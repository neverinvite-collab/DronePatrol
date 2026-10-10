"""Original loopable weather ambience. numpy needed only to regenerate assets."""
from pathlib import Path
import numpy as np,wave
out=Path(__file__).resolve().parents[1]/'assets/audio';sr=22050
rng=np.random.default_rng(33);duration=8;n=sr*duration;t=np.arange(n)/sr
noise=rng.normal(0,1,n)
# Circular filtering/modulation gives seamless endpoints rather than a silent tail.
low=np.fft.irfft(np.fft.rfft(noise)*np.exp(-np.fft.rfftfreq(n,1/sr)/900),n)
rain=.08*noise+.13*low
wind=.22*low*(.7+.3*np.sin(2*np.pi*t/duration))
for name,samples in [('weather_rain',rain),('weather_wind',wind)]:
 with wave.open(str(out/(name+'.wav')),'wb') as w:
  w.setnchannels(1);w.setsampwidth(2);w.setframerate(sr);w.writeframes((np.clip(samples,-.85,.85)*32767).astype('<i2').tobytes())
print('2 original weather loops generated')
