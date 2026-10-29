"""Recarga sem reiniciar: o que precisa continuar vivo entre recargas.

Objetivo do jogador: ajustar um comando e ver o efeito apenas relogando, sem
fechar o servidor nem reabrir o jogo. Para isso a recarga NAO pode tocar em:

  * a conexao SQLite (contas.py)  -- se fechar, todo login seguinte falha;
  * as sessoes abertas            -- se perder, o cliente cai em "erro
                                     desconhecido" ao relogar (bug ja visto);
  * o socket do jogo (18080)      -- se fechar, o cliente perde a conexao.

E precisa realmente trocar o codigo: um arquivo alterado tem de valer depois
de recarregar.
"""
import importlib
import os
import sys
import tempfile
from pathlib import Path

raiz = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(raiz / 'port/server'))

falhas = []


def checar(nome, condicao, detalhe=''):
    print(('  ok   ' if condicao else '  FALHA') + ' ' + nome + ((' -> ' + detalhe) if detalhe else ''))
    if not condicao:
        falhas.append(nome)


with tempfile.TemporaryDirectory(prefix='recarga-', dir=str(raiz / 'build')) as pasta:
    os.environ['NR_ACCOUNTS_DIR'] = pasta
    for nome in list(sys.modules):
        if nome in ('local_server', 'contas', 'dados_batalha', 'tutorial_campaign',
                    'recruitment_local', 'hero_training_local', 'formacao_pesadelo',
                    'energia', 'recarga', 'controle'):
            del sys.modules[nome]
    srv = importlib.import_module('local_server')
    db = srv.BANCO
    conta = db.criar_conta('recarga_test', 'Temporary123!')['id']
    token = db.abrir_sessao(conta)
    srv._sessao_conexao['token'] = token

    conexao_antes = db._conn
    comandos_antes = set(srv.MINIMOS)

    # 1) Recarga normal preserva banco, sessao e socket.
    recarga = importlib.import_module('recarga')
    ok, mensagens = recarga.recarregar(srv)
    checar('recarga concluida', ok, ' | '.join(mensagens[-1:]))
    checar('mesma conexao SQLite', db._conn is conexao_antes)
    checar('sessao continua valida', db.sessao_de(token)['conta_id'] == conta)
    checar('login ainda funciona',
           db.autenticar('recarga_test', 'Temporary123!')['id'] == conta)

    # 2) Os comandos continuam registrados (nada ficou faltando).
    faltando = comandos_antes - set(srv.MINIMOS)
    checar('nenhum comando perdido', not faltando, repr(sorted(faltando)))
    checar('energia re-registrada', 'power_swallow' in srv.MINIMOS)
    checar('formacao re-registrada', 'get_hard_copy_user_formation' in srv.MINIMOS)

    # 3) Os comandos respondem igual depois da recarga.
    r = srv.despacha('9\r\npower_swallow\r\n1\r\n')
    checar('power_swallow responde', 'power_swallow 0' in r, r[:60])

    # 4) Se um modulo quebrar (arquivo invalido), a recarga e revertida e o
    #    servidor continua de pe com o codigo anterior.
    #    Simulamos registrando no sys.modules um modulo cujo install estoura:
    #    e exatamente o que acontece quando eu introduzo um erro de sintaxe ou
    #    uma excecao no install de um modulo novo.
    import types
    quebrado = types.ModuleType('energia')
    def _install_ruim(servidor):
        raise RuntimeError('falha simulada no install')
    quebrado.install = _install_ruim
    sys.modules['energia'] = quebrado
    # Impede o import de reler o arquivo bom e mascarar a falha.
    recarga.importlib.import_module = lambda nome: sys.modules[nome]
    ok2, mensagens2 = recarga.recarregar(srv)
    checar('falha na recarga e detectada', ok2 is False, ' | '.join(mensagens2[-1:]))
    checar('codigo anterior mantido no ar', 'power_swallow' in srv.MINIMOS)
    r = srv.despacha('10\r\npower_swallow\r\n1\r\n')
    checar('servidor continua respondendo apos falha', 'power_swallow 0' in r, r[:60])

    try:
        db._conn.close()
    except Exception:
        pass

if falhas:
    print('\nRECARGA_FAILED: ' + ', '.join(falhas))
    sys.exit(1)
print('\nRECARGA_PASSED recarrega regras sem derrubar banco, sessao nem socket')
