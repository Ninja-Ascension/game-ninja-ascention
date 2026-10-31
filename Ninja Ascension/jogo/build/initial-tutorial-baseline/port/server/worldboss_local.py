"""World Boss / White Zetsu Army initial state from the original parsers."""


def install(server):
    def initialize(seq, text):
        try:
            account = server.BANCO.sessao_de(server._sessao_da_conexao())['conta_id']
            lines = server._linhas(text)
            expected = str(server.BANCO.perfil(account)['user_id'])
            if lines and lines != [expected]:
                raise ValueError('perfil_invalido')

            # Parser 355: boost flags + active army list. The local server has
            # no authoritative live spawn/schedule feed, so return an honest
            # empty list; the original client then draws its idle/helper state.
            # Parser 356: exploit totals/ranks shown in the page header.
            return ' '.join([str(seq), 'rebel_army_init', '0', '355',
                             '0', '0', '0', '356', '0', '0', '0', '0', '0'])
        except (server._contas.ErroConta, ValueError, IndexError, TypeError) as exc:
            return server.recusa('rebel_army_init', seq,
                                 str(exc) or 'exercito_zetsu_indisponivel')

    server.MINIMOS['rebel_army_init'] = initialize
