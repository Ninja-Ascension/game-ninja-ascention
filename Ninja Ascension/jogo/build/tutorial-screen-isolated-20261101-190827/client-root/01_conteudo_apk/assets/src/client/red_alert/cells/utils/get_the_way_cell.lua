-----------------------------
--获取跳转
-----------------------------
GetTheWayCell = class("GetTheWayCellClass", Window)
GetTheWayCell.__size = nil
--创建cell
local get_the_way_cell_create_cell_terminal = {
    _name = "get_the_way_cell_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local get_way_id = params[1]
        local cell = GetTheWayCell:new()
        cell:init(get_way_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(get_the_way_cell_create_cell_terminal)
state_machine.init()

function GetTheWayCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.get_way_id = nil

    local function init_get_the_way_terminal()
        local get_the_way_to_open_other_terminal = {
            _name = "get_the_way_to_open_other",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("short_cut_go_to_other_window",0,{cell.get_way_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(get_the_way_to_open_other_terminal)
        state_machine.init()
    end
    init_get_the_way_terminal()
end

function GetTheWayCell:onEnterTransitionFinish()

end

function GetTheWayCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_get_way_break_down_4 = ccui.Helper:seekWidgetByName(root,"Text_get_way_break_down_4") -- 名字描述
    local Panel_away_icon = ccui.Helper:seekWidgetByName(root,"Panel_away_icon") -- 图标
    local name = dms.string(dms["function_param"],self.get_way_id,function_param.name)
    local icon = dms.int(dms["function_param"],self.get_way_id,function_param.icon)
    local genre = dms.int(dms["function_param"],self.get_way_id,function_param.genre)
    
    local Text_get_way_number = ccui.Helper:seekWidgetByName(root,"Text_get_way_number") -- 章节
    local Text_get_way_name = ccui.Helper:seekWidgetByName(root,"Text_get_way_name") -- 名字描述
    local Text_get_way_lv = ccui.Helper:seekWidgetByName(root,"Text_get_way_lv") -- 难度
    local Text_get_way_lv_0 = ccui.Helper:seekWidgetByName(root,"Text_get_way_lv_0") -- 是否开启
    local Panel_one_text = ccui.Helper:seekWidgetByName(root,"Panel_one_text")
    local Panel_four_text = ccui.Helper:seekWidgetByName(root,"Panel_four_text")

    local open_npc = dms.int(dms["function_param"],self.get_way_id,function_param.open_npc)
    local npc_name = dms.string(dms["npc"],open_npc,npc.npc_name)

    local open_scene = dms.int(dms["function_param"],self.get_way_id,function_param.open_scene)
    local scene_type = dms.int(dms["pve_scene"],open_scene,pve_scene.scene_type)
    
    if tonumber(genre) >= 5 
        and tonumber(genre) <= 7 
        and open_scene > 0 
        and scene_type ~= nil then
        Panel_away_icon:setBackGroundImage("images/ui/function_icon/achieve_icon_1001.png")
        Text_get_way_number:setString(name)
        Text_get_way_name:setString(npc_name)
        -- Text_get_way_lv:setString(scene_type)
        Text_get_way_lv:setString(gems_difficulty_level[tonumber(scene_type)+1])
        if tonumber(_ED.npc_state[open_npc]) < 0 or tonumber(_ED.scene_current_state[open_scene]) == -1 then
            Text_get_way_lv_0:setString(red_alert_all_str[108])
        else 
            Text_get_way_lv_0:setVisible(false)
        end
        Panel_one_text:setVisible(false)
        Panel_four_text:setVisible(true)
    else
        Panel_away_icon:setBackGroundImage("images/ui/function_icon/achieve_icon_"..icon..".png")
        Text_get_way_break_down_4:setString(name)
        Panel_four_text:setVisible(false)
        Panel_one_text:setVisible(true)
    end
end

function GetTheWayCell:init(get_way_id)
    self.get_way_id = get_way_id
    self:onInit()
    self:setContentSize(GetTheWayCell.__size)
    return self
end

function GetTheWayCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.utils.get_the_way_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(true)
    self:addChild(root)
    table.insert(self.roots, root)
    if GetTheWayCell.__size == nil then
        GetTheWayCell.__size = root:getContentSize()
    end
    --跳转
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_get_way_break_down_1") , nil, 
    {
        terminal_name = "get_the_way_to_open_other", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,   
    }, nil, 0)    
    
    self:onUpdateDraw() 
end

function GetTheWayCell:onExit()

end
