extends MeshInstance3D

func _ready() -> void:
	var array_mesh = mesh as ArrayMesh
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(array_mesh, 0)
	
	for i in mdt.get_face_count():
		var color = Color(randf(), randf(), randf())
		for vi in 3:
			var vert = mdt.get_face_vertex(i, vi)
			mdt.set_vertex_color(vert, color)
	
	#for i in mdt.get_vertex_count():
		#mdt.set_vertex_color(i, Color(randf(), randf(), randf()))
	
	mdt.commit_to_surface(array_mesh)
