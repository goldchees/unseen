extends CharacterBody2D

@onready var player: CharacterBody2D = $"../../../player"

@onready var ray_cast_2d: RayCast2D = $RayCast2D

@onready var path_follow_2d: PathFollow2D = $".."
# patrol types are linear and loop
@export_enum("linear", "loop") var patrol_type: String
# 1 is forward, 0 is backward
var direction = 1
# states are patrol and attack
var current_state: String

var player_inrange
var player_in_sight

@export var eyeSpeed := 0.1


func _ready() -> void:
	current_state = "patrol"
	direction = 1

func _process(delta: float) -> void:
	if player_inrange:
		ray_cast_2d.look_at(player.global_position)
		if ray_cast_2d.is_colliding():
			var collider = ray_cast_2d.get_collider()
			if collider.has_method('player'):
				current_state = "attack"
				# put player death here
				pass

func _physics_process(delta: float) -> void:
	match current_state:
		"patrol":
			patrol(delta)
		"attack":
			attack()

func patrol(delta):
	if patrol_type == "loop":
		path_follow_2d.progress_ratio += eyeSpeed * delta
		if rotation_degrees != 0:
			rotation_degrees = lerp(rotation_degrees, 0.0, 0.2)
	elif patrol_type == "linear":
		if direction == 1:
			if path_follow_2d.progress_ratio >= 0.9:
				await get_tree().create_timer(0.3).timeout
				rotation_degrees = lerp(rotation_degrees, 180.0, 0.1)
				await get_tree().create_timer(1).timeout
				direction = 0
			else:
				path_follow_2d.progress_ratio += eyeSpeed * delta
				if rotation_degrees != 0:
					rotation_degrees = lerp(rotation_degrees, 0.0, 0.2)
		elif direction == 0:
			if path_follow_2d.progress_ratio <= 0.1:
				await get_tree().create_timer(0.3).timeout
				rotation_degrees = lerp(rotation_degrees, 0.0, 0.1)
				await get_tree().create_timer(1).timeout
				direction = 1
			else:
				path_follow_2d.progress_ratio -= eyeSpeed * delta
				if rotation_degrees != 180:
					rotation_degrees = lerp(rotation_degrees, 180.0, 0.2)
	
func attack():
	look_at(player.global_position)
	if player_inrange == false:
		current_state = "patrol"
	
	
func _on_vision_area_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		player_inrange = true

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		player_inrange = false
