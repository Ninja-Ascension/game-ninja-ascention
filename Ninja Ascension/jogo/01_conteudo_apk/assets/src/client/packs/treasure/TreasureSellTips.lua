-- ----------------------------------------------------------------------------------------------------
-- 说明：宝物出售界面提示框
-- 创建时间：2015-03-19
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

TreasureSellTip = class("TreasureSellTipClass", Window)
   
function TreasureSellTip:ctor()
    self.super:ctor()
	self.showString = ""
	self.roots = {}
	
	self.cacheTextLabel = nil
	
    -- Initialize Home page state machine.
    local function init_treasure_sell_tip_terminal()
		--确定
		local treasure_tip_to_ok_terminal = {
            _name = "treasure_tip_to_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
				--点击确定了 发消息给出售主界面 进行最终确认出售
				state_machine.excute("treasure_sell_excute", 0, "click treasure_sell_excute.")
				--刷新出售主界面是list
				--state_machine.excute("treasure_sell_refresh_list", 0, "click treasure_sell_refresh_list.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回
		local treasure_tip_to_cancel_terminal = {
            _name = "treasure_tip_to_cancel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(treasure_tip_to_ok_terminal)
		state_machine.add(treasure_tip_to_cancel_terminal)

        state_machine.init()
    end
    
    init_treasure_sell_tip_terminal()
end


function TreasureSellTip:onEnterTransitionFinish()
    local csbTreasureSellTip = csb.createNode("packs/EquipStorage/equipment_sell_prompt.csb")
	local action = csb.createTimeline("packs/EquipStorage/equipment_sell_prompt.csb")
	csbTreasureSellTip:runAction(action)
    self:addChild(csbTreasureSellTip)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	local root = csbTreasureSellTip:getChildByName("root")
	table.insert(self.roots, root)
	
	--ccui.Helper:seekWidgetByName(root, "Panel_4"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_5"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_5"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(false)
	
	--缓存TextLabel
	self.cacheTextLabel = ccui.Helper:seekWidgetByName(root, "Text_1")
	
	self:addTouchEventFunc("Button_3", "treasure_tip_to_ok", true)
	self:addTouchEventFunc("Button_4", "treasure_tip_to_cancel", true)
	
	--更新显示区域
	self:updateShowText()
end

function TreasureSellTip:updateShowText()
	if self.cacheTextLabel ~= nil then
		self.cacheTextLabel:setString(self.showString)
	end
end


--通用按钮点击事件添加
function TreasureSellTip:addTouchEventFunc(uiName, eventName, actionMode)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		next_terminal_name = "", 
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = actionMode
	}, 
	nil, 0)
	return tmpArt
end


function TreasureSellTip:onExit()
	state_machine.remove("treasure_tip_to_ok")
	state_machine.remove("treasure_tip_to_cancel")
end

function TreasureSellTip:init(value)
	self.showString = value
end
