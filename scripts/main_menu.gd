extends Node


func _ready() -> void:
	var buttons = [
		$buttons/button_level_1,
		$buttons/button_level_2,
	]

	for idx in range(buttons.size()):
		var button = buttons[idx]
		button.pressed.connect(_on_button_pressed.bind(idx + 1))
		button.disabled = idx >= GameState.levels_completed


func _on_button_pressed(level):
	GameState.load_level(level)
