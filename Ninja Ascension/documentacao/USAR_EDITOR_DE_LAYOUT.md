# Editor de ajustes — como usar

O executável da sonda agora combina **Inspector** e **Ajustes do layout**. É um editor de propriedades dos recursos já carregados; não é um editor completo de fases nem o jogo jogável.

1. Abra `build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe`.
2. No Inspector, expanda `probe.scene` e escolha um nó. Exemplos: `probe.status` (texto), `probe.atlas_preview` (textura estática), `probe.login` (interface) e `probe.logo` (logo).
3. Ajuste as propriedades. A animação do logo começa pausada para não sobrescrever os valores enquanto você edita; o Inspector continua atualizando.
4. No painel **Ajustes do layout**, clique em **Salvar ajustes**. Confira a mensagem de sucesso e o caminho exibido.
5. Feche e reabra: os ajustes são carregados automaticamente.

Controles:

- **Salvar ajustes:** grava os nós registrados em `E:\[code]\nk\build\probe-writable\layout_overrides.json` (nada no disco C:; override por execução via variável `NR_PROBE_LAYOUT_FILE`), com arquivo temporário, flush e substituição atômica.
- **Recarregar:** descarta mudanças em memória e reaplica o arquivo local. Se ainda não existir arquivo local, usa o padrão versionado `port/data/layout_overrides.json`. Um arquivo local inválido gera erro; não é substituído silenciosamente pelo padrão.
- **Restaurar iniciais:** recupera os valores originais em memória e elementos removidos. Não apaga o JSON. Para manter a restauração na próxima abertura, clique depois em Salvar ajustes.
- **Tocar som (A):** ação explícita de áudio. Cliques genéricos na janela/Inspector não acionam mais música.
- **Pausar/Continuar preview** ou Espaço fora de campos de edição: controla a timeline do logo e o áudio, sem pausar o Inspector.
- **R**, fora de campos de edição: recria a timeline do logo e preserva os ajustes atuais desse ramo.

Propriedades salvas nos nós registrados: posição, escala, rotação X/Y, âncora, tamanho, visibilidade, Z local/global, cor e opacidade; texto em nós LabelProtocol e FlipX/FlipY em sprites.

O registro usa IDs dos recursos, hierarquia, nomes, tags e actionTags. Identificadores ambíguos são omitidos com aviso; não são associados pela posição de memória ou por uma ordem de filhos instável. O painel informa a quantidade de nós registrados (33 nas amostras atuais). Objetos internos da engine/Inspector que não fazem parte desse registro não são salvos.

O botão **Delete** do Inspector não representa uma exclusão persistente. Se você remover um nó registrado, o salvamento é bloqueado com mensagem, preservando o arquivo anterior. Use Restaurar iniciais/Recarregar para recuperá-lo ou use Visible=false se quiser ocultá-lo permanentemente nos ajustes. O registro mantém referências seguras para não acessar memória liberada.

Os assets originais, CSB e Lua recuperados permanecem intactos. Para compartilhar/versionar um layout aprovado, copie o JSON local para `port/data/layout_overrides.json` deliberadamente; o arquivo local tem prioridade. O executável não reexporta CSB.

Animações e layouts automáticos podem controlar propriedades em tempo de execução. Salve com o preview pausado; habilitar a animação novamente pode modificar os valores comandados por suas timelines. A compatibilidade Spine do personagem continua pendente.

Validação automatizada:

```powershell
cmake --build N:/build/windows-probe-native --config Debug --target NinjaResourceProbe LayoutOverridesTests --parallel 4
# Aguarde o comando acima terminar antes de executar:
python tools/test_layout_editor.py
```

Os testes usam uma pasta nova em build/layout-tests-<id>, não o arquivo de ajustes do usuário. Validam JSON, gravação, recuperação, duas execuções reais e mouse sem áudio. A automação visual externa via computer-use continua sujeita ao erro já documentado do helper no workspace com colchetes; estes testes nativos não são uma captura visual dos botões.
