class_name GameManager
extends Node
# THIS IS A SINGLETON SCRIPT THAT WILL BE ACCESSED THROUGH GameManager

const NPC_TO_ENEMY_RATIO: int = 4 # 4 npcs for every 1 enemy spawned
const LEVEL_TIME: float = 10.0 # duration (seconds) for each level before the end

signal time_left(time_remaining: float) # how much time is left
signal time_up() # when the time for the level finished
signal player_hit() # when the player has been hit at the end of the level
signal player_safe() # when the player has not been hit at the end of the level
signal level_started(level_num: int) # when the level has been started
signal bullet_missed() # when the bullet hits/goes out of bounds it means that it has
	# missed the player

var _player_scene: PackedScene = preload("res://scenes/player.tscn")
var _npc_scene: PackedScene = preload("res://scenes/npc.tscn")
var _enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

var _level_num: int = 1
static var player: CharacterController2D
var _npcs: Array[NPCController2D] = []
var _enemies: Array[EnemyController2D] = []
var _time_remaining: float = LEVEL_TIME
var _waiting_for_player_check: bool = false
var _num_bullets_missed: int = 0
var _is_loading: bool = true
@onready var _vp: Rect2 = (get_viewport().get_camera_2d().get_canvas_transform().affine_inverse() * get_viewport().get_visible_rect())
@onready var _screen_transition: Control = $CanvasLayer/TextureRect
static var instance: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if instance != null and instance != self:
		queue_free()
	else:
		instance = self
	# connect the needed signals to know when to increment the level
	player_safe.connect(_increment_level)
	player_hit.connect(_load_game_over)
	bullet_missed.connect(_on_bullet_miss)
	_load_level()
	
	_screen_transition.modulate.a = 1.0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(_screen_transition, "modulate:a", 0.0, 0.5)
	await tween.finished
	_is_loading = false

func _process(delta: float) -> void:
	if _is_loading:
		return
	if _time_remaining <= 0:
		if not _waiting_for_player_check:
			time_up.emit()
			_waiting_for_player_check = true
		return
	_time_remaining -= delta
	time_left.emit(_time_remaining)


func _unload_npcs() -> void:
	for npc: NPCController2D in _npcs:
		npc.free()
	for enemy: EnemyController2D in _enemies:
		enemy.free()
	player.free()
	_npcs.clear()
	_enemies.clear()
	_waiting_for_player_check = false
	_num_bullets_missed = 0

func _load_level() -> void:
	for i in _level_num:
		# spawn 1 enemy and ratio n npcs
		var enemy: EnemyController2D = _enemy_scene.instantiate()
		add_child(enemy)
		_enemies.append(enemy)
		for j in NPC_TO_ENEMY_RATIO:
			var npc: NPCController2D = _npc_scene.instantiate()
			add_child(npc)
			_npcs.append(npc)
	# on start spawn in the player and the initial number of enemies
	player = _player_scene.instantiate()
	player.position = _vp.get_center()
	add_child(player)
	level_started.emit(_level_num)
	_time_remaining = LEVEL_TIME
	time_left.emit(_time_remaining)

func _increment_level() -> void:
	_is_loading = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(_screen_transition, "modulate:a", 1.0, 2.0)
	tween.tween_property(_screen_transition, "modulate:a", 0.0, 0.5)
	
	# wait for x seconds before transitioning to the next level
	await get_tree().create_timer(2.0).timeout
	_level_num += 1
	_unload_npcs()
	_load_level()
	
	await tween.finished
	_is_loading = false

func _load_game_over() -> void:
	print("game lose")
	# TODO: open a game over menu that will allow the player to restart
	
func _on_bullet_miss() -> void:
	_num_bullets_missed += 1
	if _num_bullets_missed >= len(_enemies):
		player_safe.emit()
