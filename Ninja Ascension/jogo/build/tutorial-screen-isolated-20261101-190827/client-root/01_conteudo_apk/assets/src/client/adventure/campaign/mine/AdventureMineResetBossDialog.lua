-- ----------------------------------------------------------------------------------------------------
-- 说明：重置BOSS确认框
-------------------------------------------------------------------------------------------------------
AdventureMineResetBossDialog = class("AdventureMineResetBossDialogClass", Window)
    
function AdventureMineResetBossDialog:ctor()
    self.super:ctor()
    self.roots = {}
    -- Initialize adventure battle reward state machine.
    local function init_adventure_mine_tip_terminal()
		local adventure_mine_reset_boss_ok_terminal = {
            _name = "adventure_mine_reset_boss_ok",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseResetMineCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.adventure_mine.boss_mineral = nil
                        _ED.adventure_mine.boss_mineral = {}
                        state_machine.excute("adventure_mine_reset_boss_update_draw",0,0)
                        state_machine.excute("adventure_mine_manager_mine_boss_count_update",0,0)
                    end
                    fwin:close(fwin:find("AdventureMineResetBossDialogClass"))
                end
                NetworkManager:register(protocol_command.mine_monster_reset.code, nil, nil, nil, cell, responseResetMineCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		
		state_machine.add(adventure_mine_reset_boss_ok_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_mine_tip_terminal()
end

function AdventureMineResetBossDialog:init()
	return self
end

function AdventureMineResetBossDialog:onUpdateDraw()
	local root = self.roots[1]
	local Text_141 = ccui.Helper:seekWidgetByName(root, "Text_sjsm")

    local array_num = zstring.split(dms.string(dms["pirates_config"], 330, pirates_config.param),",")
    local num_consume = 1

    if _ED.adventure_mine.boss_reset_count >= #array_num then
        num_consume = array_num[#array_num]
    else
        num_consume = array_num[_ED.adventure_mine.boss_reset_count + 1]
    end
	Text_141:setString(string.format(_string_piece_info[412],num_consume))
end

function AdventureMineResetBossDialog:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("campaign/Mining/wakuang_boss_shuaxin.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
	self:onUpdateDraw()
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineResetBossDialogClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineResetBossDialogClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	--确定刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shuaxin"), nil, 
    {
        terminal_name = "adventure_mine_reset_boss_ok", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

end

function AdventureMineResetBossDialog:onExit()
    state_machine.remove("adventure_mine_reset_boss_ok")
end