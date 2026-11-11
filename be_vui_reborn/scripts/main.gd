extends Node3D
## New clean foundation: art assets and gameplay are separated.
## The placeholder scene is intentionally NOT presented as final 3D art.
const LESSONS := {
 "Trường học": [["book","quyển sách"],["pen","cây bút"],["teacher","giáo viên"]],
 "Siêu thị": [["apple","quả táo"],["milk","sữa"],["bread","bánh mì"]],
 "Nhà hàng": [["rice","cơm"],["water","nước"],["fish","cá"]],
 "Bệnh viện": [["doctor","bác sĩ"],["hand","bàn tay"],["eye","mắt"]],
 "Công viên": [["tree","cây"],["flower","hoa"],["bird","chim"]]
}
var stars := 0
var current_place := ""
var question := 0
var status: Label
var answers: VBoxContainer
var scene_root: Node3D
var cat: Node3D
var camera: Camera3D
var selected_button: Button

func _ready() -> void:
 _load()
 _create_scene()
 _create_ui()

func _create_scene() -> void:
 scene_root=Node3D.new()
 scene_root.name="ART_ROOT_replace_with_professional_3d_assets"
 add_child(scene_root)
 var world:=WorldEnvironment.new()
 var env:=Environment.new()
 env.background_mode=Environment.BG_COLOR
 env.background_color=Color("#a4dfff")
 env.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
 env.ambient_light_color=Color("#fff4e7")
 env.ambient_light_energy=0.9
 world.environment=env
 add_child(world)
 var light:=DirectionalLight3D.new()
 light.rotation_degrees=Vector3(-45,-35,0)
 light.light_energy=1.3
 light.shadow_enabled=true
 add_child(light)
 camera=Camera3D.new()
 camera.projection=Camera3D.PROJECTION_ORTHOGONAL
 camera.size=17.0
 camera.position=Vector3(12,15,19)
 add_child(camera)
 camera.look_at(Vector3.ZERO)
 camera.current=true
 _box("Ground",Vector3(0,-0.15,0),Vector3(26,0.3,18),Color("#a1d99a"))
 _box("Path",Vector3(0,0.01,0),Vector3(24,0.05,2.3),Color("#f5d9b7"))
 for i in range(5):
  var angle:=float(i)*TAU/5.0
  var position:=Vector3(cos(angle)*8.0,0,sin(angle)*5.0)
  _box("ART SLOT "+str(i),position+Vector3(0,0.8,0),Vector3(2.5,1.6,2.3),Color("#e9dcf5"))
  _box("Roof placeholder",position+Vector3(0,1.7,0),Vector3(2.9,0.3,2.7),Color("#b6a3dc"))
 # Intentional marker, not a pretend polished mascot.
 cat=Node3D.new()
 cat.name="CAT_3D_ASSET_SLOT"
 cat.position=Vector3(0,0,3)
 scene_root.add_child(cat)
 var sphere:=SphereMesh.new()
 sphere.radius=0.45
 sphere.height=0.9
 var marker:=MeshInstance3D.new()
 marker.mesh=sphere
 marker.position.y=0.5
 marker.material_override=_material(Color("#a3a5bf"))
 cat.add_child(marker)

func _material(color: Color) -> StandardMaterial3D:
 var m:=StandardMaterial3D.new()
 m.albedo_color=color
 m.roughness=0.65
 return m

func _box(name: String,p: Vector3,dimensions: Vector3,color: Color) -> void:
 var n:=MeshInstance3D.new()
 n.name=name
 var mesh:=BoxMesh.new()
 mesh.size=dimensions
 n.mesh=mesh
 n.position=p
 n.material_override=_material(color)
 scene_root.add_child(n)

func _create_ui() -> void:
 var layer:=CanvasLayer.new()
 add_child(layer)
 var root:=Control.new()
 root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 layer.add_child(root)
 var top:=HBoxContainer.new()
 top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
 top.offset_left=20
 top.offset_right=-20
 top.offset_top=16
 root.add_child(top)
 var heading:=Label.new()
 heading.text="BÉ VUI ENGLISH • REBORN"
 heading.add_theme_font_size_override("font_size",28)
 heading.add_theme_color_override("font_color",Color("#43256e"))
 heading.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 top.add_child(heading)
 status=Label.new()
 status.add_theme_font_size_override("font_size",24)
 status.add_theme_color_override("font_color",Color("#43256e"))
 top.add_child(status)
 var menu:=VBoxContainer.new()
 menu.position=Vector2(22,95)
 menu.add_theme_constant_override("separation",10)
 root.add_child(menu)
 for place in LESSONS.keys():
  var b:=Button.new()
  b.text=place
  b.custom_minimum_size=Vector2(170,48)
  _decorate_button(b,Color("#7548d9"))
  b.pressed.connect(_start_lesson.bind(place))
  menu.add_child(b)
 var overlay:=PanelContainer.new()
 overlay.name="LessonOverlay"
 overlay.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
 overlay.custom_minimum_size=Vector2(430,350)
 overlay.position=Vector2(-215,-175)
 overlay.visible=false
 var panel_style:=StyleBoxFlat.new()
 panel_style.bg_color=Color("#fff4df")
 panel_style.set_corner_radius_all(26)
 panel_style.set_border_width_all(5)
 panel_style.border_color=Color("#ffffff")
 panel_style.shadow_color=Color(0.25,0.14,0.4,0.35)
 panel_style.shadow_size=15
 overlay.add_theme_stylebox_override("panel",panel_style)
 root.add_child(overlay)
 answers=VBoxContainer.new()
 answers.add_theme_constant_override("separation",12)
 overlay.add_child(answers)
 _update_status()

func _start_lesson(place: String) -> void:
 current_place=place
 question=0
 _render_question()

func _render_question() -> void:
 for child in answers.get_children(): child.queue_free()
 var overlay:=answers.get_parent() as Control
 overlay.visible=true
 var words: Array=LESSONS[current_place]
 if question>=words.size():
  var done:=Label.new()
  done.text="Hoàn thành! +3 sao"
  answers.add_child(done)
  stars+=3
  _save()
  _update_status()
  var close:=Button.new()
  close.text="Quay về thành phố"
  close.pressed.connect(func(): overlay.visible=false)
  answers.add_child(close)
  return
 var entry: Array=words[question]
 var title:=Label.new()
 title.text="%s — %d/%d" % [current_place,question+1,words.size()]
 title.add_theme_font_size_override("font_size",26)
 answers.add_child(title)
 var prompt:=Label.new()
 prompt.text="Chọn tiếng Anh của: %s" % entry[1]
 answers.add_child(prompt)
 var options: Array[String]=[str(entry[0])]
 for i in range(1,3):
  options.append(str(words[(question+i)%words.size()][0]))
 options.shuffle()
 for option in options:
  var b:=Button.new()
  b.text=option
  b.custom_minimum_size=Vector2(360,52)
  _decorate_button(b,Color("#7953d6"))
  b.pressed.connect(_choose.bind(option,str(entry[0])))
  answers.add_child(b)
 var exit:=Button.new()
 exit.text="Đóng"
 exit.pressed.connect(func(): overlay.visible=false)
 answers.add_child(exit)

func _choose(chosen: String,correct: String) -> void:
 if chosen==correct:
  question+=1
  _render_question()
 else:
  var tip:=AcceptDialog.new()
  tip.dialog_text="Thử lại nhé!"
  add_child(tip)
  tip.popup_centered()
  tip.confirmed.connect(tip.queue_free)

func _decorate_button(b: Button,color: Color) -> void:
 b.add_theme_font_size_override("font_size",22)
 b.add_theme_color_override("font_color",Color.WHITE)
 b.add_theme_color_override("font_hover_color",Color.WHITE)
 b.add_theme_color_override("font_pressed_color",Color.WHITE)
 var style:=StyleBoxFlat.new()
 style.bg_color=color
 style.set_corner_radius_all(17)
 style.set_border_width_all(3)
 style.border_color=Color("#ffffff")
 style.shadow_color=Color(0.3,0.16,0.47,0.3)
 style.shadow_size=6
 b.add_theme_stylebox_override("normal",style)
 var hover:=style.duplicate() as StyleBoxFlat
 hover.bg_color=color.lightened(0.2)
 b.add_theme_stylebox_override("hover",hover)
 var pressed:=style.duplicate() as StyleBoxFlat
 pressed.bg_color=color.darkened(0.15)
 b.add_theme_stylebox_override("pressed",pressed)

func _update_status() -> void:
 status.text="⭐ %d" % stars

func _load() -> void:
 if not FileAccess.file_exists("user://save.json"): return
 var file:=FileAccess.open("user://save.json",FileAccess.READ)
 if file==null:return
 var data=JSON.parse_string(file.get_as_text())
 if data is Dictionary: stars=int(data.get("stars",0))

func _save() -> void:
 var file:=FileAccess.open("user://save.json",FileAccess.WRITE)
 if file!=null: file.store_string(JSON.stringify({"stars":stars}))
