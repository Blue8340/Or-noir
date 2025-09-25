extends CharacterBody2D
class_name Player

@export var gravity = 1500
@export var speed = 700
@export var acceleration = 3000  
@export var friction = 2000       
@export var jumpForce = 500
var haveDoubleJump = false
@onready var sprite = %AnimatedSprite2D

var was_on_floor = false

func _physics_process(delta):
	# Gravité
	velocity.y = clamp(velocity.y + gravity * delta, -1000, 1000)

	# Input horizontal
	var direction = Input.get_axis("move_left","move_right")

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		sprite.flip_h = (direction == -1)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
	updateAnimation(direction)

func updateAnimation(direction):
	var just_landed = is_on_floor() and !was_on_floor

	if sprite.animation == "touchGrass" and sprite.is_playing():
		pass
	elif just_landed:
		sprite.play("touchGrass")
	elif is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
	else:
		if velocity.y < 0:
			if haveDoubleJump == true:
				sprite.play("jump")
			else:
				sprite.play("DoubleJump")
		else:
			sprite.play("fall")

	was_on_floor = is_on_floor()

func die():
	get_parent().call_deferred("spawn_player")
	queue_free()
