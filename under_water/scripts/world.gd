extends Node2D

var player_dead: bool = false
@onready var pause_menu: Control = $CanvasLayer/pause_menu

@onready var fish_count: int = $pausable/collectible_fish.get_child_count()
var fish_collected: int = 0

@onready var hud: Control = $CanvasLayer/hud

func _ready():
	hud.set_total_fish_count(fish_count)

func _input(event:InputEvent):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pause_menu.visible = !pause_menu.visible

func _on_player_died():
	get_tree().paused = false
	get_tree().change_scene_to_packed(Preload.lose_screen)

func _on_resume():
	get_tree().paused = false
	pause_menu.visible = false

func _on_quit_to_menu():
	get_tree().paused = false
	get_tree().change_scene_to_packed(Preload.main_menu)

func _on_fish_collected():
	fish_collected += 1
	hud.set_fish_count(fish_collected)
	if fish_collected >= fish_count:
		get_tree().paused = false
		get_tree().change_scene_to_packed(Preload.win_screen)
