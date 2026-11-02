--魔陷卡列表 显示CELL

MagicTrupCardCell = class("MagicTrupCardCellClass", Window)

MagicTrupCardCell.__size = nil
MagicTrupCardCell.__posYCPanel = nil --养成按钮初始位置

function MagicTrupCardCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.selectedIndex = 0  -- 3标示分解选择
    self.cardInfo = nil
    self.sellStates = false --是否被选中卖出
    self.status = false -- 是否是出售
    self.propIconCell = nil --道具ICON
    self.enum_type = {
        _MAGIC_TRUP_MAGIC = 1, --魔法卡
        _MAGIC_TRUP_TRUP = 2, --陷阱卡
        _MAGIC_TRUP_RESOLVE = 3,--分解
        _MAGIC_TRUP_REBORN = 4,--重生
    }
    
    local magic_trup_card_cell_choose_terminal = {
        _name = "magic_trup_card_cell_choose",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local cell = params._datas.cell
            local index = 0
            local total = 0
            local formatCount = 0
            if _ED.magicCardInfo ~= nil then
                local card_list = zstring.split(_ED.magicCardInfo, ",")
                for k,v in pairs(card_list) do
                    if v ~= nil and v ~= "" then 
                        if zstring.tonumber(v) ~= -1 then 
                            total = total + 1
                        end
                        
                        if zstring.tonumber(v) > 0 then 
                            formatCount = formatCount + 1
                        end
                    end
                end
                for k,v in pairs(card_list) do
                    if v ~= nil and v ~= "" then 
                        if zstring.tonumber(v) <= 0 then 
                            index = k
                            break
                        end
                    end
                end
            end
        	local function responseCallback(response)
        		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil then
                        response.node:onFormationChange()
                        state_machine.excute("magic_card_magic_update", 0, nil)
                    end
                end
			end
            if total == formatCount then 
                TipDlg.drawTextDailog(_magic_card_tip[9])
                return true
            end
            local card_type = dms.int(dms["magic_trap_card_info"],cell.cardInfo.base_mould,magic_trap_card_info.card_type) 
            protocol_command.magic_trap_formation_change.param_list = cell.cardInfo.id.."\r\n"..(index - 1).."\r\n"..card_type
			NetworkManager:register(protocol_command.magic_trap_formation_change.code, nil, nil, nil, cell, responseCallback, false, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local magic_trup_card_cell_remove_terminal = {
        _name = "magic_trup_card_cell_remove",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local cell = params._datas.cell
            local index = 0
            if _ED.magicCardInfo ~= nil then
                local card_list = zstring.split(_ED.magicCardInfo, ",")
                for k,v in pairs(card_list) do
                    if v ~= nil and v ~= "" and tonumber(cell.cardInfo.id) == tonumber(v) then
                        index = k
                        break
                    end
                end
            end
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil then
                        response.node:onFormationChange()
                        state_machine.excute("magic_card_magic_update", 0, nil)
                    end
                end
            end
            local card_type = dms.int(dms["magic_trap_card_info"],cell.cardInfo.base_mould,magic_trap_card_info.card_type) 
            protocol_command.magic_trap_formation_change.param_list = "0\r\n"..(index - 1).."\r\n"..card_type
            NetworkManager:register(protocol_command.magic_trap_formation_change.code, nil, nil, nil, cell, responseCallback, false, nil)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local magic_trup_card_cell_selet_sell_terminal = {
        _name = "magic_trup_card_cell_selet_sell",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local cell = params._datas.cell
            local isSell = cell.status 
            if isSell == true then 
                --已经选中了取消
                cell:setSelected(false)
            else
                cell:setSelected(true)
            end
            state_machine.excute("magic_card_sell_true_update_price",0,0)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --分解选择
    local magic_trup_card_cell_selet_resolve_terminal = {
        _name = "magic_trup_card_cell_selet_resolve",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local cell = params._datas.cell
            local isSell = cell.status 
            if isSell == true then 
                --已经选中了取消
                state_machine.excute("magic_card_sell_true_update_reslove",0,{counts = -1,_cell = cell})
            else
                state_machine.excute("magic_card_sell_true_update_reslove",0,{counts = 1,_cell = cell})
            end
            
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --养成
    local magic_trup_card_cell_strong_terminal = {
        _name = "magic_trup_card_cell_strong",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            app.load("client.magicCard.MagicCardStrong")
            local cardStrongWindow = MagicCardStrong:new()
            cardStrongWindow:init(params._datas.cell.cardInfo.id,params._datas.cell)
            fwin:open(cardStrongWindow, fwin._viewdialog)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --重生选择
    local magic_trup_card_cell_reborn_terminal = {
        _name = "magic_trup_card_cell_reborn",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            state_machine.excute("magic_card_reborn_show_magic_card_info", 0, {_datas = {cell = params._datas.cell}})
            state_machine.excute("magic_card_choose_reborn_close", 0, "magic_card_choose_reborn_close.")
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(magic_trup_card_cell_choose_terminal)
    state_machine.add(magic_trup_card_cell_remove_terminal)
    state_machine.add(magic_trup_card_cell_selet_sell_terminal)
    state_machine.add(magic_trup_card_cell_strong_terminal) 
    state_machine.add(magic_trup_card_cell_selet_resolve_terminal)
    state_machine.add(magic_trup_card_cell_reborn_terminal)
    state_machine.init()
end

function MagicTrupCardCell:init(index, selectedIndex, cardInfo,isSell)
	self.selectedIndex = selectedIndex
	self.cardInfo = cardInfo
    self.isSell = isSell
	if index ~= nil and index < 8 then
        self:onInit()
    end
    self:setContentSize(MagicTrupCardCell.__size)
    return self
end

function MagicTrupCardCell:changeState(  )
    -- body
end

function MagicTrupCardCell:setSelected(isbool)
    self.status = isbool
    ccui.Helper:seekWidgetByName(self.roots[1], "Image_10"):setVisible( self.status == true)
end

--刷新上阵状态
function MagicTrupCardCell:onFormationChange()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self.cardInfo = fundMagicCardWithId(self.cardInfo.id)
    local card_type = dms.int(dms["magic_trap_card_info"],self.cardInfo.base_mould,magic_trap_card_info.card_type) 
    if card_type == 0 then
        local isInFormation = false
        if _ED.magicCardInfo ~= nil then
            local formationType = _ED.magicCard_formation[zstring.tonumber(self.cardInfo.id)]
            if formationType ~= nil and formationType ==  1 then 
                isInFormation = true
            end
        end
        if isInFormation == true then
            ccui.Helper:seekWidgetByName(root, "Panel_button_4"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Panel_button_3"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Image_shangzhen"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Panel_button_3"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Panel_button_4"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Image_shangzhen"):setVisible(false)
        end
    else
        ccui.Helper:seekWidgetByName(self.roots[1], "Image_shangzhen"):setVisible(false)
        if self.selectedIndex == self.enum_type._MAGIC_TRUP_TRUP then 
            --陷阱卡 养成按钮需要偏移
            ccui.Helper:seekWidgetByName(root, "Panel_button_5"):setPositionY(MagicTrupCardCell.__posYCPanel + 25)
        end
    end 
end

function MagicTrupCardCell:onUpdateDraw( ... )
	local root = self.roots[1]
    local Panel_props = ccui.Helper:seekWidgetByName(root, "Panel_props")
    local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
    local Label_name = ccui.Helper:seekWidgetByName(root, "Label_name")
    local Label_property = ccui.Helper:seekWidgetByName(root, "Label_property")
    Panel_props:removeBackGroundImage()
    Panel_kuang:removeBackGroundImage()
    
    --魔法卡数据
    local cardInfoData = dms.element(dms["magic_trap_card_info"], self.cardInfo.base_mould)

    -- 对应的道具属性

    local pic_index = dms.atoi(cardInfoData,magic_trap_card_info.pic)  
    local quality = 1
    
    local card_type = dms.atoi(cardInfoData,magic_trap_card_info.card_type)  
    if card_type == 0 then 
        quality = 2
    else
        quality = 4
    end  
    Label_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
    Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))

    Panel_props:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))

    local Panel_button_4 = ccui.Helper:seekWidgetByName(root, "Panel_button_4")
    Panel_button_4:setVisible(false)
    local Panel_button_3 = ccui.Helper:seekWidgetByName(root, "Panel_button_3")
    Panel_button_3:setVisible(false)
    local sellPanel = ccui.Helper:seekWidgetByName(root, "Panel_7")
    sellPanel:setVisible(false)
    local Panel_button_6 = ccui.Helper:seekWidgetByName(root, "Panel_button_6")
    --养成
    local Panel_button_5 = ccui.Helper:seekWidgetByName(root, "Panel_button_5")
    ccui.Helper:seekWidgetByName(root, "Panel_button_5"):setPositionY(MagicTrupCardCell.__posYCPanel)
    Panel_button_5:setVisible(false)

    ccui.Helper:seekWidgetByName(root, "Image_shangzhen"):setVisible(false)
    local maxStart = dms.atoi(cardInfoData, magic_trap_card_info.max_star)
    local skillId = dms.atos(cardInfoData,magic_trap_card_info.skill_mould_id)
    local strongLevel = zstring.tonumber(self.cardInfo.strong_level)
    local showSkillId = skillId + strongLevel

    local desc = ""
    if strongLevel == 0 then 
        desc = dms.atos(cardInfoData,magic_trap_card_info.card_desc)
    else
        desc = dms.atos(cardInfoData,magic_trap_card_info.card_desc) .. "(" .. dms.string(dms["skill_mould"], showSkillId, skill_mould.skill_describe) .. ")"
    end

    Label_property:setString(desc)

    Label_name:setString(dms.string(dms["skill_mould"], showSkillId, skill_mould.skill_name))
    
    local startLevel = dms.atoi(cardInfoData, magic_trap_card_info.current_star)
    for i=1,5 do
        local startImg1 = ccui.Helper:seekWidgetByName(root, "Image_c_".. i)
        local startImg2 = ccui.Helper:seekWidgetByName(root, "Image_o_".. i)
        startImg1:setVisible(false)
        startImg2:setVisible(false)
        if i <= maxStart then 
            startImg1:setVisible(true)
        end
        if i <= startLevel then 
            startImg2:setVisible(true)
        end
    end

    if self.isSell == true then 
        --出售
        sellPanel:setVisible(true)
        local ImageSelect = ccui.Helper:seekWidgetByName(root, "Image_10")
        ImageSelect:setVisible(self.status == true)
        Panel_button_5:setVisible(false)
    else
        --加入或是移除
        Panel_button_5:setVisible(true)
        self:onFormationChange()
    end
    --重生选择
    if self.selectedIndex == 4 then 
        Panel_button_6:setVisible(true)
        Panel_button_5:setVisible(false)
        Panel_button_3:setVisible(false)
        Panel_button_4:setVisible(false)
    else
        Panel_button_6:setVisible(false)
    end
end

function MagicTrupCardCell:onInit( ... )
    local root = cacher.createUIRef("list/list_magic_card.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    self:setContentSize(root:getContentSize())
    if MagicTrupCardCell.__size == nil then
        MagicTrupCardCell.__size = root:getContentSize()
    end

    local action = csb.createTimeline("list/list_magic_card.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("list_view_cell_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_join"), nil, 
    {
        terminal_name = "magic_trup_card_cell_choose",
        terminal_state = 0, 
        isPressedActionEnabled = false,
        cell = self
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_delete"), nil, 
    {
        terminal_name = "magic_trup_card_cell_remove",
        terminal_state = 0, 
        isPressedActionEnabled = false,
        cell = self
    }, nil, 0)

    if self.selectedIndex == 3 then 
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_7"), nil, 
        {
            terminal_name = "magic_trup_card_cell_selet_resolve",
            terminal_state = 0, 
            isPressedActionEnabled = false,
            cell = self
        }, nil, 0)
    else
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_7"), nil, 
        {
            terminal_name = "magic_trup_card_cell_selet_sell",
            terminal_state = 0, 
            isPressedActionEnabled = false,
            cell = self
        }, nil, 0)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xz"), nil, 
    {
        terminal_name = "magic_trup_card_cell_reborn",
        terminal_state = 0, 
        isPressedActionEnabled = false,
        cell = self
    }, nil, 0)

    if MagicTrupCardCell.__posYCPanel == nil then 
        local ycPanel = ccui.Helper:seekWidgetByName(root, "Panel_button_5")
        MagicTrupCardCell.__posYCPanel = ycPanel:getPositionY() 
    end
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yangcheng"), nil, 
    {
        terminal_name = "magic_trup_card_cell_strong",
        terminal_state = 0, 
        isPressedActionEnabled = false,
        cell = self
    }, nil, 0)

    self:onUpdateDraw()
end

function MagicTrupCardCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MagicTrupCardCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    cacher.freeRef("list/list_magic_card.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function MagicTrupCardCell:onExit()
    cacher.freeRef("list/list_magic_card.csb", self.roots[1])
end

function MagicTrupCardCell:onEnterTransitionFinish()
end

function MagicTrupCardCell:CreateCell( ... )
	local cell = MagicTrupCardCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
