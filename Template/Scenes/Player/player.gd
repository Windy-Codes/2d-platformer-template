extends CharacterBody2D

var speed := 250.0
var jump := 200.0

var is_Player_alive := true






func adding_grivity():

    velocity = get_gravity()


# in this methoud we Control the movement of the player by Changing its velocity
# which is a built-in valuse in the charaterbody2d node
# we dosen't need to apply delta time when changing the values of velocity as it is built right into it 

func Player_Movement():
    
    var direction = Input.get_axis("Move_left","Move_right") 

    if direction:

        velocity.x = speed * direction
    



    if is_Player_alive:

        move_and_slide()

func Jump():

    if is_on_floor() and Input.is_action_just_pressed("Jump"):

        velocity.y -= jump

    


