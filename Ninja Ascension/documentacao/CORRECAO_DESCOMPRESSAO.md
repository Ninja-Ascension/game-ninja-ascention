# Resposta do tutorial excedia a estimativa de descompressão

24/10/2026. O servidor respondeu `battle_result_start` com 5.026 caracteres
após a inclusão do estado de fases 6020. O helper nativo `inflateZlib`
reservava somente `compressed_size * 8 + 256` bytes e executava inflate uma
única vez. Vetores repetitivos comprimem muito além de 8:1; o helper devolvia
vazio quando faltava espaço. O binding mantinha então os bytes comprimidos
em DBytes, incompatíveis com o parser de resposta Lua.

Correção: expandir o buffer progressivamente até Z_STREAM_END, rejeitar
entrada incompleta/inválida e limitar a saída a 64 MiB. Zeros de padding do
transporte continuam aceitos após o fim do stream.

Regressão nativa na inicialização: resposta repetitiva de 128 KiB deve voltar
idêntica; entrada truncada deve ser recusada; padding deve ser aceito. Uma
falha interrompe a inicialização em vez de reportar sucesso.

Não altera contas, protocolo, tabelas originais ou progresso. Requer o novo
executável compilado; não basta reiniciar o servidor Python. A confirmação
visual da entrada do tutorial continua separada dos testes do transporte.

Compilação Debug x64 concluída com saída 0. Suíte executada:
`build/layout-tests-fbd367c8d340476a93bf36195ef33d7c/results.json` — seis
processos com saída 0 (quatro regressões principais e dois exploratórios).
`HOST_PROTO_EXPANSION_PASSED` confirmado no log do binário novo. Isso valida
a correção de transporte, não a conclusão visual de todo o tutorial.
