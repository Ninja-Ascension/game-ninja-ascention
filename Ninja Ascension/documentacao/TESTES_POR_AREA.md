# Testes por área — estado aplicado em 25/10/2026

Recomeçar a sequência de testes, mantendo a conta atual (56 / personagem 5).
Não apagar banco, personagens nem tutorial. Ryo conferido: 10.000.000.

## Atualização aplicada

- formation_change aceita os cinco campos reais enviados pela interface,
  preservando a variante antiga. Antes a quantidade de campos causava recusa
  “ninja_nao_possuido”, mesmo para personagens existentes.
- Seis posições salvas separadamente; inclusões não substituem toda a formação.
  Trocar posições, substituir, retirar e relogar preservam os demais ninjas.
- Indicadores “+” permanecem nas posições vazias até preencher as seis.
  Ter apenas personagens já escalados não apaga mais os indicadores vazios.
- Login inclui o parser original 471 para coleção/limite de cartas combo;
  corrige user_comb_can_filed_mould_num nil na lista de ninjas.
- IDs dos sintetizados migrados para namespace separado. O antigo molde 1
  colidia com a Sakura garantida. Todos os 30 ninjas da conta foram preservados
  e os IDs agora são distintos. Reabrir o jogo descarta referências antigas.
- FightObject não tenta decodificar JSON inexistente quando um personagem
  não tem registro opcional de mega-evolução. A batalha ainda exige teste real.

## Assets

`tools/audit_assets.py` catalogou 38.547 arquivos em res, incluindo 753 retratos.
Manifesto: `build/assets-audit.json`. A engine continua usando os caminhos
originais e carregando texturas conforme a tela precisa delas; não colocar
38 mil recursos simultaneamente na GPU.

Uma página ausente: res/sprite/sprite_fudan.atlas referencia sprite_fudan2.png,
que não foi encontrada no acervo consultado. Não substituir por imagem
inventada ou por outra página sem conferir as regiões e dimensões.
O catálogo NÃO prova que toda animação, retrato ou tela foi validada visualmente.

## Ordem dos testes com o usuário

1. **Lista de ninjas e formação (AGORA).** Reabrir e entrar na mesma conta.
   Conferir retratos, nomes, Ryo e ninjas. Adicionar até seis personagens
   distintos, conferir “+” em cada vaga restante. Trocar dois de lugar,
   retirar um, recolocar e relogar. Esperado: mesma formação, sem erros.
2. **Perfil e retratos.** Testar seleção/alteração de retrato, salvamento e
   retorno ao jogo. Conferir arquivo real e propriedade/desbloqueio.
3. **Melhoria.** Qualidade, materiais, consumo e persistência. Estrelas ainda
   precisam de implementação; não declarar todas as evoluções concluídas.
4. **Mapa e recompensas.** Conferir missões disponíveis, NPC correto, estrelas,
   baú e recebimento único. draw_scene_rewad foi implementado depois desta
   revisão para moedas/itens; consultar CORRECAO_FASES_BAU_SAKURA.md.
5. **Combate.** Conferir os seis ninjas, inimigos, ataques, TAP/Secret Jutsu,
   sincronização, efeitos, dano desaparecendo e retorno ao mapa.
6. **Tutorial.** Percorrer os grupos restantes de mission3 sem ACK vazio;
   testar fechar/reabrir em cada etapa sem repetir aquisição ou consumir duas vezes.
7. **Menu normal.** Confirmar fim do guia e liberação das missões normais.

Não avançar afirmando que uma área está validada só porque o parser passou.
Registrar o primeiro erro real que o usuário apresentar e corrigir por área.

## Evidência técnica da atualização

- tools/test_formation_slots.py: passou, seis ninjas, cinco campos, troca,
  remoção, propriedade, posições inválidas e persistência.
- tools/test_damage_hooks.py: passou, incluindo indicadores de vagas vazias.
- build/formation-six-native.log: FORMATION_SIX_NATIVE_PASSED, parser original,
  seis ninjas distintos, resposta de formação e limite de cartas combo.
- tools/test_tutorial_synthesis.py: passou com IDs novos.
- tools/test_saved_profiles.py: cinco contas passaram novamente no executável,
  em cópia privada; banco do jogador preservado.
- Banco ativo: integridade ok, 30 personagens distintos na conta 56.

Servidor atualizado. Fechar e reabrir o jogo é necessário para carregar as
alterações Lua, limpar o estado anterior de erro e atualizar IDs em memória.
