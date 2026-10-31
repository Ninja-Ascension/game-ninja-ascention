-----------------------------
--批量选择公用窗口
-----------------------------
RefiningBatch = class("RefiningBatchClass", Window)

--打开批量管理
local refining_batch_window_open_terminal = {
    _name = "refining_batch_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("RefiningBatchClass")
        if nil == _Window then
            local cell = params._datas.cell
            local window_type = cell.page_index
            fwin:open(RefiningBatch:new():init(window_type), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭批量管理
local refining_batch_window_close_terminal = {
    _name = "refining_batch_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RefiningBatchClass"))      
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(refining_batch_window_open_terminal)
state_machine.add(refining_batch_window_close_terminal)
state_machine.init()

function RefiningBatch:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    self.window_type = 1 -- 1 英雄 2 装备 3 战马 4 兵符
    --批量分解对应品质表
    self.refining_table_quality_index = {}
    -- Initialize refining_batch state machine.
    local function init_refining_batch_terminal()

        -- 确认
        local refining_batch_sure_terminal = {
            _name = "refining_batch_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local select_table = instance.refining_table_quality_index
                local window_type = instance.window_type

                state_machine.excute("refining_batch_window_close",0,"")
                if window_type == 1 then
                    state_machine.excute("refining_scrollview_hero_add_batch",0,select_table)
                elseif window_type == 2 then
                    state_machine.excute("refining_scrollview_equip_add_batch",0,select_table)
                elseif window_type == 3 then
                    state_machine.excute("refining_scrollview_horse_add_batch",0,select_table)
                elseif window_type == 4 then
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --移除 添加 品质
        local refining_batch_add_or_remove_quality_terminal = {
            _name = "refining_batch_add_or_remove_quality",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:addremoveQuality(params._datas.select_index)
                -- debug.print_r(self.refining_table_quality_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }          
        
        state_machine.add(refining_batch_sure_terminal) 
        state_machine.add(refining_batch_add_or_remove_quality_terminal)   
        state_machine.init()
    end
    
    -- call func init refining_batch state machine.
    init_refining_batch_terminal()
end

--移除 添加 品质
function RefiningBatch:addremoveQuality(index)
    local root = self.roots[1]
    local Image_refining_batch_hook = ccui.Helper:seekWidgetByName(root,"Image_refining_batch_hook_"..index)         
    for i,v in pairs(self.refining_table_quality_index) do
        if index == v then
            Image_refining_batch_hook:setVisible(false)
            table.remove(self.refining_table_quality_index,i)
            return
        end
    end
    Image_refining_batch_hook:setVisible(true)
    table.insert(self.refining_table_quality_index,index)
end

--刷新界面
function RefiningBatch:onUpdateDraw()
    local root = self.roots[1]

    local Text_refining_batch_4= ccui.Helper:seekWidgetByName(root,"Text_refining_batch_4")
    local str = string.format(red_alert_all_str[5],refining_batch[self.window_type])
    Text_refining_batch_4:setString(str)

    local Text_refining_batch_6 = ccui.Helper:seekWidgetByName(root,"Text_refining_batch_6") -- 绿色
    Text_refining_batch_6:setString(color_type_to_chinese[1]..refining_batch[self.window_type])
    local Text_refining_batch_8 = ccui.Helper:seekWidgetByName(root,"Text_refining_batch_8") -- 蓝色
    Text_refining_batch_8:setString(color_type_to_chinese[2]..refining_batch[self.window_type])
    local Text_refining_batch_10 = ccui.Helper:seekWidgetByName(root,"Text_refining_batch_10") -- 紫色
    Text_refining_batch_10:setString(color_type_to_chinese[3]..refining_batch[self.window_type])
    local Text_refining_batch_12 = ccui.Helper:seekWidgetByName(root,"Text_refining_batch_12") --橙色
    Text_refining_batch_12:setString(color_type_to_chinese[4]..refining_batch[self.window_type])

    for i = 1,4 do   -- 1 英雄 2 装备 3 战马 4 兵符
        local Panel_refining_batch_icon = ccui.Helper:seekWidgetByName(root,"Panel_refining_batch_icon_"..i)
        if self.window_type == 1 then
            Panel_refining_batch_icon:setBackGroundImage("images/ui/quality/hero_head_".. i .. ".png")
        elseif self.window_type == 2 then
            Panel_refining_batch_icon:setBackGroundImage("images/ui/quality/equipment_icon_".. i .. ".png")
        elseif self.window_type == 3 then
            Panel_refining_batch_icon:setBackGroundImage("images/ui/quality/horses_".. i .. ".png")
        elseif self.window_type == 4 then
            Panel_refining_batch_icon:setBackGroundImage("images/ui/quality/hero_head_".. i .. ".png")
        end 
    end

    -- 初始选中绿色蓝色品质
    for i=1,2 do
        local Image_refining_batch_hook = ccui.Helper:seekWidgetByName(root,"Image_refining_batch_hook_"..i)    
        Image_refining_batch_hook:setVisible(true)
        table.insert(self.refining_table_quality_index,i)
    end
end

--初始化界面
function RefiningBatch:onInit( )
    local csbItem = csb.createNode(config_csb.forging.refining_batch)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refining_batch_determine"), nil, 
    {
        terminal_name = "refining_batch_sure",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --选择
    for i = 1 , 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_refining_batch_select_".. i), nil, 
        {
            terminal_name = "refining_batch_add_or_remove_quality",
            terminal_state = 0,
            select_index = i,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
    end
    self:onUpdateDraw() 
end

function RefiningBatch:init(window_type)
    self.window_type = window_type
    self:onInit()
    return self
end

--移除状态机
function RefiningBatch:onExit()
      state_machine.remove("refining_batch_sure",0,"")
      state_machine.remove("refining_batch_add_or_remove_quality",0,"")
end
