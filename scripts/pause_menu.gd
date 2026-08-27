extends CanvasLayer

var _start_scene: PackedScene = load("res://scenes/start.tscn")
@onready var _click_audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var _continue_button: Button = $"MarginContainer/MarginContainer/VBoxContainer/Continue Button"


func _ready() -> void:
	GameManager.instance.player_hit.connect(_on_game_over)
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_on_pause_pressed()

func _on_pause_pressed() -> void:
	Engine.time_scale = 0
	visible = true

func _on_game_over() -> void:
	_on_pause_pressed()
	_continue_button.visible = false

func _on_continue_button_pressed() -> void:
	_click_audio.play()
	await _click_audio.finished
	Engine.time_scale = 1
	visible = false

func _on_reset_button_pressed() -> void:
	_click_audio.play()
	await _click_audio.finished
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	_click_audio.play()
	await _click_audio.finished
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(_start_scene)
