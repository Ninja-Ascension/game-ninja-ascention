-- ----------------------------------------------------------------------------------------------------
-- 说明：英雄排序界面
-------------------------------------------------------------------------------------------------------

HeroSortDressWindow = class("HeroSortDressWindowClass", Window)
HeroSortDressWindow.__size = nil

local hero_sort_dress_window_open_terminal = {
    _name = "hero_sort_dress_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _HeroSortDressWindow = fwin:find("HeroSortDressWindowClass")
        if nil == _HeroSortDressWindow then
            local panel = HeroSortDressWindow:new()
            panel:init(params)
            fwin:open(panel, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_sort_dress_window_close_terminal = {
    _name = "hero_sort_dress_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _HeroSortDressWindow = fwin:find("HeroSortDressWindowClass")
        if nil ~= _HeroSortDressWindow then
            fwin:close(fwin:find("HeroSortDressWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_sort_dress_window_open_terminal)
state_machine.add(hero_sort_dress_window_close_terminal)
state_machine.init()

function HeroSortDressWindow:ctor()
    self.super:ctor()

    self.roots = {}

    self.dressList = {
        sQulity = {}, -- 品质
        sType = {}, -- 类型
        sMood = {}, -- 斗魂
        sTerm = {} -- 排序
    }

    self.enumList = {
        QULITY = 1, -- 品质
        TYPE = 2,   -- 类型
        MOOD = 3,   -- 斗魂
        TERM = 4   -- 排序 
    }

    self.sortState = nil -- 0 降序   1 升序
    self.win_type = 0  -- 1 英雄管理  2 上阵

    self.qulityStart = 18 -- 品质起始Id

    app.load("client.cells.ship.hero_sort_dress_cell")

    local function init_hero_sort_dress_window_tip_terminal()
        local hero_sort_dress_window_close_terminal = {
            _name = "hero_sort_dress_window_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_sort_dress_window_sure_terminal = {
            _name = "hero_sort_dress_window_sure",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params._datas then
                    local mDress = params._datas.mInfo
                    if #mDress.sQulity == 0 and #mDress.sType == 0 and #mDress.sMood == 0 and #mDress.sTerm == 0 then

                    else
                        if instance.win_type == 1 then
                            state_machine.excute("hero_list_view_ship_sort_new_refush", 0, mDress)
                        elseif instance.win_type == 2 then
                            state_machine.excute("hero_choice_show_sort_new_refush", 0, mDress)
                        end
                    end
                    instance:setChooseState()
                    state_machine.excute("hero_sort_dress_window_close", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_sort_dress_window_change_terminal = {
            _name = "hero_sort_dress_window_change",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mType = params._datas.m_type
                local minfo = params._datas.m_info
                if instance then
                    instance:changeSelect(mType, minfo)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(hero_sort_dress_window_close_terminal)
        state_machine.add(hero_sort_dress_window_sure_terminal)
        state_machine.add(hero_sort_dress_window_change_terminal)

        state_machine.init()
    end
    init_hero_sort_dress_window_tip_terminal()
end

function HeroSortDressWindow:onUpdateDraw()
    local root = self.roots[1]
    self.Button_1 = {}
    self.Text_1 = {}
    self.ListView_zizhi = ccui.Helper:seekWidgetByName(root, "ListView_zizhi")
    -- DB2重塑,资质筛选处理
    if self.ListView_zizhi ~= nil then
        self.ListView_zizhi:removeAllItems()
        -- 是否开放17资质
        local isOpen  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 206, fun_open_condition.level) 
        for i = 1 , 5 do
            if not isOpen and i == 1 then 
                self.qulityStart = 17
            else
                local sortCell = state_machine.excute("hero_sort_dress_cell_create", 0, "")
                local Button_zizhi = ccui.Helper:seekWidgetByName(sortCell, "Button_zizhi")
                local Text_zizhi = ccui.Helper:seekWidgetByName(sortCell, "Text_zizhi")
                local qulity = 18 - i
                Text_zizhi:setString(qulity.."")
                self:changeButtonColor(Button_zizhi, Text_zizhi, true, false)
                table.insert(self.Button_1, Button_zizhi)
                table.insert(self.Text_1, Text_zizhi)
                self.ListView_zizhi:addChild(sortCell)
            end
        end
        self.ListView_zizhi:jumpToLeft()
        self.ListView_zizhi:requestRefreshView()
    else
        for i = 1, 5 do
            local btn_1 = ccui.Helper:seekWidgetByName(root, "Button_1_" .. i)
            local text_1 = ccui.Helper:seekWidgetByName(root, "Text_1_" .. i)
            self:changeButtonColor(btn_1, text_1, true, false)
            table.insert(self.Button_1, btn_1)
            table.insert(self.Text_1, text_1)
        end
    end
    
    for i = 1, #self.Button_1 do
        local qId = self.qulityStart - i
        fwin:addTouchEventListener(
            self.Button_1[i],
            nil,
            {
                terminal_name = "hero_sort_dress_window_change",
                terminal_state = 0,
                m_type = 1,
                m_info = qId
            },
            nil,
            0
        )
    end

    self.Button_2 = {}
    self.Text_2 = {}
    for i = 1, 3 do
        local btn_1 = ccui.Helper:seekWidgetByName(root, "Button_2_" .. i)
        local text_1 = ccui.Helper:seekWidgetByName(root, "Text_2_" .. i)
        self:changeButtonColor(btn_1, text_1, true, false)
        table.insert(self.Button_2, btn_1)
        table.insert(self.Text_2, text_1)
    end

    for i = 1, #self.Button_2 do
        fwin:addTouchEventListener(
            self.Button_2[i],
            nil,
            {
                terminal_name = "hero_sort_dress_window_change",
                terminal_state = 0,
                m_type = 2,
                m_info = i
            },
            nil,
            0
        )
    end

    self.Button_3 = {}
    self.Text_3 = {}
    for i = 1, 4 do
        local btn_1 = ccui.Helper:seekWidgetByName(root, "Button_3_" .. i)
        local text_1 = ccui.Helper:seekWidgetByName(root, "Text_3_" .. i)
        self:changeButtonColor(btn_1, text_1, true, false)
        table.insert(self.Button_3, btn_1)
        table.insert(self.Text_3, text_1)
    end

    for i = 1, 4 do
        fwin:addTouchEventListener(
            self.Button_3[i],
            nil,
            {
                terminal_name = "hero_sort_dress_window_change",
                terminal_state = 0,
                m_type = 3,
                m_info = i
            },
            nil,
            0
        )
    end

    self.Button_4 = {}
    self.Text_4 = {}
    for i = 1, 5 do
        local btn_1 = ccui.Helper:seekWidgetByName(root, "Button_4_" .. i)
        local text_1 = ccui.Helper:seekWidgetByName(root, "Text_4_" .. i)
        self:changeButtonColor(btn_1, text_1, true, false)
        --btn_1:loadTexturePressed("images/ui/text/smpacks/btn_sx_0.png")
        table.insert(self.Button_4, btn_1)
        table.insert(self.Text_4, text_1)
    end
    for i = 1, 5 do
        fwin:addTouchEventListener(
            self.Button_4[i],
            nil,
            {
                terminal_name = "hero_sort_dress_window_change",
                terminal_state = 0,
                m_type = 4,
                m_info = i
            },
            nil,
            0
        )
    end
end

function HeroSortDressWindow:changeSelect(mType, mInfo)
    if mType == 1 then
        local isAdd = false
        for i, v in ipairs(self.dressList.sQulity) do
            if v == mInfo then
                isAdd = true
                self:changeButtonColor(self.Button_1[self.qulityStart - mInfo], self.Text_1[self.qulityStart - mInfo], true, true)
                table.remove(self.dressList.sQulity, i)
                break
            end
        end
        if not isAdd then
            self:changeButtonColor(self.Button_1[self.qulityStart - mInfo], self.Text_1[self.qulityStart - mInfo], false, true)
            self.dressList.sQulity[#self.dressList.sQulity + 1] = mInfo
        end
    elseif mType == 2 then
        local isAdd = false
        for i, v in ipairs(self.dressList.sType) do
            if v == mInfo then
                isAdd = true
                self:changeButtonColor(self.Button_2[mInfo], self.Text_2[mInfo], true, true)
                table.remove(self.dressList.sType, i)
                break
            end
        end
        if not isAdd then
            self:changeButtonColor(self.Button_2[mInfo], self.Text_2[mInfo], false, true)
            self.dressList.sType[#self.dressList.sType + 1] = mInfo
        end
    elseif mType == 3 then
        local isAdd = false
        for i, v in ipairs(self.dressList.sMood) do
            if v == mInfo then
                isAdd = true
                self:changeButtonColor(self.Button_3[mInfo], self.Text_3[mInfo], true, true)
                table.remove(self.dressList.sMood, i)
                break
            end
        end
        if not isAdd then
            self:changeButtonColor(self.Button_3[mInfo], self.Text_3[mInfo], false, true)
            self.dressList.sMood[#self.dressList.sMood + 1] = mInfo
        end
    elseif mType == 4 then
        for i = 1, 5 do
            self:changeButtonColor(self.Button_4[i], self.Text_4[i], true, false)
        end
        local tempTerm = self.dressList.sTerm[1]
        if tempTerm == mInfo then
            if self.dressList.sTerm[2] and self.dressList.sTerm[2] == 0 then
                self.Button_4[mInfo]:loadTextureNormal("images/ui/text/smpacks/btn_sx_1.png")
                self:changeButtonColor(self.Button_4[mInfo], self.Text_4[mInfo], false, true)
                self.dressList.sTerm[2] = 1
            else
                self.dressList.sTerm[1] = nil
                self.dressList.sTerm[2] = nil
            end
        else
            self.Button_4[mInfo]:loadTextureNormal("images/ui/text/smpacks/btn_sx_2.png")
            self:changeButtonColor(self.Button_4[mInfo], self.Text_4[mInfo], false, true)
            self.dressList.sTerm[1] = mInfo
            self.dressList.sTerm[2] = 0
        end
    end
end

-- 改变按钮的状态和文本的显示颜色
function HeroSortDressWindow:changeButtonColor(button, text, isPressed, isHighlightedText)
    if not button then
        return
    end
    -- DSC重塑在按下的时候更改字体颜色
    if __lua_project_id == __lua_project_l_digital then
        if tipStringInfo_color_type_assemble ~= nil and text ~= nil then
            local color = (isHighlightedText == true) and tipStringInfo_color_type_assemble[6] or tipStringInfo_color_type_assemble[5]
            text:setColor(cc.c3b(color[1], color[2], color[3]))
        end
    end

    button:setHighlighted(isPressed)
end

-- 初始化筛选状态
function HeroSortDressWindow:initChooseState()
    local chooseStr = readKey("hero_generals_choose")
    local chooseInfo = {}
    if chooseStr ~= nil and chooseStr ~= "" then
        chooseInfo = zstring.splits(chooseStr, "|", ",", tonumber)
    end
    for _, v in ipairs(chooseInfo) do
        if v[1] == 4 then
            if v[3] == 1 then
                self.dressList.sTerm[1] = v[2]
                self.dressList.sTerm[2] = 0
            end
        end
        state_machine.excute("hero_sort_dress_window_change", 0, {_datas = {m_type = v[1], m_info = v[2]}})
    end
end

-- 根据key的名称获取当前类型
function HeroSortDressWindow:getTypeByName(name)
    local type = 1
    if name == "sQulity" then
        type = self.enumList.QULITY
    elseif name == "sType" then
        type = self.enumList.TYPE
    elseif name == "sMood" then
        type = self.enumList.MOOD
    elseif name == "sTerm" then
        type = self.enumList.TERM
    end

    return type
end

-- 设置新的本地存储状态
function HeroSortDressWindow:setChooseState()
    local chooseFinalStr = ""
    local function concatChooseStr(chooseStr)
        if chooseStr ~= "" then
            chooseStr = chooseStr .. "|"
        end

        return chooseStr
    end
    
    for i, v in pairs(self.dressList) do
        local curType = self:getTypeByName(i)
        if curType == 4 then
            if v ~= nil and v[1] ~= nil and v[2] ~= nil then
                chooseFinalStr = concatChooseStr(chooseFinalStr)
                chooseFinalStr = chooseFinalStr .. curType .. "," .. v[1] .. "," .. v[2]
            end
        else
            for j, value in ipairs(v) do
                chooseFinalStr = concatChooseStr(chooseFinalStr)
                chooseFinalStr = chooseFinalStr .. curType .. "," .. value
            end
        end
    end
    writeKey("hero_generals_choose", chooseFinalStr)
end

function HeroSortDressWindow:onInit()
    local csbHeroSortDressWindow = csb.createNode("packs/HeroStorage/generals_shaiXuan.csb")
    local root = csbHeroSortDressWindow:getChildByName("root")
    table.insert(self.roots, root)

    self:addChild(csbHeroSortDressWindow)
    if HeroSortDressWindow.__size == nil then
        HeroSortDressWindow.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_3_1_0"),
        nil,
        {
            terminal_name = "hero_sort_dress_window_sure",
            terminal_state = 0,
            mInfo = self.dressList,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_3_2_0"),
        nil,
        {
            terminal_name = "hero_sort_dress_window_close",
            terminal_state = 0,
            mInfo = self.dressList,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
    self:initChooseState()
end

function HeroSortDressWindow:onEnterTransitionFinish()
end

function HeroSortDressWindow:onExit()
    state_machine.remove("hero_sort_dress_window_close")
    state_machine.remove("hero_sort_dress_window_sure")
    state_machine.remove("hero_sort_dress_window_change")
end

function HeroSortDressWindow:init(params)
    self.win_type = params[2]
    self:onInit()
    if params[1] then
        params[1]:addChild(self)
    end
    return self
end
