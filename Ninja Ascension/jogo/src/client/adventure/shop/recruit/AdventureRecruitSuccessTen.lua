-- ----------------------------------------------------------------------------------------------------
-- 说明：十次招募成功
-------------------------------------------------------------------------------------------------------
AdventureRecruitSuccessTen = class("AdventureRecruitSuccessTenClass", Window)
    
function AdventureRecruitSuccessTen:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.drawCount = 1
    self.hero = nil
    self.heros = {}


    fwin:close(fwin:find("AdventureRecruitSuccessTenClass"))

    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
    app.load("client.adventure.packs.hero.AdventureHeroInformation")

    -- Initialize adventure recruit success ten state machine.
    local function init_adventure_recruit_success_ten_terminal()
        -- 显示招募成功界面
        local adventure_recruit_success_ten_show_terminal = {
            _name = "adventure_recruit_success_ten_show",
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
        -- 关闭
        local adventure_recruit_close_ten_show_terminal = {
            _name = "adventure_recruit_close_ten_show",
            _init = function (terminal)
                app.load("client.adventure.system.share.AdventureShareDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                 if missionIsOver() == true  then 
                    local heroName = "" 
                    for k,v in pairs(self.heros) do
                        if tonumber(v.ship_type + 1) >= 5 then 
                            local handbook = _ED.hero_handbook["" .. v.ship_template_id]
                            if handbook ~= nil and handbook.is_new ~= true then
                            else
                                if heroName == "" then
                                    heroName = v.captain_name
                                else
                                    heroName = heroName..","..v.captain_name
                                end
                            end
                        end
                    end
                    local heroNames = string.format(_share_text[1],heroName)
                    if heroName ~= "" then 
                        state_machine.excute("adventure_open_share_dialog",0,heroNames)
                    end
                end 
                fwin:close(fwin:find("AdventureRecruitSuccessTenClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_recruit_success_ten_show_terminal)
        state_machine.add(adventure_recruit_close_ten_show_terminal)
        
        state_machine.init()
    end

    
    -- call func init adventure recruit success ten state machine.
    init_adventure_recruit_success_ten_terminal()
end

function AdventureRecruitSuccessTen:init()
    self.heros = {}

    local heroIds = zstring.split(_ED.recruit_success_ship_ids, ",")
    _ED.recruit_success_ship_id = ""
    _ED.recruit_success_ship_ids = ""
    --print(" ---------------------,",#heroIds)
    for i, v in pairs(heroIds) do
        local hero = _ED.user_ship["" .. v] or {ship_template_id = 1}
        table.insert(self.heros, hero)
    end
    return self
end

function AdventureRecruitSuccessTen:show()
    local root = self.roots[1]
    self:setVisible(true)
    --print(" ==== self drawCount ,",self.drawCount)
    local heroCount = #self.heros
    --print(" ---------------------,",heroCount,self.drawCount)
    if self.drawCount > heroCount then
       
        _ED.recruit_success_ship_id = ""
        _ED.recruit_success_ship_ids = ""
        -- 关闭
        local Panel_zhaomu = ccui.Helper:seekWidgetByName(root, "Panel_zhaomu")
        Panel_zhaomu:setTouchEnabled(true)
        fwin:addTouchEventListener(Panel_zhaomu,       nil, 
        {
            terminal_name = "adventure_recruit_close_ten_show",   
            terminal_state = 0, 
            isPressedActionEnabled = false
        }, 
        nil, 2)

    else
        local action = self.actions[1]
        action:play("started_appear_hero_" .. self.drawCount, false)
    end
end

function AdventureRecruitSuccessTen:onEnterTransitionFinish()
    self.roots = {}
    self.actions = {}

    local csbAdventureRecruitSuccessTen = csb.createNode("shop/heroshop/heroshop_buy_result.csb")
    local root = csbAdventureRecruitSuccessTen:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecruitSuccessTen)
    local heroCount = #self.heros
    --print("显示动画长度:",heroCount)

    local action = csb.createTimeline("shop/heroshop/heroshop_buy_result.csb")
    table.insert(self.actions, action)
     
    csbAdventureRecruitSuccessTen:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "started_appear_over" then
            self.actions[1]:play("started_appear_hero_1", false)
            --print(" ---------------------ssss,",heroCount,self.drawCount)
        else
            local params = zstring.split(str, "_")
            --debug.print_r(params)
            if params[5] == "start" then

                self.drawCount = tonumber(params[4])
                self.hero = self.heros[self.drawCount]
                local cell = AdventureHeroIconCell:createCell()

                ccui.Helper:seekWidgetByName(root, "Panel_hero_" .. params[4]):removeAllChildren(true)
                cell:init(1, self.hero, 1, 0, nil, nil, nil, nil, 0)
                ccui.Helper:seekWidgetByName(root, "Panel_hero_" .. params[4]):addChild(cell)
                pushEffect(formatMusicFile("effect", 511))
            elseif params[5] == "over" then
                self.actions[1]:stop()
                ccui.Helper:seekWidgetByName(root, "Panel_"..self.drawCount):getChildByName("ArmatureNode_"..self.drawCount):setVisible(false) 
                    
                local handbook = _ED.hero_handbook["" .. self.hero.ship_template_id]

                if handbook ~= nil and handbook.is_new == true then
                    ccui.Helper:seekWidgetByName(root, "Image_new_"..self.drawCount):setVisible(true) 
                else
                    ccui.Helper:seekWidgetByName(root, "Image_new_"..self.drawCount):setVisible(false) 
                end
                self.drawCount = self.drawCount + 1
                local handbook = _ED.hero_handbook["" .. self.hero.ship_template_id]
                self:show()
                -- if handbook ~= nil and handbook.is_new ~= true then
                --    -- state_machine.excute("adventure_recruit_success_ten_show", 0, 0)
                -- else
        
                --     --local ship_type = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ship_type)
                --      self:show()

                --     -- if ship_type >= 3 or true then
                --     --     --self:setVisible(false)
                        
                --     --    -- fwin:open(AdventureHeroInformation:new():init(self.hero), fwin._ui)
                --     -- else
                --     --     self:show()
                --     -- end
                -- end
            end
        end
    end)
     for i = 1,10 do
        if i <= heroCount then 
            local BackGroundImageName = string.format("images/ui/icon/icon_recruit_blood_diamond_%d.png",self.heros[i].ship_type+1)
            local juan =  ccui.Helper:seekWidgetByName(root, string.format("Panel_juan_%d",i))
            juan:setBackGroundImage(BackGroundImageName)
            juan:setVisible(true)
        end
    end

    self.actions[1]:play("started_appear", false)
    for i = 1,10 do
        local panel = ccui.Helper:seekWidgetByName(root, string.format("Panel_%d",i))

        if i <= heroCount then 
            panel:setVisible(true)
        else 
            panel:setVisible(false)
        end
    end
end

function AdventureRecruitSuccessTen:onExit()
    state_machine.remove("adventure_recruit_success_ten_show")
end

    -- 创建招募的动画
    -- for i = 1, 10 do
            
    --      -- 替换背景动画
    --     if i <= heroCount then 
    --         local BackGroundImageName = string.format("images/ui/icon/icon_recruit_blood_diamond_%d.png",self.heros[i].ship_type+1)
    --         local juan =  ccui.Helper:seekWidgetByName(root, string.format("Panel_juan_%d",i))
    --         juan:setBackGroundImage(BackGroundImageName)
    --         juan:setVisible(true)
    --         local action = csb.createTimeline("shop/heroshop/heroshop_buy_result.csb")
    --         table.insert(self.actions, action)
     
    --         csbAdventureRecruitSuccessTen:runAction(action)
    --         action:setFrameEventCallFunc(function (frame)
    --             if nil == frame then
    --                 return
    --             end

    --             local str = frame:getEvent()
    --             if str == "started_appear_over" then
    --                 self.actions[self.drawCount]:play("started_appear_hero_1", false)
    --             else
    --                 local params = zstring.split(str, "_")
    --                 if params[5] == "start" then
    --                     self.drawCount = tonumber(params[4])
    --                     self.hero = self.heros[self.drawCount]
    --                     local cell = AdventureHeroIconCell:createCell()
    --                     cell:init(0, self.hero, 1, 0, nil, nil, nil, nil, 0)
    --                     ccui.Helper:seekWidgetByName(root, "Panel_hero_" .. params[4]):addChild(cell)
    --                     pushEffect(formatMusicFile("effect", 511))
    --                 elseif params[5] == "over" then
    --                     ccui.Helper:seekWidgetByName(root, "Panel_"..self.drawCount):getChildByName("ArmatureNode_"..self.drawCount):setVisible(false) 
    --                     self.drawCount = self.drawCount + 1
    --                     local handbook = _ED.hero_handbook["" .. self.hero.ship_template_id]
    --                     if handbook ~= nil and handbook.is_new ~= true then
    --                         -- if self.drawCount <= 10 then
    --                         --     -- self.actions[self.drawCount]:play("started_appear_hero_" .. self.drawCount, false)
    --                         --     self:show()
    --                         -- end
    --                         self:show()
    --                     else
    --                         local ship_type = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ship_type)
    --                         if ship_type >= 3 or true then
    --                             self:setVisible(false)
    --                             app.load("client.adventure.packs.hero.AdventureHeroInformation")
    --                             fwin:open(AdventureHeroInformation:new():init(self.hero), fwin._ui)
    --                         -- elseif self.drawCount <= 10 then
    --                         else
    --                             -- self.actions[self.drawCount]:play("started_appear_hero_" .. self.drawCount, false)
    --                             self:show()
    --                         end
    --                     end
    --                 end
    --             end
    --         end)
    --     end        
    -- end