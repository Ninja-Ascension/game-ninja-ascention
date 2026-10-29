# Prévia do personagem original

O executável de diagnóstico agora inclui um adaptador isolado para Spine 2.1.
Não inicia o `main.lua` original nem acessa os servidores antigos.

## Ao voltar ao computador

1. Abra `build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe` na pasta do projeto.
2. Procure o painel **Personagem original - Spine 2.1**.
3. Escolha uma entrada em **Animacao**. O personagem inicial é `spirte_102101`; `00_daiji` é a animação inicial.
4. Use **Pausar personagem**, **Reiniciar personagem** e **Velocidade** para examinar a prévia.
5. No Inspector, selecione `probe.character` para editar posição, escala e visibilidade. Salve pelo painel **Ajustes do layout**.

O painel do personagem controla sua animação separadamente do logo. A seleção
de animação, o tempo e a velocidade ainda não são persistidos. Posição e escala
participam do mesmo sistema de ajustes existente. Perfis anteriores continuam
válidos: o novo nó usa seus valores iniciais quando não existe no perfil salvo.
Os nós internos de malha são atualizados pelo adaptador e não são registrados
como elementos editáveis persistentes. Edite o nó pai `probe.character`.

## Implementação e limites

- Runtime oficial Spine 2.1.25, revisão `142e770e5b4b42395a3a0a68ff3c8a21ba2774eb`, sem modificações.
- O runtime Cocos 3.5 de referência continua disponível como comparação; sua falha `flipX` não foi ocultada.
- O Spine moderno do Axmol continua desativado. O adaptador usa regiões, meshes e skinned meshes do runtime antigo e sprites poligonais do Axmol, respeitando a ordem dos slots.
- Esta etapa trata da prévia visual. Eventos de animação ainda não acionam golpes, áudio ou lógica de combate.
- Nenhum JSON, atlas, PNG ou script original é regravado.
- A licença original permanece em `build/deps/spine-2.1.25/LICENSE` e nos fontes. Não foi feita distribuição do runtime ou do jogo.
- A fidelidade visual precisa ser conferida na tela; testes de leitura e geometria não comprovam equivalência com o APK.

## Reprodução do teste de leitura

Depois de executar `tools/fetch_engines.ps1`, com `N:` apontando para a pasta do projeto:

```powershell
cmake -S N:/port/tests/legacy_parser -B N:/build/spine21-parser -G "Visual Studio 18 2026" -A x64 -DNR_SPINE_21=ON
cmake --build N:/build/spine21-parser --config Debug
ctest --test-dir N:/build/spine21-parser -C Debug --output-on-failure
```

O teste de integração de layout continua disponível em `tools/test_layout_editor.py`,
usando perfis temporários para preservar os ajustes do usuário.
