extends Node3D

# Endless Swarm - Main script

@onready var units_container: Node3D = $Units
@onready var gates_container: Node3D = $Gates
@onready var camera: Camera3D = $Camera3D

var unit_count: int = 5
var unit_speed: float = 8.0

func _ready() -> void:
	print("Endless Swarm prototype started")
	spawn_starting_units()
	spawn_gates()

func spawn_starting_units() -> void:
	for i in range(unit_count):
		var unit = create_simple_unit()
		# Spawn near the camera (higher Z) so they walk away into the distance (-Z)
		unit.position = Vector3(randf_range(-2.5, 2.5), 0.5, 8.0 + i * 0.25)
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

func spawn_gates() -> void:
	# Simple visual gates for now (not yet functional)
	var gate_data = [
		{"pos": Vector3(0, 1.5, 0), "text": "x3", "color": Color(0.2, 0.9, 0.3)},
		{"pos": Vector3(0, 1.5, -12), "text": "+100", "color": Color(0.3, 0.6, 1.0)},
		{"pos": Vector3(0, 1.5, -24), "text": "x2", "color": Color(0.2, 0.9, 0.3)},
		{"pos": Vector3(0, 1.5, -36), "text": "÷2", "color": Color(0.95, 0.3, 0.3)},
		{"pos": Vector3(0, 1.5, -48), "text": "x4", "color": Color(0.2, 0.9, 0.3)},
	]

	for data in gate_data:
		var gate = create_gate(data.text, data.color)
		gate.position = data.pos
		gates_container.add_child(gate)

func create_gate(label_text: String, color: Color) -> Node3D:
	var gate = Node3D.new()

	# Left pillar
	var left = CSGBox3D.new()
	left.size = Vector3(0.6, 3.0, 0.6)
	left.position = Vector3(-4.0, 0, 0)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	left.material = mat
	gate.add_child(left)

	# Right pillar
	var right = CSGBox3D.new()
	right.size = Vector3(0.6, 3.0, 0.6)
	right.position = Vector3(4.0, 0, 0)
	right.material = mat
	gate.add_child(right)

	# Top bar
	var top = CSGBox3D.new()
	top.size = Vector3(8.6, 0.5, 0.6)
	top.position = Vector3(0, 1.5, 0)
	top.material = mat
	gate.add_child(top)

	# Label (simple 3D text using a Label3D)
	var label = Label3D.new()
	label.text = label_text
	label.font_size = 64
	label.position = Vector3(0, 2.2, 0)
	label.modulate = Color.WHITE
	gate.add_child(label)

	return gate

func _process(delta: float) -> void:
	# Move units away from camera (towards -Z)
	for unit in units_container.get_children():
		unit.position.z -= unit_speed * delta
