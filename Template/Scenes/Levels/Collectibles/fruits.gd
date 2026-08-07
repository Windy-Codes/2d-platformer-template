extends Area2D

@export var Add_Fruits := 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collected_sound: AudioStreamPlayer2D = $Collected_Sound
@onready var collected_effect: AnimatedSprite2D = $Collected_effect

func _ready() -> void:

    Random_Fruit_picker()
    collected_effect.visible = false


func Random_Fruit_picker():

    var fruit_type : Array = animated_sprite.sprite_frames.get_animation_names()

    animated_sprite.animation = fruit_type.pick_random()

    animated_sprite.play()


func Fruits_adder():

    var Sound_pich = randf_range(0.90, 1.10)

    animated_sprite.visible = false
    ScoreManager.Current_fruits_number += Add_Fruits
    collected_sound.pitch_scale = Sound_pich
    collected_sound.play()
    collected_effect.visible = true
    collected_effect.play()




func _on_body_entered(body: Node2D):
	
    if body.is_in_group("Player"):
        Fruits_adder()
        print(ScoreManager.Current_fruits_number)


func _on_collected_effect_animation_finished():
        call_deferred("queue_free")
