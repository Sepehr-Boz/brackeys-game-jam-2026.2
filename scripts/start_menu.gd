class_name StartMenu
extends CanvasLayer

var _game_scene: PackedScene = load("res://scenes/game.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(_game_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
