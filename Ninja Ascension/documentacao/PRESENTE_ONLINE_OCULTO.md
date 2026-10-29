# Presente online oculto temporariamente

O clique de 25/10/2026 às 19:35:49 enviou `trigger_scene_surprise` e
recebeu sucesso pelo handler local, sem recompensas inventadas.

Em `Home.lua`, `_localOnlineGiftHidden` impede montar o presente online e
impede o terminal de atualização de reativá-lo. `Panel_online_reward`,
`Panel_bgdh` e `Panel_tjhl` ficam invisíveis e sem toque; as animações
associadas são removidas. O fundo é separado do botão, por isso ocultar
somente o botão após o clique deixava o efeito preto.

É necessário reiniciar o cliente para reconstruir Home com esta mudança.
Os parsers de login passaram nos três cenários do teste nativo. A remoção
visual precisa ser confirmada no menu normal.
