class_name NestedMenu extends Control

@export var back:Button
@export var parent:Control

func _ready():
	back.pressed.connect(_on_back_pressed)
	self.visible = false

func _input(event:InputEvent):
	if event.is_action_pressed("pause"):
		deactivate()
		get_viewport().set_input_as_handled()

func activate():
	self.visible = true
	parent.visible = false

func _on_back_pressed():
	deactivate()

func deactivate():
	self.visible = false
	parent.visible = true
