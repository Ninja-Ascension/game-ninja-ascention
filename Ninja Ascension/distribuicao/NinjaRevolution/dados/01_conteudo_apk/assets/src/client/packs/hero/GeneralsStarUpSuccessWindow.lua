-- ----------------------------------------------------------------------------------------------------
-- 说明：角色升品升星成功
-------------------------------------------------------------------------------------------------------
GeneralsStarUpSuccessWindow = class("GeneralsStarUpSuccessWindowClass", Window)

local generals_star_up_success_window_open_terminal = {
    _name = "generals_star_up_success_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("GeneralsStarUpSuccessWindowClass")
        if nil == _homeWindow then
            local panel = GeneralsStarUpSuccessWindow:new():init(params)
            fwin:open(panel,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local generals_star_up_success_window_close_terminal = {
    _name = "generals_star_up_success_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.unlock("sm_role_strengthen_tab_up_product_request", 0, "")
        smFightingChange()
		local _homeWindow = fwin:find("GeneralsStarUpSuccessWindowClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("GeneralsStarUpSuccessWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(generals_star_up_success_window_open_terminal)
state_machine.add(generals_star_up_success_window_close_terminal)
state_machine.init()
    
function GeneralsStarUpSuccessWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    app.load("client.cells.ship.ship_head_new_cell")

    local function init_generals_star_up_success_window_terminal()
        -- 显示界面
        local generals_star_up_success_window_display_terminal = {
            _name = "generals_star_up_success_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local generals_star_up_success_window_hide_terminal = {
            _name = "generals_star_up_success_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- guanbi界面
        local generals_star_up_success_window_close_info_terminal = {
            _name = "generals_star_up_success_window_close_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance.m_type) == 2 then
                    state_machine.excute("sm_role_strengthen_tab_rising_the_stars_fall",0,"")
                    state_machine.excute("generals_star_up_success_window_close",0,"")
                else
                    state_machine.excute("generals_star_up_success_window_close",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(generals_star_up_success_window_display_terminal)
        state_machine.add(generals_star_up_success_window_hide_terminal)
        state_machine.add(generals_star_up_success_window_close_info_terminal)
        
        state_machine.init()
    end
    init_generals_star_up_success_window_terminal()
end

function GeneralsStarUpSuccessWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local animation_name = nil
    local continued_name = nil
    if tonumber(self.m_type) == 1 then
        animation_name = "jinjiechenggong"
        continued_name = "jinjiechenggong2"
    elseif tonumber(self.m_type) == 2 then
        animation_name = "shengxingchenggong"
        continued_name = "shengxingchenggong2"
    end

    local Panel_dh = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_dh")
    Panel_dh:removeAllChildren(true)
    local isOver = false
    local function onFrameEventBullet(bone,evt,originFrameIndex,currentFrameIndex)
        if evt ~= nil and #evt > 0 then
            if evt == "union_10010103" then
                local jsonFile2 = "sprite/effect_10010103.json"
                local atlasFile2 = "sprite/effect_10010103.atlas"
                local animation2 = sp.spine(jsonFile2, atlasFile2, 1, 0, "animation", true, nil)
                animation2:setTag(1205)
                Panel_dh:addChild(animation2)
            elseif evt == "union_10010104" then
                if Panel_dh:getChildByTag(1205) ~= nil then
                    Panel_dh:removeChildByTag(1205)
                end
                if isOver == false then
                    isOver = true
                    local jsonFile3 = "sprite/effect_10010104.json"
                    local atlasFile3 = "sprite/effect_10010104.atlas"
                    local animation3 = sp.spine(jsonFile3, atlasFile3, 1, 0, "animation", true, nil)
                    Panel_dh:addChild(animation3)
                end
            end
        end
    end
    local jsonFile = "sprite/sprite_sjsx.json"
    local atlasFile = "sprite/sprite_sjsx.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
    animation.animationNameList = {animation_name,continued_name}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    animation:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 1, false)
    Panel_dh:addChild(animation)
    

    --头像
    local Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1")
    local Panel_digimon_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_2")
    local cell1 = ShipHeadNewCell:createCell()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        self.OldShip.isformation = false
    end
    cell1:init(self.OldShip,2)
    Panel_digimon_icon_1:addChild(cell1)
    -- local quality = tonumber(self.OldShip.Order)+1
    -- ccui.Helper:seekWidgetByName(cell1, "Panel_kuang"):setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))

    local cell2 = ShipHeadNewCell:createCell()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        self.newShip.isformation = false
    end
    cell2:init(self.newShip,2)
    Panel_digimon_icon_2:addChild(cell2)

    --名称
    local Text_name_1 = ccui.Helper:seekWidgetByName(root, "Text_name_1")
    local Text_name_2 = ccui.Helper:seekWidgetByName(root, "Text_name_2")
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], self.newShip.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local ship_evo = zstring.split(self.newShip.evolution_status, "|")
    local evo_mould_id = smGetSkinEvoIdChange(self.newShip)
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local names = word_info[3]
    if getShipNameOrder(tonumber(self.OldShip.Order)) > 0 then
        Text_name_1:setString(names.." +"..getShipNameOrder(tonumber(self.OldShip.Order)))
    else
        Text_name_1:setString(names)
    end
    if getShipNameOrder(tonumber(self.newShip.Order)) > 0 then
        Text_name_2:setString(names.." +"..getShipNameOrder(tonumber(self.newShip.Order)))
    else
        Text_name_2:setString(names)
    end
    local quality1 = shipOrEquipSetColour(tonumber(self.OldShip.Order))
    local quality2 = shipOrEquipSetColour(tonumber(self.newShip.Order))
    Text_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality1][1], tipStringInfo_quality_color_Type[quality1][2], tipStringInfo_quality_color_Type[quality1][3]))
    Text_name_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality2][1], tipStringInfo_quality_color_Type[quality2][2], tipStringInfo_quality_color_Type[quality2][3]))

    --战力
    local Text_fighting_n_1 = ccui.Helper:seekWidgetByName(root, "Text_fighting_n_1")
    local Text_fighting_n_2 = ccui.Helper:seekWidgetByName(root, "Text_fighting_n_2")
    Text_fighting_n_1:setString(self.OldShip.hero_fight)
    Text_fighting_n_2:setString(self.newShip.hero_fight)

    --速度
    local Text_speed_n_1 = ccui.Helper:seekWidgetByName(root, "Text_speed_n_1") 
    local Text_speed_n_2 = ccui.Helper:seekWidgetByName(root, "Text_speed_n_2") 
    Text_speed_n_1:setString(math.floor(self.OldShip.ship_wisdom))
    Text_speed_n_2:setString(math.floor(self.newShip.ship_wisdom))

    local Text_zdl_1 = ccui.Helper:seekWidgetByName(root, "Text_zdl_1") 
    -- local Image_title_1 = ccui.Helper:seekWidgetByName(root, "Image_title_1") 
    -- local Image_title_2 = ccui.Helper:seekWidgetByName(root, "Image_title_2") 
    local Panel_skill_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon_1") 
    local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name") 
    local Text_skill_info = ccui.Helper:seekWidgetByName(root, "Text_skill_info") 
    Panel_skill_icon_1:removeAllChildren(true)
    Text_skill_name:setString("")
    Text_skill_info:setString("")
    local Panel_jnjs = ccui.Helper:seekWidgetByName(root, "Panel_jnjs")  
    local Panel_queding = ccui.Helper:seekWidgetByName(root, "Panel_queding")  

    if tonumber(self.m_type) == 1 then
        -- Image_title_1:setVisible(false)
        -- Image_title_2:setVisible(true)
        Text_zdl_1:setVisible(false)
        Panel_jnjs:setVisible(false)
        Panel_queding:setVisible(true)
    elseif tonumber(self.m_type) == 2 then              --升星
        -- Image_title_1:setVisible(true)
        -- Image_title_2:setVisible(false)
        Text_zdl_1:setVisible(false)
        Panel_jnjs:setVisible(true)
        Panel_queding:setVisible(false)
        --技能解锁的需求
        local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
        local demands = zstring.split(demandInfo, ",")
        --获取天赋
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], self.newShip.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(self.newShip.evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        --进化的天赋
        local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
        local talentData = zstring.split(talent, "|")

        --技能解锁的需求
        local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
        local demands = zstring.split(demandInfo, ",")
        local isover = false
        for i=1,#demands do
            if tonumber(self.newShip.StarRating) == tonumber(demands[i]) then
                Text_zdl_1:setVisible(true)
                local skillData = zstring.split(talentData[i], ",")
                --天赋模板id
                local talentMouldid = skillData[3]
                local skill_icon = nil
                local pic_index = dms.int(dms["talent_mould"], talentMouldid, talent_mould.new_skill_pic)
                skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
                -- skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", 1))
                skill_icon:setPosition(cc.p(Panel_skill_icon_1:getContentSize().width/2,Panel_skill_icon_1:getContentSize().height/2))
                Panel_skill_icon_1:addChild(skill_icon)

                --名称
                local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name")
                local skillName = skillDescriptionReplaceData(talentMouldid,tonumber(self.newShip.ship_template_id),i,1,false)
                Text_skill_name:setString(skillName)

                --描述
                local Text_skill_info = ccui.Helper:seekWidgetByName(root, "Text_skill_info")
                local skill_describe = skillDescriptionReplaceData(talentMouldid,tonumber(self.newShip.ship_template_id),i,2,false)
                Text_skill_info:setString(skill_describe)

                isover = true
                break
            end
        end
        if isover == false then
            Panel_queding:setVisible(true)    
        end

        if app.configJson.OperatorName == "cayenne" then
            if tonumber(self.newShip.StarRating) == 4 or tonumber(self.newShip.StarRating) == 5 or tonumber(self.newShip.StarRating) == 6 then
                jttd.facebookAPPeventSlogger("10|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|"..tonumber(self.newShip.StarRating))
            end
        end
    end
end

function GeneralsStarUpSuccessWindow:init(params)
    self.OldShip = params[1]
    self.newShip = params[2]
    self.m_type = params[3] --1是武将升品，2是武将升星
    self:onInit()
    return self
end

function GeneralsStarUpSuccessWindow:onInit()
    local csbGeneralsStarUpSuccessWindow = csb.createNode("packs/HeroStorage/generals_star_up_success_window.csb")
    local root = csbGeneralsStarUpSuccessWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbGeneralsStarUpSuccessWindow)
    local action = csb.createTimeline("packs/HeroStorage/generals_star_up_success_window.csb")
    table.insert(self.actions, action)
    csbGeneralsStarUpSuccessWindow:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)

    playEffect(formatMusicFile("effect", 9981))

    action:play("zhankai", false)
	
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Panel_bg"), nil, 
    {
        terminal_name = "generals_star_up_success_window_close_info", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_ok"), nil, 
    {
        terminal_name = "generals_star_up_success_window_close_info", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)

	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    -- {
        -- terminal_name = "red_alert_time_mine_help_info_close",
        -- terminal_state = 0,
    -- },
    -- nil,3)
	
end

function GeneralsStarUpSuccessWindow:onExit()
    state_machine.remove("generals_star_up_success_window_hide")
    state_machine.remove("generals_star_up_success_window_display")
    state_machine.remove("generals_star_up_success_window_close_info")

end