extends SceneTree

func _initialize() -> void:
 call_deferred("_capture")

func _capture() -> void:
 change_scene_to_file("res://scenes/main.tscn")
 for i in range(45):
  await process_frame
 var scene:=current_scene
 if scene==null:
  push_error("Main scene failed to load")
  quit(1)
  return
 var img:=root.get_viewport().get_texture().get_image()
 if img==null or img.is_empty():
  push_error("Unable to capture rendered frame")
  quit(1)
  return
 var err:=img.save_png("res://screenshot.png")
 if err!=OK:
  push_error("Failed to save screenshot: %s" % err)
  quit(1)
  return
 print("SCREENSHOT_SAVED res://screenshot.png")
 quit()
