# NinjaAscension

- Jogo em `jogo`. Preservar contas e progresso, especialmente os personagens ItachiBR, RenegadoBR e Aeglos (nomes em `perfis.user_name`, diferentes dos logins).
- Não apagar contas, recriar banco ou reativar tutorial. Antes de alterações persistentes, fazer backup consistente pela API SQLite e verificar a integridade.
- Não responder sucesso genérico para operações não implementadas. Testar compras/melhorias com banco temporário e repetição do mesmo pedido para evitar cobrança duplicada.
- Ao finalizar alterações, após os testes, publicar com `python jogo/tools/publicar_atualizacao.py --automatico` e reiniciar o servidor. O usuário autorizou publicação e reinício ao concluir; evitar reinícios durante a implementação.
- Validar/compilar Lua ao final. Nome público do APK e PC: NinjaAscension; ícone: `logogame.jpg`. Manter a identificação interna Android e o iniciador legado compatíveis com as instalações existentes.
- Pendência solicitada após resolver a inicialização do APK: animação de power deve contar os números subindo, manter o `+valor` junto do total e depois desaparecer em etapas como no original; não apenas aparecer/sumir.
