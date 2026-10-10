extends SceneTree
var game
func _initialize():call_deferred("run")
func run():
 game=load("res://Main.tscn").instantiate()
 root.add_child(game)
 await process_frame
 check_voice_files()
 game.voice_on=true;game.sound_on=true;game.say("ready",true)
 assert(game.voice.playing,"Voice event plays")
 game.voice.stop();assert(not game.voice.playing,"Active voice stops")
 # Keep the player's persistent campaign untouched by automated checks.
 var keys=["unlocked","stars","wallet","reserves","stats","claimed","collection","difficulty","level","lang"]
 var snapshot={}
 for k in keys:
  var v=game.get(k)
  snapshot[k]=v.duplicate(true) if v is Array or v is Dictionary else v
 game.unlocked=1;game.stars={};game.wallet=0;game.reserves=[0,0,0,0]
 game.stats={"kills":0,"crates":0,"wins":0,"recon":0};game.claimed=[];game.collection=[]
 for language in ["uk","ru","en"]:
  game.lang=language
  for page in range(3):
   game.map_page=page;game.show_map()
   var nodes=0
   for child in game.ui.get_children():
    if child is Button and child.position.y>=220 and child.position.y<1000:
     nodes+=1
     assert(child.disabled==(int(child.text.split(" ")[0])>game.unlocked))
   assert(nodes==20,"Twenty nodes on each route page")
  game.show_equipment();game.show_achievements();game.show_shop();game.show_collection();game.show_settings()
 game.lang="uk"
 for stage in [1,15,16,30,31,45,46,60]:
  game.level=stage;game.start_game()
  assert(game.season==mini(int((stage-1)/15),3),"Season progression")
 game.level=1;game.start_game();game.spawned=game.quota
 game.enemies=[];game.drones=[];game.health=90;game.coins=10
 var before=game.wallet
 game._process(0)
 assert(game.screen=="victory" and game.unlocked==2 and game.stars["1"]==3)
 assert(game.wallet==before+21,"Reward banked")
 before=game.wallet;game._process(1)
 assert(game.wallet==before,"Victory reward once")
 game.wallet=100;game.buy_item(0)
 assert(game.wallet==70 and game.reserves[0]==3)
 game.start_game();assert(game.stock[0]==11 and game.reserves[0]==0,"Purchase used once")
 game.start_game();assert(game.stock[0]==8,"No repeated purchase")
 game.wallet=0;game.buy_item(1);assert(game.wallet==0 and game.reserves[1]==0)
 game.stats.kills=1;game.claimed=[];game.claim_achievement(0)
 assert(game.wallet==30 and 0 in game.claimed)
 game.claim_achievement(0);assert(game.wallet==30,"Achievement reward once")
 for d in range(3):
  game.difficulty=d;game.level=1;game.start_game();game.spawn_enemy()
  assert(game.spawned==1 and game.enemies.size()==1)
 game.collect(0);assert("loot_0" in game.collection)
 game.save_progress()
 var wallet=game.wallet;var inventory=game.collection.duplicate()
 game.wallet=999;game.collection=[];game.load_progress()
 assert(game.wallet==wallet and game.collection==inventory,"Persistence roundtrip")
 for k in keys:game.set(k,snapshot[k])
 game.save_progress()
 game.voice.stop()
 await create_timer(.2).timeout
 game.queue_free()
 await process_frame
 await create_timer(0.15).timeout
 print("PASS: 60 nodes, localization, seasons, victory, rewards, shop, achievements, collection, difficulty, persistence")
 quit()

func check_voice_files():
 for language in ["uk","ru","en"]:
  for event in ["ready","launch","hit","loot","hurt","empty","win","lose"]:
   var clip=load("res://assets/voices/%s_%s.wav" % [language,event])
   assert(clip is AudioStreamWAV and clip.get_length()>0.2,"Voice audio exists")
