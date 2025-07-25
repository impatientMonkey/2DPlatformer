extends Area2D

@onready var sprite = $Sprite2D

var float_amplitude := 30.0 
var float_speed := 1.0
var base_y := 0.0

func _ready() -> void:
    base_y = sprite.position.y

func _process(_delta: float) -> void:
    sprite.position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed * TAU) * float_amplitude

func _on_body_entered(_body:Node2D) -> void:
    queue_free()

