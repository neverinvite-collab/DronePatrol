extends SceneTree
var game
func _initialize():call_deferred("run")
func run():
 game=load("res://Main.tscn").instantiate();root.add_child(game)
 await process_frame
 game.sound_on=false;game.difficulty=1;game.wallet=0;game.xp=0;game.stars={};game.unlocked=1
 game.upgrades={"armor":0,"motor":0,"optics":0,"supply":0}
 var samples=[]
 for stage in [1,8,10,20,30,40,50,60]:
  seed(33+stage)
  game.unlocked=stage;game.level=stage
  game.xp=game.xp_for_rank(1+mini(stage,20));game.research_points=0
  if stage>=20:game.upgrades={"armor":1,"motor":1,"optics":1,"supply":1}
  if stage>=40:game.upgrades={"armor":2,"motor":2,"optics":2,"supply":2}
  game.reserves=[0,0,0,0]
  game.stash={"repair":0,"shield":0,"slow":0,"battery":0,"explosive":0,"pulse":0,"recon":0}
  game.start_game()
  var tick=0
  while game.screen=="game" and tick<2400:
   tick+=1
   for pickup in game.pickups.duplicate():game.collect(pickup.kind);game.pickups.erase(pickup)
   if tick%3==0:
    var target=null
    for enemy in game.enemies:
     if enemy.hp<=0:continue
     var targeted=false
     for drone in game.drones:
      if drone.target_id==enemy.id:targeted=true;break
     if not targeted and (target==null or enemy.pos.y>target.pos.y):target=enemy
    if target!=null:
     game.selected_drone=1 if target.hp>2+game.upgrades.optics and game.stock[1]>0 else 0
     game.selected_ammo=0
     game.launch_target(target)
   game._process(.1)
  print("sample",stage," screen=",game.screen," HP=",game.health," stock=",game.stock," ammo=",game.ammo," enemies=",game.enemies.size()," elapsed=",game.elapsed)
  assert(game.screen=="victory","Supply model should sustain focused play at stage %d" % stage)
  samples.append({"level":stage,"seconds":game.elapsed,"hp":game.health,"kills":game.battle_kills})
 print("PASS: deterministic collection/aiming bot completed sample stages: "+JSON.stringify(samples))
 game.show_menu();await create_timer(.2).timeout;game.queue_free();await process_frame;await create_timer(.2).timeout;quit()
