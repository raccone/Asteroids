extends Node


func is_valid(body, body_shape):
	if not is_instance_valid(body):
		return false
	if not body.has_method("update_borders"):
		return false
	if body_shape != 0:
		return false
	return true


func _on_Left_body_shape_entered(body_id, body, body_shape, area_shape):
	if not is_valid(body, body_shape):
		return
	body.update_borders("left", true)


func _on_Left_body_shape_exited(body_id, body, body_shape, area_shape):
	if not is_valid(body, body_shape):
		return
	body.update_borders("left", false)


func _on_Right_body_shape_entered(body_id, body, body_shape, area_shape):
	if not is_valid(body, body_shape):
		return
	body.update_borders("right", true)


func _on_Right_body_shape_exited(body_id, body, body_shape, area_shape):
	if not is_valid(body, body_shape):
		return
	body.update_borders("right", false)


func _on_Top_body_shape_entered(body_id, body, body_shape, area_shape):
	if not is_valid(body, body_shape):
		return
	body.update_borders("top", true)


func _on_Top_body_shape_exited(body_id, body, body_shape, area_shape):
	if not is_valid(body, body_shape):
		return
	body.update_borders("top", false)


func _on_Bottom_body_shape_entered(body_id, body, body_shape, area_shape):
	if not is_valid(body, body_shape):
		return
	body.update_borders("bottom", true)


func _on_Bottom_body_shape_exited(body_id, body, body_shape, area_shape):
	if not is_valid(body, body_shape):
		return
	body.update_borders("bottom", false)
