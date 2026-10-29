# Janela larga, nome e traduções

## Nome

O handler `user_info_modify` estava apenas na recarga, não no startup.
Agora está instalado em ambos. Parser 12033 atualiza o cabeçalho e a
página aberta. `local_profile_edits` impede que um register repetido
substitua o nome editado. Teste privado verifica startup sem install manual,
persistência, login, register repetido e reabertura do banco.

## Janela larga

O modo final usa EXACT_FIT global no módulo `desktop_layout.lua`, pois
adaptar apenas a cidade deixava ninjas, mochila e loja com largura antiga.
Todas as cenas compartilham a mesma área lógica e transformação de toque.
As proporções se adaptam à janela. O módulo também centraliza as
camadas da cidade, expande o contêiner de fundo `Panel_animation`,
redistribui os atalhos e reduz seu tamanho a 85%. As seis posições de
atores usam escala uniforme 90% e distribuição centralizada. Redimensionar
reaplica os valores de base, sem acumular escala. O preenchimento global
também altera a proporção aparente de atores quando a janela muda de formato.

## Português

Primeira passagem nas mensagens de nome/assinatura e termos comuns.
As legendas retangulares adicionadas aos ícones e abas foram removidas a
pedido do usuário. Textos incorporados às imagens permanecem originais
até tradução própria dos assets. Não é tradução completa do conteúdo: outras
telas, descrições e texturas ainda precisam de revisão própria. Nomes de
personagens não foram traduzidos automaticamente.

## Validação

Build Debug recompilado. Teste nativo: três cenários de login, parser de
nome, controles promocionais ocultos, deslocamento em largura 1280,
identificação das seis posições e do fundo real. Não confirma acabamento
visual de todas as telas. Pedir nova captura maximizada ao avaliar o
resultado. Testes do perfil em `tools/test_profile_local.py`.

Também corrigido import inexistente `require('app')` no catálogo que
interrompia a etapa 6; usa o framework global já inicializado.

## Ajuste seguinte: atalhos inferiores

Os nove atalhos agora ocupam posições uniformes por centro de tela. A
conversão para o pai de cada botão evita sobrepor os dois atalhos finais,
que pertencem a grupos diferentes no CSB. Nenhuma caixa/legenda extra é
criada; visuais originais preservados.

Validação adicional: layouts originais de ninjas, mochila e loja criados
sem caixas extras. Área de viewport cobre a área cliente em 960x640,
1280x720, 1280x800 e 800x600, com origem zero e sem faixas. Três cenários
de login nativo aprovados após essa alteração.
