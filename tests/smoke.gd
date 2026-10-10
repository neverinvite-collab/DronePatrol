extends SceneTree
var game
func _initialize():
 call_deferred("run")
func check(ok, message):
 if not ok:
  push_error(message)
  quit(1)
  return false
 return true
func run():
 game=load("res://Main.tscn").instantiate()
 root.add_child(game)
 await process_frame
 game.start_game()
 game.sound_on=false
 game.spawn_timer=999
 game.supply_timer=999
 check(game.health==100,"Initial base health")
 game.stock=[0,0,0]
 game.ammo=[0,0,0]
 game.collect(4)
 game.collect(0)
 check(game.stock[0]==3 and game.ammo[0]==8,"Crates replenish stocks")
 game.enemies=[{"id":1,"pos":Vector2(360,400),"kind":"soldier","row":0,"hp":1,"speed":30.0,"r":24.0,"age":0.0,"bush":false,"side":1}]
 var event=InputEventMouseButton.new()
 event.button_index=MOUSE_BUTTON_LEFT
 event.pressed=true
 event.position=Vector2(360,400)
 game._unhandled_input(event)
 check(game.stock[0]==2 and game.ammo[0]==7 and game.drones.size()==1,"Launch spends one drone and ammo")
 for i in range(120):game._process(1.0/60)
 check(game.score==1 and game.enemies.is_empty(),"Drone reaches target and destroys infantry")
 game.enemies=[{"id":2,"pos":Vector2(360,814),"kind":"vehicle","row":0,"hp":4,"speed":30.0,"r":40.0,"age":0.0,"bush":false,"side":1}]
 game._process(0.1)
 check(game.health==85 and game.enemies.is_empty(),"Reached enemy damages base once")
 game.pause_game()
 var time=game.elapsed
 game._process(1)
 check(game.elapsed==time,"Pause freezes simulation")
 game.screen="game"
 game.health=6
 game.enemies=[{"id":3,"pos":Vector2(360,814),"kind":"soldier","row":0,"hp":1,"speed":30.0,"r":24.0,"age":0.0,"bush":false,"side":1}]
 game._process(0.1)
 check(game.health==0 and game.screen=="over","Zero health ends game")
 game.start_game()
 check(game.health==100 and game.enemies.is_empty() and game.stock[0]==8,"Restart resets state")
 for language in ["uk","ru","en"]:
  game.lang=language
  game.show_menu()
  game.show_settings()
  game.show_equipment()
  game.start_game()
  check(game.t(1).length()>0,"Localization exists")
 event=null
 game.voice.stop()
 await create_timer(0.2).timeout
 game.queue_free()
 await process_frame
 await create_timer(0.15).timeout
 print("PASS: pickup, launch, impact, base damage, pause, defeat, restart, three languages")
 quit()
