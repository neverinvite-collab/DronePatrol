extends SceneTree
var game
func _initialize():call_deferred("run")
func run():
 game=load("res://Main.tscn").instantiate()
 root.add_child(game)
 await process_frame
 assert(game.cursor_sprite.size==Vector2(56,56),"Cursor keeps intended size after texture assignment")
 game.cursor_timer=.16
 game.update_audio_cursor(.01)
 assert(game.cursor_sprite.size==Vector2(56,56),"Pressed cursor does not enlarge")
 game.unlocked=60;game.stars={"60":3};game.xp=100000;game.research_points=100
 game.wallet=20000
 game.upgrades={"armor":0,"motor":0,"optics":0,"supply":0}
 game.stash={"repair":0,"shield":0,"slow":0,"battery":0,"explosive":0,"pulse":0,"recon":0}
 game.reserves=[0,0,0,0]
 for language in ["uk","ru","en"]:
  game.lang=language
  for tab in range(2):
   game.shop_tab=tab;game.show_shop()
   await process_frame
   assert(game.shop_scroll_node.size.y==800)
 game.lang="uk"
 for i in range(14):game.buy_item(i)
 assert(game.reserves==[3,1,8,0])
 assert(game.stash.repair==1 and game.stash.shield==1)
 for i in range(10,14):
  game.buy_item(i);game.buy_item(i)
  var before=game.wallet
  game.buy_item(i)
  assert(game.wallet==before,"Cannot purchase past maximum")
 game.start_game()
 assert(game.max_health==160 and game.health==160)
 assert(game.stock==[11,3,4] and game.ammo==[32,10,7])
 assert(game.stash.recon==0 and game.stash.explosive==0)
 game.use_boost("repair")
 assert(game.stash.repair==1,"Full base does not waste repair")
 game.health=100;game.use_boost("repair")
 assert(game.health==130 and game.stash.repair==0)
 game.use_boost("shield");game.use_boost("slow");game.use_boost("battery")
 assert(game.shield_until==10 and game.slow_until==10)
 assert(game.stock[0]==13 and game.stock[1]==4)
 game.health=20;game.start_game()
 assert(game.health==160 and game.stock==[8,2,3])
 assert(game.stash.shield==0,"Boosts consumed once")
 game.collect(0)
 assert(not game.notice.begins_with(game.t(34)),"No collected popup")
 game.save_progress();game.upgrades.armor=0;game.load_progress()
 assert(game.upgrades.armor==3,"Permanent upgrade persists")
 game.enemies=[{"hp":3,"pos":Vector2(300,300),"r":24,"speed":10}]
 game.impact({"kind":0,"ammo":0,"target":Vector2(300,300)})
 assert(game.enemies[0].hp<=0,"Optics affects damage")
 game.show_menu()
 game.queue_free()
 await process_frame
 await create_timer(.2).timeout
 print("PASS: 14 items, all languages, cap, one-use stock/boosts, repair guard, armor, damage, persistence")
 quit()
