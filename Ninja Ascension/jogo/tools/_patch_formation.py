"""Substitui o handler formation_change (linhas 120-148) pelo formato real."""
from pathlib import Path

alvo = Path('E:/[code]/nk/port/server/recruitment_local.py')
linhas = alvo.read_text(encoding='utf8').splitlines(keepends=True)

inicio = next(i for i, l in enumerate(linhas) if l.strip().startswith('def formation(seq,text):'))
fim = next(i for i in range(inicio, len(linhas))
           if linhas[i].strip().startswith('server.MINIMOS['))
print('substituindo linhas %d-%d' % (inicio + 1, fim))

novo = '''    def formation(seq,text):
        """Troca de formacao no formato que o cliente REALMENTE envia.

        Formatos encontrados nos scripts originais:

        Formation.lua:759-763 (tela principal):
            ship_id \\r\\n posicao \\r\\n "1"      -> coloca; posicao 0 retira
        FormationChangeMakeWar.lua:435-439:
            ship_id \\r\\n posicao                -> duas linhas, sem modo
        FormationChange.lua:510-512:
            ship_id \\r\\n posicao \\r\\n "2"      -> arrastar entre vagas

        O handler antigo exigia user_id na primeira linha e modo 1/-1, que
        nenhum script envia: toda troca caia em ninja_nao_possuido ou
        modo_invalido, e por isso o "+" nao funcionava.
        """
        try:
            session=db.sessao_de(server._sessao_da_conexao());account=session['conta_id']
            lines=[l.strip() for l in server._linhas(text) if l.strip()!='']
            if not lines:raise ValueError('pedido_vazio')

            # Caminhos antigos prefixam o user_id; aceitamos as duas formas.
            user_id=str(db.perfil(account)['user_id'])
            if len(lines)>=2 and lines[0]==user_id:
                lines=lines[1:]

            ship_id=lines[0]
            entry=next((e for e in all_owned(db,account) if str(e[0])==ship_id),None)
            if not entry:raise ValueError('ninja_nao_possuido')
            position=int(lines[1]) if len(lines)>1 else 0
            mode=lines[2] if len(lines)>2 else '1'
            if mode not in ('1','2'):raise ValueError('modo_invalido')
            if not 0<=position<=6:raise ValueError('posicao_invalida')

            with db._lock:
                slots=_slots_locked(db,account);ship=str(entry[0])
                if position==0:
                    anterior=slots.index(ship) if ship in slots else None
                    if anterior is None:raise ValueError('ninja_fora_da_formacao')
                    slots[anterior]='0'
                    change=['56','-1',str(anterior+1),ship,'-1']
                else:
                    previous=slots.index(ship) if ship in slots else None
                    displaced=slots[position-1]
                    if previous is not None and previous!=position-1:
                        slots[previous]=displaced
                    slots[position-1]=ship
                    change=['56',ship,str(position),displaced,
                            str(previous+1 if previous is not None else -1)]
                with db._conn:
                    for index,value in enumerate(slots,1):
                        db._conn.execute('INSERT OR REPLACE INTO local_formation_slots VALUES (?,?,?)',(account,index,int(value)))
            server.log('formation_change conta=%s ship=%s pos=%s modo=%s -> %s'
                       % (account,ship,position,mode,slots))
            return ' '.join([str(seq),'formation_change','0']+change+formation_tokens(db,account))
        except (server._contas.ErroConta,ValueError) as exc:
            server.log('formation_change RECUSADO: %s' % exc)
            return server.recusa('formation_change',seq,str(exc))
'''

linhas[inicio:fim] = [novo]
alvo.write_text(''.join(linhas), encoding='utf8')
print('ok, arquivo tem agora %d linhas' % len(''.join(linhas).splitlines()))
