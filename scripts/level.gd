extends Node2D

@onready var player: CharacterBody2D = $player
@onready var player_spawn: Marker2D = $playerSpawn
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	#get_tree().paused = false
	animation_player.play('fade_out')
	player.player_died.connect(handle_death)
	player.global_position = player_spawn.global_position

func handle_death():
	animation_player.play("fade_in")
	#get_tree().paused = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		get_tree().reload_current_scene()


func _on_level_transition_area_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		var current_scene_file = get_tree().current_scene.scene_file_path
