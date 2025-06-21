extends Area2D

var speed := 300
var direction: Vector2
func _process(delta: float) -> void:
	position += delta * direction
