--------------------------------------------------------------------------------------------------------------
--  说明：将领简介
--------------------------------------------------------------------------------------------------------------
LeaderSynopsisWindow = class("LeaderSynopsisWindowClass", Window)

--打开界面
local leader_synopsis_window_window_open_terminal = {
	_name = "leader_synopsis_window_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("LeaderSynopsisWindowClass") == nil then
    		fwin:open(LeaderSynopsisWindow:new():init(params), fwin._ui)
        else
            state_machine.excute("leader_synopsis_window_show",0,"")
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local leader_synopsis_window_window_close_terminal = {
	_name = "leader_synopsis_window_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderSynopsisWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(leader_synopsis_window_window_open_terminal)
state_machine.add(leader_synopsis_window_window_close_terminal)
state_machine.init()

function LeaderSynopsisWindow:ctor()
	self.super:ctor()
	self.roots = {}

    self._ship_id = nil
    self._info = nil 

    local function init_leader_synopsis_window_terminal()
        --显示所有
        local leader_synopsis_window_show_terminal = {
            _name = "leader_synopsis_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local leader_synopsis_window_hide_terminal = {
            _name = "leader_synopsis_window_hide",
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
        state_machine.add(leader_synopsis_window_show_terminal)    
        state_machine.add(leader_synopsis_window_hide_terminal) 
        state_machine.init()
    end
    init_leader_synopsis_window_terminal()
end

function LeaderSynopsisWindow:updateDraw()
    local root = self.roots[1]
    local ship_info = dms.element(dms["ship_mould"], self._ship_id)
    -- icon
    local Panel_leader_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_icon")
    Panel_leader_icon:removeAllChildren(true)
    local prop_id = zstring.split(dms.atos(ship_info, ship_mould.screen_attack_effect), ",")
    local cell = state_machine.excute("props_icon_create_cell",0,{2,3,self._ship_id,3})
    Panel_leader_icon:addChild(cell)

    -- name
    local Text_leader_name = ccui.Helper:seekWidgetByName(root, "Text_leader_name")
    local captain_name = dms.atos(ship_info, ship_mould.captain_name)
    local ship_type =  dms.atoi(ship_info, ship_mould.ship_type)
    Text_leader_name:setString(captain_name)
    Text_leader_name:setColor(cc.c3b(color_Type[ship_type+1][1],color_Type[ship_type+1][2],color_Type[ship_type+1][3]))

    -- 国籍
    local Text_leader_synopsis_nationality_n = ccui.Helper:seekWidgetByName(root, "Text_leader_synopsis_nationality_n")
    local skill_name = dms.atos(ship_info, ship_mould.skill_name)
    Text_leader_synopsis_nationality_n:setString(skill_name)

    -- 特点
    local Text_leader_characteristic_n = ccui.Helper:seekWidgetByName(root, "Text_leader_characteristic_n")
    local skill_describe = dms.atos(ship_info, ship_mould.skill_describe)   
    Text_leader_characteristic_n:setString(skill_describe)       

    -- 描述
    local Text_leader_synopsis_infor = ccui.Helper:seekWidgetByName(root, "Text_leader_synopsis_infor")
    local introduce = dms.atos(ship_info, ship_mould.introduce)  
    Text_leader_synopsis_infor:setString(introduce)       
end

function LeaderSynopsisWindow:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_synopsis_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor_close"), nil, 
    {
        terminal_name = "leader_synopsis_window_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_synopsis_sure"), nil, 
    {
        terminal_name = "leader_synopsis_window_window_close", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "leader_synopsis_window_window_close", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        -- touch_black = true,
    }, nil, 1)

    self:updateDraw()
end

function LeaderSynopsisWindow:onEnterTransitionFinish()

end

function LeaderSynopsisWindow:init(params)
    self._ship_id = params[1]
    self._info = params[2]
	self:onInit(params)
    return self
end

function LeaderSynopsisWindow:onExit()
    state_machine.remove("leader_synopsis_window_show")
    state_machine.remove("leader_synopsis_window_hide")
end