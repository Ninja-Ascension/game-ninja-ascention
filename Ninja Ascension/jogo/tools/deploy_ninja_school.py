"""Backup the live SQLite database, then reload local server rules."""
import sqlite3, socket
from pathlib import Path
from datetime import datetime
root=Path(__file__).resolve().parents[1]
source=root/'port/dados/contas.sqlite3'
if not source.is_file(): raise SystemExit('Banco esperado não encontrado; nenhuma alteração efetuada.')
target=root/'build'/('contas-before-ninja-school-'+datetime.now().strftime('%Y%m%d-%H%M%S')+'.sqlite3')
with sqlite3.connect(source) as live,sqlite3.connect(target) as backup:
    live.backup(backup)
print('Backup: '+str(target))
with socket.create_connection(('127.0.0.1',18081),timeout=15) as channel:
    channel.sendall(b'recarregar\n')
    reply=b''
    while True:
        part=channel.recv(65536)
        if not part:break
        reply+=part
    result=reply.decode('utf8','replace')
    print(result)
    if not result.startswith('OK\n'):raise SystemExit('Recarga falhou; conferir relatório.')
