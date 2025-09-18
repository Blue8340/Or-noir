extends CharacterBody2D
class_name Player

@export var gravity = 1500
@export var speed = 300
@export var acceleration = 0.3
@export var jumpForce = 500
var haveDoubleJump = false
@onready var sprite = %AnimatedSprite2D

func _physics_process(delta):
	#print("physique")
	velocity.y = clamp(velocity.y + gravity * delta, -1000, 1000)

	var direction = Input.get_axis("move_left","move_right")

	velocity.x = lerp(velocity.x, direction * speed, acceleration)

	if direction != 0:
		sprite.flip_h = (direction == -1)
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jumpForce
			haveDoubleJump = true
			#print(haveDoubleJump)
			haveDoubleJump = true
		
		elif !is_on_floor() and haveDoubleJump == true:
			velocity.y = -jumpForce
			#print(haveDoubleJump) 
			haveDoubleJump = false
			#print(haveDoubleJump)

	updateAnimation(direction)
	move_and_slide()

var was_on_floor = false

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
	#print("mort")
	get_parent().call_deferred("spawn_player")
	queue_free()
