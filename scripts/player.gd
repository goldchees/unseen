extends CharacterBody2D

@export var speed = 200
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: Node2D = $"../health"
@onready var explosion: CPUParticles2D = $explosion
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal player_died

enum state {walk, idle}
var current_state: state

var input_direction: Vector2
var push_speed := 300

var min_knockback := 50
var slow_knockback := 20
var knockback: Vector2

func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	#if velocity != Vector2.ZERO:
		#animated_sprite_2d.play('walk')
	#else:
		#animated_sprite_2d.stop()
	if Input.is_action_just_pressed("left"):
		animated_sprite_2d.flip_h = true
	elif Input.is_action_just_pressed("right"):
		animated_sprite_2d.flip_h = false
	
	if get_slide_collision_count() > 0:
		check_box_collision(input_direction)

func check_box_collision(direction):
	var collision = get_slide_collision(0)
	var collider := collision.get_collider()
	if collider.is_in_group('boxes'):
		collider.apply_central_impulse(direction * push_speed)

func _physics_process(delta):
	get_input()
	if knockback.length() > min_knockback:
		knockback /= slow_knockback
		velocity = knockback
	if health.health <= 0:
		animated_sprite_2d.hide()
		collision_shape_2d.disabled = true
		explosion.emitting = true
		
	match current_state:
		state.idle:
			pass
		state.walk:
			pass
	
	move_and_slide()

func _ready() -> void:
	current_state = state.idle
	animation_player.play("RESET")
	animated_sprite_2d.show()
	collision_shape_2d.disabled = false

func do_idle():
	animated_sprite_2d.frame = 0
	if velocity != Vector2.ZERO:
		current_state = state.walk

func do_walk():
	if velocity == Vector2.ZERO:
		current_state = state.idle

func receive_damage(enemy, direction):
	animation_player.play("hurt")
	#knockback = (position - enemy.position).normalized() * 200
	knockback = direction * 500
	health.lose_health()

func player():
	pass


func _on_explosion_finished() -> void:
	await get_tree().create_timer(0.5).timeout
	player_died.emit()
