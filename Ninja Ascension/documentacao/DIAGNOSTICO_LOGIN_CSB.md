# Diagnóstico: por que o GAME START não chega ao menu

Estado em 2026-10-24. Este documento existe porque a causa NÃO é o sistema de
contas, e sim o carregamento do layout do login.

## Resumo

A árvore do CSB **está íntegra**. A causa é o **nome gravado no layout**:
o Cocos Studio salva cada widget com o sufixo de `actionTag`, por exemplo
`"Label_server_name*11"`, enquanto o código do acervo procura
`"Label_server_name"` (`login.lua:1605`, `2041`, ...). A busca direta por
nome nunca casa.

Prova no JSON decodificado (`05_layouts_cocos_json/.../login.json`, posição
15086):

```json
"widgetOptions": {
  "name": "Label_server_name*11",
  "actionTag": 393,
  ...
```

E no runtime, com a correção aplicada, `Label_server_name` **saiu** da lista
de widgets não encontrados — antes ela aparecia:

```
BOOT_MAP_DUMP ipairs=5 getChildrenCount=5 rootName='root'
    nomes=Panel_368_pr2,Panel_change_language_pr1,Image_2,
          Button_gonggao_pr1,Button_antiaddction_pr1
```

### Correção de um diagnóstico meu, errado

Numa rodada anterior eu concluí que "a árvore vinha vazia" porque
`filhos:size()` dava erro. Era **erro meu de instrumentação**: no Axmol
`getChildren()` devolve uma tabela iterável por `ipairs` (é assim que
`ResourceProbe.cpp:47-52` percorre), e `:size()` simplesmente não está nos
bindings. Corrigido o diagnóstico: a árvore tem os 5 filhos e os nomes certos.
Isso está registrado aqui porque a conclusão anterior, se ficasse, mandaria
alguém converter formato de arquivo sem necessidade.

## Cadeia de erros que escondia isso

Cada erro abaixo abortava `Login:onEnterTransitionFinish` no meio, e como o
Lua não tem `pcall` nesse caminho, o resto da função nunca rodava. Como
`state_machine.add(...)` dos terminais do login está nas linhas 1206-1218
(executadas no `ctor`), o resultado era: janela de conta funcionando, login
funcionando, servidor respondendo — e GAME START sem efeito nenhum.

| # | Erro observado no console | Correção (em `port/`) |
|---|---|---|
| 1 | `AudioUtil.lua:69 attempt to index field 'SimpleAudioEngine' (a nil value)` | **corrigido**: `cc.SimpleAudioEngine` inerte em `boot_map.lua` (stage 0c) |
| 2 | `login.lua:1555 attempt to index local 'Button_gonggao'` | **corrigido**: o CSB tem `Button_gonggao_pr1`; alias em `seekWidgetByName` |
| 3 | `boot_map.lua:260 seekWidgetByName has wrong number of arguments` | **corrigido**: o método é `(self, root, nome)`; wrapper aceita as duas formas |
| 4 | `login.lua:1610 attempt to index local 'serverNameLabel'` | **em andamento**: sufixo `*tag` nos nomes (busca por `nome*0..300` já resolve `Label_server_name`) |
| 5 | `GameAnnouncement.lua:247 Shader compile failed` | **corrigido**: servidor não pede anúncio (sentinela 999) |

## Estado exato desta rodada

`Label_server_name` passou a ser encontrado pela busca com sufixo, mas o
`login.lua:1610` ainda falha — porque usa `self.roots[1]`, e existem **duas
instâncias de `LoginClass` vivas** (o censo mostra
`LoginClass,...,LoginClass,...`). A janela que recebe o callback não é
necessariamente a que tem `roots[1]` preenchido com o root certo.

Próximo passo concreto: instrumentar `Login:onEnterTransitionFinish` para
imprimir `#self.roots` e o nó recebido em 1605, e então fazer a busca nos
**dois** roots (ou guardar o root por instância). Não é mais um problema de
engine nem de formato — é escolha de qual nó consultar.

## Por que os testes de protocolo não pegaram isso

`tools/test_sessao_perfil.py` (36 verificações) e `tools/test_contas_e2e.py`
(29) exercitam o **servidor** e os **parsers** do jogo. Eles provam que
`vali_register` e `login_init` respondem certo e que o parser 3 entrega o
`user_id` real. Eles **não** provam que a tela desenha widgets — isso depende
do `CSLoader` + bindings, que é exatamente onde está o defeito.

## Por que o GAME START "sumia" (o relato original)

Antes, `account_automatic_login == "2"` fazia o acervo autenticar a conta
lembrada e **esconder** a janela de conta (`AccountSysManager.lua:278-308`).
Sem janela de conta e sem START visível, parecia "login success e o botão
some". Isso foi corrigido (o jogo agora sempre começa na tela de conta) e está
confirmado no console:
`HOST_ACCOUNT_UI login automatico desativado: o jogo comeca na tela de conta`.

Ou seja: o sintoma relatado foi corrigido; o bloqueio que sobrou é outro e é
mais profundo.

## Caminhos possíveis

1. **Busca por nome com sufixo de tag** (`nome` → `nome*tag`) — já aplicada em
   `boot_map.lua`; resolve os widgets, sem tocar nos arquivos do acervo.
2. **Escolher o root certo por instância** — pendente (item 4 acima). É o
   próximo passo; não exige mudança de formato.
3. Converter CSB 2.1 → 3.x — **desnecessário**: o loader lê bem o arquivo, como
   ficou provado pelo dump dos 5 filhos.

## O que continua válido

- Servidor local: contas, sessões, perfis isolados por conta, recusas corretas.
- `vali_register`/`login_init` exigem sessão da própria conta.
- `user_id` real do perfil no parser 3.
- Nenhum comando desconhecido vira sucesso (`-3 nao_implementado`).
- Só loopback é contactado.
- Contas existentes preservadas (5 contas / 5 perfis).
