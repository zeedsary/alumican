/*======================================================================*//**
 * 
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2008 taka:nium
 * @version 3.1.52
 * @see http://classes.nium.jp/
 * 
 * Developed by taka:nium
 * @see http://nium.jp/
 * 
 * Progression is (C) 2007-2008 taka:nium and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 */
package jp.nium.core.display {
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	/*======================================================================*//**
	 * <p>IDisplayObject インターフェイスは、基本的な表示オブジェクトに必要な機能を実装します。</p>
	 * <p>The IDisplayObject interface implements the basic function which display objects needs.</p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.45.0
	 * 
	 * @example <listing version="3.0" >
	 * </listing>
	 */
	public interface IDisplayObject extends IEventDispatcher {
		
		/*======================================================================*//**
		 * <p>この表示オブジェクトの現在のアクセシビリティオプションです。</p>
		 * <p>The current accessibility options for this display object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get accessibilityProperties():AccessibilityProperties;
		function set accessibilityProperties( value:AccessibilityProperties ):void;
		
		/*======================================================================*//**
		 * <p>指定されたオブジェクトのアルファ透明度値を示します。</p>
		 * <p>Indicates the alpha transparency value of the object specified.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get alpha():Number;
		function set alpha( value:Number ):void;
		
		/*======================================================================*//**
		 * <p>使用するブレンドモードを指定する BlendMode クラスの値です。</p>
		 * <p>A value from the BlendMode class that specifies which blend mode to use.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get blendMode():String;
		function set blendMode( value:String ):void;
		
		/*======================================================================*//**
		 * <p>true に設定されている場合、表示オブジェクトの内部ビットマップ表現が Flash Player にキャッシュされます。</p>
		 * <p>If set to true, Flash Player or Adobe AIR caches an internal bitmap representation of the display object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get cacheAsBitmap():Boolean;
		function set cacheAsBitmap( value:Boolean ):void;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトに現在関連付けられている各フィルタオブジェクトが保存されているインデックス付きの配列です。</p>
		 * <p>An indexed array that contains each filter object currently associated with the display object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get filters():Array;
		function set filters( value:Array ):void;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトの高さを示します (ピクセル単位)。</p>
		 * <p>Indicates the height of the display object, in pixels.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get height():Number;
		function set height( value:Number ):void;
		
		/*======================================================================*//**
		 * <p>この表示オブジェクトが属するファイルのロード情報を含む LoaderInfo オブジェクトを返します。</p>
		 * <p>Returns a LoaderInfo object containing information about loading the file to which this display object belongs.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get loaderInfo():LoaderInfo;
		
		/*======================================================================*//**
		 * <p>呼び出し元の表示オブジェクトは、指定された mask オブジェクトによってマスクされます。</p>
		 * <p>The calling display object is masked by the specified mask object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get mask():DisplayObject;
		function set mask( value:DisplayObject ):void;
		
		/*======================================================================*//**
		 * <p>マウス位置の x 座標を示します (ピクセル単位)。</p>
		 * <p>Indicates the x coordinate of the mouse position, in pixels.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get mouseX():Number;
		
		/*======================================================================*//**
		 * <p>マウス位置の y 座標を示します (ピクセル単位)。</p>
		 * <p>Indicates the y coordinate of the mouse position, in pixels.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get mouseY():Number;
		
		/*======================================================================*//**
		 * <p>DisplayObject のインスタンス名を示します。</p>
		 * <p>Indicates the instance name of the DisplayObject.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get name():String;
		function set name( value:String ):void;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトが特定の背景色で不透明であるかどうかを指定します。</p>
		 * <p>Specifies whether the display object is opaque with a certain background color.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get opaqueBackground():Object;
		function set opaqueBackground( value:Object ):void;
		
		/*======================================================================*//**
		 * <p>この表示オブジェクトを含む DisplayObjectContainer オブジェクトを示します。</p>
		 * <p>Indicates the DisplayObjectContainer object that contains this display object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get parent():DisplayObjectContainer;
		
		/*======================================================================*//**
		 * <p>ロードされた SWF ファイル内の表示オブジェクトの場合、root プロパティはその SWF ファイルが表す表示リストのツリー構造部分の一番上にある表示オブジェクトとなります。</p>
		 * <p>For a display object in a loaded SWF file, the root property is the top-most display object in the portion of the display list's tree structure represented by that SWF file.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get root():DisplayObject;
		
		/*======================================================================*//**
		 * <p>DisplayObject インスタンスの元の位置からの回転角を度単位で示します。</p>
		 * <p>Indicates the rotation of the DisplayObject instance, in degrees, from its original orientation.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get rotation():Number;
		function set rotation( value:Number ):void;
		
		/*======================================================================*//**
		 * <p>現在有効な拡大 / 縮小グリッドです。</p>
		 * <p>The current scaling grid that is in effect.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get scale9Grid():Rectangle;
		function set scale9Grid( value:Rectangle ):void;
		
		/*======================================================================*//**
		 * <p>基準点から適用されるオブジェクトの水平スケール (percentage) を示します。</p>
		 * <p>Indicates the horizontal scale (percentage) of the object as applied from the registration point.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get scaleX():Number;
		function set scaleX( value:Number ):void;
		
		/*======================================================================*//**
		 * <p>オブジェクトの基準点から適用されるオブジェクトの垂直スケール (percentage) を示します。</p>
		 * <p>Indicates the vertical scale (percentage) of an object as applied from the registration point of the object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get scaleY():Number;
		function set scaleY( value:Number ):void;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトのスクロール矩形の境界です。</p>
		 * <p>The scroll rectangle bounds of the display object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get scrollRect():Rectangle;
		function set scrollRect( value:Rectangle ):void;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトのステージです。</p>
		 * <p>The Stage of the display object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get stage():Stage;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトのマトリックス、カラー変換、ピクセル境界に関係するプロパティを持つオブジェクトです。</p>
		 * <p>An object with properties pertaining to a display object's matrix, color transform, and pixel bounds.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get transform():Transform;
		function set transform( value:Transform ):void;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトが可視かどうかを示します。</p>
		 * <p>Whether or not the display object is visible.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get visible():Boolean;
		function set visible( value:Boolean ):void;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトの幅を示します (ピクセル単位)。</p>
		 * <p>Indicates the width of the display object, in pixels.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get width():Number;
		function set width( value:Number ):void;
		
		/*======================================================================*//**
		 * <p>親 DisplayObjectContainer のローカル座標を基準にした DisplayObject インスタンスの x 座標を示します。</p>
		 * <p>Indicates the x coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get x():Number;
		function set x( value:Number ):void;
		
		/*======================================================================*//**
		 * <p>親 DisplayObjectContainer のローカル座標を基準にした DisplayObject インスタンスの y 座標を示します。</p>
		 * <p>Indicates the y coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 */
		function get y():Number;
		function set y( value:Number ):void;
		
		
		
		
		
		/*======================================================================*//**
		 * <p>targetCoordinateSpace オブジェクトの座標系を基準にして、表示オブジェクトの領域を定義する矩形を返します。</p>
		 * <p>Returns a rectangle that defines the area of the display object relative to the coordinate system of the targetCoordinateSpace object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 * 
		 * @param targetCoordinateSpace
		 * 	<p>使用する座標系を定義する表示オブジェクトです。</p>
		 * 	<p>The display object that defines the coordinate system to use.</p>
		 * @return
		 * 	<p>targetCoordinateSpace オブジェクトの座標系を基準とする、表示オブジェクトの領域を定義する矩形です。</p>
		 * 	<p>The rectangle that defines the area of the display object relative to the targetCoordinateSpace object's coordinate system.</p>
		 */
		function getBounds( targetCoordinateSpace:DisplayObject ):Rectangle;
		
		/*======================================================================*//**
		 * <p>シェイプ上の線を除き、targetCoordinateSpace パラメータによって定義された座標系に基づいて、表示オブジェクトの境界を定義する矩形を返します。</p>
		 * <p>Returns a rectangle that defines the boundary of the display object, based on the coordinate system defined by the targetCoordinateSpace parameter, excluding any strokes on shapes.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 * 
		 * @param targetCoordinateSpace
		 * 	<p>使用する座標系を定義する表示オブジェクトです。</p>
		 * 	<p>The display object that defines the coordinate system to use.</p>
		 * @return
		 * 	<p>targetCoordinateSpace オブジェクトの座標系を基準とする、表示オブジェクトの領域を定義する矩形です。</p>
		 * 	<p>The rectangle that defines the area of the display object relative to the targetCoordinateSpace object's coordinate system.</p>
		 */
		function getRect( targetCoordinateSpace:DisplayObject ):Rectangle;
		
		/*======================================================================*//**
		 * <p>point オブジェクトをステージ (グローバル) 座標から表示オブジェクトの (ローカル) 座標に変換します。</p>
		 * <p>Converts the point object from the Stage (global) coordinates to the display object's (local) coordinates.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 * 
		 * @param point
		 * 	<p>Point クラスを使って作成されるオブジェクトです。Point オブジェクトは、x および y 座標をプロパティとして指定します。</p>
		 * 	<p>An object created with the Point class. The Point object specifies the x and y coordinates as properties.</p>
		 * @return
		 * 	<p>表示オブジェクトからの相対座標を持つ Point オブジェクトです。</p>
		 * 	<p>A Point object with coordinates relative to the display object.</p>
		 */
		function globalToLocal( point:Point ):Point;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトを評価して、obj 表示オブジェクトと重複または交差するかどうかを調べます。</p>
		 * <p>Evaluates the display object to see if it overlaps or intersects with the obj display object.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 * 
		 * @param obj
		 * 	<p>検査の対象となる表示オブジェクトです。</p>
		 * 	<p>The display object to test against.</p>
		 * @return
		 * 	<p>表示オブジェクトが交差する場合は true、そうでない場合は false です。</p>
		 * 	<p>true if the display objects intersect; false if not.</p>
		 */
		function hitTestObject( obj:DisplayObject ):Boolean;
		
		/*======================================================================*//**
		 * <p>表示オブジェクトを評価して、x および y パラメータで指定されたポイントと重複または交差するかどうかを調べます。</p>
		 * <p> Evaluates the display object to see if it overlaps or intersects with the point specified by the x and y parameters.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 * 
		 * @param x
		 * 	<p>このオブジェクトの検査の基準となる x 座標です。</p>
		 * 	<p>The x coordinate to test against this object.</p>
		 * @param y
		 * 	<p>このオブジェクトの検査の基準となる y 座標です。</p>
		 * 	<p>The y coordinate to test against this object.</p>
		 * @param shapeFlag
		 * 	<p>オブジェクトの実際のピクセルと比較して検査する場合は true、境界ボックスと比較して検査する場合は false です。</p>
		 * 	<p>Whether to check against the actual pixels of the object (true) or the bounding box (false).</p>
		 * @return
		 * 	<p>指定されたポイントと表示オブジェクトが重複または交差する場合は true、そうでなければ false です。</p>
		 * 	<p>true if the display object overlaps or intersects with the specified point; false otherwise.</p>
		 */
		function hitTestPoint( x:Number, y:Number, shapeFlag:Boolean = false ):Boolean;
		
		/*======================================================================*//**
		 * <p>point オブジェクトを表示オブジェクトの (ローカル) 座標からステージ (グローバル) 座標に変換します。</p>
		 * <p>Converts the point object from the display object's (local) coordinates to the Stage (global) coordinates.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 * 
		 * @param point
		 * 	<p>Point クラスを使用し、x および y 座標をプロパティとして指定して作成されるポイントの名前または識別子です。</p>
		 * 	<p>The name or identifier of a point created with the Point class, specifying the x and y coordinates as properties.</p>
		 * @return
		 * 	<p>ステージからの相対座標を持つ Point オブジェクトです。</p>
		 * 	<p>A Point object with coordinates relative to the Stage.</p>
		 */
		function localToGlobal( point:Point ):Point;
	}
}
