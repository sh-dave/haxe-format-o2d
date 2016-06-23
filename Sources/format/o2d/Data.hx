package format.o2d;

// http://overlap2d.com/data-api-creating-custom-runtime/

typedef O2dItem = {
	uniqueId : Int,
	id : String,
	//public var tags : Array<String>;
	//public var customVars : String;

	x : Float,
	y : Float,
	scaleX : Float,
	scaleY : Float,
	//public var rotation : Float; // deg

	//public var shader : String;
	zIndex : Int,
	//public var originX : Float;
	//public var originY : Float;
	layerName : String,
}

typedef O2dImageItem = {
	> O2dItem,

	imageName : String,
}

typedef O2dNinepatchItem = {
	> O2dItem,

	imageName : String,
	width : Float,
	height : Float,
}

typedef O2dCompositeItem = {
	> O2dItem,

	composite : O2dComposite,
	itemName : String, // TODO (DK) bug? not listed in the docs
	//scissorX : Float,
	//scissorY : Float,
	//scissorWidth : Float,
	//scissorHeight : Float,
	width : Float,
	height : Float,
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
	public var composites : Array<O2dCompositeItem>;

	//spriterAnimations : Array<O2dSpriterAnimation>,
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
