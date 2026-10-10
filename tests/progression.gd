extends SceneTree
var game
func _initialize():call_deferred("run")
func reset():
 game.unlocked=1;game.stars={};game.wallet=0;game.xp=0;game.research_points=0
 game.upgrades={"armor":0,"motor":0,"optics":0,"supply":0}
 game.stash={"repair":0,"shield":0,"slow":0,"battery":0,"explosive":0,"pulse":0,"recon":0}
 game.reserves=[0,0,0,0];game.level=1
func run():
 game=load("res://Main.tscn").instantiate();root.add_child(game)
 await process_frame
 reset();game.start_game()
 assert(game.stock==[8,0,0] and game.ammo==[24,0,0],"Only basic FPV and ammo initially")
 assert(game.allowed_loot()==[0,3,4,8])
 game.wallet=1000;game.buy_item(1)
 assert(game.wallet==1000 and game.reserves[1]==0,"Cannot buy locked drone")
 game.selected_drone=1;game.launch_target({"id":1,"pos":Vector2(300,300)})
 assert(game.drones.is_empty(),"Cannot launch locked drone")
 game.selected_drone=0
 for i in range(100):
  game.spawn_enemy();assert(game.enemies[-1].kind=="soldier" and game.enemies[-1].row==0)
 reset()
 game.difficulty=1;game.level=1;game.start_game();game.battle_kills=10;game.coins=50
 game.win_level()
 assert(game.xp==100 and game.research_points==1 and game.wallet==61)
 var previous_xp=game.xp;var previous_wallet=game.wallet
 game.win_level();game.settle_result(true,3)
 assert(game.xp==previous_xp and game.wallet==previous_wallet,"No double reward")
 game.start_game();game.battle_kills=10;game.coins=50;game.win_level()
 assert(game.xp==previous_xp+35 and game.wallet==previous_wallet+37,"Replay rewards")
 game.start_game();game.battle_kills=0;game.coins=0;game.game_over()
 assert(game.result_xp==0 and game.result_coins==0,"No reward for zero contribution defeat")
 game.unlocked=3;game.xp=500;game.research_points=5;game.wallet=1000
 assert(game.feature_open("repair") and not game.feature_open("heavy"))
 game.buy_item(10)
 assert(game.upgrades.armor==1 and game.research_points==4)
 var wallet=game.wallet;game.buy_item(10)
 assert(game.wallet==wallet,"Second tier needs later campaign checkpoint")
 game.unlocked=9;game.xp=1000;game.start_game()
 assert(game.stock[1]==2 and game.stock[2]==3,"Heavy and recon unlocked")
 game.level=10;game.start_game();game.spawned=game.quota;game.enemies=[];game.drones=[]
 game._process(0)
 assert(game.screen=="game" and game.boss_spawned and game.enemies.size()==1,"Boss prevents premature victory")
 var boss=game.enemies[0];assert(boss.row==0 and boss.max_hp==16)
 boss.pos=Vector2(300,300)
 game.impact({"kind":1,"ammo":0,"target":boss.pos})
 assert(boss.hp==12 and not game.boss_defeated)
 boss.hp=1;game.impact({"kind":0,"ammo":0,"target":boss.pos})
 assert(game.boss_defeated)
 game.enemies=[];game._process(0)
 assert(game.screen=="victory")
 for stage in [20,30,40,50,60]:
  game.level=stage;game.start_game();game.spawn_boss()
  assert(game.enemies[0].row==int(stage/10)-1)
 game.level=10;game.start_game();game.spawn_boss();game.enemies[0].pos.y=815
 game._process(.1)
 assert(game.screen=="over" and game.health==0,"Boss reaching base cannot count as defeated")
 game.xp=2500;game.research_points=3;game.save_progress();game.xp=0;game.load_progress()
 assert(game.xp==2500 and game.research_points==3,"XP and research persist")
 var legacy=ConfigFile.new()
 legacy.set_value("progress","unlocked",3);legacy.set_value("progress","stars",{"1":3,"2":2})
 legacy.set_value("progress","wallet",123);legacy.set_value("progress","reserves",[0,1,0,0])
 legacy.set_value("progress","upgrades",{"armor":1});legacy.set_value("progress","stash",{"recon":1})
 legacy.save("user://campaign.cfg")
 game.load_progress()
 assert(game.xp==206 and game.wallet==123 and game.upgrades.armor==1,"Legacy migration keeps progression and purchases")
 game.start_game()
 assert(game.reserves[1]==1 and game.stash.recon==1,"Locked purchased reserves are retained")
 var migrated_xp=game.xp;game.load_progress()
 assert(game.xp==migrated_xp,"Migration cannot award XP twice")
 for language in ["uk","ru","en"]:
  game.lang=language;game.show_map();game.show_research();game.show_collection();game.show_result(true,2)
 game.show_menu();game.voice.stop()
 await create_timer(.2).timeout
 game.queue_free();await process_frame;await create_timer(.2).timeout
 print("PASS: locked resources/enemies, first/repeat rewards, no duplicate award, tiers, 6 bosses, loss, persistence, three languages")
 quit()
