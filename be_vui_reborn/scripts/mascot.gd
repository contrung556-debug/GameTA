extends Node3D
## Original procedural 3D mascot. No borrowed Talking Tom artwork.
var body_root: Node3D
var t := 0.0

func _ready() -> void:
 body_root=Node3D.new()
 add_child(body_root)
 _oval("Body",Vector3(0,0.95,0),Vector3(0.73,0.93,0.58),Color("#888b9d"))
 _oval("White belly",Vector3(0,0.89,0.46),Vector3(0.55,0.7,0.2),Color("#fff6f1"))
 _oval("Head",Vector3(0,2.2,0.15),Vector3(1.12,0.97,0.88),Color("#a1a5b5"))
 for side in [-1.0,1.0]:
  _oval("Ear",Vector3(side*0.79,2.94,0.12),Vector3(0.38,0.55,0.25),Color("#888a9d"))
  _oval("Pink ear",Vector3(side*0.8,2.98,0.35),Vector3(0.24,0.36,0.10),Color("#ff9bb6"))
  _oval("Eye white",Vector3(side*0.45,2.35,0.85),Vector3(0.33,0.39,0.19),Color("#fffefd"))
  _oval("Green iris",Vector3(side*0.43,2.31,1.025),Vector3(0.20,0.25,0.08),Color("#4dd67b"))
  _oval("Pupil",Vector3(side*0.43,2.31,1.092),Vector3(0.11,0.16,0.04),Color("#142e33"))
  _oval("Eye sparkle",Vector3(side*0.48-0.04,2.4,1.13),Vector3(0.055,0.07,0.018),Color.WHITE)
  _oval("Cheek",Vector3(side*0.75,1.98,0.85),Vector3(0.28,0.18,0.1),Color("#ffa7b8"))
  _oval("Arm",Vector3(side*0.78,1.05,0.18),Vector3(0.29,0.52,0.3),Color("#9498aa"))
  _oval("Foot",Vector3(side*0.45,0.24,0.43),Vector3(0.37,0.26,0.5),Color("#777b90"))
  for stripe in range(2):
   _oval("Face stripe",Vector3(side*(0.38+stripe*0.18),2.77-stripe*0.11,0.77),Vector3(0.13,0.045,0.055),Color("#656b7f"))
 _oval("Left muzzle",Vector3(-0.22,1.98,0.94),Vector3(0.38,0.25,0.2),Color("#fff9f5"))
 _oval("Right muzzle",Vector3(0.22,1.98,0.94),Vector3(0.38,0.25,0.2),Color("#fff9f5"))
 _oval("Nose",Vector3(0,2.1,1.14),Vector3(0.16,0.11,0.1),Color("#ff789a"))
 _oval("Smile",Vector3(0,1.84,1.1),Vector3(0.31,0.10,0.065),Color("#63314e"))
 _oval("Tongue",Vector3(0,1.81,1.16),Vector3(0.17,0.06,0.025),Color("#ff829b"))
 _oval("Blue shirt",Vector3(0,1.04,0.45),Vector3(0.59,0.51,0.24),Color("#2787ee"))
 _oval("Shirt star",Vector3(0,1.13,0.67),Vector3(0.15,0.15,0.04),Color("#ffe05b"))
 _box("Graduation cap",Vector3(0,3.26,0.06),Vector3(1.68,0.13,1.18),Color("#2665d4"))
 _box("Cap crown",Vector3(0,3.13,0.06),Vector3(0.87,0.28,0.72),Color("#1f52ae"))
 _oval("Gold tassel",Vector3(0.8,3.05,0.5),Vector3(0.07,0.29,0.07),Color("#ffd74d"))
 _oval("Tail",Vector3(-0.89,0.65,-0.28),Vector3(0.25,0.67,0.25),Color("#777b90"))

func _process(delta: float) -> void:
 t+=delta
 body_root.position.y=sin(t*2.3)*0.055
 body_root.rotation.y=sin(t*0.9)*0.06

func _oval(name: String,pos: Vector3,scale: Vector3,color: Color) -> void:
 var n:=MeshInstance3D.new()
 n.name=name
 n.mesh=SphereMesh.new()
 n.position=pos
 n.scale=scale
 var mat:=StandardMaterial3D.new()
 mat.albedo_color=color
 mat.roughness=0.32
 mat.metallic=0.02
 n.material_override=mat
 body_root.add_child(n)

func _box(name: String,pos: Vector3,size: Vector3,color: Color) -> void:
 var n:=MeshInstance3D.new()
 n.name=name
 var mesh:=BoxMesh.new()
 mesh.size=size
 n.mesh=mesh
 n.position=pos
 var mat:=StandardMaterial3D.new()
 mat.albedo_color=color
 mat.roughness=0.35
 n.material_override=mat
 body_root.add_child(n)
