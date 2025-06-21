extends Node2D

var health: int
var hearts: Array
var i: int
var can_lose_health: bool

func _ready() -> void:
	hearts = get_children()
	health = hearts.size()
	i = 1
	can_lose_health = true
	for heart in hearts:
		heart.visible = true

func lose_health():
	if health <= 0 or can_lose_health == false:
		return
	health -= 1
	hearts[-i].visible = false
	print(health)
	i += 1
	can_lose_health = false
	get_tree().create_timer(0.5).timeout.connect(on_timeout)

func on_timeout():
	can_lose_health = true
	
