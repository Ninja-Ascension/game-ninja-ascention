# Cadeado da tela FIGHT — diagnóstico medido (26/10/2026)

Escopo: os botões da tela FIGHT (`ExploreWindow`) aparecem com cadeado mesmo com o jogador no nível 110. Todas as funções pedidas (Ninja King, X-server Ninja King, X-server RSS War, Inter-server Grat War, Squad Arena, Clan War) ficam atrás desses botões.

**Estado: NÃO RESOLVIDO.** Pausado por decisão do jogador ("vou resolver quando abrir para servidor, vai ter mais gente").

## O que foi medido (com evidência)

### A tela e o cadeado

- Tela: `client/l_digital/explore/ExploreWindow.lua`, CSB `campaign/maoxian.csb`.
- Botões: `Image_maoxian_fun_pic_N`; cadeado: `Image_maoxian_lock_N`.
- Linhas 232-251: o cadeado fica visível quando `funOpenDrawTip(90+i ou 185+i, false)` **não** devolve `false`.
- A tabela é `res/data/mould/fun_open_condition.txt` (205 linhas, 11 colunas).

### Condições da tabela para os 9 botões

| Botão | ID | Nível | open_day | Situação esperada |
|---|---|---|---|---|
| 1 | 91 | 18 | -1 | liberado |
| 2 | 92 | 24 | -1 | liberado |
| 3 | 93 | 32 | -1 | liberado |
| 4 | 94 | **999** | -1 | **trancado por design** (`Coming Soon`) |
| 5 | 186 | 38 | -1 | liberado |
| 6 | 187 | 32 | -1 | liberado |
| 7 | 188 | 25 | -1 | liberado |
| 8 | 189 | 45 | -1 | liberado |
| 9 | 190 | 40 | **3** | depende dos dias de servidor |

Simulação com os dados reais (`tools/simular_cadeado_fight.py`) confirmou: **8 de 9 deveriam estar liberados**; só o botão 4 é trancado por design.

### O nível do jogador está correto

No bloco do parser 3 do `login_init`, campo `[18] user_grade = '110'`.
Erro anterior: um script meu localizou o parser com `tokens.index('3')` e pegou um `'3'` dentro do bloco `6020`, reportando `'0,0,0,0,0,0,0'`. **O nível nunca esteve errado.** Índice correto: o bloco 3 começa depois do envelope `seq cmd status 6020 <produto>`.

### A hipótese do `union_grade` (testada e INSUFICIENTE)

- `_ED.union.union_info` é declarado em `EnvironmentDatas.lua:1692-1702` **sem** o campo `union_grade`.
- Ele só seria preenchido por `parse_union_init` (`ProtocolParserCopy.lua:7991`).
- O cliente **nunca envia** `union_init`: após um login completo, os comandos recebidos foram `login_init`, `login_init_again`, `vali_register`, `register`, `arena_init`, `ship_purify_init`, `draw_endurance_init`, `battlefield_report_get`, `get_web_recharge_state`, `keep_alive`, `new_get_server_list`, `platform_user_login`, `get_random_name`.
- Logo `funOpenDrawTip:5286` faria `-1 > tonumber(nil)`.

**Teste feito:** `port/lua/fun_open_seguro.lua` preenchia `union_grade = 0` (conta sem clã, valor real) antes de a tela ser desenhada. O log `fun-open.log` confirmou que o valor foi aplicado:

```
18:55:18 union_grade preenchido com 0 (sem cla = 0)
22:17:00 union_grade preenchido com 0 (sem cla = 0)
```

**O cadeado continuou.** Portanto essa linha **não** é o bloqueio (ou não é o único). O módulo foi removido para não deixar código inefetivo no jogo.

## O que ainda falta medir (próximo passo, não feito)

1. Instrumentar `funOpenDrawTip` registrando o **motivo exato** de cada `return true` (qual das 6 condições disparou) durante a abertura real da tela.
2. Verificar `_ED.function_open_states`: se não for nil e o id tiver valor diferente de 1, a linha 5211 trava antes de qualquer outra checagem.
3. Verificar `dms.element(dms["fun_open_condition"], id)` em tempo de execução (se devolver nil → linha 5221 `return true`), pois o arquivo tem os ids mas o `dms` pode falhar ao carregar a tabela.
4. Considerar que o `i` do laço em `ExploreWindow:224` pode não corresponder ao id esperado (o laço usa `i` de `pairs` no `ScrollView`, não a ordem visual): ids 91-94 para `i<=4` e **185+i** para `i>4`, ou seja 186..194 — conferir se `194` existe na tabela (faixa presente: 185..191).

## Alteração mantida

`port/server/local_server.py`: `union_init` agora responde os 14 campos de `parse_union_init` (`ProtocolParserCopy.lua:7988-8008`) com `union_grade` numérico. Validado por `tools/test_union_init.py` (14 campos, nenhum vazio, números válidos). Hoje é inerte porque o cliente não pede o comando; passa a valer quando houver clã real.

## Estado do jogo

Tutorial desativado, conta 61 preservada, nenhum processo encerrado à força além dos reinícios autorizados pelo jogador.
