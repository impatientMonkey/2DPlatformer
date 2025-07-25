extends Area2D

var damage := 1
var launch_strength := -500.0

func _on_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		body.take_damage(damage)
		body.launch_player(launch_strength)
	
