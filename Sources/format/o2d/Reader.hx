package format.o2d;

import format.o2d.Data.O2dComposite;
import format.o2d.Data.O2dCompositeItem;
import format.o2d.Data.O2dImageItem;
import format.o2d.Data.O2dItem;
import format.o2d.Data.O2dLayer;
import format.o2d.Data.O2dNinepatchItem;
import format.o2d.Data.O2dProject;
import format.o2d.Data.O2dScene;
import format.o2d.Data.O2dSpriterAnimationItem;

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
		var spriterAnimations : Array<Dynamic> = Reflect.field(d, 'sSpriterAnimations');

		return {
			layers : [for (l in layers) resolveLayer(l)],
			images : [for (i in images) resolveImageItem(i)],
			ninepatches : ninepatches != null ? [for (np in ninepatches) resolveNinepatchItem(np)] : [],
			spriterAnimations : spriterAnimations != null ? [for (sa in spriterAnimations) resolveSpriterAnimationItem(sa)] : [],
			composites : composites != null ? [for (c in composites) resolveCompositeItem(c)] : [],
		}
	}

	function resolveLayer( d : Dynamic ) : O2dLayer {
		return {
			name : Reflect.field(d, 'layerName'),
			//isVisible : Reflect.field(d, 'isVisible'),
		}
	}

	function resolveBasicItem( d : Dynamic, i : O2dItem ) {
		i.uniqueId = Reflect.field(d, 'uniqueId');
		i.id = Reflect.field(d, 'itemIdentifier');
		//tags : Reflect.field(d, 'tags'), // TODO (DK) map to Array<String>
		i.x = _ofloat(d, 'x', 0.0);
		i.y = _ofloat(d, 'y', 0.0);
		i.scaleX = _ofloat(d, 'scaleX', 1.0);
		i.scaleY = _ofloat(d, 'scaleY', 1.0);
		i.zIndex = _oint(d, 'zIndex', 0);
		//originX : Reflect.field(d, 'originX'),
		//originY : Reflect.field(d, 'originY'),
		i.layerName = Reflect.field(d, 'layerName');
		//tint : null, // TODO (DK)
	}

	function resolveImageItem( d : Dynamic ) : O2dImageItem {
		var ii = new O2dImageItem();
		resolveBasicItem(d, ii);

		ii.imageName = Reflect.field(d, 'imageName');
		//ii.isRepeat
		//ii.isPolygon
		return ii;
	}

	function resolveNinepatchItem( d : Dynamic ) : O2dNinepatchItem {
		var npi = new O2dNinepatchItem();
		resolveBasicItem(d, npi);

		npi.imageName = Reflect.field(d, 'imageName');
		npi.width = _float(d, 'width');
		npi.height = _float(d, 'height');
		return npi;
	}

	function resolveCompositeItem( d : Dynamic ) : O2dCompositeItem {
		var ci = new O2dCompositeItem();
		resolveBasicItem(d, ci);

		ci.composite = resolveComposite(Reflect.field(d, 'composite'));
		//ci.scissorX : _float(d, 'scissorX', -1),
		//ci.scissorY : _float(d, 'scissorX', -1),
		//ci.scissorWidth : _float(d, 'scissorX', -1),
		//ci.scissorHeight : _float(d, 'scissorX', -1),
		ci.width = _float(d, 'width');
		ci.height = _float(d, 'height');
		return ci;
	}

	function resolveSpriterAnimationItem( d : Dynamic ) : O2dSpriterAnimationItem {
		var sai = new O2dSpriterAnimationItem();
		resolveBasicItem(d, sai);

		sai.animationName = Reflect.field(d, 'animationName');
		sai.animation = Reflect.field(d, 'animation');
		sai.entityId = _oint(d, 'entity', 0);
		return sai;
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
