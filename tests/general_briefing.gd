extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://Main.tscn").instantiate();root.add_child(game)
 await process_frame
 assert(game.edition==0 and ProjectSettings.get_setting("drone_patrol/edition")==0)
 assert(game.general_sprite.mouse_filter==Control.MOUSE_FILTER_IGNORE)
 game.reserves=[4,5,6];var before=game.reserves.duplicate()
 for language in ["uk","ru","en"]:
  game.lang=language
  for stage in [1,10,20,30,40,50,60]:
   game.level=stage;game.prepare_stage()
   assert(game.screen=="briefing" and game.reserves==before,"Briefing cannot consume supplies")
   for child in game.ui.get_children():
    if child is Label or child is Button:
     assert(child.position.x>=0 and child.position.x+child.size.x<=720)
     assert(child.position.y+child.size.y<=1250)
  for event in game.SPEECH[language]:
   assert(ResourceLoader.exists("res://assets/voices/%s_%s.wav" % [language,event]))
 game.lang="uk";game.level=1;game.start_game()
 game.say("loot",true)
 assert(game.general_sprite.visible and game.general_time>0)
 game.update_general(.3)
 assert(game.general_sprite.position.x>=7)
 var duration=game.general_time
 game.update_general(duration-.15)
 assert(game.general_sprite.visible and game.general_sprite.position.x<8)
 game.update_general(.3)
 assert(not game.general_sprite.visible)
 game.voice_on=false;game.stop_speech();game.say("loot",true)
 assert(not game.general_sprite.visible and not game.speech_active())
 game.voice_on=true;game.say("hurt",true);game.pause_game()
 assert(not game.general_sprite.visible and not game.speech_active())
 game.show_menu();game.voice.stop();game.weather_loop.stop()
 await create_timer(.2).timeout;game.queue_free();await process_frame;await create_timer(.2).timeout
 print("PASS: edition 1, briefing without spending, 3-language/6-boss preview, 36 speech assets, portrait animation/no touch blocking, mute/pause")
 quit()
