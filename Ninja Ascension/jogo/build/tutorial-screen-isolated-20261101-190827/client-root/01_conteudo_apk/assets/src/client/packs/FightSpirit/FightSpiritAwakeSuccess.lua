-- ----------------------------------------------------------------------------------------------------
-- 说明：战魂强化成功
-------------------------------------------------------------------------------------------------------
FightSpiritAwakeSuccess = class("FightSpiritAwakeSuccessClass", Window)
    
--打开窗口
local fight_spirit_awake_success_window_open_terminal = {
    _name = "fight_spirit_awake_success_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("FightSpiritAwakeSuccessClass") then
            fwin:open(FightSpiritAwakeSuccess:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local fight_spirit_awake_success_window_close_terminal = {
    _name = "fight_spirit_awake_success_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FightSpiritAwakeSuccessClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fight_spirit_awake_success_window_open_terminal)
state_machine.add(fight_spirit_awake_success_window_close_terminal)
state_machine.init()

function FightSpiritAwakeSuccess:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_fight_spirit_awake_success_terminal()
    end
    
    -- call func init hom state machine.
    init_fight_spirit_awake_success_terminal()
end

function FightSpiritAwakeSuccess:onUpdateDraw()
    local root = self.roots[1]

    function splitAttr(attrs)
        local retAttrs = {}
        local attrList = zstring.split(attrs, "|")
        for _,attrItem in ipairs(attrList) do
            local attrItem = zstring.split(attrItem, ",", function (value) return tonumber(value) end)
            table.insert(retAttrs, attrItem)
        end
        return retAttrs
    end

    local fightSpirit = FightSpiritHandle.getFightSpiritById(self.oldFightSpirit.id)
    
    local cell = ResourcesIconCell:createCell()
    cell:init(73,nil,nil,nil,nil,nil,nil,nil,{fightSpirit=self.oldFightSpirit})
    ccui.Helper:seekWidgetByName(root, "Panel_13"):addChild(cell)

    local cell = ResourcesIconCell:createCell()
    cell:init(73,nil,nil,nil,nil,nil,nil,nil,{fightSpirit=fightSpirit})
    ccui.Helper:seekWidgetByName(root, "Panel_13_0"):addChild(cell)

    local attrs = splitAttr(self.oldFightSpirit.addProperty.main)
    for i = 1, 3 do
        if #attrs < i then
            self["Text_atk_"..i]:setVisible(false)
            self["Text_shuxing_"..i]:setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Image_upup_"..i):setVisible(false)
        else
            local attr = attrs[i]
            local name, value = getHardenPropertyNameAndValue(attr[1], attr[2]+attr[3])
            self["Text_atk_"..i]:setString(name)
            self["Text_shuxing_"..i]:setString(value)
        end
    end

    local attrs = splitAttr(fightSpirit.addProperty.main)
    for i = 1, 3 do
        if #attrs < i then
            self["Text_atk_"..i+3]:setVisible(false)
            self["Text_shuxing_"..i+3]:setVisible(false)
        else
            local attr = attrs[i]
            local name, value = getHardenPropertyNameAndValue(attr[1], attr[2]+attr[3])
            self["Text_atk_"..i+3]:setString(name)
            self["Text_shuxing_"..i+3]:setString(value)
        end
    end

    local skillNameId = dms.string(dms["talent_mould"], fightSpirit.addProperty.awake, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], skillNameId)
    ccui.Helper:seekWidgetByName(root, "Text_lvup"):setString(word_info[3])
end

function FightSpiritAwakeSuccess:onEnterTransitionFinish()
    local csbFightSpiritAwakeSuccess = csb.createNode("packs/FightSpirit/FightSpirit_wake_vic.csb")
    self:addChild(csbFightSpiritAwakeSuccess)
    local root = csbFightSpiritAwakeSuccess:getChildByName("root")
    table.insert(self.roots, root)
    
    local action = csb.createTimeline("packs/FightSpirit/FightSpirit_wake_vic.csb")
    table.insert(self.actions, action)
    csbFightSpiritAwakeSuccess:runAction(action)
    action:play("window_open", false)
   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_h_bg"), nil,
    {
        terminal_name = "fight_spirit_awake_success_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)  

    for i = 1, 6 do
        self["Text_atk_"..i] = ccui.Helper:seekWidgetByName(root, "Text_atk_"..i)
        self["Text_shuxing_"..i] = ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i)
    end

    self:onUpdateDraw()
end


function FightSpiritAwakeSuccess:init(params)
    self.oldFightSpirit = params.oldFightSpirit
    return self
end

function FightSpiritAwakeSuccess:onExit()

end
