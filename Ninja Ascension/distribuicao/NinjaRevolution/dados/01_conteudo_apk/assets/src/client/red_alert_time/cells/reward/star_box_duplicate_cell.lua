-----------------------------
--副本界面管理
-----------------------------
StarBoxDuplicateCell = class("StarBoxDuplicateCellClass", Window)
--创建cell
local star_box_duplicate_create_cell_terminal = {
    _name = "star_box_duplicate_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local floor = params[1]
        local box_type = params[2]
        local scenceID = params[3]
        local cell = StarBoxDuplicateCell:new()
        cell:init(floor, box_type,scenceID)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(star_box_duplicate_create_cell_terminal)
state_machine.init()

function StarBoxDuplicateCell:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    self.floor = nil  -- 1 副本
    self.box_type = nil -- 1 简单 2 普通 3 困难
    --场景id
    self.scene_ID = nil
    self.sceneID = nil  --仅七星台使用
    -- Initialize star_box_duplicate_cell state machine.
    local function init_star_box_duplicate_cell_terminal()
	
        --改变宝箱类型
		local star_box_duplicate_cell_change_type_terminal = {
            _name = "star_box_duplicate_cell_change_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                local box_type = params[2]
                if cell == nil or box_type == nil then
                    return
                end
                cell.box_type = box_type
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --查看宝箱信息
        local star_box_duplicate_cell_see_info_terminal = {
            _name = "star_box_duplicate_cell_see_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                -- print("================宝箱类型",cell.floor) -- 副本
                -- print("========打开宝箱",cell.box_type) -- 难度
                state_machine.excute("duplicate_star_box_window_window_open",0,{cell,cell.floor,cell.box_type,self.sceneID})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新宝箱动画播放状态
        local star_box_duplicate_cell_updatedraw_terminal = {
            _name = "star_box_duplicate_cell_updatedraw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                cell:onUpdateDraw() 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
		state_machine.add(star_box_duplicate_cell_change_type_terminal)
        state_machine.add(star_box_duplicate_cell_see_info_terminal)
        state_machine.add(star_box_duplicate_cell_updatedraw_terminal)
        state_machine.init()
    end
    
    -- call func init star_box_duplicate_cell state machine.
    init_star_box_duplicate_cell_terminal()
end

function StarBoxDuplicateCell:onHide( ... )
    self:setVisible(false)
end

function StarBoxDuplicateCell:onShow( ... )
    self:setVisible(true)
end

-- 播放宝箱闪光动画
function StarBoxDuplicateCell:onUpdateDraw()
	local root = self.roots[1]
    local Panel_star_box = ccui.Helper:seekWidgetByName(root,"Panel_star_box")   
    local Button_star_box = ccui.Helper:seekWidgetByName(root,"Button_star_box")  
    local total_stars = dms.int(dms["pve_scene"],self.scene_ID,pve_scene.total_star)        --总星数
    if tonumber(self.box_type) == battle_enum._fight_type._fight_type_104 + 1 then  -- 七星台
        local npcs = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.npcs), ",")
        local scene_state = tonumber(_ED.scene_current_state[self.sceneID])    -- 已击败npc数量
        if #npcs == scene_state and tonumber(_ED.star_reward_state[self.sceneID]) ~= 1 then
            Panel_star_box:setVisible(true)
            Button_star_box:setVisible(false)
            return
        end
    else
        if tonumber(self.box_type) == 3 then
            self.box_type = 16
        end
        for i, v in pairs(_ED.scene_current_state) do  
            if tonumber(self.box_type) == dms.int(dms["pve_scene"],i,pve_scene.scene_type) + 1 then --场景类型(0:普通 1:精英 2活动 3:试练塔)
                if zstring.tonumber(_ED.get_star_count[i]) >= total_stars and tonumber(_ED.star_reward_state[i]) ~= 1 then
                    Panel_star_box:setVisible(true)
                    Button_star_box:setVisible(false)
                    return
                end
            end
        end 
    end
    Button_star_box:setVisible(true)
    Panel_star_box:setVisible(false)
end

function StarBoxDuplicateCell:onEnterTransitionFinish()

end

function StarBoxDuplicateCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.reward.star_box_duplicate_cell)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_star_box"), nil, 
    {
        terminal_name = "star_box_duplicate_cell_see_info", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_star_box"), nil, 
    {
        terminal_name = "star_box_duplicate_cell_see_info", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

	self:onUpdateDraw()	
end

--宝箱领取    0 未达成 1 可领取 2  已领取
function StarBoxDuplicateCell:getLimitCanGetReward(index)
    local total_stars = dms.int(dms["pve_scene"],index,pve_scene.total_star)        --总星数
    local box_state = 0
    -- print("=========",total_stars,index)
    if zstring.tonumber(_ED.get_star_count[index]) < total_stars then
        box_state = 0
    elseif zstring.tonumber(_ED.get_star_count[index] ) >= total_stars and tonumber(_ED.star_reward_state[index]) ~= 1 then
        box_state = 1
    elseif zstring.tonumber(_ED.get_star_count[index] ) >= total_stars and tonumber(_ED.star_reward_state[index]) == 0 then
        box_state = 2 
    end
    return box_state
end
function StarBoxDuplicateCell:init( floor, box_type,scenceID) 
    self.floor = floor
    self.box_type = box_type
    if tonumber(self.box_type) == 3 then
        self.box_type = 16
    end
    local numbers = 0
    -- print("============self.box_type",self.box_type)
    for i, v in pairs(_ED.scene_current_state) do  
        if tonumber(self.box_type) == dms.int(dms["pve_scene"],i,pve_scene.scene_type) + 1 then --场景类型(0:普通 1:精英 2活动 3:试练塔)
            if tonumber(_ED.scene_current_state[i]) == 0 then
                self.scene_ID = i
            end
            if _ED.scene_current_state[i] == "" then
                self.scene_ID = i - 1
                break
            end
            if self:getLimitCanGetReward(i) == 1 then
                self.scene_ID = i
                break
            end
            if tonumber(v) == -1 then
                self.scene_ID = i - 1
                break
            end
            numbers = numbers + 1
        end
    end 

    -- print("=====scene_ID======",self.scene_ID)
    if self.scene_ID == nil then
        self.scene_ID = #_ED.scene_current_state
    end

    if scenceID ~= nil then
        self.scene_ID = scenceID
        self.sceneID = scenceID
    end
	self:onInit()
    return self
end

function StarBoxDuplicateCell:onExit()

end
