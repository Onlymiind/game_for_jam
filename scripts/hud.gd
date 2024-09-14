extends Control

@onready var stamina_bar: ProgressBar = $ProgressBar
@onready var animation: AnimationPlayer = $AnimationPlayer

var stamina_value: float = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stamina_value != -1:
		stamina_bar.value = stamina_value

func _on_stamina_changed(percentage: float) -> void:
	if stamina_bar == null:
		stamina_value = percentage
		return
	if abs(percentage - 1) < 1e-3:
		percentage = 1
	stamina_bar.value = percentage * stamina_bar.max_value

func _on_stamina_ran_out() -> void:
	animation.play("blink")

func _on_stamina_replenished() -> void:
	animation.stop()
	animation.play("RESET")
