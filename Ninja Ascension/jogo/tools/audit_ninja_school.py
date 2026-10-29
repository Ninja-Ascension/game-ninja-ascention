"""Inventory original Ninja School client dependencies without changing data."""
import re
from pathlib import Path
root = Path(__file__).resolve().parents[1]
base = root / '01_conteudo_apk/assets/src/client/l_digital/cultivate'
for folder in base.iterdir():
    if folder.is_dir():
        source = '\n'.join(p.read_text(encoding='utf-8-sig') for p in folder.rglob('*.lua'))
        fields = set(re.findall(r'_ED\.([A-Za-z_0-9]+)', source))
        print(folder.name + ': ' + ','.join(sorted(fields - {'user_info', 'user_ships', 'user_props', 'formetion'})))
