"""controle.py — canal local para recarregar o servidor sem reinicia-lo.

Escuta em 127.0.0.1:NR_CONTROLE (padrao 18081), SEPARADO da porta do jogo
(18080), para nao interferir no protocolo.

Comandos (texto simples, uma linha):
    recarregar  -> recarrega os modulos de regra; responde com o relatorio.
    estado      -> quantos comandos estao registrados e desde quando roda.

Seguranca: so aceita conexao de loopback e NAO aceita comandos do jogo. Se o
jogo estiver aberto, ele continua falando com 18080 como sempre — a recarga
nao fecha nem reinicia nada. Depois de recarregar, o jogador reloga a conta
para que o novo codigo atenda o proximo login.
"""
import os
import socket
import threading
import time

import recarga

PORTA_PADRAO = 18081
HOST = '127.0.0.1'

_INICIADO = time.time()


def _atender(conexao, servidor, log):
    try:
        dados = conexao.recv(4096).decode('utf-8', 'replace').strip().lower()
        if dados == 'recarregar':
            ok, mensagens = recarga.recarregar(servidor)
            log('[CONTROLE] recarregar -> %s' % ('ok' if ok else 'falhou'))
            for linha in mensagens:
                log('[CONTROLE]' + linha if not linha.startswith(' ') else '[CONTROLE] ' + linha.strip())
            resposta = ('OK\n' if ok else 'FALHOU\n') + '\n'.join(mensagens) + '\n'
        elif dados == 'estado':
            minutos = (time.time() - _INICIADO) / 60.0
            resposta = ('OK\ncomandos registrados: %d\nno ar ha %.1f min\n'
                        % (len(servidor.MINIMOS), minutos))
        else:
            resposta = 'DESCONHECIDO %r\nuse: recarregar | estado\n' % dados
    except Exception as exc:  # nunca derrubar o servidor por causa do controle
        resposta = 'ERRO %s\n' % exc
    finally:
        try:
            conexao.sendall(resposta.encode('utf-8'))
            conexao.close()
        except OSError:
            pass


def iniciar(servidor, log, porta=None):
    """Sobe o canal de controle em uma thread daemon. Devolve a porta usada."""
    porta = int(os.getenv('NR_CONTROLE') or porta or PORTA_PADRAO)
    soquete = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Windows: sem SO_REUSEADDR para que uma segunda instancia falhe em vez de
    # dividir a porta silenciosamente (mesmo motivo do servidor do jogo).
    try:
        soquete.bind((HOST, porta))
    except OSError as exc:
        log('[CONTROLE] porta %d indisponivel (%s): recarga desativada' % (porta, exc))
        soquete.close()
        return None
    soquete.listen(4)
    log('[CONTROLE] recarga em http://%s:%d — comando: recarregar' % (HOST, porta))

    def laco():
        while True:
            try:
                conexao, _ = soquete.accept()
            except OSError:
                return
            threading.Thread(target=_atender, args=(conexao, servidor, log),
                             daemon=True).start()

    threading.Thread(target=laco, daemon=True).start()
    return porta
