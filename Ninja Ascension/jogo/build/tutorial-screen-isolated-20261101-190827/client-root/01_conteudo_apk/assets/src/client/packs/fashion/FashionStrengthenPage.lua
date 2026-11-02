--------------------------------------------------------------------------------------------------------------
--  说明：时装强化页界面
--------------------------------------------------------------------------------------------------------------
FashionStrengthenPage = class("FashionStrengthenPageClass", Window)

--打开界面
local fashion_strengthen_page_open_terminal = {
    _name = "fashion_strengthen_page_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FashionStrengthenPageWindow = fwin:find("FashionStrengthenPageClass")
        if FashionStrengthenPageWindow ~= nil and FashionStrengthenPageWindow:isVisible() == true then
            return true
        end
        state_machine.lock("fashion_strengthen_page_open", 0, "")
        local cell = FashionStrengthenPage:createCell(params)
        fwin:open(cell, fwin._view)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local fashion_strengthen_page_close_terminal = {
    _name = "fashion_strengthen_page_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        FashionStrengthenPage:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(fashion_strengthen_page_open_terminal)
state_machine.add(fashion_strengthen_page_close_terminal)
state_machine.init()

function FashionStrengthenPage:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self._source = nil 
    self._equipid = nil 
    self.isrefresh = false
    self.textData = {}
    app.load("client.cells.ship.ship_body_cell_new")
    app.load("client.cells.ship.ship_body_cell")
    app.load("client.cells.prop.prop_icon_cell")
	 -- Initialize fashion information page machine.
    local function init_fashion_strengthen_page_terminal()
		-- 隐藏界面
        local fashion_strengthen_page_hide_event_terminal = {
            _name = "fashion_strengthen_page_hide_event",
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
        local fashion_strengthen_page_show_event_terminal = {
            _name = "fashion_strengthen_page_show_event",
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
		local fashion_strengthen_page_refresh_terminal = {
            _name = "fashion_strengthen_page_refresh",
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
        --强化按钮
        local fashion_strengthen_page_enter_button_terminal = {
            _name = "fashion_strengthen_page_enter_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("fashion_strengthen_page_enter_button", 0, "")
                local mcell = params._datas._self
                local cell = params._datas._cell
                mcell:senderStreng(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        --强化属性按钮
        local fashion_strengthen_page_button_qianghuashuxin_terminal = {
            _name = "fashion_strengthen_page_button_qianghuashuxin",
            _init = function (terminal)
                app.load("client.packs.fashion.FashionStrengthenPreview")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ncell = instance._source
                state_machine.excute("fashion_strengthen_Preview_open", 0, {_datas={ _cell= ncell}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--播放动画
        local fashion_strengthen_page_play_action_terminal = {
            _name = "fashion_strengthen_page_play_action",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local action = instance.actions[1]
                if action ~= nil then
                    action:play("window_open", false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(fashion_strengthen_page_hide_event_terminal)
		state_machine.add(fashion_strengthen_page_show_event_terminal)
		state_machine.add(fashion_strengthen_page_refresh_terminal)
        state_machine.add(fashion_strengthen_page_enter_button_terminal)
        state_machine.add(fashion_strengthen_page_button_qianghuashuxin_terminal)
        state_machine.add(fashion_strengthen_page_play_action_terminal)
        state_machine.init()
    end
    
    -- call func init fashion strengthen page  machine.
    init_fashion_strengthen_page_terminal()

end

function FashionStrengthenPage:onHide()
	self:setVisible(false)
end

function FashionStrengthenPage:onShow()
	self:setVisible(true)
end

function FashionStrengthenPage:playFontAmation()
    if self.textData == nil or self.textData == "" then
        return
    end
    local garde =  self._source.equip.user_equiment_grade
    local str = ""
    if zstring.tonumber(garde) > 0 then
        -- str = "成功强化至"..garde.."级"
        str = string.format(tipStringInfo_fashion_str[1], garde)
    else
    end
    app.load("client.cells.utils.property_change_tip_info_cell") 
    local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
    tipInfo:init(5,str, self.textData)   
    fwin:open(tipInfo, fwin._ui)
    self.textData = {}
end
function FashionStrengthenPage:senderStreng(cell)
    local root = self.roots[1]
    local userEquipId = self._equipid
    if userEquipId == nil then
        state_machine.unlock("fashion_strengthen_page_enter_button", 0, "")
        return
    end
    local function responseStrengCallback(response)
        state_machine.unlock("fashion_strengthen_page_enter_button", 0, "")
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                response.node._source:onUpdateDraw1()
                response.node.isrefresh = true
                response.node:updateDraw(response.node._source)
                response.node:playFontAmation()
                local data = {
                    source = response.node._source,
                    _isrefresh = true
                }
                state_machine.excute("fashion_develop_open_updata_index", 0, data)
                state_machine.excute("fashion_recast_page_refresh", 0, data)
                state_machine.excute("fashion_information_page_refresh", 0, data)
            end
        end
    end
    local str = ""
    str = str..userEquipId
    protocol_command.fashion_escalate.param_list = str
    NetworkManager:register(protocol_command.fashion_escalate.code, nil, nil, nil, self, responseStrengCallback, false, nil)
end

local infoText = {
    {"Text_4","Text_gongji_01","Text_gongji_02"},
    {"Text_5","Text_fangyu_01","Text_fangyu_02"},
    {"Text_5_0","Text_baoji_01","Text_baoji_02"},
    {"Text_5_0_0","Text_shanghai_01","Text_shanghai_02"},
}
function FashionStrengthenPage:drawInfo(cell,datas)
    local root = self.roots[1]
    if root == nil or cell == nil then
        return
    end
    local equipGrade = zstring.tonumber(cell.equip.user_equiment_grade)
    ccui.Helper:seekWidgetByName(root, "Text_lv_1"):setString(equipGrade)
    ccui.Helper:seekWidgetByName(root, "Text_lv_2"):setString(equipGrade+1)
    -- ccui.Helper:seekWidgetByName(root, "Text_gongji_01"):setString(cell.equip.user_equiment_grade)
    local BtableInfo = {}
    local AtableInfo = {}
    -- local equipProperty = dms.atos(datas,equipment_mould.initial_value)  -- 基础属性
    -- local initialValue = zstring.split(equipProperty,"|")
    -- for i,v in pairs(initialValue) do
    --     if i>3 then
    --         break
    --     end
    --     local influenceType = zstring.split(v,",")      --每一种属性
    --     if table.getn(influenceType) >= 2 then 
    --         local _pType = tonumber(influenceType[1])
    --         if _pType < 4 then
    --             local _pValue = tonumber(influenceType[2])
    --             BtableInfo[_pType+1] = _pValue
    --             AtableInfo[_pType+1] = _pValue
    --         end
    --     end
    -- end
    local everyLevel = dms.string(dms["equipment_mould"],cell.mould_id,equipment_mould.grow_value)
    local everyLevelAdd = zstring.split(everyLevel,"|")
    self.textData = {}
    table.insert(self.textData, {property = "", value = 0})
    for i,v in pairs(everyLevelAdd) do
        local influenceType = zstring.split(v,",")      --每一种属性 强化属性
        if table.getn(influenceType) >= 2 then
            local _pType = tonumber(influenceType[1])
            if _pType < 4 then
                local _pValue = tonumber(influenceType[2])
                -- if BtableInfo[_pType+1] ~= nil then
                --     BtableInfo[_pType+1] = BtableInfo[_pType+1] + _pValue*(equipGrade-1)
                --     AtableInfo[_pType+1] = AtableInfo[_pType+1] + _pValue*(equipGrade)
                -- else
                    BtableInfo[_pType+1] = _pValue*(equipGrade-1)
                    AtableInfo[_pType+1] = _pValue*(equipGrade)
                -- end
                table.insert(self.textData, {property = _influence_type[_pType+1].."+", value = _pValue})
            end 
        end
    end
    local num = 1
    for i,v in pairs(BtableInfo) do
        if v ~= nil then
            if num <= 4 then
                ccui.Helper:seekWidgetByName(root, infoText[num][1]):setString(_influence_type[i])
                ccui.Helper:seekWidgetByName(root, infoText[num][2]):setString(v)
                num = num +1
            end
        end
    end
    local count = 1
     for i,v in pairs(AtableInfo) do
        if v ~= nil then
            if count <= 4 then
                ccui.Helper:seekWidgetByName(root, infoText[count][3]):setString(v)
                count =count +1
            end
        end
    end
    
    local equipGrowLevel = dms.atoi(datas,equipment_mould.grow_level)
    local needdatas = dms.searchs(dms["equipment_fashion_level"], equipment_fashion_level.garde, equipGrade)
    ccui.Helper:seekWidgetByName(root, "Panel_tubiao"):removeAllChildren(true)
    if needdatas ~= nil and needdatas[1] ~= nil then
        if equipGrowLevel == 3 then
            local propid = dms.atoi(needdatas[1],equipment_fashion_level.need_prop_1)
            local cell = self:getItemCell(propid,nil,nil)
            ccui.Helper:seekWidgetByName(root, "Panel_tubiao"):addChild(cell)
            ccui.Helper:seekWidgetByName(root, "Text_money"):setString(dms.atos(needdatas[1],equipment_fashion_level.need_silver_1))
            ccui.Helper:seekWidgetByName(root, "Text_szjh_numb"):setString(""..getPropAllCountByMouldId(propid).."/"..dms.atos(needdatas[1],equipment_fashion_level.prop_num_1))
        elseif equipGrowLevel == 4 then
            local propid = dms.atoi(needdatas[1],equipment_fashion_level.need_prop_2)
            local cell = self:getItemCell(propid,nil,nil)
            ccui.Helper:seekWidgetByName(root, "Panel_tubiao"):addChild(cell)
            ccui.Helper:seekWidgetByName(root, "Text_money"):setString(dms.atos(needdatas[1],equipment_fashion_level.need_silver_2))
            ccui.Helper:seekWidgetByName(root, "Text_szjh_numb"):setString(""..getPropAllCountByMouldId(propid).."/"..dms.atos(needdatas[1],equipment_fashion_level.prop_num_2))
        elseif equipGrowLevel == 5 then
            local propid = dms.atoi(needdatas[1],equipment_fashion_level.need_prop_3)
            local cell = self:getItemCell(propid,nil,nil)
            ccui.Helper:seekWidgetByName(root, "Panel_tubiao"):addChild(cell)
            ccui.Helper:seekWidgetByName(root, "Text_money"):setString(dms.atos(needdatas[1],equipment_fashion_level.need_silver_3))
            ccui.Helper:seekWidgetByName(root, "Text_szjh_numb"):setString(""..getPropAllCountByMouldId(propid).."/"..dms.atos(needdatas[1],equipment_fashion_level.prop_num_3))
        end
    end


end

function FashionStrengthenPage:updateDraw(cell)
    local root = self.roots[1]
    if root == nil or cell == nil then
        return
    end
    if self.isrefresh == false then
        if self._source ~= nil and self._source == cell then
            return
        end
    elseif self.isrefresh == true then
        self.isrefresh = false
    end
    self._source = cell

    local head = ccui.Helper:seekWidgetByName(root, "Panel_shizhuang_role")
    local Text_shiz_name = ccui.Helper:seekWidgetByName(root, "Text_shiz_name")
    if cell.equip ~= nil then
        self._equipid = tonumber(cell.equip.user_equiment_id)
        local equipGrade = tonumber(cell.equip.user_equiment_grade)

        local datas = dms.element(dms["equipment_mould"], tonumber(cell.mould_id))
        local quality = dms.atoi(datas,equipment_mould.grow_level)+1

        Text_shiz_name:setString(dms.atos(datas,equipment_mould.equipment_name))
        Text_shiz_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
        local picIndex =  dms.atoi(datas,equipment_mould.All_icon)
        local ship = fundShipWidthId(_ED.user_formetion_status[1])
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
        self:drawInfo(cell,datas)

        local skills = dms.int(dms["equipment_mould"], cell.mould_id, equipment_mould.skill_equipment_adron_mould)
        local talentDatas = dms.searchs(dms["equipment_fashion_talent"], equipment_fashion_talent.group_id, skills)
        local open  = nil 
        local willopen = nil
         if table.getn(talentDatas) ~= 0 then
            for i,v in ipairs(talentDatas) do
                if dms.atoi(v,equipment_fashion_talent.talent_id) > 0 then
                    if dms.atoi(v,equipment_fashion_talent.need_lv) <= tonumber(equipGrade) then
                        open = dms.atoi(v,equipment_fashion_talent.talent_id)
                    else
                        willopen = dms.atoi(v,equipment_fashion_talent.talent_id)
                        break
                    end
                end  
            end
        end
        if willopen ~= nil then
            local talentMould = dms.element(dms["talent_mould"],tonumber(willopen))
            local name = dms.atos(talentMould,talent_mould.talent_name)
            local describe = dms.atos(talentMould,talent_mould.talent_describe)
            ccui.Helper:seekWidgetByName(root, "Text_5_0_0_0"):setString("["..name.."] "..describe)
            
        else
            if open ~= nil then
                local talentMould = dms.element(dms["talent_mould"],tonumber(open))
                local name = dms.atos(talentMould,talent_mould.talent_name)
                local describe = dms.atos(talentMould,talent_mould.talent_describe)
                ccui.Helper:seekWidgetByName(root, "Text_5_0_0_0"):setString("["..name.."] "..describe)
            else
                ccui.Helper:seekWidgetByName(root, "Text_5_0_0_0"):setString("")
            end 
        end
        ccui.Helper:seekWidgetByName(root, "qianghuashuju"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_qianghuashuxin"):setTouchEnabled(true)
    else
        ccui.Helper:seekWidgetByName(root, "qianghuashuju"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_qianghuashuxin"):setTouchEnabled(false)
    end
end
--道具
function FashionStrengthenPage:getItemCell(mid,mtype,count,isCertainly)
    app.load("client.cells.prop.model_prop_icon_cell")
    local cell = ModelPropIconCell:createCell()
    local cellConfig = cell:createConfig()
    cellConfig.mouldId = mid
    cellConfig.isShowName = false
    cellConfig.isDebris = true
    cellConfig.mouldType = mtype
    cellConfig.touchShowType = 1
    cellConfig.count = count
    cellConfig.isCertainly = isCertainly
    cell:init(cellConfig)
    return cell
end

function FashionStrengthenPage:onInit()
	self:updateDraw()
end

function FashionStrengthenPage:onEnterTransitionFinish()
    local csbFashionStrengthenPageCell = csb.createNode("fashionable_dress/fashionable_qianghua.csb")
    local root = csbFashionStrengthenPageCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFashionStrengthenPageCell)

    local action = csb.createTimeline("fashionable_dress/fashionable_qianghua.csb") 
    table.insert(self.actions, action )
    csbFashionStrengthenPageCell:runAction(action)
    action:play("window_open", false)



   ccui.Helper:seekWidgetByName(root, "qianghuashuju"):setTouchEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianghuashuxin"), nil, 
    {
        terminal_name = "fashion_strengthen_page_button_qianghuashuxin", 
        terminal_state = 0,
        _self = self,
        isPressedActionEnabled = false
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianghua"), nil, 
    {
        terminal_name = "fashion_strengthen_page_enter_button", 
        terminal_state = 0,
        _self = self,
        _cell = self._source,
        isPressedActionEnabled = false
    }, 
    nil, 0)

    self:init()
    state_machine.unlock("fashion_strengthen_page_open", 0, "")
end

function FashionStrengthenPage:init()
	self:onInit()
	return self
end

function FashionStrengthenPage:onExit()
	state_machine.remove("fashion_strengthen_page_hide_event")
	state_machine.remove("fashion_strengthen_page_show_event")
    state_machine.remove("fashion_strengthen_page_refresh")
    state_machine.remove("fashion_strengthen_page_enter_button")
    state_machine.remove("fashion_strengthen_page_button_qianghuashuxin")
	state_machine.remove("fashion_strengthen_page_play_action")
end

function FashionStrengthenPage:createCell( ... )
    local cell = FashionStrengthenPage:new()
     cell:registerOnNodeEvent(cell)
    return cell
end

function FashionStrengthenPage:closeCell( ... )
    local FashionStrengthenPageWindow = fwin:find("FashionStrengthenPageClass")
    if FashionStrengthenPageWindow == nil then
        return
    end
    fwin:close(FashionStrengthenPageWindow)
end