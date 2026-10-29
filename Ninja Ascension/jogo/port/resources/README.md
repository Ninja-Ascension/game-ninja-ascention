# port/resources — overrides de recursos

Este diretório tem prioridade sobre `01_conteudo_apk/assets/res` na busca de
arquivos do runtime (ver `ResourceProbe.cpp`, `FileUtils::setSearchPaths`):
uma cópia em `port/resources/<hierarquia>` substitui a original sem alterá-la.

## Regras

1. Nunca edite os originais em `01_conteudo_apk` ou `02_recursos_decodificados`.
2. Copie para cá SOMENTE o asset que vai substituir, preservando a hierarquia
   (exemplo: `images/ui/login/fangchenmi.png`).
3. Documente no commit o caminho de origem e o motivo da mudança.
4. Para reverter, remova a cópia daqui: a original volta a ser usada
   automaticamente, pois a busca cai no primeiro caminho encontrado.

Criado em 23/10/2026. Primeira validação de precedência (mesmo dia): cópia
byte-a-byte de `images/ui/login/fb_icon.png` (SHA-256 idêntica à original,
nenhuma mudança visual) resolve a partir daqui — linha
`OVERRIDE_RESOLVE … -> …/port/resources/…` nos logs dos três processos de
teste (`build/layout-tests-418fba4f1eda4fedb98f1e4d3b86d677/`).
