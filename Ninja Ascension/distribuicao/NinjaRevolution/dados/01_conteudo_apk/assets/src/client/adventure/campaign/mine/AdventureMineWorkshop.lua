-- ----------------------------------------------------------------------------------------------------
-- 说明：矿区工坊
-------------------------------------------------------------------------------------------------------
AdventureMineWorkshop = class("AdventureMineWorkshopClass", Window)
    
function AdventureMineWorkshop:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.adventure.cells.mine.adventure_mine_workshop_cell")
	self.workshoplist = nil
    -- Initialize adventure mine workshop state machine.
    local function init_adventure_mine_workshop_terminal()
		-- 刷新工坊工程
        local adventure_mine_workshop_update_listview_terminal = {
            _name = "adventure_mine_workshop_update_listview",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_mine_workshop_update_listview_terminal)
		
        state_machine.init()
    end
    
    -- call func init adventure mine workshop state machine.
    init_adventure_mine_workshop_terminal()
end

function AdventureMineWorkshop:init()

	return self
end

function AdventureMineWorkshop:onUpdateDraw()
	local root = self.roots[1]
	local config = zstring.split(dms.string(dms["pirates_config"], 300, pirates_config.param), ",")
	self.workshoplist:removeAllItems()
	for i=1, #config do
		local cell = AdventureMineWorkshopCell:createCell()
		cell:init(i)
		self.workshoplist:addChild(cell)
	end
	ccui.Helper:seekWidgetByName(root, "Text_chutou"):setString(_ED.user_info.endurance.."/".._ED.user_info.max_endurance)
	local targetNumber = 0
	for i, v in pairs(_ED.user_prop) do
		if zstring.tonumber(v.user_prop_template) == 303 then
			targetNumber = zstring.tonumber(v.prop_number)
			break	
		end
	end
	ccui.Helper:seekWidgetByName(root, "Text_number"):setString("x"..targetNumber)
	local mineData = zstring.split(cc.UserDefault:getInstance():getStringForKey(getKey("mine_data")), "|")
	ccui.Helper:seekWidgetByName(root, "Text_sd"):setString((#mineData-1))
end

function AdventureMineWorkshop:onEnterTransitionFinish()
	local csbAdventureMineWorkshop = csb.createNode("campaign/Mining/wakang_kuangqugongfang.csb")
    local root = csbAdventureMineWorkshop:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMineWorkshop)
	self.workshoplist = ccui.Helper:seekWidgetByName(root, "ListView_gongfang")
	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineWorkshopClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureMineWorkshop:onExit()
    
end