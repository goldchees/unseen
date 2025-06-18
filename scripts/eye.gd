extends CharacterBody2D

@onready var player: CharacterBody2D = $"../../../player"

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var pupil: CharacterBody2D = $pupil

@onready var right: Marker2D = $pupilPositions/right
@onready var down: Marker2D = $pupilPositions/down
@onready var left: Marker2D = $pupilPositions/left
@onready var up: Marker2D = $pupilPositions/up
@onready var center: Marker2D = $pupilPositions/center

#@export var firstMove: states
#@export var secondMove: states
#@export var thirdMove: states
#@export var fourthMove: states
#@export var fifthMove: states
#@onready var move_timer: Timer = $moveTimer

#@export var moves: Array[states] = []
#var num_of_moves: int
#var move_counter: int = 0
#var count_dir: String = "forward"
#var reverse_moves: Array[states] = []

@onready var vision_cone: PointLight2D = $visionCone
var vision_positions: Dictionary = {
	"down": {"position": Vector2(3,57), "rotation": 0},
	"up": {"position": Vector2(-1,-48), "rotation": 180},
}

var player_inrange
var player_in_sight

enum states {up, down, right, left, center}
var current_state: states = states.up
var pupil_speed := 20
@export var eyeSpeed := 100

#func _ready() -> void:
	#move_counter = 0
	#player_inrange = false
	#num_of_moves = moves.size()
	#for move in moves:
		#var r_move: states
		#match move:
			#states.up:
				#r_move = states.down
				#
			#states.down:
				#r_move = states.up
			#states.right:
				#r_move = states.left
			#states.left:
				#r_move = states.right
			#states.center:
				#r_move = states.center
		#reverse_moves.append(r_move)
	#move_timer.start()
	
func _process(delta: float) -> void:
	if player_inrange:
		ray_cast_2d.look_at(player.global_position)
		if ray_cast_2d.is_colliding():
			var collider = ray_cast_2d.get_collider()
			if collider.has_method('player'):
				print('hit player')
				#current_state = states.up

func _physics_process(delta: float) -> void:
	match current_state:
		states.up:
			#print("up")
			pupil.global_position = pupil.global_position.move_toward(up.global_position, pupil_speed * delta)
			vision_cone.position = vision_positions["up"]["position"]
			vision_cone.rotation = vision_positions["up"]["rotation"]
			
		states.down:
			#print("down")
			pupil.global_position = pupil.global_position.move_toward(down.global_position, pupil_speed * delta)
			vision_cone.position = vision_positions["down"]["position"]
			vision_cone.rotation = vision_positions["down"]["rotation"]
		states.right:
			#print("right")
			pupil.global_position = pupil.global_position.move_toward(right.global_position, pupil_speed * delta)
		states.left:
			#print("left")
			pupil.global_position = pupil.global_position.move_toward(left.global_position, pupil_speed * delta)
		states.center:
			#print("center")
			pupil.global_position = pupil.global_position.move_toward(center.global_position, pupil_speed * delta)

func _on_vision_area_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		player_inrange = true

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		player_inrange = false

func set_dir(dir: String):
	match "right":
		#current_state = states.right
		pass
		
		
#ww	# up (0), down (1)
	#var has_played_forward: bool = false
	#if count_dir == "forward":
		#current_state = moves[move_counter]
		#print(current_state)
		#print(count_dir)
		#move_counter += 1
	#elif count_dir == "reverse":
		#if move_counter == (num_of_moves - 1) and not has_played_forward:
			#current_state = moves[move_counter]
			#has_played_forward = true
		#elif move_counter == (num_of_moves - 1) and has_played_forward:
			#current_state = reverse_moves[move_counter]
			#move_counter -= 1
		#else:
			#current_state = reverse_moves[move_counter]
			#move_counter -= 1
#
		#print(current_state)
		#print(count_dir)
		#move_counter -= 1
		#
	#if move_counter == (num_of_moves - 1):
		#count_dir = "reverse"
		#has_played_forward = false
#
	#elif move_counter == 0:
		#count_dir = "forward"
	
#	remove
	#match move_counter:
		#0:
			#current_state = firstMove
			#count_dir = "forward"
		#1:
			#current_state = secondMove
		#2:
			#current_state = thirdMove
		#3:
			#current_state = fourthMove
		#4:
			#current_state = fifthMove
			#count_dir = "reverse"

	#move_timer.start()
	#
#
#func _on_move_timer_timeout() -> void:
	#move()
