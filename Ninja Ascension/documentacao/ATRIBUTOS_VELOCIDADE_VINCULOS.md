# Atributos, velocidade e vínculos

Regras confirmadas pelo jogador: +5 de velocidade por passo de Advance e +20 por estrela ganha por Promote. Nível comum não dá velocidade. O cálculo parte dos estados salvos e desconta avanço/estrelas iniciais do molde, portanto é retroativo e não acumula ao reconectar. Melhorias antigas não são cobradas novamente.

## Fontes e reconstrução

- res/data/configs/fight_config.txt, linhas 1–4: coeficientes A/B para bônus base por estrela/qualidade e C/D para crescimento.
- ship_mould: atributos iniciais e crescimento de cada ninja.
- fate_relationship_mould: requisitos e percentuais de HP, ataque, defesa física e defesa de habilidades.
- ship_soul_addition_property_param: atributos anteriores à batalha dos selos desbloqueados. Atributos 0–3 entram na ficha; outros são enviados em property_values para o avaliador nativo, preservando os talentos durante a batalha.

A equação reconstruída no servidor local é: atributo inicial + crescimento × [A(estrela) + B(Advance) + (nível−1) × (1+C(estrela)+D(Advance))]. Os coeficientes são do acervo; a equação é uma reconstrução local a partir do significado das colunas, não uma reprodução verificada do servidor oficial indisponível.

Vínculos de personagens ativam quando todos os ninjas exatos exigidos estão na coleção, conforme a identificação de molde usada pelo cliente. Bônus percentuais ativos são somados antes da aplicação. Vínculos de equipamento continuam inativos enquanto o item exigido não puder ser comprovado como equipado; possuir um item na mochila não ativa esse vínculo. Não se declara implementado o balanceamento completo de todas as armas, skins e sistemas online.

## Consistência

A mesma fonte calcula login, atualização das abas e dados da batalha (HP máximo e iniciativa). O cliente atualiza poder individual e da formação depois do pacote completo. A velocidade total segue o agregado da coleção indicado pela rotina original getUserSpeedSum; não é derivada do ID da conta. O parser original 12042 atualiza a velocidade e mantém seus registros de integridade.

Os snapshots de atributos validam o histórico anterior e renovam o registro criptografado após a atualização legítima do servidor. No login completo, a velocidade anterior é validada antes de iniciar o histórico do novo perfil. A verificação não foi desativada.

A janela de aumento de poder usa uma mensagem breve se o CSB recuperado não contém o root original.

## Verificação

- tools/test_hero_stats_local.py: Advance +5, Promote +20, ausência de velocidade por nível, ganho de atributos, vínculos, repetição de pedidos e valores enviados à batalha.
- tools/test_hero_stats_native.py: poder crescente, snapshots repetidos sem bônus duplicado, novo login, integridade, iniciativa da batalha e janela de poder.
- Regressões de nível e avanço: test_hero_level_local.py, test_hero_level_native.py e test_quality_battle_native.py.
