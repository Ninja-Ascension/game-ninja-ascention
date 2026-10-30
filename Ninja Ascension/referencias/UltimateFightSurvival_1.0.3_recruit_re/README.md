# Extração do Recruit — Ultimate Fight Survival 1.0.3

Esta pasta contém somente a seleção de scripts, layouts, tabelas e recursos visuais do Recruit necessários para análise. O APK original permanece intacto em `distribuicao/Ultimate+Fight_Survival_1.0.3_APKPure.apk`; não foi executado nem copiado para esta pasta.

## Conteúdo

Os arquivos recuperados estão em `extraido/firecracker/`, mantendo os caminhos internos originais. O lote contém os módulos Lua do Recruit, os layouts CSB relacionados, dados de recrutamento, sprites/animações e imagens alcançados a partir das referências desses módulos e layouts. `manifesto_recruit.json` registra tamanho e SHA-256 por arquivo.

## Como foi decodificado

O APK contém o índice `Horrycation.txt`, que associa os caminhos originais aos nomes embaralhados. Os recursos protegidos usam um cabeçalho próprio seguido de Blowfish em modo ECB e conteúdo zlib. A rotina lê a chave necessária diretamente do APK em memória; ela não é gravada nesta pasta nem exibida no log. Fontes TTF que já estavam em formato aberto foram copiadas após validar a assinatura.

`ExtrairRecruit.java` documenta e reproduz a extração seletiva. Ele não extrai o restante do APK.

## Limitações observadas

- O APK não contém algumas referências nomeadas pelo layout, incluindo `chaozhi.png`, `lhm_zhaoyici.png` e `zhaoshici.png`; elas não foram substituídas por imagens inventadas.
- Há outras referências não resolvidas registradas no manifesto. `effect_hjcqcq.png` tem mais de um caminho possível no índice; a imagem indicada pelo atlas do efeito foi extraída, mas a ambiguidade de caminho permanece documentada.
- Os layouts CSB foram recuperados como binários originais. Não foram convertidos para JSON nem testados dentro de outra engine.
- Esta entrega é uma extração de referência: não foi integrada ao Ninja Ascension, não altera cliente, servidor ou banco e não foi testada em jogo. Os Lua foram verificados como texto UTF-8 não vazio; não havia `lua`/`luac` CLI disponível para compilá-los.
