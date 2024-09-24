class_name ExplosiveWall extends StaticBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var particles1: GPUParticles2D = $GPUParticles2D
@onready var particles2: GPUParticles2D = $GPUParticles2D2
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var particles_finished: bool = false
var sound_finished: bool = false

func explode():
	particles1.emitting = true
	particles2.emitting = true
	collision.disabled = true
	sprite.visible = false
	sound.play()

func _on_explosion_sound_finished():
	queue_free()
