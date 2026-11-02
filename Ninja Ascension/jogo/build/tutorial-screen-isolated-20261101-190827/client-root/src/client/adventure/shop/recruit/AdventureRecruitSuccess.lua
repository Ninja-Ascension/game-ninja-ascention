-- ----------------------------------------------------------------------------------------------------
-- 说明：单次招募成功
-------------------------------------------------------------------------------------------------------
AdventureRecruitSuccess = class("AdventureRecruitSuccessClass", Window)
    
function AdventureRecruitSuccess:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.hero = nil

    fwin:close(fwin:find("AdventureRecruitSuccessClass"))

    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")

    -- Initialize adventure recruit success state machine.
    local function init_adventure_recruit_success_terminal()
        -- 显示招募成功界面
        local adventure_recruit_success_show_terminal = {
            _name = "adventure_recruit_success_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:show()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --关闭
        local adventure_close_recruit_show_terminal = {
            _name = "adventure_close_recruit_show",
            _init = function (terminal)
                app.load("client.adventure.system.share.AdventureShareDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if missionIsOver() == true and tonumber(self.hero.ship_type+1) >= 5 then 
                    --开始
                    
                    local heroName = string.format(_share_text[1],self.hero.captain_name)
                    
                    state_machine.excute("adventure_open_share_dialog",0,heroName)
                end 
                fwin:close(fwin:find("AdventureRecruitSuccessClass"))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_recruit_success_show_terminal)
        state_machine.add(adventure_close_recruit_show_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure recruit success state machine.
    init_adventure_recruit_success_terminal()
end

function AdventureRecruitSuccess:init()
    self.hero = _ED.user_ship["".._ED.recruit_success_ship_id] or {ship_template_id = 1}
    
    return self
end

function AdventureRecruitSuccess:show()
    local root = self.roots[1]
    self:setVisible(true)
    _ED.recruit_success_ship_id = ""
    _ED.recruit_success_ship_ids = ""
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_zhaomu"),       nil, 
    {
        terminal_name = "adventure_close_recruit_show",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 2)
end

function AdventureRecruitSuccess:onEnterTransitionFinish()
    local csbAdventureRecruitSuccess = csb.createNode("shop/heroshop/heroshop_buy_result.csb")
    local root = csbAdventureRecruitSuccess:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecruitSuccess)
    -- 替换背景动画
    local BackGroundImageName = string.format("images/ui/icon/icon_recruit_blood_diamond_%d.png"
        ,self.hero.ship_type+1)
    ccui.Helper:seekWidgetByName(root, "Panel_juan_1"):setBackGroundImage(BackGroundImageName)
    -- 创建招募的动画
    local action = csb.createTimeline("shop/heroshop/heroshop_buy_result.csb")
    table.insert(self.actions, action)
    csbAdventureRecruitSuccess:runAction(action)
    pushEffect(formatMusicFile("effect", 511))
    
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "juan_1_over" then
            -- 绘制图标
            local cell = AdventureHeroIconCell:createCell()
            ccui.Helper:seekWidgetByName(root, "Panel_hero_1"):removeAllChildren(true)
            cell:init(0, self.hero, 1, 0, nil, nil, nil, nil, 0)
            ccui.Helper:seekWidgetByName(root, "Panel_hero_1"):addChild(cell)
        elseif str == "hero_1_over" then
        
            ccui.Helper:seekWidgetByName(root, "Panel_1"):getChildByName("ArmatureNode_1"):setVisible(false)

            local handbook = _ED.hero_handbook["" .. self.hero.ship_template_id]
            if handbook ~= nil and handbook.is_new ~= true then
                state_machine.excute("adventure_recruit_success_show", 0, 0)
                ccui.Helper:seekWidgetByName(root, "Image_new_1"):setVisible(false) 
            else
                ccui.Helper:seekWidgetByName(root, "Image_new_1"):setVisible(true) 
                local ship_type = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ship_type)
                if ship_type >= 3 or true then
                    self:setVisible(false)
                    app.load("client.adventure.packs.hero.AdventureHeroInformation")
                    local Window1 = fwin:find("AdventureArenaWarcraftClass")
                    local Window2 = fwin:find("AdventureArenaWarcraftListClass")
                    if Window1 ~=nil or Window2 ~= nil then 
                        --
                        fwin:open(AdventureHeroInformation:new():init(self.hero), fwin._windows)
                    else
                        fwin:open(AdventureHeroInformation:new():init(self.hero), fwin._ui)
                    end
                    
                end
            end
        end
    end)
    action:play("hero_1", false)
end

function AdventureRecruitSuccess:onExit()
    state_machine.remove("adventure_recruit_success_show")
    state_machine.remove("adventure_close_recruit_show")
end