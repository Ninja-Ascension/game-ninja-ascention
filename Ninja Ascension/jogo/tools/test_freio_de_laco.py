# tools/test_freio_de_laco.py — CONFERE O FREIO DE LACO DO SERVIDOR.
#
# Item 4 do pedido do jogador: "Impeca o ciclo ilimitado de repeticao das
# solicitacoes". O ciclo real observado foi:
#
#     comando obrigatorio -> -3 -> dialogo de erro -> relogin -> mesmo comando
#
# Este teste fala com um servidor JA RODANDO em 127.0.0.1:18080 (igual a
# tools/test_local_server.py) e usa um nome de comando que NAO existe no
# acervo, para nao interferir em nada. O que se prova:
#   * as primeiras respostas sao -3 (falha continua VISIVEL, nao escondida);
#   * a partir de LIMITE_REPETICOES a resposta vira ACK neutro (o cliente
#     para de abrir o dialogo de erro, o laco morre);
#   * o log registra a decisao uma vez, com o nome do comando.
import os
import sys
import time
import urllib.request
import zlib

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                os.pardir, "port", "server"))
from local_server import swap  # noqa: E402

URL = "http://127.0.0.1:18080/iniServer"
# Nome UNICO por execucao: o contador do freio vive no processo do servidor
# e nao e zerado entre testes. Com nome fixo, a segunda execucao ja comecaria
# acima do limite e o teste falharia por estado acumulado, nao por defeito.
COMANDO = "comando_que_nunca_existe_laco_%d" % (int(time.time() * 1000) % 10**9)


def pedido(texto):
    body = swap(zlib.compress(texto.encode("utf-8"), 9))
    req = urllib.request.Request(URL, data=body, method="POST",
                                 headers={"Content-Type": "application/octet-stream"})
    return zlib.decompress(swap(urllib.request.urlopen(req, timeout=10).read())
                           ).decode("utf-8", "replace")


def main():
    status = []
    for i in range(6):
        r = pedido("%d\r\n%s\r\n\r\n" % (100 + i, COMANDO))
        status.append(r.split(" ")[2])
    print("[freio] status das 6 repeticoes:", status)

    if status[0] != "-3":
        print("FALHA: a primeira resposta deveria ser -3 (falha visivel)")
        return 1
    if "-3" not in status[:3]:
        print("FALHA: as primeiras repeticoes deveriam recusar (-3)")
        return 1
    if status[-1] != "0":
        print("FALHA: depois do limite a resposta deveria virar ACK (0), "
              "senao o laco continua")
        return 1
    if "0" not in status:
        print("FALHA: o freio nao atuou")
        return 1

    log = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                       os.pardir, "port", "server", "server.log")
    achou = False
    if os.path.exists(log):
        with open(log, "r", encoding="utf-8", errors="replace") as f:
            for linha in f:
                if "FREIO DE LACO" in linha and COMANDO in linha:
                    achou = True
                    print("[freio] log:", linha.strip()[:150])
                    break
    if not achou:
        print("FALHA: o freio atuou sem registrar no log")
        return 1

    print("SUCESSO: o laco e contido (visivel nas primeiras, ACK depois, "
          "registrado no log)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
