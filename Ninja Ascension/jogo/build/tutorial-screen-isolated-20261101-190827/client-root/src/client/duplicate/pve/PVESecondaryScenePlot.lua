-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE 二级战斗 场景上的 剧情 (名将)
-------------------------------------------------------------------------------------------------------
PVESecondaryScenePlot = class("PVESecondaryScenePlotClass", Window)

function PVESecondaryScenePlot:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self.pveSceneID = 0				--场景ID

	
	
	local function init_terminal()
		
		local duplicate_pve_secondary_scene_show_plot_terminal = {
            _name = "duplicate_pve_secondary_scene_show_plot",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:showPlay()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local duplicate_pve_secondary_scene_hide_plot_terminal = {
            _name = "duplicate_pve_secondary_scene_hide_plot",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:hidePlay()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(duplicate_pve_secondary_scene_show_plot_terminal)
		
        state_machine.init()
	end
	
	init_terminal()
	
end

function PVESecondaryScenePlot:showState(isbool)

	self.hideBtn:setVisible(not isbool)
	self.hideBtn:setTouchEnabled(not isbool)
	self.showBtn:setVisible(isbool)
	self.showBtn:setTouchEnabled(isbool)
end

function PVESecondaryScenePlot:showPlay()
	
	local root = self.roots[1]
	local action = self.actions[1]
	
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "juqingjiesao_over" then
        	self:hidePlay()
        end
    end)
    action:play("juqingjiesao_2", false)
	
	self:showState(false)
	
end

function PVESecondaryScenePlot:hidePlay()

	local root = self.roots[1]
	local action = self.actions[1]
	
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "jieqingjiesao_1_over" then
        	self:showState(true)
        end
    end)
	action:play("juqingjiesao_1", false)
end

function PVESecondaryScenePlot:updateAttackTimes()

	ccui.Helper:seekWidgetByName(self.roots[1], "Text_2"):setString(_ED.activity_pve_times[347])

end

function PVESecondaryScenePlot:init(sceneID,currentPageType)
	
	self.sceneID = sceneID
	self.currentPageType = currentPageType
end

function PVESecondaryScenePlot:onEnterTransitionFinish()
	
	local csbPVESecondaryScenePlot = csb.createNode("duplicate/juqingjiesao.csb")
	
	local root = csbPVESecondaryScenePlot:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVESecondaryScenePlot)
	
	local action = csb.createTimeline("duplicate/juqingjiesao.csb")
    table.insert(self.actions, action )
    root:runAction(action)
	
	
	local info = dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.brief_introduction)
	
	ccui.Helper:seekWidgetByName(root, "Text_40_4_4"):setString(info)
	
	self.hideBtn = ccui.Helper:seekWidgetByName(root, "Button_17_4_4")
	fwin:addTouchEventListener(self.hideBtn, nil, 
	{
		terminal_name = "duplicate_pve_secondary_scene_hide_plot", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		isPressedActionEnabled = false,
		sceneID = self.sceneID,
		currentPageType = self.currentPageType
	},
	nil, 0)
	
	self.showBtn = ccui.Helper:seekWidgetByName(root, "Button_8_2_2")
	fwin:addTouchEventListener(self.showBtn, nil, 
	{
		terminal_name = "duplicate_pve_secondary_scene_show_plot", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		isPressedActionEnabled = false,
		sceneID = self.sceneID,
		currentPageType = self.currentPageType
	},
	nil, 0)

	self:showPlay()
	
	
	self:updateAttackTimes()
	

end

function PVESecondaryScenePlot:onExit()
	state_machine.remove("duplicate_pve_secondary_scene_show_plot")
	state_machine.remove("duplicate_pve_secondary_scene_hide_plot")
end

function PVESecondaryScenePlot:createCell()
	local cell = PVESecondaryScenePlot:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
