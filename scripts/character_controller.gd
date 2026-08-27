class_name CharacterController2D
extends Area2D

@export var _walk_speed: float = 400
@export var _run_speed: float = 600
@export_group("Bounce Animation")
@export var _bounce_duration: float = 3.0
@export_range(1, 10) var _num_bounces: int = 3
@export var _bounce_height: float = 128
@export_range(0, 1) var _bounce_height_falloff: float = 0.5
@export var _bounce_distance: float = 64

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _vp: Rect2 = (get_viewport().get_camera_2d().get_canvas_transform().affine_inverse() * get_viewport().get_visible_rect())
@onready var _victory_particles: CPUParticles2D = $"Win Particles"
@onready var _shot_particles: CPUParticles2D = $"Lose Particles"


var _is_sprinting: bool = false
var velocity: Vector2
var _can_control: bool = true
var _hit_from_left: bool

func _ready() -> void:
	GameManager.instance.player_hit.connect(_lost_level)
	GameManager.instance.player_safe.connect(_won_level)
	area_entered.connect(_on_area_entered)
	
	_sprite.play()

func get_move_input() -> void:
	# get input and set velocity
	var input_direction: Vector2 = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down").normalized()
	_is_sprinting = Input.is_action_pressed("sprint")
	velocity = input_direction * (_run_speed if _is_sprinting else _walk_speed)

func set_animation() -> void:
	if velocity == Vector2.ZERO:
		_sprite.animation = "idle"
	else:
		if _is_sprinting:
			_sprite.animation = "sprint"
		else:
			_sprite.animation = "walk"
		# only flip on when actually turned
		if velocity.x < 0:
			_sprite.flip_h = true
		elif velocity.x > 0:
			_sprite.flip_h = false

func _process(delta: float) -> void:
	if not _can_control:
		return
	get_move_input()
	position += velocity * delta
	# clamp the position so that the character is within the viewport at all times
	position = Vector2(
		clampf(position.x, _vp.position.x, _vp.end.x),
		clampf(position.y, _vp.position.y, _vp.end.y)
	)
	set_animation()

func _lost_level() -> void:
	velocity = Vector2.ZERO
	_can_control = false
	_sprite.animation = "hit"
	_shot_particles.emitting = true
	# play bounce animation in the direction it was hit
	var initial_position: Vector2 = position
	var offset: Vector2 = Vector2.ZERO
	var time_passed: float = 0.0
	var delta: float
	var time_per_bounce: float = _bounce_duration / _num_bounces
	while time_passed <= _bounce_duration:
		var time_on_bounce: float = fmod(time_passed, time_per_bounce)
		offset = Vector2(
			time_passed * _bounce_distance * (1 if _hit_from_left else -1),
			-abs(sin(deg_to_rad(
				inverse_lerp(0, time_per_bounce, time_on_bounce) * 180)
			)) * (_bounce_height * pow(_bounce_height_falloff, time_passed / time_per_bounce))
		)
		position = initial_position + offset
		delta = get_process_delta_time()
		time_passed += delta
		await get_tree().create_timer(delta).timeout

func _won_level() -> void:
	velocity = Vector2.ZERO
	_can_control = false
	_sprite.animation = "victory"
	_victory_particles.emitting = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		_hit_from_left = area.position.x < position.x
		_sprite.flip_h = _hit_from_left # so that it faces the direction it was hit in
