extends Bullet

@export var secondary_bullet_scene: PackedScene
@export var secondary_damage: float = 20

func _on_damage_box_hit():
	spawn_bullet(Vector2.LEFT)
	spawn_bullet(Vector2.RIGHT)
	spawn_bullet(Vector2.UP)
	spawn_bullet(Vector2.DOWN)
	super()


func spawn_bullet(bullet_direction: Vector2):
	if not secondary_bullet_scene: return
	var tower_layer = get_tree().get_first_node_in_group("tower_layer")
	if not tower_layer: return
	var bullet: Bullet = secondary_bullet_scene.instantiate() as Bullet
	bullet.damage = secondary_damage
	bullet.global_position = global_position
	bullet.target_pos = global_position + bullet_direction * 500
	bullet.ignore_id = "%d"%id
	tower_layer.call_deferred("add_child", bullet)
	
	
