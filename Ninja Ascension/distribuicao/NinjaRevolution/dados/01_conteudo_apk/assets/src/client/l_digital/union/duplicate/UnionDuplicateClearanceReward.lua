--------------------------------------------------------------------------------------------------------------
--  说明：军团副本通关奖励界面
--------------------------------------------------------------------------------------------------------------
UnionDuplicateClearanceReward = class("UnionDuplicateClearanceRewardClass", Window)

if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    app.load("client.l_digital.cells.union.union_duplicate_clearance_reward_list_cell")
else
    app.load("client.cells.union.union_duplicate_clearance_reward_list_cell")
end
local union_duplicate_clearance_reward_open_terminal = {
            _name = "union_duplicate_clearance_reward_open",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local  _UnionDuplicateClearanceReward =  UnionDuplicateClearanceReward:new()
                _UnionDuplicateClearanceReward:init(params)
                fwin:open(_UnionDuplicateClearanceReward,fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --关闭界面
        local union_duplicate_clearance_reward_close_terminal = {
            _name = "union_duplicate_clearance_reward_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("UnionDuplicateClearanceRewardClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
state_machine.add(union_duplicate_clearance_reward_open_terminal)
state_machine.add(union_duplicate_clearance_reward_close_terminal)
state_machine.init()
function UnionDuplicateClearanceReward:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	
    self.listview = nil
    self.listview_ContainerPosY = nil
    self.playaction = true
	 -- Initialize uniond uplicate clearance reward state machine.
    local function init_union_duplicate_clearance_reward_terminal()
		--close界面
            local union_duplicate_clearance_reward_close_action_terminal = {
            _name = "union_duplicate_clearance_reward_close_action",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playEndAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(union_duplicate_clearance_reward_close_action_terminal)
        state_machine.init()
    end
    
    -- call func init uniond uplicate clearance reward state machine.
    init_union_duplicate_clearance_reward_terminal()

end
function UnionDuplicateClearanceReward:onUpdate()
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_ContainerPosY == posY then
            return
        end
        self.listview_ContainerPosY = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end
function UnionDuplicateClearanceReward:updateDraw()
    local root = self.roots[1]
    local listview = ccui.Helper:seekWidgetByName(root,"ListView_123")
    local open_scene_id = tonumber(_ED.union.union_current_scene_id) --当前
    local Text_2_0 = ccui.Helper:seekWidgetByName(root,"Text_2_0") --当前进度显示

    local scene_name = dms.string(dms["union_pve_scene"],open_scene_id,union_pve_scene.scene_name)
    local str = string.format("%s%d%s  %s",_string_piece_info[97],open_scene_id,_string_piece_info[98],scene_name)
    Text_2_0:setString(str)

    local reward_index = tonumber(_ED.union.user_union_info.duplicate_reward) --领取索引
    local drawindex = 1
    for i=1,1000 do
        local rewardlist = dms.string(dms["union_pve_scene"],i,union_pve_scene.reward)
        if rewardlist == nil then
            break
        end
        if i > reward_index then
            local cell =UnionDuplicateClearanceRewardListCell:createCell()
            cell:init(rewardlist,reward_index,i,drawindex)
            listview:addChild(cell)
            drawindex = drawindex +1
        end
    end
    drawindex = 1
    for i=1,1000 do
        local rewardlist = dms.string(dms["union_pve_scene"],i,union_pve_scene.reward)
        if rewardlist == nil then
            break
        end
        if i <= reward_index then
            local cell =UnionDuplicateClearanceRewardListCell:createCell()
            cell:init(rewardlist,reward_index,i,drawindex)
            listview:addChild(cell)
            drawindex = drawindex +1
        end
    end

    self.listview = listview
    self.listview_ContainerPosY = listview:getInnerContainer():getPositionY()  
end

function UnionDuplicateClearanceReward:onInit()
    local csbUnionDuplicateClearanceReward = csb.createNode("legion/legion_pve_attack.csb")
    local root = csbUnionDuplicateClearanceReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionDuplicateClearanceReward)

    local action = csb.createTimeline("legion/legion_pve_attack.csb") 
    table.insert(self.actions, action)
    csbUnionDuplicateClearanceReward:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123"),  nil, 
    {
        terminal_name = "union_duplicate_clearance_reward_close_action",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_122"),  nil, 
    {
        terminal_name = "union_duplicate_clearance_reward_close_action",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        
        local str = frame:getEvent()
        if str == "window_open_over" then
        elseif str == "window_close_over" then
            state_machine.excute("union_duplicate_clearance_reward_close",0,"")
        end
    end)
    if self.playaction == true then
        action:play("window_open",false)
    end
	self:updateDraw()
    state_machine.unlock("union_duplicate_open_clearance_reward")
end

function UnionDuplicateClearanceReward:onEnterTransitionFinish()

end
function UnionDuplicateClearanceReward:playEndAction()
    self.actions[1]:play("window_close",false)
end
function UnionDuplicateClearanceReward:init(params)
    self.playaction = params
	self:onInit()
	return self
end

function UnionDuplicateClearanceReward:onExit()
    state_machine.remove("union_duplicate_clearance_reward_close_action")
end