extends CharacterBody2D

@export var speed = 200
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum state {walk, idle}
var current_state: state

var input_direction: Vector2
var push_speed := 100

func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play('walk')
	else:
		animated_sprite_2d.stop()
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
	match current_state:
		state.idle:
			pass
		state.walk:
			pass
	
	move_and_slide()

func _ready() -> void:
	current_state = state.idle

func do_idle():
	animated_sprite_2d.frame = 0
	if velocity != Vector2.ZERO:
		current_state = state.walk

func do_walk():
	if velocity == Vector2.ZERO:
		current_state = state.idle

func player():
	pass
