extends SceneTree
var game
func _initialize():call_deferred("run")
func run():
 game=load("res://Main.tscn").instantiate();root.add_child(game)
 await process_frame
 game.weather_auto=true
 for season in range(4):
  game.season=season
  var counts=[0,0,0,0]
  for i in range(1000):counts[game.pick_weather()]+=1
  assert(counts[0]>0 and counts[2]>0)
  if season<3:assert(counts[3]==0,"No automatic snow in warm seasons")
  else:assert(counts[1]==0 and counts[3]>0,"Winter snow rather than rain")
 game.level=16;game.unlocked=16;game.start_game()
 assert(game.season==1 and game.weather!=3)
 game.weather_auto=false;game.manual_weather=2;game.start_game()
 assert(game.weather==2,"Manual weather retained at battle start")
 game.weather_weights=[1.0,0.0,0.0,0.0];game.set_weather(1)
 game.update_weather(2)
 assert(is_equal_approx(game.weather_weights[0],.5) and is_equal_approx(game.weather_weights[1],.5),"Four second transition")
 game.update_weather(2)
 assert(game.weather_weights==[0.0,1.0,0.0,0.0])
 game.update_weather(10);assert(game.wet_ground>0)
 var wet=game.wet_ground;game.set_weather(0);game.update_weather(.1)
 assert(game.wet_ground>wet-.1,"Puddles do not vanish instantly")
 game.screen="paused"
 var before=game.weather_clock;game.update_weather(5);assert(game.weather_clock==before)
 game.weather_auto=true;game.manual_weather=0;game.save_settings()
 game.weather_auto=false;game.load_progress();assert(game.weather_auto)
 for language in ["uk","ru","en"]:
  game.lang=language;game.show_settings();game.show_menu();game.start_game()
  for event in ["ready","launch","hit","loot","hurt","empty","win","lose"]:
   game.sound_on=true;game.voice_on=true;game.say(event,true)
   assert(game.voice.pitch_scale==1 and game.voice.volume_db==-3)
   assert(game.general_time>.2 and game.general_sprite.visible)
   assert(game.music_player.volume_db==-39,"Music ducks before speech begins")
   assert(game.voice.stream.get_length()>.2 and game.voice.stream.get_length()<6)
   game.voice.stop();await process_frame
 game.voice.stop();await create_timer(.2).timeout
 game.queue_free();await process_frame;await create_timer(.2).timeout
 print("PASS: seasonal weather, transition, puddles, pause, manual mode, settings, 24 voice events/general portraits/ducking")
 quit()
