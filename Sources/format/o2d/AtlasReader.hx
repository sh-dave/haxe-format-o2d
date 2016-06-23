package format.o2d;

class AtlasReader {
	var data : String;

	var lines : Array<String>;
	var lineIndex : Int;

	public function new( data : String ) {
		this.data = data;
	}

	public function read() : AtlasData.O2dAtlasData {
		lines = data.split('\n');
		lineIndex = -1;

		// (DK) remove trailing newlines
		while (lines.length > 0) {
			var l = lines[lines.length - 1];

			if (StringTools.trim(l) == '') {
				lines.pop();
			} else {
				break;
			}
		}

		var regions : Array<AtlasData.O2dAtlasRegion> = [];
		var imagePacks : Array<AtlasData.O2dImagePack> = [];
		var imagePack : AtlasData.O2dImagePack;

		while (++lineIndex < lines.length) {
			var empty = lines[lineIndex];
			var imageFile = StringTools.trim(nextline());
			var size = readTuple('size', 2).map(Std.parseInt);
			var format = readTuple('format', 1);
			var filter = readTuple('filter', 2);
			var repeat = readTuple('repeat', 1);

			imagePack = {
				imageFilename : imageFile
			}

			imagePacks.push(imagePack);

			while (++lineIndex < lines.length) {
				if (StringTools.trim(lines[lineIndex]).length == 0) {
					--lineIndex;
					break;
				}

				var name = StringTools.trim(lines[lineIndex]);
				var rotate = readTuple('rotate', 1);
				var xy = readTuple('xy', 2).map(Std.parseInt);
				var size = readTuple('size', 2).map(Std.parseInt);
				var split = readOptionalTuple('split', 4).map(Std.parseInt);
				var splitPadding = readOptionalTuple('pad', 4).map(Std.parseInt);
				var orig = readTuple('orig', 2).map(Std.parseInt);
				var offset = readTuple('offset', 2).map(Std.parseInt);
				var index = readTuple('index', 1).map(Std.parseInt);

				regions.push({
					id : name,
					imagePack : imagePack,
					rotate : rotate[0] == 'true',
					x : xy[0],
					y : xy[1],
					width : size[0],
					height : size[1],
					splitL : split.length == 4 ? split[0] : -1,
					splitR : split.length == 4 ? split[1] : -1,
					splitT : split.length == 4 ? split[2] : -1,
					splitB : split.length == 4 ? split[3] : -1,
					splitPaddingL : splitPadding.length == 4 ? splitPadding[0] : -1,
					splitPaddingR : splitPadding.length == 4 ? splitPadding[1] : -1,
					splitPaddingT : splitPadding.length == 4 ? splitPadding[2] : -1,
					splitPaddingB : splitPadding.length == 4 ? splitPadding[3] : -1,
					origW : orig[0],
					origH : orig[1],
					offsetX : offset[0],
					offsetY : offset[1],
					index : index[0],
				});
			}
		}

		return {
			imagePacks : imagePacks,
			regions : regions,
			//width : size[0],
			//height : size[1],
			//format : null,
			//filterMin : null,
			//filterMax : null,
			//repeatU : null,
			//repeatV : null,
		}
	}

	function nextline() : String {
		if (++lineIndex < lines.length) {
			return lines[lineIndex];
		}

		throw 'out of bounds';
	}

	function readTuple( id : String, length : Int ) : Array<String> {
		var line = nextline();
		var splitNV = line.split(':').map(StringTools.trim);

		if (splitNV.length != 2) {
			throw '"${line}" is not a valid tuple line';
		}

		var splitValues = splitNV[1].split(',').map(StringTools.trim);

		if (splitValues.length != length) {
			throw '"${splitValues}" has invalid length (expected ${length})';
		}

		return splitValues;
	}

	function readOptionalTuple( id : String, length : Int ) : Array<String> {
		var line = nextline();
		var splitNV = line.split(':').map(StringTools.trim);

		if (splitNV.length != 2) {
			throw '"${line}" is not a valid tuple line';
		}

		if (splitNV[0] != id) {
			--lineIndex;
			return [];
		}

		var splitValues = splitNV[1].split(',').map(StringTools.trim);

		if (splitValues.length != length) {
			throw '"${splitValues}" has invalid length (expected ${length})';
		}

		return splitValues;
	}

}
