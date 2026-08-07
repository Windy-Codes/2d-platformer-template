extends CanvasLayer


@onready var fruit_score_shadow: Label = $Main_Fruit_Score/Fruit_Score_Shadow
@onready var fruit_score: Label = $Main_Fruit_Score/Fruit_Score


func _process(_delta: float) -> void:
    Fruit_Score_Updater()



func Fruit_Score_Updater():

    fruit_score.text = str(ScoreManager.Current_fruits_number)
    fruit_score_shadow.text = fruit_score.text

