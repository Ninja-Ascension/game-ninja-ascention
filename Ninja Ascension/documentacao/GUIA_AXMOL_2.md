# Abrir e editar Ninja Revolution com Axmol 2

Guia do projeto atual — 23/10/2026.

Estado atual: Inspector e painel Ajustes do layout com persistência JSON já estão integrados. Consulte USAR_EDITOR_DE_LAYOUT.md para salvar/recarregar/restaurar. As observações abaixo sobre falta de salvamento correspondem ao estado anterior à implementação.

Atualização: o Inspector foi ativado e executado na sonda. A descrição abaixo de Inspector desabilitado corresponde ao estado anterior; para o procedimento corrigido e a distinção entre ajustes temporários e persistência, consulte GUIA_INSPECTOR_E_PERSISTENCIA.md. As alterações visuais ainda não são salvas automaticamente.

## 1. O que você vai abrir

O projeto usa Axmol **2.11.5**, revisão `6c0dce6db4660feafe29dabb1ab3506ee76b0931`, com LuaJIT. O fluxo validado aqui é **Visual Studio 2026 + solução CMake gerada + janela do aplicativo**. Não há neste repositório um editor de cenas Axmol pronto para abrir o jogo completo como um projeto Unity/Godot.

O alvo atual é `NinjaResourceProbe`: uma sonda que carrega interface CSB, timeline, fonte e textura originais. Ainda não é o jogo completo. A animação Spine do personagem e a integração de combate continuam pendentes.

Referência oficial de integração com IDE: https://github.com/axmolengine/axmol/blob/v2.11.5/docs/DevSetup.md. Para VS2026, a solução gerada usa extensão `.slnx`.

## 2. Preparar o caminho após entrar no Windows

Abra PowerShell normalmente e execute:

```powershell
subst
```

Se N: ainda não estiver mapeado, e estiver livre:

```powershell
subst N: "E:\[code]\nk"
```

Se `subst` já mostrar `N:\: => E:\[code]\nk`, não repita a criação. Se N: pertencer a outra pasta, não a substitua: a solução atual foi gerada para N:, então será preciso regenerar o build com outra letra livre.

N: é somente um alias para os mesmos arquivos. Ele evita que os colchetes de `[code]` sejam interpretados como padrões pelo CMake. O mapeamento deve existir durante a compilação e depuração e pode precisar ser recriado depois de reiniciar o computador.

## 3. Abrir a solução correta

No Visual Studio 2026:

1. Escolha **Abrir um projeto ou uma solução**.
2. Abra `N:\build\windows-probe-native\NinjaResourceProbe.slnx`.
3. Selecione **Debug** e **x64** na barra superior.
4. No Gerenciador de Soluções, clique com o botão direito em **NinjaResourceProbe** e escolha **Definir como Projeto de Inicialização**.
5. Use **Compilar → Compilar NinjaResourceProbe** ou compile a solução.
6. Pressione **F5** para depurar, ou **Ctrl+F5** para executar sem depurador.

O nome de alguns menus pode variar com o idioma do Visual Studio. Se o projeto não estiver selecionado para compilação, confira-o no Gerenciador de Configurações.

Abra a solução do aplicativo, não as soluções de `ax_libs`, `3rdparty` ou `luajit`. O arquivo `.exe` executa o aplicativo; ele não abre um editor.

Executável atual:

```text
E:\[code]\nk\build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe
```

Para simplesmente testar, também é possível abrir esse executável pelo Explorador. Mantenha as DLLs e a pasta `axslc` ao lado dele.

## 4. Compilar/regenerar pelo script

Para alterações no CMake, arquivos nativos novos, solução ausente ou atualização da configuração:

```powershell
Set-Location -LiteralPath 'E:\[code]\nk'
.\tools\build_windows.ps1 -SourceRoot N:/
```

O script detecta VS2022/VS2026, verifica a revisão da engine e configura/compila o alvo. O ambiente existente já compilou com VS2026, MSVC x64, SDK 10.0.26100.0 e CMake 4.5.0-rc1. Não é necessário instalar Lua separado nem Ninja para este gerador Visual Studio.

Se o build foi removido e faltarem dependências:

```powershell
.\tools\fetch_engines.ps1
.\tools\prepare_probe_dependencies.ps1
.\tools\build_windows.ps1 -SourceRoot N:/
```

Esses passos podem baixar dependências oficiais. Não execute `axmol new` sobre esta pasta: a sonda existente tem configuração e adaptadores próprios.

## 5. Onde editar

| Caminho relativo à raiz | Finalidade | Como aplicar |
|---|---|---|
| `port/native/ResourceProbe.cpp` | Janela, cena da sonda, posição de elementos, recursos, controles e áudio | Salvar, recompilar e executar novamente |
| `port/lua/compatibility.lua` | Aliases e contrato mínimo Lua | Salvar e reiniciar o aplicativo; atualmente o arquivo é lido diretamente do disco |
| `port/CMakeLists.txt` | Dependências, fontes e configuração de build | Regenerar pelo script e recompilar |
| `port/data/samples.json` | Inventário e hashes das amostras | É saída da ferramenta, não configuração dinâmica da cena |
| `tools/probe_compatibility.py` | Seleção/validação reproduzível das amostras | Executar a ferramenta; não substitui os paths escritos na cena C++ |
| `port/tests` | Testes estáticos e comparação nativa do parser | Executar o teste pertinente à mudança |
| `port/docs` | Contratos, decisões, resultados e pendências | Atualizar com evidência da alteração |

O Gerenciador de Soluções mostra principalmente fontes C++. Para abrir Lua/CMake/documentos não listados, use **Ctrl+O** e escolha o arquivo real. Não é necessário adicionar Lua à solução para o runtime ler o arquivo.

Primeiro exercício simples: em `ResourceProbe.cpp`, altere apenas o título `Ninja Revolution - M1 resource probe`; salve, feche a execução anterior, compile e pressione F5. Isso confirma seu ciclo de edição sem mexer na lógica recuperada.

Não edite os `.vcxproj`/`.slnx` gerados para adicionar dependências permanentes: o CMake pode recriá-los. Faça essas mudanças em `port/CMakeLists.txt`.

## 6. Assets, layouts e edição visual

`01_conteudo_apk` é referência preservada. Não edite os Lua/assets originais. Para mudanças, use cópias no port e registre a origem.

Importante sobre o estado atual:

- Os `.csb` são layouts compilados. A solução Visual Studio não os transforma em uma cena visual editável.
- `05_layouts_cocos_json` contém representações estruturais extraídas. Editar esses JSON **não altera automaticamente** o CSB carregado pelo aplicativo.
- Não foi recuperado um projeto Cocos Studio completo com seus arquivos de autoria. Uma ferramenta visual externa exige validar importação/formato e exportação; não há round-trip visual validado nesta etapa.
- O Inspector do Axmol está desabilitado neste alvo. Não há painel de propriedades do jogo integrado por padrão.
- `port/resources` ainda não está no caminho de busca do runtime. Copiar uma imagem para lá, sozinho, não substitui a original.

Para editar uma textura futuramente, peça ao Codex para criar a pasta de overrides, copiar somente o asset escolhido e adicionar `root + "/port/resources"` antes de `assets/res` em `FileUtils::setSearchPaths`. Preserve a hierarquia, por exemplo `port/resources/images/...`. Só então edite a cópia e reinicie. Essa adaptação é uma próxima alteração; não foi aplicada por este guia.

Para mudar posição, escala ou texto de um nó existente, comece com uma alteração pequena na cena C++ ou em um novo módulo Lua do port. Evite modificar o CSB original ou reconstruir milhares de layouts de uma vez.

## 7. Usar o Codex para editar

Mantenha esta conversa no projeto `E:\[code]\nk` e descreva um resultado observável. Exemplos:

> Em port/native/ResourceProbe.cpp, altere o título da janela para Ninja Revolution — Desenvolvimento. Compile o alvo NinjaResourceProbe em Debug x64 e confirme o resultado. Preserve todos os arquivos originais.

> Crie um override somente para a textura que eu indicar em port/resources e configure a prioridade de busca. Não altere 01_conteudo_apk. Documente o caminho de origem e valide o carregamento.

> Investigue o erro flipX do parser Spine legado. Preserve as timelines e os eventos originais; não remova flipX para fazer o teste passar. Proponha e teste a menor adaptação compatível.

Para código, builds, logs e testes, o Codex deve preferir as ferramentas normais de arquivos e terminal. Isso permite alterações precisas e reproduzíveis.

## 8. Usar a skill computer-use

A skill pode atuar na interface do Visual Studio ou da sonda: selecionar projeto, observar erros, conferir a janela e testar controles. Ela não transforma Axmol em um editor visual nem substitui compilação/testes.

Exemplo de solicitação:

> Use a skill computer-use para inspecionar a janela Ninja Revolution - M1 resource probe, capturar o estado visível e testar A, Espaço e R. Compare o resultado com os logs e relate o que foi realmente verificado.

Ou:

> Use a skill computer-use para abrir a solução NinjaResourceProbe no Visual Studio, selecionar Debug x64 e verificar os erros apresentados. Faça alterações de código e comandos de build pelas ferramentas normais do Codex.

Limitação observada neste ambiente: o helper de computer-use falhou ao iniciar porque interpretou `E:\[code]\nk` como padrão de filesystem. O alias N: resolveu o CMake, mas não corrigiu o helper. Assim, o uso dessa skill ainda não foi validado neste workspace. Não confundir isso com falha da janela do jogo, que abriu e respondeu.

Uma eventual mudança para uma raiz sem colchetes, por exemplo `E:\nk`, deve ser feita separadamente: fechar builds/aplicativos, mover somente a pasta do projeto, reabrir a conversa na nova raiz e regenerar os builds/caminhos absolutos. Não basta renomear e reutilizar o cache atual. A skill deve ser testada novamente depois; não há garantia de que mudar o caminho seja a única correção necessária.

Skill consultada: `C:\Users\! I T A C H I\.codex\plugins\cache\openai-bundled\computer-use\26.1016.61520\skills\computer-use\SKILL.md`.

## 9. Controles e diagnóstico

- **A ou clique:** solicita reprodução da música original.
- **Espaço:** alterna pausa.
- **R:** reinicia a timeline do logo, não uma batalha.
- **Shift+F5 no Visual Studio:** encerra a sessão de depuração.

Log próprio: `E:\[code]\nk\build\probe-writable\resource-probe.log` (tudo dentro do workspace; nada é gravado no disco C:; override via `NR_PROBE_WRITABLE`).

Validação já realizada: compilação x64, inicialização Lua, criação de nó CSB e início de timeline. Ainda pendentes: fidelidade visual completa, confirmação sonora, comportamento de controles por inspeção independente e animação Spine do personagem. Há um aviso de conflito CRT na linkedição Debug a investigar antes de declarar estabilidade.

Consulte `TEST_RESULTS.md` para evidências e `KNOWN_ISSUES.md` para limitações. O ciclo de trabalho recomendado é uma mudança pequena, build/reinício, verificação e checkpoint Git.
