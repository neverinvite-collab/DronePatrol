extends SceneTree
func _initialize():call_deferred("run")
func unit(kind,hp,pos):return {"id":randi(),"kind":kind,"row":0,"hp":hp,"max_hp":hp,"pos":pos,"r":24,"age":0,"speed":35,"side":1,"bush":false}
func run():
 var game=load("res://Main.tscn").instantiate();root.add_child(game);await process_frame
 game.sound_on=false;game.voice_on=false;game.medals=[];game.bonus_claimed=[];game.pending_bonus={};game.stars={}
 for stage in range(1,61):
  game.level=stage;game.build_wave_plan()
  assert(game.wave_plan.size()==8+mini(stage*2,40))
  assert(stage>=6 or not "bike" in game.wave_plan)
  assert(stage>=9 or not "vehicle" in game.wave_plan)
 game.level=15;game.unlocked=15;game.xp=10000;game.start_game()
 assert(game.wave_wait==5 and game.spawned==0)
 game.process_wave_spawns(4);assert(game.spawned==0)
 game.process_wave_spawns(1);game.process_wave_spawns(.1);assert(game.spawned==1)
 for i in range(5):game.spawn_enemy()
 assert(game.spawned==6)
 for enemy in game.enemies:
  if enemy.kind=="vehicle" or enemy.kind=="bike":assert(enemy.route_x>=340 and enemy.route_x<=380)
  else:assert(enemy.route_x in [145.0,575.0])
 game.process_wave_spawns(10);assert(game.spawned==6,"Cannot overlap waves")
 game.enemies=[];game.drones=[];game.process_wave_spawns(.1)
 assert(game.wave_index==1 and game.wave_wait==5)
 var recon={"kind":2,"target":Vector2(300,300),"ammo":0}
 game.impact(recon);assert(game.forecast_until==game.elapsed+20 and game.reveal_until==game.elapsed+12)
 var tank=unit("vehicle",6,Vector2(300,300))
 game.enemies=[tank];game.upgrades.optics=0
 game.impact({"kind":1,"target":tank.pos,"ammo":0})
 assert(tank.hp==1,"Heavy deals 5 vehicle damage")
 assert(game.vehicle_damage_ratio(tank)>.8)
 game.enemies=[unit("soldier",1,Vector2(600,600))]
 game.impact({"kind":0,"target":Vector2(300,300),"ammo":0})
 assert(game.enemies[0].hp==1,"FPV strike stays local")
 game.pending_bonus={};game.bonus_claimed=[];game.level=1;game.stars={};game.reward_paid=false
 game.damage_taken=false;game.heavy_used=false;game.purchased_supplies=false;game.boss_defeated=false;game.weather_seen=[]
 game.settle_result(true,3)
 assert(game.pending_bonus.stage==1)
 game.save_progress();game.pending_bonus={};game.load_progress();assert(game.pending_bonus.stage==1,"Pending reward survives reload")
 game.show_map();assert(game.screen=="reward")
 var coins=game.wallet;game.choose_bonus(0);assert(game.wallet==coins+21 and game.pending_bonus.is_empty())
 game.choose_bonus(1);assert(game.wallet==coins+21,"Only one reward")
 game.level=1;game.reward_paid=false;game.settle_result(true,3);assert(game.pending_bonus.is_empty(),"Replay cannot repeat first-clear bonus")
 game.medals=[];game.level=10;assert(game.suggested_medal()==3)
 game.medals=[3];assert(game.suggested_medal()==1)
 game.pending_bonus={"stage":2,"rating":3,"xp":0,"coins":0};game.xp=79;game.research_points=0
 game.choose_bonus(1);assert(game.xp==108 and game.research_points==1,"XP choice awards rank point once")
 game.pending_bonus={"stage":3,"rating":3,"xp":0,"coins":0};game.reserves=[0,0,0,0]
 game.choose_bonus(2);assert(game.reserves[0]==2 and game.reserves[2]==8)
 for language in ["uk","ru","en"]:
  game.lang=language
  for event in game.SPEECH[language]:assert(ResourceLoader.exists("res://assets/voices/%s_%s.wav" % [language,event]))
  game.prepare_stage();game.show_achievements()
 game.show_menu();game.stop_speech();game.siren.stop();game.weather_loop.stop()
 await create_timer(.2).timeout;game.queue_free();await process_frame;await create_timer(.2).timeout
 print("PASS: gated 60-stage wave plans, preparation/no overlap, lanes, recon forecast, heavy/local strike/damage, persistent exclusive reward, no replay reward, medal goals, 66 voices/3 languages")
 quit()
