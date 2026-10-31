-- ----------------------------------------------------------------------------------------------------
-- 说明：角色信息界面控件4
-------------------------------------------------------------------------------------------------------
SmRoleInformationControlsFour = class("SmRoleInformationControlsFourClass", Window)
SmRoleInformationControlsFour.__size = nil

local sm_role_information_controls_four_open_terminal = {
    _name = "sm_role_information_controls_four_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local cell = SmRoleInformationControlsFour:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_information_controls_four_close_terminal = {
    _name = "sm_role_information_controls_four_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationControlsFourClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleInformationControlsFourClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_information_controls_four_open_terminal)
state_machine.add(sm_role_information_controls_four_close_terminal)
state_machine.init()
    
function SmRoleInformationControlsFour:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0--模板id
    self.user_ship_id = 0--实例id
    app.load("client.shop.recruit.SmGeneralsCard")
    local function init_sm_role_information_controls_four_terminal()
        -- 显示界面
        local sm_role_information_controls_four_display_terminal = {
            _name = "sm_role_information_controls_four_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsFourWindow = fwin:find("SmRoleInformationControlsFourClass")
                if SmRoleInformationControlsFourWindow ~= nil then
                    SmRoleInformationControlsFourWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_information_controls_four_hide_terminal = {
            _name = "sm_role_information_controls_four_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsFourWindow = fwin:find("SmRoleInformationControlsFourClass")
                if SmRoleInformationControlsFourWindow ~= nil then
                    SmRoleInformationControlsFourWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看技能信息
        local sm_role_information_look_skill_infor_terminal = {
            _name = "sm_role_information_look_skill_infor",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenTabSkillDescription")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas._index
                local shipInfo = nil
                if instance.isMould == true then
                    shipInfo = {}
                    shipInfo.ship_template_id = instance.ship_id
                    shipInfo.evolution_status = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.captain_name)
                    shipInfo.skillLevel = "1,1,1,1,1,1"
                    shipInfo.StarRating = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.ship_star)
                else
                    if zstring.tonumber(self.m_type) == -1 then
                        shipInfo = _ED.other_user_ship
                    else
                        shipInfo = _ED.user_ship[""..instance.user_ship_id]
                    end
                    
                end
                -- 模板Id
                local ship_id = instance.ship_template_id
                --进化形象
                local evo_image = dms.string(dms["ship_mould"], ship_id, ship_mould.fitSkillTwo)
                local evo_info = zstring.split(evo_image, ",")
                --进化模板id
                local evo_mould_id = nil
                if instance.isMould == true then
                    evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship_id, ship_mould.captain_name)]
                else
                    evo_mould_id = smGetSkinEvoIdChange(shipInfo)
                    if zstring.tonumber(shipInfo.skin_id) ~= 0 then
                        evo_mould_id = dms.int(dms["ship_skin_mould"], shipInfo.skin_id, ship_skin_mould.ship_evo_id)
                    end
                end
                --进化的天赋
                local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
                local talentData = zstring.splits(talent, "|",",")

                if instance.user_ship_id ~= nil and instance.user_ship_id ~= "" and instance.user_ship_id ~= 0 then
                    local isusemega = false
                    talentData,isusemega = ReplaceMegaSkill(talentData, instance.user_ship_id)
                end

                --天赋模板id
                local talentMouldid = talentData[index][3]
                state_machine.excute("sm_role_strengthen_tab_skill_description_open",0,{shipInfo,talentMouldid,index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_information_controls_four_display_terminal)
        state_machine.add(sm_role_information_controls_four_hide_terminal)
        state_machine.add(sm_role_information_look_skill_infor_terminal)
        state_machine.init()
    end
    init_sm_role_information_controls_four_terminal()
end

function SmRoleInformationControlsFour:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipData = nil
    local ship_id = self.ship_id
    if zstring.tonumber(self.m_type) == -1 then
        shipData = _ED.other_user_ship
        ship_id = shipData.ship_template_id
    else
        if self.isMould == true then
            ship_id = self.ship_id
        else
            for i, v in pairs(_ED.user_ship) do
                if tonumber(v.ship_template_id) == tonumber(self.ship_id) then
                    shipData = v
                    ship_id = shipData.ship_template_id
                    self.user_ship_id = fundShipWidthTemplateId(ship_id).ship_id
                    break
                end
            end
        end
    end
    
    --获取天赋
    --进化形象
    self.ship_template_id = ship_id
    local evo_image = dms.string(dms["ship_mould"], ship_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = nil
    if shipData == nil then
        evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship_id, ship_mould.captain_name)]
    else
        local ship_evo = zstring.split(shipData.evolution_status, "|")
        evo_mould_id = smGetSkinEvoIdChange(shipData)
        if zstring.tonumber(shipData.skin_id) ~= 0 then
            evo_mould_id = dms.int(dms["ship_skin_mould"], shipData.skin_id, ship_skin_mould.ship_evo_id)
        end

    end
    --进化的天赋
    local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
    local talentData = zstring.splits(talent, "|",",")

    if self.user_ship_id ~= nil and self.user_ship_id ~= "" and self.user_ship_id ~= 0 then
        local isusemega = false
        talentData,isusemega = ReplaceMegaSkill(talentData, self.user_ship_id)
    end

    --技能解锁的需求
    local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
    local demands = zstring.split(demandInfo, ",")

    --技能等级
    local skillAllLevel = nil
    if shipData == nil then
        skillAllLevel = zstring.split("1,1,1,1,1,1", ",")
    else
        skillAllLevel = zstring.split(shipData.skillLevel, ",")
    end

    for i=1,6 do
        --天赋模板id
        local talentMouldid = talentData[i][3]
        local isReal = true
        --画技能图标
        local Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon_"..i)
        Panel_skill_icon:removeAllChildren(true)
        Panel_skill_icon:setSwallowTouches(false)
        local skill_icon = nil
        local pic_index = dms.int(dms["talent_mould"], talentMouldid, talent_mould.new_skill_pic)
        skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
        --测试临时的图,正式的时候换成上面的代码
        -- skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", i))
        if skill_icon ~= nil then
            skill_icon:setPosition(cc.p(Panel_skill_icon:getContentSize().width/2,Panel_skill_icon:getContentSize().height/2))
            Panel_skill_icon:addChild(skill_icon)
        end
        --技能名称
        local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name_"..i)
        local skillNameId = dms.int(dms["talent_mould"], talentMouldid, talent_mould.talent_name)
        local word_info = dms.element(dms["word_mould"], skillNameId)
        local skillName = word_info[3]
        skillName = skillDescriptionReplaceData(talentMouldid,ship_id,i,1,false)
        Text_skill_name:setString(skillName)

        --技能解锁说明
        local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip_"..i)
        --技能等级
        local Text_skill_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_lv_"..i)
        
        Text_skill_lv:setString(_new_interface_text[30]..skillAllLevel[i])
        --技能锁定图标
        local Image_locking = ccui.Helper:seekWidgetByName(root, "Image_locking_"..i)
        local StarRating = 0 
        if shipData == nil then
            StarRating = dms.int(dms["ship_mould"], ship_id, ship_mould.ship_star)  
        else
            StarRating = shipData.StarRating
        end
        if tonumber(StarRating) >= tonumber(demands[i]) then
            Image_locking:setVisible(false)
            Text_tip:setString("")
            if skill_icon ~= nil then
                display:ungray(skill_icon)
            end
        else
            Image_locking:setVisible(true)
            Text_tip:setString(string.format(_new_interface_text[7],zstring.tonumber(demands[i])))
            if skill_icon ~= nil then
                display:gray(skill_icon)
            end
            Text_skill_lv:setString("")
        end
    end
end

function SmRoleInformationControlsFour:init(params)
    --模板id
    self.ship_id = params[1]
    self.isMould = params[2]
    self.m_type = params[3] or nil
    self:onInit()
    return self
end

function SmRoleInformationControlsFour:onInit()
    local csbSmRoleInformationControlsFour = csb.createNode("packs/HeroStorage/sm_generals_information_4.csb")
    local root = csbSmRoleInformationControlsFour:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleInformationControlsFour)
	if SmRoleInformationControlsFour.__size == nil then
        SmRoleInformationControlsFour.__size = root:getContentSize()
    end

    for i = 1 , 6 do 
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_skill_icon_"..i), nil, 
        {
            terminal_name = "sm_role_information_look_skill_infor", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            _index = i,
        }, 
        nil, 0)
    end
    self:onUpdateDraw()
end

function SmRoleInformationControlsFour:onExit()
    state_machine.remove("sm_role_information_controls_four_display")
    state_machine.remove("sm_role_information_controls_four_hide")
    -- state_machine.remove("sm_role_information_look_skill_infor")
end