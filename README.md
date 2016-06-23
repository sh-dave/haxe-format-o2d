# haxe-format-o2d

very basic, framework independent parser for overlap2d files

## progress
- [x] atlas parser - usable, wip
- [x] images - usable, wip
- [x] ninepatches - usable, wip
- [x] composite - usable, wip
- [ ] particles
- [ ] sprite animations
- [ ] spriter animations
- [ ] spine animations
- [ ] labels
- [ ] light
- [ ] scene physics
- [ ] resolutions

## usage

```haxe
	// load project
	var projectData : String = ... load you project file here ...;
	var project = new format.o2d.Reader(projectData).read();

	// load scenes into projectData
	for (scene in projectData.scenes) {
		var sceneData : String = ... load 'scenes/${scene.name}.dt' here ...
		new format.o2d.Reader(sceneString).readScene(scene);
	}

	// load sprite atlas
	var atlasData = ... load whatever atlas file you need ...
	var atlas = new format.o2d.AtlasReader(atlasData).read();

```
