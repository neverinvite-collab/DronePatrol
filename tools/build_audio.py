"""Original procedural game soundtrack and effects; numpy required only for rebuilding."""
from pathlib import Path
import numpy as np, wave
out=Path(__file__).resolve().parents[1]/'assets/audio';out.mkdir(exist_ok=True)
sr=22050;rng=np.random.default_rng(33)
def save(name,a):
 a=np.clip(a,-.95,.95)
 with wave.open(str(out/(name+'.wav')),'wb') as w:
  w.setnchannels(1);w.setsampwidth(2);w.setframerate(sr);w.writeframes((a*32767).astype('<i2').tobytes())
def axis(n):return np.arange(int(sr*n))/sr
t=axis(.85);noise=rng.normal(0,1,len(t));low=np.convolve(noise,np.ones(28)/28,'same')
save('explosion',.6*noise*np.exp(-t*14)+1.5*low*np.exp(-t*4)+.28*np.sin(2*np.pi*(65*t-20*t*t))*np.exp(-t*6))
t=axis(.55);save('pulse',.3*np.sin(2*np.pi*(650*t-400*t*t))*np.exp(-t*7))
t=axis(.28);save('launch',.19*np.sin(2*np.pi*(180*t+700*t*t))*np.sin(np.pi*t/.28)**2)
t=axis(.35);save('collect',.2*(np.sin(2*np.pi*660*t)*(t<.16)+np.sin(2*np.pi*990*t)*(t>=.16))*np.sin(np.pi*t/.35))
t=axis(.07);save('tap',.16*np.sin(2*np.pi*420*t)*np.exp(-t*50))
t=axis(.35);save('hurt',.25*np.sin(2*np.pi*95*t)*np.exp(-t*9)+rng.normal(0,.08,len(t))*np.exp(-t*15))
t=axis(2);save('drone',.1*np.sin(2*np.pi*160*t)*(1+.4*np.sin(2*np.pi*40*t))+.03*np.sin(2*np.pi*320*t))
save('engine',.2*np.sin(2*np.pi*45*t)+.07*np.sin(2*np.pi*90*t)+.025*np.sin(2*np.pi*165*t))
t=axis(2);steps=np.zeros(len(t))
for at in [0,.5,1,1.5]:
 st=axis(.13);hit=rng.normal(0,.15,len(st))*np.exp(-st*25)
 offset=int(at*sr);steps[offset:offset+len(st)]+=hit
save('steps',steps)
# Three 32-second ambient arrangements, soft pads, bass pulses, delayed plucked melody.
for variant,notes in enumerate([[45,48,52,55],[43,47,50,54],[40,43,47,50]]):
 t=axis(32);track=np.zeros(len(t))
 for bar in range(8):
  chord=notes[bar%4];start=bar*4*sr;ct=axis(4)
  env=np.minimum(ct/1.1,1)*np.minimum((4-ct)/1.3,1)
  for interval in [0,7,12]:
   f=440*2**((chord+interval-69)/12)
   track[start:start+len(ct)]+=.032*np.sin(2*np.pi*f*ct)*env
  for beat in range(4):
   bt=axis(.8);f=440*2**((chord-12-69)/12)
   pulse=.06*np.sin(2*np.pi*f*bt)*np.exp(-bt*5)
   offset=start+beat*sr;track[offset:offset+len(bt)]+=pulse
  for beat in [1,3]:
   mt=axis(1);f=440*2**((chord+12+[0,7,12][(bar+beat+variant)%3]-69)/12)
   tone=.025*np.sin(2*np.pi*f*mt)*np.exp(-mt*4)
   offset=start+beat*sr
   end=min(len(track),offset+len(mt));track[offset:end]+=tone[:end-offset]
 save('music_'+str(variant),track)
print('3 original music tracks and 8 effects generated')
