extends CanvasLayer

@export var _start_menu: CanvasLayer
@onready var _click_audio: AudioStreamPlayer = $AudioStreamPlayer

func _on_return_button_pressed() -> void:
	_click_audio.play()
	await _click_audio.finished
	_start_menu.visible = true
	visible = false
