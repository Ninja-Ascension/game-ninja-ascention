"""Define uma senha nova para uma conta existente, sem mostrar a senha na tela.

Uso: python tools/redefinir_senha.py <usuario>
Faz backup consistente do banco (API de backup do SQLite) antes de alterar.
Nao cria nem apaga contas; so troca o hash da senha e encerra as sessoes antigas.
"""
import getpass
import os
import sqlite3
import sys
import time
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port' / 'server'))
import contas  # noqa: E402

def main():
    if len(sys.argv) != 2:
        print('Uso: python tools/redefinir_senha.py <usuario>')
        return 2
    base = Path(os.environ.get('NR_ACCOUNTS_DIR') or root / 'port' / 'dados')
    banco = base / 'contas.sqlite3'
    conn = sqlite3.connect(str(banco), timeout=30)
    chave = contas.normalizar_nome(sys.argv[1])
    linha = conn.execute('SELECT id, display_name FROM contas WHERE nome=?', (chave,)).fetchone()
    if not linha:
        print('Conta nao encontrada:', sys.argv[1])
        return 1
    print('Conta: %s (id %d)' % (linha[1], linha[0]))
    senha = getpass.getpass('Nova senha: ')
    confirmacao = getpass.getpass('Repita a nova senha: ')
    try:
        contas.validar_senha(senha, confirmacao)
    except contas.ErroConta as erro:
        print('Senha recusada:', erro.mensagem)
        return 1
    pasta = base / 'backups'
    pasta.mkdir(exist_ok=True)
    copia = pasta / ('contas_antes_senha_%s.sqlite3' % time.strftime('%Y%m%d_%H%M%S'))
    destino = sqlite3.connect(str(copia))
    conn.backup(destino)
    destino.close()
    with conn:
        conn.execute('UPDATE contas SET senha_hash=? WHERE id=?', (contas.derivar(senha), linha[0]))
        conn.execute('DELETE FROM sessoes WHERE conta_id=?', (linha[0],))
    conn.close()
    print('Senha alterada. Backup do banco anterior:', copia)
    return 0

if __name__ == '__main__':
    sys.exit(main())
