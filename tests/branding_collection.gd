extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://Main.tscn").instantiate()
 root.add_child(game)
 await process_frame
 for language in ["uk","ru","en"]:
  game.lang=language
  for kind in ["soldier","vehicle","bike","boss"]:
   for i in range(6 if kind=="boss" else 3 if kind=="bike" else 4):
    assert(not game.collection_description(kind+"_"+str(i)).is_empty())
  game.show_collection()
  await process_frame
  var rows=game.ui.get_child(1).get_child(0)
  for row in rows.get_children():
   assert(row.size.x<=660,"Collection row must fit the scroll area")
   assert(row.get_child(1).position.x+row.get_child(1).size.x<=660)
  for i in range(3):
   game.edition=i
   game.show_menu()
   await process_frame
   assert(is_instance_valid(game.version_label))
   assert(game.version_label.text.ends_with("%d/3" % (i+1)))
   if language=="uk":
    var title=game.ui.get_child(0)
    assert(title is TextureRect and title.texture!=null)
    assert(title.position.y+title.size.y<=180)
 game.start_game()
 assert(game.version_label.is_inside_tree())
 var previous=ProjectSettings.get_setting("application/config/version")
 ProjectSettings.set_setting("application/config/version","0.7.1")
 game.refresh_version()
 assert(game.version_label.text.begins_with("v0.7.1"))
 ProjectSettings.set_setting("application/config/version",previous)
 game.voice.stop()
 game.weather_loop.stop()
 await create_timer(.2).timeout
 game.queue_free()
 await process_frame
 await create_timer(.2).timeout
 print("PASS: enemy/boss descriptions, collection wrapping, three menu titles, persistent version, updated project version")
 quit()
