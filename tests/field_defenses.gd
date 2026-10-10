extends SceneTree
var game
func _initialize():call_deferred("run")
func unit(kind,row=0,hp=4,boss=false):
 return {"id":randi(),"kind":kind,"row":row,"hp":hp,"r":24.0,"pos":Vector2(300,300),"boss":boss}
func obstacle(kind,pos=Vector2(300,300)):
 return {"kind":kind,"pos":pos,"ttl":60.0}
func run():
 game=load("res://Main.tscn").instantiate();root.add_child(game)
 await process_frame
 game.unlocked=1;game.stars={};game.xp=0;game.wallet=1000;game.research_points=100
 var before=game.wallet;game.buy_item(15)
 assert(game.wallet==before and not game.studied_defenses.wire,"Research gated by campaign/XP")
 game.unlocked=60;game.stars={"60":3};game.xp=100000
 before=game.wallet;game.buy_item(14)
 assert(game.wallet==before and game.defense_stock.wire==0,"Supply locked until researched")
 game.buy_item(15)
 assert(game.studied_defenses.wire and game.research_points==99 and game.wallet==before-80)
 before=game.wallet;game.buy_item(15);assert(game.wallet==before and game.research_points==99,"Study once")
 game.buy_item(14);assert(game.defense_stock.wire==1)
 game.start_game();game.select_defense("wire")
 assert(not game.place_defense(Vector2(10,10)) and game.defense_stock.wire==1)
 game.cancel_deployment();assert(game.defense_stock.wire==1,"Cancel is free")
 game.select_defense("wire");assert(game.place_defense(Vector2(300,300)))
 assert(game.defense_stock.wire==0 and game.field_defenses.size()==1)
 var soldier=unit("soldier");var tank=unit("vehicle",0);var car=unit("vehicle",3);var bike=unit("bike")
 assert(game.defense_slow(soldier)==.45 and game.defense_slow(tank)==1 and game.defense_slow(bike)==1)
 game.field_defenses=[obstacle("teeth")]
 assert(game.defense_slow(tank)==.4 and game.defense_slow(car)==1 and game.defense_slow(soldier)==1)
 assert(game.defense_slow(unit("vehicle",3,40,true))==.4 and game.defense_slow(unit("vehicle",0,16,true))==1,"Boss classes")
 game.field_defenses=[obstacle("spikes")]
 assert(game.defense_slow(tank)==.5 and game.defense_slow(car)==.5 and game.defense_slow(bike)==.5 and game.defense_slow(soldier)==1)
 game.field_defenses.append(obstacle("teeth"));assert(game.defense_slow(tank)==.4,"No multiplicative stacking")
 game.field_defenses=[obstacle("mine_soldier")];game.enemies=[tank]
 game.process_field_defenses(.1);assert(tank.hp==4 and game.field_defenses.size()==1,"Infantry mine ignores vehicle")
 soldier=unit("soldier",0,1);game.enemies.append(soldier)
 var kills=game.stats.kills;game.process_field_defenses(.1)
 assert(soldier.hp<=0 and tank.hp==4 and game.field_defenses.is_empty())
 assert(game.stats.kills==kills+1)
 game.credit_kill(soldier);assert(game.stats.kills==kills+1,"One kill reward")
 soldier=unit("soldier",0,1);tank=unit("vehicle",0,4)
 game.field_defenses=[obstacle("mine_vehicle")];game.enemies=[soldier]
 game.process_field_defenses(.1);assert(soldier.hp==1 and game.field_defenses.size()==1)
 game.enemies.append(tank);game.process_field_defenses(.1)
 assert(tank.hp<=0 and soldier.hp==1 and game.field_defenses.is_empty())
 var boss=unit("vehicle",5,56,true);game.boss_defeated=false
 game.field_defenses=[obstacle("mine_vehicle")];game.enemies=[boss];game.process_field_defenses(.1)
 assert(boss.hp==50 and not game.boss_defeated,"Mine does not instantly defeat boss")
 game.field_defenses=[obstacle("wire")];game.enemies=[];game.process_field_defenses(61)
 assert(game.field_defenses.is_empty(),"Defenses expire")
 for key in game.DEFENSE_KEYS:game.studied_defenses[key]=true;game.defense_stock[key]=2
 game.field_defenses=[];game.select_defense("spikes");game.place_defense(Vector2(300,300))
 game.select_defense("wire");assert(not game.place_defense(Vector2(320,300)) and game.defense_stock.wire==2,"No dense stacking")
 game.save_progress();game.studied_defenses.spikes=false;game.defense_stock.spikes=0;game.load_progress()
 assert(game.studied_defenses.spikes and game.defense_stock.spikes==1,"Research and consumed inventory persist")
 game.start_game();assert(game.field_defenses.is_empty() and game.defense_stock.spikes==1)
 for language in ["uk","ru","en"]:
  game.lang=language;game.show_shop();game.show_research();game.show_collection();game.start_game();game.show_defense_picker();game.cancel_deployment()
 game.show_menu();game.voice.stop();game.weather_loop.stop();await create_timer(.2).timeout
 game.queue_free();await process_frame;await create_timer(.2).timeout
 print("PASS: research/purchase gates, placement/cancel, target types, no stacking, one-use mines, boss damage, one reward, expiry, persistence, 3 languages")
 quit()
