# Recruit do Ultimate Fight Survival — engenharia reversa

APK de origem: `../Ultimate+Fight_Survival_1.0.3_APKPure.apk`.

## Extração

O APK usa `assets/Horrycation.txt` como mapa entre caminhos originais e nomes embaralhados. Os arquivos seguem o cabeçalho `39 7f 13`, são decifrados com Blowfish ECB usando a chave contida em `assets/Horriblekimo.bin` e descomprimidos em zlib. A ferramenta `ExtractRecruitAssets.java` extrai os módulos Recruit, cenas Cocostudio da loja e recursos citados por essas cenas para `decrypted/firecracker/`. `manifest_sha256.tsv` registra tamanho e SHA-256 dos arquivos decodificados.

## Arquivos centrais

- `decrypted/firecracker/client/shop/recruit/HeroRecruitListView.lua`
- `decrypted/firecracker/res/cocostudio/shop/shop.csb`
- `decrypted/firecracker/res/images/ui/bg/hy_zhaomu_bg.png`

O Lua ativo em `jogo/01_conteudo_apk/assets/src/client/shop/recruit/HeroRecruitListView.lua` corresponde ao código do APK, com a proteção dos sorteios não suportados, o cenário e o X de fechar da integração. A cena `shop.csb` e os 20 recursos que ela referencia foram comparados com os arquivos ativos: correspondem e não faltam referências.

## Limite da integração

A interface e os controles da tela vêm do Recruit do APK. Os botões de recrutamento continuam bloqueados em modo visual porque o código original envia `ship_bounty`, que ainda não está implementado de forma compatível no servidor local. O X fecha somente a janela do Recruit. A integração visual não representa sorteios funcionais.
