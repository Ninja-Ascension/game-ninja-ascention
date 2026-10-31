-- ----------------------------------------------------------------------------------------------------
-- 说明：战魂强化成功
-------------------------------------------------------------------------------------------------------
FightSpiritQianghuaSuccess = class("FightSpiritQianghuaSuccessClass", Window)
    
--打开窗口
local fight_spirit_qianghua_success_window_open_terminal = {
    _name = "fight_spirit_qianghua_success_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("FightSpiritQianghuaSuccessClass") then
            fwin:open(FightSpiritQianghuaSuccess:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local fight_spirit_qianghua_success_window_close_terminal = {
    _name = "fight_spirit_qianghua_success_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FightSpiritQianghuaSuccessClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fight_spirit_qianghua_success_window_open_terminal)
state_machine.add(fight_spirit_qianghua_success_window_close_terminal)
state_machine.init()

function FightSpiritQianghuaSuccess:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_fight_spirit_qianghua_success_terminal()
    end
    
    -- call func init hom state machine.
    init_fight_spirit_qianghua_success_terminal()
end

function FightSpiritQianghuaSuccess:onUpdateDraw()
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

    local attrs1 = splitAttr(self.oldFightSpirit.addProperty.random)
    for i = 1, 3 do
        if #attrs1 < i then
            self["Text_atk_"..i]:setVisible(false)
            self["Text_shuxing_"..i]:setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Image_upup_"..i):setVisible(false)
        else
            local attr = attrs1[i]
            local name, value = getHardenPropertyNameAndValue(attr[1], attr[2]+attr[3])
            self["Text_atk_"..i]:setString(name)
            self["Text_shuxing_"..i]:setString(value)
        end
    end

    local fontColor = cc.c3b(tipStringInfo_fight_spirit[31][1], tipStringInfo_fight_spirit[31][2], tipStringInfo_fight_spirit[31][3])

    local attrs2 = splitAttr(fightSpirit.addProperty.random)
    for i = 1, 3 do
        if #attrs2 < i then
            self["Text_atk_"..i+3]:setVisible(false)
            self["Text_shuxing_"..i+3]:setVisible(false)
        else
            local attr = attrs2[i]
            local name, value = getHardenPropertyNameAndValue(attr[1], attr[2]+attr[3])
            self["Text_atk_"..i+3]:setString(name)
            self["Text_shuxing_"..i+3]:setString(value)
            if attrs1[i][2] + attrs1[i][3] ~= attrs2[i][2] + attrs2[i][3] then
                self["Text_atk_"..i]:setColor(fontColor)
                self["Text_shuxing_"..i]:setColor(fontColor)
                self["Text_atk_"..i+3]:setColor(fontColor)
                self["Text_shuxing_"..i+3]:setColor(fontColor)
            end
        end
    end    
end

function FightSpiritQianghuaSuccess:onEnterTransitionFinish()
	local csbFightSpiritQianghuaSuccess = csb.createNode("packs/FightSpirit/FightSpirit_qianghua_vic.csb")
	self:addChild(csbFightSpiritQianghuaSuccess)
	local root = csbFightSpiritQianghuaSuccess:getChildByName("root")
	table.insert(self.roots, root)
	
    local action = csb.createTimeline("packs/FightSpirit/FightSpirit_qianghua_vic.csb")
    table.insert(self.actions, action)
    csbFightSpiritQianghuaSuccess:runAction(action)
    action:play("window_open", false)
   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_h_bg"), nil,
    {
        terminal_name = "fight_spirit_qianghua_success_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)  

    for i = 1, 6 do
        self["Text_atk_"..i] = ccui.Helper:seekWidgetByName(root, "Text_atk_"..i)
        self["Text_shuxing_"..i] = ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i)
    end

	self:onUpdateDraw()
end


function FightSpiritQianghuaSuccess:init(params)
	self.oldFightSpirit = params.oldFightSpirit
    return self
end

function FightSpiritQianghuaSuccess:onExit()

end
