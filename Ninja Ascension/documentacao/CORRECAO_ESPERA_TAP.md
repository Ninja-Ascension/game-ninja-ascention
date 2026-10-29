# Espera por TAP no tutorial — 25/10/2026

O código original de FightTeamController encerra a etapa tanto pelo evento
`end` da timeline como pelo botão TAP, que chama skeepTeamFight. Portanto
o término automático podia liberar a fila antes da interação esperada.

port/lua/tutorial_tap_wait.lua mantém o encerramento aguardando o botão
durante missões do tutorial e habilidades do lado aliado. Enquanto essa
espera existe, qteToAutoNextAttackRole não escolhe outro atacante. O botão
continua executando skeepTeamFight original, incluindo os trechos de dano
pendentes, e libera teamFightEnd. Não há alteração dos valores de dano,
energia, animações ou resultado da batalha.

A instalação acompanha app.load em battle_lifecycle.lua para ocorrer antes
da cópia dos métodos para os peers nativos. A mudança exige reiniciar o jogo.

tools/test_damage_hooks.py verifica espera antes do TAP, retomada pelo botão,
seleção automática bloqueada, batalhas normais e habilidades inimigas.
tools/test_battle_lifecycle.py também passou.

Limite: a reprodução humana da sequência Sakura → Sasuke → TAP → Naruto
ainda precisa ser confirmada. Se continuar diferente, registrar vídeo desde
antes da habilidade do Sasuke até o bloqueio, incluindo a tentativa de TAP.

## Proteção contra avanço forçado

O trecho fornecido pelo usuário registra FURY_GUARD asalto pasado 201060 1 4.
Mission.lua:3888 chama furyGuardRelease, que limpa o estado da missão,
desbloqueia o combate e solicita qte_to_auto_next_attack_role. Essa rotina
de recuperação pode desfazer a espera por interação.

O port agora impede furyGuardTick durante a introdução identificada por
NPC 1196, nível 1 e experiência 0, ou durante uma espera ativa por TAP.
A espera por TAP usa também essa identificação persistente: missionIsOver
pode retornar true entre instruções sem a batalha introdutória ter terminado.
O watchdog das demais batalhas continua com o comportamento original.

O teste de regressão cobre a transição entre instruções, o bloqueio do
watchdog na introdução e sua manutenção fora dela. A execução humana
completa e a causa do atraso visual ainda não foram comprovadas.
