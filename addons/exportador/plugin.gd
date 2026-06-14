@tool
extends EditorPlugin

## Reconstruye el APK de Android usando export_project() directamente.
## Motivo: en este equipo, la validación previa de Godot (can_export) falla en
## modo headless por un canal de mensajes interno, pese a que el SDK, el JDK y la
## keystore son correctos y la exportación real funciona. Esta herramienta omite
## esa validación previa y ejecuta la exportación que sí funciona.
##
## Uso: se activa SOLO cuando el editor se lanza con el argumento de usuario
## "--build-apk" (ver Reconstruir_APK.bat). En el uso normal del editor no hace nada.

func _enter_tree() -> void:
	if "--build-apk" in OS.get_cmdline_user_args():
		_build_apk.call_deferred()

func _build_apk() -> void:
	await get_tree().create_timer(0.8).timeout
	var plat: Object = ClassDB.instantiate("EditorExportPlatformAndroid")
	if plat == null:
		printerr("[exportador] No se pudo crear la plataforma Android.")
		get_tree().quit(1)
		return
	var preset: Object = plat.create_preset()
	preset.set("gradle_build/use_gradle_build", false)
	preset.set("architectures/arm64-v8a", true)
	preset.set("architectures/armeabi-v7a", true)
	preset.set("version/code", 1)
	preset.set("version/name", "1.0")
	preset.set("package/unique_name", "com.estudiopaulina.guerradelpacifico")
	preset.set("package/name", "Guerra del Pacifico 1879")

	var proj_dir: String = ProjectSettings.globalize_path("res://")
	var out: String = proj_dir.path_join("../../_builds/android/GuerraDelPacifico.apk").simplify_path()
	DirAccess.make_dir_recursive_absolute(out.get_base_dir())

	plat.clear_messages()
	var err: int = plat.export_project(preset, true, out, 0)
	if err == 0:
		print("[exportador] APK creado correctamente en: ", out)
	else:
		printerr("[exportador] Error al exportar APK (codigo ", err, "):")
		for j in plat.get_message_count():
			printerr("  - ", plat.get_message_text(j))
	get_tree().quit(0 if err == 0 else 1)
