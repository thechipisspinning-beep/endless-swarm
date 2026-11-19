extends Node3D

# Endless Swarm - Main script (very early prototype)

@onready var units_container: Node3D = $Units
@onready var camera: Camera3D = $Camera3D

var unit_count: int = 5
var unit_speed: float = 6.0

func _ready() -> void:
	print("Endless Swarm prototype started")
	spawn_starting_units()

func spawn_starting_units() -> void:
	# Placeholder: later we will spawn real units based on unlocked slots + rarity
	for i in range(unit_count):
		var unit = create_simple_unit()
		unit.position = Vector3(randf_range(-3.0, 3.0), 0.5, -5.0 + i * 0.3)
		units_container.add_child(unit)

func create_simple_unit() -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = 0.35
	sphere.height = 0.7
	mesh_instance.mesh = sphere

	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.7, 1.0)
	mesh_instance.material_override = material

	return mesh_instance

func _process(delta: float) -> void:
	# Temporary: move all units forward
	for unit in units_container.get_children():
		unit.position.z += unit_speed * delta
