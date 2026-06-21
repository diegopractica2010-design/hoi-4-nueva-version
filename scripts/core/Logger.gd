static func info(msg: String, context: String = "") -> void:
	if context.is_empty():
		print("[INFO] ", msg)
	else:
		print("[INFO][", context, "] ", msg)

static func warn(msg: String, context: String = "") -> void:
	if context.is_empty():
		push_warning("[WARN] ", msg)
	else:
		push_warning("[WARN][", context, "] ", msg)

static func error(msg: String, context: String = "") -> void:
	if context.is_empty():
		push_error("[ERROR] ", msg)
	else:
		push_error("[ERROR][", context, "] ", msg)

static func debug(msg: String, context: String = "") -> void:
	if context.is_empty():
		print("[DEBUG] ", msg)
	else:
		print("[DEBUG][", context, "] ", msg)
