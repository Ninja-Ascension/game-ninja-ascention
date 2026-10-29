# Pausas ao tocar/trocar personagens

`HomeHero:onHeroesDraw` invalidava os seis `shipId` em toda atualização,
forçando destruir e recriar todos os atores Spine. Para Naruto, conserva
agora os atores inalterados. Uma chave de aparência inclui identidade,
evolução, skin, avanço, estrelas e nível, preservando atualizações visuais
quando essas propriedades mudam. Outras variantes do cliente mantêm o
comportamento anterior.

Erros registrados também corrigidos: notificação de conquistas sem
`user_artifact_achieve_info` e callback de purificação sem
`digital_purify_info._heros`. Os recursos incompletos não produzem alertas
antes de sua inicialização válida.

Testes nativos de login e notificações aprovados (três cenários). Não foi
medido FPS nem latência de clique real. Reiniciar o cliente e comparar a
troca de um ninja já carregado é a próxima verificação visual. Arquivos de
um ninja ainda não carregado podem causar uma pausa inicial.
