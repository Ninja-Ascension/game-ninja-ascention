-- ----------------------------------------------------------------------------------------------------
-- 说明：道具使用提示
-------------------------------------------------------------------------------------------------------
AdventurePropUseTip = class("AdventurePropUseTipClass", Window)
    
function AdventurePropUseTip:ctor()
    self.super:ctor()
    self.roots = {}
	self.prop_id = nil
    self.prop_name = nil
    self.prop_template_id = nil
    -- Initialize adventure battle reward state machine.
    local function init_adventure_prop_use_tip_terminal()
		local adventure_prop_use_ok_terminal = {
            _name = "adventure_prop_use_ok",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseUsePropCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
                        
                        state_machine.excute("adventure_prop_storage_update_prop",0,0)
                        if tonumber(instance.prop_template_id) == 334 then 
                            TipDlg.drawTextDailog(_string_piece_info[406])
                            if _ED.adventure_mine.mine_data ~= "-1" then
                                cc.UserDefault:getInstance():setStringForKey(getKey("mine_data"), _ED.adventure_mine.mine_data or "")
                            end
                            state_machine.excute("adventure_mine_reset_update_draw", 0, 0)
                        end
                        if tonumber(instance.prop_template_id) == 332 then
                            TipDlg.drawTextDailog(_string_piece_info[407])
                        end

                    end
                    fwin:close(self)
                end
				protocol_command.prop_use.param_list = self.prop_id.."\r\n" .. 1
                NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, cell, responseUsePropCallback,true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		
		state_machine.add(adventure_prop_use_ok_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_prop_use_tip_terminal()
end

function AdventurePropUseTip:init(propId,propName,templateid)
    self.prop_id = propId
    self.prop_name = propName
    self.prop_template_id = templateid
	return self
end

function AdventurePropUseTip:onUpdateDraw()
	local root = self.roots[1]
	local Text_141 = ccui.Helper:seekWidgetByName(root, "Text_141")
    local str = nil
    if tonumber(self.prop_template_id) == 334 then 
        --矿区
        str = string.format(_string_piece_info[410], self.prop_name)
    else
        --天空神殿
        str = string.format(_string_piece_info[411], self.prop_name)
    end
	Text_141:setString(str)
end

function AdventurePropUseTip:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("utils/prompt_1.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
	self:onUpdateDraw()
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventurePropUseTipClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	--确定使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), nil, 
    {
        terminal_name = "adventure_prop_use_ok", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

end

function AdventurePropUseTip:onExit()

end