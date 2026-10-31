--------------------------------------------------------------------------------------------------------------
--  说明：时装页界面
--------------------------------------------------------------------------------------------------------------
FashionInformationPage = class("FashionInformationPageClass", Window)

--打开界面
local fashion_information_page_open_terminal = {
    _name = "fashion_information_page_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FashionInformationPageWindow = fwin:find("FashionInformationPageClass")
        if FashionInformationPageWindow ~= nil and FashionInformationPageWindow:isVisible() == true then
            return true
        end
        state_machine.lock("fashion_information_page_open", 0, "")
        local cell = FashionInformationPage:createCell(params)
        fwin:open(cell, fwin._view)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local fashion_information_page_close_terminal = {
    _name = "fashion_information_page_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        FashionInformationPage:closeCell()
        -- state_machine.excute("union_refresh_info", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(fashion_information_page_open_terminal)
state_machine.add(fashion_information_page_close_terminal)
state_machine.init()

function FashionInformationPage:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions ={}
    -- app.load("client.cells.union.union_the_meeting_place_notice_cell")
    -- app.load("client.cells.union.union_logo_icon_cell")
    -- app.load("client.union.meeting.UnionTheMeetingCheck")
    app.load("client.cells.ship.ship_body_fizz_cell")
    app.load("client.cells.ship.ship_body_cell_new")
    app.load("client.cells.ship.ship_body_cell")
    self._equipid = nil
    self._shipid = nil 
    self._source = nil

    self.isrefresh = false
    self.selectSkill = nil
    self.isOpen = false
	 -- Initialize fashion information page machine.
    local function init_fashion_information_page_terminal()
		-- 隐藏界面
        local fashion_information_page_hide_event_terminal = {
            _name = "fashion_information_page_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local fashion_information_page_show_event_terminal = {
            _name = "fashion_information_page_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local fashion_information_page_refresh_terminal = {
            _name = "fashion_information_page_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.source
                local _isrefresh = params._isrefresh
                if _isrefresh ~= nil then 
                    instance.isrefresh = _isrefresh
                end
                instance:updateDraw(cell)
        
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --保存按钮
        local fashion_information_page_wear_terminal = {
            _name = "fashion_information_page_wear",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("fashion_information_page_wear", 0, "")
                instance:senderWear()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         --点击技能
        local fashion_information_page_enter_skill_terminal = {
            _name = "fashion_information_page_enter_skill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local skillindex = params._datas._skillIndex
                -- state_machine.lock("fashion_information_page_enter_skill", 0, "")
                instance:playSkillAction(skillindex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --播放动画
        local fashion_information_page_play_action_terminal = {
            _name = "fashion_information_page_play_action",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local action = instance.actions[1]
                if action ~= nil then
                    action:play("role_change", false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(fashion_information_page_hide_event_terminal)
		state_machine.add(fashion_information_page_show_event_terminal)
        state_machine.add(fashion_information_page_refresh_terminal)
        state_machine.add(fashion_information_page_wear_terminal)
        state_machine.add(fashion_information_page_enter_skill_terminal)
		state_machine.add(fashion_information_page_play_action_terminal)
        state_machine.init()
    end
    
    -- call func init fashion information page   machine.
    init_fashion_information_page_terminal()

end
function FashionInformationPage:playSkillAction(skillindex)
    local root = self.roots[1]
    if root == nil then
        return
    end 
   
    local action = self.actions[1]
    if  self.isOpen == false then
        self.selectSkill = skillindex
        if skillindex == 0 then
            action:play("tounch_putong_1", false)
        elseif skillindex == 1 then
            action:play("tounch_jineng_1", false)
        elseif skillindex == 2 then
            action:play("tounch_heji_1", false)
        end
        self.isOpen = true
    elseif self.isOpen == true then
        if self.selectSkill == 0 then
            action:play("tounch_putong_2", false)
        elseif self.selectSkill == 1 then
            action:play("tounch_jineng_2", false)
        elseif self.selectSkill == 2 then
            action:play("tounch_heji_2", false)
        end
        self.isOpen = false
    end
end

function FashionInformationPage:onHide()
	self:setVisible(false)
end

function FashionInformationPage:onShow()
	self:setVisible(true)
end

function FashionInformationPage:senderWear()

    if self._equipid ~= nil and tonumber(self._equipid) > 0 then 
        local function responseWearCallback(response)
            _ED.baseFightingCount = calcTotalFormationFight()
            state_machine.unlock("fashion_information_page_wear", 0, "")
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                    TipDlg.drawTextDailog(tipStringInfo_fashion_str[2])
                    state_machine.excute("fashion_develop_refresh", 0, response.node)
                    ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_726"):setTouchEnabled(false)
                    ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_726"):setVisible(false)
                    local data = {
                        source = response.node._source,
                        _isrefresh = true
                    }
                    state_machine.excute("fashion_develop_open_updata_index", 0, data)
                    state_machine.excute("fashion_recast_page_refresh", 0, data)
                end
            end
        end
        local str = ""
        str = str..self._shipid.."\r\n"--佩戴船只ID
        str = str..self._equipid.."\r\n"--装备ID
        str = str.."6"     --装备位标识
        protocol_command.equipment_adorn.param_list = str
        NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, self, responseWearCallback, false, nil)
    elseif self._equipid ~= nil and tonumber(self._equipid) == 0 then
        local function responseWearCallback(response)
            _ED.baseFightingCount = calcTotalFormationFight()
            state_machine.unlock("fashion_information_page_wear", 0, "")
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                     TipDlg.drawTextDailog(tipStringInfo_fashion_str[2])
                    state_machine.excute("fashion_develop_refresh", 0, response.node)
                    ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_726"):setTouchEnabled(false)
                    ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_726"):setVisible(false)
                    local data = {
                        source = response.node._source,
                        _isrefresh = true
                    }
                    state_machine.excute("fashion_develop_open_updata_index", 0, data)
                    state_machine.excute("fashion_recast_page_refresh", 0, data)
                end
            end
        end
        local str = ""
        str = str..self._shipid.."\r\n"--佩戴船只ID
        str = str..self._equipid.."\r\n"--装备ID
        str = str.."6"     --装备位标识
        protocol_command.equipment_adorn.param_list = str
        NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, self, responseWearCallback, false, nil)
    else
        state_machine.unlock("fashion_information_page_wear", 0, "")
    end
end

function FashionInformationPage:drawSkill(skills,equipGrade,level)
    local root = self.roots[1]
    local skillsData = dms.searchs(dms["equipment_fashion_skill"], equipment_fashion_skill.group_id, skills)
    local skillsDataOne = nil 
    local skillsDataTwo = nil 
    local skillsDataThere = nil 
    equipGrade = zstring.tonumber(equipGrade)
    level = zstring.tonumber(level)
    if table.getn(skillsData) ~= 0 then
        -- local skillsDataOne = dms.searchs(dms["equipment_fashion_skill"], equipment_fashion_skill.group_id, skills)
        for i,v in ipairs(skillsData) do
            local _type = dms.atoi(v,equipment_fashion_skill.skill_type)
            local _needLv = dms.atoi(v,equipment_fashion_skill.need_lv)
            if _type == 0 then
                if level >= _needLv then
                    skillsDataOne = v
                end
            elseif _type == 1 then
                if level >= _needLv then
                    skillsDataTwo = v
                end
            elseif _type == 2 then
                if level >= _needLv then
                    skillsDataThere = v
                end
            end
        end
    end 
    if skillsDataOne ~= nil then
        local picIndexOne = dms.atoi(skillsDataOne,equipment_fashion_skill.skill_pic)
        ccui.Helper:seekWidgetByName(root, "Panel_6"):removeBackGroundImage()
        ccui.Helper:seekWidgetByName(root, "Panel_6"):setBackGroundImage(string.format("images/ui/props/skill_props/skill_props_%d.png", picIndexOne))
        local skillmouidid = dms.atoi(skillsDataOne,equipment_fashion_skill.skill_mouid_id)
        local skillDatas = dms.element(dms["skill_mould"],skillmouidid)
        local shizhuangputong = ccui.Helper:seekWidgetByName(root, "shizhuangputong")
        shizhuangputong:getChildByName("Text_1"):setString(dms.atos(skillDatas,skill_mould.skill_name).."Lv"..dms.atoi(skillsDataOne,equipment_fashion_skill.need_lv))
        shizhuangputong:getChildByName("Text_2"):setString(dms.atos(skillDatas,skill_mould.skill_describe))
        
    end
    if skillsDataTwo ~= nil then
        local picIndextwo = dms.atoi(skillsDataTwo,equipment_fashion_skill.skill_pic)
        ccui.Helper:seekWidgetByName(root, "Panel_7"):removeBackGroundImage()
        ccui.Helper:seekWidgetByName(root, "Panel_7"):setBackGroundImage(string.format("images/ui/props/skill_props/skill_props_%d.png", picIndextwo))
        
        local skillmouidid = dms.atoi(skillsDataTwo,equipment_fashion_skill.skill_mouid_id)
        local skillDatas = dms.element(dms["skill_mould"],skillmouidid)
        local shizhuangjineng = ccui.Helper:seekWidgetByName(root, "shizhuangjineng")
        shizhuangjineng:getChildByName("Text_1"):setString(dms.atos(skillDatas,skill_mould.skill_name))
        shizhuangjineng:getChildByName("Text_2"):setString(dms.atos(skillDatas,skill_mould.skill_describe))
    end
    if skillsDataThere ~= nil then
        local picIndexthere = dms.atoi(skillsDataThere,equipment_fashion_skill.skill_pic)
        local Panel_13_he = ccui.Helper:seekWidgetByName(root, "Panel_13_he")
        Panel_13_he:setVisible(true)
        local sprite = Panel_13_he:getChildByName("Sprite_126")
        sprite:setTexture(string.format("images/ui/props/skill_props/skill_props_%d.png", picIndexthere))

        local skillmouidid = dms.atoi(skillsDataThere,equipment_fashion_skill.skill_mouid_id)
        local skillDatas = dms.element(dms["skill_mould"],skillmouidid)
        local shizhuangheji = ccui.Helper:seekWidgetByName(root, "shizhuangheji")
        shizhuangheji:getChildByName("Text_1"):setString(dms.atos(skillDatas,skill_mould.skill_name))
        shizhuangheji:getChildByName("Text_2"):setString(dms.atos(skillDatas,skill_mould.skill_describe))

        display:gray(sprite)
        local skillequipmentmould = dms.atoi(skillsDataThere,equipment_fashion_skill.skill_equipment_mould)
        local talentDatas = dms.searchs(dms["equipment_fashion_talent"], equipment_fashion_talent.group_id, skills)
        if table.getn(talentDatas) ~= 0 then
            for i,v in ipairs(talentDatas) do
                if dms.atoi(v,equipment_fashion_talent.skill_fit_mould_id) == skillequipmentmould then
                    if dms.atoi(v,equipment_fashion_talent.need_lv) <= tonumber(equipGrade) then
                        display:ungray(sprite)
                    end
                end  
            end
        end
        -- display:gray(sprite)
        -- display:ungray(sprite)
    end
end

function FashionInformationPage:drawSkillShip(shipMouldId)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Panel_13_he"):setVisible(false)
    local id = zstring.tonumber(dms.string(dms["ship_mould"], shipMouldId, ship_mould.skill_mould))
    if id > 0 then
        local picIndex = dms.string(dms["skill_mould"],id,skill_mould.skill_pic)
        -- print("id ==",id,picIndex)
        local shizhuangputong = ccui.Helper:seekWidgetByName(root, "shizhuangputong")
        ccui.Helper:seekWidgetByName(root, "Panel_6"):removeBackGroundImage()
        ccui.Helper:seekWidgetByName(root, "Panel_6"):setBackGroundImage(string.format("images/ui/props/skill_props/skill_props_%d.png", zstring.tonumber(picIndex)))

        local skill_name = dms.string(dms["skill_mould"], id, skill_mould.skill_name)
        local skill_describe = dms.string(dms["skill_mould"], id, skill_mould.skill_describe)
        shizhuangputong:getChildByName("Text_1"):setString(skill_name)
        shizhuangputong:getChildByName("Text_2"):setString(skill_describe)
    end
    local id2 = zstring.tonumber(dms.string(dms["ship_mould"], shipMouldId, ship_mould.deadly_skill_mould))
    if id2 > 0  then
        local picIndex = dms.string(dms["skill_mould"],id2,skill_mould.skill_pic)
        -- print("id2 ==",id2,picIndex)
        local shizhuangjineng = ccui.Helper:seekWidgetByName(root, "shizhuangjineng")
        ccui.Helper:seekWidgetByName(root, "Panel_7"):removeBackGroundImage()
        ccui.Helper:seekWidgetByName(root, "Panel_7"):setBackGroundImage(string.format("images/ui/props/skill_props/skill_props_%d.png", zstring.tonumber(picIndex)))

        local skill_name = dms.string(dms["skill_mould"], id2, skill_mould.skill_name)
        local skill_describe = dms.string(dms["skill_mould"], id2, skill_mould.skill_describe)
        shizhuangjineng:getChildByName("Text_1"):setString(skill_name)
        shizhuangjineng:getChildByName("Text_2"):setString(skill_describe)
    end
end


function FashionInformationPage:updateDraw(cell)
    if cell == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end

    if self.isrefresh == false then
        if self._source ~= nil and self._source == cell then
            return
        end
    elseif self.isrefresh == true then
        self.isrefresh = false
    end
    -- if self._source ~= nil and self._source == cell then
    --     return
    -- end
    self._source = cell
    ccui.Helper:seekWidgetByName(root, "Button_726"):setTouchEnabled(true)
    ccui.Helper:seekWidgetByName(root, "Button_726"):setVisible(true)
    if cell.isWear ~= nil then
        if cell.isWear == true then
            ccui.Helper:seekWidgetByName(root, "Button_726"):setTouchEnabled(false)
            ccui.Helper:seekWidgetByName(root, "Button_726"):setVisible(false)
        end
    end
    local name = ccui.Helper:seekWidgetByName(root, "Text_134")
    local head =  ccui.Helper:seekWidgetByName(root, "renwutuceng")

    ccui.Helper:seekWidgetByName(root, "Panel_6"):setTouchEnabled(false)
    ccui.Helper:seekWidgetByName(root, "Panel_7"):setTouchEnabled(false)
    ccui.Helper:seekWidgetByName(root, "Panel_8"):setTouchEnabled(false)
    self.isOpen = false
    if cell.ship == nil then
        local equipGrade = 0
        if cell.equip ~= nil then
            self._equipid=cell.equip.user_equiment_id
            equipGrade = tonumber(cell.equip.user_equiment_grade)
        else
            self._equipid = -1
        end
        -- self._equipid = cell.mould_id
        -- local datas = dms.element(dms["equipment_mould"], cell.mould_id)

        -- local skills = dms.atoi(datas,equipment_mould.skill_equipment_adron_mould)
        local skills = dms.int(dms["equipment_mould"], cell.mould_id, equipment_mould.skill_equipment_adron_mould)
       
        local ship = fundShipWidthId(_ED.user_formetion_status[1])
        local level = nil
        if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
            tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(_ED.user_formetion_status[1]) then
            level = _ED.hero_skillstren_info.level
            -- mynum = _ED.hero_skillstren_info.value
        else
            level = ship.ship_skillstren.skill_level
            -- mynum = self.ship.ship_skillstren.skill_value
        end
        self:drawSkill(skills,equipGrade,level)
        ccui.Helper:seekWidgetByName(root, "Panel_6"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "Panel_7"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "Panel_8"):setTouchEnabled(true)
        

        ccui.Helper:seekWidgetByName(root, "shizhuangmingzi"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_134"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "shizhuangxinxikuang"):setVisible(true)

        local equipProperty = dms.string(dms["equipment_mould"],cell.mould_id,equipment_mould.initial_value)
        local initialValue = zstring.split(equipProperty,"|")

      
        for i,v in pairs(initialValue) do
            if i>3 then
                break
            end
            local influenceType = zstring.split(v,",")      --每一种属性
            if table.getn(influenceType) >= 2 then 
                local _pType = tonumber(influenceType[1])
                local _pValue = tonumber(influenceType[2])
                 if i==1 then
                     ccui.Helper:seekWidgetByName(root, "Text_6"):setString(_influence_type[_pType+1])
                    if _pType >= 4 and _pType <= 17 then
                        ccui.Helper:seekWidgetByName(root, "Text_6_0"):setString("+".._pValue.."%")
                    else
                        ccui.Helper:seekWidgetByName(root, "Text_6_0"):setString("+".._pValue)
                    end
                elseif i==2 then
                    ccui.Helper:seekWidgetByName(root, "Text_5"):setString(_influence_type[_pType+1])
                    if _pType >= 4 and _pType <= 17 then
                        ccui.Helper:seekWidgetByName(root, "Text_6_0_0"):setString("+".._pValue.."%")
                    else
                        ccui.Helper:seekWidgetByName(root, "Text_6_0_0"):setString("+".._pValue)
                    end
                end
                -- if _pType <= 3 then
                --     if i==1 then
                --         ccui.Helper:seekWidgetByName(root, "Text_6"):setString(string_equiprety_name_teo[_pType+1])
                --         ccui.Helper:seekWidgetByName(root, "Text_6_0"):setString(_pValue)
                --     elseif i==2 then
                --         ccui.Helper:seekWidgetByName(root, "Text_5"):setString(string_equiprety_name_teo[_pType+1])
                --         ccui.Helper:seekWidgetByName(root, "Text_6_0_0"):setString(_pValue)
                --     end
                -- end
            end
        end
        local everyLevel = dms.string(dms["equipment_mould"],cell.mould_id,equipment_mould.grow_value)
        local everyLevelAdd = zstring.split(everyLevel,"|")
        for i,v in pairs(everyLevelAdd) do
            local influenceType = zstring.split(v,",")      --每一种属性 强化属性
            if table.getn(influenceType) >= 2 then
                local _pType = tonumber(influenceType[1])
                local _pValue = influenceType[2]
                -- if table.getn(everyLevelAdd) > 1 then
                if _pType <= 3 then
                    if i==1 then
                        ccui.Helper:seekWidgetByName(root, "Text_7"):setString(_influence_type[_pType+1])
                        ccui.Helper:seekWidgetByName(root, "Text_7_0"):setString(_pValue*(equipGrade-1))
                    elseif i==2 then
                        ccui.Helper:seekWidgetByName(root, "Text_8"):setString(_influence_type[_pType+1])
                        ccui.Helper:seekWidgetByName(root, "Text_8_0"):setString(_pValue*(equipGrade-1))
                    elseif i==3 then
                        ccui.Helper:seekWidgetByName(root, "Text_9"):setString(_influence_type[_pType+1])
                        ccui.Helper:seekWidgetByName(root, "Text_9_0"):setString(_pValue*(equipGrade-1))
                    elseif i==4 then
                        ccui.Helper:seekWidgetByName(root, "Text_10"):setString(_influence_type[_pType+1])
                        ccui.Helper:seekWidgetByName(root, "Text_10_0"):setString(_pValue*(equipGrade-1))
                    end
                end
            end
        end


        local quality = dms.int(dms["equipment_mould"], cell.mould_id, equipment_mould.grow_level) + 1
        
        local picIndex =  dms.int(dms["equipment_mould"], cell.mould_id, equipment_mould.All_icon)
        -- picIndex = 10502


        
        local ptype = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.capacity)--角色头像类型
        local mcell = nil
        if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_warship_girl_b 
            then
            mcell = ShipBodyCellNew:createCell()
            mcell:init(picIndex + ptype - 1, false, cell.equip)
        else 
            mcell = ShipBodyCell:createCell()
            mcell:initShipMID(nil,picIndex + ptype - 1,cell.equip)
        end
        head:removeAllChildren(true)
        head:removeBackGroundImage()
        head:addChild(mcell)
        -- mcell:setTouchEnabled(false)
        mcell:setSwallowTouches(false)


        -- head:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
        name:setString(dms.string(dms["equipment_mould"], cell.mould_id, equipment_mould.equipment_name))
        name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
    else
        self._equipid = 0
   
        self:drawSkillShip(tonumber(cell.ship.ship_template_id))
        ccui.Helper:seekWidgetByName(root, "Panel_6"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "Panel_7"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "shizhuangmingzi"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_134"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "shizhuangxinxikuang"):setVisible(false)
        local picIndex = dms.int(dms["ship_mould"], cell.ship.ship_template_id, ship_mould.All_icon)
        local mcell = nil
        if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_warship_girl_b 
            then
            mcell = ShipBodyCellNew:createCell()
            mcell:init(picIndex, false)
        else 
            mcell = ShipBodyCell:createCell()
            mcell:initShipMID(nil,picIndex)
        end
        local ship = fundShipWidthId(_ED.user_formetion_status[1])
        local ptype = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.capacity)--角色头像类型
        head:removeAllChildren(true)
        head:removeBackGroundImage()
        head:addChild(mcell)
        mcell:setTouchEnabled(false)
        mcell:setSwallowTouches(false)
       
    end
    local action = self.actions[1]
    action:play("role_change", false)

end

function FashionInformationPage:onInit()
	self:updateDraw()
end

function FashionInformationPage:onEnterTransitionFinish()
    local csbFashionInformationPageCell = csb.createNode("fashionable_dress/fashionable_shizhuang.csb")
    local root = csbFashionInformationPageCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFashionInformationPageCell)

    local action = csb.createTimeline("fashionable_dress/fashionable_shizhuang.csb") 
    table.insert(self.actions, action )
    csbFashionInformationPageCell:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
           return
        end
        local str = frame:getEvent()
        -- if str == "started_appear_over" then
        -- end
    end)
    action:play("window_open", false)
    local user_info = nil  
    for i = 2, 7 do
        local shipId = _ED.formetion[i]
        if tonumber(shipId) > 0 then
            local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
            if tonumber(isleadtype) == 0 then
                user_info = _ED.user_ship[_ED.formetion[i]]
                break
            end
        end
    end
    self._shipid = user_info.ship_id
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_726"), nil, 
    {
        terminal_name = "fashion_information_page_wear", 
        terminal_state = 0,
        _shipId = user_info.ship_id,
        _cell = self,
        isPressedActionEnabled = false
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_6"), nil, 
    {
        terminal_name = "fashion_information_page_enter_skill", 
        terminal_state = 0,
        _skillIndex = 0,
        _cell = self,
        isPressedActionEnabled = false
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_7"), nil, 
    {
        terminal_name = "fashion_information_page_enter_skill", 
        terminal_state = 0,
        _skillIndex = 1,
        _cell = self,
        isPressedActionEnabled = false
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_8"), nil, 
    {
        terminal_name = "fashion_information_page_enter_skill", 
        terminal_state = 0,
        _skillIndex = 2,
        _cell = self,
        isPressedActionEnabled = false
    }, 
    nil, 0)


    self:init()
    state_machine.unlock("fashion_information_page_open", 0, "")
end

function FashionInformationPage:init()
	self:onInit()
	return self
end

function FashionInformationPage:onExit()
	state_machine.remove("fashion_information_page_hide_event")
	state_machine.remove("fashion_information_page_show_event")
    state_machine.remove("fashion_information_page_refresh")
    state_machine.remove("fashion_information_page_wear")
    state_machine.remove("fashion_information_page_enter_skill")
	state_machine.remove("fashion_information_page_play_action")

end

function FashionInformationPage:createCell( ... )
    local cell = FashionInformationPage:new()
     cell:registerOnNodeEvent(cell)
    return cell
end

function FashionInformationPage:closeCell( ... )
    local FashionInformationPageWindow = fwin:find("FashionInformationPageClass")
    if FashionInformationPageWindow == nil then
        return
    end
    fwin:close(FashionInformationPageWindow)
end