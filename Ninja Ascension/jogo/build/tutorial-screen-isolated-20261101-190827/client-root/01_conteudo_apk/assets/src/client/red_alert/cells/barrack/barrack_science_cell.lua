--------------------------------------------------------------------------------------------------------------
--  说明：兵营科技cell
--------------------------------------------------------------------------------------------------------------
BarrackScienceCell = class("BarrackScienceCellClass", Window)
BarrackScienceCell.__size = nil

--创建cell
local barrack_science_create_cell_terminal = {
    _name = "barrack_science_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local barrack_id = params[1]
        local max_time = params[2]
        local index = params[3]
        local cell = BarrackScienceCell:new()
        cell:init(barrack_id,max_time,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(barrack_science_create_cell_terminal)
state_machine.init()

function BarrackScienceCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.barrack_id = nil
    self.barrack_data = nil
    self.max_time = nil
    self.index = nil
	 -- Initialize barrack_science_cell state machine.
    local function init_barrack_science_cell_terminal()
		
        --打开升级选项
        local barrack_science_open_update_window_terminal = {
            _name = "barrack_science_open_update_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local need_level = _ED.barracks_escalate_info[""..cell.barrack_id][""..cell.barrack_data.barrack_level].need_barracks_level
                if need_level == -1 then
                    return
                end

                state_machine.excute("barrack_science_lv_up_window_open",0,{cell.barrack_id,cell.index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(barrack_science_open_update_window_terminal)
        state_machine.init()
    end
    
    -- call func barrack_science_cell create state machine.
    init_barrack_science_cell_terminal()

end

function BarrackScienceCell:updateDraw()
    local root = self.roots[1]
    local Text_skill_name = ccui.Helper:seekWidgetByName(root,"Text_skill_name")
    Text_skill_name:setString(self.barrack_data.name)

    local Text_skill_lv_remind = ccui.Helper:seekWidgetByName(root,"Text_skill_lv_remind")
    -- 解析兵营科技数据
    if _ED.barracks_escalate_info == nil or table.nums(_ED.barracks_escalate_info) == 0 then
        initAllBarracksEscapeData()
    end
    local need_level = _ED.barracks_escalate_info[""..self.barrack_id][""..self.barrack_data.barrack_level].need_barracks_level
    Text_skill_lv_remind:setString(string.format(red_alert_all_str[84],need_level - 1))
    if need_level > tonumber(_ED.home_build[""..2].level) then
        Text_skill_lv_remind:setVisible(true)
        Text_skill_lv_remind:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        if need_level == -1 then
            Text_skill_lv_remind:setString(red_alert_all_str[85])
            Text_skill_lv_remind:setVisible(true)
            Text_skill_lv_remind:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))         
        else
            Text_skill_lv_remind:setVisible(false)
            Text_skill_lv_remind:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end
    end
    
    local Panel_skill_icon = ccui.Helper:seekWidgetByName(root,"Panel_skill_icon")
    Panel_skill_icon:removeAllChildren(true)
    local cell = state_machine.excute("barrack_science_icon_create_cell",0,{self.barrack_id,1})
    Panel_skill_icon:addChild(cell)
end

--缓存清理
function BarrackScienceCell:close()
    
end

function BarrackScienceCell:onInit() 
    local csbItem = csb.createNode(config_csb.cells.barrack.barrack_science_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    if BarrackScienceCell.__size == nil then
        BarrackScienceCell.__size = root:getContentSize()
    end

    --打开升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_barrack_science_cell"), nil, 
    {
        terminal_name = "barrack_science_open_update_window", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
	self:updateDraw()
end

function BarrackScienceCell:onEnterTransitionFinish()

end

function BarrackScienceCell:init( barrack_id , max_time , index)
    self.barrack_id = barrack_id
    self.barrack_data = _ED.barracks_info[""..self.barrack_id]
    self.max_time = max_time
    self.index = index
    self:onInit()
    self:setContentSize(BarrackScienceCell.__size)
    return self
end

function BarrackScienceCell:onExit()
    local Panel_skill_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_skill_icon")
    if Panel_skill_icon ~= nil then
        Panel_skill_icon:removeAllChildren(true)
    end
end