extends CharacterBody2D

@export var SPEED := 250.0
@export var JUMP_VELOCITY := -350.0
@export var Health := 100

@export_group("Peremeters")
@export var Can_Double_Jump := true


var is_alive := true
var is_Hit := false

var can_double_jump := true
var coyote := false
var was_on_floor := false


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_time: Timer = $Coyote_Time
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _physics_process(delta):

	Movement()
	Jump()
	Grivity(delta)
	coyote_timer()


func _process(_delta: float) -> void:

	Player_animations()



func Grivity(delta):
	# Gravity
	if !is_on_floor() and is_Hit == false:
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
		elif can_double_jump and Can_Double_Jump :

			velocity.y = JUMP_VELOCITY
			can_double_jump = false
		
	# Landing
	if is_on_floor():
		can_double_jump = true
		coyote = false



func Movement():

	if is_Hit:
		return
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
	
	if is_Hit == true:
		return

	if !is_on_floor() and can_double_jump:
		animated_sprite.play("Jump")
	elif !is_on_floor() and !can_double_jump:
		animated_sprite.play("Double_Jump")

	elif velocity.x != 0:
		animated_sprite.play("runing")
	else:
		animated_sprite.play("idle")

	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true


func Take_Damage(Damage):
	is_Hit = true
	Health -= Damage
	collision_shape.call_deferred("set_disabled", true)

	animated_sprite.play("Hit")
	await  animated_sprite.animation_finished
	collision_shape.call_deferred("set_disabled", false)
	is_Hit = false


	if Health <= 0:
		Death()



func Death():

	get_tree().reload_current_scene.call_deferred()




func _on_coyote_time_timeout():
	coyote = false

