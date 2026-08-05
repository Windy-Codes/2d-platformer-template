extends CharacterBody2D

@export var SPEED := 150.0

@export_group("Perematers")
@export var is_a_moving_enemy := true
@export var Damage := 25

var direction := 1

@onready var ray_cast_left: RayCast2D = $Collision_checker/RayCast_left
@onready var ray_cast_right: RayCast2D = $Collision_checker/RayCast_right



func _physics_process(_delta: float) -> void:
	Movement()

func _process(_delta: float) -> void:

	Ray_collision()





func Movement():

	if is_a_moving_enemy:
		velocity.x = SPEED * direction


	move_and_slide()



func Ray_collision():

	if ray_cast_left.is_colliding():
		var body = ray_cast_left.get_collider()
		if body and !body.is_in_group("Player"):
			direction = -1

	if ray_cast_right.is_colliding():
		var body = ray_cast_right.get_collider()
		if body and !body.is_in_group("Player"):
			direction = 1





func _on_area_right_body_exited(_body: Node2D):
	direction = -1
	

func _on_area_left_body_exited(_body: Node2D):
	direction = 1
	



func _on_hit_box_body_entered(body: Node2D):
	
	if body.is_in_group("Player") and body.has_method("Take_Damage"):
		body.Take_Damage(Damage)
