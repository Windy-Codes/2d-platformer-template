extends Area2D

@export var one_shot_zone := false
@export var  Damage := 25


func _on_body_entered(body: Node2D):

    if one_shot_zone == false:
         if body.is_in_group("Player") and body.has_method("Take_Damage"):
            body.Take_Damage(Damage)
    else:
        if body.is_in_group("Player") and body.has_method("Death"):
            body.Death()
