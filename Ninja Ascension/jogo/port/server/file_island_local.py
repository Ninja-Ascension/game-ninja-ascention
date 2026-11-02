"""Empty local social-task state required by the File Island parser."""
import json


EMPTY_TASK_STATE = {
    'mySingleTaskInfo': [],
    'myJoinTaskInfo': [],
    'myMultiTaskInfo': [],
    'friendMultiTaskInfo': [],
    'joinFriendTaskCount': 0,
    'finishFriendTaskCount': 0,
}


def install(server):
    def info(seq, text):
        try:
            fields = server._linhas(text)
            session = server.BANCO.sessao_de(server._sessao_da_conexao())
            user_id = str(server.BANCO.perfil(session['conta_id'])['user_id'])
            if not fields or fields[0].strip() != user_id:
                raise ValueError('perfil_invalido')
            payload = json.dumps(EMPTY_TASK_STATE, separators=(',', ':'))
            return ' '.join((str(seq), 'file_island_task_info', '0', '12573', payload))
        except (server._contas.ErroConta, ValueError, KeyError, IndexError) as exc:
            return server.recusa('file_island_task_info', seq,
                                 str(exc) or 'perfil_invalido')

    server.MINIMOS['file_island_task_info'] = info
