extends Marker2D

var has_actvated : = false


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func animation_player():
	
	if has_actvated == false:
		animated_sprite.play("acivation")
	else:
		animated_sprite.play("idle")



func _on_area_2d_body_entered(body: Node2D):
	
	if body.is_in_group("Player"):
			body.chack_point = self
			animation_player()
			has_actvated = true
			

func _on_animated_sprite_2d_animation_finished():
		animated_sprite.play("idle")



