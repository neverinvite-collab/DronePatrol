"""Prepare a versioned Godot source release; no APK export is performed."""
import argparse
import re
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SLUGS = ['GREEN_FRONTIER', 'STEEL_ONSLAUGHT', 'FROZEN_FRONT']

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--edition', type=int, choices=[1, 2, 3], default=1)
    parser.add_argument('--bump', choices=['patch', 'minor', 'major'], default='patch')
    parser.add_argument('--output', type=Path, default=ROOT.parent)
    args = parser.parse_args()
    project = ROOT / 'project.godot'
    original = project.read_text(encoding='utf-8')
    match = re.search(r'config/version="(\d+)\.(\d+)(?:\.(\d+))?"', original)
    if not match:
        parser.error('project.godot must contain a numeric config/version')
    version = [int(part or 0) for part in match.groups()]
    index = ['major', 'minor', 'patch'].index(args.bump)
    version[index] += 1
    for i in range(index + 1, 3):
        version[i] = 0
    number = '.'.join(map(str, version))
    changed = original[:match.start()] + f'config/version="{number}"' + original[match.end():]
    changed = re.sub(r'(?m)^edition=\d+$', f'edition={args.edition - 1}', changed)
    args.output.mkdir(parents=True, exist_ok=True)
    target = args.output.resolve() / f'DronePatrol_{SLUGS[args.edition-1]}_v{number}.zip'
    if target.exists():
        parser.error(f'Release already exists: {target}')
    project.write_text(changed, encoding='utf-8')
    try:
        with zipfile.ZipFile(target, 'w', zipfile.ZIP_DEFLATED) as archive:
            for path in sorted(ROOT.rglob('*')):
                if not path.is_file() or '.godot' in path.parts or '__pycache__' in path.parts or path.suffix in ['.import', '.zip']:
                    continue
                archive.write(path, Path('DronePatrol') / path.relative_to(ROOT))
    except Exception:
        project.write_text(original, encoding='utf-8')
        target.unlink(missing_ok=True)
        raise
    print(f'Release {number}, edition {args.edition}: {target}')

if __name__ == '__main__':
    main()
