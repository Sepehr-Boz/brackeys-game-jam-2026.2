class_name Indicator
extends Sprite2D

@export var _initial_color: Color = Color(0,0,0,0)
@export var _final_color: Color = Color(1,1,1,1)
@export var _initial_scale: Vector2 = Vector2(0.1, 0.1)
@export var _final_scale: Vector2 = Vector2(2.5, 2.5)
@export var _tween_duration: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = _initial_color
	scale = _initial_scale

func play() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", _final_color, _tween_duration)
	tween.parallel().tween_property(self, "scale", _final_scale, _tween_duration)
	await tween.finished
	self.queue_free()
