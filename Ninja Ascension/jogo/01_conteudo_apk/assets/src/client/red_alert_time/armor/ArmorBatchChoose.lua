-- ------------------------------------------------------------------------------------------------------------
--  说明：装甲批量选择
-- ------------------------------------------------------------------------------------------------------------
ArmorBatchChoose = class("ArmorBatchChooseClass", Window)

--打开界面
local armor_batch_choose_window_open_terminal = {
    _name = "armor_batch_choose_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("ArmorBatchChooseClass") == nil then
            local _win = ArmorBatchChoose:new()
            local from_type = params._datas.from_type
            _win:init(from_type)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local armor_batch_choose_window_close_terminal = {
    _name = "armor_batch_choose_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorBatchChooseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(armor_batch_choose_window_open_terminal)
state_machine.add(armor_batch_choose_window_close_terminal)
state_machine.init()

function ArmorBatchChoose:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._is_selected = false

    self._from_type = 0
    self._selected_tables = {               -- 每个checkbox选中状态
        {false, false, false, false, false},
        {false, false, false, false, false},
    }      
    self._all_selected_tables = {false, false}        -- 全部选中状态       

    local function init_armor_batch_choose_terminal()

        local armor_batch_choose_change_page_terminal = {
            _name = "armor_batch_choose_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas.page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
 
        --全部选中
        local armor_batch_choose_all_terminal = {
            _name = "armor_batch_choose_all",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = instance._current_page
                instance._all_selected_tables[page] = not instance._all_selected_tables[page]
                for i = 1, 5 do
                    instance._selected_tables[page][i] = instance._all_selected_tables[page]
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --确定
        local armor_batch_choose_sure_terminal = {
            _name = "armor_batch_choose_sure",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._from_type == 1 then
                    state_machine.excute("armor_pack_update_batch_choose", 0, instance._selected_tables)
                elseif instance._from_type == 2 then
                    state_machine.excute("armor_up_update_batch_choose", 0, instance._selected_tables)
                end
                state_machine.excute("armor_batch_choose_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_batch_choose_select_terminal = {
            _name = "armor_batch_choose_select",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = instance._current_page
                local index = params._datas.index
                instance._selected_tables[page][index] = not instance._selected_tables[page][index]
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_batch_choose_all_terminal)
        state_machine.add(armor_batch_choose_sure_terminal)
        state_machine.add(armor_batch_choose_change_page_terminal)   
        state_machine.add(armor_batch_choose_select_terminal)
        state_machine.init()
    end
    init_armor_batch_choose_terminal()
end

-- 显示信息
function ArmorBatchChoose:changeSelectPage(page)
    self._is_selected = false
    local root = self.roots[1]
    local Button_armor_batch_armor = ccui.Helper:seekWidgetByName(root, "Button_armor_batch_armor")
    local Button_armor_batch_exp = ccui.Helper:seekWidgetByName(root, "Button_armor_batch_exp")
    if page == self._current_page then
        if page == 1 then
            Button_armor_batch_armor:setHighlighted(true)
        else
            Button_armor_batch_exp:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_armor_batch_armor:setHighlighted(false)
    Button_armor_batch_exp:setHighlighted(false)
    if page == 1 then
        Button_armor_batch_armor:setHighlighted(true)
    else
        Button_armor_batch_exp:setHighlighted(true)
    end
    self:onUpdateDraw()
end

function ArmorBatchChoose:onUpdateDraw()
    local root = self.roots[1]
        
    local page = self._current_page
    local str = zstring.split(armor_select_str[page], ",")
    for i=1,5 do
        local Text_armor_batch = ccui.Helper:seekWidgetByName(root,"Text_armor_batch_"..i)
        local CheckBox_armor_batch = ccui.Helper:seekWidgetByName(root,"CheckBox_armor_batch_"..i)
        local is_selected = self._selected_tables[page][i]
        CheckBox_armor_batch:setSelected(is_selected)
        Text_armor_batch:setVisible(false)
        CheckBox_armor_batch:setVisible(false)
        if str[i] ~= "" and str[i] ~= nil then
            Text_armor_batch:setString(str[i])
            Text_armor_batch:setVisible(true)
            CheckBox_armor_batch:setVisible(true)
        end
    end
    local Button_armor_batch_all = ccui.Helper:seekWidgetByName(root, "Button_armor_batch_all")
    if self._all_selected_tables[page] == true then
        Button_armor_batch_all:setTitleText(armor_tip_str[7])
    else
        Button_armor_batch_all:setTitleText(armor_tip_str[6])
    end
end

--初始化界面
function ArmorBatchChoose:onInit()
    local csbItem = csb.createNode(config_csb.armor.armor_batch_choose)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_batch_close"), nil, 
    {
        terminal_name = "armor_batch_choose_window_close", 
        terminal_state = 0, 
    }, nil, 3)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "armor_batch_choose_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 全部选中
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_batch_all"), nil, 
    {
        terminal_name = "armor_batch_choose_all", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_batch_sure"), nil, 
    {
        terminal_name = "armor_batch_choose_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 装甲
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_batch_armor"), nil, 
    {
        terminal_name = "armor_batch_choose_change_page", 
        terminal_state = 0, 
        page = 1,
    }, nil, 1)

    -- 装甲经验
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_batch_exp"), nil, 
    {
        terminal_name = "armor_batch_choose_change_page", 
        terminal_state = 0, 
        page = 2,
    }, nil, 1) 

    for i = 1, 5 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_armor_batch_"..i), nil, 
        {
            terminal_name = "armor_batch_choose_select", 
            terminal_state = 0, 
            index = i,
        }, nil, 1)
    end

    self:changeSelectPage(2)
end

--初始化
function ArmorBatchChoose:init(from_type)
    self._from_type = from_type             -- 1：出售，2：升级
    self:onInit()
end

--移除状态机
function ArmorBatchChoose:onExit()   
    state_machine.remove("armor_batch_choose_change_page")
    state_machine.remove("armor_batch_choose_all")
    state_machine.remove("armor_batch_choose_sure")
    state_machine.remove("armor_batch_choose_select")
end
