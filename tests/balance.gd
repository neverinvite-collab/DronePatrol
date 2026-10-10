extends SceneTree
var game
func _initialize():call_deferred("run")
func run():
 game=load("res://Main.tscn").instantiate();root.add_child(game)
 await process_frame
 var report=[]
 for mode in range(3):
  game.xp=0;game.unlocked=1;game.stars={};game.wallet=0;game.research_points=0
  game.upgrades={"armor":0,"motor":0,"optics":0,"supply":0}
  game.studied_defenses={"wire":false,"teeth":false,"spikes":false,"mine_soldier":false,"mine_vehicle":false}
  game.difficulty=mode
  var checkpoints=[]
  var unlocks={}
  var spent=0
  for stage in range(1,61):
   game.level=stage;game.quota=8+mini(stage*2,40)
   game.battle_kills=game.quota+(1 if stage%10==0 else 0)
   game.coins=game.quota*2+(25 if stage%10==0 else 0)
   game.reward_paid=false;game.settle_result(true,3)
   for key in game.FEATURES:
    if game.feature_open(key) and not unlocks.has(key):unlocks[key]=stage
   for i in range(10,14):
    if game.upgrades[game.SHOP[i].upgrade]<3 and game.shop_available(i) and game.research_points>0 and game.wallet>=game.shop_price(i):
     spent+=game.shop_price(i);game.wallet-=game.shop_price(i)
     game.upgrades[game.SHOP[i].upgrade]+=1;game.research_points-=1
   for i in range(14,game.SHOP.size()):
    if game.SHOP[i].has("study") and not game.studied_defenses[game.SHOP[i].study] and game.shop_available(i) and game.research_points>0 and game.wallet>=game.shop_price(i):
     spent+=game.shop_price(i);game.wallet-=game.shop_price(i);game.research_points-=1;game.studied_defenses[game.SHOP[i].study]=true
   if stage in [1,4,8,10,18,24,30,60]:
    checkpoints.append({"stage":stage,"rank":game.player_rank(),"xp":game.xp,"wallet":game.wallet,"rp":game.research_points,"upgrade_ranks":game.upgrades.duplicate(),"defense_technologies":game.studied_defenses.duplicate()})
   await process_frame
  assert(unlocks.heavy==8 and unlocks.recon==4 and unlocks.pulse==18,"No mandatory XP grind in full-clear model")
  assert(game.upgrades.values().count(3)==4,"All research affordable within campaign")
  assert(game.studied_defenses.values().count(true)==5,"All five defense technologies affordable")
  report.append({"mode":mode,"checkpoints":checkpoints,"unlocks":unlocks,"research_spend":spent})
 var f=FileAccess.open("res://BALANCE_MODEL.json",FileAccess.WRITE);f.store_string(JSON.stringify(report,"  "));f.close()
 print("PASS: 3 difficulty models, staged unlocks without required repeats, 12 upgrade tiers + 5 defense technologies affordable")
 game.show_menu();game.voice.stop();await create_timer(.2).timeout
 game.queue_free();await process_frame;await create_timer(.2).timeout;quit()
