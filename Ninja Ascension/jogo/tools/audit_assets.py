"""Catalog the game's existing runtime assets without uploading textures to GPU."""
import json
from collections import Counter
from pathlib import Path
root=Path(__file__).resolve().parents[1];res=root/'res'
files=[path for path in res.rglob('*') if path.is_file()]
counts=Counter(path.suffix.lower() or '(none)' for path in files)
portraits=[path.relative_to(res).as_posix() for path in files if any(key in path.as_posix().lower() for key in ('big_head/','rage_head/','head_icon/','headicon/'))]
missing=[]
for atlas in (p for p in files if p.suffix.lower()=='.atlas'):
    for line in atlas.read_text(encoding='utf8',errors='replace').splitlines():
        page=line.strip()
        if page.lower().endswith(('.png','.jpg','.jpeg')) and ':' not in page:
            if not (atlas.parent/page).is_file():missing.append(dict(atlas=atlas.relative_to(res).as_posix(),page=page))
result=dict(total_files=len(files),by_extension=dict(counts),portrait_count=len(portraits),
            portraits=portraits,missing_atlas_pages=missing,
            files=[path.relative_to(res).as_posix() for path in files])
output=root/'build/assets-audit.json';output.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf8')
print('ASSETS_AUDIT',len(files),'files;',len(portraits),'portrait files;',len(missing),'missing atlas pages')
print(output)
