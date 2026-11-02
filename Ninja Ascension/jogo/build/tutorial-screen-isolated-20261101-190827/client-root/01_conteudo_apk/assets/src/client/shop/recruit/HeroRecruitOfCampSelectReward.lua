--------------------------------------------------------------------------------------------------------------
--  说明：阵营招募选择奖励界面
--------------------------------------------------------------------------------------------------------------
HeroRecruitOfCampSelectReward = class("HeroRecruitOfCampSelectRewardClass", Window)


local hero_recruit_of_camp_select_reward_open_terminal = {
    _name = "hero_recruit_of_camp_select_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("hero_recruit_of_camp_select_reward_open")
        local reward_window = HeroRecruitOfCampSelectReward:new()
        reward_window:init()
        fwin:open(reward_window,fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local hero_recruit_of_camp_select_reward_close_terminal = {
    _name = "hero_recruit_of_camp_select_reward_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitOfCampSelectRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_recruit_of_camp_select_reward_open_terminal)
state_machine.add(hero_recruit_of_camp_select_reward_close_terminal)
state_machine.init()
function HeroRecruitOfCampSelectReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.params = nil
    self.selectIndex = -1
    self.shipIdOne = 0
    self.shipIdTwo = 0
	app.load("client.cells.ship.ship_head_cell")
	 -- Initialize union duplicate seat machine.
    local function init_hero_recruit_of_camp_reward_terminal()
		--打开界面
        -- -- 选择要领取的物品
        local hero_recruit_of_camp_select_reward_select_terminal = {
            _name = "hero_recruit_of_camp_select_reward_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.selectIndex = params._datas.selectIndex

                local but_bgImage = nil
                if terminal.page_name ~= nil then
                    but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end
                end
                terminal.page_name = params._datas.but_image
                but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                if but_bgImage ~= nil then
                    but_bgImage:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- -- 领取物品
        local hero_recruit_of_camp_select_reward_request_terminal = {
            _name = "hero_recruit_of_camp_select_reward_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                if mcell.selectIndex < 0 then
                    TipDlg.drawTextDailog(_string_piece_info[304])
                    return
                end
                local config = zstring.split(dms.string(dms["pirates_config"], 295, pirates_config.param), ",")
                if tonumber(config[1]) > _ED.user_bounty_info.integral  then
                    TipDlg.drawTextDailog(tipStringInfo_camp_recruitment_str[3])
                    return
                end
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            response.node:rewadDraw(index)             
                            state_machine.excute("hero_recruit_of_camp_select_reward_close", 0, "")
                            state_machine.excute("hero_recruit_of_camp_refresh", 0, "")
                        end 
                    end
                end
                if TipDlg.drawStorageTipo() == false then
                    local shipid = 0
                    if mcell.selectIndex == 1 then
                        shipid =mcell.shipIdOne
                    else
                        shipid= mcell.shipIdTwo
                    end
                    protocol_command.partner_bounty_get_reward.param_list = ""..mcell.selectIndex.."\r\n"..shipid
                    NetworkManager:register(protocol_command.partner_bounty_get_reward.code, nil, nil, nil, mcell, responseGetServerListCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(hero_recruit_of_camp_select_reward_select_terminal)
        state_machine.add(hero_recruit_of_camp_select_reward_request_terminal)
        state_machine.init()
    end
    -- call func init union duplicate seat machine.
    init_hero_recruit_of_camp_reward_terminal()

end

function HeroRecruitOfCampSelectReward:rewadDraw( ... )
    app.load("client.reward.DrawRareReward")
    local getRewardWnd = DrawRareReward:new()
    getRewardWnd:init(7)
    fwin:open(getRewardWnd, fwin._ui)
end

function HeroRecruitOfCampSelectReward:updateDraw()
    local root =self.roots[1]
    if root == nil then
        return 
    end
    local mounld = _ED.user_bounty_typeid 
    local datas =  dms.element(dms["partner_bounty"], mounld)
    local shipIds = zstring.split(dms.atos(datas, partner_bounty.ship_mould),",")

    self.shipIdOne = tonumber(shipIds[1])
    self.shipIdTwo = tonumber(shipIds[2])
    local rewardPad1 = ccui.Helper:seekWidgetByName(root, "Panel_21")
    local cell1 = ShipHeadCell:createCell()
    cell1:init(nil, cell1.enum_type._DUPLICATE, tonumber(shipIds[1]), 1, true)
    rewardPad1:addChild(cell1)

    local rewardPad2 = ccui.Helper:seekWidgetByName(root, "Panel_22")
    local cell2 = ShipHeadCell:createCell()
    cell2:init(nil, cell2.enum_type._DUPLICATE, tonumber(shipIds[2]), 1, true)
    rewardPad2:addChild(cell2)
end



function HeroRecruitOfCampSelectReward:onInit()
    
    local HeroRecruitOfCampSelectReward = csb.createNode("utils/select_award_tow.csb") 
    local root = HeroRecruitOfCampSelectReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(HeroRecruitOfCampSelectReward)

	self:updateDraw()


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_02"),       nil, 
    {
        terminal_name = "hero_recruit_of_camp_select_reward_select",     
        but_image = "Image_39",
        terminal_state = 0, 
        cell = self,
        selectIndex = 1,
        isPressedActionEnabled = false
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_03"),       nil, 
    {
        terminal_name = "hero_recruit_of_camp_select_reward_select",     
        but_image = "Image_40",
        terminal_state = 0, 
        cell = self,
        selectIndex = 2,
        isPressedActionEnabled = false
    }, 
    nil, 0)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10_4"), nil, 
    {
        terminal_name = "hero_recruit_of_camp_select_reward_request", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11_6"), nil, 
    {
        terminal_name = "hero_recruit_of_camp_select_reward_close", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.unlock("hero_recruit_of_camp_select_reward_open")
end



function HeroRecruitOfCampSelectReward:onEnterTransitionFinish()

end

function HeroRecruitOfCampSelectReward:init()
	self:onInit()
	return self
end

function HeroRecruitOfCampSelectReward:onExit()
    state_machine.remove("hero_recruit_of_camp_select_reward_select")
    state_machine.remove("hero_recruit_of_camp_select_reward_request")
end