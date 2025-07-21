extends CharacterBody2D

@onready var playerSprite = $Sprite2D

const SPEED = 450.0
const JUMP_VELOCITY = -650.0
const ACCEL = 2000.0
const FRICTION = 1500.0
const COYOTE_TIME = 0.15
const JUMP_BUFFER_TIME = 0.15

var coyote_timer = 0.0
var jump_buffer_timer = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# coyote time
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	# jump buffer
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta
	
	if not is_on_floor():
		velocity.y += gravity * delta
	if jump_buffer_timer > 0 and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	#vertical movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)
	
	#flip sprite based on direction
	if Input.is_action_just_pressed("ui_left"):
		playerSprite.flip_h = false
	elif Input.is_action_just_pressed("ui_right"):
		playerSprite.flip_h = true

	move_and_slide()
	
