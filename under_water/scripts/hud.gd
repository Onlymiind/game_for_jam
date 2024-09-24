extends Control

@onready var oxygen: TextureProgressBar = $TextureRect/VBoxContainer/oxygen
@onready var hp: TextureProgressBar = $TextureRect/VBoxContainer/hp
@onready var fish_label: Label = $HBoxContainer/Label

func set_hp(percentage: float):
	if absf(percentage - 100) < 1e-4:
		hp.value = hp.max_value
		return
	hp.value = percentage * hp.max_value

func set_oxygen(percentage: float):
	if absf(percentage - 100) < 1e-4:
		oxygen.value = oxygen.max_value
		return
	oxygen.value = percentage * oxygen.max_value

func set_total_fish_count(count: int):
	$HBoxContainer/Label3.text = "%d"%count

func set_fish_count(count: int):
	fish_label.text = "%d"%count
