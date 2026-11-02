--------------------------------------------------------------------------------------------------------------
--  说明：时装重铸界面
--------------------------------------------------------------------------------------------------------------
FashionRecastPage = class("FashionRecastPageClass", Window)

--打开界面
local fashion_recast_page_open_terminal = {
    _name = "fashion_recast_page_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FashionRecastPageWindow = fwin:find("FashionRecastPageClass")
        if FashionRecastPageWindow ~= nil and FashionRecastPageWindow:isVisible() == true then
            return true
        end
        state_machine.lock("fashion_recast_page_open", 0, "")
        local cell = FashionRecastPage:createCell(params)
        fwin:open(cell, fwin._view)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local fashion_recast_page_close_terminal = {
    _name = "fashion_recast_page_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        FashionRecastPage:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(fashion_recast_page_open_terminal)
state_machine.add(fashion_recast_page_close_terminal)
state_machine.init()

function FashionRecastPage:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self._source = nil 
    self.isrefresh = nil 
	self._equipid = nil 
    self.canrefresh = true

    app.load("client.packs.fashion.FashionResolveReturnPreview")
    app.load("client.cells.ship.ship_body_cell_new")
    app.load("client.cells.ship.ship_body_cell")
	 -- Initialize fashion information page machine.
    local function init_fashion_recast_page_terminal()
		-- 隐藏界面
        local fashion_recast_page_hide_event_terminal = {
            _name = "fashion_recast_page_hide_event",
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
        local fashion_recast_page_show_event_terminal = {
            _name = "fashion_recast_page_show_event",
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
		local fashion_recast_page_refresh_terminal = {
            _name = "fashion_recast_page_refresh",
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
        --重铸按钮
        local fashion_recast_page_enter_button_terminal = {
            _name = "fashion_recast_page_enter_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.canrefresh == false then
                    return true
                end 
                state_machine.lock("fashion_recast_page_enter_button", 0, "")
                local mcell = params._datas._self
                mcell:senderRecycleInit()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --确认重铸
        local fashion_recast_page_sender_recast_terminal = {
            _name = "fashion_recast_page_sender_recast",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("fashion_recast_page_sender_recast", 0, "")
                instance:senderRecast()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--播放动画
        local fashion_recast_page_play_action_terminal = {
            _name = "fashion_recast_page_play_action",
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
		
		state_machine.add(fashion_recast_page_hide_event_terminal)
		state_machine.add(fashion_recast_page_show_event_terminal)
        state_machine.add(fashion_recast_page_refresh_terminal)
        state_machine.add(fashion_recast_page_enter_button_terminal)
        state_machine.add(fashion_recast_page_sender_recast_terminal)
		state_machine.add(fashion_recast_page_play_action_terminal)
        state_machine.init()
    end
    
    -- call func init fashion information page   machine.
    init_fashion_recast_page_terminal()

end

function FashionRecastPage:onHide()
	self:setVisible(false)
end

function FashionRecastPage:onShow()
	self:setVisible(true)
end
function FashionRecastPage:senderRecycleInit( ... )
    local userEquipId = self._equipid
    if userEquipId == nil then
        state_machine.unlock("fashion_recast_page_enter_button", 0, "")
        return
    end
    local function responseRebirthInitCallback(response)
        state_machine.unlock("fashion_recast_page_enter_button", 0, "")
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                state_machine.excute("fashion_resolve_return_preview_open", 0, "")
            end
        end
    end
    local str = ""
    str = str.."4"
    str = str.."\r\n"..userEquipId
    protocol_command.recycle_init.param_list = str
    NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, self, responseRebirthInitCallback, false, nil)
end

function FashionRecastPage:senderRecast(cell)
    local root = self.roots[1]
    local userEquipId = self._equipid
    if userEquipId == nil then
        state_machine.unlock("fashion_recast_page_sender_recast", 0, "")
        return
    end
     local function responseRebirthCallback(response)
        _ED.baseFightingCount = calcTotalFormationFight()
        state_machine.unlock("fashion_recast_page_sender_recast", 0, "")
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                state_machine.excute("fashion_resolve_return_preview_close", 0, "")
                response.node:rewadDraw()
                response.node._source:onUpdateDraw1()
                response.node.isrefresh = true
                response.node:updateDraw(response.node._source)
                local data = {
                    source = response.node._source,
                    _isrefresh = true
                }
                state_machine.excute("fashion_develop_open_updata_index", 0, data)
                state_machine.excute("fashion_strengthen_page_refresh", 0, data)
                state_machine.excute("fashion_information_page_refresh", 0, data)
                

            end
        end
    end
    local str = ""
    str = str.."1"
    str = str.."\r\n"..userEquipId
    protocol_command.rebirth.param_list = str
    NetworkManager:register(protocol_command.rebirth.code, nil, nil, nil, self, responseRebirthCallback, false, nil)
end

function FashionRecastPage:rewadDraw()
    local root = self.roots[1]
    
    app.load("client.reward.DrawRareReward")
    local getRewardWnd = DrawRareReward:new()
    getRewardWnd:init(16)
    fwin:open(getRewardWnd, fwin._ui)
end

function FashionRecastPage:updateDraw(cell)
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
    local head = ccui.Helper:seekWidgetByName(root, "renwu")
    local Text_shiz_name = ccui.Helper:seekWidgetByName(root, "Text_fashine_name")
    local Text_b_chongzhu =  ccui.Helper:seekWidgetByName(root, "Text_b_chongzhu")
    local Panel_k_chongzhu = ccui.Helper:seekWidgetByName(root, "Panel_k_chongzhu")
    

    if cell.equip ~= nil then 
        local equipGrade = zstring.tonumber(cell.equip.user_equiment_grade)
        self._equipid = tonumber(cell.equip.user_equiment_id)
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
        if equipGrade > 1 and zstring.tonumber(cell.equip.ship_id) == 0 then
            self.canrefresh = true
            Text_b_chongzhu:setVisible(false)
            Panel_k_chongzhu:setVisible(true)
            -- Panel_k_chongzhu:getChildByName("Text_3"):setString("当前时装强化等级: ")
            Panel_k_chongzhu:getChildByName("Text_3_0"):setString(equipGrade)
        else
            self.canrefresh = false
            Text_b_chongzhu:setVisible(true)
            Panel_k_chongzhu:setVisible(false)
            -- Text_b_chongzhu:setString("当前时装不可重铸")
        end
        local needgold = dms.string(dms["pirates_config"], 227, pirates_config.param)
        ccui.Helper:seekWidgetByName(root, "Text_chonzghu_m"):setString(needgold)
        
    end
   
end

function FashionRecastPage:onInit()
	self:updateDraw()
end

function FashionRecastPage:onEnterTransitionFinish()
    local csbFashionRecastPageCell = csb.createNode("fashionable_dress/fashionable_chongzhu.csb")
    local root = csbFashionRecastPageCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFashionRecastPageCell)


    local action = csb.createTimeline("fashionable_dress/fashionable_chongzhu.csb") 
    table.insert(self.actions, action )
    csbFashionRecastPageCell:runAction(action)
    action:play("window_open", false)

    ccui.Helper:seekWidgetByName(root, "chongzhuxinxi"):setTouchEnabled(false)
   
   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chongzhu"), nil, 
    {
        terminal_name = "fashion_recast_page_enter_button", 
        terminal_state = 0,
        _self = self,
        _cell = self._source,
        isPressedActionEnabled = false
    }, 
    nil, 0)

    self:init()
    state_machine.unlock("fashion_recast_page_open", 0, "")
end

function FashionRecastPage:init()
	self:onInit()
	return self
end

function FashionRecastPage:onExit()
	state_machine.remove("fashion_recast_page_hide_event")
	state_machine.remove("fashion_recast_page_show_event")
    state_machine.remove("fashion_recast_page_refresh")
    state_machine.remove("fashion_recast_page_enter_button")
    state_machine.remove("fashion_recast_page_sender_recast")
	state_machine.remove("fashion_recast_page_play_action")

end

function FashionRecastPage:createCell( ... )
    local cell = FashionRecastPage:new()
     cell:registerOnNodeEvent(cell)
    return cell
end

function FashionRecastPage:closeCell( ... )
    local FashionRecastPageWindow = fwin:find("FashionRecastPageClass")
    if FashionRecastPageWindow == nil then
        return
    end
    fwin:close(FashionRecastPageWindow)
end