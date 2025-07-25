extends CharacterBody2D

@onready var sprite = $Sprite2D

var speed := 80.0 
var turn_distance := 100.0 
var initial_offset := 0.0

var direction := 1
var distance_traveled := 0.0
var damage := 1
var launch_strength := -500.0

func _ready():
    distance_traveled = initial_offset

func _physics_process(delta: float) -> void:
    velocity.y = 0
    velocity.x = speed * direction
    var _collision_info = move_and_slide()

    distance_traveled += abs(velocity.x) * delta

    if distance_traveled >= turn_distance:
        direction *= -1
        distance_traveled = 0.0
    
    if sprite:
        sprite.flip_h = (direction < 0)

func _on_area_2d_body_entered(body:Node2D) -> void:
    if body.name == "Player":
        body.take_damage(damage)
        body.launch_player(launch_strength)

	