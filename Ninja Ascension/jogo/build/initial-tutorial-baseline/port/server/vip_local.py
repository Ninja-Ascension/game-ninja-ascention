"""VIP level per account (login_init field 62, read by the client as _ED.vip_grade)."""


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_vip (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, grade INTEGER NOT NULL)')


def grade(db, conta_id):
    schema(db)
    row = db._conn.execute('SELECT grade FROM local_vip WHERE conta_id=?', (conta_id,)).fetchone()
    return str(row[0] if row else 0)


def set_grade(db, conta_id, value):
    schema(db)
    db._conn.execute('INSERT INTO local_vip(conta_id, grade) VALUES(?,?) ON CONFLICT(conta_id) DO UPDATE SET grade=excluded.grade', (conta_id, int(value)))
    db._conn.commit()
