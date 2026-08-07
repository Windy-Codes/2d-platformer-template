extends CharacterBody2D


@export_category("Peremeters")

@export_group("movement")
@export var Can_Double_Jump := true  # set can the player double jump or not
@export var SPEED := 250.0  # there speed
@export var JUMP_VELOCITY := -350.0  # there jump power

@export_group("Life_Death")
@export var Reset_Lvl_after_Death := false # if you want the level to reset after the death set this true and if you want player to respwan to a chack point ste this false
@export var  Reset_Lvl_when_lifes_hit_0 := false # if you want the level to reset what the lifes hit zero
@export var respwn_Health := 100 # if the Reset_lvl_after_death is false you can set what should the player respawning health should be 
@export var Health := 100 # the player max health
@export var lifes := 3 # how many lifes the player have 

# not important

var is_alive := true
var is_Hit := false

signal took_damage

var can_double_jump := true
var coyote := false
var was_on_floor := false

@onready var max_health := Health

var chack_point : Marker2D
var world_spawn_point : Vector2
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_time: Timer = $Coyote_Time
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var health_bar: ProgressBar = $Health_bar/Health_Bar


#audio players
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var damage: AudioStreamPlayer2D = $Damage



func _ready() -> void:

	world_spawn_point = global_position

	health_bar.value = Health
	health_bar.max_value = max_health


func _physics_process(delta):

	Movement()
	Jump()
	Grivity(delta)
	coyote_timer()


func _process(_delta: float) -> void:

	Player_animations()



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
			jump.play()
			velocity.y = JUMP_VELOCITY
			
			

		# Coyote jump
		elif coyote:
			jump.play()
			velocity.y = JUMP_VELOCITY
			coyote = false

		# Double jump
		elif can_double_jump and Can_Double_Jump :
			jump.play()
			velocity.y = JUMP_VELOCITY
			can_double_jump = false
			
		
	# Landing
	if is_on_floor():
		can_double_jump = true
		coyote = false



func Movement():

	# Move the character
	if is_alive:
		move_and_slide()

	# Horizontal movement
	var direction := Input.get_axis("Move_left", "Move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)




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
	damage.play()
	took_damage.emit()

	animated_sprite.play("Hit")
	await  animated_sprite.animation_finished
	is_Hit = false


	if Health <= 0 and Reset_Lvl_after_Death == false:
		Respwnable_Death(1)
	elif Health <= 0 and Reset_Lvl_after_Death == true:
		All_resetting_Death()


func Health_Bar_updater():

	health_bar.value = Health




func Respwnable_Death(take_lifes_numbre):

	health_bar.value = respwn_Health

	if Reset_Lvl_when_lifes_hit_0 == true  and lifes <= 0:
		All_resetting_Death()

	Health = respwn_Health
	if is_instance_valid(chack_point):
		global_position = chack_point.global_position
	else:
		global_position = world_spawn_point
	
	lifes -= take_lifes_numbre

func All_resetting_Death():

	get_tree().reload_current_scene.call_deferred()




func _on_coyote_time_timeout():
	coyote = false



func _on_took_damage():
	
	Health_Bar_updater()
