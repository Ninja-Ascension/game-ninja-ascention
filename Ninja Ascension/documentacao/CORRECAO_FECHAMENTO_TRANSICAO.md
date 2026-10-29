# Fechamento e Total DMG na transição — 25/10/2026

Evidência: build/probe-writable/falha-nativa.txt foi atualizado às 01:50:31,
com código 0xc0000005 em ComponentContainer::isEmpty, chamado por
Node::update:1647 após a execução do callback Lua. Esse caminho permite
que a janela seja removida e destruída antes de Node::update concluir.

Proteção implementada no port, sem alterar o fonte da engine: a ponte
cc.nrKeepAliveFrame faz retain/autorelease pareados antes do onUpdate
da janela. A liberação ocorre no esvaziamento do pool ao final do quadro,
após o retorno à engine. window_update_lifetime.lua instala a proteção nos
registros de atualização de fwin e Window via battle_lifecycle.lua.

Não foram apagados caches. As texturas usadas pelo renderer Spine já são
retidas por atlas/sprites; mensagens de remoção de texturas não utilizadas
não comprovam corrupção do cache.

O Total DMG de FightQTEController é limpo com a API original, passando 0,
depois do encerramento de FightTeamController.teamFightEnd. Isso para a
ação correspondente, zera o acumulador e oculta seu painel. É diferente
dos números flutuantes e do DrawHitDamage.

tools/test_damage_hooks.py verifica que a proteção precede o callback e
que a conclusão da habilidade limpa o acumulador do painel. A reprodução
completa da transição humana é necessária para confirmar que a falha
nativa observada não volta a ocorrer. O atraso visual permanece separado.
