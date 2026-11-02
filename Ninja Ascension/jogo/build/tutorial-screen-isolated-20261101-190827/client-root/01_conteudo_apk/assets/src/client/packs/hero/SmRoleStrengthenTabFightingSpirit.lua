-- ----------------------------------------------------------------------------------------------------
-- 说明：角色斗魂界面
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabFightingSpirit = class("SmRoleStrengthenTabFightingSpiritClass", Window)

local sm_role_strengthen_tab_fighting_spirit_open_terminal = {
    _name = "sm_role_strengthen_tab_fighting_spirit_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabFightingSpiritClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabFightingSpirit:new():init(params)
            fwin:open(panel)
        else
            fwin:close(fwin:find("SmRoleStrengthenTabFightingSpiritClass"))    
            local panel = SmRoleStrengthenTabFightingSpirit:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_fighting_spirit_close_terminal = {
    _name = "sm_role_strengthen_tab_fighting_spirit_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabFightingSpiritClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabFightingSpiritClass"))
        end
        state_machine.excute("formation_update_ship_info", 0, {isChange = true})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_fighting_spirit_open_terminal)
state_machine.add(sm_role_strengthen_tab_fighting_spirit_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabFightingSpirit:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    self.m_index = 1
    self.soul_lv = 1

    app.load("client.packs.hero.SmRoleStrengthenTabFightingSpiritStrengthen")
    app.load("client.packs.hero.SmRoleStrengthenTabFightingSpiritOld")
    local function init_sm_role_strengthen_tab_fighting_spirit_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_fighting_spirit_display_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabFightingSpiritWindow = fwin:find("SmRoleStrengthenTabFightingSpiritClass")
                if SmRoleStrengthenTabFightingSpiritWindow ~= nil then
                    SmRoleStrengthenTabFightingSpiritWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_fighting_spirit_hide_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabFightingSpiritWindow = fwin:find("SmRoleStrengthenTabFightingSpiritClass")
                if SmRoleStrengthenTabFightingSpiritWindow ~= nil then
                    SmRoleStrengthenTabFightingSpiritWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_role_strengthen_tab_fighting_spirit_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params[1] ~= nil then
                    instance.ship_id = params[1]
                end
                instance:onUpdateDraw()
                instance:ChooseRefresh(1)
                state_machine.excute("formation_update_ship_info", 0, {isChange = true})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择
        local sm_role_strengthen_tab_fighting_spirit_select_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                if tonumber(index) ~= instance.m_index then
                    instance:ChooseRefresh(index)
                else
                    if ccui.Helper:seekWidgetByName(instance.roots[1],"Image_dh_lock_"..index):isVisible() == false then
                        if tonumber(self.soul_lv) >= 20 then
                        else
                            if funOpenDrawTip(177,false) == false then
                                state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_open", 0 , {_datas = {index = index,shipId = instance.ship_id}})
                            else
                                state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_open", 0 , {_datas = {index = index,shipId = instance.ship_id}})
                            end
                            
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 升级刷新
        local sm_role_strengthen_tab_fighting_spirit_up_lv_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_up_lv_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                instance:ChooseRefresh(tonumber(params[1]))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_fighting_spirit_display_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_select_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_up_lv_update_draw_terminal)
        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_fighting_spirit_terminal()
end

--选中的斗魂刷新
--*index 选中的编号
function SmRoleStrengthenTabFightingSpirit:ChooseRefresh(index)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = _ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    self.m_index = tonumber(index)
    local soul_data = zstring.split((shipInfo.ship_fighting_spirit ~= "0" and shipInfo.ship_fighting_spirit) or "", "|")
    self.soul_exp = tonumber(zstring.split(soul_data[self.m_index] or "1,0",",")[2])
    self.soul_lv = tonumber(zstring.split(soul_data[self.m_index] or "1,0",",")[1])

    local faction_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.faction_id),",")
    local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.unlock_condition)
    --找对应的天赋
    local talent_id =  tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.talent_id),",")[1])

    for i=1,4 do
        local Image_dh_hook = ccui.Helper:seekWidgetByName(root,"Image_dh_hook_"..i)
        if i == tonumber(index) then
            Image_dh_hook:setVisible(true)
        else
            Image_dh_hook:setVisible(false)
        end
    end

    local Panel_dh_icon = ccui.Helper:seekWidgetByName(root,"Panel_dh_icon")
    Panel_dh_icon:removeBackGroundImage()
    local icon = dms.string(dms["talent_mould"], talent_id, talent_mould.buff_add_beau)
    if tonumber(icon) < 10 then
        icon = "0"..icon
    end
    Panel_dh_icon:setBackGroundImage(string.format("images/ui/talent_icon/talent_icon_%s.png", icon))

    local Image_dh_icon_bg_1 = ccui.Helper:seekWidgetByName(root,"Image_dh_icon_bg_1")
    local Image_dh_icon_bg_2 = ccui.Helper:seekWidgetByName(root,"Image_dh_icon_bg_2")
    
    --选中de斗魂名称
    local Text_dh_name = ccui.Helper:seekWidgetByName(root,"Text_dh_name")
    local name = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_name)
    local word_info = dms.element(dms["word_mould"], name)
    local skillName = word_info[3]
    Text_dh_name:setString(skillName)

    --选中de斗魂等级
    local Text_dh_lv = ccui.Helper:seekWidgetByName(root,"Text_dh_lv")
    --暂时写1
    Text_dh_lv:setString("Lv."..self.soul_lv)
    if tonumber(self.soul_lv) == 1 then
        Text_dh_lv:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    elseif tonumber(self.soul_lv) == 20 then
        Text_dh_lv:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
    else
        Text_dh_lv:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
    end

    --选中的斗魂描述
    local Text_dh_info = ccui.Helper:seekWidgetByName(root,"Text_dh_info") 
    local describe = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], describe)
    local describe_text = word_info[3]
    --画描述内容
    local attribute_content = {}
    local attribute_bonus_library = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.attribute_bonus_library)
    local attributes = dms.searchs(dms["ship_soul_addition_property_param"], ship_soul_addition_property_param.library_group, attribute_bonus_library)
    local attribute_bonus = nil
    for i, v in pairs(attributes) do
        if tonumber(v[3]) == self.soul_lv then
            attribute_bonus = v
            break
        end
    end
    --战前加的属性
    -- local base_additional = dms.string(dms["talent_mould"], talent_id, talent_mould.base_additional)
    if attribute_bonus[4] ~= "-1" then
        for i, v in pairs(zstring.split(attribute_bonus[4],"|")) do
            table.insert(attribute_content, zstring.split(v,",")[2])
        end
    end
    --战中加的属性
    -- local influence_judge_result = dms.string(dms["talent_mould"], talent_id, talent_mould.influence_judge_result)
    if attribute_bonus[5] ~= "-1" then
        local content = zstring.split(attribute_bonus[5],"|")
        local index = 0
        for i, v in pairs(zstring.split(attribute_bonus[5],"|")) do
            index = index + 1
            local value = zstring.split(v, ",")
            table.insert(attribute_content, zstring.split(content[index],",")[2])
        end
    end
    for i,v in pairs(attribute_content) do
        describe_text = string.gsub(describe_text,"{"..i.."}",v)
    end

    local textWidth = Text_dh_info:getContentSize().width
    Text_dh_info:setString(describe_text)
    Text_dh_info:setUnifySizeEnabled(true) --使用归一化尺寸, 不使用自定义尺寸
    Text_dh_info:setTextAreaSize(cc.size(textWidth, 0))	
    Text_dh_info:ignoreContentAdaptWithSize(false) --不使用自定义尺寸

    --解决text尺寸变化后，ListView未能自适应的问题
    local Listview_text = ccui.Helper:seekWidgetByName(root,"ListView_1")
    local Text_clone = Text_dh_info:clone()
    Listview_text:removeLastItem()
    Listview_text:pushBackCustomItem(Text_clone)

    --斗魂解锁条件
    local Panel_tiaojian = ccui.Helper:seekWidgetByName(root,"Panel_tiaojian") 
    --斗魂解锁条件描述
    local Text_tiaojian = ccui.Helper:seekWidgetByName(root,"Text_tiaojian") 
    local str = ""
    if unlock_condition > 8 then
        if unlock_condition == 13 then
            str = string.format(_new_interface_text[159],"")
        elseif unlock_condition > 13 then
            str = string.format(_new_interface_text[159],"+"..(unlock_condition - 13))
        else
            str = string.format(_new_interface_text[158],"+"..(unlock_condition - 8))
        end
    else
        str = string.format(_new_interface_text[158],"")
    end
    Text_tiaojian:setString(str)

    --斗魂满级
    local Image_lv_max = ccui.Helper:seekWidgetByName(root,"Image_lv_max") 

    --斗魂升级按钮
    local Button_qh = ccui.Helper:seekWidgetByName(root,"Button_qh") 
    if unlock_condition > tonumber(shipInfo.Order) then
        Panel_tiaojian:setVisible(true)
        Image_lv_max:setVisible(false)
        Button_qh:setVisible(false)
        Image_dh_icon_bg_1:setVisible(true)
        Image_dh_icon_bg_2:setVisible(false)
        Text_dh_lv:setString("")
    else
        Panel_tiaojian:setVisible(false)
        Image_lv_max:setVisible(false)
        Button_qh:setVisible(true)
        Image_dh_icon_bg_1:setVisible(false)
        Image_dh_icon_bg_2:setVisible(true)
        --没有等级无法判断是否满级
        if self.soul_lv == 20 then
            Image_lv_max:setVisible(true)
            Button_qh:setVisible(false)
        end
    end
    --强化
    if funOpenDrawTip(177,false) == false then
        fwin:addTouchEventListener(Button_qh, nil, 
        {
            terminal_name = "sm_role_strengthen_tab_fighting_spirit_strengthen_open", 
            terminal_state = 0,
            index = self.m_index,
            shipId = self.ship_id,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    else
        fwin:addTouchEventListener(Button_qh, nil, 
        {
            terminal_name = "sm_role_strengthen_tab_fighting_spirit_old_open", 
            terminal_state = 0,
            index = self.m_index,
            shipId = self.ship_id,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end
   
    
end

function SmRoleStrengthenTabFightingSpirit:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = _ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    
    --锁,绘制的icon,开启和关闭的状态，等级
    local faction_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.faction_id),",")
    for i=1, #faction_id do
        local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[i], ship_soul_mould.unlock_condition)
        --找对应的天赋
        local talent_id = tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[i], ship_soul_mould.talent_id),",")[1])
        --锁
        local Image_dh_lock = ccui.Helper:seekWidgetByName(root,"Image_dh_lock_"..i)

        --画icon
        local Panel_dh_icon = ccui.Helper:seekWidgetByName(root,"Panel_dh_icon_"..i)
        Panel_dh_icon:removeBackGroundImage()
        local icon = dms.string(dms["talent_mould"], talent_id, talent_mould.buff_add_beau)
        if tonumber(icon) < 10 then
            icon = "0"..icon
        end
        Panel_dh_icon:setBackGroundImage(string.format("images/ui/talent_icon/talent_icon_%s.png", icon))

        --关闭
        local Image_dh_1 = ccui.Helper:seekWidgetByName(root,"Image_dh_"..i.."_1")

        --开启
        local Image_dh_2 = ccui.Helper:seekWidgetByName(root,"Image_dh_"..i.."_2")

        --等级
        local Text_dh_lv = ccui.Helper:seekWidgetByName(root,"Text_dh_lv_"..i)
        
        local soul_data = zstring.split((shipInfo.ship_fighting_spirit ~= "0" and shipInfo.ship_fighting_spirit) or "", "|")
        local soul_lv = tonumber(zstring.split(soul_data[i] or "1,0",",")[1]) or 1
        --暂时写1
        Text_dh_lv:setString("Lv."..soul_lv)
        if tonumber(soul_lv) == 1 then
            Text_dh_lv:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        elseif tonumber(soul_lv) == 20 then
            Text_dh_lv:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
        else
            Text_dh_lv:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
        end
        --选中
        local Image_dh_hook = ccui.Helper:seekWidgetByName(root,"Image_dh_hook_"..i)
        Image_dh_hook:setVisible(false)

        if unlock_condition > tonumber(shipInfo.Order) then
        --     --未解锁
            Image_dh_lock:setVisible(true)
            Image_dh_1:setVisible(true)
            Image_dh_2:setVisible(false)
            Text_dh_lv:setString("")
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            else
                if i > 1 then
                    ccui.Helper:seekWidgetByName(root,"Image_douhun_link_"..(i-1)):setVisible(false)
                end
            end
        else
        --     --解锁了
            Image_dh_lock:setVisible(false)
            Image_dh_1:setVisible(false)
            Image_dh_2:setVisible(true)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            else
                if i > 1 then
                    ccui.Helper:seekWidgetByName(root,"Image_douhun_link_"..(i-1)):setVisible(true)
                end
            end
        end
    end
end

function SmRoleStrengthenTabFightingSpirit:onUpdate(dt)
    
end

function SmRoleStrengthenTabFightingSpirit:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    self.ship_id = params[2]
    self:onInit()
    return self
end

function SmRoleStrengthenTabFightingSpirit:onInit()
    local csbSmRoleStrengthenTabFightingSpirit = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_5.csb")
    local root = csbSmRoleStrengthenTabFightingSpirit:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabFightingSpirit)
	
    self:onUpdateDraw()

    self:ChooseRefresh(1)

    for i=1,4 do
        --选择
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Panel_dh_icon_"..i), nil, 
        {
            terminal_name = "sm_role_strengthen_tab_fighting_spirit_select", 
            terminal_state = 0,
            index = i
        }, 
        nil, 0)
    end
end

function SmRoleStrengthenTabFightingSpirit:onExit()
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_display")
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_hide")
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_update_draw")
end