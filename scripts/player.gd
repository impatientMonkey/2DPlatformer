extends CharacterBody2D

@onready var dyingTimer = $dyingTimer
@onready var playerSprite = $playerSprite
@onready var pfp = $pfp
@onready var hitbox = $hitbox
@onready var attackTimer = $attackTimer

const SPEED = 450.0
const JUMP_VELOCITY = -700.0
const ACCEL = 2000.0
const FRICTION = 1500.0
const COYOTE_TIME = 0.15
const JUMP_BUFFER_TIME = 0.15
const ATTACK_COOLDOWN = 0.3

var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var is_attacking = false

var max_health := 3
var current_health := 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	current_health = max_health
	pfp.play("default")
	playerSprite.play("default")
	attackTimer.wait_time = ATTACK_COOLDOWN
	attackTimer.one_shot = true

func _physics_process(delta: float) -> void:
	# coyote time
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	# jump buffer
	if Input.is_action_just_pressed("jump"):
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
	var direction = Input.get_axis("left", "right")
	if(current_health != 0):
		if direction != 0:
			if not is_attacking:
				playerSprite.play("walking")
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
		else:
			if not is_attacking:
				playerSprite.play("default")
			velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)
	else:
		playerSprite.play("dead")
	
	#melee attack
	if Input.is_action_just_pressed("attack") and not is_attacking and attackTimer.is_stopped():
		is_attacking = true
		playerSprite.play("attack")
		hitbox.monitoring = true
		hitbox.monitorable = true
		attackTimer.start()
	
	#flip sprite based on direction
	if Input.is_action_just_pressed("left"):
		playerSprite.flip_h = false
		$hitbox/CollisionShape2D.position.x = -abs($hitbox/CollisionShape2D.position.x)
	elif Input.is_action_just_pressed("right"):
		playerSprite.flip_h = true
		$hitbox/CollisionShape2D.position.x = abs($hitbox/CollisionShape2D.position.x)

	move_and_slide()

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		pfp.play("dead")
		die() 
	elif current_health == 2:
		pfp.play("minor_hurt")
	elif current_health == 1:
		pfp.play("really_hurt")

func launch_player(strength: float):
	velocity.y = strength

func die():
	dyingTimer.start()
	

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_world_boundary_body_entered(_body:Node2D) -> void:
	die()


func _on_hitbox_body_entered(body:Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1)

func _on_attack_timer_timeout() -> void:
	is_attacking = false
	hitbox.monitorable = false
	hitbox.monitorable = false
	if playerSprite.animation == "attack":
		playerSprite.play("default")




