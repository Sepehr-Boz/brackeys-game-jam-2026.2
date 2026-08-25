class_name EnemyController2D
extends NPCController2D

@export_group("Indicator Props.")
@export var _indicator_initial_color: Color
@export var _indicator_final_color: Color
@export var _indicator_final_scale: Vector2
@export var _indicator_scale_duration: float

var _bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var _indicator_scene: PackedScene = preload("res://scenes/indicator.tscn")
var _is_dancing: bool = false
var _time_when_indicate: float
var _is_indicating: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_time_when_indicate = _rng.randf_range(GameManager.LEVEL_TIME / 5, GameManager.LEVEL_TIME / 1.5)
	# connect to the time up signal in game manager and when it emits then
	# make the enemy face towards the player and shoot
	GameManager.time_up.connect(_on_timer_up)
	GameManager.player_hit.connect(_on_player_hit)
	GameManager.time_left.connect(_on_time_decreased)

func _process(delta: float) -> void:
	if _is_dancing:
		return
	super._process(delta)

func _on_timer_up() -> void:
	velocity = Vector2.ZERO
	_sprite.animation = "idle"
	_sprite.flip_h = GameManager.player.position.x < position.x
	var bullet: Bullet2D = _bullet_scene.instantiate()
	add_sibling(bullet)
	bullet.shoot(position, GameManager.player.position)

func _on_player_hit() -> void:
	velocity = Vector2.ZERO
	_sprite.animation = "victory"
	_sprite.flip_h = _rng.randi_range(0, 1) == 1
	_is_dancing = true

func _on_time_decreased(time_remaining: float) -> void:
	if time_remaining <= _time_when_indicate and not _is_indicating:
		_is_indicating = true
		var indicator: Indicator = _indicator_scene.instantiate()
		add_sibling(indicator)
		indicator.position = position
		indicator.play()
