import mx.utils.Delegate;

class Initializer {
	
	//mc.init(a, b, c); -> Initializer.resist(mc, "init", [a, b, c]);
	static function register(target:MovieClip, func:String, args:Array, callback:Function):Void {
		
		var f:Function = target[func];
		
		if(f == undefined) {
			target.onLoad = Delegate.create(this, function():Void {
				callback( f.apply(target, args) );
			});
			
		} else {
			callback( f.apply(target, args) );
		}
	}
}