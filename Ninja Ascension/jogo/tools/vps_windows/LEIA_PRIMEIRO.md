# Pacote Windows — Ninja Revolution

Copie esta pasta inteira para a VPS Windows. Abra `INICIAR_JOGO.cmd` em uma sessão gráfica/RDP. Para executar somente o servidor Python, use `INICIAR_SERVIDOR.cmd`. O launcher cria os atalhos internos, define o caminho local e grava os logs em `logs/`.

## Pastas

- `jogo/01_conteudo_apk/assets/`: imagens, áudios, traduções, layouts, tabelas e Lua original.
- `jogo/port/`: adaptações Lua/C++, servidor Python, banco atual e configurações.
- `jogo/build/windows-probe-native/`: executável, DLLs e shaders; sem objetos de compilação.
- `jogo/build/deps/`: fontes e dependências Axmol/Spine para continuar o desenvolvimento.
- `jogo/tools/`: scripts de desenvolvimento e testes.
- `documentacao/`: guias e diagnósticos preservados.
- `MANIFESTO.json` e `RELATORIO.json`: arquivos copiados, tamanho e exclusões.

Os caminhos internos foram mantidos porque são usados pelo código e pelo CMake. Não renomeie essas subpastas sem ajustar as dependências. A pasta externa pode mudar de local; o executável usa `NR_GAME_ROOT`, definido pelo launcher.

## Requisitos e limites

- Windows x64, Python 3.11 ou superior no PATH e suporte gráfico OpenGL/ANGLE na sessão RDP.
- O executável atual é **Debug**. Pode exigir o ambiente C++ de desenvolvimento do Visual Studio e seu runtime de depuração. O redistribuível VC++ comum não substitui o runtime Debug. Uma distribuição de produção deve ser compilada em Release e validada separadamente.
- O servidor continua em `127.0.0.1:18080`, acessível na própria VPS. Este pacote não configura acesso remoto de outros jogadores, firewall, domínio ou TLS.
- O banco `jogo/port/dados/contas.sqlite3` contém as contas e o progresso atuais. Mantenha a pasta privada. Ele foi copiado com a API de backup do SQLite, sem resetar as contas.
- Os fontes foram incluídos; os intermediários CMake do computador original não foram copiados. Para recompilar, configure novamente com `jogo/tools/build_windows.ps1` e um caminho sem colchetes. Os testes antigos podem conter caminhos `N:/`; precisam ser adaptados ao executá-los em outra máquina.
- Limitações e funcionalidades incompletas do jogo permanecem registradas na documentação. A transferência não conclui sistemas ainda pendentes.

Os APKs originais, decompilação Java/Smali, ferramentas de extração, auditorias históricas e backups antigos ficaram no projeto de origem. Eles não são necessários para iniciar o port e não foram apagados como se fossem arquivos descartáveis.
