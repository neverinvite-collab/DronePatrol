# -*- coding: utf-8 -*-
"""Generate optional Ukrainian voice packs into a Godot project. Requires Internet only once."""
from pathlib import Path
from urllib.request import urlopen, Request
import json, wave, sys
ROOT=Path(__file__).resolve().parents[1]
MODEL_DIR=ROOT/'voice_tools'/'models'
OUT=ROOT/'assets'/'voices_v2'
BASE='https://huggingface.co/rhasspy/piper-voices/resolve/main/uk/uk_UA'
GENERAL={
 'ready':'Так, бійці! Каву допиваємо потім. Зараз працюємо!',
 'launch':'Дрон пішов! Тільки дивись, не в мій обід!',
 'hit':'Оце влучив! Аж вуса від радості затремтіли!',
 'loot':'Припаси прибули! А печиво знову забули!',
 'hurt':'Агов! Базу бережіть! Там мій термос!',
 'empty':'Де боєприпаси? Хто знову все витратив?',
 'win':'Молодці, бійці! А тепер відпочинок. Рівно три секунди!',
 'lose':'Ой леле. То хто так обороняється?',
 'boss':'Увага! До нас їде велика проблема. А я тільки чай налив!',
 'banter_0':'Спокійно, хлопці! Я майже не панікую!',
 'banter_1':'Працюємо! Кава сама себе не захистить!',
 'banter_2':'План простий! Базу не віддаємо!'
}
ENEMIES={
 'squad':'Командире! А ми точно туди йдемо?',
 'hit_0':'Та я ж тільки прийшов!',
 'hit_1':'Ой! А можна назад?',
 'hit_2':'Хлопці, тут літає щось сердите!',
 'hit_3':'Я передумав! Піду додому!'
}

def fetch(url,dest,threshold):
 if dest.exists() and dest.stat().st_size>threshold:return
 dest.parent.mkdir(parents=True,exist_ok=True)
 tmp=dest.with_suffix(dest.suffix+'.part')
 with urlopen(Request(url+'?download=true',headers={'User-Agent':'Mozilla/5.0'}),timeout=240) as r, tmp.open('wb') as f:
  while True:
   b=r.read(1024*1024)
   if not b:break
   f.write(b)
 if tmp.stat().st_size<=threshold:raise RuntimeError('Download incomplete: '+str(dest))
 tmp.replace(dest)

def voice_model(name):
 from piper import PiperVoice
 model=MODEL_DIR/f'uk_UA-{name}-high.onnx'
 config=MODEL_DIR/f'uk_UA-{name}-high.onnx.json'
 url=f'{BASE}/{name}/high/uk_UA-{name}-high.onnx'
 fetch(url,model,50_000_000)
 fetch(url+'.json',config,500)
 info=json.loads(config.read_text(encoding='utf-8'))
 print(name, 'phoneme_type:',info.get('phoneme_type'),flush=True)
 return PiperVoice.load(str(model),config_path=str(config))

def render(v, lines, directory):
 directory.mkdir(parents=True,exist_ok=True)
 for key,phrase in lines.items():
  dest=directory/f'uk_{key}.wav'
  print(dest.relative_to(ROOT),':',phrase,flush=True)
  with wave.open(str(dest),'wb') as f:v.synthesize_wav(phrase,f)
  if dest.stat().st_size<1000:raise RuntimeError('Invalid WAV: '+str(dest))

def main():
 # Generating the two general voices and an enemy pack produces all playable choices.
 for name in ('oleksa','mykyta'):
  v=voice_model(name)
  render(v,GENERAL,OUT/name)
  if name=='mykyta':render(v,ENEMIES,OUT/'enemies')
 print('DONE! Open:',OUT)
if __name__=='__main__':
 try:main()
 except Exception as e:
  import traceback
  traceback.print_exc()
  sys.exit(1)
