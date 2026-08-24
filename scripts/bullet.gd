class_name Bullet2D
extends Area2D

@export var _speed: float = 400.0
@onready var _vp: Rect2 = (get_viewport().get_camera_2d().get_canvas_transform().affine_inverse() * get_viewport().get_visible_rect())
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * _speed * delta
	# if out of bounds then communicate that it has missed the player
	if position.x <= _vp.position.x or position.x >= _vp.end.x:
		pass
	elif position.y <= _vp.position.y or position.y >= _vp.end.y:
		pass

func shoot(from: Vector2, at: Vector2) -> void:
	position = from
	velocity = position.direction_to(at).normalized()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		GameManager.player_hit.emit()
		self.queue_free()
