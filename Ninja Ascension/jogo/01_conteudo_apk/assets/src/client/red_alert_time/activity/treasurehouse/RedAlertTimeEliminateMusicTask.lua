--------------------------------------------------------------------------------------------------------------
--  说明：消消乐界面2
--------------------------------------------------------------------------------------------------------------
RedAlertTimeEliminateMusicTask = class("RedAlertTimeEliminateMusicTaskClass", Window)

--打开界面
local red_alert_time_eliminate_music_task_open_terminal = {
	_name = "red_alert_time_eliminate_music_task_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeEliminateMusicTaskClass") == nil then
    		fwin:open(RedAlertTimeEliminateMusicTask:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_eliminate_music_task_close_terminal = {
	_name = "red_alert_time_eliminate_music_task_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeEliminateMusicTaskClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_eliminate_music_task_open_terminal)
state_machine.add(red_alert_time_eliminate_music_task_close_terminal)
state_machine.init()

function RedAlertTimeEliminateMusicTask:ctor()
	self.super:ctor()
	self.roots = {}
    self._Image_music_task_arrow_down = nil
    self._Image_music_task_arrow_up = nil

	
    local function init_red_alert_time_eliminate_music_task_terminal()
        local red_alert_time_eliminate_music_task_show_terminal = {
            _name = "red_alert_time_eliminate_music_task_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_eliminate_music_task_hide_terminal = {
            _name = "red_alert_time_eliminate_music_task_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 刷新
        local red_alert_time_eliminate_music_task_updata_terminal = {
            _name = "red_alert_time_eliminate_music_task_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_eliminate_music_task_updata_terminal)
        state_machine.add(red_alert_time_eliminate_music_task_hide_terminal)
        state_machine.add(red_alert_time_eliminate_music_task_show_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_eliminate_music_task_terminal()
end

function RedAlertTimeEliminateMusicTask:updateDraw()
    local root = self.roots[1]
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
	local ListView_music_task_list = ccui.Helper:seekWidgetByName(root,"ListView_eliminate_music_task")
    ListView_music_task_list:removeAllItems()
    local index = 1
    for i=1, #self._activity_type.activity_data[2] do
        local cell = state_machine.excute("red_alert_time_eliminate_music_task_cell_create",0,{self._activity_type.activity_data[2][i] ,self._activity_type.activity_type,i })
        ListView_music_task_list:addChild(cell)
        index = index + 1 
    end
    ListView_music_task_list:requestRefreshView()
    self._list_view = ListView_music_task_list
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

--初始化
function RedAlertTimeEliminateMusicTask:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.eliminate_music_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self._Image_music_task_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_music_task_arrow_down")
    self._Image_music_task_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_music_task_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_music_task_arrow_down:stopAllActions()
    self._Image_music_task_arrow_up:stopAllActions()
    playActions(self._Image_music_task_arrow_down)
    playActions(self._Image_music_task_arrow_up)
    self._Image_music_task_arrow_down:setVisible(false)
    self._Image_music_task_arrow_up:setVisible(false)

    self:updateDraw()
end

function RedAlertTimeEliminateMusicTask:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_music_task_arrow_down:setVisible(true)
        else
            self._Image_music_task_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_music_task_arrow_up:setVisible(true)
        else
            self._Image_music_task_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function RedAlertTimeEliminateMusicTask:onEnterTransitionFinish()

end

function RedAlertTimeEliminateMusicTask:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeEliminateMusicTask:onExit()
    state_machine.remove("red_alert_time_eliminate_music_task_show")
    state_machine.remove("red_alert_time_eliminate_music_task_hide")
    state_machine.remove("red_alert_time_eliminate_music_task_updata")
end