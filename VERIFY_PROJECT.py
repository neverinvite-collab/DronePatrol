from pathlib import Path
import hashlib
root=Path(__file__).resolve().parent
file=root/'scripts'/'game.gd'
b=file.read_bytes()
print('PROJECT:',root)
print('GAME.GD:',file)
print('TABS:',b.count(bytes([9])))
print('SHA256:',hashlib.sha256(b).hexdigest())
print('LINE 708:',repr(b.splitlines()[707]))
print('ALL GD TABS:',sum(p.read_bytes().count(bytes([9])) for p in root.rglob('*.gd')))
assert b.count(bytes([9]))==0
print('VERIFICATION PASSED')
