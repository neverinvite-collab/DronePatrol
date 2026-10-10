extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://Main.tscn").instantiate();root.add_child(game);await process_frame
 game.start_game();game.weather_auto=false
 var soldier={"kind":"soldier","pos":Vector2(300,200),"hp":1}
 var tank={"kind":"vehicle","pos":Vector2(300,200),"hp":4}
 game.weather_weights=[0,1,0,0]
 assert(is_equal_approx(game.weather_movement(soldier),.85) and game.weather_movement(tank)==1)
 game.weather_weights=[0,0,0,1]
 assert(game.weather_movement(soldier)==1 and is_equal_approx(game.weather_movement(tank),.9) and is_equal_approx(game.weather_drone_speed(),.9))
 game.weather_weights=[0,0,1,0];game.elapsed=20;game.reveal_until=0
 assert(not game.enemy_visible(soldier))
 var before=game.stock[0];game.launch_target(soldier);assert(game.stock[0]==before,"Cannot target hidden enemy")
 game.reveal_until=30;assert(game.enemy_visible(soldier))
 game.reveal_until=0;soldier.pos.y=350;assert(game.enemy_visible(soldier))
 tank.boss=true;assert(game.enemy_visible(tank),"Boss remains visible")
 game.medals=[];game.damage_taken=false;game.heavy_used=false;game.purchased_supplies=false;game.boss_defeated=true;game.weather_seen=[1,3]
 assert(game.award_medals()==330 and game.medals.size()==6)
 assert(game.award_medals()==0,"Medal rewards cannot repeat")
 game.save_progress();game.medals=[];game.load_progress();assert(game.medals.size()==6)
 game.level=10;game.start_game();game.begin_boss_warning();game.begin_boss_warning()
 assert(game.boss_warning_left==2 and not game.boss_spawned)
 game.update_boss_warning(1);assert(not game.boss_spawned)
 game.update_boss_warning(1);assert(game.boss_spawned and game.enemies.size()==1)
 game.update_boss_warning(1);assert(game.enemies.size()==1 and game.shake_offset==Vector2.ZERO)
 for language in ["uk","ru","en"]:game.lang=language;game.show_achievements()
 game.show_menu();game.stop_speech();game.siren.stop();game.weather_loop.stop()
 await create_timer(.2).timeout;game.queue_free();await process_frame;await create_timer(.2).timeout
 print("PASS: weather speed/visibility/recon/targeting, one-time persistent medals, delayed single boss warning, shake reset, 3-language achievements")
 quit()
