class_name HUD extends Control

@onready var stamina_bar: ProgressBar = $MarginContainer/HBoxContainer/ProgressBar
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var level_status: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/level_status
@onready var time_to_police: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/time_to_police
@onready var interact_tooltip: PanelContainer = $MarginContainer/PanelContainer

var stamina_value: float = -1

const level_status_idle: String = "Police will arrive in: "
const level_status_police: String = "Police is here! Get to the car"

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

func _on_can_interact() -> void:
	interact_tooltip.show()

func _on_cannot_interact() -> void:
	interact_tooltip.hide()

func set_level_status(police_arrived: bool) -> void:
	if police_arrived:
		time_to_police.hide()
		level_status.text = level_status_police
	else:
		time_to_police.show()
		level_status.text = level_status_idle

func set_time_to_police(time_sec: float) -> void:
	var minutes: int = (time_sec / 60) as int
	var seconds: int = (time_sec - minutes * 60) as int
	time_to_police.text = "{0}:{1}".format([minutes, seconds])
