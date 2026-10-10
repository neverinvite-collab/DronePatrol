extends Node2D

const WORDS = {
"uk": ["ДРОН-ПАТРУЛЬ", "ГРАТИ", "СПОРЯДЖЕННЯ", "НАЛАШТУВАННЯ", "ВИХІД", "ЗАПАСИ", "ВАЖКИЙ", "РОЗВІДКА", "ЗВИЧАЙНИЙ", "ВИБУХОВИЙ", "ІМПУЛЬСНИЙ", "ЗАПУСТИТИ", "БАЗА", "ПАУЗА", "ПРОДОВЖИТИ", "МЕНЮ", "БАЗУ ЗРУЙНОВАНО", "ЩЕ РАЗ", "Оберіть дрон і БК, потім натисніть ворога. Ящики збирайте натисканням.", "Немає дронів або БК", "ВЕСНА", "ЛІТО", "ОСІНЬ", "ЗИМА", "ДЕНЬ", "ВЕЧІР", "НІЧ", "ЯСНО", "ДОЩ", "ТУМАН", "СНІГ", "ХВИЛЯ", "Натисніть ціль на полі", "Тільки розвідка: показує ворогів", "Зібрано", "ЗВУК"],
"ru": ["ДРОН-ПАТРУЛЬ", "ИГРАТЬ", "СНАРЯЖЕНИЕ", "НАСТРОЙКИ", "ВЫХОД", "ЗАПАСЫ", "ТЯЖЁЛЫЙ", "РАЗВЕДКА", "ОБЫЧНЫЙ", "ВЗРЫВНОЙ", "ИМПУЛЬСНЫЙ", "ЗАПУСТИТЬ", "БАЗА", "ПАУЗА", "ПРОДОЛЖИТЬ", "МЕНЮ", "БАЗА РАЗРУШЕНА", "ЕЩЁ РАЗ", "Выберите дрон и БК, затем нажмите врага. Ящики собирайте нажатием.", "Нет дронов или БК", "ВЕСНА", "ЛЕТО", "ОСЕНЬ", "ЗИМА", "ДЕНЬ", "ВЕЧЕР", "НОЧЬ", "ЯСНО", "ДОЖДЬ", "ТУМАН", "СНЕГ", "ВОЛНА", "Нажмите цель на поле", "Только разведка: показывает врагов", "Собрано", "ЗВУК"],
"en": ["DRONE PATROL", "PLAY", "EQUIPMENT", "SETTINGS", "EXIT", "SUPPLIES", "HEAVY", "RECON", "STANDARD", "EXPLOSIVE", "PULSE", "LAUNCH", "BASE", "PAUSED", "RESUME", "MENU", "BASE DESTROYED", "RETRY", "Select drone and ammo, then tap an enemy. Tap crates to collect them.", "No drones or ammo", "SPRING", "SUMMER", "AUTUMN", "WINTER", "DAY", "EVENING", "NIGHT", "CLEAR", "RAIN", "FOG", "SNOW", "WAVE", "Tap a target on the field", "Recon only: reveals enemies", "Collected", "SOUND"]}
const EDITION_NAMES = [
 ["Зелений рубіж","Зелёный рубеж","Green Frontier"],
 ["Сталевий натиск","Стальной натиск","Steel Onslaught"],
 ["Крижаний фронт","Ледяной фронт","Frozen Front"]
]
var edition = 0
var version_label: Label
var lang = "uk"
var season = 1
var daylight = 0
var mission_night = false
var daylight_blend = 0.0
var spotlight_until = 0.0
var mission_id = 0
var mission_goal = 0
var mission_progress = 0
var mission_start_hp = 0
var mission_completed = false
var weather = 0
var weather_auto = true
var manual_weather = 0
var weather_season = -1
var weather_weights = [1.0,0.0,0.0,0.0]
var weather_timer = 50.0
var weather_from_weights = [1.0,0.0,0.0,0.0]
var weather_blend_elapsed = 4.0
var weather_blend_time = 4.0
var wet_ground = 0.0
var snow_cover = 0.0
var weather_clock = 0.0
var weather_loop: AudioStreamPlayer
var native_speech_time = 0.0
var general_sprite: TextureRect
var general_time = 0.0
var general_duration = 0.0
var banter_timer = 30.0
var last_banter = -1
var sound_on = true
var screen = "menu"
var field_defenses = []
var deployment = ""
var defense_panel: Panel
var defense_stock = {"wire":0,"teeth":0,"spikes":0,"mine_soldier":0,"mine_vehicle":0,"spotlight":0}
var studied_defenses = {"wire":false,"teeth":false,"spikes":false,"mine_soldier":false,"mine_vehicle":false,"spotlight":false}
var enemies = []
var drones = []
var pickups = []
var blasts = []
var stock = [8, 2, 3]
var ammo = [24, 6, 3]
var selected_drone = 0
var selected_ammo = 0
var health = 100
var score = 0
var coins = 0
var elapsed = 0.0
var clock = 0.0
var spawn_timer = 1.0
var supply_timer = 5.0
var slow_until = 0.0
var shield_until = 0.0
var double_until = 0.0
var reveal_until = 0.0
var next_id = 0
var notice = ""
var notice_time = 0.0
var cache = {}
var ui: Control
var overlay: Control
var hud_labels = []
var stock_buttons = []
var ammo_buttons = []
var difficulty = 1
var voice_on = true
var general_voice_name = "oleksa"
var enemy_voices_on = true
var enemy_voice: AudioStreamPlayer
var enemy_voice_cooldown = 0.0
var enemy_voice_number = 0
var upgrades = {"armor":0,"motor":0,"optics":0,"supply":0}
var stash = {"repair":0,"shield":0,"slow":0,"battery":0,"explosive":0,"pulse":0,"recon":0,"spotlight":0}
var max_health = 100
var shop_tab = 0
var shop_scroll = 0
var shop_scroll_node: ScrollContainer
var music_on = true
var music_player: AudioStreamPlayer
var drone_loop: AudioStreamPlayer
var vehicle_loop: AudioStreamPlayer
var foot_loop: AudioStreamPlayer
var sfx_pool = []
var cursor_layer: CanvasLayer
var cursor_sprite: TextureRect
var cursor_timer = 0.0
var cursor_touch = false
var combo = 0
var combo_until = 0.0
var status_label: Label
var notice_panel: Panel
var notice_label: Label
var boost_buttons = []
var music_last = -1
var xp = 0
var research_points = 0
var progression_version = 1
var battle_kills = 0
var reward_paid = false
var boss_spawned = false
var boss_defeated = false
var result_xp = 0
var result_coins = 0
var result_rank_before = 1
var result_new = []
var result_first = false
var supply_count = 0
var level = 1
var unlocked = 1
var stars = {}
var wallet = 0
var reserves = [0,0,0,0]
var stats = {"kills":0,"crates":0,"wins":0,"recon":0,"missions":0}
var claimed = []
var collection = []
var spawned = 0
var quota = 10
var map_page = 0
var voice: AudioStreamPlayer
var voice_cooldown = 0.0
var audio: AudioStreamPlayer

func t(i):
 return WORDS[lang][i]

func tex(name):
 if name.begins_with("drone_") and not name.begins_with("drone_clean_"):
  name = "drone_clean_" + name.split("_")[1]
 if not cache.has(name):
  cache[name] = load("res://assets/" + name + ".png")
 return cache[name]

func boss_tex(index):
 return tex("boss_" + str(clampi(index, 0, 5)))

func _ready():
 Input.emulate_mouse_from_touch=true
 randomize()
 var cfg = ConfigFile.new()
 if cfg.load("user://settings.cfg") == OK:
  lang = cfg.get_value("settings", "language", "uk")
  if not WORDS.has(lang): lang = "uk"
  season = clampi(cfg.get_value("settings", "season", 1), 0, 3)
 audio = AudioStreamPlayer.new()
 audio.stream = load("res://assets/hit.wav")
 audio.volume_db = -15
 add_child(audio)
 var layer = CanvasLayer.new()
 add_child(layer)
 ui = Control.new()
 ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
 layer.add_child(ui)
 voice = AudioStreamPlayer.new()
 voice.volume_db = 1
 add_child(voice)
 enemy_voice = AudioStreamPlayer.new()
 enemy_voice.volume_db = -2
 add_child(enemy_voice)
 load_progress()
 setup_audio_cursor()
 setup_branding()
 setup_general()
 show_menu()

func setup_branding():
 edition=clampi(int(ProjectSettings.get_setting("drone_patrol/edition",0)),0,2)
 var footer=CanvasLayer.new()
 footer.layer=90
 add_child(footer)
 version_label=Label.new()
 version_label.position=Vector2(505,1263)
 version_label.size=Vector2(205,17)
 version_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT
 version_label.mouse_filter=Control.MOUSE_FILTER_IGNORE
 version_label.add_theme_font_size_override("font_size",14)
 version_label.add_theme_color_override("font_shadow_color",Color.BLACK)
 version_label.add_theme_constant_override("shadow_offset_x",1)
 version_label.add_theme_constant_override("shadow_offset_y",1)
 footer.add_child(version_label)
 refresh_version()

func refresh_version():
 version_label.text="v%s · %d/3" % [str(ProjectSettings.get_setting("application/config/version","0.7.0")),edition+1]

func menu_title():
 if lang=="uk":
  var title=TextureRect.new()
  title.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  title.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  title.texture=load("res://assets/menu_title_%d.png" % edition)
  title.position=Vector2(70,10)
  title.size=Vector2(580,165)
  title.mouse_filter=Control.MOUSE_FILTER_IGNORE
  ui.add_child(title)
 else:
  label(t(0),Rect2(20,35,680,70),44)
  label(localized(EDITION_NAMES[edition]),Rect2(20,105,680,55),29)
 refresh_version()

func setup_general():
 var layer=CanvasLayer.new()
 layer.layer=70
 add_child(layer)
 general_sprite=TextureRect.new()
 general_sprite.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 general_sprite.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 general_sprite.texture=load("res://assets/general.png")
 general_sprite.size=Vector2(120,155)
 general_sprite.position=Vector2(-130,625)
 general_sprite.mouse_filter=Control.MOUSE_FILTER_IGNORE
 general_sprite.visible=false
 layer.add_child(general_sprite)

func speech_active():
 return voice.playing

func stop_speech():
 if is_instance_valid(voice):voice.stop()
 native_speech_time=0
 general_time=0
 if is_instance_valid(general_sprite):general_sprite.visible=false

func update_general(delta):
 native_speech_time=maxf(0,native_speech_time-delta)
 if screen!="game":
  general_sprite.visible=false
  general_time=0
  return
 general_time=maxf(0,general_time-delta)
 general_sprite.visible=general_time>0
 if general_time>0:
  var entering=clampf((general_duration-general_time)/0.3,0,1)
  var leaving=clampf(general_time/0.3,0,1)
  general_sprite.position.x=lerpf(-130,8,minf(entering,leaving))
  general_sprite.position.y=625+sin(clock*7)*2
 banter_timer-=delta
 if banter_timer<=0:
  if voice_cooldown<=0 and general_time<=0 and not speech_active():
   var choice=randi()%3
   if choice==last_banter:choice=(choice+1)%3
   last_banter=choice
   say("banter_%d" % choice)
   banter_timer=randf_range(30,45)
  else:banter_timer=3

func is_night_level():
 return level >= 4 and level % 4 == 0

func active_daylight():
 return 2 if mission_night and screen in ["game","paused","over","victory"] else daylight

func enemy_visible(enemy):
 if not mission_night:
  return true
 if elapsed < reveal_until or elapsed<spotlight_until and enemy.pos.y>345 or daylight_blend<0.58:
  return true
 if enemy.get("boss",false) or enemy.get("mini_boss",false):
  return true
 return enemy.pos.y > 585 or enemy.pos.distance_to(Vector2(360,887)) < 305

func prepare_stage():
 stop_speech()
 screen="briefing"
 clear_ui()
 mission_night=is_night_level()
 var is_boss=level%10==0
 label(localized(["ПЕРЕД БОЄМ","ПЕРЕД БОЕМ","BEFORE BATTLE"]),Rect2(20,35,680,65),35)
 label(x("level")+" %d · " % level+t(20+mini(int((level-1)/15),3))+(" · "+localized(["НІЧНА ОПЕРАЦІЯ","НОЧНАЯ ОПЕРАЦИЯ","NIGHT OPERATION"]) if mission_night else ""),Rect2(20,115,680,55),26)
 if is_boss:
  var index=clampi(int(level/10)-1,0,5)
  var image=TextureRect.new()
  image.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  image.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  image.texture=boss_texture(index)
  image.position=Vector2(230,180);image.size=Vector2(260,240)
  ui.add_child(image)
  label(collection_name("boss_%d" % index),Rect2(30,425,660,60),29)
  label(collection_description("boss_%d" % index),Rect2(45,490,630,235),23)
 else:
  label(localized(["Захистіть базу. Оберіть дрон і БК, запустіть та натисніть ціль. Збирайте ящики натисканням.","Защитите базу. Выберите дрон и БК, запустите и нажмите цель. Собирайте ящики нажатием.","Protect the base. Select a drone and ammo, launch, then tap a target. Tap crates to collect them."]),Rect2(45,225,630,220),27)
  label(localized(["Дріт — проти піхоти. Зуби дракона — проти танків. Шипи — проти техніки. Міни діють лише на свій тип цілі.","Проволока — против пехоты. Зубы дракона — против танков. Шипы — против техники. Мины действуют только на свой тип цели.","Wire slows infantry. Dragon teeth slow tanks. Spikes slow vehicles. Each mine affects its matching target type."]),Rect2(45,490,630,240),25)
 if mission_night:
  label(localized(["Нічний бій: далекі цілі приховані. Розвідка відкриває ворогів на кілька секунд.","Ночной бой: дальние цели скрыты. Разведка открывает врагов на несколько секунд.","Night battle: distant targets are hidden. Recon reveals enemies for a few seconds."]),Rect2(55,760,610,110),22)
 else:
  label(localized(["Покупки та запаси витратяться лише після початку бою.","Покупки и запасы потратятся только после начала боя.","Supplies are consumed only when the battle starts."]),Rect2(45,770,630,100),22)
 button(localized(["ДО БОЮ!","В БОЙ!","START BATTLE!"]),Rect2(100,940,520,85),start_game,true,30)
 button(localized(["НАЗАД ДО КАРТИ","НАЗАД К КАРТЕ","BACK TO MAP"]),Rect2(100,1045,520,75),show_map,false,25)
 queue_redraw()

func save_settings():
 var cfg = ConfigFile.new()
 cfg.set_value("settings", "language", lang)
 cfg.set_value("settings", "season", season)
 cfg.set_value("settings", "difficulty", difficulty)
 cfg.set_value("settings", "voice", voice_on)
 cfg.set_value("settings", "general_voice_name", general_voice_name)
 cfg.set_value("settings", "enemy_voices_on", enemy_voices_on)
 cfg.set_value("settings", "sound", sound_on)
 cfg.set_value("settings", "music", music_on)
 cfg.set_value("settings", "daylight", daylight)
 cfg.set_value("settings", "weather", weather)
 cfg.set_value("settings", "weather_auto", weather_auto)
 cfg.set_value("settings", "manual_weather", manual_weather)
 cfg.save("user://settings.cfg")

func clear_ui():
 deployment=""
 defense_panel=null
 for child in ui.get_children():
  ui.remove_child(child)
  child.queue_free()
 stock_buttons.clear()
 ammo_buttons.clear()
 hud_labels.clear()

func label(text_value, rect, size = 26, parent = null):
 var l = Label.new()
 l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 l.clip_text = true
 l.text = text_value
 l.position = rect.position
 l.size = rect.size
 l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
 l.add_theme_font_size_override("font_size", size)
 l.add_theme_color_override("font_color", Color("fff0be"))
 l.add_theme_color_override("font_shadow_color", Color("192014"))
 l.add_theme_constant_override("shadow_offset_x", 2)
 l.add_theme_constant_override("shadow_offset_y", 2)
 l.mouse_filter = Control.MOUSE_FILTER_IGNORE
 (ui if parent == null else parent).add_child(l)
 return l

func button(text_value, rect, callback, orange = false, size = 26, parent = null):
 var b = Button.new()
 b.text = text_value
 b.position = rect.position
 b.size = rect.size
 for state in ["normal", "hover", "pressed", "disabled"]:
  var style = StyleBoxTexture.new()
  style.texture = load("res://assets/button_orange.svg" if orange else "res://assets/button_green.svg")
  for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
   style.set_texture_margin(side, 36 if side in [SIDE_LEFT, SIDE_RIGHT] else 24)
   style.set_content_margin(side, 14 if side in [SIDE_LEFT, SIDE_RIGHT] else 8)
  if state == "pressed": style.modulate_color = Color(0.8, 0.8, 0.8)
  if state == "disabled": style.modulate_color = Color(0.65,0.65,0.65)
  b.add_theme_stylebox_override(state, style)
 b.add_theme_stylebox_override("focus",StyleBoxEmpty.new())
 b.add_theme_color_override("font_disabled_color",Color("4b4e3f"))
 b.add_theme_font_size_override("font_size", size)
 b.add_theme_color_override("font_color", Color("202516"))
 b.add_theme_color_override("font_hover_color", Color("11150d"))
 b.add_theme_constant_override("icon_max_width", 52)
 b.expand_icon=true
 b.pressed.connect(func(): play_sfx("tap"))
 b.pressed.connect(callback)
 (ui if parent==null else parent).add_child(b)
 return b

func menu_icon(index):
 var atlas=AtlasTexture.new()
 atlas.atlas=load("res://assets/menu_icons.png")
 var cell=atlas.atlas.get_size()/2.0
 atlas.region=Rect2(Vector2(index%2,int(index/2))*cell,cell)
 return atlas

func menu_shortcut(index,caption,pos,callback):
 var shortcut=Button.new()
 shortcut.name="MenuShortcut%d" % index
 shortcut.set_meta("menu_role","shortcut")
 shortcut.position=pos
 shortcut.size=Vector2(96,96)
 shortcut.tooltip_text=caption
 for state in ["normal","hover","pressed","focus"]:
  var style=StyleBoxFlat.new()
  style.bg_color=Color("293a2ae8") if state=="normal" else Color("4e5c31f5")
  style.border_color=Color("c49e57") if state!="focus" else Color("fff0a5")
  style.set_border_width_all(2 if state!="focus" else 4)
  style.set_corner_radius_all(24)
  shortcut.add_theme_stylebox_override(state,style)
 var icon=TextureRect.new()
 icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 icon.texture=menu_icon(index)
 icon.position=Vector2(8,8)
 icon.size=Vector2(80,80)
 icon.mouse_filter=Control.MOUSE_FILTER_IGNORE
 shortcut.add_child(icon)
 shortcut.pressed.connect(func():play_sfx("tap"))
 shortcut.pressed.connect(callback)
 ui.add_child(shortcut)
 label(caption,Rect2(pos+Vector2(-22,101),Vector2(140,48)),18)
 return shortcut

func show_menu():
 stop_speech()
 screen = "menu"
 clear_ui()
 season = mini(int((unlocked-1)/15),3)
 ensure_season_weather()
 menu_title()
 label(x("campaign")+"  %d / 60    ◎ %d" % [unlocked,wallet],Rect2(40,180,640,55),25)
 var play=button(t(1),Rect2(130,460,460,95),show_map,true,33)
 play.set_meta("menu_role","primary")
 var equipment=button(t(2),Rect2(150,580,420,82),show_equipment,false,26)
 equipment.set_meta("menu_role","primary")
 var shop=button(x("shop"),Rect2(150,688,420,82),show_shop,false,28)
 shop.set_meta("menu_role","primary")
 var research=button(localized(["ДОСЛІДЖЕННЯ","ИССЛЕДОВАНИЯ","RESEARCH"]),Rect2(150,796,420,82),show_research,false,26)
 research.set_meta("menu_role","primary")
 menu_shortcut(0,x("achievements"),Vector2(34,285),show_achievements)
 menu_shortcut(1,x("collection"),Vector2(590,285),show_collection)
 menu_shortcut(2,t(3),Vector2(34,935),show_settings)
 menu_shortcut(3,t(4),Vector2(590,935),func():get_tree().quit())
 var progress_panel=Panel.new()
 progress_panel.position=Vector2(175,1095)
 progress_panel.size=Vector2(370,92)
 progress_panel.mouse_filter=Control.MOUSE_FILTER_IGNORE
 progress_panel.add_theme_stylebox_override("panel",panel_style(Color("24351de0")))
 ui.add_child(progress_panel)
 label(localized(["Рівень гравця","Уровень игрока","Player rank"])+" %d" % player_rank(),Rect2(185,1103,350,35),21)
 label("XP %d / %d" % [xp,xp_for_rank(player_rank()+1)],Rect2(185,1142,350,32),19)
 queue_redraw()

func language_row(y, refresh):
 var langs = ["uk", "ru", "en"]
 for i in range(3):
  var code = langs[i]
  button(["УКР", "РУС", "ENG"][i],Rect2(110+i*170,y,160,65),func(): lang=code; save_settings(); refresh.call(),code==lang,24)

func show_equipment():
 screen = "equipment"
 clear_ui()
 label(t(2),Rect2(20,30,680,70),38)
 for i in range(6):
  var y = 120+i*157
  var card=Panel.new()
  card.position=Vector2(18,y)
  card.size=Vector2(684,147)
  card.mouse_filter=Control.MOUSE_FILTER_IGNORE
  card.add_theme_stylebox_override("panel",panel_style(Color("293821e8")))
  ui.add_child(card)
  var image=TextureRect.new()
  image.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  image.texture=tex("drone_%d_0" % [2,0,1][i]) if i<3 else tex("loot_%d" % (i-3))
  image.position=Vector2(25,y+5)
  image.size=Vector2(120,125)
  image.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  image.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  image.mouse_filter=Control.MOUSE_FILTER_IGNORE
  ui.add_child(image)
  label((["FPV",t(6),t(7)][i] if i<3 else t(8+i-3)),Rect2(155,y,540,40),26)
  var detail=label(equipment_description(i),Rect2(155,y+42,530,100),20)
  detail.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  var feature=["fpv","heavy","recon","normal","explosive","pulse"][i]
  if not feature_open(feature):
   image.modulate=Color(0.35,0.35,0.35)
   detail.text=feature_requirement(feature)+"\n"+equipment_description(i)
 button(t(15),Rect2(160,1135,400,80),show_menu,true)
 queue_redraw()

func show_settings():
 screen = "settings"
 clear_ui()
 label(t(3),Rect2(20,100,680,80),38)
 language_row(245, show_settings)
 for i in range(3):
  var ii=i
  button(t(24+i),Rect2(60+i*205,390,195,70),func(): daylight=ii; save_settings(); show_settings(),daylight==i,24)
 for i in range(4):
  var ii=i
  button(t(27+i),Rect2(20+i*175,520,165,70),func(): weather_auto=false;manual_weather=ii;set_weather(ii); save_settings(); show_settings(),not weather_auto and manual_weather==i,22)
 button(localized(["ПОГОДА ЗА СЕЗОНОМ","ПОГОДА ПО СЕЗОНУ","SEASONAL WEATHER"])+(" ✓" if weather_auto else " —"),Rect2(70,610,580,60),func(): weather_auto=not weather_auto;set_weather(pick_weather() if weather_auto else manual_weather);save_settings();show_settings(),weather_auto,23)
 button(t(35)+(" ✓" if sound_on else " —"),Rect2(160,690,400,80),func(): toggle_sound())
 label(x("difficulty"),Rect2(40,825,640,50),26)
 for i in range(3):
  var ii=i
  button(x(["easy","normal","hard"][i]),Rect2(30+i*230,890,220,70),func(): difficulty=ii; save_settings(); show_settings(),difficulty==i,21)
 button(x("voice")+(" ✓" if voice_on else " —"),Rect2(160,958,400,53),func(): toggle_voice())
 button(localized(["ГОЛОС ГЕНЕРАЛА: ","ГОЛОС ГЕНЕРАЛА: ","GENERAL VOICE: "])+general_voice_name.capitalize(),Rect2(90,1017,540,51),func(): general_voice_name="mykyta" if general_voice_name=="oleksa" else "oleksa"; save_settings();show_settings(),false,21)
 button(localized(["ГОЛОСИ ВОРОГІВ","ГОЛОСА ВРАГОВ","ENEMY VOICES"])+(" ✓" if enemy_voices_on else " —"),Rect2(140,1074,440,48),func(): enemy_voices_on=not enemy_voices_on; save_settings();show_settings(),false,21)
 button(localized(["МУЗИКА","МУЗЫКА","MUSIC"])+(" ✓" if music_on else " —"),Rect2(160,762,400,55),func(): music_on=not music_on; save_settings(); show_settings(),false,24)
 button(t(15),Rect2(160,1150,400,67),show_menu,true)
 queue_redraw()

func start_game():
 stop_speech()
 banter_timer=randf_range(28,38)
 screen="game"
 mission_night=is_night_level()
 season=mini(int((level-1)/15),3)
 reset_battle_weather()
 spawned=0
 quota=8+mini(level*2,40)
 battle_kills=0;reward_paid=false;boss_spawned=false;boss_defeated=false;supply_count=0
 if not feature_open(["fpv","heavy","recon"][selected_drone]):selected_drone=0
 if not feature_open(["normal","explosive","pulse"][selected_ammo]):selected_ammo=0
 enemies.clear(); drones.clear(); pickups.clear(); blasts.clear();field_defenses.clear()
 max_health=100+20*upgrades.armor
 stock=[8+reserves[0],(2+reserves[1]) if feature_open("heavy") else 0,(3+stash.recon) if feature_open("recon") else 0]
 ammo=[24+reserves[2],(6+stash.explosive*4) if feature_open("explosive") else 0,(3+stash.pulse*4) if feature_open("pulse") else 0]
 health=max_health;score=0;coins=0
 reserves[0]=0;reserves[2]=0
 if feature_open("heavy"):reserves[1]=0
 if feature_open("recon"):stash.recon=0
 if feature_open("explosive"):stash.explosive=0
 if feature_open("pulse"):stash.pulse=0
 combo=0;combo_until=0
 save_progress()
 elapsed=0;spawn_timer=1;supply_timer=3
 spotlight_until=0.0
 daylight_blend=0.0
 setup_general_mission()
 slow_until=0;shield_until=0;double_until=0;reveal_until=0
 build_hud()
 announce(mission_text())
 say("ready",true)

func use_spotlight():
 if not feature_open("spotlight") or stash.spotlight<=0 or screen!="game":return
 stash.spotlight-=1
 spotlight_until=elapsed+18.0
 announce(localized(["Прожектор увімкнено!","Прожектор включён!","Searchlight on!"]))
 build_hud()

func setup_general_mission():
 mission_id=randi()%3
 mission_progress=0
 mission_completed=false
 mission_start_hp=max_health
 mission_goal=5 if mission_id==0 else 3 if mission_id==1 else 8

func mission_text():
 match mission_id:
  0:return localized(["Завдання: знищити 5 ворогів","Задание: уничтожить 5 врагов","Mission: defeat 5 enemies"])
  1:return localized(["Завдання: зібрати 3 ящики","Задание: собрать 3 ящика","Mission: collect 3 crates"])
  _:return localized(["Завдання: утримати 8 ворогів без шкоди","Задание: удержать 8 врагов без урона","Mission: 8 kills without base damage"])

func update_mission(amount:int=1):
 if mission_completed:return
 if mission_id==2 and health<mission_start_hp:return
 mission_progress+=amount
 if mission_progress>=mission_goal:
  mission_completed=true
  coins+=15
  stats["missions"]=int(stats.get("missions",0))+1
  announce(localized(["Генерал задоволений! +15 монет","Генерал доволен! +15 монет","General approves! +15 coins"]))

func build_hud():
 clear_ui()
 hud_labels.append(label("",Rect2(10,8,240,62),28))
 hud_labels.append(label("",Rect2(255,8,290,62),28))
 button("Ⅱ",Rect2(612,12,92,60),pause_game,false,30)
 var defenses_button=button("⚒",Rect2(549,12,59,60),show_defense_picker,false,25)
 defenses_button.tooltip_text=localized(["Польовий захист","Полевой защитный набор","Field defenses"])
 status_label=label("",Rect2(78,74,564,32),19)
 notice_panel=Panel.new()
 notice_panel.position=Vector2(52,106)
 notice_panel.size=Vector2(616,46)
 notice_panel.mouse_filter=Control.MOUSE_FILTER_IGNORE
 notice_panel.add_theme_stylebox_override("panel",panel_style(Color("24351ee8")))
 ui.add_child(notice_panel)
 notice_label=label("",Rect2(64,111,592,36),18)
 notice_label.add_theme_color_override("font_color", Color("fff6d0"))
 notice_label.add_theme_color_override("font_shadow_color", Color("182010"))
 boost_buttons.clear()
 for i in range(4):
  var key=["repair","shield","slow","battery"][i]
  boost_buttons.append(button("",Rect2(20+i*172,1000,164,44),func(): use_boost(key),false,16))
 for i in range(3):
  var ii=i
  stock_buttons.append(button("",Rect2(20+i*230,1053,220,83),func(): selected_drone=ii; build_hud(),i==selected_drone,21))
 for i in range(3):
  var ii=i
  ammo_buttons.append(button("",Rect2(20+i*230,1145,220,68),func(): selected_ammo=ii; build_hud(),i==selected_ammo,16))
 for i in range(3):
  stock_buttons[i].icon=tex("drone_%d_0" % [2 if i==0 else 0 if i==1 else 1])
  ammo_buttons[i].icon=tex("loot_%d" % i)
 var lamp=button(localized(["🔦 СВІТЛО","🔦 СВЕТ","🔦 LIGHT"])+" ×%d" % stash.spotlight,Rect2(505,945,188,44),use_spotlight,false,16)
 lamp.disabled=not feature_open("spotlight") or stash.spotlight<=0
 refresh_hud()
 update_notice_ui()

func refresh_hud():
 if hud_labels.size()!=2: return
 hud_labels[0].text="● %d    ◎ %d" % [coins,score]
 var active=[t(20+season)+" · "+t(27+weather)]
 if mission_night:active.append(localized(["НІЧ","НОЧЬ","NIGHT"]))
 if not mission_completed:active.append("★ %d/%d" % [mission_progress,mission_goal])
 if elapsed<shield_until:active.append("◈ %ds" % ceili(shield_until-elapsed))
 if elapsed<slow_until:active.append("◷ %ds" % ceili(slow_until-elapsed))
 if elapsed<double_until:active.append("×2 %ds" % ceili(double_until-elapsed))
 if combo>1 and elapsed<combo_until:active.append("COMBO ×%d" % combo)
 if deployment!="":active=[localized(["Поставити: ","Поставить: ","Place: "])+feature_name(deployment)]
 if is_instance_valid(status_label):status_label.text="   ".join(active)
 for j in range(boost_buttons.size()):
  var key=["repair","shield","slow","battery"][j]
  boost_buttons[j].text=localized({"repair":["Ремонт","Ремонт","Repair"],"shield":["Щит","Щит","Shield"],"slow":["Стоп","Стоп","Slow"],"battery":["Батарея","Батарея","Battery"]}[key])+" ×%d" % stash[key]
  boost_buttons[j].disabled=not feature_open(key) or stash[key]<=0 or (key=="repair" and health>=max_health)
  if not feature_open(key):boost_buttons[j].text="🔒";boost_buttons[j].tooltip_text=feature_requirement(key)
 hud_labels[1].text=x("level")+" %d  %d/%d" % [level,spawned,quota]
 for i in range(3):
  var drone_key=["fpv","heavy","recon"][i]
  var ammo_key=["normal","explosive","pulse"][i]
  stock_buttons[i].text=["FPV",t(6),t(7)][i]+("  ×%d" % stock[i] if feature_open(drone_key) else " 🔒")
  stock_buttons[i].disabled=not feature_open(drone_key)
  stock_buttons[i].tooltip_text=feature_requirement(drone_key) if not feature_open(drone_key) else ""
  ammo_buttons[i].text=t(8+i)+("\n%d" % ammo[i] if feature_open(ammo_key) else " 🔒")
  ammo_buttons[i].disabled=not feature_open(ammo_key)
  ammo_buttons[i].tooltip_text=feature_requirement(ammo_key) if not feature_open(ammo_key) else ""
 update_notice_ui()

func update_notice_ui():
 if not is_instance_valid(notice_label):
  return
 var default_hint=localized(["🎯 Натисніть на ворога для запуску","🎯 Нажмите на врага для запуска","🎯 Tap an enemy to launch"])
 notice_label.text=notice if notice_time>0 else default_hint
 if is_instance_valid(notice_panel):
  notice_panel.visible=screen=="game"

func pause_game():
 stop_speech()
 screen="paused"
 clear_ui()
 label(t(13),Rect2(60,300,600,100),48)
 button(t(14),Rect2(140,470,440,100),func(): screen="game"; build_hud(),true)
 button(t(15),Rect2(140,590,440,100),show_menu)

func game_over():
 if reward_paid:return
 screen="over"
 settle_result(false)
 say("lose",true)
 show_result(false,0)

func announce(message):
 notice=message
 notice_time=3
 update_notice_ui()

func make_enemy(kind:String,row:int,hp:int,speed:float,radius:float,from_bush:bool,side:int,pos:Vector2,extra:Dictionary={}):
 next_id+=1
 spawned+=1
 speed*=[0.75,1.0,1.25][difficulty]
 var enemy={"id":next_id,"pos":pos,"kind":kind,"row":row,"hp":hp,"max_hp":hp,"speed":speed,"r":radius,"age":randf(),"bush":from_bush,"side":side,"zig_amp":0.0,"zig_speed":0.0,"zig_phase":randf()*TAU}
 if kind in ["soldier","kikimora","medic"]:
  enemy.zig_amp=randf_range(7.0,14.0)+level*0.22
  enemy.zig_speed=randf_range(1.25,1.95)
 elif kind=="bike":
  enemy.zig_amp=randf_range(5.0,10.0)
  enemy.zig_speed=randf_range(1.6,2.2)
 elif kind=="vehicle":
  enemy.zig_amp=randf_range(2.0,5.0)
  enemy.zig_speed=randf_range(0.7,1.0)
 if kind=="medic":enemy.heal_cd=randf_range(2.8,4.0)
 for k in extra.keys():enemy[k]=extra[k]
 discover("soldier_"+str(row) if kind in ["kikimora","medic"] else kind+"_"+str(row) if kind in ["soldier","vehicle","bike"] else kind)
 enemies.append(enemy)
 return enemy

func spawn_enemy_group():
 var count=1
 var forced_kind=""
 if level>=9 and randf()<0.20:
  forced_kind="vehicle"
 elif level>=6 and randf()<0.18:
  forced_kind="bike"
 elif level>=7 and randf()<0.10:
  forced_kind="medic"
 elif level>=5 and randf()<0.14:
  forced_kind="kikimora"
 else:
  forced_kind="soldier"
 if forced_kind=="vehicle":
  count=1
 elif forced_kind=="bike":
  count=1 if randf()<0.55 else 2
 else:
  if level>=4 and randf()<0.34:count=2
  if level>=10 and randf()<0.12:count=3
 count=mini(count,maxi(1,quota-spawned))
 for i in range(count):
  spawn_enemy(i,count,forced_kind)
 if count>=2 and randf()<0.50:play_enemy_voice("squad")

func spawn_miniboss():
 boss_spawned=true
 var hp=roundi((10+level*0.55)*[0.85,1.0,1.15][difficulty])
 var row=randi()%4
 make_enemy("vehicle",row,hp,20.0,56.0,false,1,Vector2(360,-82),{"mini_boss":true})
 play_sfx("siren")
 announce(localized(["МІНІ-БОС НА ПІДХОДІ!","МИНИ-БОСС НА ПОДХОДЕ!","MINI-BOSS INCOMING!"]))

func spawn_enemy(formation_index:=0,formation_count:=1,forced_kind=""):
 var wave=1+int((level-1)/5)
 var kind=forced_kind if forced_kind!="" else "soldier"
 var row=randi()%mini(4,1+int((level-1)/2))
 var hp=1+(1 if level>=5 and randf()<0.45 else 0)
 var speed=randf_range(27,43)+min(wave*2,22)
 var radius=24.0
 if kind=="vehicle":
  row=randi()%mini(4,1+int((level-9)/10))
  hp=4+int(level>=12)+int(level>=20 and randf()<0.55)
  speed=20+wave+randf_range(-2,4)
  radius=42
 elif kind=="bike":
  row=randi()%mini(3,1+int((level-6)/10))
  hp=2+int(level>=10)+int(level>=18 and randf()<0.5)
  speed=50+wave+randf_range(2,10)
  radius=30
 elif kind=="medic":
  row=randi()%mini(4,1+int((level-1)/2))
  hp=2+int(level>=12)
  speed=31+wave
  radius=24
 elif kind=="kikimora":
  row=randi()%mini(4,1+int((level-1)/2))
  hp=2+int(level>=10)+int(level>=18 and randf()<0.4)
  speed=25+wave
  radius=24
 var from_bush=kind in ["soldier","kikimora","medic"] and randf()<0.34
 var side=-1 if randf()<0.5 else 1
 var pos=Vector2(randf_range(110,610),-65-float(formation_index)*38.0)
 if formation_count>1:
  var lane_gap=116.0 if kind in ["bike","vehicle"] else 92.0
  pos.x=clampf(360+(formation_index-(formation_count-1)/2.0)*lane_gap,92,628)
  pos.y-=formation_index*10.0
 if from_bush:
  pos=Vector2(28 if side==-1 else 692,randf_range(130,530)+formation_index*34)
 if difficulty==2 and kind not in ["soldier","medic"]:hp+=1
 make_enemy(kind,row,hp,speed,radius,from_bush,side,pos)

func _process(delta):
 update_audio_cursor(delta)
 update_weather(delta)
 update_general(delta)
 clock+=delta
 voice_cooldown=maxf(0,voice_cooldown-delta)
 enemy_voice_cooldown=maxf(0,enemy_voice_cooldown-delta)
 if screen=="game":
  daylight_blend=move_toward(daylight_blend,1.0,delta/55.0)
  elapsed+=delta;notice_time=maxf(0,notice_time-delta);spawn_timer-=delta;supply_timer-=delta
  update_notice_ui()
  if spawn_timer<=0 and spawned<quota:
   spawn_enemy_group();spawn_timer=maxf(0.55,2.2-level*0.024)/[0.8,1.0,1.2][difficulty]
  if supply_timer<=0:
   pickups.append({"pos":Vector2(randf_range(85,635),randf_range(180,745)),"kind":supply_kind(),"ttl":20.0})
   supply_timer=randf_range(4,7)/(1.0+0.12*upgrades.supply)
  process_field_defenses(delta)
  var deferred_escorts=[]
  var factor=0.45 if elapsed<slow_until else 1.0
  for e in enemies:
   if e.hp<=0:continue
   e.age+=delta
   if e.get("boss",false):
    e.ability-=delta
    if e.row==0 and e.hp<e.max_hp/2:e.speed=25.0
    if e.ability<=0:
     e.ability=8.0
     if e.row in [1,4] and e.casts<3:
      e.casts+=1
      make_enemy("soldier",0,1,40.0,24.0,false,1,e.pos+Vector2(75,40),{"spawned_helper":true})
     elif e.row==2:supply_timer=maxf(supply_timer,4.0)
     elif e.row==5:e.hp=mini(e.max_hp,e.hp+3)
   if e.kind=="medic":
    e.heal_cd-=delta
    if e.heal_cd<=0:
     var healed=0
     for ally in enemies:
      if ally.id==e.id or ally.hp<=0 or ally.get("boss",false):
       continue
      if ally.pos.distance_to(e.pos)<155 and ally.hp<ally.max_hp:
       ally.hp=min(ally.max_hp,ally.hp+1)
       healed+=1
       if healed>=2:break
     e.heal_cd=randf_range(3.0,4.6)
   var movement_factor=minf(factor,defense_slow(e))
   if e.get("panic_until",0.0)>elapsed:movement_factor*=0.18
   if e.bush and e.age<2.2:e.pos.x+=(-e.side)*48*delta*movement_factor
   e.pos.x=clampf(e.pos.x+sin(e.age*float(e.get("zig_speed",0.0))+float(e.get("zig_phase",0.0)))*float(e.get("zig_amp",0.0))*0.8*delta*movement_factor,64,656)
   e.pos.y+=e.speed*delta*movement_factor
   if e.pos.y>=850:
    if elapsed>=shield_until:
     var base_damage=6 if e.kind in ["soldier","kikimora","medic"] else 10 if e.kind=="bike" else 15
     if e.get("mini_boss",false):base_damage=22
     health=0 if e.get("boss",false) else maxi(0,health-int(base_damage*[0.7,1.0,1.3][difficulty]))
     if mission_id==2 and not mission_completed:mission_progress=0
     say("hurt")
     play_sfx("hurt")
    if e.get("boss",false):health=0
    e.hp=0
  process_field_defenses(0)
  enemies=enemies.filter(func(e):return e.hp>0)
  for d in drones:
   for e in enemies:
    if e.id==d.target_id:d.target=e.pos
   d.pos=d.pos.move_toward(d.target,delta*(420 if d.kind==0 else 270)*(1.0+0.15*upgrades.motor))
   if d.pos.distance_to(d.target)<8:
    impact(d);d.done=true
  drones=drones.filter(func(d):return not d.done)
  for p in pickups:p.ttl-=delta
  pickups=pickups.filter(func(p):return p.ttl>0)
  for b in blasts:b.ttl-=delta
  blasts=blasts.filter(func(b):return b.ttl>0)
  refresh_hud()
  if health<=0:game_over()
  elif spawned>=quota and enemies.is_empty() and drones.is_empty():
   if level%10==0 and not boss_spawned:
    spawn_boss()
   elif level%5==0 and level%10!=0 and not boss_spawned:
    spawn_miniboss()
   elif level%10!=0 and level%5!=0 or boss_defeated:
    win_level()
 queue_redraw()

func impact(d):
 if d.kind==2:
  reveal_until=elapsed+12
  stats.recon+=1
  announce(localized(["Розвідка відкрила цілі!","Разведка открыла цели!","Recon revealed targets!"]))
  return
 var radius=(45.0 if d.kind==0 else 110.0)*(1.0+0.08*upgrades.optics)
 if d.ammo==1:radius*=1.35
 blasts.append({"pos":d.target,"r":radius,"ttl":0.45,"pulse":d.ammo==2})
 play_sfx("pulse" if d.ammo==2 else "explosion")
 for e in enemies:
  if e.hp<=0:continue
  if e.pos.distance_to(d.target)<radius+e.r:
   var damage=(2 if d.kind==0 else 4)+upgrades.optics
   if e.kind=="kikimora":damage=maxi(1,damage-1)
   if e.get("boss",false) and e.row==3 and d.kind==0:damage=maxi(1,damage-1)
   e.hp-=damage
   if e.kind in ["vehicle","bike"] and e.hp>0:
    e.speed=maxf(10.0,e.speed*0.88)
   if e.kind in ["soldier","medic","kikimora"] and e.hp>0 and randf()<0.24:
    e["panic_until"]=elapsed+randf_range(0.8,1.8)
   if d.ammo==2: e.speed*=0.5
   if e.hp<=0:credit_kill(e)

func _unhandled_input(event):
 if event is InputEventKey and event.pressed and event.keycode==KEY_ESCAPE:
  if screen=="game" and (deployment!="" or is_instance_valid(defense_panel)):
   cancel_deployment();return
  if screen=="game":pause_game()
  elif screen=="paused":screen="game";build_hud()
  else:show_menu()
 var pos=Vector2.ZERO
 var tap=false
 # Touch generates a mouse event. Use that event for both GUI and gameplay,
 # so GUI can consume it and a single tap cannot launch twice.
 if event is InputEventScreenTouch:return
 if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT:pos=event.position;tap=true
 if not tap or screen!="game" or pos.y>950:return
 if deployment!="":
  place_defense(pos)
  return
 for p in pickups:
  if pos.distance_to(p.pos)<44:
   collect(p.kind);pickups.erase(p);return
 var target=null
 var dist=80.0
 for e in enemies:
  if not enemy_visible(e):
   continue
  var dd=pos.distance_to(e.pos)
  if dd<dist:dist=dd;target=e
 if target==null:return
 launch_target(target)

func launch_target(target):
 if not feature_open(["fpv","heavy","recon"][selected_drone]):return
 if selected_drone!=2 and not feature_open(["normal","explosive","pulse"][selected_ammo]):return
 if stock[selected_drone]<=0 or (selected_drone!=2 and ammo[selected_ammo]<=0):
  announce(t(19));say("empty");return
 say("launch")
 play_sfx("launch")
 stock[selected_drone]-=1
 if selected_drone!=2:ammo[selected_ammo]-=1
 drones.append({"pos":Vector2(360,887),"target":target.pos,"target_id":target.id,"kind":selected_drone,"ammo":selected_ammo,"done":false})

func collect(kind):
 if kind not in allowed_loot():return
 stats.crates+=1
 if mission_id==1:update_mission()
 discover("loot_"+str(kind))
 say("loot")
 match kind:
  0:ammo[0]+=8
  1:ammo[1]+=3
  2:ammo[2]+=3
  3:stock[0]+=2
  4:stock[0]+=3
  5:stock[1]+=1
  6:stock[2]+=1
  7:health=min(max_health,health+12)
  8:coins+=25
  9:slow_until=elapsed+8
  10:shield_until=elapsed+8
  11:double_until=elapsed+12
 play_sfx("collect")
 refresh_hud()

func sprite(name, center, size):
 draw_texture_rect(tex(name),Rect2(center-size/2,size),false)

func _draw():
 if not is_node_ready():return
 draw_texture_rect(tex("map_%d"%season),Rect2(0,0,720,1004 if screen in ["game","paused","over","victory"] else 1280),false)
 draw_weather_terrain()
 if screen in ["game","paused","over","victory"]:
  draw_field_defenses()
  var state=0 if health>max_health*0.75 else 1 if health>max_health*0.4 else 2 if health>0 else 3
  sprite("base_%d_%d"%[1 if season==3 else 0,state],Vector2(360,887),Vector2(205,160))
  draw_style_box(panel_style(Color("303d20")),Rect2(230,955,260,24))
  draw_rect(Rect2(234,959,252*health/float(max_health),16),Color("72b345") if health>40 else Color("f18b35"))
  draw_string(ThemeDB.fallback_font,Vector2(275,946),t(12)+" %d/%d"%[health,max_health],HORIZONTAL_ALIGNMENT_LEFT,-1,21,Color.WHITE)
  if elapsed<shield_until:draw_arc(Vector2(360,887),116,PI,TAU,40,Color(0.2,0.8,1,0.8),5,true)
  if health<max_health*0.6:
   for j in range(5):
    draw_circle(Vector2(350+j*11+sin(clock+j)*8,800-fmod(clock*26+j*18,90)),10+j*2,Color(0.18,0.18,0.16,0.3))
  for e in enemies:
   if not enemy_visible(e):
    continue
   if e.get("boss",false):
    draw_texture_rect(boss_texture(e.row),Rect2(e.pos-Vector2(85,85),Vector2(170,170)),false)
    draw_rect(Rect2(e.pos+Vector2(-65,-88),Vector2(130,10)),Color("252525"))
    draw_rect(Rect2(e.pos+Vector2(-65,-88),Vector2(130*maxf(0,e.hp)/e.max_hp,10)),Color("ff8445"))
    continue
   var f=int(e.age*7)%6
   var visual_kind=e.kind
   if e.kind in ["kikimora","medic"]:visual_kind="soldier"
   var sz=Vector2(76,76) if e.kind in ["soldier","kikimora","medic"] else Vector2(125,125) if e.kind=="vehicle" else Vector2(97,97)
   sprite("%s_%d_%d_s%d"%[visual_kind,e.row,f,season],e.pos,sz)
   if e.kind=="kikimora":
    draw_circle(e.pos+Vector2(-10,-6),13,Color(0.28,0.45,0.22,0.72))
    draw_circle(e.pos+Vector2(12,-4),11,Color(0.34,0.51,0.24,0.68))
    draw_circle(e.pos+Vector2(0,10),14,Color(0.25,0.40,0.18,0.64))
   elif e.kind=="medic":
    draw_rect(Rect2(e.pos+Vector2(-11,-31),Vector2(22,16)),Color(0.24,0.42,0.22,0.96))
    draw_rect(Rect2(e.pos+Vector2(-3,-35),Vector2(6,5)),Color(0.24,0.42,0.22,0.96))
    draw_rect(Rect2(e.pos+Vector2(-7,-28),Vector2(14,10)),Color(0.96,0.96,0.94,0.98))
    draw_rect(Rect2(e.pos+Vector2(-2,-26),Vector2(4,6)),Color(0.84,0.14,0.14,0.98))
    draw_rect(Rect2(e.pos+Vector2(-5,-23),Vector2(10,4)),Color(0.84,0.14,0.14,0.98))
   if e.max_hp>2 and not e.get("boss",false):
    draw_rect(Rect2(e.pos+Vector2(-26,-42),Vector2(52,6)),Color("252525"))
    draw_rect(Rect2(e.pos+Vector2(-26,-42),Vector2(52*maxf(0,e.hp)/e.max_hp,6)),Color("c9e26d") if e.kind=="medic" else Color("e78c43"))
   if e.get("mini_boss",false):
    draw_rect(Rect2(e.pos+Vector2(-40,-58),Vector2(80,8)),Color("252525"))
    draw_rect(Rect2(e.pos+Vector2(-40,-58),Vector2(80*maxf(0,e.hp)/e.max_hp,8)),Color("ff8445"))
    draw_string(ThemeDB.fallback_font,e.pos+Vector2(-18,-62),"MINI",HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("fff0be"))
   if e.kind in ["vehicle","bike"] and e.hp<e.max_hp:
    draw_texture_rect(tex("damage_smoke"),Rect2(e.pos+Vector2(-24,-78),Vector2(52,68)),false,Color(1,1,1,0.65))
    draw_circle(e.pos+Vector2(0,-24),9,Color(0.13,0.13,0.13,0.38))
    draw_circle(e.pos+Vector2(6,-43),12,Color(0.19,0.19,0.19,0.25))
   if e.get("panic_until",0.0)>elapsed:draw_arc(e.pos,35,0,TAU,20,Color("ffce71"),2,true)
   if elapsed<reveal_until:draw_arc(e.pos,e.r,0,TAU,24,Color.CYAN,2)
  for p in pickups:
   sprite("loot_%d"%p.kind,p.pos+Vector2(0,sin(clock*3)*3),Vector2(66,66))
  for d in drones:
   sprite("drone_%d_%d"%[2 if d.kind==0 else 0 if d.kind==1 else 1,int(clock*12)%6],d.pos,Vector2(88,88))
  for b in blasts:
   var c=Color("57caff") if b.pulse else Color("ffae27")
   c.a=b.ttl/0.45
   draw_circle(b.pos,b.r*(1-b.ttl/0.5),c)
   for spark in range(10):
    var direction=Vector2.from_angle(spark*TAU/10)
    draw_line(b.pos+direction*b.r*(1-b.ttl/0.45),b.pos+direction*b.r*(1.2-b.ttl/0.45),c,3,true)
  draw_weather()
  if elapsed<spotlight_until:
   draw_arc(Vector2(360,887),340,PI,TAU,54,Color(1,0.97,0.55,0.65),4,true)
   draw_circle(Vector2(360,700),190,Color(1,0.95,0.55,0.07))
  draw_style_box(panel_style(Color("d7c58a")),Rect2(6,988,708,263))
  draw_style_box(panel_style(Color("34431ed9")),Rect2(6,4,700,72))
  if screen!="game":draw_rect(Rect2(0,0,720,1280),Color(0,0,0,0.55))
 else:
  draw_weather()
  if screen=="map":
   var route=PackedVector2Array()
   for n in range(20):
    var row=int(n/4)
    var col=n%4 if row%2==0 else 3-n%4
    route.append(Vector2(105+col*170,272+row*165))
   draw_polyline(route,Color("ffdc88"),10,true)
  draw_rect(Rect2(0,0,720,1280),Color(0.08,0.12,0.03,0.4))
  if screen=="menu":sprite("drone_2_0",Vector2(360,337),Vector2(148,148))
 draw_monitor_frame()

func panel_style(color):
 var s=StyleBoxFlat.new()
 s.bg_color=color
 s.border_color=Color("222a18")
 s.set_border_width_all(4)
 s.set_corner_radius_all(20)
 return s

func draw_weather():
 var height=weather_height()
 var dlight=active_daylight()
 if screen in ["game","paused","over","victory"]:
  var darkness=daylight_blend if mission_night else 0.0
  draw_rect(Rect2(0,0,720,height),Color(0.02,0.05,0.16,0.56*darkness))
 elif dlight==1:draw_rect(Rect2(0,0,720,height),Color(0.5,0.23,0.04,0.17))
 elif dlight==2:draw_rect(Rect2(0,0,720,height),Color(0.02,0.05,0.16,0.56))
 var rain=weather_weights[1]
 var fog=weather_weights[2]
 var snow=weather_weights[3]
 if rain>0.01:
  for i in range(85):
   var p=Vector2(fposmod(i*113.0-weather_clock*90,720),fposmod(i*73.0+weather_clock*520,height))
   draw_line(p,p+Vector2(-7,22),Color(0.75,0.88,1,rain*0.45),1.5,true)
  for i in range(9):
   var p=Vector2(290+fposmod(i*47.0,140),170+i*78)
   var ripple=fposmod(weather_clock*0.8+i*0.3,1.0)
   draw_arc(p,3+12*ripple,0,TAU,16,Color(0.78,0.9,1,rain*(1-ripple)*0.3),1,true)
 if fog>0.01:
  draw_rect(Rect2(0,0,720,height),Color(0.76,0.83,0.83,fog*0.08))
  for i in range(10):
   var center=Vector2(fposmod(i*133.0+weather_clock*14,980)-130,95+i*(height/10))
   for ring in range(3):
    draw_circle(center+Vector2(0,sin(weather_clock*0.3+i)*12),145-ring*35,Color(0.87,0.91,0.9,fog*0.026))
 if snow>0.01:
  draw_rect(Rect2(0,0,720,height),Color(0.76,0.86,0.94,snow*0.05))
  for i in range(90):
   var p=Vector2(fposmod(i*83.0+sin(weather_clock+i)*18+weather_clock*8,720),fposmod(i*53.0+weather_clock*(45+i%4*9),height))
   draw_circle(p,1.5+i%3,Color(1,1,1,snow*0.75))
 if mission_night and screen in ["game","paused","over","victory"]:
  draw_rect(Rect2(0,0,720,height),Color(0.01,0.03,0.08,0.18*daylight_blend))
  draw_arc(Vector2(360,887),300,PI,TAU,48,Color(0.78,0.88,1,0.08),2,true)
  if elapsed<reveal_until:
   for e in enemies:
    draw_circle(e.pos,58+e.r*0.2,Color(0.65,0.9,1,0.08))


func draw_monitor_frame():
 draw_rect(Rect2(3,3,714,1274),Color(0.10,0.13,0.10,0.58),false,6,true)
 draw_rect(Rect2(11,11,698,1258),Color(0.88,0.82,0.60,0.18),false,2,true)
 draw_line(Vector2(24,18),Vector2(110,18),Color(0.98,0.94,0.78,0.30),2,true)
 draw_line(Vector2(610,18),Vector2(696,18),Color(0.98,0.94,0.78,0.30),2,true)
 draw_line(Vector2(24,1262),Vector2(110,1262),Color(0.98,0.94,0.78,0.20),2,true)
 draw_line(Vector2(610,1262),Vector2(696,1262),Color(0.98,0.94,0.78,0.20),2,true)

func _exit_tree():
 stop_speech()
 if is_instance_valid(voice):
  voice.stop()
  voice.stream=null
 if is_instance_valid(audio):
  audio.stop()
  audio.stream=null
 for player in sfx_pool+[music_player,drone_loop,vehicle_loop,foot_loop,weather_loop]:
  if is_instance_valid(player):
   player.stop()
   player.stream=null
 if is_instance_valid(cursor_sprite):cursor_sprite.texture=null
 cache.clear()
 Input.mouse_mode=Input.MOUSE_MODE_VISIBLE

const EXTRA = {
"campaign":["КАМПАНІЯ","КАМПАНИЯ","CAMPAIGN"],"achievements":["ДОСЯГНЕННЯ","ДОСТИЖЕНИЯ","ACHIEVEMENTS"],"shop":["МАГАЗИН","МАГАЗИН","SHOP"],"collection":["КОЛЕКЦІЯ","КОЛЛЕКЦИЯ","COLLECTION"],"difficulty":["СКЛАДНІСТЬ","СЛОЖНОСТЬ","DIFFICULTY"],"easy":["ЛЕГКО","ЛЕГКО","EASY"],"normal":["ЗВИЧАЙНО","ОБЫЧНО","NORMAL"],"hard":["СКЛАДНО","СЛОЖНО","HARD"],"voice":["ОЗВУЧЕННЯ","ОЗВУЧКА","VOICE"],"level":["РІВЕНЬ","УРОВЕНЬ","LEVEL"],"victory":["БАЗУ ЗАХИЩЕНО!","БАЗА ЗАЩИЩЕНА!","BASE PROTECTED!"],"next":["ДАЛІ","ДАЛЬШЕ","NEXT"],"route":["МАРШРУТ · 60 РІВНІВ","МАРШРУТ · 60 УРОВНЕЙ","ROUTE · 60 LEVELS"],"buy":["КУПИТИ","КУПИТЬ","BUY"],"money":["Бракує монет","Не хватает монет","Not enough coins"],"bought":["Запас для наступного бою додано!","Запас для следующего боя добавлен!","Supplies added for the next battle!"],"reward":["НАГОРОДА","НАГРАДА","REWARD"],"claim":["ЗАБРАТИ","ЗАБРАТЬ","CLAIM"],"done":["ОТРИМАНО","ПОЛУЧЕНО","CLAIMED"],"found":["ЗНАЙДЕНО","НАЙДЕНО","FOUND"],"unknown":["ЩЕ НЕ ЗНАЙДЕНО","ЕЩЁ НЕ НАЙДЕНО","NOT FOUND YET"],"all_done":["Усі 60 рівнів пройдено!","Все 60 уровней пройдены!","All 60 levels completed!"],"shop_hint":["Покупки додаються у наступний бій. Монети — за перемоги.","Покупки добавляются в следующий бой. Монеты — за победы.","Purchases supply the next battle. Earn coins by winning."],"map_hint":["Захистіть базу від усіх ворогів. Сезон змінюється кожні 15 рівнів.","Защитите базу от всех врагов. Сезон меняется каждые 15 уровней.","Protect the base from all enemies. Seasons change every 15 levels."]}

func x(key):
 return EXTRA[key][["uk","ru","en"].find(lang)]

func equipment_description(i):
 var descriptions={
 "uk":["Швидкий камікадзе. Урон 2, радіус 45. Натисніть на ворога для запуску. Витрачає 1 дрон + 1 БК.","Повільніший, потужний. Урон 4, радіус 110. Добре проти техніки та груп. Витрачає 1 дрон + 1 БК.","Без удару: на 12 секунд позначає ворогів. БК не витрачається. Витрачає 1 дрон.","Стандартний удар. Урон і радіус залежать від обраного дрона.","Радіус вибуху ×1,35. Урон той самий. Для щільних груп ворогів.","Наносить звичайний урон та зменшує швидкість вцілілих ворогів удвічі."],
 "ru":["Быстрый камикадзе. Урон 2, радиус 45. Нажмите на врага для запуска. Расход: 1 дрон + 1 БК.","Медленнее, мощнее. Урон 4, радиус 110. Против техники и групп. Расход: 1 дрон + 1 БК.","Без удара: на 12 секунд отмечает врагов. БК не расходуется. Расход: 1 дрон.","Стандартный удар. Урон и радиус зависят от выбранного дрона.","Радиус взрыва ×1,35. Урон прежний. Для плотных групп врагов.","Наносит обычный урон и уменьшает скорость выживших врагов вдвое."],
 "en":["Fast kamikaze. Damage 2, radius 45. Tap an enemy to launch. Costs 1 drone + 1 ammo.","Slower, stronger. Damage 4, radius 110. Best against vehicles and groups. Costs 1 drone + 1 ammo.","No damage: marks enemies for 12 seconds. Uses no ammo. Costs 1 drone.","Standard strike. Damage and radius depend on the selected drone.","Blast radius ×1.35. Same damage. Best against clustered enemies.","Normal damage, plus halves the speed of surviving enemies."]}
 return descriptions[lang][i]

func load_progress():
 var cfg=ConfigFile.new()
 if cfg.load("user://settings.cfg")==OK:
  difficulty=clampi(int(cfg.get_value("settings","difficulty",1)),0,2)
  voice_on=cfg.get_value("settings","voice",true)
  general_voice_name=cfg.get_value("settings","general_voice_name","oleksa")
  if general_voice_name not in ["oleksa","mykyta"]:general_voice_name="oleksa"
  enemy_voices_on=cfg.get_value("settings","enemy_voices_on",true)
  sound_on=cfg.get_value("settings","sound",true)
  music_on=cfg.get_value("settings","music",true)
  daylight=clampi(int(cfg.get_value("settings","daylight",0)),0,2)
  weather=clampi(int(cfg.get_value("settings","weather",0)),0,3)
  weather_auto=cfg.get_value("settings","weather_auto",true)
  manual_weather=clampi(int(cfg.get_value("settings","manual_weather",weather)),0,3)
 if cfg.load("user://campaign.cfg")!=OK:return
 unlocked=clampi(int(cfg.get_value("progress","unlocked",1)),1,60)
 stars=cfg.get_value("progress","stars",{})
 wallet=maxi(0,int(cfg.get_value("progress","wallet",0)))
 reserves=cfg.get_value("progress","reserves",[0,0,0,0])
 stats=cfg.get_value("progress","stats",stats)
 claimed=cfg.get_value("progress","claimed",[])
 collection=cfg.get_value("progress","collection",[])
 var saved_upgrades=cfg.get_value("progress","upgrades",{})
 var saved_stash=cfg.get_value("progress","stash",{})
 for key in upgrades:upgrades[key]=clampi(int(saved_upgrades.get(key,0)),0,3)
 for key in stash:stash[key]=clampi(int(saved_stash.get(key,0)),0,99)
 if cfg.has_section_key("progress","xp"):
  xp=maxi(0,int(cfg.get_value("progress","xp",0)))
  research_points=maxi(0,int(cfg.get_value("progress","research_points",0)))
 else:
  xp=0
  for stage in stars:xp+=first_xp(int(stage),int(stars[stage]),8+mini(int(stage)*2,40),1)
  research_points=maxi(0,player_rank()-1-int(upgrades.armor+upgrades.motor+upgrades.optics+upgrades.supply))
 var saved_study=cfg.get_value("progress","studied_defenses",{})
 var saved_defense_stock=cfg.get_value("progress","defense_stock",{})
 for key in studied_defenses:studied_defenses[key]=bool(saved_study.get(key,false))
 for key in defense_stock:defense_stock[key]=clampi(int(saved_defense_stock.get(key,0)),0,20)

func save_progress():
 var cfg=ConfigFile.new()
 for key in ["unlocked","stars","wallet","reserves","stats","claimed","collection","upgrades","stash","xp","research_points","progression_version","studied_defenses","defense_stock"]:
  cfg.set_value("progress",key,get(key))
 cfg.save("user://campaign.cfg")

func say(event,force=false):
 if not voice_on or not is_instance_valid(voice):return
 if not force and (voice_cooldown>0 or speech_active()):return
 var phrase=SPEECH[lang].get(event,"")
 if phrase.is_empty():return
 var path="res://assets/voices_v2/%s/%s_%s.wav" % [general_voice_name,lang,event]
 if not ResourceLoader.exists(path):
  path="res://assets/voices_v2/%s_%s.wav" % [lang,event]
 stop_speech()
 var duration=3.4
 general_duration=duration
 general_time=duration if screen=="game" else 0.0
 if is_instance_valid(general_sprite):general_sprite.visible=general_time>0
 voice_cooldown=7.0
 if sound_on and ResourceLoader.exists(path):
  voice.stream=load(path)
  voice.pitch_scale=1.0
  voice.volume_db=1.5
  duration=voice.stream.get_length()
  voice.play()
 else:
  return
 general_duration=minf(duration+0.6,7.0)
 general_time=general_duration if screen=="game" else 0.0
 if is_instance_valid(general_sprite):general_sprite.visible=general_time>0
 if is_instance_valid(music_player):music_player.volume_db=-39
 for player in sfx_pool:
  if is_instance_valid(player):player.volume_db=-26
 voice_cooldown=10.0


func play_enemy_voice(event:String):
 if not voice_on or not enemy_voices_on or not sound_on or screen!="game":return
 if enemy_voice_cooldown>0 or not is_instance_valid(enemy_voice):return
 if is_instance_valid(voice) and voice.playing:return
 if general_time>0:return
 var path="res://assets/voices_v2/enemies/uk_%s.wav" % event
 if not ResourceLoader.exists(path):return
 enemy_voice.stream=load(path)
 enemy_voice.pitch_scale=randf_range(0.96,1.04)
 enemy_voice.play()
 enemy_voice_cooldown=randf_range(14.0,23.0)

func discover(key):
 if key not in collection:collection.append(key)

func show_map():
 screen="map"
 clear_ui()
 season=mini(int((unlocked-1)/15),3)
 ensure_season_weather()
 label(x("route"),Rect2(10,15,700,65),32)
 add_unlock_icon(Vector2(25,87),Vector2(90,90))
 var hint=label(next_unlock_text(),Rect2(125,82,555,105),20)
 hint.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 for n in range(20):
  var number=map_page*20+n+1
  var row=int(n/4)
  var col=n%4 if row%2==0 else 3-n%4
  var yy=220+row*165
  var caption=str(number)+(" ☠" if number%10==0 else "")+("
"+"★".repeat(int(stars.get(str(number),0))) if stars.has(str(number)) else "")
  var chosen=number
  var btn=button(caption,Rect2(40+col*170,yy,130,105),func(): level=chosen; prepare_stage(),number==unlocked,28)
  btn.tooltip_text=x("level")+" %d · " % number+t(20+mini(int((number-1)/15),3))
  btn.disabled=number>unlocked
  if btn.disabled:btn.modulate=Color(0.55,0.55,0.55)
 for i in range(3):
  var page=i
  button("%d–%d" % [i*20+1,(i+1)*20],Rect2(40+i*230,1075,210,70),func(): map_page=page; show_map(),map_page==i,24)
 button(t(15),Rect2(160,1170,400,75),show_menu,true)
 queue_redraw()

func win_level():
 if reward_paid:return
 screen="victory"
 var ratio=health/float(max_health)
 var rating=3 if ratio>=0.8 else 2 if ratio>=0.45 else 1
 settle_result(true,rating)
 say("win",true)
 show_result(true,rating)

func show_shop():
 screen="research" if shop_tab==1 else "shop"
 clear_ui()
 label((localized(["ДОСЛІДЖЕННЯ","ИССЛЕДОВАНИЯ","RESEARCH"]) if shop_tab==1 else x("shop"))+"  ◎ %d" % wallet,Rect2(20,25,680,65),34)
 label(localized(["Рівень","Уровень","Rank"])+" %d · XP %d/%d · ◇ %d" % [player_rank(),xp,xp_for_rank(player_rank()+1),research_points],Rect2(20,92,680,50),21)
 for j in range(2):
  var tab=j
  button(localized([["ЗАПАСИ","ЗАПАСЫ","SUPPLIES"],["ДОСЛІДЖЕННЯ","ИССЛЕДОВАНИЯ","RESEARCH"]][j]),Rect2(30+j*345,150,330,65),func(): shop_tab=tab;shop_scroll=0;show_shop(),shop_tab==j,24)
 shop_scroll_node=ScrollContainer.new()
 shop_scroll_node.position=Vector2(25,235)
 shop_scroll_node.size=Vector2(670,800)
 shop_scroll_node.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
 ui.add_child(shop_scroll_node)
 var rows=VBoxContainer.new()
 rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 rows.add_theme_constant_override("separation",14)
 shop_scroll_node.add_child(rows)
 for i in range(SHOP.size()):
  var item=SHOP[i]
  if int(item.has("upgrade") or item.has("study"))!=shop_tab:continue
  var index=i
  var panel=PanelContainer.new()
  panel.custom_minimum_size=Vector2(645,195)
  panel.add_theme_stylebox_override("panel",panel_style(Color("293821ed")))
  rows.add_child(panel)
  var margin=MarginContainer.new()
  for side in ["left","right","top","bottom"]:margin.add_theme_constant_override("margin_"+side,12)
  panel.add_child(margin)
  var content=HBoxContainer.new()
  content.add_theme_constant_override("separation",12)
  margin.add_child(content)
  var img=TextureRect.new()
  img.texture=shop_icon(item)
  img.custom_minimum_size=Vector2(108,130)
  img.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  img.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  content.add_child(img)
  var info=VBoxContainer.new()
  info.size_flags_horizontal=Control.SIZE_EXPAND_FILL
  content.add_child(info)
  var title=Label.new()
  title.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  title.text=localized(item.title)
  title.add_theme_font_size_override("font_size",24)
  info.add_child(title)
  var detail=Label.new()
  detail.text=localized(item.desc)
  detail.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  detail.custom_minimum_size.x=305
  detail.add_theme_font_size_override("font_size",19)
  info.add_child(detail)
  var count=shop_count(i)
  var status=Label.new()
  status.text=(localized(["Рівень","Уровень","Level"])+" %d/3" % count) if item.has("upgrade") else localized(["У запасі","В запасе","In stock"])+" %d" % count
  if item.has("study"):status.text=localized(["Вивчено","Изучено","Researched"]) if count>0 else localized(["Відкриває покупку та розміщення","Открывает покупку и размещение","Unlocks purchase and deployment"])
  var key=shop_feature(i)
  if not shop_available(i):status.text=shop_requirement(i)
  status.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  status.add_theme_font_size_override("font_size",16)
  info.add_child(status)
  var buy=Button.new()
  var price=shop_price(i)
  buy.text=(localized(["ВИВЧИТИ","ИЗУЧИТЬ","RESEARCH"]) if item.has("upgrade") or item.has("study") else x("buy"))+"\n◎ %d" % price
  if item.has("upgrade") or item.has("study"):buy.text+="\n◇ 1"
  buy.custom_minimum_size=Vector2(130,105)
  buy.add_theme_font_size_override("font_size",20)
  buy.disabled=not shop_available(i) or wallet<price or ((item.has("upgrade") or item.has("study")) and research_points<1) or (item.has("upgrade") and count>=3) or (item.has("study") and count>0) or (not item.has("upgrade") and not item.has("study") and count>=shop_stock_limit(i))
  if item.has("upgrade") and count>=3:buy.text="MAX"
  if item.has("study") and count>0:buy.text=localized(["ВИВЧЕНО","ИЗУЧЕНО","KNOWN"])
  buy.pressed.connect(func(): shop_scroll=shop_scroll_node.scroll_vertical;buy_item(index))
  content.add_child(buy)
 shop_scroll_node.set_deferred("scroll_vertical",shop_scroll)
 label(notice if notice_time>0 else localized(["Ремонт, щит і батареї: кнопки над дронами у бою","Ремонт, щит и батареи: кнопки над дронами в бою","Repair, shield and batteries: buttons above drones in battle"]),Rect2(25,1045,670,70),19).autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 button(t(15),Rect2(160,1150,400,85),show_menu,true)
 queue_redraw()

func shop_price(i):
 var item=SHOP[i]
 return item.price*(1+upgrades[item.upgrade]) if item.has("upgrade") else item.price

func buy_item(i):
 if i<0 or i>=SHOP.size():return
 var item=SHOP[i]
 var price=shop_price(i)
 if not shop_available(i):announce(shop_requirement(i));show_shop();return
 if (item.has("upgrade") or item.has("study")) and research_points<1:return
 if item.has("upgrade") and upgrades[item.upgrade]>=3:return
 if item.has("stash") and stash[item.stash]>=99:return
 if item.has("study") and studied_defenses[item.study]:return
 if item.has("defense") and defense_stock[item.defense]>=20:return
 if i<3 and reserves[i]+[3,1,8][i]>[30,12,80][i]:return
 if wallet<price:announce(x("money"));show_shop();return
 wallet-=price
 if i<3:reserves[i]+=[3,1,8][i]
 elif item.has("upgrade"):upgrades[item.upgrade]+=1;research_points-=1
 elif item.has("study"):studied_defenses[item.study]=true;research_points-=1
 elif item.has("defense"):defense_stock[item.defense]+=1
 else:stash[item.stash]+=1
 save_progress()
 announce(localized(["Технологію вивчено!","Технология изучена!","Technology researched!"]) if item.has("study") else x("bought"))
 play_sfx("collect")
 show_shop()

func achievement_values():
 return [stats.kills,stats.kills,stats.crates,stats.recon,stars.size(),stars.size(),stars.size(),stars.values().count(3),int(stats.get("missions",0))]

func show_achievements():
 screen="achievements"
 clear_ui()
 label(x("achievements"),Rect2(10,35,700,75),36)
 var names={"uk":["Перший удар","Мисливець","Збирач","Очі в небі","Перший рубіж","На півдорозі","Весь маршрут","Ідеальний захист","Наказ генерала"],"ru":["Первый удар","Охотник","Собиратель","Глаза в небе","Первый рубеж","На полпути","Весь маршрут","Идеальная защита","Приказ генерала"],"en":["First strike","Hunter","Collector","Eyes in the sky","First checkpoint","Halfway there","Full route","Perfect defense","General orders"]}
 var targets=[1,100,20,5,1,30,60,10,5]
 var values=achievement_values()
 for i in range(9):
  var id=i
  var y=135+i*112
  label(names[lang][i]+"  %d/%d" % [mini(values[i],targets[i]),targets[i]],Rect2(15,y,450,70),23)
  var btn=button(x("done") if i in claimed else x("claim")+" ◎30",Rect2(465,y,235,72),func(): claim_achievement(id),i not in claimed and values[i]>=targets[i],19)
  btn.disabled=i in claimed or values[i]<targets[i]
 button(t(15),Rect2(160,1160,400,80),show_menu,true)
 queue_redraw()

func claim_achievement(i):
 var targets=[1,100,20,5,1,30,60,10,5]
 if i in claimed or achievement_values()[i]<targets[i]:return
 claimed.append(i)
 wallet+=30
 save_progress()
 show_achievements()

func show_collection():
 screen="collection"
 clear_ui()
 label(x("collection"),Rect2(10,20,700,70),36)
 var scroll=ScrollContainer.new()
 scroll.position=Vector2(20,110)
 scroll.size=Vector2(680,1000)
 ui.add_child(scroll)
 var rows=VBoxContainer.new()
 rows.add_theme_constant_override("separation",12)
 scroll.add_child(rows)
 var entries=[]
 for i in range(3):entries.append(["drone_"+str(i),"drone_%d_0" % [2,0,1][i]])
 for kind in ["soldier","vehicle","bike"]:
  for i in range(3 if kind=="bike" else 4):entries.append([kind+"_"+str(i),kind+"_%d_0_s1" % i])
 for i in range(12):entries.append(["loot_"+str(i),"loot_"+str(i)])
 for i in range(6):entries.append(["boss_"+str(i),"boss_"+str(i)])
 for key in DEFENSE_KEYS:entries.append(["def_"+key,"def_"+key])
 for item in entries:
  var row=HBoxContainer.new()
  row.custom_minimum_size=Vector2(650,110)
  row.add_theme_constant_override("separation",16)
  rows.add_child(row)
  var img=TextureRect.new()
  img.custom_minimum_size=Vector2(110,110)
  img.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  img.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  img.texture=defense_icon(DEFENSE_KEYS.find(item[0].trim_prefix("def_"))) if item[0].begins_with("def_") else boss_texture(int(item[1].split("_")[1])) if item[0].begins_with("boss_") else tex(item[1])
  var found=item[0] in collection or (item[0].begins_with("drone") and feature_open(["fpv","heavy","recon"][int(item[0].split("_")[1])]))
  if item[0].begins_with("def_"):found=feature_open(item[0].trim_prefix("def_"))
  if not found:img.modulate=Color(0.12,0.12,0.12)
  row.add_child(img)
  var txt=Label.new()
  txt.text=collection_name(item[0])+"
"+(x("found") if found else x("unknown"))
  txt.add_theme_font_size_override("font_size",20)
  row.add_child(txt)
 button(t(15),Rect2(160,1160,400,80),show_menu,true)
 queue_redraw()

func collection_name(key):
 if key.begins_with("def_"):return feature_name(key.trim_prefix("def_"))
 var id=int(key.split("_")[1])
 if key.begins_with("boss"):return localized(BOSS_NAMES[id])
 if key.begins_with("drone"):return ["FPV",t(6),t(7)][id]
 if key.begins_with("loot"):
  var names={"uk":["Звичайний БК","Вибуховий БК","Імпульсний БК","FPV +2","FPV +3","Важкий дрон","Розвідка","Ремонт бази","Монети","Сповільнення","Щит","Подвійні очки"],"ru":["Обычный БК","Взрывной БК","Импульсный БК","FPV +2","FPV +3","Тяжёлый дрон","Разведка","Ремонт базы","Монеты","Замедление","Щит","Двойные очки"],"en":["Standard ammo","Explosive ammo","Pulse ammo","FPV +2","FPV +3","Heavy drone","Recon","Base repair","Coins","Slowdown","Shield","Double score"]}
  return names[lang][id]
 if key.begins_with("vehicle_"):
  return localized([["Танк","Бронеавтомобіль","Вантажівка","Джип"],["Танк","Бронеавтомобиль","Грузовик","Джип"],["Tank","Armored car","Truck","Jeep"]])[id]
 var names={"uk":["Піхота","Техніка","Мотоцикл"],"ru":["Пехота","Техника","Мотоцикл"],"en":["Infantry","Vehicle","Motorbike"]}
 return names[lang][["soldier","vehicle","bike"].find(key.split("_")[0])]+" %d" % (id+1)

func collection_description(key):
 if not key.begins_with("boss_") and not key.begins_with("soldier_") and not key.begins_with("vehicle_") and not key.begins_with("bike_"):return ""
 var id=int(key.split("_")[1])
 var stage=1
 var hp=1
 var details=""
 if key.begins_with("boss_"):
  stage=(id+1)*10
  hp=16+id*8
  details=localized([
   ["Прискорюється, коли міцність нижча за половину.","Викликає до трьох піхотинців: один кожні 8 с.","Кожні 8 с затримує наступний ящик постачання.","Броня зменшує урон FPV на 1. Сповільнюється зубами дракона.","Викликає до трьох піхотинців. Сповільнюється зубами дракона.","Відновлює 3 міцності кожні 8 с. Сповільнюється зубами дракона."],
   ["Ускоряется, когда прочность ниже половины.","Вызывает до трёх пехотинцев: один каждые 8 с.","Каждые 8 с задерживает следующий ящик снабжения.","Броня уменьшает урон FPV на 1. Замедляется зубами дракона.","Вызывает до трёх пехотинцев. Замедляется зубами дракона.","Восстанавливает 3 прочности каждые 8 с. Замедляется зубами дракона."],
   ["Accelerates below half health.","Calls up to three infantry escorts, one every 8s.","Delays the next supply crate every 8s.","Armor reduces FPV damage by 1. Dragon teeth slow it.","Calls up to three infantry escorts. Dragon teeth slow it.","Repairs 3 HP every 8s. Dragon teeth slow it."]
  ])[id]
  details+=" " + localized(["З'являється після хвилі. Прорив до бази — поразка, навіть зі щитом.","Появляется после волны. Прорыв к базе — поражение, даже со щитом.","Appears after the wave. Reaching the base causes defeat, even with a shield."])
 elif key.begins_with("soldier_"):
  stage=1+id*2
  details=localized(["Іде до бази, іноді виходить із кущів. Дріт і протипіхотні міни діють; протитанкові перешкоди не діють. Варіанти мають однакові характеристики.","Идёт к базе, иногда выходит из кустов. Действуют проволока и мины против пехоты. Препятствия для техники не действуют. У вариантов одинаковые характеристики.","Advances on the base and may emerge from bushes. Wire and infantry mines work; vehicle defenses do not. Variants share the same stats."])
 elif key.begins_with("vehicle_"):
  stage=9+id*10
  hp=4 if id==0 else 3
  details=localized(["Шипи та міни проти техніки діють. Піхотні пастки не діють.","Действуют шипы и мины против техники. Ловушки для пехоты не действуют.","Spikes and vehicle mines work. Infantry traps do not."])
  if id==0:details+=" "+localized(["Танк також сповільнюється зубами дракона.","Танк также замедляется зубами дракона.","Dragon teeth also slow this tank."])
 else:
  stage=6+id*10
  hp=2
  details=localized(["Швидша за піхоту й важку техніку ціль. Діють шипи та міни проти техніки; зуби дракона не діють.","Цель быстрее пехоты и тяжёлой техники. Действуют шипы и мины против техники; зубы дракона не действуют.","Faster than infantry and heavy vehicles. Spikes and vehicle mines work; dragon teeth do not."])
 var header=localized(["З рівня %d · міцність %d (звичайна складність)","С уровня %d · прочность %d (обычная сложность)","From stage %d · %d HP (normal difficulty)"]) % [stage,hp]
 return header+"\n"+details

func toggle_sound():
 sound_on=not sound_on
 if not sound_on:
  audio.stop()
  voice.stop()
  for player in sfx_pool:player.stop()
  if is_instance_valid(weather_loop):weather_loop.stop()
  stop_speech()
 save_settings()
 show_settings()

func toggle_voice():
 voice_on=not voice_on
 if not voice_on:voice.stop();stop_speech()
 save_settings()
 show_settings()
 if voice_on:say("ready",true)


const SHOP = [
 {"title":["FPV ×3","FPV ×3","FPV ×3"],"desc":["Три дрони на наступний бій","Три дрона на следующий бой","Three drones for the next battle"],"price":30,"icon":0},
 {"title":["Важкий дрон","Тяжёлый дрон","Heavy drone"],"desc":["+1 важкий дрон на наступний бій","+1 тяжёлый дрон на следующий бой","+1 heavy drone next battle"],"price":40,"icon":1},
 {"title":["Звичайний БК ×8","Обычный БК ×8","Standard ammo ×8"],"desc":["Запас на наступний бій","Запас на следующий бой","Supplies for the next battle"],"price":20,"icon":2},
 {"title":["Розвідка","Разведка","Recon"],"desc":["+1 розвідник на наступний бій","+1 разведчик на следующий бой","+1 scout drone next battle"],"price":25,"icon":3,"stash":"recon"},
 {"title":["Вибуховий БК ×4","Взрывной БК ×4","Explosive ammo ×4"],"desc":["Більший радіус вибуху","Больший радиус взрыва","Wider explosion radius"],"price":35,"icon":4,"stash":"explosive"},
 {"title":["Імпульсний БК ×4","Импульсный БК ×4","Pulse ammo ×4"],"desc":["Сповільнює вцілілих ворогів","Замедляет выживших врагов","Slows surviving enemies"],"price":35,"icon":5,"stash":"pulse"},
 {"title":["Ремкомплект","Ремкомплект","Repair kit"],"desc":["Кнопка у бою: +30 міцності","Кнопка в бою: +30 прочности","Battle button: repair 30 HP"],"price":25,"icon":6,"stash":"repair"},
 {"title":["Щит бази","Щит базы","Base shield"],"desc":["Кнопка у бою: захист на 10 с","Кнопка в бою: защита на 10 с","Battle button: protection for 10s"],"price":40,"icon":7,"stash":"shield"},
 {"title":["Сповільнення","Замедление","Slowdown"],"desc":["Кнопка у бою: вороги ×0,45 на 10 с","Кнопка в бою: враги ×0,45 на 10 с","Battle button: enemies ×0.45 for 10s"],"price":35,"icon":8,"stash":"slow"},
 {"title":["Батареї","Батареи","Batteries"],"desc":["Кнопка у бою: +2 FPV та +1 важкий","Кнопка в бою: +2 FPV и +1 тяжёлый","Battle button: +2 FPV and +1 heavy"],"price":45,"icon":9,"stash":"battery"},
 {"title":["Броня бази","Броня базы","Base armor"],"desc":["Назавжди: +20 міцності за рівень","Навсегда: +20 прочности за уровень","Permanent: +20 base HP per rank"],"price":90,"icon":10,"upgrade":"armor"},
 {"title":["Двигуни","Двигатели","Drone motors"],"desc":["Назавжди: +15% швидкості за рівень","Навсегда: +15% скорости за уровень","Permanent: +15% speed per rank"],"price":80,"icon":11,"upgrade":"motor"},
 {"title":["Оптика","Оптика","Targeting optics"],"desc":["Назавжди: +1 урон, +8% радіуса за рівень","Навсегда: +1 урон, +8% радиуса за уровень","Permanent: +1 damage, +8% radius per rank"],"price":120,"icon":12,"upgrade":"optics"},
 {"title":["Постачання","Снабжение","Supply network"],"desc":["Назавжди: частіші ящики, +1 монета за ціль","Навсегда: чаще ящики, +1 монета за цель","Permanent: more crates, +1 coin per kill per rank"],"price":100,"icon":13,"upgrade":"supply"},
 {"title": ["Колючий дріт", "Колючая проволока", "Barbed wire"], "desc": ["Сповільнює лише піхоту. 45 с.", "Замедляет только пехоту. 45 с.", "Slows infantry only. 45s."], "price": 15, "icon": 0, "defense": "wire"},
 {"title": ["Колючий дріт", "Колючая проволока", "Barbed wire"], "desc": ["Вивчити технологію: відкриває предмет у магазині.", "Изучить технологию: открывает предмет в магазине.", "Research technology: unlocks the shop item."], "price": 80, "icon": 0, "study": "wire"},
 {"title": ["Зуби дракона", "Зубы дракона", "Dragon teeth"], "desc": ["Сповільнює лише танки. 45 с.", "Замедляет только танки. 45 с.", "Slows tanks only. 45s."], "price": 25, "icon": 1, "defense": "teeth"},
 {"title": ["Зуби дракона", "Зубы дракона", "Dragon teeth"], "desc": ["Вивчити технологію: відкриває предмет у магазині.", "Изучить технологию: открывает предмет в магазине.", "Research technology: unlocks the shop item."], "price": 140, "icon": 1, "study": "teeth"},
 {"title": ["Шипи", "Шипы", "Spikes"], "desc": ["Сповільнює техніку й мотоцикли. 45 с.", "Замедляет технику и мотоциклы. 45 с.", "Slows vehicles and motorbikes. 45s."], "price": 20, "icon": 2, "defense": "spikes"},
 {"title": ["Шипи", "Шипы", "Spikes"], "desc": ["Вивчити технологію: відкриває предмет у магазині.", "Изучить технологию: открывает предмет в магазине.", "Research technology: unlocks the shop item."], "price": 100, "icon": 2, "study": "spikes"},
 {"title": ["Міна проти піхоти", "Мина против пехоты", "Infantry mine"], "desc": ["Один вибух лише проти піхоти. 60 с.", "Один взрыв только против пехоты. 60 с.", "One blast against infantry only. 60s."], "price": 30, "icon": 3, "defense": "mine_soldier"},
 {"title": ["Міна проти піхоти", "Мина против пехоты", "Infantry mine"], "desc": ["Вивчити технологію: відкриває предмет у магазині.", "Изучить технологию: открывает предмет в магазине.", "Research technology: unlocks the shop item."], "price": 160, "icon": 3, "study": "mine_soldier"},
 {"title": ["Міна проти техніки", "Мина против техники", "Vehicle mine"], "desc": ["Один вибух проти техніки. 60 с.", "Один взрыв против техники. 60 с.", "One blast against vehicles. 60s."], "price": 45, "icon": 4, "defense": "mine_vehicle"},
 {"title": ["Міна проти техніки", "Мина против техники", "Vehicle mine"], "desc": ["Вивчити технологію: відкриває предмет у магазині.", "Изучить технологию: открывает предмет в магазине.", "Research technology: unlocks the shop item."], "price": 200, "icon": 4, "study": "mine_vehicle"},
 {"title":["Прожектор ×1","Прожектор ×1","Searchlight ×1"],"desc":["Вмикає світло бази на 18 с під час бою.","Освещает поле на 18 с во время боя.","Illuminates nearby enemies for 18s."],"price":45,"icon":7,"stash":"spotlight"},
 {"title":["Прожектор: дослідження","Прожектор: исследование","Research searchlight"],"desc":["Вивчити прожектор, щоб купувати заряди.","Исследовать прожектор для покупки зарядов.","Unlock searchlight charges in the shop."],"price":130,"icon":7,"study":"spotlight"}
]

func localized(values):
 return values[["uk","ru","en"].find(lang)]

func atlas_icon(index):
 var atlas=AtlasTexture.new()
 atlas.atlas=load("res://assets/shop_atlas.png")
 var cell=atlas.atlas.get_size()/4.0
 atlas.region=Rect2(Vector2(index%4,int(index/4))*cell,cell)
 return atlas

func use_boost(key):
 if screen!="game" or not feature_open(key) or stash.get(key,0)<=0:return
 if key=="repair" and health>=max_health:return
 stash[key]-=1
 match key:
  "repair":health=mini(max_health,health+30)
  "shield":shield_until=maxf(elapsed,shield_until)+10
  "slow":slow_until=maxf(elapsed,slow_until)+10
  "battery":stock[0]+=2;stock[1]+=1
 save_progress()
 play_sfx("collect")
 refresh_hud()

func setup_audio_cursor():
 for i in range(8):
  var player=AudioStreamPlayer.new()
  player.volume_db=-12
  add_child(player)
  sfx_pool.append(player)
 music_player=AudioStreamPlayer.new()
 music_player.volume_db=-24
 music_player.finished.connect(next_music)
 add_child(music_player)
 next_music()
 drone_loop=AudioStreamPlayer.new()
 drone_loop.stream=load("res://assets/audio/drone.wav")
 drone_loop.stream.loop_mode=AudioStreamWAV.LOOP_FORWARD
 add_child(drone_loop)
 vehicle_loop=AudioStreamPlayer.new()
 vehicle_loop.stream=load("res://assets/audio/engine.wav")
 vehicle_loop.stream.loop_mode=AudioStreamWAV.LOOP_FORWARD
 add_child(vehicle_loop)
 cursor_layer=CanvasLayer.new()
 cursor_layer.layer=100
 add_child(cursor_layer)
 cursor_sprite=TextureRect.new()
 cursor_sprite.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 cursor_sprite.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 cursor_sprite.texture=atlas_icon(14)
 cursor_sprite.size=Vector2(56,56)
 cursor_sprite.mouse_filter=Control.MOUSE_FILTER_IGNORE
 cursor_layer.add_child(cursor_sprite)
 foot_loop=AudioStreamPlayer.new()
 foot_loop.stream=load("res://assets/audio/steps.wav")
 foot_loop.stream.loop_mode=AudioStreamWAV.LOOP_FORWARD
 add_child(foot_loop)
 weather_loop=AudioStreamPlayer.new()
 weather_loop.stream=load("res://assets/audio/weather_rain.wav")
 weather_loop.stream.loop_mode=AudioStreamWAV.LOOP_FORWARD
 weather_loop.stream.loop_begin=0
 weather_loop.stream.loop_end=roundi(weather_loop.stream.get_length()*weather_loop.stream.mix_rate)
 add_child(weather_loop)
 cursor_touch=OS.has_feature("mobile")
 cursor_sprite.visible=not cursor_touch
 Input.mouse_mode=Input.MOUSE_MODE_HIDDEN

func next_music():
 var chosen=randi()%3
 if chosen==music_last:chosen=(chosen+1)%3
 music_last=chosen
 music_player.stream=load("res://assets/audio/music_%d.wav" % chosen)
 if sound_on and music_on:music_player.play()

func play_sfx(name):
 if not sound_on:return
 for player in sfx_pool:
  if not player.playing:
   player.stream=load("res://assets/audio/"+name+".wav")
   player.pitch_scale=randf_range(0.95,1.05)
   player.volume_db=(-28 if speech_active() else (-16 if name=="siren" else -10 if name in ["explosion","pulse"] else -14))
   player.play()
   return

func _input(event):
 if event is InputEventMouseMotion and event.device!=-1:
  cursor_touch=false
  cursor_sprite.visible=true
 if event is InputEventScreenTouch:
  cursor_touch=true
  if event.pressed:
   cursor_sprite.position=event.position-Vector2(22,4)
   cursor_timer=0.22
 if event is InputEventMouseButton and event.device!=-1 and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
  cursor_timer=0.16
 if cursor_timer>0:cursor_sprite.texture=atlas_icon(15)

func update_audio_cursor(delta):
 if not is_instance_valid(cursor_sprite):return
 cursor_timer=maxf(0,cursor_timer-delta)
 if not cursor_touch:cursor_sprite.position=get_global_mouse_position()-Vector2(22,4)
 cursor_sprite.visible=not cursor_touch or cursor_timer>0
 if cursor_timer<=0:cursor_sprite.texture=atlas_icon(14)
 if not sound_on or not music_on:
  music_player.stop()
 elif not music_player.playing:next_music()
 var battle=screen=="game" and sound_on
 music_player.pitch_scale=lerpf(music_player.pitch_scale,1.06 if battle and enemies.size()>5 else 1.0,minf(1,delta*0.5))
 music_player.volume_db=lerpf(music_player.volume_db,-48.0 if speech_active() else (-26.0 if battle and enemies.size()>5 else -30.0),minf(1,delta*3))
 if battle and not drones.is_empty():
  if not drone_loop.playing:drone_loop.play()
  drone_loop.pitch_scale=1.15 if drones[0].kind==0 else 0.7
  drone_loop.volume_db=-44 if speech_active() else -17
 else:drone_loop.stop()
 var nearest=0.0
 if battle:
  for e in enemies:
   if e.kind!="soldier":nearest=maxf(nearest,e.pos.y/815.0)
 if nearest>0:
  if not vehicle_loop.playing:vehicle_loop.play()
  vehicle_loop.volume_db=(-59 if speech_active() else -38)+nearest*18
 else:vehicle_loop.stop()
 var walking=false
 if battle:
  for e in enemies:
   if e.kind=="soldier":walking=true;break
 if walking:
  if not foot_loop.playing:foot_loop.play()
  foot_loop.volume_db=-51 if speech_active() else -33
 else:foot_loop.stop()
 for player in sfx_pool:player.volume_db=-34 if speech_active() else -12
 update_weather_audio(battle)

const FEATURES = {
 "fpv":[0,1,"FPV","FPV","FPV"], "normal":[0,1,"Звичайний БК","Обычный БК","Standard ammo"],
 "repair":[2,2,"Ремкомплект","Ремкомплект","Repair kit"], "armor":[2,2,"Броня бази","Броня базы","Base armor"],
 "motor":[3,3,"Двигуни","Двигатели","Drone motors"], "recon":[4,3,"Розвідка","Разведка","Recon"],
 "supply":[4,3,"Постачання","Снабжение","Supply network"], "slow":[5,4,"Сповільнення","Замедление","Slowdown"],
 "explosive":[6,4,"Вибуховий БК","Взрывной БК","Explosive ammo"], "optics":[6,4,"Оптика","Оптика","Targeting optics"],
 "battery":[7,4,"Батареї","Батареи","Batteries"], "heavy":[8,5,"Важкий дрон","Тяжёлый дрон","Heavy drone"],
 "shield":[12,8,"Щит бази","Щит базы","Base shield"], "double":[24,12,"Подвійні очки","Двойные очки","Double score"],
 "pulse":[18,9,"Імпульсний БК","Импульсный БК","Pulse ammo"],
 "wire":[5,4,"Колючий дріт","Колючая проволока","Barbed wire"],
 "spikes":[7,5,"Шипи","Шипы","Spikes"],
 "teeth":[12,8,"Зуби дракона","Зубы дракона","Dragon teeth"],
 "mine_soldier":[16,9,"Міна проти піхоти","Мина против пехоты","Infantry mine"],
 "mine_vehicle":[22,11,"Міна проти техніки","Мина против техники","Vehicle mine"],
 "spotlight":[8,5,"Прожектор","Прожектор","Searchlight"]
}
const BOSS_NAMES = [
 ["Командний джип","Командный джип","Command jeep"], ["Броньована вантажівка","Бронированный грузовик","Armored truck"],
 ["Глушник","Глушитель","The jammer"], ["Сталевий повзун","Стальной ползун","Steel crawler"],
 ["Конвойний велетень","Конвойный гигант","Convoy giant"], ["Рухома фортеця","Подвижная крепость","Moving fortress"]
]

func xp_for_rank(rank):
 var n=maxi(0,rank-1)
 return 80*n+30*n*(n-1)

func player_rank():
 var rank=1
 while rank<50 and xp>=xp_for_rank(rank+1):rank+=1
 return rank

func highest_cleared():
 return 60 if stars.has("60") else maxi(0,unlocked-1)

func feature_name(key):
 return FEATURES[key][2+["uk","ru","en"].find(lang)]

func feature_eligible(key):
 return highest_cleared()>=FEATURES[key][0] and player_rank()>=FEATURES[key][1]

func feature_open(key):
 return feature_eligible(key) and (not studied_defenses.has(key) or studied_defenses[key])

func feature_requirement(key,rank_override=0,stage_override=0):
 if studied_defenses.has(key) and feature_eligible(key) and not studied_defenses[key]:
  return feature_name(key)+" · "+localized(["Вивчіть у дослідженнях","Изучите в исследованиях","Research this technology"])
 return feature_name(key)+" · "+localized(["Пройти","Пройти","Clear"])+" %d · " % maxi(FEATURES[key][0],stage_override)+localized(["Рівень гравця","Уровень игрока","Player rank"])+" %d" % maxi(FEATURES[key][1],rank_override)

func available_features():
 var opened=[]
 for key in FEATURES:
  if feature_open(key):opened.append(key)
 return opened

func next_unlock_text():
 var key=""
 var nearest=100000
 for candidate in FEATURES:
  if feature_open(candidate):continue
  var distance=maxi(0,FEATURES[candidate][0]-highest_cleared())*100+maxi(0,FEATURES[candidate][1]-player_rank())
  if distance<nearest:nearest=distance;key=candidate
 if key=="":
  for i in range(10,14):
   if upgrades[SHOP[i].upgrade]<3:return localized(["ДАЛІ: ","ДАЛЕЕ: ","NEXT: "])+feature_requirement(shop_feature(i),research_rank(i),research_stage(i))+" · " + localized(["Дослідження","Исследование","Research"])+" %d/3" % (upgrades[SHOP[i].upgrade]+1)
  return localized(["Усі технології відкрито!","Все технологии открыты!","All technologies unlocked!"])
 return localized(["ДАЛІ: ","ДАЛЕЕ: ","NEXT: "])+feature_requirement(key)

func shop_feature(i):
 var item=SHOP[i]
 if item.has("study"):return item.study
 if item.has("defense"):return item.defense
 if item.has("stash"):return item.stash
 return ["fpv","heavy","normal","recon","explosive","pulse","repair","shield","slow","battery","armor","motor","optics","supply"][i]

func research_rank(i):
 var item=SHOP[i]
 return FEATURES[shop_feature(i)][1]+4*upgrades[item.upgrade] if item.has("upgrade") else 0

func research_stage(i):
 var item=SHOP[i]
 return FEATURES[shop_feature(i)][0]+[0,10,25,25][upgrades[item.upgrade]] if item.has("upgrade") else FEATURES[shop_feature(i)][0]

func shop_available(i):
 return (feature_eligible(shop_feature(i)) if SHOP[i].has("study") else feature_open(shop_feature(i))) and player_rank()>=research_rank(i) and highest_cleared()>=research_stage(i)

func show_research():
 shop_tab=1;shop_scroll=0;show_shop()

func allowed_loot():
 var kinds=[0,3,4,8]
 for entry in [["explosive",1],["pulse",2],["heavy",5],["recon",6],["repair",7],["slow",9],["shield",10],["double",11]]:
  if feature_open(entry[0]):kinds.append(entry[1])
 return kinds

func supply_kind():
 supply_count+=1
 if ammo[0]<=3:return 0
 # A guaranteed FPV crate every other spawn prevents resource starvation.
 if supply_count%2==1 or stock[0]+stock[1]<=2:return 4
 var choices=allowed_loot()
 if boss_spawned and feature_open("heavy") and supply_count%4==0:return 5
 return choices[randi()%choices.size()]

func first_xp(stage,rating,kills,mode):
 var base=50+5*stage+3*mini(kills,9+mini(stage*2,40))+5*rating+(40 if stage%10==0 else 0)
 return maxi(1,roundi(base*[0.85,1.0,1.15][mode]))

func settle_result(won,rating=0):
 if reward_paid:return
 reward_paid=true
 var before=available_features()
 result_rank_before=player_rank()
 var previous=int(stars.get(str(level),0))
 result_first=won and previous==0
 if won:
  result_xp=first_xp(level,rating,battle_kills,difficulty)
  if not result_first:result_xp=maxi(1,roundi(result_xp*0.35))+10*maxi(0,rating-previous)
  var full_coins=10+level+mini(coins,(quota+1)*9+50)
  result_coins=full_coins if result_first else maxi(1,roundi(full_coins*0.6))
  if mission_completed:result_coins+=20
  stars[str(level)]=maxi(previous,rating)
  unlocked=maxi(unlocked,mini(60,level+1))
  stats.wins+=1
 else:
  result_xp=roundi((5+mini(battle_kills,quota)*3)*[0.85,1.0,1.15][difficulty]) if battle_kills>0 else 0
  result_coins=mini(40+level*2,roundi(coins*0.25))
 xp+=result_xp
 wallet+=result_coins
 research_points+=player_rank()-result_rank_before
 result_new=[]
 for key in available_features():
  if key not in before:result_new.append(feature_name(key))
 save_progress()

func show_result(won,rating):
 clear_ui()
 label(x("victory") if won else t(16),Rect2(20,125,680,75),34)
 label("★".repeat(rating) if won else localized(["Можна посилитись і спробувати знову","Можно усилиться и попробовать снова","Upgrade and try again"]),Rect2(40,205,640,70),32 if won else 23)
 label(localized(["Перше проходження","Первое прохождение","First clear"]) if result_first else localized(["Повтор: 35% XP · 60% монет","Повтор: 35% XP · 60% монет","Replay: 35% XP · 60% coins"]) if won else localized(["Досвід за знищені цілі збережено","Опыт за уничтоженные цели сохранён","XP for defeated enemies saved"]),Rect2(30,285,660,65),21)
 label("+%d XP     ◎ +%d" % [result_xp,result_coins],Rect2(30,365,660,65),34)
 var rank=player_rank()
 label(localized(["Рівень гравця","Уровень игрока","Player rank"])+" %d → %d" % [result_rank_before,rank],Rect2(40,442,640,50),25)
 var progress=ProgressBar.new()
 progress.position=Vector2(80,510);progress.size=Vector2(560,28)
 progress.min_value=xp_for_rank(rank);progress.max_value=xp_for_rank(rank+1);progress.value=xp
 progress.show_percentage=false;ui.add_child(progress)
 label("XP %d/%d · ◇ %d" % [xp,xp_for_rank(rank+1),research_points],Rect2(40,545,640,45),23)
 label(localized(["ВІДКРИТО: ","ОТКРЫТО: ","UNLOCKED: "])+", ".join(result_new) if not result_new.is_empty() else next_unlock_text(),Rect2(135,610,550,115),21)
 add_unlock_icon(Vector2(30,620),Vector2(95,95))
 if won and level<60:
  button(x("next"),Rect2(140,755,440,70),func(): level+=1;prepare_stage(),true,28)
 else:button(t(17),Rect2(140,755,440,70),start_game,true,28)
 button(localized(["ПОВТОРИТИ РІВЕНЬ","ПОВТОРИТЬ УРОВЕНЬ","REPLAY LEVEL"]),Rect2(140,840,440,65),start_game,false,25)
 button(localized(["ДОСЛІДЖЕННЯ","ИССЛЕДОВАНИЯ","RESEARCH"]),Rect2(140,920,440,65),show_research,false,25)
 button(x("route"),Rect2(140,1000,440,65),func(): map_page=int((level-1)/20);show_map(),false,25)
 button(t(15),Rect2(140,1080,440,65),show_menu,false,25)
 queue_redraw()

func boss_texture(index):
 return boss_tex(index)

func spawn_boss():
 boss_spawned=true
 var index=clampi(int(level/10)-1,0,5)
 var hp=roundi((16+index*8)*[0.85,1.0,1.15][difficulty])
 next_id+=1
 enemies.append({"id":next_id,"pos":Vector2(360,-85),"kind":"vehicle","row":index,"hp":hp,"max_hp":hp,"speed":18.0*[0.85,1.0,1.15][difficulty],"r":65.0,"age":0.0,"bush":false,"side":1,"zig_amp":0.0,"zig_speed":0.0,"zig_phase":0.0,"boss":true,"ability":8.0,"casts":0})
 discover("boss_"+str(index))
 play_sfx("siren")
 say("boss",true)
 announce(localized(["БОС: ","БОСС: ","BOSS: "])+localized(BOSS_NAMES[index]))


func add_unlock_icon(pos,dimensions):
 var selected=-1
 for i in range(SHOP.size()):
  if not feature_open(shop_feature(i)) and (selected<0 or FEATURES[shop_feature(i)][0]<FEATURES[shop_feature(selected)][0]):selected=i
 if selected<0:
  for i in range(10,14):
   if upgrades[SHOP[i].upgrade]<3:selected=i;break
 if selected<0:return
 var img=TextureRect.new()
 img.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 img.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 img.texture=shop_icon(SHOP[selected])
 img.position=pos;img.size=dimensions
 img.mouse_filter=Control.MOUSE_FILTER_IGNORE
 ui.add_child(img)


const SEASON_WEATHER = [[40,40,20,0],[65,25,10,0],[25,45,30,0],[30,0,20,50]]
const SPEECH = {
 "uk": {
  "ready": "Так, герої! Каву після бою!",
  "launch": "Лети! Тільки не в мій обід!",
  "hit": "Влучно! Навіть вуса зраділи!",
  "loot": "Припаси! А печиво де?",
  "hurt": "Базу бережіть! Там моя кава!",
  "empty": "Порожньо! Хто зʼїв припаси?",
  "win": "Перемога! Усім по печиву!",
  "lose": "Нічого! Вуса не здаються!",
  "boss": "Бос! Оце так великий сусід!",
  "banter_0": "Спокійно! Я майже не панікую!",
  "banter_1": "Працюємо! Кава сама не захиститься!",
  "banter_2": "План простий! Базу не віддаємо!"
 },
 "ru": {
  "ready": "Так, герои! Кофе после боя!",
  "launch": "Лети! Только не в мой обед!",
  "hit": "Метко! Даже усы обрадовались!",
  "loot": "Припасы! А печенье где?",
  "hurt": "Базу берегите! Там мой кофе!",
  "empty": "Пусто! Кто съел припасы?",
  "win": "Победа! Всем по печенью!",
  "lose": "Ничего! Усы не сдаются!",
  "boss": "Босс! Вот это большой сосед!",
  "banter_0": "Спокойно! Я почти не паникую!",
  "banter_1": "Работаем! Кофе сам не защитится!",
  "banter_2": "План простой! Базу не отдаём!"
 },
 "en": {
  "ready": "Heroes! Coffee after the battle!",
  "launch": "Fly! Stay away from my lunch!",
  "hit": "Nice hit! My moustache approves!",
  "loot": "Supplies! Where are the cookies?",
  "hurt": "Save the base! My coffee is there!",
  "empty": "Empty! Who ate the supplies?",
  "win": "Victory! Cookies for everyone!",
  "lose": "My moustache never gives up!",
  "boss": "Boss! What a big neighbour!",
  "banter_0": "Stay calm! I am almost calm!",
  "banter_1": "Work! Coffee cannot defend itself!",
  "banter_2": "Simple plan! Keep the base!"
 }
}

func weather_height():
 return 1004.0 if screen in ["game","paused","over","victory"] else 1280.0

func pick_weather():
 var value=randi_range(1,100)
 var cumulative=0
 for i in range(4):
  cumulative+=SEASON_WEATHER[season][i]
  if value<=cumulative:return i
 return 0

func set_weather(mode):
 weather_from_weights=weather_weights.duplicate()
 weather_blend_elapsed=0.0
 weather=clampi(mode,0,3)
 weather_timer=randf_range(45,75)

func ensure_season_weather():
 if weather_season==season:return
 weather_season=season
 set_weather(pick_weather() if weather_auto else manual_weather)
 weather_weights=[0.0,0.0,0.0,0.0]
 weather_weights[weather]=1.0
 weather_from_weights=weather_weights.duplicate()
 weather_blend_elapsed=weather_blend_time

func reset_battle_weather():
 weather_season=-1
 ensure_season_weather()
 wet_ground=0.7 if weather==1 else 0.0
 snow_cover=0.55 if season==3 else 0.0

func update_weather(delta):
 if screen=="paused":return
 weather_clock+=delta
 if screen=="game" and weather_auto:
  weather_timer-=delta
  if weather_timer<=0:
   set_weather(pick_weather())
 weather_blend_elapsed=minf(weather_blend_time,weather_blend_elapsed+delta)
 for i in range(4):
  weather_weights[i]=lerpf(weather_from_weights[i],1.0 if i==weather else 0.0,weather_blend_elapsed/weather_blend_time)
 wet_ground=move_toward(wet_ground,weather_weights[1]*0.85,delta/25.0)
 snow_cover=move_toward(snow_cover,(0.5+weather_weights[3]*0.25) if season==3 else weather_weights[3]*0.25,delta/35.0)

func draw_weather_terrain():
 var height=weather_height()
 var rain=weather_weights[1]
 var fog=weather_weights[2]
 if wet_ground>0.01:
  draw_rect(Rect2(0,0,720,height),Color(0.035,0.10,0.14,wet_ground*0.24))
  for i in range(10):
   var center=Vector2(290+fposmod(i*61.0,145),170+i*minf(82,(height-200)/10))
   var points=PackedVector2Array()
   for k in range(10):
    var angle=k*TAU/10
    points.append(center+Vector2(cos(angle)*(27+i%3*8),sin(angle)*(8+i%2*3)))
   draw_colored_polygon(points,Color(0.25,0.44,0.51,wet_ground*0.38))
   draw_line(center+Vector2(-14,-2),center+Vector2(13,-2),Color(0.68,0.85,0.91,wet_ground*0.28),2,true)
 if rain>0.01:
  draw_rect(Rect2(0,0,720,height),Color(0.1,0.14,0.2,rain*0.08))
 if snow_cover>0.01:
  draw_rect(Rect2(0,0,720,height),Color(0.83,0.9,0.95,snow_cover*0.13))
  for i in range(15):
   var side=55.0 if i%2==0 else 665.0
   draw_circle(Vector2(side+sin(i*2.2)*24,120+i*(height-180)/15),18+i%4*7,Color(0.96,0.98,1,snow_cover*0.22))
 if fog>0.01:draw_rect(Rect2(0,0,720,height),Color(0.75,0.82,0.78,fog*0.05))

func update_weather_audio(battle):
 if not is_instance_valid(weather_loop):return
 var mode=1 if weather_weights[1]>=weather_weights[3] else 3
 var intensity=weather_weights[mode]
 if not battle or intensity<0.08:
  weather_loop.stop();return
 var path="res://assets/audio/weather_rain.wav" if mode==1 else "res://assets/audio/weather_wind.wav"
 if weather_loop.stream.resource_path!=path:
  weather_loop.stop()
  weather_loop.stream=load(path)
  weather_loop.stream.loop_mode=AudioStreamWAV.LOOP_FORWARD
  weather_loop.stream.loop_begin=0
  weather_loop.stream.loop_end=roundi(weather_loop.stream.get_length()*weather_loop.stream.mix_rate)
 if not weather_loop.playing:weather_loop.play()
 weather_loop.volume_db=(-43 if speech_active() else -32)+intensity*5

const DEFENSE_KEYS = ["wire","teeth","spikes","mine_soldier","mine_vehicle"]
const DEFENSE_FACTORS = {"wire":0.45,"teeth":0.4,"spikes":0.5}

func defense_icon(index):
 var icon=AtlasTexture.new()
 icon.atlas=load("res://assets/defense_atlas.png")
 var cell=icon.atlas.get_size()/Vector2(3,2)
 icon.region=Rect2(Vector2(index%3,int(index/3))*cell,cell)
 return icon

func shop_icon(item):
 return defense_icon(item.icon) if item.has("defense") or item.has("study") else atlas_icon(item.icon)

func shop_count(i):
 var item=SHOP[i]
 if item.has("study"):return int(studied_defenses[item.study])
 if item.has("defense"):return defense_stock[item.defense]
 if item.has("upgrade"):return upgrades[item.upgrade]
 return stash.get(item.get("stash",""),reserves[i] if i<3 else 0)

func shop_stock_limit(i):
 if i<3:return [30,12,80][i]
 return 20 if SHOP[i].has("defense") else 99

func shop_requirement(i):
 var key=shop_feature(i)
 if SHOP[i].has("defense") and feature_eligible(key) and not studied_defenses[key]:
  return localized(["Спочатку вивчіть у дослідженнях","Сначала изучите в исследованиях","Research this technology first"])
 return feature_requirement(key,research_rank(i),research_stage(i))

func is_tank(enemy):
 if enemy.kind!="vehicle":return false
 return enemy.row in [3,4,5] if enemy.get("boss",false) else enemy.row==0

func defense_applies(key,enemy):
 match key:
  "wire","mine_soldier":return enemy.kind=="soldier"
  "teeth":return is_tank(enemy)
  "spikes","mine_vehicle":return enemy.kind in ["vehicle","bike"]
 return false

func defense_slow(enemy):
 var factor=1.0
 for obstacle in field_defenses:
  if obstacle.ttl<=0 or not DEFENSE_FACTORS.has(obstacle.kind):continue
  if defense_applies(obstacle.kind,enemy) and enemy.pos.distance_to(obstacle.pos)<68+enemy.r:
   factor=minf(factor,DEFENSE_FACTORS[obstacle.kind])
 return factor

func process_field_defenses(delta):
 for obstacle in field_defenses:
  obstacle.ttl-=delta
  if obstacle.ttl<=0 or not obstacle.kind.begins_with("mine_"):continue
  for enemy in enemies:
   if enemy.hp>0 and defense_applies(obstacle.kind,enemy) and enemy.pos.distance_to(obstacle.pos)<34+enemy.r:
    obstacle.ttl=0
    mine_blast(obstacle)
    break
 field_defenses=field_defenses.filter(func(obstacle):return obstacle.ttl>0)

func mine_blast(obstacle):
 var radius=75.0
 blasts.append({"pos":obstacle.pos,"r":radius,"ttl":0.45,"pulse":false})
 play_sfx("explosion")
 for enemy in enemies:
  if enemy.hp<=0 or not defense_applies(obstacle.kind,enemy):continue
  if enemy.pos.distance_to(obstacle.pos)<radius+enemy.r:
   enemy.hp-=3 if obstacle.kind=="mine_soldier" else 6
   if enemy.hp<=0:credit_kill(enemy)

func credit_kill(enemy):
 if enemy.get("credited",false):return
 enemy.credited=true
 score+=2 if elapsed<double_until else 1
 combo=mini(8,combo+1) if elapsed<combo_until else 1
 combo_until=elapsed+3.0
 coins+=2+upgrades.supply+(combo/2 as int)+(25 if enemy.get("boss",false) else 0)+(10 if enemy.get("mini_boss",false) else 0)+(2 if enemy.kind=="medic" else 0)+(1 if enemy.kind=="kikimora" else 0)
 stats.kills+=1
 battle_kills+=1
 if mission_id!=1:update_mission()
 if enemy.get("boss",false) or enemy.get("mini_boss",false):boss_defeated=true
 if enemy.kind in ["soldier","kikimora","medic"] and randf()<0.18:play_enemy_voice("hit_%d" % (randi()%4))
 if enemy.kind=="medic":
  pickups.append({"pos":enemy.pos,"kind":7,"ttl":20.0})
 elif enemy.get("mini_boss",false):
  pickups.append({"pos":enemy.pos,"kind":8,"ttl":20.0})
  pickups.append({"pos":enemy.pos+Vector2(28,0),"kind":4,"ttl":20.0})
 elif stock[0]<=2 and not enemy.get("boss",false) and battle_kills%2==0:
  pickups.append({"pos":enemy.pos,"kind":3,"ttl":20.0})
 say("hit")

func show_defense_picker():
 if screen!="game":return
 if is_instance_valid(defense_panel):cancel_deployment();return
 defense_panel=Panel.new()
 defense_panel.position=Vector2(45,195);defense_panel.size=Vector2(630,680)
 defense_panel.add_theme_stylebox_override("panel",panel_style(Color("1f321df7")))
 ui.add_child(defense_panel)
 label(localized(["ПОЛЬОВИЙ ЗАХИСТ","ПОЛЕВОЙ ЗАЩИТНЫЙ НАБОР","FIELD DEFENSES"]),Rect2(15,15,600,55),27,defense_panel)
 label(localized(["Оберіть предмет, потім місце на полі. Бій триває.","Выберите предмет, затем место на поле. Бой продолжается.","Choose an item, then a spot on the field. Battle continues."]),Rect2(20,70,590,55),18,defense_panel)
 for i in range(5):
  var key=DEFENSE_KEYS[i]
  var item=button(feature_name(key)+" ×%d" % defense_stock[key],Rect2(25,140+i*84,580,73),func(): select_defense(key),false,23,defense_panel)
  item.icon=defense_icon(i)
  item.disabled=not feature_open(key) or defense_stock[key]<=0 or field_defenses.size()>=8
  item.tooltip_text=feature_requirement(key) if not feature_open(key) else localized(["Натисніть місце на полі","Нажмите место на поле","Tap a spot on the field"])
 button(localized(["СКАСУВАТИ","ОТМЕНА","CANCEL"]),Rect2(155,590,320,65),cancel_deployment,true,25,defense_panel)

func select_defense(key):
 if not feature_open(key) or defense_stock[key]<=0:return
 deployment=key
 if is_instance_valid(defense_panel):defense_panel.queue_free()
 defense_panel=null
 announce(localized(["Оберіть місце на полі. Esc — скасувати.","Выберите место на поле. Esc — отмена.","Choose a spot on the field. Esc cancels."]))
 refresh_hud()

func cancel_deployment():
 deployment=""
 if is_instance_valid(defense_panel):defense_panel.queue_free()
 defense_panel=null
 refresh_hud()

func placement_allowed(pos):
 if not Rect2(75,205,570,555).has_point(pos) or field_defenses.size()>=8:return false
 for obstacle in field_defenses:
  if obstacle.pos.distance_to(pos)<85:return false
 return true

func place_defense(pos):
 if deployment=="" or not feature_open(deployment) or defense_stock[deployment]<=0:return false
 pos=Vector2(roundf(pos.x/20)*20,roundf(pos.y/20)*20)
 if not placement_allowed(pos):
  announce(localized(["Поставте на вільному місці всередині поля","Поставьте на свободном месте внутри поля","Place on an empty spot inside the field"]))
  return false
 var key=deployment
 field_defenses.append({"kind":key,"pos":pos,"ttl":60.0 if key.begins_with("mine_") else 45.0})
 defense_stock[key]-=1
 discover("def_"+key)
 deployment=""
 save_progress()
 play_sfx("collect")
 refresh_hud()
 return true

func draw_field_defenses():
 for obstacle in field_defenses:
  var index=DEFENSE_KEYS.find(obstacle.kind)
  var dimensions=Vector2(54,54) if obstacle.kind.begins_with("mine_") else Vector2(100,78)
  draw_texture_rect(defense_icon(index),Rect2(obstacle.pos-dimensions/2,dimensions),false,Color(1,1,1,minf(1,obstacle.ttl/3)))
  draw_arc(obstacle.pos,32,0,TAU,20,Color(0.86,0.91,0.6,0.25),1,true)
 if deployment!="":
  var pos=get_global_mouse_position()
  var valid=placement_allowed(pos)
  draw_arc(pos,50,0,TAU,28,Color("91ec74") if valid else Color("ff6d62"),2,true)
  draw_texture_rect(defense_icon(DEFENSE_KEYS.find(deployment)),Rect2(pos-Vector2(40,40),Vector2(80,80)),false,Color(1,1,1,.5))
