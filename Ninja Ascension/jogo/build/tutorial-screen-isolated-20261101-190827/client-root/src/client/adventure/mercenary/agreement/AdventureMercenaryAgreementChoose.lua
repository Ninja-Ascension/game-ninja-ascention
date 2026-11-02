-- ----------------------------------------------------------------------------------------------------
-- 说明：选择签订契约--第一步操作
-------------------------------------------------------------------------------------------------------
AdventureMercenaryAgreementChoose = class("AdventureMercenaryAgreementChooseClass", Window)
    
function AdventureMercenaryAgreementChoose:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.hero = nil

    app.load("client.adventure.mercenary.agreement.AdventureMercenaryAgreementChooseList")
    -- Initialize adventure hero awaken state machine.
    local function init_adventure_mercenary_agreement_terminal()
        -- --弹出选择佣兵列表
        local adventure_mercenary_agreement_choose_list_open_terminal = {
            _name = "adventure_mercenary_agreement_choose_list_open",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)                
                local max_num = dms.int(dms["pirates_config"], 331, pirates_config.param)
                
                if zstring.tonumber(_ED.user_info.recruit_count) >= max_num then
                    fwin:open(AdventureMercenaryAgreementChooseList:new():init(), fwin._view)
                else
                    TipDlg.drawTextDailog(_string_piece_info[435])
                end 
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
       
        state_machine.add(adventure_mercenary_agreement_choose_list_open_terminal)

        
        state_machine.init()
    end
    
    -- call func init adventure hero awaken state machine.
    init_adventure_mercenary_agreement_terminal()
end

function AdventureMercenaryAgreementChoose:init(hero)
    -- self.hero = hero
    -- self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    return self
end

function AdventureMercenaryAgreementChoose:updateDraw()
    local root = self.roots[1]

end

function AdventureMercenaryAgreementChoose:onEnterTransitionFinish()
    local csbAdventureHeroAwaken = csb.createNode("packs/Mercenary/yongbing_qiyue_xuanze.csb")
    local root = csbAdventureHeroAwaken:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroAwaken)
    ccui.Helper:seekWidgetByName(root, "Panel_1"):setTouchEnabled(false)
    ccui.Helper:seekWidgetByName(root, "Panel_ybing_bg"):setTouchEnabled(false)
    local Image_Agreement = ccui.Helper:seekWidgetByName(root, "Image_tishi")
    local max_num = dms.int(dms["pirates_config"], 331, pirates_config.param)
    local num_Text = ccui.Helper:seekWidgetByName(root, "Text_tishi_number")
    num_Text:setString("" .. _ED.user_info.recruit_count)

     if zstring.tonumber(_ED.user_info.recruit_count) >= max_num then
        Image_Agreement:setVisible(false)
    else
        Image_Agreement:setVisible(true)
    end 
    --ccui.Helper:seekWidgetByName(root, "root"):setTouchEnabled(false)

    -- 点击选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xzyb"),       nil, 
    {
        terminal_name = "adventure_mercenary_agreement_choose_list_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function AdventureMercenaryAgreementChoose:onExit()
    state_machine.remove("adventure_mercenary_agreement_choose_list_open")
end
