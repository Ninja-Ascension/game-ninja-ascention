# Dano persistente: instalação tardia dos callbacks

As adaptações numeros_flutuantes e painel_de_dano alteravam
setFrameEventCallFunc DEPOIS da execução de drawAntNumber e
onEnterTransitionFinish. Nesses métodos originais os callbacks já eram
registrados. Alterar o método posteriormente não altera o callback nativo
já armazenado. Os contratos antigos armavam antes de registrar e não
reproduziam a ordem usada na integração.

Agora a criação das timelines é interceptada apenas durante cada método
original e apenas para os arquivos correspondentes. A tradução de eventos
é instalada antes do registro original. A fábrica é restaurada também
quando ocorre exceção. Os valores reais e as condições de combate são
preservados. O frame é restaurado mesmo se seu callback lançar erro.

Validação em 25/10/2026:

- tools/test_damage_hooks.py: ambos os lados, registro dentro do método
  original, tradução de eventos, retornos e restauração após exceção.
- tools/test_layout_editor.py: sete casos com saída zero; resultados em
  build/layout-tests-ec3f4508c58342a59421b9b187312b2d/results.json.

Limite: não foi validada uma interação humana completa na batalha atual.
O painel Total DMG de FightQTEController é distinto de DrawHitDamage;
permanecer visível pode ser consequência de o ataque ainda não terminar.
O gesto de habilidade no tutorial deve ser verificado no retrato do Naruto,
pressionando e arrastando para cima. Não foi aplicado desbloqueio forçado.

Reiniciar o processo do jogo é necessário para carregar os módulos novos.
