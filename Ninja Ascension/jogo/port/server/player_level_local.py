"""Player (account) level and EXP following the original user_experience_param table.

Original rule recovered from the data: every winning battle grants player EXP
equal to the energy it costs (npc.attack_need_food). Evidence: the level curve
(level 2 needs 7, levels 3-8 need 6, ...) matches battles costing 6/12 energy,
while npc.difficulty_reward holds the placeholder "99,99" in all 3000 rows.

user_experience_param columns: 0 id, 1 level, 2 EXP needed to reach this level,
3 energy capacity, 4 mine capacity, 5 battle units, 6 endurance gained,
7 gold gained, 8 energy gained on reaching this level.
EXP stored here is the progress inside the current level (the client shows
user_experience / user_grade_need_experience and resets EXP to 0 on parser 40).
"""
import dados_batalha as data


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_player_exp (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, exp INTEGER NOT NULL DEFAULT 0)')


def tabela():
    return data.tabela('user_experience_param.txt')


def nivel_maximo():
    return max(int(k) for k in tabela() if k.isdigit())


def necessario(grade):
    """EXP needed to go from `grade` to the next level (0 at max level)."""
    proximo = tabela().get(str(grade + 1))
    return int(proximo[2]) if proximo else 0


def capacidade_energia(grade):
    row = tabela().get(str(grade))
    return int(row[3]) if row else 60


def estado(db, account):
    with db._lock:
        row = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
        exp = db._conn.execute('SELECT exp FROM local_player_exp WHERE conta_id=?', (account,)).fetchone()
    grade = int(row[0]) if row else 1
    return grade, int(exp[0]) if exp else 0, necessario(grade)


def ganhar(db, account, quantidade):
    """Add EXP inside the caller's transaction. Returns (grade, exp, need,
    leveled, energy_gained). Level-up rewards come from the table."""
    grade, exp, _ = estado(db, account)
    exp += max(0, int(quantidade))
    subiu = False
    energia = endurance = ouro = 0
    while grade < nivel_maximo() and exp >= necessario(grade) > 0:
        exp -= necessario(grade)
        grade += 1
        subiu = True
        row = tabela()[str(grade)]
        endurance += int(row[6]); ouro += int(row[7]); energia += int(row[8])
    if grade >= nivel_maximo():
        exp = 0
    db._conn.execute('INSERT INTO local_campaign(conta_id,grade,silver) VALUES (?,?,0) ON CONFLICT(conta_id) DO UPDATE SET grade=excluded.grade', (account, grade))
    db._conn.execute('INSERT INTO local_player_exp VALUES (?,?) ON CONFLICT(conta_id) DO UPDATE SET exp=excluded.exp', (account, exp))
    if energia or endurance or ouro:
        db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id,food,endurance) VALUES (?,60,150)', (account,))
        db._conn.execute('UPDATE local_resources SET food=food+?, endurance=endurance+?, gold=gold+? WHERE conta_id=?',
                         (energia, endurance, ouro, account))
    return grade, exp, necessario(grade), subiu, energia


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
