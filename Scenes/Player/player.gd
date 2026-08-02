extends CharacterBody2D

var speed := 250.0

var jump := 200.0








# in this methoud we Control the movement of the player by Changing its velocity
# which is a built-in valuse in the charaterbody2d node
# we dosen't need to apply delta time when changing the values of velocity as it is built right into it 

func Player_Movement():
    
    var direction = Input.get_axis("Move_left","Move_right") 

    


