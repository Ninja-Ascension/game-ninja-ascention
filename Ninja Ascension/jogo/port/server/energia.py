"""energia.py — comandos de energia (power) que o cliente pede ao entrar no jogo.

PROBLEMA REAL ENCONTRADO NO LOG:
    [PENDENTE] cmd=draw_endurance_init
    CRASH DO CLIENTE: Home.lua:2136: utils.lua:9: attempt to index local 'str'
    (a nil value)  -- zstring.split(_ED._add_enger_info, "|")

`_ED._add_enger_info` só é preenchido pelo parser 194
(parse_return_add_enger_init, ProtocolParserCopy.lua:7142-7148), que responde
ao comando `power_swallow` (ProtocolCommander.lua:1213). Como o servidor local
nunca respondia esse comando, o valor ficava nil e a Home quebrava ao abrir.

Contrato do parser 194 (lista de tokens, nessa ordem):
    [1] _add_enger        -- estado do "frango assado" (energia)
    [2] _add_enger_time   -- estado do período
    [3] _add_enger_info   -- "estado,horário|estado,horário|..." (4 períodos)
        estado 0 + horário 0 => precisa "assinar" para resgatar

Os horários vêm de activity_config (dms["activity_config"], linha 1), que é a
mesma tabela que a Home usa para desenhar os quatro períodos.
"""
import datetime
import time
import dados_batalha as data


def periodos():
    """Os quatro períodos de energia, exatamente como a Home os lê.

    Home.lua:2135 -> zstring.split(dms.string(dms["activity_config"], 1,
    activity_config.param), "|"); LocalDatas.lua:5521: param é a coluna 4.
    O arquivo fica em res/configs/, não em res/mould/ (dados_batalha.MOULD),
    por isso é lido aqui direto.
    """
    import os
    caminho = os.path.join(os.path.dirname(data.__file__), '..', '..',
                           '01_conteudo_apk', 'assets', 'res', 'data',
                           'configs', 'activity_config.txt')
    caminho = os.path.normpath(caminho)
    try:
        with open(caminho, encoding='utf-8', errors='replace') as arquivo:
            for linha in arquivo:
                colunas = linha.rstrip('\n').split('\t')
                if colunas and colunas[0].strip() == '1':
                    texto = colunas[3] if len(colunas) > 3 else ''
                    return [p for p in texto.split('|') if p]
    except OSError:
        pass
    return []


def info_tokens(db=None, account=None):
    """"estado,hora" por período, incluindo os resgates persistidos da conta.

    A conta local não tem assinatura de energia; declarar 0,0 é o estado
    "ainda não resgatado", que é o que a Home/DailyTask esperam para exibir os
    períodos e não quebrar.
    """
    claimed = {}
    if db is not None and account is not None:
        claimed = dict(db._conn.execute('SELECT slot,claimed FROM local_energy_claims WHERE conta_id=? AND day=?',(account, cycle()[0])))
    itens = []
    for index, periodo in enumerate(periodos(), 1):
        hora = periodo.split(',')[0]
        itens.append(('1,%s' % claimed[index]) if index in claimed else ('0,%s' % hora))
    if not itens:
        # Sem tabela: quatro períodos vazios mantêm o formato "a,b|c,d|..."
        itens = ['0,00:00:00'] * 4
    return itens


def config(ident):
    from pathlib import Path
    path=Path(data.MOULD).parent/'configs/activity_config.txt'
    return next(row[3] for line in path.read_text(encoding='utf8').splitlines() if (row:=line.split('\t'))[0]==ident)

def hour_seconds(value):
    h,m,s=map(int,value.split(':'));return h*3600+m*60+s

def cycle():
    # The client builds these slots from its synchronized local game clock
    # and shifts 00:00-05:00 into the previous daily cycle. Match that exact
    # 05:00 cutoff in the server's configured local timezone. The old code
    # subtracted five hours in UTC but compared against a midnight UTC origin;
    # this shifted every slot by the host offset and could reject a visible
    # claim button (or accept a claim in a different window).
    now=time.time()
    current=datetime.datetime.fromtimestamp(now).astimezone()
    day=(current-datetime.timedelta(hours=5)).date()
    origin=datetime.datetime.combine(day,datetime.time(),tzinfo=current.tzinfo).timestamp()
    return day.isoformat(),now-origin,origin


def install(server):
    db=server.BANCO
    with db._lock,db._conn:
        db._conn.execute('CREATE TABLE IF NOT EXISTS local_energy_claims(conta_id INTEGER,day TEXT,slot INTEGER,claimed INTEGER,food INTEGER,gold INTEGER,PRIMARY KEY(conta_id,day,slot))')
    def account_for(text):
        account=db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields=server._linhas(text)
        while fields and fields[-1]=='':fields.pop()
        if not fields or fields[0]!=str(db.perfil(account)['user_id']):raise ValueError('conta_da_energia_invalida')
        return account,fields
    def power_swallow(seq, texto=''):
        try:
            account,fields=account_for(texto)
            if len(fields)!=1:raise ValueError('pedido_de_energia_invalido')
            with db._lock:
                return ' '.join([str(seq),'power_swallow','0','194','0','0','|'.join(info_tokens(db,account))])
        except (server._contas.ErroConta,ValueError) as exc:return server.recusa('power_swallow',seq,str(exc))
    def dinner_time(seq,texto=''):
        try:
            account,fields=account_for(texto)
            if len(fields)!=2 or fields[1] not in ('1','2','3','4'):raise ValueError('periodo_de_energia_invalido')
            slot=int(fields[1]);day,seconds,origin=cycle()
            periods=periodos()
            if len(periods)!=4:raise ValueError('configuracao_de_energia_ausente')
            start,end,amount=periods[slot-1].split(',')
            start,end=hour_seconds(start),hour_seconds(end);amount=int(amount)
            with db._lock,db._conn:
                old=db._conn.execute('SELECT 1 FROM local_energy_claims WHERE conta_id=? AND day=? AND slot=?',(account,day,slot)).fetchone()
                food_delta=gold_cost=0
                if not old:
                    if seconds<start:raise ValueError('horario_de_energia_ainda_nao_abriu')
                    if db.perfil(account)['criada_em']//1000>origin+end:raise ValueError('conta_criada_apos_o_periodo')
                    if seconds>end:gold_cost=int(config('2').split(',')[slot-1])
                    wallet=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                    if not wallet or wallet[0]<gold_cost:raise ValueError('gold_insuficiente')
                    food_delta=amount
                    db._conn.execute('UPDATE local_resources SET food=food+?,gold=gold-? WHERE conta_id=?',(amount,gold_cost,account))
                    db._conn.execute('INSERT INTO local_energy_claims VALUES (?,?,?,?,?,?)',(account,day,slot,int(time.time()),amount,gold_cost))
                gold,food=db._conn.execute('SELECT gold,food FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                reply=[str(seq),'dinner_time','0','29',str(food_delta),str(food),'25',str(-gold_cost),str(gold),'194','0','0','|'.join(info_tokens(db,account))]
                if not old:
                    reply+=['171','6','1','-1','12',str(amount)]
                return ' '.join(reply)
        except (server._contas.ErroConta,ValueError,IndexError) as exc:return server.recusa('dinner_time',seq,str(exc))

    def draw_endurance_init(seq, texto=''):
        """Parser 199 (ProtocolParserCopy.lua:7226-7228).

        Dois tokens: remain_times e get_count. get_count=0 encerra o laço e o
        cliente fica com endurance_init_info.get_info = {} — estado neutro, sem
        lista de quem já recebeu resistência. Não é "sucesso genérico": a conta
        local não tem jogadores que tenham te dado resistência.

        Antes: o comando não era respondido e caía no freio de laço
        ("[PENDENTE] cmd=draw_endurance_init"), registrado no log do jogador.
        """
        return ' '.join([str(seq), 'draw_endurance_init', '0', '199', '0', '0'])

    server.MINIMOS['dinner_init'] = lambda seq,text='': power_swallow(seq,text).replace(' power_swallow ', ' dinner_init ',1)
    server.MINIMOS['dinner_time'] = dinner_time
    server.MINIMOS['power_swallow'] = power_swallow
    server.MINIMOS['draw_endurance_init'] = draw_endurance_init
    # Original parser 476: native-only recharge mode, no web recharge service.
    server.MINIMOS['get_web_recharge_state'] = lambda seq,text='': '%s get_web_recharge_state 0 476 0 0' % seq
