extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://Main.tscn").instantiate();root.add_child(game)
 await process_frame
 for language in ["uk","ru","en"]:
  game.lang=language;game.show_menu();await process_frame
  var main=[];var shortcuts=[];var controls=[]
  for child in game.ui.get_children():
   if child is Button:
    controls.append(child)
    if child.get_meta("menu_role","")=="primary":main.append(child)
    elif child.get_meta("menu_role","")=="shortcut":shortcuts.append(child)
    assert(child.position.x>=0 and child.position.x+child.size.x<=720)
    assert(child.position.y>=0 and child.position.y+child.size.y<1263)
   if child is Label:assert(child.position.x>=0 and child.position.x+child.size.x<=720)
  assert(main.size()==4 and shortcuts.size()==4,"Exactly four main actions and four shortcuts")
  for a in range(controls.size()):
   for b in range(a+1,controls.size()):
    assert(not controls[a].get_rect().intersects(controls[b].get_rect()),"Touch targets cannot overlap")
  for shortcut in shortcuts:
   assert(shortcut.size.x>=96 and shortcut.size.y>=96)
   assert(shortcut.get_child(0).texture!=null and shortcut.get_child(0).mouse_filter==Control.MOUSE_FILTER_IGNORE)
  for i in range(3):
   game.show_menu();game.ui.get_node("MenuShortcut%d" % i).pressed.emit()
   assert(game.screen==["achievements","collection","settings"][i],"Shortcut opens correct screen")
  game.show_settings()
  var language_buttons=[]
  for child in game.ui.get_children():
   if child is Button and child.text in ["УКР","РУС","ENG"]:language_buttons.append(child)
  assert(language_buttons.size()==3,"Language switch remains available in settings")
 game.show_menu();game.voice.stop();game.weather_loop.stop()
 await create_timer(.2).timeout;game.queue_free();await process_frame;await create_timer(.2).timeout
 print("PASS: four main buttons, four icons, no touch overlap, bounds, routing and languages in settings")
 quit()
