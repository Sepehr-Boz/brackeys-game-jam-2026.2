class_name StartMenu
extends CanvasLayer

var _game_scene: PackedScene = load("res://scenes/game.tscn")
@onready var _click_audio: AudioStreamPlayer = $AudioStreamPlayer

func _on_play_button_pressed() -> void:
	_click_audio.play()
	await _click_audio.finished
	get_tree().change_scene_to_packed(_game_scene)

func _on_quit_button_pressed() -> void:
	_click_audio.play()
	await _click_audio.finished
	get_tree().quit()
