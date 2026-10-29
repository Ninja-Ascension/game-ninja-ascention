"""Troca a senha de uma conta SEM apagar nada da progressao.

O banco guarda `senha_hash` (pbkdf2_sha256 + salt): nao ha como recuperar a
senha original. Aqui derivamos uma nova com a MESMA funcao do servidor
(contas.derivar), entao o login passa a aceitar a senha nova e todo o resto
(personagens, itens, nivel, formacao) continua intacto.

Uso:
    python tools/trocar_senha.py <conta_id> <senha_nova>
"""
import sqlite3
import sys
from pathlib import Path

RAIZ = Path('E:/[code]/nk')
BANCO = RAIZ / 'port/dados/contas.sqlite3'
sys.path.insert(0, str(RAIZ / 'port/server'))
import contas as _contas

if len(sys.argv) != 3:
    sys.exit('uso: trocar_senha.py <conta_id> <senha_nova>')

conta_id = int(sys.argv[1])
senha_nova = sys.argv[2]

c = sqlite3.connect(str(BANCO))
c.row_factory = sqlite3.Row
linha = c.execute('SELECT id, nome FROM contas WHERE id=?', (conta_id,)).fetchone()
if linha is None:
    sys.exit('conta %d nao existe' % conta_id)

novo_hash = _contas.derivar(senha_nova)
# Confere que o hash gerado e aceito pela funcao de verificacao do servidor
# antes de gravar: garante que o login vai funcionar.
if not _contas.conferir(senha_nova, novo_hash):
    sys.exit('erro interno: hash gerado nao confere')

with c:
    c.execute('UPDATE contas SET senha_hash=? WHERE id=?', (novo_hash, conta_id))

# Rele do banco e confirma de verdade.
guardado = c.execute('SELECT senha_hash FROM contas WHERE id=?', (conta_id,)).fetchone()[0]
ok = _contas.conferir(senha_nova, guardado)
c.close()

print('conta %d (%s)' % (conta_id, linha['nome']))
print('senha nova gravada e verificada: %s' % ('OK' if ok else 'FALHOU'))
if not ok:
    sys.exit(1)
