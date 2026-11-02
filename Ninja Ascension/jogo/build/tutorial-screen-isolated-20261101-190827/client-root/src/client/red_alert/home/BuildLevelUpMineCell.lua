-----------------------------
--浮动详细信息
-----------------------------
BuildLevelUpMineCell = class("BuildLevelUpMineCellClass", Window)
BuildLevelUpMineCell.__size = nil
local build_level_up_mine_cell_window_open_terminal = {
    _name = "build_level_up_mine_cell_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BuildLevelUpMineCellClass") then
            local build_id = params[1]
            local pos = params[2]
            fwin:open(BuildLevelUpMineCell:new():init(build_id,pos), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local build_level_up_mine_cell_window_close_terminal = {
    _name = "build_level_up_mine_cell_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildLevelUpMineCellClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_level_up_mine_cell_window_open_terminal)
state_machine.add(build_level_up_mine_cell_window_close_terminal)
state_machine.init()

function BuildLevelUpMineCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.build_id = nil
end

function BuildLevelUpMineCell:onUpdateDraw()
    local root = self.roots[1]
    local build_name = dms.string(dms["build_mould"],self.build_id,build_mould.build_name)
    local build_dec = dms.string(dms["build_mould"],self.build_id,build_mould.build_dec)
    local Text_build_name = ccui.Helper:seekWidgetByName(root,"Text_build_name")
    Text_build_name:setString(build_name)
    Text_build_name:setColor(cc.c3b(color_Type[4][1],color_Type[4][2],color_Type[4][3]))
    local Text_infor = ccui.Helper:seekWidgetByName(root,"Text_infor")
    Text_infor:setString(build_dec)

end

function BuildLevelUpMineCell:onEnterTransitionFinish()

end

function BuildLevelUpMineCell:onInit( )
    local csbItem = csb.createNode(config_csb.home.build_level_up_mine_cell)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    if BuildLevelUpMineCell.__size == nil then
        BuildLevelUpMineCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_bg"), nil, 
    {
        terminal_name = "build_level_up_mine_cell_window_close", 
        terminal_state = 0,  
    }, nil, 0)

	self:onUpdateDraw()	

end

function BuildLevelUpMineCell:init(build_id,pos)
    self.build_id = build_id
	self:onInit()
    self:setContentSize(BuildLevelUpMineCell.__size)
    local x = math.max(pos.x/ app.scaleFactor,0)
    x = math.min(x,(fwin._width - BuildLevelUpMineCell.__size.width))
    local y = math.max(0,pos.y/ app.scaleFactor)
    y = math.min(y,(fwin._height - BuildLevelUpMineCell.__size.height))
    self:setPosition(cc.p(x,y))
    return self
end

function BuildLevelUpMineCell:onExit()

end
