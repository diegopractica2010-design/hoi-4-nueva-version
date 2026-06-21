# scripts/core/AutoloadValidationRunner.gd
extends Node

func _ready() -> void:
	var Validator = load("res://scripts/core/AutoloadValidator.gd")
	var ok = Validator.validate_all()
	print("Autoload validation: ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)
