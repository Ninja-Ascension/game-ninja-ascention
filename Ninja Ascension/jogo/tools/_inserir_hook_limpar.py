"""Insere o hook de limpeza de conta no boot_map.lua (uma vez)."""
from pathlib import Path

p = Path('E:/[code]/nk/port/lua/boot_map.lua')
texto = p.read_text(encoding='utf8', errors='replace')

if 'NR_LIMPAR_CONTA' in texto:
    print('hook ja presente')
    raise SystemExit(0)

hook = (
    "-- Limpa a conta salva no cliente (ver limpar_conta_local.lua).\n"
    "if os.getenv('NR_LIMPAR_CONTA')=='1' then\n"
    "    if not tryload('6a.limpa', function()\n"
    "        require('limpar_conta_local')\n"
    "    end) then\n"
    "        local f = io.open(cc.FileUtils:getInstance():getWritablePath()..'limpar-conta.log','w')\n"
    "        if f then f:write('FALHA: nao carregou') f:flush() f:close() end\n"
    "        os.exit(1)\n"
    "    end\n"
    "end\n\n"
)

alvo = "if os.getenv('NR_LOGIN_AUTOMATICO')=='1' then"
if alvo not in texto:
    print('ancora nao encontrada')
    raise SystemExit(1)

p.write_text(texto.replace(alvo, hook + alvo, 1), encoding='utf8')
print('hook inserido')
