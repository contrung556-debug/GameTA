extends Node3D
## Playable 3D learning town. All buildings, trees, cat and props are real 3D meshes.
## Tap a location button to travel, learn vocabulary and collect saved stars.

const SKY := Color("#7ccfff")
const PURPLE := Color("#7543d5")
const NAVY := Color("#302265")
const GOLD := Color("#ffc64b")
const WHITE := Color("#ffffff")
const LESSONS := {
 "Trường học": [["book","quyển sách"],["pen","bút"],["desk","bàn học"],["teacher","giáo viên"],["school","trường học"]],
 "Siêu thị": [["apple","quả táo"],["banana","quả chuối"],["milk","sữa"],["bread","bánh mì"],["water","nước"]],
 "Nhà hàng": [["rice","cơm"],["fish","cá"],["chicken","gà"],["soup","súp"],["juice","nước ép"]],
 "Bệnh viện": [["doctor","bác sĩ"],["nurse","y tá"],["hand","bàn tay"],["eye","mắt"],["nose","mũi"]],
 "Chợ": [["carrot","cà rốt"],["orange","quả cam"],["tomato","cà chua"],["egg","trứng"],["potato","khoai tây"]],
 "Công viên": [["tree","cây"],["flower","hoa"],["bird","chim"],["sun","mặt trời"],["grass","cỏ"]]
}
const COLORS := [Color("#ff9db8"),Color("#83d6fa"),Color("#ffe09a"),Color("#c3a2f4"),Color("#91e5b5")]
var stars := 0
var completed := 0
var camera: Camera3D
var cat: Node3D
var destination := Vector3(-5,0,5)
var move_t := 0.0
var ui: Control
var hud: Control
var panel: PanelContainer
var question_index := 0
var question_place := ""
var score_label: Label
var title_label: Label
var answer_buttons: Array[Button] = []
var feedback: Label
var game_paused := false
var locations := {
 "Trường học": Vector3(-6,0,-4),
 "Bệnh viện": Vector3(0,0,-5),
 "Siêu thị": Vector3(6,0,-4),
 "Chợ": Vector3(-7,0,3),
 "Nhà hàng": Vector3(7,0,3),
 "Công viên": Vector3(0,0,5)
}

func _ready() -> void:
 _load_progress()
 _setup_world()
 _setup_ui()

func _process(delta: float) -> void:
 if cat == null: return
 var delta_pos := destination - cat.position
 delta_pos.y = 0
 if delta_pos.length() > 0.1:
  cat.position += delta_pos.normalized() * minf(delta * 3.0,delta_pos.length())
  cat.rotation.y = lerp_angle(cat.rotation.y,atan2(delta_pos.x,delta_pos.z),delta * 7.0)
 move_t += delta
 cat.position.y = sin(move_t * 3.2) * 0.07

func _mat(color: Color, roughness: float = 0.7) -> StandardMaterial3D:
 var m := StandardMaterial3D.new()
 m.albedo_color = color
 m.roughness = roughness
 return m

func _mesh_box(parent: Node3D, name: String, pos: Vector3, scale3: Vector3, color: Color) -> MeshInstance3D:
 var m := MeshInstance3D.new()
 m.name = name
 var box := BoxMesh.new()
 box.size = scale3
 m.mesh = box
 m.material_override = _mat(color)
 m.position = pos
 parent.add_child(m)
 return m

func _sphere(parent: Node3D, name: String, pos: Vector3, radius: float, color: Color, flatten: Vector3 = Vector3.ONE) -> MeshInstance3D:
 var m := MeshInstance3D.new()
 m.name = name
 var sphere := SphereMesh.new()
 sphere.radius = radius
 sphere.height = radius * 2.0
 sphere.radial_segments = 24
 sphere.rings = 12
 m.mesh = sphere
 m.material_override = _mat(color,0.85)
 m.position = pos
 m.scale = flatten
 parent.add_child(m)
 return m

func _cylinder(parent: Node3D, name: String, pos: Vector3, radius: float, height: float, color: Color) -> MeshInstance3D:
 var m := MeshInstance3D.new()
 m.name = name
 var shape := CylinderMesh.new()
 shape.top_radius = radius
 shape.bottom_radius = radius
 shape.height = height
 m.mesh = shape
 m.material_override = _mat(color)
 m.position = pos
 parent.add_child(m)
 return m

func _setup_world() -> void:
 var env := WorldEnvironment.new()
 var e := Environment.new()
 e.background_mode = Environment.BG_COLOR
 e.background_color = SKY
 e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
 e.ambient_light_color = Color("#fff4e8")
 e.ambient_light_energy = 0.8
 e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
 env.environment = e
 add_child(env)
 var sun := DirectionalLight3D.new()
 sun.rotation_degrees = Vector3(-48,-28,0)
 sun.light_energy = 1.15
 sun.shadow_enabled = true
 add_child(sun)
 camera = Camera3D.new()
 camera.projection = Camera3D.PROJECTION_ORTHOGONAL
 camera.size = 23.5
 camera.position = Vector3(16,22,24)
 camera.look_at(Vector3(0,0,0),Vector3.UP)
 camera.current = true
 add_child(camera)
 _mesh_box(self,"Grass",Vector3(0,-0.25,0),Vector3(35,0.4,24),Color("#8bda8a"))
 _mesh_box(self,"Road horizontal",Vector3(0,0.01,1.0),Vector3(33,0.05,2.6),Color("#778aa5"))
 _mesh_box(self,"Road vertical",Vector3(0,0.02,0),Vector3(2.8,0.05,21),Color("#778aa5"))
 for i in range(-15,16,3):
  _mesh_box(self,"Lane",Vector3(float(i),0.045,1),Vector3(1.3,0.01,0.10),Color("#fff4c5"))
 for i in range(-9,10,3):
  _mesh_box(self,"Lane",Vector3(0,0.06,float(i)),Vector3(0.10,0.01,1.3),Color("#fff4c5"))
 _mesh_box(self,"Walkway",Vector3(0,0.04,-1.05),Vector3(33,0.08,0.40),Color("#f8e8cf"))
 _mesh_box(self,"Walkway",Vector3(0,0.04,3.05),Vector3(33,0.08,0.40),Color("#f8e8cf"))
 _building("Trường học",Vector3(-6,0,-4),Color("#ffd58e"),Color("#f07882"),4.2,3.3)
 _building("Bệnh viện",Vector3(0,0,-5),Color("#d5f3ff"),Color("#60ace5"),3.5,3.2)
 _building("Siêu thị",Vector3(6,0,-4),Color("#e7caff"),Color("#9c76dd"),4.2,3.3)
 _building("Chợ",Vector3(-7,0,3),Color("#ffc7d5"),Color("#ff6b9b"),3.2,2.3)
 _building("Nhà hàng",Vector3(7,0,3),Color("#ffe3ac"),Color("#f28b51"),3.2,2.3)
 _park(Vector3(0,0,5))
 for i in range(26):
  var x := -15.0 + float((i*11)%31)
  var z := -9.0 + float((i*7)%19)
  if absf(x) < 2.6 or absf(z-1.0) < 2.0: continue
  if _near_building(Vector3(x,0,z)): continue
  _tree(Vector3(x,0,z),0.75+float(i%4)*0.10)
 _fountain(Vector3(0,0,-0.1))
 _car(Vector3(-4,0.35,1),Color("#ff8099"))
 _car(Vector3(5,0.35,1),Color("#ffca48"))
 _bus(Vector3(10,0.45,1))
 cat = Node3D.new()
 cat.name = "BeVuiCat"
 cat.position = Vector3(-5,0,5)
 add_child(cat)
 _build_cat(cat)

func _near_building(p: Vector3) -> bool:
 for v in locations.values():
  if p.distance_to(v) < 3.3: return true
 return false

func _building(name: String, pos: Vector3, wall: Color, roof: Color, w: float, h: float) -> void:
 var root := Node3D.new()
 root.name = name
 root.position = pos
 add_child(root)
 _mesh_box(root,"Foundation",Vector3(0,0.15,0),Vector3(w+0.35,0.3,3.5),Color("#f6e9d9"))
 _mesh_box(root,"Walls",Vector3(0,h*0.5,0),Vector3(w,h,3.2),wall)
 _mesh_box(root,"Roof",Vector3(0,h+0.25,0),Vector3(w+0.5,0.42,3.7),roof)
 _mesh_box(root,"Roof highlight",Vector3(0,h+0.48,-0.25),Vector3(w+0.3,0.08,2.9),roof.lightened(0.28))
 for row in range(2):
  for col in range(3):
   var x := -w*0.33+float(col)*w*0.33
   _mesh_box(root,"Window frame",Vector3(x,1.45+row*1.15,1.65),Vector3(0.72,0.78,0.11),Color("#ffffff"))
   _mesh_box(root,"Window glass",Vector3(x,1.45+row*1.15,1.72),Vector3(0.53,0.58,0.08),Color("#7ed8fa"))
 _mesh_box(root,"Door",Vector3(0,0.65,1.75),Vector3(0.9,1.3,0.16),Color("#8063a6"))
 _mesh_box(root,"Door knob",Vector3(0.28,0.67,1.87),Vector3(0.12,0.12,0.08),GOLD)
 if name == "Bệnh viện":
  _mesh_box(root,"Cross horizontal",Vector3(0,h+0.95,0),Vector3(1.25,0.32,0.25),Color("#ff5d73"))
  _mesh_box(root,"Cross vertical",Vector3(0,h+0.95,0),Vector3(0.32,1.25,0.25),Color("#ff5d73"))
 else:
  _mesh_box(root,"Sign",Vector3(0,h+0.12,1.96),Vector3(w*0.72,0.62,0.12),Color("#fff5d8"))
 _sign(root,name,Vector3(0,h+0.12,2.04),Color("#442f7e"),29)
 if name == "Trường học":
  _cylinder(root,"Clock",Vector3(0,h+0.6,1.9),0.40,0.16,Color("#ffffff"))
 if name == "Chợ" or name == "Nhà hàng":
  for i in range(5):
   _mesh_box(root,"Awning",Vector3(-w*0.40+i*w*0.20,h*0.78,1.96),
    Vector3(w*0.19,0.22,0.65),Color("#ffffff") if i%2==0 else roof)

func _sign(parent: Node3D, text: String, pos: Vector3, color: Color, size: int) -> void:
 var label := Label3D.new()
 label.text = text
 label.font_size = size
 label.pixel_size = 0.006
 label.modulate = color
 label.outline_size = 8
 label.position = pos
 label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
 label.no_depth_test = true
 parent.add_child(label)

func _tree(pos: Vector3, size: float = 1.0) -> void:
 var root := Node3D.new()
 root.position = pos
 root.scale = Vector3.ONE*size
 add_child(root)
 _cylinder(root,"Trunk",Vector3(0,0.6,0),0.18,1.2,Color("#996747"))
 _sphere(root,"Leaves",Vector3(0,1.65,0),1.0,Color("#28a66c"))
 _sphere(root,"Light foliage",Vector3(-0.4,1.95,0),0.65,Color("#6bda83"))
 _sphere(root,"Highlight",Vector3(0.35,2.15,-0.25),0.52,Color("#a2ed9a"))

func _park(pos: Vector3) -> void:
 _mesh_box(self,"Park grass",pos+Vector3(0,0.05,0),Vector3(5.2,0.16,4.3),Color("#6bd995"))
 for x in [-1.8,1.8]:
  for z in [-1.3,1.3]:
   _tree(pos+Vector3(x,0,z),0.78)
 for i in range(8):
  var a := float(i)*TAU/8.0
  _sphere(self,"Flower",pos+Vector3(cos(a)*1.1,0.19,sin(a)*0.8),0.18,
   Color("#ff78bb") if i%2==0 else Color("#ffe36e"))
 _sign(self,"Công viên",pos+Vector3(0,2.5,0),PURPLE,40)

func _fountain(pos: Vector3) -> void:
 _cylinder(self,"Fountain base",pos+Vector3(0,0.18,0),1.3,0.36,Color("#f9f3e6"))
 _cylinder(self,"Fountain water",pos+Vector3(0,0.40,0),1.12,0.12,Color("#57d2f8"))
 _cylinder(self,"Fountain stem",pos+Vector3(0,0.9,0),0.16,1.0,Color("#b6f5ff"))
 _sphere(self,"Fountain spray",pos+Vector3(0,1.55,0),0.24,Color("#d7faff"))

func _car(pos: Vector3, color: Color) -> void:
 var root := Node3D.new()
 root.position = pos
 add_child(root)
 _mesh_box(root,"Car body",Vector3.ZERO,Vector3(1.7,0.6,0.85),color)
 _mesh_box(root,"Cabin",Vector3(0,0.5,0),Vector3(0.95,0.55,0.75),Color("#c5f4ff"))
 for x in [-0.52,0.52]:
  for z in [-0.43,0.43]:
   _cylinder(root,"Wheel",Vector3(x,-0.28,z),0.23,0.14,Color("#35445d"))

func _bus(pos: Vector3) -> void:
 var root := Node3D.new()
 root.position = pos
 add_child(root)
 _mesh_box(root,"Yellow school bus",Vector3.ZERO,Vector3(2.7,1.25,1.15),Color("#ffd14c"))
 for x in [-0.85,-0.25,0.35,0.95]:
  _mesh_box(root,"Bus window",Vector3(x,0.22,0.61),Vector3(0.42,0.48,0.05),Color("#7ad7f2"))
 for x in [-0.85,0.9]:
  _cylinder(root,"Bus wheel",Vector3(x,-0.62,0.5),0.3,0.2,Color("#35445d"))

func _build_cat(root: Node3D) -> void:
 _sphere(root,"Body",Vector3(0,0.78,0),0.56,Color("#b9c1d3"),Vector3(0.8,1.05,0.65))
 _sphere(root,"Head",Vector3(0,1.55,0.18),0.72,Color("#c8d0df"),Vector3(1,0.9,0.9))
 for x in [-0.48,0.48]:
  _sphere(root,"Ear",Vector3(x,2.13,0.12),0.25,Color("#a5aec5"),Vector3(0.8,1.3,0.5))
  _sphere(root,"Inner ear",Vector3(x,2.16,0.31),0.14,Color("#ff9fc1"),Vector3(0.8,1.2,0.45))
  _sphere(root,"Eye white",Vector3(x*0.70,1.67,0.76),0.22,WHITE,Vector3(0.85,1.15,0.4))
  _sphere(root,"Eye iris",Vector3(x*0.70,1.66,0.87),0.14,Color("#329f9a"),Vector3(0.85,1,0.45))
  _sphere(root,"Pupil",Vector3(x*0.70,1.67,0.94),0.08,Color("#23304c"),Vector3(0.85,1.1,0.45))
  _sphere(root,"Cheek",Vector3(x*1.15,1.35,0.72),0.14,Color("#ffb2c9"),Vector3(1.2,0.7,0.45))
  _sphere(root,"Paw",Vector3(x*0.8,0.25,0.28),0.25,Color("#e3e7f0"))
 _sphere(root,"Muzzle",Vector3(0,1.32,0.78),0.32,WHITE,Vector3(1.4,0.7,0.55))
 _sphere(root,"Nose",Vector3(0,1.43,1.01),0.12,Color("#ff7f9f"),Vector3(1,0.7,0.5))
 _mesh_box(root,"Blue shirt",Vector3(0,0.8,0.3),Vector3(0.75,0.72,0.28),Color("#327ee5"))
 _mesh_box(root,"Hat top",Vector3(0,2.4,0.1),Vector3(1.25,0.14,1.15),Color("#315fc7"))
 _mesh_box(root,"Hat crown",Vector3(0,2.28,0.1),Vector3(0.72,0.28,0.7),Color("#2454b6"))
 _sphere(root,"Backpack",Vector3(-0.5,0.8,-0.24),0.33,Color("#f7a72b"),Vector3(0.6,1.1,0.75))

func _setup_ui() -> void:
 var canvas := CanvasLayer.new()
 add_child(canvas)
 ui = Control.new()
 ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 canvas.add_child(ui)
 var top := HBoxContainer.new()
 top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
 top.offset_left=18
 top.offset_top=12
 top.offset_right=-18
 top.add_theme_constant_override("separation",12)
 ui.add_child(top)
 var brand := _pill("🐱  BÉ VUI ENGLISH 3D",PURPLE,24)
 brand.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 top.add_child(brand)
 score_label=_pill("⭐ 0",Color("#8857d9"),22)
 top.add_child(score_label)
 var guide := Button.new()
 guide.text="❔"
 _style_button(guide,GOLD)
 guide.pressed.connect(_show_guide)
 top.add_child(guide)
 var bottom := PanelContainer.new()
 bottom.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
 bottom.offset_left=16
 bottom.offset_right=-16
 bottom.offset_top=-135
 bottom.offset_bottom=-14
 bottom.add_theme_stylebox_override("panel",_style(Color("#eee2ff"),22,Color("#ffffff"),3))
 ui.add_child(bottom)
 var col := VBoxContainer.new()
 col.add_theme_constant_override("separation",8)
 bottom.add_child(col)
 var title := Label.new()
 title.text="🏙️  KHÁM PHÁ THÀNH PHỐ • CHỌN ĐỊA ĐIỂM"
 title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
 title.add_theme_color_override("font_color",NAVY)
 title.add_theme_font_size_override("font_size",19)
 col.add_child(title)
 var places := HFlowContainer.new()
 places.alignment=FlowContainer.ALIGNMENT_CENTER
 places.add_theme_constant_override("h_separation",8)
 places.add_theme_constant_override("v_separation",5)
 col.add_child(places)
 for place in LESSONS.keys():
  var b := Button.new()
  b.text=place
  _style_button(b,COLORS[places.get_child_count()%COLORS.size()])
  b.pressed.connect(_visit.bind(place))
  places.add_child(b)
 panel=PanelContainer.new()
 panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
 panel.custom_minimum_size=Vector2(540,400)
 panel.position=Vector2(-270,-200)
 panel.add_theme_stylebox_override("panel",_style(Color("#f7edff"),24,WHITE,4))
 panel.visible=false
 ui.add_child(panel)
 var inner := VBoxContainer.new()
 inner.add_theme_constant_override("separation",12)
 panel.add_child(inner)
 var heading := HBoxContainer.new()
 inner.add_child(heading)
 title_label=Label.new()
 title_label.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 title_label.add_theme_color_override("font_color",NAVY)
 title_label.add_theme_font_size_override("font_size",25)
 heading.add_child(title_label)
 var close := Button.new()
 close.text="✕"
 _style_button(close,Color("#ff9ebc"))
 close.pressed.connect(_close_lesson)
 heading.add_child(close)
 feedback=Label.new()
 feedback.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
 feedback.add_theme_font_size_override("font_size",22)
 feedback.add_theme_color_override("font_color",NAVY)
 inner.add_child(feedback)
 for i in range(3):
  var b:=Button.new()
  b.custom_minimum_size=Vector2(400,54)
  _style_button(b,COLORS[i])
  b.pressed.connect(_answer.bind(i))
  inner.add_child(b)
  answer_buttons.append(b)
 var speak:=Button.new()
 speak.text="🔊  NGHE LẠI"
 _style_button(speak,GOLD)
 speak.pressed.connect(_speak_current)
 inner.add_child(speak)
 _update_score()

func _style(color: Color,radius: int,border: Color,width: int) -> StyleBoxFlat:
 var s:=StyleBoxFlat.new()
 s.bg_color=color
 s.set_corner_radius_all(radius)
 s.border_color=border
 s.set_border_width_all(width)
 s.shadow_color=Color(0.2,0.1,0.4,0.2)
 s.shadow_size=5
 s.content_margin_left=14
 s.content_margin_right=14
 s.content_margin_top=9
 s.content_margin_bottom=9
 return s

func _style_button(b: Button,color: Color) -> void:
 b.add_theme_stylebox_override("normal",_style(color,16,WHITE,2))
 b.add_theme_stylebox_override("hover",_style(color.lightened(0.12),16,WHITE,2))
 b.add_theme_stylebox_override("pressed",_style(color.darkened(0.10),16,WHITE,2))
 b.add_theme_color_override("font_color",NAVY)
 b.add_theme_color_override("font_hover_color",NAVY)
 b.add_theme_color_override("font_pressed_color",NAVY)
 b.add_theme_font_size_override("font_size",18)

func _pill(text: String,color: Color,font_size: int) -> Label:
 var l:=Label.new()
 l.text=text
 l.add_theme_color_override("font_color",WHITE)
 l.add_theme_font_size_override("font_size",font_size)
 l.add_theme_stylebox_override("normal",_style(color,22,WHITE,2))
 return l

func _visit(place: String) -> void:
 destination=locations[place]+Vector3(0,0,2.7)
 question_place=place
 question_index=0
 panel.visible=true
 _next_question()

func _next_question() -> void:
 var words: Array=LESSONS[question_place]
 if question_index>=words.size():
  completed+=1
  stars+=5
  _save_progress()
  _update_score()
  title_label.text="🎉 HOÀN THÀNH!"
  feedback.text="Giỏi quá! +5 sao ⭐"
  for b in answer_buttons: b.visible=false
  return
 var entry: Array=words[question_index]
 title_label.text="📚 %s • %d/%d" % [question_place,question_index+1,words.size()]
 feedback.text="Từ nào có nghĩa: %s?" % entry[1]
 var options: Array[String]=[str(entry[0])]
 for offset in range(1,3):
  options.append(str(words[(question_index+offset)%words.size()][0]))
 options.shuffle()
 for i in range(3):
  answer_buttons[i].visible=true
  answer_buttons[i].text=options[i]
  answer_buttons[i].set_meta("correct",options[i]==str(entry[0]))
 _speak_current()

func _answer(i: int) -> void:
 if answer_buttons[i].get_meta("correct",false):
  stars+=1
  question_index+=1
  _save_progress()
  _update_score()
  _next_question()
 else:
  feedback.text="Thử lại nhé! 🌟"
  _speak_current()

func _speak_current() -> void:
 var words: Array=LESSONS[question_place]
 if question_index>=words.size(): return
 if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
  var voices:=DisplayServer.tts_get_voices_for_language("en")
  if not voices.is_empty():
   DisplayServer.tts_speak(str(words[question_index][0]),voices[0],70)

func _close_lesson() -> void:
 panel.visible=false
 for b in answer_buttons: b.visible=true

func _update_score() -> void:
 score_label.text="⭐ %d  🏆 %d" % [stars,completed]

func _show_guide() -> void:
 var d:=AcceptDialog.new()
 d.title="Bé Vui English 3D"
 d.dialog_text="Chạm địa điểm để mèo đi tới. Nghe tiếng Anh, chọn đáp án và nhận sao. Tiến độ được lưu tự động."
 add_child(d)
 d.popup_centered()

func _load_progress() -> void:
 if not FileAccess.file_exists("user://progress.json"): return
 var f:=FileAccess.open("user://progress.json",FileAccess.READ)
 if f==null: return
 var data=JSON.parse_string(f.get_as_text())
 if data is Dictionary:
  stars=int(data.get("stars",0))
  completed=int(data.get("completed",0))

func _save_progress() -> void:
 var f:=FileAccess.open("user://progress.json",FileAccess.WRITE)
 if f!=null:
  f.store_string(JSON.stringify({"stars":stars,"completed":completed}))
