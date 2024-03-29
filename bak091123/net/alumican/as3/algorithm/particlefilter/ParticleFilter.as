﻿package particlefilter
{
	import fl.motion.Color;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	/**
	 * ParticleFilter
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class ParticleFilter extends Sprite
	{
		
		/*==========================================================================//**
		 * リサンプリング関数
		 */
		public function get resample():Function { return __resample || _resample; }
		public function set resample(value:Function):void { __resample = value; }
		/**
		 * リサンプリング関数(オーバーライドされる)
		 * @param	particles
		 */
		protected function _resample(particles:Array):void
		{
			var n:uint = _particleCount;
			var tmp:Array = new Array(n);
			
			//累積重みの計算
			_weights[0] = ImageParticle(_particles[0]).weight;
			for (var i:uint = 1; i < n; ++i)
			{
				_weights[i] = _weights[i - 1] + ImageParticle(particles[i]).weight;
				
				tmp[i] = { x:particles[i].x, y:particles[i].y };
			}
			
			//重みを基準にパーティクルをリサンプリングして重みを1.0に
			var w:Number;
			var j:uint;
			for (var i:uint = 0; i < n; ++i)
			{
				w = Math.random() * _weights[n - 1];
				j = 0;
				while (_weights[++j] < w);
				_particles[i].x      = tmp[j].x;
				_particles[i].y      = tmp[j].y;
				_particles[i].weight = 1;
			}
		}
		private var __resample:Function;
		
		
		
		
		
		/*==========================================================================//**
		 * 予測関数
		 */
		public function get predict():Function { return __predict || _predict; }
		public function set predict(value:Function):void { __predict = value; }
		/**
		 * 予測関数(オーバーライドされる)
		 * @param	particles
		 */
		protected function _predict(particles:Array):void
		{
			var n:uint = _particleCount;
			
			//位置の予測
			var variance:Number = 13.0;
			var vx:Number;
			var vy:Number;
			var p:ImageParticle;
			for (var i:uint = 0; i < n; ++i)
			{
				p = particles[i] as ImageParticle;
				
				vx = variance * Math.sqrt(-2 * Math.log(Math.random())) * Math.sin(2 * Math.PI * Math.random());
				vy = variance * Math.sqrt(-2 * Math.log(Math.random())) * Math.sin(2 * Math.PI * Math.random());
				
				p.x += vx;
				p.y += vy;
				
				p.x = (p.x < 0) ? 0 : (p.x >= _videoWidth ) ? (_videoWidth  - 1) : p.x;
				p.y = (p.y < 0) ? 0 : (p.y >= _videoHeight) ? (_videoHeight - 1) : p.y;
			}
		}
		private var __predict:Function;
		
		
		
		
		
		/*==========================================================================//**
		 * 尤度計算関数
		 */
		public function get likelihood():Function { return __likelihood || _likelihood; }
		public function set likelihood(value:Function):void { __likelihood = value; }
		/**
		 * 尤度計算関数(オーバーライドされる)
		 * @param	particle
		 */
		protected function _likelihood(x:uint, y:uint):Number 
		{
			var w:uint = 30;
			var h:uint = 30;
			
			var count:uint = 0;
			
			var m:int = y + h / 2;
			var n:int;
			for(var j:uint = y - h / 2; j < m; ++j)
			{
				n = x + w / 2;
				for(var i:uint = x - w / 2 ; i < n; ++i)
				{               
					if(_isInImage(i, j) && _isYellow(i, j))
					{
						++count;
					}
				}
			}
			
			if (count == 0)
			{
				return 0.0001;
			}
			else {
				
				return count / (w * h);
			}
		}
		private var __likelihood:Function;
		
		
		
		
		
		private function _isInImage(x:uint, y:uint):Boolean 
		{
			return (x >= 0 && y >= 0 && x < _videoWidth && y < _videoHeight);
		}
		
		private function _isYellow(x:uint, y:uint):Boolean 
		{
			var c:uint = _bmd.getPixel(x, y);
			
			var r:uint = c >> 16 & 0xff;
			var g:uint = c >> 8  & 0xff;
			var b:uint = c       & 0xff;
			
			/*
			if (r > 200 && g > 200 && b < 150)
			{
				_bmd.setPixel(x, y, 0x0000ff);
			}
			*/
			
			return (r > 200 && g > 200 && b < 150);
			//return (r > 50 && g > 50 && b < 200);
		}
		
		
		
		
		
		/*==========================================================================//**
		 * 重み付け関数
		 */
		public function get weighting():Function { return __weighting || _weighting; }
		public function set weighting(value:Function):void { __weighting = value; }
		/**
		 * 重み付け関数(オーバーライドされる)
		 * @param	particles
		 */
		protected function _weighting(particles:Array):void 
		{
			var n:uint = _particleCount;
			
			var sum:Number = 0;
			var p:ImageParticle;
			
			//尤度に従いパーティクルの重みを決定する
			for (var i:uint = 0; i < n; ++i)
			{
				p = _particles[i] as ImageParticle;
				p.weight = _likelihood(p.x, p.y);
				
				sum += p.weight;
			}
			
			//重みの正規化
			for (var i:uint = 0; i < n; ++i)
			{
				p = _particles[i] as ImageParticle;
				p.weight = n * p.weight / sum;
			}
		}
		private var __weighting:Function;
		
		
		
		
		
		/*==========================================================================//**
		 * 観測関数
		 */
		public function get measure():Function { return __measure || _measure; }
		public function set measure(value:Function):void { __measure = value; }
		/**
		 * 観測関数(オーバーライドされる)
		 * @param	particles
		 */
		protected function _measure(particles:Array):void 
		{
			var n:uint = _particleCount;
			
			var x:Number = 0;
			var y:Number = 0;
			var w:Number = 0;
			
			var p:ImageParticle;
			
			//重み和
			for (var i:uint = 0; i < n; ++i)
			{
				p = ImageParticle(_particles[i]);
				x += p.x * p.weight;
				y += p.y * p.weight;
				w += p.weight;
			}
			
			//正規化
			_result = new ImageParticle(x / w, y / w, 1);
			//return new ImageParticle(x / w, y / w, 1);
		}
		private var __measure:Function;
		
		
		
		
		
		/*==========================================================================//**
		 * 初期化関数
		 */
		public function get initialize():Function { return __initialize || _initialize; }
		public function set initialize(value:Function):void { __initialize = value; }
		/**
		 * 観測関数(オーバーライドされる)
		 * @param	particles
		 */
		protected function _initialize():void {
			//パーティクルの初期値を決定する
			var maxW:Number = 0;
			var maxX:uint;
			var maxY:uint;
			
			//最も尤度の高いピクセルを探索
			for (var j:uint = 0; j < _videoHeight; j += 5)
			{
				for (var i:uint = 0; i < _videoWidth; i += 5)
				{
					
					var w:Number = _likelihood(i, j);
					
					if (w > maxW)
					{
						maxW = w;
						maxX = i;
						maxY = j;
					}
				}
			}
			
			//すべてのパーティクルの値を最尤値で設定する
			var n:uint = _particleCount;
			_particles = new Array(n);
			for (var i:uint = 0; i < n; ++i)
			{
				_particles[i] = new ImageParticle(maxX, maxY, maxW);
			}
		}
		private var __initialize:Function;
		
		
		
		
		
		/*==========================================================================//**
		 * パーティクルの数
		 */
		public function get particleCount():uint { return _particleCount; }
		private var _particleCount:uint;
		
		
		
		
		
		/*==========================================================================//**
		 * パーティクル配列
		 */
		public function get particles():Array { return _particles; }
		private var _particles:Array;
		
		
		
		
		
		/*==========================================================================//**
		 * コンストラクタ
		 * @param	particles
		 */
		public function ParticleFilter(particleCount:uint = 100):void 
		{
			_particleCount = particleCount;
			
			//累積重み
			_weights = new Array(_particleCount);
			
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		private function _addedToStageHandler(e:Event):void 
		{
			_bmd = new BitmapData(_videoWidth, _videoHeight, false, 0x0);
			_bmp = new Bitmap(_bmd);
			_bmp.scaleX = -2;
			_bmp.scaleY = 2;
			_bmp.x = _videoWidth * 2;
			addChild(_bmp);
			
			_shape = new Shape();
			_shape.graphics.lineStyle(3, 0x00ff00);
			_shape.graphics.moveTo(0 , 0 );
			_shape.graphics.lineTo(100, 0 );
			_shape.graphics.lineTo(100, 100);
			_shape.graphics.lineTo(0 , 100);
			_shape.graphics.lineTo(0 , 0 );
			
			//load webcam
			_camera = Camera.getCamera();
			if (_camera) {
				_video = new Video(_videoWidth, _videoHeight);
				_video.attachCamera(_camera);
				
				_camera.addEventListener(ActivityEvent.ACTIVITY, _activityHandler);
			}
		}
		
		private function _activityHandler(e:ActivityEvent):void {
			
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void
			{
				addChild(_shape);
				
				_startFilter();
			});
			timer.start();
		}
		
		private function _startFilter():void
		{
			_bmd.lock();
			_bmd.draw(_video);
			
			_initialize();
			
			_bmd.unlock();
			
			addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
		}
		
		private function _enterFrameHandler(e:Event):void 
		{
			_bmd.lock();
			_bmd.draw(_video);
			
			_resample(_particles);
			_predict(_particles);
			_weighting(_particles);
			_measure(_particles);
			
			var n:uint = _particleCount;
			var p:ImageParticle;
			for (var i:uint = 0; i < n; ++i)
			{
				p = ImageParticle(_particles[i]);
				_bmd.setPixel(p.x, p.y, 0xff9900);
			}
			
			_bmd.unlock();
			
			_shape.x = _bmp.width  - _result.x * 2 - 50;
			_shape.y = _result.y * 2 - 50;
		}
		
		//累積重み
		private var _weights:Array;
		
		//結果
		private var _result:ImageParticle;
		
		//ソース
		private var _video:Video;
		private var _camera:Camera;
		private var _videoWidth:uint  = 320;
		private var _videoHeight:uint = 240;
		private var _bmd:BitmapData;
		private var _bmp:Bitmap
		private var _shape:Shape;
	}
}