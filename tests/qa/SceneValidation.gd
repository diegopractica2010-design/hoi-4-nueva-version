extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene_path := ""
	var manifest_path := ""
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--scene="):
			scene_path = argument.trim_prefix("--scene=")
		elif argument.begins_with("--manifest="):
			manifest_path = argument.trim_prefix("--manifest=")

	var scene_paths: Array[String] = []
	if not scene_path.is_empty():
		scene_paths.append(scene_path)
	elif not manifest_path.is_empty():
		var manifest := FileAccess.open(manifest_path, FileAccess.READ)
		if manifest == null:
			push_error("SCENE_VALIDATION: cannot open %s" % manifest_path)
			quit(2)
			return
		for raw_line in manifest.get_as_text().split("\n"):
			var line := raw_line.strip_edges()
			if not line.is_empty() and not line.begins_with("#"):
				scene_paths.append(line)
		manifest.close()

	if scene_paths.is_empty():
		push_error("SCENE_VALIDATION: missing --scene or --manifest")
		quit(2)
		return

	for target in scene_paths:
		if not _validate_scene(target):
			call_deferred("_finish", 1)
			return
	print("SCENE_VALIDATION: PASS count=%d" % scene_paths.size())
	call_deferred("_finish", 0)


func _finish(exit_code: int) -> void:
	quit(exit_code)


func _validate_scene(scene_path: String) -> bool:
	var resource := ResourceLoader.load(scene_path, "", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
	if resource == null or not resource is PackedScene:
		push_error("SCENE_VALIDATION: cannot load %s" % scene_path)
		return false

	var instance := (resource as PackedScene).instantiate()
	if instance == null:
		push_error("SCENE_VALIDATION: cannot instantiate %s" % scene_path)
		return false

	instance.free()
	return true
