extends RichTextLabel

# > 5 seconds
const BASE_FORMAT: String = "[p align=c][b][font_size=192]%.1f[/font_size][/b][/p]"
# < 5 seconds
const WARN_FORMAT: String = "[p align=c][b][font_size=204][shake rate=20.0 level=5 connected=1]%.1f[/shake][/font_size][/b][/p]"
# == 0 seconds
const FINAL_STRING: String = "[p align=c][b][font_size=204]0.0[/font_size][/b][/p]"
@export var _warning_gradient: Gradient # the color gradient change as it goes from 5 to 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.instance.time_left.connect(_on_time_remaining_updated)

func _on_time_remaining_updated(time_remaining: float) -> void:
	if time_remaining > 5.0:
		modulate = Color.WHITE
		text = BASE_FORMAT % clampf(time_remaining, 0.0, GameManager.LEVEL_TIME)
	elif time_remaining > 0:
		# whenever theres <= 5 seconds left then start changing the colour to warn
		# also 'shake' the text by scaling up and down continuously to draw attention
		modulate = _warning_gradient.sample(inverse_lerp(5.0, 0, time_remaining))
		text = WARN_FORMAT % clampf(time_remaining, 0.0, GameManager.LEVEL_TIME)
	else:
		text = FINAL_STRING
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1,0.25), 0.25)
