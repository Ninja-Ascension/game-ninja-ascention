"""Le um results.json da suite de layouts e lista etapa + exit code."""
import json
import sys
from pathlib import Path

caminho = Path(sys.argv[1])
dados = json.loads(caminho.read_text(encoding="utf-8"))
print("chaves disponiveis:", sorted(dados[0].keys()))
print()

falhas = 0
for r in dados:
    rotulo = (r.get("stage") or r.get("case") or r.get("step")
              or r.get("label") or "?")
    codigo = r.get("exit_code")
    saida = (r.get("stdout") or "") + (r.get("stderr") or "")
    marca = ""
    if "NATIVE_TUTORIAL_WAVE2_PASSED" in saida:
        marca = "  [onda 2 liberada por callback real]"
    print("%-28s exit=%s%s" % (rotulo, codigo, marca))
    if codigo not in (0, None):
        falhas += 1

print()
print("TOTAL=%d  FALHAS=%d" % (len(dados), falhas))
