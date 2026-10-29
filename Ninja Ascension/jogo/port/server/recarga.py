"""recarga.py — recarrega os modulos de regra SEM reiniciar o servidor.

Por que existe: cada ajuste de protocolo exigia matar o servidor e reabrir o
jogo, e qualquer coisa que derrubasse a conexao derrubava tambem a sessao em
memoria (o login tinha de ser refeito do zero). Aqui a recarga troca apenas a
logica dos comandos; a conexao SQLite, as sessoes abertas e o socket
continuam vivos. Depois de recarregar, basta relogar no jogo.

O que NAO e recarregado, de proposito:
  * contas.py  — guarda a conexao SQLite e o cache de sessoes;
  * local_server.py — dono do socket e da tabela de despacho.

Os modulos de regra registram seus handlers em `MINIMOS`; ao recarregar, cada
um re-registra por cima do antigo. Se um modulo novo falhar ao carregar, a
recarga e revertida e o servidor continua funcionando com o codigo anterior.
"""
import importlib
import os
import sys
import traceback

# Modulos de REGRA: seguros de recarregar (nao guardam conexao nem sessao).
# Ordem importa para a mensagem de erro, nao para o resultado.
# Modulos de REGRA: seguros de recarregar (nao guardam conexao nem sessao).
# A lista `COMANDOS` diz exatamente quais chaves cada um registra — e so essas
# sao removidas antes de recarregar. Assim os comandos do proprio servidor
# (local_server.py) nunca somem do despacho.
COMANDOS = {
    'achievements_local': ['draw_achievement_reward'],
    'mythical_local': ['magical_animals_activate','magical_animals_advance_star','magical_animals_forging','magical_animals_steps_rebirth','magical_animals_relevant_active','magical_animals_set_skill','magical_animals_set_skill_release_method','magical_animals_activate_fate','magical_animals_activate_get_fate_task_reward'],
    'saga_local': ['biographies_activate','biographies_advance','biographies_rebirth','biographies_mark_synthesis','biographies_buy_prop','biographies_draw','biographies_get_extra_reward','biographies_achieve_activate','biographies_rank'],
    'constellation_local': ['constellation_buy','constellation_exchange'],
    'artifact_local': ['artifact_unlock','artifact_culture','artifact_confirm'],
    'mudra_local': ['ship_metal_set','ship_metal_escalate','ship_metal_onekey_escalate','ship_metal_dissolve','draw_matrix_reward'],
    'index_local': ['user_card_info_activate','user_card_info_advance','user_card_info_rank'],
    'ninja_school_local': ['ship_talent_init','artifact_init','combine_ship_init','user_card_info_init','biographies_init','magical_animals_init','ship_spirit_init','ship_talent_level_up','ship_talent_reset','ship_spirit_level_up','ship_spirit_batch_level_up'],
    'hero_gates_local': ['mega_unblock','mega_level_up','mega_use_skill'],
    'hero_stats_local': [],
    'hero_development_local': [],
    'hero_level_local': [],
    'equipment_local': ['equipment_escalate'],
    'treasure_local': ['treasure_escalate','treasure_onekey_escalate'],
    'equipment_development_local': ['equipment_up_star','equipment_harden','equipment_harden_replace','equipment_harden_locking'],
    'hero_quality_local': [],
    'shop_special_local': ['arena_shop_init','glories_shop_init','union_shop_init','arena_shop_exchange','glories_shop_exchange','union_shop_exchange','shop_request_product_refresh'],
    'shop_local': ['ship_bounty','ship_batch_bounty','shop_frags_init','shop_frags_exchange','prop_sell'],
    'shop_general_local': ['secret_shop_init','secret_shop_exchange','secret_shop_refresh'],
    'normal_recruit': [],
    'profile_local': ['user_info_modify'],
    'online_reward_local': ['trigger_scene_surprise'],
    'energia': ['power_swallow', 'draw_endurance_init', 'get_web_recharge_state'],
    'formacao_pesadelo': ['get_hard_copy_user_formation'],
    'recruitment_local': ['new_recruitment_system', 'formation_change'],
    'hero_training_local': ['ship_grow_up','ship_escalate','ship_awaken','ship_skill_level_up','ship_skill_level_up_one_key','ship_soul_level_up'],
    'tutorial_synthesis': ['prop_compound'],
    'scene_rewards_local': ['draw_scene_rewad', 'one_key_draw_scene_reward'],
    # tutorial_campaign ENVOLVE handle_battle_result_start do local_server
    # (linha 98: original = server.MINIMOS[...]). A chave pertence ao
    # local_server, entao NAO pode ser removida aqui: o modulo se limita a
    # re-embrulhar a funcao original, que ja esta registrada.
    'tutorial_campaign': [],
    'ninja_trial_local': ['three_kingdoms_init', 'three_kingdoms_launch', 'three_kingdoms_draw_score_reward', 'three_kingdoms_sweep', 'dignified_shop_buy', 'unparallel_purchase'],
    'worldboss_local': ['rebel_army_init'],
    'purify_local': ['ship_purify_init'],
    'dados_batalha': [],
    'quest_local': ['daily_mission_init','draw_daily_mission_reward','draw_liveness_reward'],
}
MODULOS = list(COMANDOS)

# Handlers que vem dos modulos de regra. Ao recarregar, sao reescritos.
_PREFIXO_CHAVE = 'MINIMOS'


def _instantaneo(servidor):
    """Copia (modulo -> codigo em memoria) para poder voltar atras."""
    return dict(sys.modules)


def recarregar(servidor, modulo_de_registro='local_server'):
    """Recarrega MODULOS e re-registra os handlers. Devolve (ok, mensagens)."""
    mensagens = []
    # Guarda a tabela de despacho atual: se algo falhar, ela e restaurada.
    minimos_antes = dict(servidor.MINIMOS)
    modulos_antes = _instantaneo(servidor)
    removidos = []

    try:
        # 1) Esquece os modulos de regra para que o import leia o arquivo novo.
        for nome in MODULOS:
            if nome in sys.modules:
                del sys.modules[nome]
                removidos.append(nome)

        # 2) Remove APENAS as chaves dos modulos de regra. local_server.py
        #    registra dezenas de comandos proprios (battle_result_start,
        #    platform_user_login, education_change...) que NAO sao
        #    recarregados: apaga-los derrubava o despacho com KeyError.
        for chaves in COMANDOS.values():
            for chave in chaves:
                servidor.MINIMOS.pop(chave, None)

        # 3) Reimporta cada modulo e roda o install() dele.
        for nome in MODULOS:
            modulo = importlib.import_module(nome)
            mensagens.append('  carregado: %s' % nome)
            instalador = getattr(modulo, 'install', None)
            if callable(instalador):
                instalador(servidor)
                mensagens.append('    install() ok')

    except Exception:
        # Reverte: volta a tabela de despacho e descarta os modulos quebrados.
        servidor.MINIMOS.clear()
        servidor.MINIMOS.update(minimos_antes)
        for nome in list(sys.modules):
            if nome in MODULOS and nome not in modulos_antes:
                del sys.modules[nome]
        for nome in removidos:
            if nome in modulos_antes:
                sys.modules[nome] = modulos_antes[nome]
        detalhe = traceback.format_exc()
        mensagens.append('  ERRO ao recarregar — codigo ANTERIOR mantido no ar:')
        for linha in detalhe.rstrip().splitlines():
            mensagens.append('    ' + linha)
        return False, mensagens

    return True, mensagens


def arquivos_modificados(base):
    """Lista (nome, mtime) dos .py de regra, para mostrar o que mudou."""
    resultado = []
    pasta = os.path.dirname(os.path.abspath(base.__file__))
    for nome in MODULOS:
        caminho = os.path.join(pasta, nome + '.py')
        if os.path.exists(caminho):
            resultado.append((nome, os.path.getmtime(caminho)))
    return resultado
