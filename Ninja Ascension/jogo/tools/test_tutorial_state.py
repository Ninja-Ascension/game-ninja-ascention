"""Exercise the RECOVERED Lua 6020 parser with the shipped LuaJIT DLL.

No account database, server, UI input or original file writes.
"""
from pathlib import Path
import ctypes
import json
import sys
import os
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "port/server"))
import dados_batalha

tokens = dados_batalha.estado_inicial_cenas()
assert tokens[0] == "6020" and len(tokens) == 5
assert tokens[1] == tokens[2]
assert tokens[1].split(",")[0] == "0"
assert set(tokens[1].split(",")[1:]) == {"-1"}
assert set(tokens[3].split(",")) == {"0"}
assert len(tokens[1].split(",")) == len(tokens[3].split(","))

# Exercise the actual endpoint with an isolated account DB, then feed its
# exact response into the original parser below. Never open the player's DB.
with tempfile.TemporaryDirectory(prefix="tutorial-state-", dir=ROOT / "build") as isolated:
    previous = os.environ.get("NR_ACCOUNTS_DIR")
    os.environ["NR_ACCOUNTS_DIR"] = isolated
    try:
        import local_server
        try:
            # battle_result_start responde ACK de sucesso SEM tokens de parser.
            #
            # O pacote 6020 NAO vai mais aqui. Motivo medido no acervo:
            #   * o callback de battle_result_start (Mission.lua:2379-2398) le
            #     ZERO campos — so testa RESPONSE_SUCCESS e PROTOCOL_STATUS>=0;
            #   * anexar os quatro vetores gerava 5026 caracteres para uma
            #     chamada que espera ACK, e o cliente FECHAVA durante o
            #     processamento;
            #   * _ED.scene_max_state serve as telas de MENU de PVE e o
            #     Mission.lua:2283, entao viaja no login_init.
            # Este teste fixa o contrato atual e impede a regressao.
            response = local_server.handle_battle_result_start(
                "7", "7\r\nbattle_result_start\r\n1\r\n0\r\n1\r\n1196\r\n1\r\n1,4008,1,2")
            parts = response.split(" ")
            assert parts[:3] == ["7", "battle_result_start", "0"], response
            assert parts[3:] == [], (
                "battle_result_start deve ser ACK puro: "
                + repr(parts[3:]))

            # Onde o 6020 realmente viaja: login_init.
            # login_init exige sessao valida, entao cria conta e sessao no
            # banco isolado (nunca no do jogador).
            conta = local_server.BANCO.criar_conta("prova_cenas", "senha_forte_1")
            token = local_server.BANCO.abrir_sessao(conta["id"])
            local_server.lembrar_token(token)
            login = local_server.resposta_login_init(
                "8", "8\r\nlogin_init\r\n22\r\n0\r\n", nome_cmd="login_init")
            campos = login.split(" ")
            assert "6020" in campos, "login_init nao entrega o parser 6020"
            posicao = campos.index("6020")
            # tokens[0] e o proprio nome do codigo ("6020"); os vetores de
            # estado sao tokens[1:].
            vetores = tokens[1:]
            entregues = campos[posicao + 1:posicao + 1 + len(vetores)]
            assert entregues == vetores, (
                "login_init entregou vetores de cena diferentes do acervo: "
                + repr([len(v.split(",")) for v in entregues]))
        finally:
            local_server.BANCO.fechar()
    finally:
        if previous is None:
            os.environ.pop("NR_ACCOUNTS_DIR", None)
        else:
            os.environ["NR_ACCOUNTS_DIR"] = previous

dll = ROOT / "build/windows-probe-native/bin/NinjaResourceProbe/Debug/lua51.dll"
lua = ctypes.CDLL(str(dll))
lua.luaL_newstate.restype = ctypes.c_void_p
lua.luaL_openlibs.argtypes = [ctypes.c_void_p]
lua.luaL_loadstring.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
lua.lua_pcall.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]
lua.lua_tolstring.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_void_p]
lua.lua_tolstring.restype = ctypes.c_char_p
lua.lua_close.argtypes = [ctypes.c_void_p]

def quoted(text):
    return json.dumps(text, ensure_ascii=False)

parser = ROOT / "01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopyExx.lua"
rows = dados_batalha.tabela("pve_scene.txt")
# LocalDatas.pve_scene.scene_type is resolved from the recovered declaration.
local_data = (ROOT / "01_conteudo_apk/assets/src/client/loader/LocalDatas.lua").read_text(encoding="utf-8-sig")
import re
declaration = re.search(r"pve_scene\s*=\s*\{(.*?)\}", local_data, re.S)
assert declaration, "pve_scene declaration missing"
column = int(re.search(r"scene_type\s*=\s*(\d+)", declaration.group(1)).group(1))
types = ",".join(f"[{int(k)}]={int(v[column-1])}" for k,v in rows.items() if k.isdigit())
payload = ",".join(quoted(t) for t in tokens[1:])
script = f"""
__lua_project_id=27
_ED={{scene_max_state=''}}
zstring={{split=function(s,sep)
 local t={{}};for v in (s..sep):gmatch('(.-)'..sep) do t[#t+1]=v end;return t
end}}
pve_scene={{scene_type={column}}}
local types={{{types}}}
dms={{pve_scene=types,int=function(t,id,col) return assert(t[id]) end}}
function npos(list) return table.remove(list,1) end
assert(loadfile({quoted(parser.as_posix())}))()
local payload={{{payload}}}
parse_user_scene_states(nil,nil,nil,nil,payload,nil)
assert(#payload==0,'6020 parser did not consume exact payload')
assert(type(_ED.scene_max_state)=='table','Mission pairs would still fail')
assert(_ED.scene_max_state[1]=='0' and _ED.scene_max_state[2]=='-1')
local locked=0;for i,v in pairs(_ED.scene_max_state) do if tonumber(v)==-1 then locked=locked+1 end end
assert(locked>0)
"""
state = lua.luaL_newstate()
assert state
try:
    lua.luaL_openlibs(state)
    for source in ("loading_diagnostics.lua", "boot_map.lua"):
        content = (ROOT / "port/lua" / source).read_bytes()
        if lua.luaL_loadstring(state, content):
            raise AssertionError(lua.lua_tolstring(state, -1, None).decode("utf-8", "replace"))
    rc = lua.luaL_loadstring(state, script.encode("utf-8"))
    if not rc:
        rc = lua.lua_pcall(state, 0, 0, 0)
    if rc:
        raise AssertionError(lua.lua_tolstring(state, -1, None).decode("utf-8", "replace"))
finally:
    lua.lua_close(state)
print("TUTORIAL_STATE_PASSED: original Lua 6020 parser, exact consumption, Mission table contract")
