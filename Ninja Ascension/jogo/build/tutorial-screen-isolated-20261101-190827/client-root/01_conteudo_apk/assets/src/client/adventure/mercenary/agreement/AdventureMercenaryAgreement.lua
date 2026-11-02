-- ----------------------------------------------------------------------------------------------------
-- 说明：契约界面
-------------------------------------------------------------------------------------------------------
AdventureMercenaryAgreement = class("AdventureMercenaryAgreementClass", Window)
    
function AdventureMercenaryAgreement:ctor()
    self.super:ctor()
    self.roots = {}

    -- self.equip = nil
    -- self.fouceCell = nil
    -- self.selectCell = nil
    self.chooseType = 1

    app.load("client.adventure.mercenary.agreement.AdventureMercenaryAgreementChoose")
    app.load("client.adventure.mercenary.agreement.AdventureMercenaryAgreementContract")
    app.load("client.adventure.utils.AdventureHookAgreementInfoSee")

    -- Initialize adventure mercenary equipment fate state machine.
    local function init_adventure_mercenary_agreement_terminal()
        --打开选择契约界面,一级界面
        local adventure_mercenary_agreement_open_choose_terminal = {
            _name = "adventure_mercenary_agreement_open_choose",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryAgreementChoose:new():init(), fwin._view)
                -- local root = self.roots[1]
                -- print("-----:",root)
                -- -- local view1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
                -- view1:setVisible(true)
                --local view = AdventureMercenaryAgreementChoose:new():init()
                --view1:addChild(view,4)
                instance.chooseType = 1
                --fwin:close(fwin:find("AdventureMercenaryAgreementContractClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
     
        --打开签订界面
        local adventure_mercenary_agreement_open_contract_terminal = {
            _name = "adventure_mercenary_agreement_open_contract",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        
                fwin:open(AdventureMercenaryAgreementContract:new():init(params), fwin._ui)
                instance.chooseType = 2
                fwin:close(fwin:find("AdventureMercenaryAgreementChooseClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭契约界面
        local adventure_mercenary_agreement_close_terminal = {
            _name = "adventure_mercenary_agreement_close",
            _init = function (terminal)
                app.load("client.adventure.mercenary.agreement.AdventureMercenaryAgreementChooseList") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.chooseType == 1 then 
                    fwin:close(fwin:find("AdventureMercenaryAgreementClass"))
                    fwin:close(fwin:find("AdventureMercenaryAgreementChooseClass"))
                    fwin:close(fwin:find("AdventureMercenaryAgreementContractClass"))
                else
                    fwin:open(AdventureMercenaryAgreementChoose:new():init(), fwin._view)
                    fwin:close(fwin:find("AdventureMercenaryAgreementContractClass"))
                    fwin:open(AdventureMercenaryAgreementChooseList:new():init(), fwin._view)
                end
                instance.chooseType = 1
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_mercenary_agreement_open_choose_terminal)
        state_machine.add(adventure_mercenary_agreement_open_contract_terminal)
        state_machine.add(adventure_mercenary_agreement_close_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure mercenary equipment fate state machine.
    init_adventure_mercenary_agreement_terminal()
end

function AdventureMercenaryAgreement:init()
    return self
end

function AdventureMercenaryAgreement:initListView()
   
end

function AdventureMercenaryAgreement:updateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_9")
    Panel_role:removeAllChildren(true)
    Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(_ED.user_info.user_head) + 500))
    --ccui.Helper:seekWidgetByName(root, "Text_12_0_0") 契约等级
    ccui.Helper:seekWidgetByName(root, "Text_exp_0"):setString("" .. _ED.user_info.contract_exp)

    local index_exp = 1

    for i=1,31 do
        local exp_value =dms.int(dms["contract_grade_param"], i, contract_grade_param.upgrade_need_exp)
        if i == 31 then 
            index_exp = i
        end
        if exp_value > _ED.user_info.contract_exp then
            if i == 1 then 
                index_exp = i 
            else
                index_exp = i -1 
            end
            break 
        end 
    end
    local leavel_value = dms.int(dms["contract_grade_param"],index_exp,contract_grade_param.contract_level)
    ccui.Helper:seekWidgetByName(root, "Text_12_0_0"):setString("Lv" .. leavel_value)
end

function AdventureMercenaryAgreement:onUpdateAgreementTip(show)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if show == true then 
        local Tip_Text = ccui.Helper:seekWidgetByName(root, "Text_17_0")
        if _ED.user_info.contract_exp == 0  then 
            Tip_Text:setString(tipStringInfo_hero_agreement_states[14])
        else
            Tip_Text:setString(string.format(tipStringInfo_hero_agreement_states[16],_ED.user_info.contract_exp))
        end 
    end
    ccui.Helper:seekWidgetByName(root, "Image_24"):setVisible(show)
end

function AdventureMercenaryAgreement:onEnterTransitionFinish()
    local csbAdventureAgreement = csb.createNode("packs/Mercenary/yongbing_qiyue.csb")
    local root = csbAdventureAgreement:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureAgreement)
    ccui.Helper:seekWidgetByName(root, "Panel_ybing_bg"):setTouchEnabled(false)
    self:updateDraw()
    -- 创建顶部列表窗口
   -- self:initListView()

     local function formationTouchListener(sender, eventType)
        
        if eventType == ccui.TouchEventType.began then
            --self:onUpdateAgreementTip(true)
            local layer =  ccui.Helper:seekWidgetByName(root, "Panel_11")
            if layer ~= nil then 
                fwin:open(AdventureAgreementInfoSee:new():init(layer), fwin._ui)    
            end
        elseif eventType == ccui.TouchEventType.moved then 
        else 
            --self:onUpdateAgreementTip(false)
            fwin:close(fwin:find("AdventureAgreementInfoSeeClass"))
        end
    end
    local layer =  ccui.Helper:seekWidgetByName(root, "Panel_11")
    layer:setTouchEnabled(true)
    layer:addTouchEventListener(formationTouchListener)


    state_machine.excute("adventure_mercenary_agreement_open_choose", 0, "")
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10"),       nil, 
    {
        terminal_name = "adventure_mercenary_agreement_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureMercenaryAgreement:onExit()
    state_machine.remove("adventure_mercenary_agreement_open_choose")
    state_machine.remove("adventure_mercenary_agreement_open_contract")
    state_machine.remove("adventure_mercenary_agreement_close")
end
