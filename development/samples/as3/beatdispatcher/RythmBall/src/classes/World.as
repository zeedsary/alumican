package {
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.BasicView;
	
	/**
	 * World.as
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class World extends Sprite {
		
		private var _world:BasicView;
		
		private var _scene:Scene3D;
		private var _camera:CameraObject3D;
		
		private var _spheres:Array;
		private var _sphereCount:uint;
		
		private var _angles:Array;
		
		private var _light:PointLight3D;
		
		private var _cameraAngle:Number;
		private var _cameraAngleTarget:Number;
		private var _cameraRadius:Number;
		
		private var _canvas:BitmapData;
		private var _bmp:Bitmap;
		private var _tone:ColorTransform;
		private var _blur:BlurFilter;
		private var _zeroPoint:Point;
		
		private var _line:Shape;
		private var _lineContainer:Sprite;
		
		private var _drawFlag:Boolean;
		
		private var _main:Main;
		public function get main():Main { return _main; }
		public function set main(value:Main):void { _main = value; }
		
		
		/**
		 * コンストラクタ
		 */
		public function World():void {
			CurveModifiers.init();
			
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		/**
		 * 初期化関数
		 * @param	e
		 */
		private function _initialize(e:Event):void {
			_sphereCount = 10;
			
			//========================================
			//world
			
			_world = new BasicView(0, 0, true, false, CameraType.TARGET);
			_world.visible = false;
			addChild(_world);
			
			//========================================
			//scene
			
			_scene = _world.scene;
			
			
			//========================================
			//camera
			
			_camera = _world.camera;
			
			_cameraRadius = 1500;
			_cameraAngleTarget = _cameraAngle = 0;
			
			_camera.x = _cameraRadius * Math.cos(_cameraAngleTarget);
			_camera.z = _cameraRadius * Math.sin(_cameraAngleTarget);
			_camera.y = 500;
			
			_camera.zoom = 30 * Math.sqrt(stage.stageWidth / 550);
			
			
			//========================================
			//light
			
			_light = new PointLight3D();
			_light.z = 0;
			_light.x = 500;
			_light.y = 500;
			
			
			//========================================
			//sphere
			
			_spheres = new Array(_sphereCount);
			_angles  = new Array(_sphereCount);
			
			var material:PhongMaterial;
			var sphere:Sphere;
			var angle:Number;
			var color:Number;
			
			for (var i:uint = 0; i < _sphereCount; ++i) {
				angle = 2 * Math.PI * i / _sphereCount;
				
				color = _hsv2rgb(angle, 0.5, 0.1);
				
				material = new PhongMaterial(_light, 0xFFFFFF, color, 10);
				
				sphere = new Sphere(material, 100, 10, 10);
				sphere.x = 1000 * Math.cos(angle);
				sphere.z = 1000 * Math.sin(angle);
				
				var vertices:Array = sphere.geometry.vertices;
				for each(var v:Vertex3D in vertices) {
					v.extra = {
						x:v.x,
						y:v.y,
						z:v.z
					};
				}
				
				_scene.addChild(sphere);
				
				_spheres[i] = sphere;
				_angles[i]  = angle;
			}
			
			
			//========================================
			//render
			
			_world.startRendering();
			
			
			//========================================
			//line
			
			_lineContainer = new Sprite();
			
			_line = new Shape();
			_lineContainer.addChild(_line);
			
			
			//========================================
			//bitmap
			
			_zeroPoint = new Point(0, 0);
			
			var reduce:Number = 0.7;
			_tone = new ColorTransform(reduce, reduce, reduce);
			_blur = new BlurFilter(0, 16, 1);
			
			_canvas = new BitmapData(10, 10, false, 0x0);
			_bmp = new Bitmap(_canvas);
			addChild(_bmp);
			
			addEventListener(Event.ENTER_FRAME, _update);
			
			stage.addEventListener(Event.RESIZE, _resizeHandler);
			_resizeHandler();
		}
		
		private function _resizeHandler(e:Event = null):void {
			var sw:uint = stage.stageWidth;
			var sh:uint = stage.stageHeight;
			
			_canvas = new BitmapData(sw, sh, false, 0x0);
			_bmp.bitmapData = _canvas;
			
			_line.graphics.clear();
			_line.graphics.lineStyle(0, 0x666666);
			_line.graphics.moveTo(0, 0);
			_line.graphics.lineTo(0, stage.stageHeight);
			
			_camera.zoom = 30 * Math.sqrt(sw / 550);
		}
		
		public function kick(id:uint):void {
			var sphere:Sphere = _spheres[id] as Sphere;
			
			if (sphere) {
				
				var vertices:Array = sphere.geometry.vertices;
				
				var i:uint = 0;
				
				for each(var v:Vertex3D in vertices) {
					++i;
					
					//if (Math.random() > 0.2) continue;
					if (i % 6 != 0) continue;
					
					Tweener.addTween(v, {
						x:v.extra.x,
						y:v.extra.y,
						z:v.extra.z,
						
						_bezier:{
							x:v.x * 3,
							y:v.y * 3,
							z:v.z * 3
						},
						
						time:1,
						transition:"easeOutExpo"
					});
				}
				
				var diffAngle:Number = _angles[id] - _cameraAngleTarget;
				diffAngle += (diffAngle < 0      ) ?  2 * Math.PI :
							 (diffAngle > Math.PI) ? -2 * Math.PI :
													 0;
				
				_cameraAngleTarget += diffAngle;
			}
		}
		
		/**
		 * 毎フレーム更新
		 * @param	e
		 */
		private function _update(e:Event):void {
			
			//========================================
			//camera
			
			_cameraAngle += (_cameraAngleTarget - _cameraAngle) / 50;
			
			_camera.x = _cameraRadius * Math.cos(_cameraAngle);
			_camera.z = _cameraRadius * Math.sin(_cameraAngle);
			
			//描画は2フレームに1回
			/*
			if (!_drawFlag) {
				_drawFlag = true;
				return;
			}
			_drawFlag = false;
			*/
			
			//========================================
			//line
			
			_line.x = _main.loop.beatdispatcher.currentRatio * stage.stageWidth;
			
			
			//========================================
			//bitmap
			
			_canvas.lock();
			
			_canvas.colorTransform(_canvas.rect, _tone);
			//_canvas.scroll(0, 200);
			//_canvas.applyFilter(_canvas, _canvas.rect, _zeroPoint, _blur);
			_canvas.draw(_lineContainer);
			//_canvas.draw(_world, null, null, BlendMode.ADD);
			_canvas.draw(_world);
			
			_canvas.unlock();
		}
		
		private function _hsv2rgb(h:Number, s:Number, v:Number):uint {
			
			var p:Number = Math.PI / 3;
			
			var t:uint = uint(h / p);
			
			var fl:Number = (h / p) - t;
			
			if (t % 2 == 0) fl = 1 - fl;
			
			var m:Number = v * (1 - s);
			var n:Number = v * (1 - s * fl);
			
			var r:Number;
			var g:Number;
			var b:Number;
			
			switch(t){
				case 0: r = v; g = n; b = m; break;
				case 1: r = n; g = v; b = m; break;
				case 2: r = m; g = v; b = n; break;
				case 3: r = m; g = n; b = v; break;
				case 4: r = n; g = m; b = v; break;
				case 5: r = v; g = m; b = n; break;
			}
			
			var rr:uint = uint(r * 255);
			var gg:uint = uint(g * 255);
			var bb:uint = uint(b * 255);
			
			return ((rr << 16) | (gg << 8) | bb);
		}
	}
}