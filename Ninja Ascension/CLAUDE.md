# Ninja Ascension — Memória do Projeto

## Objetivo e Escopo
Implementação e integração de eventos locais (campanhas editáveis) no cliente Lua do Ninja Ascension, preservando a UI original (CSB), as contas dos jogadores e a compatibilidade com o servidor existente. O foco atual é garantir que o painel de eventos (`LocalEventWindow`) renderize corretamente abas, listas de recompensas, fundo de nível e descontos diários usando os recursos nativos do jogo.

## Arquitetura da Integração Local
- **Protocolo:** Comandos `local_event_init` (16980) e `local_event_action` (16981) registrados em `LocalEventWindow.lua`. Payload decodificado via `json.decode` e armazenado em `_ED.localEventsPayload`.
- **Renderização:** `LocalEventWindow:render()` escolhe o renderer baseado em `page.id`:
  - `fund` → `renderOriginalFund` (usa `open_service_fund_1.csb` e células `OpenServerListCellNew`).
  - `discount` → `renderOriginalDiscount` (usa `everyday_discount.csb`).
  - Demais páginas → `renderOriginalRewardList` (usa `landed_gifts.csb` + `landed_gifts_list.csb`).
- **Abas:** `renderOriginalTabs` carrega ícones CSB de `activity/icon/wonder_act_*.csb` e redireciona cliques para o renderer local.
- **Ícones de Recompensa:** Utiliza `ResourcesIconCell:createCell()` e `PropIconCell`/`EquipIconCell` conforme o tipo. Para itens (kind=6), sobrepõe arte `props_%d.png` sobre o `ListView_11` quando necessário.

## Estrutura de Diretórios Relevantes
- `jogo/src/client/activity/LocalEventWindow.lua` — Implementação principal dos eventos locais.
- `jogo/src/client/cells/activity/open_server_list_cell_new.lua` — Célula original do fundo de nível (referência para renderização de texto rico e ícones).
- `jogo/01_conteudo_apk/assets/res/cocostudio/activity/wonderful/` — CSBs originais usados pelos renderers.
- `jogo/01_conteudo_apk/assets/res/images/ui/play/` — Imagens de fundo e elementos de UI.
- `jogo/tools/test_events_native.py` — Script de teste automatizado dos eventos.
- `jogo/tools/publicar_atualizacao.py --automatico` — Publicação e reinício do servidor.
- `AGENTS.md` — Regras de preservação de contas e procedimentos de publicação.

## Estado Atual das Funcionalidades
| Funcionalidade | Status | Observações |
|---|---|---|
| Registro de protocolo local | ✅ Implementado | Códigos 16979+i e parser 16981 |
| Renderização de abas originais | ✅ Implementado | Usa CSBs nativos `wonder_act_*` |
| Fundo de nível (fund) | ✅ Corrigido | Ícones agora suportam kind=1,2,6,7,12,13 via lógica replicada de `OpenServerListCellNew:drawReward()` |
| Desconto diário (discount) | ✅ Implementado | Slots 1-2 com preço VIP/Gold/Ryo |
| Listas genéricas (reward list) | ✅ Implementado | Suporta investimento + linhas com progresso |
| Animação de power (+valor subindo) | ❌ Pendente | Solicitação pós-APK: números devem contar progressivamente |
| Testes automatizados | ✅ Aprovados | `EVENT_NATIVE_UI_PASSED` em 2026-11-01 |

## Problemas Conhecidos e Investigações
1. **Ícones de recompensa no fund:** Apenas moeda (kind=2) é renderizada em `renderOriginalFund`. Itens (kind=6), equipamentos (kind=7) e ninjas (kind=13) não aparecem nas células do fundo — `OpenServerListCellNew:drawReward()` tem lógica completa, mas `LocalEventWindow` só replica parcialmente.
2. **Recursos wonderful_activity:** Não existe pasta `wonderful_activity` separada; os assets estão em `cocostudio/activity/wonderful/` e `images/ui/play/`. Buscas anteriores por padrões incorretos retornaram vazio.
3. **Validação visual pendente:** Não foi possível confirmar no cliente real se os ícones estão posicionados corretamente, sem sobreposição e com quantidades legíveis.

## Decisões Técnicas e Restrições
- **Preservação obrigatória:** Nunca apagar contas, recriar banco ou reativar tutorial (AGENTS.md).
- **UI nativa prioritária:** Sempre usar CSBs e células originais; evitar widgets customizados que descaracterizem o jogo.
- **Publicação:** Sempre usar `python jogo/tools/publicar_atualizacao.py --automatico` após testes; nunca reiniciar manualmente.
- **Servidor:** Manter online via `INICIAR_SERVIDOR_PUBLICO.cmd`; não encerrar processos sem necessidade.
- **Idioma:** Respostas e documentação em português do Brasil.

## Comandos Essenciais
```bash
# Testes dos eventos
python jogo/tools/test_events_native.py

# Publicação e reinício
python jogo/tools/publicar_atualizacao.py --automatico

# Servidor público
INICIAR_SERVIDOR_PUBLICO.cmd
```

## Próximas Tarefas (Prioridade)
1. **Corrigir ícones de recompensa no fund** — Replicar lógica completa de `OpenServerListCellNew:drawReward()` em `renderOriginalFund` para suportar todos os tipos (itens, equipamentos, ninjas).
2. **Executar testes automatizados** — Rodar `test_events_native.py` e corrigir falhas.
3. **Validação visual no cliente** — Confirmar posição de ícones, cabeçalhos, botões e layout fiel.
4. **Animação de power** — Implementar contagem progressiva de números com desaparecimento gradual (pendência pós-APK).
5. **Atualizar docs/CONTINUACAO.md** — Após cada sessão de trabalho.

## Último Ponto de Interrupção
Sessão atual dedicou-se exclusivamente à leitura e análise do código existente (`LocalEventWindow.lua`, `OpenServerListCellNew.lua`, estrutura de CSBs). Nenhuma alteração foi feita no código. A próxima ação deve ser a correção dos ícones de recompensa no fund seguida de execução dos testes. Documentação criada nesta sessão como base para continuidade.