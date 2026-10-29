# Fundo vazio na revelação do recrutamento

Logs: x1 falhava em HeroRecruitSuccess.lua:1426 e x10 em
HeroRecruitSuccessTen.lua:2716. Os resultados estavam salvos no banco.

Correções:
- Resultados de fragmentos agora informam a instância do inventário em
  `mould_id`, como as telas originais esperam; o payload do servidor
  continua registrando o molde para auditoria.
- O parser inicializa a lista de recompensas legada vazia, necessária
  para a tela x10, sem inserir os dez resultados duas vezes.
- HeroRecruitSuccess carrega explicitamente ResourcesIconCell.
- Notificação de matriz sem dados retorna falso.

Validação melhorada: o teste anterior abria a janela e terminava antes do
callback de inicialização; não comprovava a montagem completa. Agora
executa `onEnterTransitionFinish` diretamente, no modo 15 e ranking nil,
como NewRecruitMain. x1 com repetido/fragmentos e x10 passaram sem exceção.
O teste impede requisições de diagnóstico ao servidor real.

Ainda não comprova toda a sequência animada e aceitação por clique. Não
reexecutar o sorteio existente nem cobrar novamente para recuperar dados;
os personagens/fragmentos já foram persistidos na coleção/inventário.
