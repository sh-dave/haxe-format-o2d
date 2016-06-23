package format.o2d;

// http://overlap2d.com/data-api-creating-custom-runtime/

class O2dItem {
	public var uniqueId : Int;
	public var id : String;
	//public var tags : Array<String>;
	//public var customVars : String;

	public var x : Float;
	public var y : Float;
	public var scaleX : Float;
	public var scaleY : Float;
	//public var rotation : Float; // deg

	//public var shader : String;
	public var zIndex : Int;
	//public var originX : Float;
	//public var originY : Float;
	public var layerName : String;

	public function new() {
	}
}

class O2dImageItem extends O2dItem {
	public var imageName : String;
}

class O2dNinepatchItem extends O2dItem {
	public var imageName : String;
	public var width : Float;
	public var height : Float;
}

class O2dCompositeItem extends O2dItem {
	public var composite : O2dComposite;
	public var itemName : String; // TODO (DK) bug? not listed in the docs
	//scissorX : Float,
	//scissorY : Float,
	//scissorWidth : Float,
	//scissorHeight : Float,
	public var width : Float;
	public var height : Float;
}

class O2dSpriterAnimationItem extends O2dItem {
	public var animationName : String;
	public var entityId : Int;
	public var animation : String;
}

//@:structInit
//class O2dLabel extends O2dItem {
		//// text
		//// style
		//// size
		//// align
		//// width, height
		//// multiline
//}

//@:structInit
//class O2dParticle extends O2dItem {
	//// particleConfig : String
//}

//@:structInit
//class O2dLight extends O2dItem {
//}

@:structInit
class O2dLayer {
	public var name : String;
	//public var isVisible : Bool;
	//public var isLocked : Bool;
}

@:structInit
class O2dScenePhysics {
	public var isEnabled : Bool;
	public var gravityX : Float;
	public var gravityY : Float;
}

@:structInit
class O2dComposite {
	public var layers : Array<O2dLayer>;

	public var images : Array<O2dImageItem>;
	public var ninepatches : Array<O2dNinepatchItem>;
	public var spriterAnimations : Array<O2dSpriterAnimationItem>;

	public var composites : Array<O2dCompositeItem>;
}

@:structInit
class O2dScene {
	public var name : String;
	public var composite : O2dComposite;

	//public var physicsProperties : O2dScenePhysics;

	//horizontalGuides : Array<Float>,
	//verticalGuides : Array<Float>,
}

//@:structInit
//class O2dResolution {
	//public var name : String;
	//public var width : Int;
	//public var height : Int;
//}

@:structInit
class O2dProject {
	public var pixelToWorld : Int;
	//public var originalResolution : O2dResolution;
	public var scenes : Array<O2dScene>;
	//public var libraryItems : Array<O2dCompositeItem>;
}
