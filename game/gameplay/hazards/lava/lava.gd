class_name Lava extends AttackBase

@onready var sprite: Sprite2D = $offset/sprite
@onready var collision: CollisionShape2D = $collision
@onready var left_ray: RayCast2D = $left_ray
@onready var right_ray: RayCast2D = $right_ray
@onready var drip_particles: CPUParticles2D = $drip_particles

var sprite_height: int:
	get:
		return sprite.texture.get_height()

var start_y: float:
	get:
		return left_ray.global_position.y

var sprite_material: ShaderMaterial:
	get:
		return sprite.material

var height: float:
	get:
		var left_hit_point: Vector2 = left_ray.get_collision_point()
		var right_hit_point: Vector2 = right_ray.get_collision_point()
		if left_ray.is_colliding() or right_ray.is_colliding():
			return min(
				left_ray.get_collision_point().y - start_y, 
				right_ray.get_collision_point().y - start_y)
		else:
			return sprite_height

var height_ratio: float:
	get:
		return height / left_ray.target_position.y

func _process(delta: float) -> void:
	if height_ratio <= 1:
		drip_particles.show()
		drip_particles.position.y = height - sprite_height / 2
	else:
		drip_particles.hide()
	sprite_material.set_shader_parameter("amount", height_ratio)
	collision.shape.size.y = height
	collision.position.y = height / 2 - sprite_height / 2
