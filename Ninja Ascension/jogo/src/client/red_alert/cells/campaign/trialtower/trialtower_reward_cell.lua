-----------------------------
--三国无双奖励控件
-----------------------------
TrialtowerRewardCell = class("TrialtowerRewardCellClass", Window)
TrialtowerRewardCell.__size = nil

local trialtower_reward_create_cell_terminal = {
    _name = "trialtower_reward_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local reward_data = params[1]
        local floor = params[2]
        local index = params[3]
        local cell = TrialtowerRewardCell:new()
        cell:init(reward_data,floor,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_reward_create_cell_terminal)
state_machine.init()

function TrialtowerRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    --奖励信息
    self.reward_data = nil
    --当前层数
    self.floor = nil

end


function TrialtowerRewardCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_title = ccui.Helper:seekWidgetByName(root,"Text_title")
    Text_title:setString(string.format(red_alert_all_str[118],self.floor))

    for i = 1,5 do
        local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
        Panel_reward:removeAllChildren(true)
    end

    for i,data in pairs(self.reward_data) do
        local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
        local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        Panel_reward:addChild(cell)
    end
end


function TrialtowerRewardCell:onEnterTransitionFinish()

end

function TrialtowerRewardCell:onInit( )
    local root = cacher.createUIRef(config_csb.cells.campaign.trialtower.trialtower_reward_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root)

    if TrialtowerRewardCell.__size == nil then
        TrialtowerRewardCell.__size = root:getContentSize()
    end

	self:onUpdateDraw()	
end


function TrialtowerRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function TrialtowerRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    for i = 1,5 do
        local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
        Panel_reward:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.campaign.trialtower.trialtower_reward_cell)
    root:removeFromParent(false)
    self.roots = {}
end

function TrialtowerRewardCell:init(reward_data,floor,index)
    self.reward_data = reward_data
    self.floor = floor
    if index ~= nil and index < 5 then
	   self:onInit()
    end
    self:setContentSize(TrialtowerRewardCell.__size)
    return self
end

function TrialtowerRewardCell:onExit()
    for i = 1,5 do
        local Panel_reward = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_reward_"..i)
        if Panel_reward ~= nil then 
            Panel_reward:removeAllChildren(true)
        end
    end
    cacher.freeRef(config_csb.cells.campaign.trialtower.trialtower_reward_cell,self.roots[1])
end
