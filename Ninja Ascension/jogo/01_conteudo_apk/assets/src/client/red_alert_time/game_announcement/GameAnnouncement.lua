--------------------------------------------------------------------------------------------------------------
--  说明：公告
--------------------------------------------------------------------------------------------------------------
GameAnnouncement = class("GameAnnouncementClass", Window)

--打开界面
local game_announcement_window_open_terminal = {
	_name = "game_announcement_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        -- Sin tablon no hay cartel: "" y "0" son "ningun aviso" igual
        -- que nil. El "" lo deja el propio troceo del sobre cuando el
        -- S2C 999 viene sin texto (utils.lua:197-230) y el "0" es el
        -- centinela del servidor; los hermanos de esta misma casa ya lo
        -- miran asi (AnnouncePage.lua:172, InStall.lua:374).
        -- Y se devuelve SIEMPRE el panel de login: quien lo escondio fue
        -- login.lua:1844 antes de pedir el tablon, y solo lo recupera el
        -- onExit de esta ventana. Saliendo por aqui sin devolverlo el
        -- jugador se queda sin boton de entrar.
        -- state_machine.excute devuelve nil si el terminal no existe:
        -- eso es "no estamos en el login", y ahi si toca el aviso de
        -- "no hay anuncios" del boton de dentro del juego.
        if _ED.system_notice_ex == nil or _ED.system_notice_ex == ""
            or _ED.system_notice_ex == "0" then
            if state_machine.excute("login_ui_control", 0, true) == nil then
                TipDlg.drawTextDailog(game_share_tip_text[4])
            end
            return
        end
		if nil == fwin:find("GameAnnouncementClass") then
			fwin:open(GameAnnouncement:new():init(),fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local game_announcement_window_close_terminal = {
	_name = "game_announcement_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GameAnnouncementClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(game_announcement_window_open_terminal)
state_machine.add(game_announcement_window_close_terminal)
state_machine.init()

function GameAnnouncement:ctor()
	self.super:ctor()
	self.roots = {}
    -- 左边列表
    self._left_list = nil    
    -- 右边列表
    self._right_list = nil
    -- 标题
    self._title_table = {}
    -- 内容
    self._notice_table = {}

    self.chooseLeftIndex = 0

    self._system_notice_table = nil

    -- load lua file
    app.load("client.red_alert_time.cells.game_announcement.game_announcement_cell")
    app.load("client.red_alert_time.cells.game_announcement.game_announcement_list_one")

    local function init_game_announcement_terminal()

        local game_announcement_select_left_once_terminal = {
            _name = "game_announcement_select_left_once",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeLeftSelectState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local game_announcement_select_right_once_terminal = {
            _name = "game_announcement_select_right_once",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeRightSelect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(game_announcement_close_terminal)
        state_machine.add(game_announcement_select_left_once_terminal)
        state_machine.add(game_announcement_select_right_once_terminal)
        state_machine.init()
    end
    init_game_announcement_terminal()
end

function GameAnnouncement:updateSystemNoticeInfo()
    self._system_notice_table = {}

    local systemNotice = zstring.split(_ED.system_notice_ex,"\\r\\n|") --格式化的内容
    local nCount = 10000
    local nIndex = 1
    while true do
        nCount = nCount - 1
        if nCount < 0 then
            break
        end
        local notice_info = {}
        notice_info.title = systemNotice[nIndex]
        notice_info.isNew = systemNotice[nIndex + 1]
        notice_info.nType = systemNotice[nIndex + 2]
        notice_info.titleImage = systemNotice[nIndex + 3]
        notice_info.content = systemNotice[nIndex + 4]

        if notice_info.title == nil or notice_info.isNew == nil or notice_info.nType == nil or notice_info.titleImage == nil or notice_info.content == nil then
            break
        end
        table.insert(self._system_notice_table, notice_info)
        nIndex = nIndex + 5
    end
end

function GameAnnouncement:updateDraw()
    local root = self.roots[1]

    self:updateSystemNoticeInfo()

    for k, v in pairs(self._system_notice_table) do
        local title = v.title
        local content = v.content
        table.insert(self._title_table,title)
        table.insert(self._notice_table,content)
    end

    self:onUpdateLeftDraw()
end


function GameAnnouncement:changeLeftSelectState( selectedIndex )
    local root = self.roots[1]
    if self.chooseLeftIndex == selectedIndex then
        return
    end
    self.chooseLeftIndex = selectedIndex
    local items = self._left_list:getItems()
    for i, v in pairs(items) do
        v:changeSelectedState(i == self.chooseLeftIndex)
    end
    local Text_act_title_name = ccui.Helper:seekWidgetByName(root,"Text_act_title_name")
    for i,v in pairs(self._title_table) do
        if i == self.chooseLeftIndex then
            Text_act_title_name:setString(v)
        end
    end
    self:onUpdateRightDraw(self.chooseLeftIndex)
end

function GameAnnouncement:onUpdateLeftDraw()
    local root = self.roots[1]
    local game_announcement_push = cc.UserDefault:getInstance():getStringForKey("game_announcement_push")
    game_announcement_push = zstring.split(game_announcement_push,"|||")
    for i,v in pairs(self._title_table) do
        local is_open = true
        local notice = zstring.exchangeTo(self._notice_table[i])
        for k,v1 in pairs(game_announcement_push) do
            if notice == v1 then
                is_open = false
            end
        end
        local cell_left = state_machine.excute("game_announcement_list_one_create",0,{v,i,is_open,self._notice_table})
        self._left_list:addChild(cell_left)
    end
    self._left_list:requestRefreshView()
    self:changeLeftSelectState(1)
end

function GameAnnouncement:changeRightSelect( index )
    local items = self._right_list:getItems()
    local lastHeight = 0
    for k,v in pairs(items) do
        v:setPositionY(lastHeight)
        lastHeight = lastHeight + v:getContentSize().height
    end
    self._right_list:requestRefreshView()
    
    if index >= #items then
        local function delatEnd()
            self._right_list:getInnerContainer():setPositionY(0)
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(delatEnd)))
    end
end

function GameAnnouncement:onUpdateRightDraw(chooseLeftIndex)
    local root = self.roots[1]
    self._right_list:removeAllItems()
    local test = 0
    local title_infor = "" 
    for k,v in pairs(self._notice_table) do
        if k == chooseLeftIndex then 
            local heightAndContent = zstring.split(v, "///")  
            local each_content = zstring.split(heightAndContent[2], "//")
            local index = 0 
            for i, str in pairs(each_content) do
                local splitStrForContent = zstring.split(str, "%/!")
                local temp_string = splitStrForContent[1]
                title_infor = title_infor .. temp_string
                -- title_infor = title_infor .. "/r/n"
            end
        end
    end
    local cell_right = state_machine.excute("game_announcement_create_cell",0,{title_infor})
    self._right_list:addChild(cell_right)
    
    self._cell_height = cell_right:getContentSize().height
    self._right_list:jumpToTop()
    self._right_list:requestRefreshView()
end

function GameAnnouncement:onInit()
    local csbItem = csb.createNode(config_csb.game_announcement.game_announcement)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self._left_list = ccui.Helper:seekWidgetByName(root, "ListView_2")    --左边列表
    self._right_list = ccui.Helper:seekWidgetByName(root, "ListView_1")     --右边列表

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "game_announcement_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "game_announcement_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:updateDraw()
end

function GameAnnouncement:onEnterTransitionFinish()

end

function GameAnnouncement:init()
	self:onInit()
    return self
end

function GameAnnouncement:onExit()
   state_machine.excute("login_ui_control", 0, true)
end