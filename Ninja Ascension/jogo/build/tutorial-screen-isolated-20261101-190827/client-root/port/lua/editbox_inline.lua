-- port/lua/editbox_inline.lua — digitacao dentro do jogo, sem a caixa do Windows.
--
-- No Axmol/Windows, ccui.EditBox abre um controle EDIT nativo (retangulo
-- branco) por cima do jogo enquanto o jogador digita. Aqui cada EditBox criado
-- pelo jogo (todos passam por ccui.EditBox:create) ganha um ccui.TextField da
-- propria engine por cima: o jogador ve o texto na fonte/cor do jogo com o
-- cursor "|" piscando. O EditBox continua sendo a fonte da verdade para o
-- jogo: getText(), o handler registrado ("began/changed/ended/return"),
-- senha e limite de caracteres sao mantidos.
local M = {}

local estados = setmetatable({}, { __mode = "k" })   -- edit -> estado
local INPUT_FLAG_PASSWORD = 0                         -- EditBox::InputFlag::PASSWORD

local function chamar(estado, evento, edit)
    if estado.handler then pcall(estado.handler, evento, edit) end
end

local function cor(c, a)
    return cc.c4b(c.r or 255, c.g or 255, c.b or 255, a)
end

local original = {}

function M.instalar(edit, tamanho)
    if estados[edit] or not ccui.TextField then return end
    local largura, altura = tamanho.width or 200, tamanho.height or 30
    local campo = ccui.TextField:create("", "Arial", math.max(12, math.floor(altura * 0.55)))
    campo:setAnchorPoint(cc.p(0, 0.5))
    campo:setPosition(cc.p(6, altura / 2))
    campo:setTouchAreaEnabled(true)
    campo:setTouchSize(cc.size(largura, altura))
    campo:setCursorEnabled(true)
    campo:setTextColor(cc.c4b(255, 255, 255, 255))
    campo:setPlaceHolderColor(cc.c4b(160, 160, 160, 255))
    edit:addChild(campo, 100)
    -- O toque no proprio EditBox abriria o controle nativo; quem recebe e o campo.
    edit:setTouchEnabled(false)
    local estado = { campo = campo }
    estados[edit] = estado

    campo:addEventListener(function(_, evento)
        local tipos = ccui.TextFiledEventType
        if evento == tipos.attach_with_ime then
            chamar(estado, "began", edit)
            -- draw:addEditBoxEx (display.lua) desloca o EditBox ao comecar a
            -- editar (espaco para o teclado do celular; com _label, para fora
            -- da tela). No PC o campo fica onde esta.
            if edit._position then edit:setPosition(edit._position) end
            edit:setVisible(true)
            if edit._label then
                edit._label:setVisible(false)
                campo:setString(edit:getText())
            end
        elseif evento == tipos.insert_text or evento == tipos.delete_backward then
            original.setText(edit, campo:getString())
            chamar(estado, "changed", edit)
        elseif evento == tipos.detach_with_ime then
            original.setText(edit, campo:getString())
            chamar(estado, "ended", edit)
            chamar(estado, "return", edit)
            if edit._label then edit._label:setVisible(true) end
        end
    end)
    -- Rotulos proprios do EditBox ficam transparentes: o campo e quem desenha.
    original.setFontColor(edit, cor(edit:getFontColor(), 0))
    original.setPlaceholderFontColor(edit, cor(edit:getPlaceholderFontColor(), 0))
end

function M.campo(edit)
    local estado = estados[edit]
    return estado and estado.campo
end

function M.armar()
    local classe = rawget(_G, "ccui") and ccui.EditBox
    if classe == nil or classe.__nr_inline or ccui.TextField == nil then return false end
    classe.__nr_inline = true
    for _, nome in ipairs({ "create", "setText", "setFont", "setFontName", "setFontSize", "setFontColor",
                            "setPlaceholderFontColor", "setPlaceHolder", "setInputFlag", "setMaxLength",
                            "registerScriptEditBoxHandler", "openKeyboard" }) do
        original[nome] = classe[nome]
    end

    classe.create = function(cls, tamanho, ...)
        local edit = original.create(cls, tamanho, ...)
        if edit and tamanho then pcall(M.instalar, edit, tamanho) end
        return edit
    end
    classe.registerScriptEditBoxHandler = function(self, fn, ...)
        local estado = estados[self]
        if estado then estado.handler = fn end
        return original.registerScriptEditBoxHandler(self, fn, ...)
    end
    classe.setText = function(self, texto, ...)
        local campo = M.campo(self)
        if campo then campo:setString(texto or "") end
        return original.setText(self, texto, ...)
    end
    classe.setFont = function(self, nome, tamanho, ...)
        local campo = M.campo(self)
        if campo then
            if nome and nome ~= "" then campo:setFontName(nome) end
            if tamanho then campo:setFontSize(tamanho) end
        end
        return original.setFont(self, nome, tamanho, ...)
    end
    classe.setFontName = function(self, nome, ...)
        local campo = M.campo(self)
        if campo and nome and nome ~= "" then campo:setFontName(nome) end
        return original.setFontName(self, nome, ...)
    end
    classe.setFontSize = function(self, tamanho, ...)
        local campo = M.campo(self)
        if campo and tamanho then campo:setFontSize(tamanho) end
        return original.setFontSize(self, tamanho, ...)
    end
    classe.setFontColor = function(self, c, ...)
        local campo = M.campo(self)
        if campo and c then
            campo:setTextColor(cor(c, 255))
            return original.setFontColor(self, cor(c, 0), ...)
        end
        return original.setFontColor(self, c, ...)
    end
    classe.setPlaceholderFontColor = function(self, c, ...)
        local campo = M.campo(self)
        if campo and c then
            campo:setPlaceHolderColor(cor(c, 255))
            return original.setPlaceholderFontColor(self, cor(c, 0), ...)
        end
        return original.setPlaceholderFontColor(self, c, ...)
    end
    classe.setPlaceHolder = function(self, texto, ...)
        local campo = M.campo(self)
        if campo then campo:setPlaceHolder(texto or "") end
        return original.setPlaceHolder(self, texto, ...)
    end
    classe.setInputFlag = function(self, flag, ...)
        local campo = M.campo(self)
        if campo and flag == INPUT_FLAG_PASSWORD then
            campo:setPasswordEnabled(true)
            campo:setPasswordStyleText("*")
        end
        return original.setInputFlag(self, flag, ...)
    end
    classe.setMaxLength = function(self, n, ...)
        local campo = M.campo(self)
        if campo and n and n > 0 then
            campo:setMaxLengthEnabled(true)
            campo:setMaxLength(n)
        end
        return original.setMaxLength(self, n, ...)
    end
    -- Quem pede o teclado (paineis do AccountSysManager, ver account_ui.lua)
    -- passa a ativar a digitacao dentro do jogo.
    classe.openKeyboard = function(self, ...)
        local campo = M.campo(self)
        if campo then return campo:attachWithIME() end
        return original.openKeyboard(self, ...)
    end
    print("HOST_EDITBOX_INLINE digitacao dentro do jogo ativa (sem caixa nativa do Windows)")
    return true
end

return M
