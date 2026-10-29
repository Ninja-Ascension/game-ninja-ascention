# Shader compile failed ao criar o chat

Sintoma: Chat/chat_home_window.csb existe, mas sua criação falha procurando
positionColorLengthTexture_vs/fs. A interface fica preta e repete tentativas.

Os dois binários existem em runtime/axslc e junto ao executável. A proteção
anterior envolvia somente app.setSearchPaths, enquanto app.init e outras
rotinas chamam diretamente FileUtils:setSearchPaths, substituindo a lista.

engine_shader_paths.lua, instalado em boot_map.lua antes de restaurar os
caminhos, agora preserva a pasta validada dos shaders em toda chamada de
cc.FileUtils.setSearchPaths. Copia a lista recebida, mantém a ordem dos
recursos e não adiciona o mesmo caminho duas vezes. Não troca os shaders por
stubs, não ignora falhas de criação de CSB e não altera conta ou protocolo.

Validação nativa: NR_PROBE_SHADER_PATH_TEST=1 junto de NR_PROBE_BOOT_MAP=1,
NR_PROBE_TEST_MODE=host e NR_PROBE_MENU_TEST=1. O teste retira axslc da lista
fornecida, substitui os caminhos e cria o chat original três vezes.
Resultado: ENGINE_SHADER_PATH_NATIVE_PASSED, MENU_BOOT_PROBE_RESULT true,
sem Shader compile failed. Log: build/shader-path-chat.log.

É necessário fechar e reabrir o jogo para carregar o novo adaptador Lua.
Não requer recompilar, reinstalar engine, apagar contas ou resetar progresso.
Outros fluxos do jogo não foram validados por esse teste específico.
