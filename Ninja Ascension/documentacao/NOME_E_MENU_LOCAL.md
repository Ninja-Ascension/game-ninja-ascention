# Nome e atalhos do menu

`user_info_modify` tipo 0 agora salva `perfis.user_name` da sessão
autenticada e retorna parser original 12033. Valida identidade, comprimento
de 1 a 20 caracteres e rejeita controles. O nome da conta/login permanece
igual. Espaços e ampersand são codificados no transporte e decodificados
no cliente, inclusive no login.

Home oculta as duas listas promocionais do layout, removendo Event,
Recharge, Pack, Activity e os demais atalhos dessas listas. Oculta também
`Button_gm_connect` (FAQ). Mantém os controles de jogo fora dessas listas.
Referências dos widgets são localizadas uma vez; atualizações posteriores
não deixam os atalhos visíveis novamente.

Testes: `tools/test_profile_local.py` (salvar/relogar/reabrir banco, nomes
inválidos) e `tools/test_login_layout_native.py` (parser 12033, listas e
FAQ invisíveis e sem toque no CSB original; três cenários de login).
Servidor aplicado, logs em `build/server-profile-menu.log`.
É necessário reiniciar o cliente para carregar as alterações de Lua.
