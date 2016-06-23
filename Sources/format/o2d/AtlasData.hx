package format.o2d;

//enum O2dTextureFilter {
	//Linear;
//}

//enum O2dAtlasFormat {
	//RGBA8888;
//}

//enum O2dAtlasRepeat {
	//ClampToEdge;
	//Repeat;
//}

@:structInit
class O2dImagePack {
	public var imageFilename : String;
	//width : Int,
	//height : Int,
	//format : O2dAtlasFormat,
	//filterMin : O2dTextureFilter,
	//filterMax : O2dTextureFilter,
	//repeatU : O2dAtlasRepeat,
	//repeatV : O2dAtlasRepeat,
}

typedef O2dAtlasRegion = {
	id : String,

	imagePack : O2dImagePack, // (DK) convenience

	rotate : Bool,
	x : Int,
	y : Int,
	width : Int,
	height : Int,

	// TODO (DK) @:optional?
	splitL : Int,
	splitR : Int,
	splitT : Int,
	splitB : Int,

	// TODO (DK) @:optional?
	splitPaddingL : Int,
	splitPaddingR : Int,
	splitPaddingT : Int,
	splitPaddingB : Int,
	// TODO (DK) /@:optional?
	// TODO (DK) /@:optional?


	origW : Int,
	origH : Int,
	offsetX : Int,
	offsetY : Int,
	index : Int,
}

@:structInit
class O2dAtlasData {
	public var imagePacks : Array<O2dImagePack>;
	public var regions : Array<O2dAtlasRegion>;
}
