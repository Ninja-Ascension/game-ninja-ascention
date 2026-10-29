"""White Zetsu / Digital Purify screen initialization from original tables."""

import secrets
import dados_batalha as data


def _candidates():
    ships = data.tabela('ship_mould.txt')
    evolutions = data.tabela('ship_evo_mould.txt')
    words = data.tabela('word_mould.txt')
    result = []
    seen_names = set()
    for key, row in ships.items():
        try:
            # Keep one canonical form per recruitable shinobi, so the six
            # random choices do not contain multiple evolution copies of one
            # character. Character and evolution IDs remain from the APK data.
            if len(row) <= 71 or int(row[3]) != 1 or int(row[52]) != int(key):
                continue
            initial_group = int(row[1])
            fit_ids = [part.strip() for part in row[71].split(',') if part.strip()]
            if initial_group < 1 or initial_group > len(fit_ids):
                continue
            evolution = evolutions.get(fit_ids[initial_group - 1])
            if evolution is None or len(evolution) < 2:
                continue
            name_id = str(evolution[1])
            name_row = words.get(name_id)
            if name_row is None or len(name_row) < 3 or not name_row[2].strip():
                continue
            # The config contains several model IDs for one named character;
            # show each actual ninja once in the six-choice list.
            visible_name = name_row[2].strip().casefold()
            if visible_name in seen_names:
                continue
            seen_names.add(visible_name)
            result.append(int(key))
        except (IndexError, TypeError, ValueError):
            continue
    return sorted(set(result))


def install(server):
    candidates = _candidates()

    def initialize(seq, text):
        try:
            account = server.BANCO.sessao_de(server._sessao_da_conexao())['conta_id']
            # The original commander appends an empty param_list line for this
            # no-argument request; ignore blank trailing protocol fields.
            lines = [line for line in server._linhas(text) if line.strip()]
            expected = str(server.BANCO.perfil(account)['user_id'])
            if lines != [expected]:
                raise ValueError('perfil_invalido')
            if len(candidates) < 6:
                raise ValueError('lista_original_de_ninjas_indisponivel')

            selected = secrets.SystemRandom().sample(candidates, 6)
            # Parser 12556 expects six "slot,ship_mould_id" pairs. The
            # client uses the second value for the character model and sends
            # the zero-based slot when creating/joining a team.
            roster = '|'.join('%d,%d' % (index, mould)
                              for index, mould in enumerate(selected))
            return ' '.join([str(seq), 'ship_purify_init', '0', '12556', roster])
        except (server._contas.ErroConta, ValueError, IndexError, TypeError) as exc:
            return server.recusa('ship_purify_init', seq,
                                 str(exc) or 'purify_indisponivel')

    server.MINIMOS['ship_purify_init'] = initialize
