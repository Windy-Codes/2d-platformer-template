extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.visible = false


func Scene_Change( Changing_Scene ):
	color_rect.visible = true
	animation_player.play("Fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(Changing_Scene)
	animation_player.play("Fade_in")
	await animation_player.animation_finished
	color_rect.visible = false
