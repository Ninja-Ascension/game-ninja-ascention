-- ---------------------------
-- 服务器提示
-- ---------------------------
ServerPrompt = class("ServerPromptClass", Window)

local server_prompt_create_terminal = {
    _name = "server_prompt_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("server_prompt_close", 0, nil)
        fwin:open(ServerPrompt:new():init(params), fwin._notification)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local server_prompt_close_terminal = {
    _name = "server_prompt_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        fwin:close(fwin:find("ServerPromptClass"))
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            fwin:close(fwin:find("ConnectingViewClass"))
        end
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(server_prompt_create_terminal)
state_machine.add(server_prompt_close_terminal)
state_machine.init()

function ServerPrompt:ctor()
    self.super:ctor()
    self.roots = {}

    self._tick_time = 0
    self._Text_server_time_n = nil
end

function ServerPrompt:onEnterTransitionFinish()
    
end

function ServerPrompt:onUpdateDraw(params)
    local root = self.roots[1]
    local Text_server_time_title = ccui.Helper:seekWidgetByName(root, "Text_server_time_title")
    local Text_server_time_infor = ccui.Helper:seekWidgetByName(root, "Text_server_time_infor")
    self._Text_server_time_n = ccui.Helper:seekWidgetByName(root, "Text_server_time_n")
    Text_server_time_title:setString(params[1])
    --Text_server_time_infor:setString(params[2])
    Text_server_time_infor:setString("")
    Text_server_time_infor:removeAllChildren(true)
    local texts_info = zstring.split(params[2], "/r/n")
    local index = 0
    for i=1,#texts_info do
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        _richText:setContentSize(cc.size(Text_server_time_infor:getContentSize().width, 0))
        _richText:setAnchorPoint(cc.p(0, 0))
        local char_str = texts_info[i]
        local baseColor = cc.c3b(189, 206, 224)
        if __lua_project_id == __lua_project_l_naruto then
            baseColor = chat_rich_text_color[8]
        end
        if  __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            baseColor = cc.c3b(71, 71, 71)
        end
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
            char_str, 
            baseColor,
            baseColor,
            0, 
            0, 
            Text_server_time_infor:getFontName(), 
            20,
            chat_rich_text_color)
        _richText:formatTextExt()
        local rsize = _richText:getContentSize()
        _richText:setPositionX(0)
        _richText:setPositionY(Text_server_time_infor:getContentSize().height-index)
        Text_server_time_infor:addChild(_richText)
        index = index + rsize.height
    end
    self._tick_time = tonumber(params[3])
    if self._tick_time <= 0 then
        state_machine.excute("server_prompt_close", 0, nil)
    else
        self._Text_server_time_n:setString(getRedAlertTimeActivityFormat(self._tick_time))
    end
end

function ServerPrompt:onUpdate( dt )
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    self._tick_time = self._tick_time - dt
    if self._tick_time <= 0 then
        fwin:addService({
            callback = function ( params )
                state_machine.excute("server_prompt_close", 0, nil)
            end,
            delay = 0.3,
            params = self
        })
    else
        self._Text_server_time_n:setString(getRedAlertTimeActivityFormat(self._tick_time))
    end
end

function ServerPrompt:onInit(params)
    local csbItem = csb.createNode(config_csb.utils.prompt_server_time)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "server_prompt_close", 
        terminal_state = 0, 
    }, nil, 0)  
    
    self:onUpdateDraw(params)
end

function ServerPrompt:onExit()
end

function ServerPrompt:init(params)
    self:onInit(params)
    return self
end