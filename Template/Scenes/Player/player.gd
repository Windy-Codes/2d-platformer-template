extends CharacterBody2D

@export var SPEED := 250.0
@export var JUMP_VELOCITY := -350.0

var is_alive := true

var can_double_jump := true
var coyote := false
var was_on_floor := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_time: Timer = $Coyote_Time


func _physics_process(delta):

	Movement()
	Jump()
	Grivity(delta)



func Grivity(delta):
	# Gravity
	if !is_on_floor():
		velocity += get_gravity() * delta


func coyote_timer():
	# Left the ground this frame
	if was_on_floor and !is_on_floor():
		coyote = true
		coyote_time.start()

	was_on_floor = is_on_floor()

func Jump():
	# Jump input
	if Input.is_action_just_pressed("Jump"):

		# Normal jump
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Coyote jump
		elif coyote:
			velocity.y = JUMP_VELOCITY
			coyote = false

		# Double jump
		elif can_double_jump:
			velocity.y = JUMP_VELOCITY
			can_double_jump = false
		
	# Landing
	if is_on_floor():
		can_double_jump = true
		coyote = false

func Movement():
	# Horizontal movement
	var direction := Input.get_axis("Move_left", "Move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	# Move the character
	if is_alive:
		move_and_slide()



func Player_animations():

	if !is_on_floor():
		animated_sprite.play("Jump")
	elif velocity.x != 0:
		animated_sprite.play("runing")
	else:
		animated_sprite.play("idle")

	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true


func _on_coyote_time_timeout():
	coyote = false
