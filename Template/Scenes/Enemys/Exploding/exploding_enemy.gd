extends CharacterBody2D

@export var SPEED := 150.0

@export_group("Perematers")
@export var is_a_moving_enemy := true
@export var explotion_timer := 0.5

var direction := 1

@onready var ray_cast_left: RayCast2D = $Collision_checker/RayCast_left
@onready var ray_cast_right: RayCast2D = $Collision_checker/RayCast_right
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var expotion_area: Area2D = $Explodo/expotion_area
@onready var explotion_pirticles: CPUParticles2D = $Explotion_pirticles
@onready var hit_box: Area2D = $Hit_box

func _ready() -> void:
	hit_box.monitoring = false


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

			direction = 1
		if ray_cast_right.is_colliding():

			direction = -1



func Explotion():
	
	expotion_area.call_deferred("queue_free")
	animated_sprite.modulate = Color.RED
	await get_tree().create_timer(explotion_timer).timeout
	animated_sprite.visible = false
	explotion_pirticles.emitting = true
	hit_box.monitoring = true
	await get_tree().create_timer(0.2).timeout
	hit_box.monitoring = false




func _on_area_right_body_exited(_body: Node2D):
	direction = -1
	

func _on_area_left_body_exited(_body: Node2D):
	direction = 1
	

func _on_area_2d_body_entered(body: Node2D):
	
	if body.is_in_group("Player"):
		
		Explotion()


func _on_hit_box_body_entered(body):
	if body.is_in_group("Player") and body.has_method("Death"):
		body.Death()
