"""Generate Ukrainian voice clips with Apache-2.0 licensed Piper models.
Run via GENERATE_UK_VOICES.bat on Windows. Internet needed only during generation.
"""
from pathlib import Path
import json, subprocess, urllib.request, sys, wave, shutil
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets'/'voices'
MODEL_DIR=ROOT/'tools'/'piper_models'
LINES=json.loads((OUT/'LINES.json').read_text(encoding='utf-8'))['uk']
ROLES={'ready': 'oleksa', 'win': 'oleksa', 'lose': 'oleksa', 'banter_0': 'oleksa', 'banter_1': 'oleksa', 'banter_2': 'oleksa', 'boss': 'tetiana', 'hurt': 'tetiana', 'empty': 'tetiana', 'launch': 'mykyta', 'hit': 'mykyta', 'loot': 'mykyta'}
VOICES=('oleksa','mykyta','tetiana')

def download(url,path):
 if path.exists() and path.stat().st_size>1000:return
 print('Downloading',path.name,'...')
 tmp=path.with_suffix(path.suffix+'.part')
 try:
  with urllib.request.urlopen(urllib.request.Request(url,headers={'User-Agent':'Mozilla/5.0'}),timeout=120) as r, open(tmp,'wb') as f:
   shutil.copyfileobj(r,f,1024*1024)
  tmp.replace(path)
 except Exception:
  tmp.unlink(missing_ok=True)
  raise

def main():
 MODEL_DIR.mkdir(parents=True,exist_ok=True)
 from piper import PiperVoice
 loaded={}
 for name in VOICES:
  base=f'uk_UA-{name}-high'
  root=f'https://huggingface.co/rhasspy/piper-voices/resolve/main/uk/uk_UA/{name}/high/{base}'
  model=MODEL_DIR/(base+'.onnx')
  config=MODEL_DIR/(base+'.onnx.json')
  download(root+'.onnx',model)
  download(root+'.onnx.json',config)
  loaded[name]=PiperVoice.load(str(model),config_path=str(config),use_cuda=False)
 for event,text in LINES.items():
  name=ROLES.get(event,'oleksa')
  out=OUT/('uk_'+event+'.wav')
  print(name,event,':',text)
  with wave.open(str(out),'wb') as wav:
   loaded[name].synthesize_wav(text,wav)
  # Delete obsolete importer metadata: Godot regenerates on next project import.
  (OUT/(out.name+'.import')).unlink(missing_ok=True)
 print('DONE! Ukrainian voices generated:',len(LINES))
 print('You can delete tools/piper_models after generating audio.')

if __name__=='__main__':main()
