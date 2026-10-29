----------------------------------------------------------------------------------------------------
-- 敌军来袭-叛军cell
-------------------------------------------------------------------------------------------------------
RebelSoldierCell = class("RebelSoldierCellClass", Window)
RebelSoldierCell.__size = nil

local rebel_soldier_create_cell_terminal = {
    _name = "rebel_soldier_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = RebelSoldierCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_soldier_create_cell_terminal)
state_machine.init()

function RebelSoldierCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._index = 0
    self._info = nil
    self._ntype = 0
end

function RebelSoldierCell:onUpdateDraw()
	local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_icon")
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root, "Panel_tank_icon")
    local Text_rebel_name = ccui.Helper:seekWidgetByName(root, "Text_rebel_name")
    local Text_rebel_attack_state_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_attack_state_n")
    local npc_id = dms.int(dms["rebel_haunt_mould"], self._info._mould_id, rebel_haunt_mould.npc_mould_id)
    local name = dms.string(dms["npc"], npc_id, npc.npc_name)
    local head_pic = zstring.split(dms.string(dms["npc"], npc_id, npc.head_pic), ",")

    Text_rebel_attack_state_n:removeAllChildren(true)
    Text_rebel_attack_state_n:setString("")
    Panel_build_icon:removeBackGroundImage()
    Panel_tank_icon:removeBackGroundImage()
    Panel_build_icon:setBackGroundImage(string.format(config_res.images.ui.home.home_build, head_pic[1]))
    Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, head_pic[2]))
    
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end

    if self._ntype == 1 then
        Panel_build_icon:setScale(0.3)
    elseif self._ntype == 2 then
        Panel_build_icon:setScale(0.36)
    else
        Panel_build_icon:setScale(0.42)
    end
    local fontSize = Text_rebel_attack_state_n:getFontSize()
    Text_rebel_name:setString(name)
    Text_rebel_name:setColor(cc.c3b(color_Type[self._ntype + 1][1], color_Type[self._ntype + 1][2], color_Type[self._ntype + 1][3]))
    if tonumber(self._info._kill_name) == -1 then
        Text_rebel_attack_state_n:setString(tipStringInfo_campaign_info[13])
    else
        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
        local re1 = ccui.RichElementText:create(1, color, 255, tipStringInfo_campaign_info[14], config_res.font.font_name, fontSize)
        _richText_2:pushBackElement(re1)
        color = cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3])
        local re1_1 = nil
        if fontName == "" then
            local currfontSize = fontSize + 2
            re1_1 = ccui.RichElementText:create(1, color, 255, self._info._kill_name, fontName, currfontSize)
        else
            re1_1 = ccui.RichElementText:create(1, color, 255, self._info._kill_name, fontName, fontSize)
        end
        _richText_2:pushBackElement(re1_1)
        _richText_2:setContentSize(cc.size(Text_rebel_attack_state_n:getContentSize().width, fontSize))
        _richText_2:setPosition(cc.p(Text_rebel_attack_state_n:getContentSize().width / 2,fontSize))
        Text_rebel_attack_state_n:addChild(_richText_2)
    end
end

function RebelSoldierCell:onEnterTransitionFinish()

end

function RebelSoldierCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.campaign.rebel_soldier_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if RebelSoldierCell.__size == nil then
		RebelSoldierCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RebelSoldierCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.rebel_soldier_cell, root)
end

function RebelSoldierCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RebelSoldierCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_icon")
    local Text_rebel_name = ccui.Helper:seekWidgetByName(root, "Text_rebel_name")
    local Text_rebel_attack_state_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_attack_state_n")
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root, "Panel_tank_icon")
    if Panel_build_icon ~= nil then
        Panel_build_icon:removeBackGroundImage()
        Panel_tank_icon:removeBackGroundImage()
        Text_rebel_name:setString("")
        Text_rebel_attack_state_n:removeAllChildren(true)
    end
end

function RebelSoldierCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.rebel_soldier_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function RebelSoldierCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._ntype = params[3]
    if self._index <= 6 then
        self:onInit()
    end
    if RebelSoldierCell.__size ~= nil then
        self:setContentSize(RebelSoldierCell.__size)
    else
        self:setContentSize(RebelSoldierAttackCell.__size)
    end
end

