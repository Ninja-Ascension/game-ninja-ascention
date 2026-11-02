MagicCardListCell = class("MagicCardListCellClass", Window)

MagicCardListCell.__size = nil
function MagicCardListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.selectedIndex = 0
    self.cardInfo = nil

    local magic_card_cell_choose_button_terminal = {
        _name = "magic_card_cell_choose_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local cell = params._datas.cell
        	local function responseCallback(response)
        		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        			state_machine.excute("magic_card_main_close", 0, nil)
                    state_machine.excute("formation_make_war_update_card_info", 0, nil)
                end
			end
            protocol_command.magic_trap_formation_change.param_list = cell.cardInfo.id.."\r\n"..(cell.selectedIndex -1).."\r\n1"
			NetworkManager:register(protocol_command.magic_trap_formation_change.code, nil, nil, nil, true, responseCallback, false, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(magic_card_cell_choose_button_terminal)
    state_machine.init()
end

function MagicCardListCell:init(index, selectedIndex, cardInfo)
	self.selectedIndex = selectedIndex
	self.cardInfo = cardInfo
	if index ~= nil and index < 8 then
        self:onInit()
    end
    self:setContentSize(MagicCardListCell.__size)
    return self
end

function MagicCardListCell:onUpdateDraw( ... )
	local root = self.roots[1]
    local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
    local Panel_7 = ccui.Helper:seekWidgetByName(root, "Panel_7")
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    local Text_jieshao = ccui.Helper:seekWidgetByName(root, "Text_jieshao")
    Panel_6:removeBackGroundImage()
    Panel_7:removeBackGroundImage()

    local cardInfoData = dms.element(dms["magic_trap_card_info"], self.cardInfo.base_mould)
    if cardInfoData == nil then 
        return
    end

    local pic_index = dms.atoi(cardInfoData,magic_trap_card_info.pic)  
    local quality = 4

    Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
    Panel_7:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", 4))
    Panel_6:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))

    Text_jieshao:setString(remarks)
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

    Text_jieshao:setString(desc)

    Text_name:setString(dms.string(dms["skill_mould"], showSkillId, skill_mould.skill_name))

end

function MagicCardListCell:onInit( ... )
    local root = cacher.createUIRef("list/list_xianjinCard.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    self:setContentSize(root:getContentSize())
    if MagicCardListCell.__size == nil then
        MagicCardListCell.__size = root:getContentSize()
    end

    local action = csb.createTimeline("list/list_xianjinCard.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("list_view_cell_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
    {
        terminal_name = "magic_card_cell_choose_button",
        terminal_state = 0, 
        isPressedActionEnabled = false,
        cell = self
    }, nil, 0)

    self:onUpdateDraw()
end

function MagicCardListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MagicCardListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    cacher.freeRef("list/list_xianjinCard.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function MagicCardListCell:onExit()
    cacher.freeRef("list/list_xianjinCard.csb", self.roots[1])
end

function MagicCardListCell:onEnterTransitionFinish()
end

function MagicCardListCell:CreateCell( ... )
	local cell = MagicCardListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
