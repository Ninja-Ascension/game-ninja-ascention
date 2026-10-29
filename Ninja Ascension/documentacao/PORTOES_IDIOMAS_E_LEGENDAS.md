# Portões, pacotes de idioma e legendas dos ninjas

## Portões

Implementados mega_unblock, mega_level_up e mega_use_skill, com estado por conta/ninja, custos transacionais e recibos contra pedidos duplicados. O login e as respostas atualizam megaLevel/megaUse; os bônus de HP/ATK/defesa das páginas 1/3/5/7 entram na mesma ficha de atributos usada pelo poder e pela batalha.

As fontes são mega_unblock, mega_expend, mega_property e mega_ship do acervo. O primeiro Portão foi validado do desbloqueio ao nível 10. O cliente verifica requisitos antes de enviar o pedido; o servidor verifica novamente. Ícones que recebiam atualizações antes de criar seus widgets agora aplicam o desenho pendente ao entrar.

Limitação concreta: requisitos de estrelas de equipamento e ligas (tipos 5/6/9) ainda não têm estado correspondente implementado no servidor. Eles permanecem bloqueados, sem desbloqueio fictício. Custos especiais de equipamentos e materiais dos tipos 4/5/6/7 também retornam erro explícito. Assim, isto não conclui todos os oito Portões; os estágios que dependem desses sistemas precisam de implementação posterior. As habilidades dos Portões 2/4/6 possuem comando de seleção/cancelamento persistente quando estiverem legitimamente liberadas.

## Traduções

A restauração dos caminhos do executável substituía a lista de busca e perdia a prioridade de res/language. language_assets_local recoloca primeiro o idioma escolhido (por exemplo pt_BR), depois comun e depois os recursos base. TipStringInfo, imagens e CSBs traduzidos existentes passam a ser usados. Trocar o idioma refaz a prioridade e carrega a tabela original correspondente. Recursos sem versão no pacote usam a base; não foi criada uma tradução fictícia de textos ausentes.

## Nomes e estrelas

As legendas da tela inicial têm largura limitada, fonte menor, centralização e contorno; nomes na borda são mantidos dentro da área do layout. As estrelas são redesenhadas a partir de StarRating salvo, com escala e espaçamento uniformes. Nenhum nível, personagem ou estrela da conta foi alterado por este ajuste visual.

## Testes

- test_hero_gates_local.py: desbloqueio, dez melhorias, custos, repetição sem cobrança, limite e requisitos.
- test_gates_language_native.py: telas reais dos Portões, progresso do login, pacotes PT/ES, widgets de nomes e quantidade de estrelas.
- Regressões: test_hero_development_local.py, test_hero_development_native.py e test_quality_battle_native.py.

## Revisão visual solicitada

Estrelas voltaram ao renderizador original neWshowShipStar (sprites, tamanho e espaçamento originais). A legenda fica ancorada ao centro do ator, elevada sem acumular deslocamento; nome, nível e ícone ocupam áreas separadas. Fonte do nome: 14; nível usa o formato do idioma original. Não houve alteração na conta ou nos valores de estrelas.
