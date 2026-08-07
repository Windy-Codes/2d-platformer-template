extends CharacterBody2D

enum State {
	IDLE,
	CHARGING,
	RETURNING
}

@export var charge_speed := 300.0
@export var return_speed := 150.0
@export var max_charge_distance := 200.0

var state: State = State.IDLE
var charge_direction := Vector2.ZERO
var spawn_position := Vector2.ZERO
var charge_start_position := Vector2.ZERO

@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var ray_cast_right: RayCast2D = $RayCast_right
@onready var ray_cast_up: RayCast2D = $RayCast_up
@onready var ray_cast_down: RayCast2D = $RayCast_down


func _ready():
	spawn_position = global_position


func _process(delta):
	enemy_logic(delta)


func enemy_logic(delta):
	match state:

		State.IDLE:
			velocity = Vector2.ZERO
			check_for_player()

		State.CHARGING:
			charge(delta)

		State.RETURNING:
			return_to_spawn()


func charge(delta):
	var collision = move_and_collide(charge_direction * charge_speed * delta)

	# Stop if we hit something
	if collision:
		state = State.RETURNING
		return

	# Stop if we've charged too far
	if global_position.distance_to(charge_start_position) >= max_charge_distance:
		state = State.RETURNING


func return_to_spawn():
	var direction = global_position.direction_to(spawn_position)

	velocity = direction * return_speed
	move_and_slide()

	if global_position.distance_to(spawn_position) < 5:
		global_position = spawn_position
		velocity = Vector2.ZERO
		state = State.IDLE


func check_for_player():

	if ray_cast_left.is_colliding():
		var body = ray_cast_left.get_collider()
		if body.is_in_group("Player"):
			start_charge(Vector2.LEFT)
			return

	if ray_cast_right.is_colliding():
		var body = ray_cast_right.get_collider()
		if body.is_in_group("Player"):
			start_charge(Vector2.RIGHT)
			return

	if ray_cast_up.is_colliding():
		var body = ray_cast_up.get_collider()
		if body.is_in_group("Player"):
			start_charge(Vector2.UP)
			return

	if ray_cast_down.is_colliding():
		var body = ray_cast_down.get_collider()
		if body.is_in_group("Player"):
			start_charge(Vector2.DOWN)
			return


func start_charge(direction: Vector2):
	charge_direction = direction
	charge_start_position = global_position
	state = State.CHARGING