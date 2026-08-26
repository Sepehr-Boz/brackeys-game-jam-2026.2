@tool
class_name Circle2D
extends Node2D

@export var radius: float = 0.5
@export var filled: bool = true
@export var border_thickness: float = 0.1

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE, filled, -1.0 if filled else border_thickness)
