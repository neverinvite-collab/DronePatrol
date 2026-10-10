extends SceneTree
func _initialize():
 call_deferred("run")
func run():
 var game=load("res://Main.tscn").instantiate()
 root.add_child(game)
 await process_frame
 for color in ["orange","green"]:
  var texture=load("res://assets/button_%s.svg" % color)
  var img=texture.get_image()
  assert(img.get_pixel(0,0).a==0.0,"Button corner must be transparent")
  img.save_png("/tmp/button_%s_fixed.png" % color)
 for language in ["uk","ru","en"]:
  game.lang=language
  game.show_settings()
  game.show_equipment()
  for child in game.ui.get_children():
   if child is TextureRect:
    assert(child.stretch_mode==TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
    assert(child.size==Vector2(120,125),"Equipment texture cannot exceed its card")
   if child is Label and child.position.x==155:
    assert(child.size.x<=540 and child.position.x+child.size.x<=700,"Equipment text stays inside card")
  game.start_game()
  var launch=game.ui.get_child(game.ui.get_child_count()-1)
  assert(launch.position.y>=game.ammo_buttons[0].position.y+game.ammo_buttons[0].size.y+18,"Launch spacing")
 print("PASS: transparent button corners, equipment aspect ratio, launch spacing in UK/RU/EN")
 game.voice.stop()
 game.weather_loop.stop()
 await create_timer(.2).timeout
 game.queue_free()
 await process_frame
 await create_timer(0.15).timeout
 quit()
