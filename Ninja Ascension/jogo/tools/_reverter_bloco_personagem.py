"""Reverte o bloco de personagem para o ramo l_naruto (27 campos + 16 = 43).

O parser (ProtocolParserCopy.lua:519-521) inclui __lua_project_l_naruto no 'if',
entao o ramo correto e o da linha 523 (27 campos). O 'else' da linha 570 tem 33
campos e nao roda neste projeto — usa-lo desalinhava relationship_count.
"""
import io

P = 'E:/[code]/nk/port/server/recruitment_local.py'
s = io.open(P, encoding='utf8').read()

i = s.find('    # Ordem EXATA do ramo l_naruto')
j = s.find('assert len(fields) == 49')
k = s.find('\n', j) + 1

if i < 0 or j < 0:
    raise SystemExit('trecho nao encontrado (i=%s j=%s)' % (i, j))

novo = '''    # Ordem EXATA do ramo l_naruto (ProtocolParserCopy.lua:523-558): 27 campos.
    # ATENCAO: o 'if' da linha 519 inclui __lua_project_l_naruto, entao ESTE e
    # o ramo usado. O bloco a partir da linha 570 ('else') tem 33 campos
    # (ship_place, ship_force, *_grade_type...) e NAO roda neste projeto.
    # Depois dos 27 vem (linhas 704-756):
    #   28 relationship_count   (+2 por relacao)
    #   29 talent_count         (+2 por talento)
    #   30..37 ship_train_info (8 valores)
    #   38..39 skill_level, skill_value
    #   40..43 awakenLevel, awakenstates, combLockState, combUpLockState
    # Total com os dois contadores em 0: 43.
    #
    # Nenhum campo pode ser '' (string vazia): a resposta e separada por tab e
    # '' nao gera token, deslocando todos os campos seguintes em 1.
    fields=[str(ship),           # 1  ship_id
            str(mould),          # 2  ship_template_id
            col(53),             # 3  ship_base_template_id
            '0',                 # 4  captain_type
            col(4),              # 5  shipSpirit (velocidade base)
            '0',                 # 6  ship_fighting_spirit
            '0',                 # 7  ship_skin_info
            '0|-1',              # 8  ship_type
            col(36) or '-',      # 9  captain_name
            name,                # 10 ship_name
            str(nivel),          # 11 ship_grade = NIVEL do personagem
            col(13),             # 12 ship_health
            col(14),             # 13 ship_courage
            col(15),             # 14 ship_intellect
            col(16),             # 15 ship_quick
            '0',                 # 16 initial_sp_increase
            '-',                 # 17 property_values (nunca vazio)
            col(37),             # 18 ship_picture
            str(math.floor((float(col(14))*.5+float(col(13))*.1+(float(col(15))+float(col(16)))*.75)*7.5)),  # 19 hero_fight
            col(10),             # 20 ship_leader
            col(11),             # 21 ship_wisdom
            col(28),             # 22 skill_mould
            '0',                 # 23 skill_name
            '0',                 # 24 skill_describe
            col(29),             # 25 deadly_skill_mould
            '0',                 # 26 exprience
            '0',                 # 27 grade_need_exprience
            '0',                 # 28 relationship_count (laco 706)
            '0',                 # 29 talent_count       (laco 716)
            '0','0','0','0','0','0','0','0',   # 30-37 ship_train_info
            '0','0',             # 38-39 skill_level, skill_value
            '0','0','0','0',     # 40-43 awakenLevel, awakenstates,
    ]                        #        combLockState, combUpLockState
    assert len(fields) == 43, 'user_ship: parser espera 43 campos, vieram %d' % len(fields)
'''

s = s[:i] + novo + s[k:]
io.open(P, 'w', encoding='utf8', newline='').write(s)
print('recruitment_local.py revertido para o ramo l_naruto (43 campos)')
