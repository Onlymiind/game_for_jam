class_name Diver extends Character

@export var submarine: Character
@export var sprint_speed: float = 400
var normal_speed: float
@onready var ui_label: Label = $Label
@export var hp: float = 100
@export var oxygen: float = 100
@export var oxygen_step: float = 4
@export var oxygen_usage: float = 1
@export var suffocation_damage: float = 1
@export var invincibility_time: float = 1.5

const max_oxygen: float = 100
const max_hp: float = 100
const oxygen_usage_threshold: float = 20

var near_submarine: bool = false
var look_dir: Vector2 = Vector2.RIGHT
var submarine_visible: bool = true
var interactable_nearby: int = 0
var interactables: Dictionary = {}


@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var sprint_particles: GPUParticles2D = $sprint
@onready var direction_arrow: Node2D = $arrow
@onready var invincibility_timer: Timer = $invincibility

signal oxygen_changed(percentage: float)
signal hp_changed(percentage: float)
signal player_died
signal fish_collected

func _ready():
	normal_speed = speed
	oxygen_changed.emit(100)
	hp_changed.emit(100)
	disable()
	sprint_particles.emitting = false

func _input(event: InputEvent):
	if event.is_action_pressed("interact"):
		if !interactables.is_empty():
			var obj = interactables.keys().back()
			var is_fish = obj is Fish
			obj.interact()
			interactables.erase(obj)
			if is_fish:
				fish_collected.emit()
		elif near_submarine:
			oxygen = max_oxygen
			oxygen_changed.emit(100)
			disable()
			submarine.enable(position)
			get_viewport().set_input_as_handled()

func enable(pos: Vector2):
	super.enable(pos)
	submarine_visible = true

func set_look_dir():
	if absf(velocity.x) <= 1e-4:
		return
	elif velocity.x < 0 && look_dir != Vector2.LEFT:
		look_dir = Vector2.LEFT
		collider.rotation = -collider.rotation
		sprite.flip_h = true
		sprint_particles.position *= -1
		sprint_particles.scale *= -1
	elif velocity.x > 0 && look_dir != Vector2.RIGHT:
		look_dir = Vector2.RIGHT
		collider.rotation = absf(collider.rotation)
		sprite.flip_h = false
		sprint_particles.position *= -1
		sprint_particles.scale *= -1


func _physics_process(delta: float):
	var shift_pressed: bool = Input.is_action_pressed("sprint")
	if shift_pressed && oxygen > 0:
		speed = sprint_speed
	else:
		speed = normal_speed
	calculate_velocity(delta)
	set_look_dir()
	move_and_slide()
	
	draw_submarine_direction_hint()
	
	if velocity.length_squared() > oxygen_usage_threshold * oxygen_usage_threshold && shift_pressed && oxygen > 0:
		oxygen -= oxygen_step * delta
		sprint_particles.emitting = true
	elif sprint_particles.visible:
		sprint_particles.emitting = false
	
	oxygen -= oxygen_usage * delta
	oxygen = max(oxygen, 0)
	oxygen_changed.emit(oxygen/max_oxygen)
	
	if oxygen == 0:
		take_damage(suffocation_damage * delta, Vector2.ZERO)

func draw_submarine_direction_hint():
	if submarine_visible:
		direction_arrow.visible = false
		return
	direction_arrow.visible = true
	direction_arrow.look_at(submarine.global_position)

func take_damage(damage: float, knockback_dir: Vector2):
	if knockback_dir != Vector2.ZERO:
		if !invincibility_timer.is_stopped():
			return
		invincibility_timer.start(invincibility_time)
	hp -= damage
	hp_changed.emit(max(hp, 0)/max_hp)
	if hp <= 0:
		player_died.emit()

func _on_submarine_approach():
	near_submarine = true

func _on_submarine_distancing():
	near_submarine = false

func on_interaction_area_entered():
	interactable_nearby += 1
	ui_label.show()

func on_interaction_area_exited():
	interactable_nearby -= 1
	interactable_nearby = max(interactable_nearby, 0)
	if interactable_nearby == 0:
		ui_label.hide()

func add_interactable(object: Node2D):
	interactables[object] = true

func remove_interactable(object: Node2D):
	interactables.erase(object)

func _on_submarine_screen_entered():
	submarine_visible = true

func _on_submarine_screen_exited():
	submarine_visible = false
