extends PathFollow2D
@onready var eye: CharacterBody2D = $eye

var speed := 0.1

func _process(delta: float) -> void:
	var previous_pos = global_position
	progress_ratio += delta * speed
	var dir = (global_position - previous_pos).normalized()
	
	#if abs(dir.x) > abs(dir.y):
		#if dir.x > 0:
			#eye.current_state = states.right
		#else:
			#eye.current_state = states.left
