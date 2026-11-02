--点击道具使用显示的详细信息

PropuseInformation = class("PropHeadInformationClass", Window)	

function PropuseInformation:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.current_type = 0
	self.rewardType = nil
	
	local function init_use_prop_terminal()
	
	
        local use_props_terminal = {
            _name = "use_props_button",
            _init = function (terminal)
             end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(use_props_terminal)
        state_machine.init()
    end
    init_use_prop_terminal()
end
	



function PropuseInformation:updateDraw()
	local root = self.roots[1]
	
	--取图
	app.load("client.cells.utils.resources_icon_cell")
	local tempCell = ResourcesIconCell:createCell()
	tempCell:init(nil,nil,nil,self.rewardType)
	-- tempCell:init(0, 0, 0, {show_reward_list={{prop_type = self.rewardType.show_reward_type, item_value = self.rewardType.show_reward_item_count}}})
	--> print("-==-=-=--==--============================================================3211111111111")
	local iconPanel = ccui.Helper:seekWidgetByName(root, "Panel_huode_2")
	iconPanel:addChild(tempCell)
	-- fwin:open(tempCell, fwin._ui)
end


function PropuseInformation:onEnterTransitionFinish()
	local csbPropStorage = csb.createNode("refinery/refinery_fenjiefanhuan_1.csb")
	local root = csbPropStorage:getChildByName("root")
	
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("refinery/refinery_fenjiefanhuan_1.csb")
	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbPropStorage:runAction(action)
	 action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "exit" then 
            state_machine.excute("use_props_button", 0, "change to 'AssetsManagerEx'")
			fwin:close(self)
			--> print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        end
    end)
	self:addChild(csbPropStorage)
	self:updateDraw()
end


function PropuseInformation:init(rewardType)

	self.rewardType = rewardType
	--> print("=====================00000000000",rewardType)
end

function PropuseInformation:onExit()
	-- state_machine.remove("use_props_button")
	
end

