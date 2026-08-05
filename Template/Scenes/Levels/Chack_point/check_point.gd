extends Marker2D




func _on_area_2d_body_entered(body: Node2D):
	
	if body.is_in_group("Player"):

		body.chack_point = self
