--[[ ----------------------------------------------------------------------------
-- 锦囊天赋详情
--]] ----------------------------------------------------------------------------
SilkBagTalentInfo = class("SilkBagTalentInfoClass", Window)

-- 打开窗口
local silkbag_talent_info_window_open_terminal = {
    _name = "silkbag_talent_info_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SilkBagTalentInfoClass") then
            fwin:open(SilkBagTalentInfo:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local silkbag_talent_info_window_close_terminal = {
    _name = "silkbag_talent_info_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SilkBagTalentInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(silkbag_talent_info_window_open_terminal)
state_machine.add(silkbag_talent_info_window_close_terminal)
state_machine.init()

-- 构造器
function SilkBagTalentInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    -- var
    self._silkBagInfo = nil
    -- load lua files.

    -- Initialize silkbag_talent_info page state machine.
    local function init_silkbag_talent_info_terminal()
        -- 打开角色创建窗口
        local silkbag_talent_info_open_terminal = {
            _name = "silkbag_talent_info_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭角色创建窗口
        local silkbag_talent_info_close_terminal = {
            _name = "silkbag_talent_info_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示窗口
        local silkbag_talent_info_show_terminal = {
            _name = "silkbag_talent_info_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local silkbag_talent_info_hide_terminal = {
            _name = "silkbag_talent_info_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(silkbag_talent_info_open_terminal)
        state_machine.add(silkbag_talent_info_close_terminal)
        state_machine.add(silkbag_talent_info_show_terminal)
        state_machine.add(silkbag_talent_info_hide_terminal)
        state_machine.init()
    end
    -- call func init silkbag_talent_info state machine.
    init_silkbag_talent_info_terminal()
end

-- 对象初始化
function SilkBagTalentInfo:init(params)
    self._silkBagInfo = params[1]
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function SilkBagTalentInfo:onInit(params)
    local csbNode = csb.createNode("cultivate/silk_bag_infor.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭
    self.Button_closed =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "silkbag_talent_info_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function SilkBagTalentInfo:onUpdateDraw()
    local root = self.roots[1]
    local silkBagInfo = self._silkBagInfo
    -- ico
    local Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")
    self:drawSilkIcon(Panel_skill_icon)
    -- 名称
    local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name")
    self:drawSilkName(Text_skill_name)
    -- 突破
    local Text_skill_type_n = ccui.Helper:seekWidgetByName(root, "Text_skill_type_n")
    Text_skill_type_n:setString(silkBagInfo.quality)
    -- 等级
    local Text_skill_lv_n = ccui.Helper:seekWidgetByName(root, "Text_skill_lv_n")
    Text_skill_lv_n:setString(silkBagInfo.level)
    -- 技能介绍
    local Text_skill_info_1 = ccui.Helper:seekWidgetByName(root, "Text_skill_info_1")
    Text_skill_info_1:setString(self:getSkillInfo())
end

function SilkBagTalentInfo:getSkillInfo()
    local origInfo = dms.string(dms["ship_silk_bag_mould"], self._silkBagInfo.silkBagMouldId, ship_silk_bag_mould.exclusive_skill)
    local infoList = zstring.split(origInfo, "|")
    local totalDescrip = ""
    
    for i, excluseInfos in ipairs(infoList) do
        if tostring(excluseInfos) ~= "-1" then
            local excluseInfoGroups = zstring.split(excluseInfos, ",")
            local str = ""
            local title = SilkBagHandler.getSilkProtectCondition(self._silkBagInfo.silkBagMouldId, i)
            str = str .. title
            local describeCallback = function (word_id)
                if word_id ~= "-1" then 
                    local word_info = dms.element(dms["word_mould"], tonumber(word_id))
                    if word_info ~= nil then 
                        local desName = word_info[3]
                        str = str .. tostring(desName)
                    end
                end
            end
            for k, v in pairs(excluseInfoGroups) do
                if tostring(v) ~= "-1" then
                    local skillNameId = dms.string(dms["talent_mould"], tonumber(v), talent_mould.talent_name)
                    local skillDescribeId = dms.string(dms["talent_mould"], tonumber(v), talent_mould.talent_describe)
                    describeCallback(skillNameId)
                    describeCallback(skillDescribeId)
                end
            end
            if "" ~= str then
                totalDescrip = totalDescrip .. str .. "\n"
            end
        end
    end
    return totalDescrip
end

--锦囊名称设置
function SilkBagTalentInfo:drawSilkName(node)
    local silkbag_name_id = dms.int(dms["ship_silk_bag_mould"], self._silkBagInfo.silkBagMouldId, ship_silk_bag_mould.silkbag_name)
    local silkbag_name_word = dms.element(dms["word_mould"], silkbag_name_id)
    local name = silkbag_name_word[3]
    node:setString(name)
    node:setVisible(true)
end

--锦囊图标的绘制
function SilkBagTalentInfo:drawSilkIcon(node)
    node:removeAllChildren(true)
    local cell = ResourcesIconCell:createCell()
    local level = self._silkBagInfo.level
    local property_info = self._silkBagInfo.addBaseProperty
    local silkMouldId = self._silkBagInfo.silkBagMouldId
    local basePropertyList = {}
    if nil ~= property_info then
        local add_property_info = zstring.split(property_info, "|")
        for i = 1, table.nums(add_property_info) do
            local add_property_per = zstring.split(add_property_info[i], ",")
            if nil ~= add_property_per then
                local a = tipStringInfo_rescue_silkbag_property["0"]
                local baseProperty = {}
                baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
                baseProperty.property_value = add_property_per[2]
                basePropertyList[i] = baseProperty
            end
        end
    end

    cell:init(71, -1, silkMouldId, nil, nil, true, true, 0, {basePropertyList, level})
    node:addChild(cell)
end

function SilkBagTalentInfo:onEnterTransitionFinish()
end

function SilkBagTalentInfo:onExit()
    -- 释放SilkBagTalentInfoWindow界面资源.
    state_machine.remove("silkbag_talent_info_open")
    state_machine.remove("silkbag_talent_info_close")
    state_machine.remove("silkbag_talent_info_show")
    state_machine.remove("silkbag_talent_info_hide")
end

function SilkBagTalentInfo:close()
    -- window event : close.
end

function SilkBagTalentInfo:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
