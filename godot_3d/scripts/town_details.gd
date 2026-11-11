extends Node3D
## Rich procedural 3D decoration for the town.
## Uses real mesh geometry, layered materials, bevelled roofs and garden props.

func mat(color: Color, metal: float = 0.0) -> StandardMaterial3D:
 var m := StandardMaterial3D.new()
 m.albedo_color=color
 m.metallic=metal
 m.roughness=0.6
 return m

func box(parent: Node3D, name: String, p: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
 var n:=MeshInstance3D.new()
 n.name=name
 var mesh:=BoxMesh.new()
 mesh.size=size
 n.mesh=mesh
 n.material_override=mat(color)
 n.position=p
 parent.add_child(n)
 return n

func ball(parent: Node3D,name: String,p: Vector3,r: float,color: Color,shape: Vector3=Vector3.ONE) -> MeshInstance3D:
 var n:=MeshInstance3D.new()
 n.name=name
 var mesh:=SphereMesh.new()
 mesh.radius=r
 mesh.height=r*2.0
 mesh.radial_segments=20
 mesh.rings=10
 n.mesh=mesh
 n.material_override=mat(color)
 n.position=p
 n.scale=shape
 parent.add_child(n)
 return n

func cylinder(parent: Node3D,name: String,p: Vector3,r: float,h: float,color: Color) -> MeshInstance3D:
 var n:=MeshInstance3D.new()
 n.name=name
 var mesh:=CylinderMesh.new()
 mesh.top_radius=r
 mesh.bottom_radius=r
 mesh.height=h
 n.mesh=mesh
 n.material_override=mat(color)
 n.position=p
 parent.add_child(n)
 return n

func cone(parent: Node3D,name: String,p: Vector3,r: float,h: float,color: Color) -> MeshInstance3D:
 var n:=MeshInstance3D.new()
 n.name=name
 var mesh:=CylinderMesh.new()
 mesh.top_radius=0.05
 mesh.bottom_radius=r
 mesh.height=h
 n.mesh=mesh
 n.material_override=mat(color)
 n.position=p
 parent.add_child(n)
 return n

func sign(parent: Node3D,text: String,p: Vector3,color: Color=Color("#6041a0"),font_size: int=36) -> void:
 var l:=Label3D.new()
 l.text=text
 l.font_size=font_size
 l.pixel_size=0.006
 l.modulate=color
 l.outline_size=8
 l.position=p
 l.billboard=BaseMaterial3D.BILLBOARD_ENABLED
 l.no_depth_test=true
 parent.add_child(l)

func _ready() -> void:
 _decorate_school()
 _decorate_hospital()
 _decorate_supermarket()
 _decorate_market()
 _decorate_restaurant()
 _decorate_park()
 _street_furniture()
 _cat_details()
 _landscape_details()

func _decorate_school() -> void:
 var root:=Node3D.new()
 root.position=Vector3(-6,0,-4)
 root.name="School architecture"
 add_child(root)
 for x in [-2.1,2.1]:
  cylinder(root,"Ivory column",Vector3(x,1.7,1.85),0.20,3.3,Color("#fff7e8"))
  box(root,"Column capital",Vector3(x,3.34,1.85),Vector3(0.56,0.24,0.58),Color("#fef0cf"))
 box(root,"School stairs",Vector3(0,0.20,2.55),Vector3(2.5,0.28,1.2),Color("#fff2dd"))
 box(root,"School stair edge",Vector3(0,0.07,3.20),Vector3(3.0,0.14,0.5),Color("#e4d3c5"))
 for x in [-1.7,1.7]:
  box(root,"Roof flag",Vector3(x,4.0,0),Vector3(0.12,1.25,0.12),Color("#ffffff"))
  box(root,"Flag cloth",Vector3(x+0.35,4.4,0),Vector3(0.7,0.45,0.06),Color("#ff83ad"))
 sign(root,"ABC",Vector3(0,3.75,2.02),Color("#7a3dca"),45)
 for x in [-1.4,1.4]:
  _flower_pot(root,Vector3(x,0,2.2),Color("#ff8caf"))

func _decorate_hospital() -> void:
 var root:=Node3D.new()
 root.position=Vector3(0,0,-5)
 root.name="Hospital details"
 add_child(root)
 box(root,"Entrance canopy",Vector3(0,1.55,2.15),Vector3(2.5,0.25,1.2),Color("#6ac5f3"))
 for x in [-1.05,1.05]:
  cylinder(root,"Entrance post",Vector3(x,0.8,2.6),0.10,1.6,Color("#ffffff"))
 box(root,"Medical sign board",Vector3(0,4.15,2.0),Vector3(1.45,1.05,0.18),Color("#ffffff"))
 box(root,"Medical cross vertical",Vector3(0,4.15,2.12),Vector3(0.25,0.77,0.08),Color("#ff607a"))
 box(root,"Medical cross horizontal",Vector3(0,4.15,2.13),Vector3(0.75,0.25,0.08),Color("#ff607a"))
 for x in [-1.5,1.5]:
  _flower_pot(root,Vector3(x,0,2.0),Color("#f5a6e0"))

func _decorate_supermarket() -> void:
 var root:=Node3D.new()
 root.position=Vector3(6,0,-4)
 root.name="Supermarket details"
 add_child(root)
 box(root,"Wide entrance awning",Vector3(0,2.4,2.12),Vector3(3.6,0.34,1.0),Color("#9d69da"))
 for x in [-1.5,-0.9,-0.3,0.3,0.9,1.5]:
  box(root,"Striped awning",Vector3(x,2.27,2.57),Vector3(0.27,0.14,0.24),
   Color("#fff2ff") if int((x+1.5)*10)%2==0 else Color("#e79be5"))
 for x in [-1.6,1.6]:
  _flower_pot(root,Vector3(x,0,2.3),Color("#ffdc6e"))
 box(root,"Shopping cart basket",Vector3(2.2,0.8,2.5),Vector3(0.8,0.48,0.55),Color("#c1e5f4"))
 for x in [1.95,2.45]:
  ball(root,"Cart wheel",Vector3(x,0.35,2.7),0.13,Color("#555a77"))
 sign(root,"SHOP",Vector3(0,3.8,2.0),Color("#7332b0"),36)

func _decorate_market() -> void:
 var root:=Node3D.new()
 root.position=Vector3(-7,0,3)
 root.name="Market stall details"
 add_child(root)
 for x in [-1.5,1.5]:
  cylinder(root,"Canopy post",Vector3(x,1.25,2.25),0.10,2.5,Color("#fff6e5"))
 for i in range(6):
  var x: float=-1.3+float(i)*0.52
  box(root,"Candy canopy",Vector3(x,2.55,2.1),Vector3(0.52,0.28,1.1),
   Color("#ff6e9e") if i%2==0 else Color("#fff7e6"))
 box(root,"Fruit counter",Vector3(0,0.9,2.3),Vector3(3.1,0.32,0.8),Color("#c98b62"))
 for i in range(12):
  var x: float=-1.3+float(i%6)*0.48
  var z: float=2.1+float(i/6)*0.36
  ball(root,"Fruit",Vector3(x,1.22,z),0.21,
   [Color("#ff6669"),Color("#ffce4e"),Color("#8fdc76")][i%3])
 sign(root,"FRESH",Vector3(0,2.85,2.35),Color("#8c3c82"),30)

func _decorate_restaurant() -> void:
 var root:=Node3D.new()
 root.position=Vector3(7,0,3)
 root.name="Restaurant terrace"
 add_child(root)
 box(root,"Terrace",Vector3(0,0.15,3.1),Vector3(5.5,0.25,3.0),Color("#f6d4ac"))
 for x in [-1.7,1.7]:
  cylinder(root,"Cafe table",Vector3(x,0.85,3.0),0.65,0.12,Color("#ffffff"))
  cylinder(root,"Table leg",Vector3(x,0.48,3.0),0.10,0.72,Color("#9a78bd"))
  for z in [-0.85,0.85]:
   box(root,"Cafe chair",Vector3(x,0.48,3.0+z),Vector3(0.7,0.2,0.65),Color("#a6d5ff"))
   box(root,"Chair back",Vector3(x,0.83,3.0+z+0.26),Vector3(0.7,0.8,0.14),Color("#8dc3f5"))
 box(root,"Menu board",Vector3(0,1.1,2.15),Vector3(1.3,1.8,0.18),Color("#6e4b7d"))
 sign(root,"MENU",Vector3(0,1.5,2.30),Color("#ffffff"),26)
 for x in [-2.0,2.0]:
  _flower_pot(root,Vector3(x,0,1.9),Color("#ffc16d"))

func _decorate_park() -> void:
 var root:=Node3D.new()
 root.position=Vector3(0,0,5)
 root.name="Park details"
 add_child(root)
 for x in [-2.0,2.0]:
  box(root,"Park bench seat",Vector3(x,0.52,0),Vector3(1.2,0.16,0.45),Color("#bd875d"))
  box(root,"Park bench back",Vector3(x,0.88,-0.17),Vector3(1.2,0.6,0.12),Color("#d59b6b"))
  for dx in [-0.45,0.45]:
   box(root,"Bench leg",Vector3(x+dx,0.26,0),Vector3(0.10,0.50,0.10),Color("#715b69"))
 for i in range(18):
  var a: float=float(i)*TAU/18.0
  _flower(root,Vector3(cos(a)*2.0,0,sin(a)*1.45),
   Color("#ff7eb9") if i%2==0 else Color("#ffdc5b"))
 for x in [-1.0,1.0]:
  cone(root,"Playground roof",Vector3(x,2.15,0),0.72,0.7,Color("#ffcc4c"))
  cylinder(root,"Playground pole",Vector3(x,1.05,0),0.12,1.8,Color("#fa9a55"))

func _street_furniture() -> void:
 for x in [-13.0,-10.0,10.0,13.0]:
  _lamp(Vector3(x,0,-0.6))
  _lamp(Vector3(x,0,2.8))
 for x in [-12.0,12.0]:
  _flower_pot(self,Vector3(x,0,4.0),Color("#ff9cb8"))
  _flower_pot(self,Vector3(x,0,-5.5),Color("#ffe48c"))
 for x in [-11.0,11.0]:
  box(self,"Crosswalk stripe",Vector3(x,0.075,1.0),Vector3(0.20,0.02,2.2),Color("#fff8e9"))
  for i in range(5):
   box(self,"Crosswalk bar",Vector3(x+float(i)*0.33,0.077,1.0),
    Vector3(0.20,0.02,2.2),Color("#fff8e9"))
 for i in range(12):
  var x: float=-14.0+float(i)*2.5
  if absf(x)<3.0: continue
  ball(self,"Flowering bush",Vector3(x,0.28,8.8),0.40,
   Color("#f99fc1") if i%2==0 else Color("#6dd89d"),
   Vector3(1.1,0.7,0.8))

func _lamp(p: Vector3) -> void:
 var root:=Node3D.new()
 root.position=p
 add_child(root)
 cylinder(root,"Lamp post",Vector3(0,1.3,0),0.09,2.6,Color("#736d9c"))
 ball(root,"Lamp glow",Vector3(0,2.73,0),0.34,Color("#fff2a5"))
 cone(root,"Lamp shade",Vector3(0,2.94,0),0.52,0.34,Color("#7a65b7"))

func _flower_pot(parent: Node3D,p: Vector3,flower_color: Color) -> void:
 cylinder(parent,"Flower pot",p+Vector3(0,0.3,0),0.34,0.6,Color("#d78b62"))
 ball(parent,"Leaves",p+Vector3(0,0.72,0),0.43,Color("#52b979"))
 for i in range(5):
  var a: float=float(i)*TAU/5.0
  ball(parent,"Petal",p+Vector3(cos(a)*0.26,0.93,sin(a)*0.26),
   0.15,flower_color)

func _flower(parent: Node3D,p: Vector3,color: Color) -> void:
 cylinder(parent,"Flower stem",p+Vector3(0,0.25,0),0.04,0.5,Color("#4eae65"))
 for i in range(5):
  var a: float=float(i)*TAU/5.0
  ball(parent,"Flower petal",p+Vector3(cos(a)*0.16,0.58,sin(a)*0.16),0.14,color)
 ball(parent,"Flower center",p+Vector3(0,0.6,0),0.12,Color("#ffe46a"))

func _cat_details() -> void:
 var cat:=get_node_or_null("../BeVuiCat") as Node3D
 if cat==null: return
 for side in [-1.0,1.0]:
  for i in range(3):
   var z: float=0.72+float(i)*0.05
   var y: float=1.43+float(i)*0.10
   box(cat,"Whisker",Vector3(side*0.63,y,z),Vector3(0.37,0.018,0.025),Color("#6c7086"))
  for i in range(2):
   ball(cat,"Eyebrow",Vector3(side*0.32,1.95,0.72),0.07,Color("#717e99"),
    Vector3(2.1,0.4,0.5))
 for i in range(3):
  box(cat,"Forehead stripe",Vector3(-0.20+float(i)*0.2,2.12,0.64),
   Vector3(0.07,0.20,0.04),Color("#7c88a2"))
 ball(cat,"Tail",Vector3(0.48,0.75,-0.52),0.22,Color("#a0abc1"),
  Vector3(0.75,1.9,0.75))
 ball(cat,"Tail tip",Vector3(0.63,1.12,-0.6),0.22,Color("#7887a6"))
 box(cat,"Hat gold trim",Vector3(0,2.47,0.15),Vector3(1.28,0.05,1.18),Color("#ffd36c"))
 ball(cat,"Hat tassel",Vector3(0.68,2.21,0.4),0.13,Color("#ffe064"))
 box(cat,"Shirt emblem",Vector3(0,0.93,0.46),Vector3(0.20,0.25,0.04),Color("#ffe076"))

func _landscape_details() -> void:
 # Soft, layered park edges and tiled walkways make the town feel handcrafted.
 for i in range(15):
  var x: float=-14.0+float(i)*2.0
  for z in [-7.6,7.6]:
   if absf(x)<2.0 and z>0.0: continue
   ball(self,"Round shrub",Vector3(x,0.38,z),0.48,
    Color("#53bf83") if i%3==0 else Color("#86da94"),Vector3(1.3,0.7,1.0))
   if i%3==0:
    ball(self,"Shrub bloom",Vector3(x-0.15,0.7,z),0.18,Color("#ffc5e5"))
 for i in range(12):
  var x: float=-13.0+float(i)*2.3
  if absf(x)<3.0: continue
  for z in [-1.65,3.65]:
   box(self,"Paving stone",Vector3(x,0.13,z),Vector3(1.6,0.06,0.50),Color("#ffe9d6"))
 for i in range(8):
  var x: float=-13.0+float(i)*3.5
  if absf(x)<2.0: continue
  _balloon_group(Vector3(x,0,9.5),i)
 for i in range(5):
  var x: float=-12.0+float(i)*6.0
  _decorative_cloud(Vector3(x,9.0,-12.0),0.9+float(i%3)*0.25)

func _balloon_group(p: Vector3,variant: int) -> void:
 var root:=Node3D.new()
 root.position=p
 add_child(root)
 for i in range(3):
  var x: float=float(i-1)*0.34
  var y: float=1.6+float((i+variant)%3)*0.30
  cylinder(root,"Balloon string",Vector3(x*0.5,y*0.5,0),0.015,y,
   Color("#fff4e5"))
  ball(root,"Party balloon",Vector3(x,y,0),0.29,
   [Color("#ff82ad"),Color("#ffdb63"),Color("#8dd9ff")][i],
   Vector3(0.86,1.20,0.86))

func _decorative_cloud(p: Vector3,size: float) -> void:
 var root:=Node3D.new()
 root.position=p
 root.scale=Vector3.ONE*size
 add_child(root)
 for i in range(4):
  ball(root,"Cloud puff",Vector3(float(i)*0.75,0.15+float(i%2)*0.22,0),
   0.75,Color("#ffffff"),Vector3(1.1,0.7,0.85))
