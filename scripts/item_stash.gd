class_name ItemStash extends Area2D

@onready var tooltip: Label = $tooltip

func _ready() -> void:
	$animation.play("blink")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).set_item_stash(self)
		tooltip.show()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		(body as Player).remove_current_item_stash()
		tooltip.hide()
