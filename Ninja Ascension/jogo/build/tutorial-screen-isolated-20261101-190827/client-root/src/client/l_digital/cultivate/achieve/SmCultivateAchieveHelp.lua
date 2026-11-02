-----------------------------
-- 成就规则界面
-----------------------------
SmCultivateAchieveHelp = class("SmCultivateAchieveHelpClass", Window)

local sm_cultivate_achieve_help_open_terminal = {
	_name = "sm_cultivate_achieve_help_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("SmCultivateAchieveHelpClass") == nil then
            debug.print_r(params)
            fwin:open(SmCultivateAchieveHelp:new():init(params), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_cultivate_achieve_help_close_terminal = {
	_name = "sm_cultivate_achieve_help_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCultivateAchieveHelpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_achieve_help_open_terminal)
state_machine.add(sm_cultivate_achieve_help_close_terminal)
state_machine.init()

function SmCultivateAchieveHelp:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.l_digital.cells.cultivate.achieve.sm_cultivate_achieve_help_cell")
end

function SmCultivateAchieveHelp:onUpdateDraw(index)
    local root = self.roots[1]
    local jifen = ccui.Helper:seekWidgetByName(root,"Text_title_jifen")
    jifen:setString(_ED.user_artifact_achieve_all_sorce)

    local list = ccui.Helper:seekWidgetByName(root,"ListView_1")
    list:removeAllItems()
    for i, v in ipairs(dms["achievement_title"]) do
        local params = {}
        params.id = tonumber(dms.int(dms["achievement_title"], i, 1))
        params.name = tonumber(dms.int(dms["achievement_title"], i, 2))
        params.sorce = tonumber(dms.int(dms["achievement_title"], i, 3))
        local cell = state_machine.excute("sm_cultivate_achieve_cell_help",0, {params, tonumber(self.title_id)})
        list:addChild(cell)
    end

    list:requestRefreshView()
    
    for i,v in ipairs(list:getItems()) do
        if tonumber(v.params.id) == tonumber(self.title_id) then
            listviewPositioningMoves(list, i)
        end
    end
end

function SmCultivateAchieveHelp:onUpdate( dt )
    
end

function SmCultivateAchieveHelp:init(params)
    self.title_id = params
	self:onInit()
    return self
end

function SmCultivateAchieveHelp:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_achievement_help.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_cultivate_achieve_help_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function SmCultivateAchieveHelp:onEnterTransitionFinish()
end

function SmCultivateAchieveHelp:onExit()
end
