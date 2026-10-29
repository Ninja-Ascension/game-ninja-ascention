# Inspector visual e persistência — Axmol 2.11.5

**Atualização:** a persistência descrita abaixo já foi implementada no executável. Para o uso atual, leia `USAR_EDITOR_DE_LAYOUT.md`. Agora há Salvar ajustes, Recarregar e Restaurar iniciais; o áudio é solicitado por botão/atalho, e o preview pode ser pausado sem congelar o Inspector. O restante deste documento registra o procedimento de implementação anterior.

Atualização de execução: a ativação do Inspector foi aplicada, compilada e executada com sucesso. O log registra `INSPECTOR_ATTACHED` e `INSPECTOR_FRAME_CHECK windows=3 vertices=52`; a janela permanece respondendo. O erro corrigido era uma chamada `Inspector::destroyInstance()` fora de método. A instrução de encerramento abaixo agora mostra o método completo para evitar essa ambiguidade. As etapas de persistência continuam sendo um procedimento futuro: não existe ainda botão Salvar nem carregador de overrides na aplicação.

## 1. Fechar a execução e abrir a solução

Feche a sonda em execução para liberar o executável. Confira `subst` no PowerShell; se N: estiver livre e ainda não mapeado, execute:

```powershell
subst N: "E:\[code]\nk"
```

Abra `N:\build\windows-probe-native\NinjaResourceProbe.slnx` no Visual Studio 2026. Selecione Debug/x64 e NinjaResourceProbe como projeto de inicialização. Preserve a revisão Axmol 2.11.5 já fixada.

## 2. Habilitar as duas extensões

Edite `port/CMakeLists.txt`. Há um foreach que desabilita IMGUI e INSPECTOR com FORCE. **Depois do endforeach()**, acrescente:

```cmake
set(AX_ENABLE_EXT_IMGUI ON CACHE BOOL "Inspector visual" FORCE)
set(AX_ENABLE_EXT_INSPECTOR ON CACHE BOOL "Inspector visual" FORCE)
```

É importante colocar depois do loop; antes dele as opções voltariam a OFF. Não habilite Spine 4.2 para tentar corrigir a animação 2.1.27.

## 3. Conectar o Inspector à cena

Em `port/native/ResourceProbe.cpp`, acrescente o include:

```cpp
#include "Inspector/Inspector.h"
```

Depois de criar todos os nós e antes de `director->runWithScene(scene)`, acrescente:

```cpp
auto inspector = ax::extension::Inspector::getInstance();
inspector->setFontPath("fonts/FZYiHei.ttf");
inspector->openForScene(scene);
```

A fonte indicada existe nos recursos originais. O Inspector usa `fonts/arial.ttf` por padrão; essa fonte não foi localizada no conjunto consultado. O exemplo usa openForScene explicitamente porque runWithScene pode não ter efetivado a cena no instante em que retorna.

Substitua o método `applicationWillQuit()` existente pelo método completo abaixo. A chamada de destruição deve ficar **dentro das chaves do método**, nunca solta entre os métodos da classe:

```cpp
void applicationWillQuit() override {
    ax::extension::Inspector::destroyInstance();
    AudioEngine::end();
    report("PROBE_EXIT");
}
```

## 4. Regenerar, compilar e executar

```powershell
Set-Location -LiteralPath 'E:\[code]\nk'
.\tools\build_windows.ps1 -SourceRoot N:/
```

Execute novamente pelo Visual Studio (F5/Ctrl+F5). O resultado esperado é um painel chamado **Inspector**, com árvore de nós e propriedades. Se não aparecer, confira opções no CMakeCache, erros de compilação, fonte e logs; não considere a integração validada só porque a janela principal abriu.

## 5. Testar a edição temporária

Selecione um nó na árvore. Ajuste Position, Scale, Rotation, Content Size, Anchor Point, Visible ou Color. Os números alteram o nó em execução. Isso não garante gizmos para arrastar objetos diretamente sobre a cena nem oferece importação visual completa de assets.

Comece pelo rótulo ou pela textura estática da sonda. Elementos comandados por timeline, layout automático ou lógica podem ter suas propriedades reaplicadas depois do ajuste. Não edite uma propriedade enquanto a lógica a sobrescreve a cada frame; primeiro defina um modo de edição que suspenda somente o controlador relevante. Space pausa o Director e pode também interromper a atualização do Inspector; não é uma solução de modo de edição já validada.

Fechar e reabrir neste ponto deve restaurar os valores iniciais: o Inspector padrão não grava os ajustes no CSB.

## 6. Preparar IDs e escopo dos ajustes permanentes

Antes de salvar, registre os nós editáveis com identificadores estáveis. Para a sonda, nomes explícitos como `probe.login`, `probe.status`, `probe.atlas_preview` são adequados. Para descendentes do CSB, combine identificação do asset, caminho de ancestrais e nome/actionTag original, validando duplicatas. Não use endereços de memória, textos traduzidos ou índices de filhos como única identidade.

Inclua inicialmente só os nós da sonda e os descendentes do layout selecionado. Não serialize objetos internos do Inspector, caches, callbacks ou toda a engine.

## 7. Implementar o arquivo de overrides

Esta etapa exige código novo; não há uma opção pronta Salvar no Inspector. Uma estrutura proposta:

```text
port/native/LayoutOverrides.h
port/native/LayoutOverrides.cpp
port/data/layout_overrides.json
```

Adicione os novos .cpp ao alvo em `port/CMakeLists.txt` (o projeto hoje lista ResourceProbe.cpp explicitamente). Um esquema inicial pode ser:

```json
{
  "schema": 1,
  "scene": "resource_probe",
  "nodes": {
    "probe.status": {
      "position": [480, 60],
      "scale": [1, 1],
      "rotationSkew": [0, 0],
      "anchor": [0.5, 0.5],
      "contentSize": [600, 40],
      "visible": true,
      "localZOrder": 100,
      "color": [255, 255, 255],
      "opacity": 255
    }
  }
}
```

Isso é um esquema proposto, não um arquivo já suportado pelo runtime. Implemente as operações:

1. Registrar IDs e capturar valores iniciais antes dos overrides.
2. Carregar JSON, validar versão/tipos/números finitos/faixas, localizar cada nó e aplicar somente propriedades permitidas.
3. Salvar o estado editável atual com escrita em arquivo temporário e substituição atômica.
4. Restaurar os valores iniciais em memória sem sobrescrever o CSB.
5. Informar IDs ausentes/duplicados e erros de leitura/gravação; não retornar sucesso incondicionalmente.

Para desenvolvimento, use um caminho gravável explícito e visível, por exemplo `%LOCALAPPDATA%\NinjaRevolutionProbe\layout_overrides.json`. Para versionar ajustes aprovados, copie/exporte esse JSON para `port/data/layout_overrides.json`. O carregador deve ter precedência documentada: override local, depois padrão versionado; JSON local inválido deve gerar erro claro, não uma troca silenciosa de arquivo.

Na inicialização: criar os nós → registrar IDs e baseline → aplicar overrides → abrir Inspector. A função restartTimeline recria o nó do logo: reaplique os overrides desse ramo depois de recriá-lo. Não aplique o JSON em todos os frames, pois isso bloquearia a edição visual.

## 8. Acrescentar controles de salvar, recarregar e restaurar

Crie um pequeno painel ImGui separado, ou uma extensão de propriedades com InspectPropertyHandler, oferecendo:

- **Salvar ajustes:** salvar no caminho local configurado e exibir confirmação/erro.
- **Recarregar:** ler o arquivo e aplicar aos nós atuais.
- **Restaurar valores iniciais:** restaurar o baseline em memória; não apagar o arquivo sem uma ação explícita.
- Exibir o caminho do arquivo e se há alterações ainda não salvas.

O Inspector 2.11.5 permite addPropertyHandler, mas não expõe publicamente o nó selecionado para um botão externo. Para uma primeira implementação simples, salve todos os nós do registro editável; não tente acessar membros privados do Inspector nem modificar o engine para descobrir a seleção.

Integre captura de input ImGui: cliques nos painéis e digitação de coordenadas não devem disparar a música ou atalhos da cena. A sonda atual toca áudio em qualquer clique; isso precisa ser tratado durante a integração.

## 9. Validar antes de chamar de edição persistente

Teste: alterar posição de um rótulo → Salvar → fechar → reabrir → conferir o mesmo valor. Depois teste Recarregar, Restaurar, JSON inválido, ID ausente/duplicado, falha de gravação, reinício da timeline e clique/teclado dentro do painel sem acionar o jogo. Confira também que hashes dos assets originais continuam iguais.

Critérios: o Inspector funciona, o ajuste sobrevive à reabertura, o erro aparece claramente e a edição não modifica o APK, CSB ou Lua recuperado. Isso ainda não resolve o personagem Spine nem cria um editor completo de conteúdo.

## 10. Solicitar a implementação ao Codex e usar computer-use

Solicitação sugerida para implementar, em duas etapas:

> Ative ImGui e Inspector no NinjaResourceProbe com Axmol 2.11.5. Conecte o Inspector à cena e valide a compilação/execução antes de implementar persistência. Depois crie IDs estáveis, baseline e LayoutOverrides com JSON versionado, escrita atômica e controles Salvar/Recarregar/Restaurar. Preserve os assets originais, trate captura de input e reaplicação após restartTimeline. Teste salvar, fechar e reabrir, com erros visíveis. Siga port/docs/GUIA_INSPECTOR_E_PERSISTENCIA.md.

Depois que a interface existir:

> Use a skill computer-use para selecionar o nó probe.status, alterar sua posição, salvar os ajustes e verificar a persistência após reiniciar. Confirme pelos valores da interface e pelo JSON gravado.

A skill interage com painéis existentes; ela não implementa por si só a persistência. As mudanças de código e comandos devem usar as ferramentas normais do Codex. Neste workspace, o helper apresentou erro devido ao caminho com colchetes; seu funcionamento precisa ser recuperado e validado separadamente. O alias N: não resolveu esse helper na tentativa anterior.
