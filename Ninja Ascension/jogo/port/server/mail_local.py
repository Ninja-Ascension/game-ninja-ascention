"""Persistent player-to-player mailbox for the local server port."""
import re
import time


def schema(db):
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_mail (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        recipient_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        sent_at INTEGER NOT NULL,
        read_at INTEGER NOT NULL DEFAULT 0,
        deleted_sender INTEGER NOT NULL DEFAULT 0,
        deleted_recipient INTEGER NOT NULL DEFAULT 0
    )''')
    db._conn.execute('CREATE INDEX IF NOT EXISTS idx_local_mail_recipient ON local_mail(recipient_id, sent_at)')
    db._conn.execute('CREATE INDEX IF NOT EXISTS idx_local_mail_sender ON local_mail(sender_id, sent_at)')


def install(server):
    db=server.BANCO
    with db._lock,db._conn:
        schema(db)

    def request(seq,text,minimum,maximum=None):
        account=db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields=server._linhas(text)
        while fields and fields[-1]=='':fields.pop()
        if len(fields)<minimum or (maximum is not None and len(fields)>maximum):
            raise ValueError('pedido_de_email_invalido')
        profile=db.perfil(account)
        if fields[0]!=str(profile['user_id']):raise ValueError('perfil_invalido')
        return account,fields

    def profile(account):
        row=db._conn.execute('''SELECT p.user_name, COALESCE(c.grade,1), COALESCE(v.grade,0)
            FROM perfis p LEFT JOIN local_campaign c ON c.conta_id=p.conta_id
            LEFT JOIN local_vip v ON v.conta_id=p.conta_id WHERE p.conta_id=?''',(account,)).fetchone()
        return (row[0],int(row[1]),int(row[2])) if row else ('-',1,0)

    def mail_init(seq,text):
        try:
            account,fields=request(seq,text,1,1)
            unread=db._conn.execute('SELECT count(*) FROM local_mail WHERE recipient_id=? AND deleted_recipient=0 AND read_at=0',(account,)).fetchone()[0]
            return ' '.join([str(seq),'email_init','0','201',str(unread),'202','0'])
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('email_init',seq,str(exc))

    def get_mail(seq,text):
        try:
            account,fields=request(seq,text,1,1)
            rows=db._conn.execute('''SELECT id,sender_id,recipient_id,title,body,sent_at,read_at
                FROM local_mail WHERE (recipient_id=? AND deleted_recipient=0)
                   OR (sender_id=? AND deleted_sender=0) ORDER BY sent_at DESC,id DESC LIMIT 200''',(account,account)).fetchall()
            out=[str(seq),'get_user_mail','0','12800',str(len(rows))]
            for ident,sender,recipient,title,body,sent,read_at in rows:
                box=0 if recipient==account else 1
                other=sender if box==0 else recipient
                name,level,vip=profile(other)
                out += [str(ident),'0','0','0',title,body,'0','|',str(sent),str(box),name,str(level),str(vip),str(1 if read_at else 0)]
            return ' '.join(out)
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('get_user_mail',seq,str(exc))

    def send_mail(seq,text):
        try:
            account,fields=request(seq,text,6,6)
            recipient_name,title,body=fields[1],fields[2],fields[3]
            if not re.fullmatch(r'[A-Za-z0-9_.-]{3,20}',recipient_name):raise ValueError('destinatario_invalido')
            if not title or len(title)>80 or not body or len(body)>1000:raise ValueError('email_vazio_ou_muito_longo')
            if any(x in title+body for x in ('\r','\n','|')):raise ValueError('conteudo_de_email_invalido')
            target=db._conn.execute('SELECT conta_id FROM perfis WHERE lower(user_name)=lower(?)',(recipient_name,)).fetchone()
            if not target:raise ValueError('destinatario_nao_encontrado')
            with db._lock,db._conn:
                db._conn.execute('INSERT INTO local_mail(sender_id,recipient_id,title,body,sent_at) VALUES (?,?,?,?,?)',
                                 (account,int(target[0]),title,body,int(time.time()*1000)))
            return ' '.join([str(seq),'user_send_mail','0'])
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('user_send_mail',seq,str(exc))

    def read_mail(seq,text):
        try:
            account,fields=request(seq,text,3,3);ident=int(fields[1]);box=int(fields[2])
            if box not in (0,1):raise ValueError('caixa_de_email_invalida')
            column='recipient_id' if box==0 else 'sender_id'
            deleted='deleted_recipient' if box==0 else 'deleted_sender'
            with db._lock,db._conn:
                cur=db._conn.execute('UPDATE local_mail SET read_at=CASE WHEN read_at=0 THEN ? ELSE read_at END WHERE id=? AND '+column+'=? AND '+deleted+'=0',(int(time.time()*1000),ident,account))
                if cur.rowcount!=1:raise ValueError('email_nao_encontrado')
            return ' '.join([str(seq),'user_read_mail','0'])
        except (server._contas.ErroConta,ValueError) as exc:return server.recusa('user_read_mail',seq,str(exc))

    def read_all(seq,text):
        try:
            account,fields=request(seq,text,2,2);box=int(fields[1])
            if box not in (0,1):raise ValueError('caixa_de_email_invalida')
            column='recipient_id' if box==0 else 'sender_id'
            deleted='deleted_recipient' if box==0 else 'deleted_sender'
            if box==0:
                with db._lock,db._conn:db._conn.execute('UPDATE local_mail SET read_at=CASE WHEN read_at=0 THEN ? ELSE read_at END WHERE '+column+'=? AND '+deleted+'=0',(int(time.time()*1000),account))
            return ' '.join([str(seq),'one_key_read_mail','0'])
        except (server._contas.ErroConta,ValueError) as exc:return server.recusa('one_key_read_mail',seq,str(exc))

    def delete_mail(seq,text):
        try:
            account,fields=request(seq,text,2,2);ident=int(fields[1])
            with db._lock,db._conn:
                row=db._conn.execute('SELECT sender_id,recipient_id,read_at FROM local_mail WHERE id=?',(ident,)).fetchone()
                if not row:raise ValueError('email_nao_encontrado')
                sender,recipient,read_at=row
                if recipient==account:
                    box=0;db._conn.execute('UPDATE local_mail SET deleted_recipient=1 WHERE id=?',(ident,))
                elif sender==account:
                    box=1;db._conn.execute('UPDATE local_mail SET deleted_sender=1 WHERE id=?',(ident,))
                else:raise ValueError('email_nao_pertence_a_conta')
            return ' '.join([str(seq),'delete_mail','0','12801',str(ident),'0',str(box),str(1 if read_at else 0)])
        except (server._contas.ErroConta,ValueError) as exc:return server.recusa('delete_mail',seq,str(exc))

    def delete_all(seq,text):
        try:
            account,fields=request(seq,text,2,2)
            box=int(fields[1])
            if box not in (0,1):raise ValueError('caixa_de_email_invalida')
            with db._lock,db._conn:
                if box==0:
                    db._conn.execute('UPDATE local_mail SET deleted_recipient=1 WHERE recipient_id=?',(account,))
                else:
                    db._conn.execute('UPDATE local_mail SET deleted_sender=1 WHERE sender_id=?',(account,))
            return ' '.join([str(seq),'delete_all_mail','0'])
        except (server._contas.ErroConta,ValueError) as exc:return server.recusa('delete_all_mail',seq,str(exc))

    def no_attachment(seq,text):
        # This local mailbox stores player messages only; it never represents
        # an attached reward as collected. Acknowledge no item as claimed.
        return server.recusa('draw_attachment_in_mail',seq,'email_sem_anexo')

    def no_attachments(seq,text):
        return server.recusa('one_key_draw_attachment_in_mail',seq,'email_sem_anexo')

    server.MINIMOS.update({
        'email_init':mail_init,'get_user_mail':get_mail,'user_send_mail':send_mail,
        'user_read_mail':read_mail,'one_key_read_mail':read_all,'delete_mail':delete_mail,
        'delete_all_mail':delete_all,
        'draw_attachment_in_mail':no_attachment,
        'one_key_draw_attachment_in_mail':no_attachments,
    })
