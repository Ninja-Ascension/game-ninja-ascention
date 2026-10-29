"""Formação do "pesadelo" (hard copy): comando 9018 get_hard_copy_user_formation.

O cliente pede este comando ao abrir a LDuplicateWindow ("获取噩梦副本阵容信息",
LDuplicateWindow.lua:3089-3102) e fica esperando a resposta antes de pintar os
ícones dos heróis (updateHeroIcons). Enquanto o servidor não respondia, o
carregador de batalha parava em 9%.

Contrato do cliente:
  pedido  (ProtocolCommanderCopyExx.lua:5173-5179): seq / cmd / user_id
  resposta (parser 12407, ProtocolParserCopyExx.lua:3288-3312): UM campo
    user_formation:
      "-1"          -> usa a formação atual (_ED.user_formetion_status)
      "a,b,c,d,e,f" -> formação salva do pesadelo (6 ids de herói)

O port não tem um "time do pesadelo" separado: a formação da conta é única
(tutorial_formation, mais o Naruto fixo na posição 2, ver
recruitment_local.formation_tokens). Responder "-1" faz o cliente reutilizar
essa mesma formação — que é exatamente o significado documentado do campo.
"""
import recruitment_local


def install(server):
    db = server.BANCO

    def hard_copy_formation(seq, text):
        try:
            sessao = db.sessao_de(server._sessao_da_conexao())
            conta = sessao['conta_id']
            linhas = server._linhas(text)
            # O pedido carrega apenas o user_id (ProtocolCommanderCopyExx:5177).
            if not linhas or linhas[0] != str(db.perfil(conta)['user_id']):
                raise ValueError('pedido_invalido')
            # Confere que existe formação para reutilizar; sem ela "-1" deixaria
            # o cliente com _ED.user_formetion_status vazio.
            tokens = recruitment_local.formation_tokens(db, conta)
            if not tokens:
                raise ValueError('formacao_ausente')
            server.log('HARD_COPY_FORMATION conta_id=%s resposta=-1 (usa formacao atual)' % conta)
            return ' '.join([str(seq), 'get_hard_copy_user_formation', '0', '-1'])
        except (server._contas.ErroConta, ValueError) as exc:
            return server.recusa('get_hard_copy_user_formation', seq, str(exc))

    server.MINIMOS['get_hard_copy_user_formation'] = hard_copy_formation
