"""Contas locais: armazenamento persistente, senhas derivadas e sessoes.

Separado de local_server.py para poder ser testado sem socket. Todo o estado
vive num unico arquivo SQLite, em disco E:, FORA dos recursos originais:

    padrao: E:\\[code]\\nk\\port\\dados\\contas.sqlite3

Regras (por decisao do usuario nesta rodada, ver port/docs/STATUS.md):
  * senha NUNCA em texto puro nem em forma reversivel: PBKDF2-HMAC-SHA256,
    salt individual de 16 bytes, 200_000 iteracoes, guardado como
    "pbkdf2_sha256$<iter>$<salt_b64>$<hash_b64>";
  * token de sessao imprevisivel (32 bytes de os.urandom, base64url = 43
    caracteres, que e EXATAMENTE o formato que o acervo valida em
    account_sys_valid_token, AccountSysManager.lua:38-41);
  * a sessao e invalidada ao sair (revogada no banco);
  * nada de senha/token completo nos logs: so o prefixo do nome e o id curto.
"""
import base64
import hashlib
import os
import re
import secrets
import sqlite3
import threading
import time

# ---------------------------------------------------------------------------
# Regras de nome/senha. Documentadas em port/server/data_minimos.txt (item 09).
# O protocolo separa campos por CRLF e o acervo passa o texto por
# zstring.exchangeTo (utils.lua:67), entao \r \n e "|" quebrariam o pedido.
# ---------------------------------------------------------------------------
NOME_MIN = 3
NOME_MAX = 20
SENHA_MIN = 6
SENHA_MAX = 32
NOME_RE = re.compile(r"^[A-Za-z0-9_.-]{%d,%d}$" % (NOME_MIN, NOME_MAX))
SENHA_PROIBIDOS = set("\r\n| \t")

PBKDF2_ITERACOES = 200_000
SALT_BYTES = 16
TOKEN_BYTES = 32
TOKEN_SEGREDO_PREFIXO = "@tk1:"   # AccountSysManager.lua:36
TOKEN_LEN = 43                    # AccountSysManager.lua:39


class ErroConta(Exception):
    """Erro com codigo estavel consumido pelo servidor e pelos testes."""

    def __init__(self, codigo, mensagem):
        super().__init__(mensagem)
        self.codigo = codigo
        self.mensagem = mensagem


# ---------------------------------------------------------------------------
# Derivacao de senha
# ---------------------------------------------------------------------------
def derivar(senha, salt=None, iteracoes=PBKDF2_ITERACOES):
    salt = salt or os.urandom(SALT_BYTES)
    h = hashlib.pbkdf2_hmac("sha256", senha.encode("utf-8"), salt, iteracoes)
    emb = "pbkdf2_sha256$%d$%s$%s" % (
        iteracoes,
        base64.b64encode(salt).decode("ascii"),
        base64.b64encode(h).decode("ascii"),
    )
    return emb


def conferir(senha, guardado):
    try:
        algo, iteracoes, salt_b64, hash_b64 = guardado.split("$")
        if algo != "pbkdf2_sha256":
            return False
        salt = base64.b64decode(salt_b64)
        esperado = base64.b64decode(hash_b64)
        obtido = hashlib.pbkdf2_hmac(
            "sha256", senha.encode("utf-8"), salt, int(iteracoes))
    except Exception:
        return False
    return secrets.compare_digest(obtido, esperado)


def novo_token():
    return base64.urlsafe_b64encode(os.urandom(TOKEN_BYTES)).decode("ascii").rstrip("=")


def token_valido(token):
    return (isinstance(token, str) and len(token) == TOKEN_LEN
            and re.match(r"^[A-Za-z0-9_-]+$", token) is not None)


# ---------------------------------------------------------------------------
# Normalizacao de nome de usuario
# ---------------------------------------------------------------------------
def normalizar_nome(nome):
    """Regra EXPLICITA de unicidade: minusculas, sem espacos nas pontas.

    'Ana' e 'ana' sao a MESMA conta. O nome exibido e o que o jogador digitou
    na criacao (coluna display_name); a unicidade usa o normalizado.
    """
    if nome is None:
        return ""
    return nome.strip().lower()


def validar_nome(nome):
    n = (nome or "").strip()
    if n == "":
        raise ErroConta("nome_vazio", "Informe o nome de usuario.")
    if not NOME_RE.match(n):
        raise ErroConta(
            "nome_invalido",
            "Nome de usuario: %d a %d caracteres, apenas letras sem acento, "
            "numeros, ponto, hifen e sublinhado." % (NOME_MIN, NOME_MAX),
        )
    return n


def validar_senha(senha, confirmacao=None):
    s = senha or ""
    if s == "":
        raise ErroConta("senha_vazia", "Informe a senha.")
    if len(s) < SENHA_MIN:
        raise ErroConta("senha_curta",
                        "A senha precisa de pelo menos %d caracteres." % SENHA_MIN)
    if len(s) > SENHA_MAX:
        raise ErroConta("senha_longa",
                        "A senha pode ter no maximo %d caracteres." % SENHA_MAX)
    if any(c in SENHA_PROIBIDOS for c in s):
        raise ErroConta("senha_invalida",
                        "A senha nao pode conter espaco, barra vertical "
                        "nem quebra de linha.")
    if confirmacao is not None and s != confirmacao:
        raise ErroConta("senha_diferente", "As senhas nao conferem.")
    return s


# ---------------------------------------------------------------------------
# Banco
# ---------------------------------------------------------------------------
ESQUEMA = """
CREATE TABLE IF NOT EXISTS contas (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    nome          TEXT NOT NULL UNIQUE,   -- normalizado (unicidade)
    display_name  TEXT NOT NULL,          -- como o jogador digitou
    senha_hash    TEXT NOT NULL,          -- pbkdf2_sha256$...
    criada_em     INTEGER NOT NULL        -- epoch ms
);
CREATE TABLE IF NOT EXISTS sessoes (
    token      TEXT PRIMARY KEY,
    conta_id   INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    criada_em  INTEGER NOT NULL,
    expira_em  INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS perfis (
    conta_id   INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
    user_id    INTEGER NOT NULL,
    user_name  TEXT NOT NULL,
    criada_em  INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_sessoes_conta ON sessoes(conta_id);
CREATE TABLE IF NOT EXISTS tutorial_progress (
    conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
    experiencia INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS tutorial_events (
    conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    mould TEXT NOT NULL,
    progress INTEGER NOT NULL,
    PRIMARY KEY(conta_id,mould)
);
CREATE TABLE IF NOT EXISTS local_campaign (
    conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
    grade INTEGER NOT NULL DEFAULT 1,
    silver INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS local_resources (
    conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
    gold INTEGER NOT NULL DEFAULT 0,
    food INTEGER NOT NULL DEFAULT 0,
    endurance INTEGER NOT NULL DEFAULT 0,
    honour INTEGER NOT NULL DEFAULT 0,
    soul INTEGER NOT NULL DEFAULT 0,
    jade INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS local_synthesized (
    conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    mould INTEGER NOT NULL,
    ship_id INTEGER NOT NULL UNIQUE,
    PRIMARY KEY(conta_id,mould)
);
CREATE TABLE IF NOT EXISTS local_formation_slots (
    conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    position INTEGER NOT NULL CHECK(position BETWEEN 1 AND 6),
    ship_id INTEGER NOT NULL,
    PRIMARY KEY(conta_id,position)
);
CREATE TABLE IF NOT EXISTS local_scene_rewards (
    conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    scene INTEGER NOT NULL,
    chest INTEGER NOT NULL,
    items TEXT NOT NULL,
    PRIMARY KEY(conta_id,scene,chest)
);
CREATE TABLE IF NOT EXISTS local_pve_clears (
    conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    scene INTEGER NOT NULL,
    npc INTEGER NOT NULL,
    stars INTEGER NOT NULL,
    PRIMARY KEY(conta_id,scene,npc)
);
CREATE TABLE IF NOT EXISTS local_battle_pending (
    conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
    scene INTEGER NOT NULL,npc INTEGER NOT NULL,difficulty INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS local_great_shinobi_attempts (
    conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    activity_id INTEGER NOT NULL,
    reset_day TEXT NOT NULL,
    remaining INTEGER NOT NULL CHECK (remaining BETWEEN 0 AND 2),
    cooldown_until INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY(conta_id,activity_id)
);
CREATE TABLE IF NOT EXISTS tutorial_recruit (
    conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
    ship_id INTEGER NOT NULL UNIQUE,
    mould INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS tutorial_formation (
    conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
    ship_id INTEGER NOT NULL,
    position INTEGER NOT NULL CHECK(position BETWEEN 1 AND 6)
);
CREATE TABLE IF NOT EXISTS tutorial_training (
    conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
    kit INTEGER NOT NULL DEFAULT 0,
    quality INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS local_inventory (
    conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    mould INTEGER NOT NULL,
    instance_id INTEGER NOT NULL UNIQUE,
    quantity INTEGER NOT NULL,
    PRIMARY KEY(conta_id,mould)
);
-- Rank/estrela por personagem. O rank NAO vem da tabela ship_mould para
-- personagens evoluidos: getHeroStars (EnvironmentDatas.lua:5792) converte
-- rank -> (estrelas, tier). rank 21 = 3 estrelas no tier 7, o "7 estrelas"
-- do jogo. Sem esta tabela, todo personagem ficava com o rank da planilha.
CREATE TABLE IF NOT EXISTS local_ship_rank (
    conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
    ship_id INTEGER NOT NULL,
    rank_level INTEGER NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY(conta_id,ship_id)
);
"""

DURACAO_SESSAO_SEG = 30 * 24 * 3600   # 30 dias


def agora_ms():
    return int(time.time() * 1000)


class Banco:
    def __init__(self, caminho, duracao_sessao=DURACAO_SESSAO_SEG):
        self.caminho = caminho
        self.duracao = duracao_sessao
        # Atomic gameplay operations call profile/inventory readers while
        # holding this same connection lock on the current thread.
        self._lock = threading.RLock()
        self._conn = sqlite3.connect(caminho, check_same_thread=False)
        self._conn.row_factory = sqlite3.Row
        self._conn.execute('PRAGMA foreign_keys=ON')
        with self._lock:
            self._conn.executescript(ESQUEMA)
            # Migracao: bancos criados antes de local_ship_rank ter a coluna
            # `level` (nivel do personagem) precisam receber a coluna agora.
            # CREATE TABLE IF NOT EXISTS nao altera tabela ja existente.
            colunas = {row[1] for row in self._conn.execute('PRAGMA table_info(local_ship_rank)')}
            if 'level' not in colunas:
                self._conn.execute(
                    'ALTER TABLE local_ship_rank ADD COLUMN level INTEGER NOT NULL DEFAULT 1')
            # Old synthesis IDs collided with the guaranteed Sakura (offset 1).
            # Move only synthesized instances into a separate ID namespace.
            for account,mould,old_id in self._conn.execute('SELECT conta_id,mould,ship_id FROM local_synthesized WHERE ship_id<1000000000').fetchall():
                new_id=1000000000+account*100000+mould
                recruit=self._conn.execute('SELECT ship_id FROM tutorial_recruit WHERE conta_id=?',(account,)).fetchone()
                self._conn.execute('UPDATE local_synthesized SET ship_id=? WHERE conta_id=? AND mould=?',(new_id,account,mould))
                if not recruit or recruit[0]!=old_id:
                    self._conn.execute('UPDATE tutorial_formation SET ship_id=? WHERE conta_id=? AND ship_id=?',(new_id,account,old_id))
                    self._conn.execute('UPDATE local_formation_slots SET ship_id=? WHERE conta_id=? AND ship_id=?',(new_id,account,old_id))
            # Bancos criados antes da mudanca carregam o trigger que impedia
            # criar uma segunda conta. O jogador pediu para poder criar contas
            # novas, entao ele e removido no boot de forma idempotente.
            self._conn.execute('DROP TRIGGER IF EXISTS nr_single_account')
            self._conn.commit()

    def fechar(self):
        with self._lock:
            self._conn.close()

    def resetar_para_conta_unica(self, liberar_conta_em_uso=False):
        """Explicit user-requested reset; retain the one-account DB constraint.

        The live player account must never disappear because an automated or
        test run touched the real database (one earlier run of
        tools/test_single_account.py was pointed at port/dados/contas.sqlite3
        instead of a temporary file). The reset therefore refuses to touch a
        database that already holds an account carrying progress unless the
        operator explicitly releases it with a `nraccounts.release` file in the
        database folder (or passes liberar_conta_em_uso=True in code). The
        database folder is also used by backups, never deleted by this method.
        """
        with self._lock:
            count=self._conn.execute('SELECT COUNT(*) FROM contas').fetchone()[0]
            if count and not liberar_conta_em_uso:
                marcador=os.path.join(os.path.dirname(os.path.abspath(self.caminho)),
                                      'nraccounts.release')
                if not os.path.exists(marcador):
                    raise ErroConta("conta_em_uso",
                                    "O banco ja tem conta. Libere com "
                                    "nraccounts.release na pasta do banco.")
            self._conn.execute('PRAGMA secure_delete=ON')
            with self._conn:
                for table in ('sessoes','perfis','tutorial_progress','tutorial_events',
                              'local_campaign','local_pve_clears','local_battle_pending',
                              'tutorial_recruit','tutorial_formation'):
                    self._conn.execute('DELETE FROM '+table)
                self._conn.execute('DELETE FROM contas')
                # O trigger de conta unica foi REMOVIDO: o jogador pediu para
                # poder criar contas novas. A protecao contra apagar a conta
                # real continua onde deve ficar — na recusa acima, que exige
                # o marcador nraccounts.release.
                self._conn.execute('DROP TRIGGER IF EXISTS nr_single_account')
            return count

    def experiencia_tutorial(self, conta_id):
        with self._lock:
            row = self._conn.execute(
                "SELECT experiencia FROM tutorial_progress WHERE conta_id=?", (conta_id,)).fetchone()
            return int(row[0]) if row else 0

    def concluir_intro(self, conta_id):
        with self._lock:
            self._conn.execute(
                "INSERT OR IGNORE INTO tutorial_progress(conta_id,experiencia) VALUES (?,1)",
                (conta_id,))
            self._conn.commit()
        return self.experiencia_tutorial(conta_id)

    # -- contas ------------------------------------------------------------
    def criar_conta(self, nome, senha, confirmacao=None):
        """Cria a conta. Levanta ErroConta para entradas invalidas."""
        nome_exibicao = validar_nome(nome)
        validar_senha(senha, confirmacao)
        chave = normalizar_nome(nome_exibicao)
        emb = derivar(senha)
        with self._lock:
            try:
                cur = self._conn.execute(
                    "INSERT INTO contas (nome, display_name, senha_hash, criada_em)"
                    " VALUES (?, ?, ?, ?)",
                    (chave, nome_exibicao, emb, agora_ms()),
                )
                self._conn.commit()
            except sqlite3.IntegrityError as exc:
                self._conn.rollback()
                if 'nr_single_account' in str(exc):
                    # Bancos antigos ainda podem carregar o trigger; o servidor
                    # ja o remove no boot, mas se ele aparecer a mensagem diz o
                    # caminho real em vez de "use a conta salva".
                    raise ErroConta('conta_unica',
                                    'O banco ainda tem o bloqueio de conta unica. '
                                    'Reinicie o servidor para removê-lo.')
                raise ErroConta("nome_ocupado",
                                "Esse nome de usuario ja esta cadastrado.")
            conta_id = cur.lastrowid
            self._garantir_perfil(conta_id, nome_exibicao)
            self._conn.commit()
        return {"id": conta_id, "nome": nome_exibicao, "nome_chave": chave}

    def autenticar(self, nome, senha):
        """Devolve a conta ou levanta ErroConta. Nunca aceita senha errada."""
        chave = normalizar_nome(nome)
        if chave == "" or senha is None or senha == "":
            raise ErroConta("credenciais_vazias",
                            "Informe o nome de usuario e a senha.")
        with self._lock:
            row = self._conn.execute(
                "SELECT * FROM contas WHERE nome = ?", (chave,)).fetchone()
        # Compare sempre com algo: tempo de resposta nao vaza se o nome existe.
        senha_guardada = row["senha_hash"] if row else derivar("inexistente-salt-fixo")
        if not conferir(senha, senha_guardada) or row is None:
            raise ErroConta("credenciais_invalidas",
                            "Nome de usuario ou senha incorretos.")
        return {"id": row["id"], "nome": row["display_name"],
                "nome_chave": row["nome"]}

    def conta_por_token(self, token):
        """Sessao -> conta. Token caducado/revogado => ErroConta."""
        if not token_valido(token):
            raise ErroConta("token_invalido", "Sessao invalida.")
        with self._lock:
            row = self._conn.execute(
                "SELECT c.id, c.display_name, s.expira_em FROM sessoes s"
                " JOIN contas c ON c.id = s.conta_id WHERE s.token = ?",
                (token,)).fetchone()
            if row is None:
                raise ErroConta("token_invalido", "Sessao invalida.")
            if row["expira_em"] < agora_ms():
                self._conn.execute("DELETE FROM sessoes WHERE token = ?", (token,))
                self._conn.commit()
                raise ErroConta("token_expirado", "Sessao expirada.")
        return {"id": row["id"], "nome": row["display_name"]}

    # -- sessoes -----------------------------------------------------------
    def abrir_sessao(self, conta_id):
        token = novo_token()
        agora = agora_ms()
        with self._lock:
            self._conn.execute(
                "INSERT INTO sessoes (token, conta_id, criada_em, expira_em)"
                " VALUES (?, ?, ?, ?)",
                (token, conta_id, agora, agora + self.duracao * 1000),
            )
            self._conn.commit()
        return token

    def revogar_sessao(self, token):
        with self._lock:
            cur = self._conn.execute(
                "DELETE FROM sessoes WHERE token = ?", (token,))
            self._conn.commit()
        return cur.rowcount > 0

    def revogar_todas(self, conta_id):
        with self._lock:
            self._conn.execute(
                "DELETE FROM sessoes WHERE conta_id = ?", (conta_id,))
            self._conn.commit()

    def sessao_de(self, token, conta_esperada=None):
        """Sessao valida -> {conta_id, nome, expira_em}.

        Recusa token invalido/expirado/revogado. Se `conta_esperada` vier
        (nome ou chave), a sessao TEM de pertencer a essa conta: usar o token
        da conta A para pedir a conta B e recusado.
        """
        if not token_valido(token):
            raise ErroConta("sessao_invalida", "Sessao invalida.")
        with self._lock:
            row = self._conn.execute(
                "SELECT s.conta_id, s.expira_em, c.display_name, c.nome"
                " FROM sessoes s JOIN contas c ON c.id = s.conta_id"
                " WHERE s.token = ?", (token,)).fetchone()
            if row is None:
                raise ErroConta("sessao_invalida", "Sessao invalida.")
            if row["expira_em"] < agora_ms():
                self._conn.execute("DELETE FROM sessoes WHERE token = ?", (token,))
                self._conn.commit()
                raise ErroConta("sessao_expirada", "Sessao expirada.")
        if conta_esperada:
            esperada = normalizar_nome(conta_esperada)
            if esperada != row["nome"]:
                raise ErroConta("sessao_de_outra_conta",
                                "Sessao nao pertence a esta conta.")
        return {"conta_id": row["conta_id"], "nome": row["display_name"]}

    # -- perfis ------------------------------------------------------------
    def _proximo_user_id(self):
        row = self._conn.execute("SELECT COALESCE(MAX(user_id), 0) + 1 AS n FROM perfis").fetchone()
        return row["n"]

    def _garantir_perfil(self, conta_id, nome):
        row = self._conn.execute(
            "SELECT * FROM perfis WHERE conta_id = ?", (conta_id,)).fetchone()
        if row is not None:
            return dict(row)
        self._conn.execute(
            "INSERT INTO perfis (conta_id, user_id, user_name, criada_em)"
            " VALUES (?, ?, ?, ?)",
            (conta_id, self._proximo_user_id(), self.apelido_livre(nome, conta_id), agora_ms()),
        )
        self._conn.commit()
        row = self._conn.execute(
            "SELECT * FROM perfis WHERE conta_id = ?", (conta_id,)).fetchone()
        return dict(row)

    def perfil(self, conta_id):
        """Perfil de jogo da conta; cria na primeira vez (progresso preservado)."""
        with self._lock:
            return self._garantir_perfil(
                conta_id, self._nome_exibicao(conta_id))

    def _nome_exibicao(self, conta_id):
        row = self._conn.execute(
            "SELECT display_name FROM contas WHERE id = ?", (conta_id,)).fetchone()
        return row["display_name"] if row else "Jogador"

    def definir_apelido(self, conta_id, apelido):
        """Grava o nome do PERSONAGEM escolhido na criacao (register, C2S 9).

        Fica em perfis.user_name, que e o campo que o login_init envia como
        user_name (token 18). Assim o jogador reencontra o proprio
        personagem ao voltar, e o nome continua sendo por conta.
        Nao mexe no nome da conta/login.
        """
        apelido = (apelido or "").strip()
        if not 1 <= len(apelido) <= 20:
            raise ErroConta("apelido_invalido",
                            "O nome do personagem precisa ter 1 a 20 caracteres.")
        with self._lock:
            # Nome de personagem e unico no servidor (sem diferenciar
            # maiusculas), como em qualquer servidor com varios jogadores.
            if self.apelido_em_uso(apelido, conta_id):
                raise ErroConta("nome_em_uso", "Esse nome de personagem ja esta em uso.")
            self._conn.execute(
                "UPDATE perfis SET user_name = ? WHERE conta_id = ?",
                (apelido, conta_id))
            self._conn.commit()
        return apelido

    def apelido_em_uso(self, apelido, exceto_conta=None):
        with self._lock:
            row = self._conn.execute(
                "SELECT 1 FROM perfis WHERE lower(user_name) = lower(?) AND conta_id IS NOT ?",
                (apelido.strip(), exceto_conta)).fetchone()
        return row is not None

    def apelido_livre(self, base, exceto_conta=None):
        """base, ou base com o menor numero que o torna unico (ate 20 chars)."""
        base = (base or "").strip()[:20] or "Ninja"
        if not self.apelido_em_uso(base, exceto_conta):
            return base
        for n in range(2, 100000):
            sufixo = str(n)
            candidato = base[:20 - len(sufixo)] + sufixo
            if not self.apelido_em_uso(candidato, exceto_conta):
                return candidato
        raise ErroConta("nome_em_uso", "Nao ha nome livre para esse personagem.")

    def total_contas(self):
        with self._lock:
            return self._conn.execute("SELECT COUNT(*) AS n FROM contas").fetchone()["n"]


def abrir_banco_padrao():
    """Banco no disco E:, fora dos recursos originais do jogo."""
    base = os.environ.get("NR_ACCOUNTS_DIR")
    if not base:
        aqui = os.path.dirname(os.path.abspath(__file__))
        base = os.path.abspath(os.path.join(aqui, os.pardir, "dados"))
    os.makedirs(base, exist_ok=True)
    return Banco(os.path.join(base, "contas.sqlite3"))
