package format.o2d;

import format.o2d.Data.O2dComposite;
import format.o2d.Data.O2dCompositeItem;
import format.o2d.Data.O2dImageItem;
import format.o2d.Data.O2dLayer;
import format.o2d.Data.O2dNinepatchItem;
import format.o2d.Data.O2dProject;
import format.o2d.Data.O2dScene;

class Reader {
	var json : String;
	var data : Dynamic;

	public function new( json : String ) {
		this.json = json;
		data = haxe.Json.parse(json);
	}

	public function read() : O2dProject {
		var scenes : Array<Dynamic> = Reflect.field(data, 'scenes');

		return {
			pixelToWorld : Reflect.field(data, 'pixelToWorld'),
			//originalResolution : null, // TODO (DK)
			scenes : [for (scene in scenes) {
				name : scene.sceneName,
				//physicsProperties : null,
				composite : null,
			}],
			//libraryItems : null,
		}
	}

	public inline function readScene( root : O2dScene ) : O2dScene {
		return resolveScene(root);
	}

	function resolveScene( root : O2dScene ) : O2dScene {
		if (root != null) {
			var sceneName = Reflect.field(data, 'sceneName');

			if (root.name != sceneName) {
				throw 'resolving to wrong scene';
			}

			root.composite = resolveComposite(Reflect.field(data, 'composite'));

			// TODO (DK) physics properties
			return root;
		}

		return {
			name : Reflect.field(data, 'sceneName'),
			composite : resolveComposite(Reflect.field(data, 'composite')),
			//physicsProperties : null, // TODO (DK) physicsPropertiesVO
		}
	}

	function resolveComposite( d : Dynamic ) : O2dComposite {
		var layers : Array<Dynamic> = Reflect.field(d, 'layers');
		var images : Array<Dynamic> = Reflect.field(d, 'sImages');
		var ninepatches : Array<Dynamic> = Reflect.field(d, 'sImage9patchs');
		var composites : Array<Dynamic> = Reflect.field(d, 'sComposites');

		return {
			layers : [for (l in layers) resolveLayer(l)],
			images : [for (i in images) resolveImageItem(i)],
			ninepatches : ninepatches != null ? [for (np in ninepatches) resolveNinepatchItem(np)] : [],
			composites : composites != null ? [for (c in composites) resolveCompositeItem(c)] : [],
		}
	}

	function resolveLayer( d : Dynamic ) : O2dLayer {
		return {
			name : Reflect.field(d, 'layerName'),
			//isVisible : Reflect.field(d, 'isVisible'),
		}
	}

	function resolveImageItem( d : Dynamic ) : O2dImageItem {
		return {
			uniqueId : Reflect.field(d, 'uniqueId'),
			id : Reflect.field(d, 'itemIdentifier'),
			//tags : Reflect.field(d, 'tags'), // TODO (DK) map to Array<String>
			x : _ofloat(d, 'x', 0.0),
			y : _ofloat(d, 'y', 0.0),
			scaleX : _ofloat(d, 'scaleX', 1.0),
			scaleY : _ofloat(d, 'scaleY', 1.0),
			zIndex : _oint(d, 'zIndex', 0),
			//originX : Reflect.field(d, 'originX'),
			//originY : Reflect.field(d, 'originY'),
			layerName : Reflect.field(d, 'layerName'),

			imageName : Reflect.field(d, 'imageName'),

			//tint : null, // TODO (DK)
		}
	}

	function resolveNinepatchItem( d : Dynamic ) : O2dNinepatchItem {
		return {
			uniqueId : Reflect.field(d, 'uniqueId'),
			id : Reflect.field(d, 'itemIdentifier'),
			x : _float(d, 'x'),
			y : _float(d, 'y'),
			scaleX : _ofloat(d, 'scaleX', 1.0),
			scaleY : _ofloat(d, 'scaleY', 1.0),
			zIndex : _oint(d, 'zIndex', 0),
			layerName : Reflect.field(d, 'layerName'),

			imageName : Reflect.field(d, 'imageName'),
			width : _float(d, 'width'),
			height : _float(d, 'height'),
		}
	}

	function resolveCompositeItem( d : Dynamic ) : O2dCompositeItem {
		return {
			uniqueId : Reflect.field(d, 'uniqueId'),
			id : Reflect.field(d, 'itemIdentifier'),
			itemName : Reflect.field(d, 'itemName'),
			x : _float(d, 'x'),
			y : _float(d, 'y'),
			scaleX : _ofloat(d, 'scaleX', 1.0),
			scaleY : _ofloat(d, 'scaleY', 1.0),
			zIndex : _oint(d, 'zIndex', 0),
			layerName : Reflect.field(d, 'layerName'),

			composite : resolveComposite(Reflect.field(d, 'composite')),
			//scissorX : _float(d, 'scissorX', -1),
			//scissorY : _float(d, 'scissorX', -1),
			//scissorWidth : _float(d, 'scissorX', -1),
			//scissorHeight : _float(d, 'scissorX', -1),
			width : _float(d, 'width'),
			height : _float(d, 'height'),
		}
	}

	inline function _float( d : Dynamic, id : String ) : Float {
		var f = Reflect.field(d, id);

		if (f == null) {
			throw 'field ${id} does not exist';
		}

		return Std.parseFloat(f);
	}

	inline function _ofloat( d : Dynamic, id : String, defaultValue : Float ) : Float {
		var v = Reflect.field(d, id);

		return v != null
			? Std.parseFloat(v)
			: defaultValue;
	}

	inline function _oint( d : Dynamic, id : String, defaultValue : Int ) : Int {
		var v = Reflect.field(d, id);

		return v != null
			? Std.parseInt(v)
			: defaultValue;
	}
}
