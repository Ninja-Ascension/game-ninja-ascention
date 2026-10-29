# Proporção na cidade e lista Ninja

A resolução global continua EXACT_FIT. Somente os atores/ícones da cidade
e os cartões da lista Ninja compensam a diferença entre a escala horizontal
e vertical: fator X = (altura/640)/(largura/960). Isso mantém a proporção
física original, enquanto o cenário ocupa a área inteira.

Os cartões reais são `SmHeroSeatCell`, layout
`packs/HeroStorage/sm_list_generals_big.csb`, não HeroIconListCell. O ajuste
fica ativo quando HeroStorage/HeroListView está aberto e restaura a escala
base fora desse contexto. Redimensionar reaplica a escala sem acumular.

`Chat/chat_home_window.csb` fica invisível para ocultar a faixa compacta
preta. Não exclui mensagens nem o restante da interface de chat.

Validação: teste nativo do login, cartões originais, seis atores,
viewport completo e chat oculto em quatro formatos. Mochila, loja,
recrutamento e demais categorias mantêm o preenchimento anterior.
