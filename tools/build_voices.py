"""Plain offline speech: no character filters or pitch/time remapping.
Requires eSpeak NG and ffmpeg only for regenerating clips.
"""
import os,subprocess,tempfile,json
from pathlib import Path
LINES=json.loads((Path(__file__).resolve().parents[1]/'assets/voices/LINES.json').read_text(encoding='utf-8'))
def main():
 out=Path(__file__).resolve().parents[1]/'assets/voices';out.mkdir(parents=True,exist_ok=True)
 env=os.environ.copy()
 if os.getenv('ESPEAK_LIBRARY_PATH'):env['LD_LIBRARY_PATH']=os.environ['ESPEAK_LIBRARY_PATH']
 for lang,events in LINES.items():
  for name,phrase in events.items():
   with tempfile.TemporaryDirectory() as tmp:
    wav=Path(tmp)/'raw.wav'
    args=[os.getenv('ESPEAK_BINARY','espeak-ng')]
    if os.getenv('ESPEAK_DATA_ROOT'):args+=['--path='+os.environ['ESPEAK_DATA_ROOT']]
    args+=['-v',('en-us' if lang=='en' else lang),'-p','50','-s','145','-a','110','-g','3','-w',str(wav),phrase]
    subprocess.run(args,env=env,check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
    subprocess.run(['ffmpeg','-y','-loglevel','error','-i',str(wav),'-af','loudnorm=I=-17:TP=-2:LRA=7','-ac','1','-ar','22050',str(out/f'{lang}_{name}.wav')],check=True)
 (out/'LINES.json').write_text(json.dumps(LINES,ensure_ascii=False,indent=2))
 print('36 general voice clips generated (offline fallback)')
if __name__=='__main__':main()
