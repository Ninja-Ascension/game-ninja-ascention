-- ----------------------------------------------------------------------------------------------------
-- 说明：宝石招募功能界面
-------------------------------------------------------------------------------------------------------
AdventureRecruitWithGold = class("AdventureRecruitWithGoldClass", Window)
    
function AdventureRecruitWithGold:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure recruit state machine.
    local function init_adventure_recruit_terminal()
        -- 单次宝石招募
        local adventure_recruit_with_gold_one_terminal = {
            _name = "adventure_recruit_with_gold_one",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function recruitSuccessCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- print("单次宝石招募成功")
                        fwin:close(fwin:find("AdventureRecruitWithGoldClass"))
                        app.load("client.adventure.shop.recruit.AdventureRecruitSuccess")
                        fwin:open(AdventureRecruitSuccess:new():init(), fwin._ui)
                    end
                end

                _ED.recruit_success_ship_id = ""
                _ED.recruit_success_ship_ids = ""
                protocol_command.ship_bounty.param_list = "3"
                NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, nil, recruitSuccessCallBack, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 十次宝石招募
        local adventure_recruit_with_gold_ten_terminal = {
            _name = "adventure_recruit_with_gold_ten",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function recruitSuccessCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- print("十次宝石招募成功")
                        fwin:close(fwin:find("AdventureRecruitWithGoldClass"))
                        app.load("client.adventure.shop.recruit.AdventureRecruitSuccessTen")
                        fwin:open(AdventureRecruitSuccessTen:new():init(), fwin._ui)
                    end
                end
                
                _ED.recruit_success_ship_id = ""
                _ED.recruit_success_ship_ids = ""
                protocol_command.ship_batch_bounty.param_list = "4"
                NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, nil, recruitSuccessCallBack, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_recruit_with_gold_one_terminal)
        state_machine.add(adventure_recruit_with_gold_ten_terminal)
        state_machine.init()
    end
    
    -- call func init adventure recruit state machine.
    init_adventure_recruit_terminal()
end

function AdventureRecruitWithGold:init()
	return self
end

function AdventureRecruitWithGold:onEnterTransitionFinish()
	local csbAdventureRecruitWithGold = csb.createNode("shop/heroshop/heroshop_xuezhuan.csb")
    local root = csbAdventureRecruitWithGold:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecruitWithGold)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureRecruitWithGoldClass"))]],
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 单次宝石招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_8"),       nil, 
    {
        terminal_name = "adventure_recruit_with_gold_one",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 十次宝石招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_8_0"),       nil, 
    {
        terminal_name = "adventure_recruit_with_gold_ten",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureRecruitWithGold:onExit()
    state_machine.remove("adventure_recruit_with_gold_one")
    state_machine.remove("adventure_recruit_with_gold_ten")
end