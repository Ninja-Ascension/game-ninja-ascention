-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛圣物属性信息
-------------------------------------------------------------------------------------------------------
FileIslandHolyCellInfo = class("FileIslandHolyCellInfoClass", Window)

local FileIslandHolyCellInfo_open_terminal = {
    _name = "FileIslandHolyCellInfo_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("FileIslandHolyCellInfoClass")
        if nil == _homeWindow then
            local panel = FileIslandHolyCellInfo:new():init(params)
            fwin:open(panel, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(FileIslandHolyCellInfo_open_terminal)
state_machine.init()
    
function FileIslandHolyCellInfo:ctor()
    self.roots = {}

    local FileIslandHolyCellInfo_close_terminal = {
        _name = "FileIslandHolyCellInfo_close",
        _init = function (terminal) 
        
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local _homeWindow = fwin:find("FileIslandHolyCellInfoClass")
            if nil ~= _homeWindow then
                fwin:close(fwin:find("FileIslandHolyCellInfoClass"))

                local cell = params._datas.cell
                state_machine.excute("fileIsland_holy_cell_icon_hide_select_anim", 0, {cell = cell}) 
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    
    state_machine.add(FileIslandHolyCellInfo_close_terminal)
    state_machine.init()
end

function FileIslandHolyCellInfo:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end


end

function FileIslandHolyCellInfo:init(params)
    self.data = params or {}
    self:onInit()
    return self
end

function FileIslandHolyCellInfo:onInit()
    local node = csb.createNode("campaign/explore/explore_friend_infor.csb")
    local root = node:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(node)

    self:onUpdateDraw()

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_5"), nil, 
    {
        terminal_name = "FileIslandHolyCellInfo_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self.data.cell
    }, 
    nil, 0)
	
end

function FileIslandHolyCellInfo:onExit()
    state_machine.remove("FileIslandHolyCellInfo_close") 
end