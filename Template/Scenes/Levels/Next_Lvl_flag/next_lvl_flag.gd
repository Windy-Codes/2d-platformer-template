extends Area2D


@export var next_scene := preload("res://Template/Scenes/Levels/Debug/test_lvl_2.tscn")


func load_next_scene():

    SceneTransitions.Scene_Change(next_scene)



func _on_body_entered(body: Node2D):

    if body.is_in_group("Player"):
        load_next_scene()












