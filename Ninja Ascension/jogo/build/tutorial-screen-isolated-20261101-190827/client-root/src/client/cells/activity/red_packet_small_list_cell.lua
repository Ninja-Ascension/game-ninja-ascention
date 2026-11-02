--------------------------------------------------------------------------------------------------------------
--  说明：节日红包小排行榜cell
--------------------------------------------------------------------------------------------------------------
red_packet_small_list_cell = class("red_packet_small_list_cellClass", Window)
red_packet_small_list_cell.__size = nil

--创建cell
local red_packet_small_list_cell_terminal = {
    _name = "red_packet_small_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = red_packet_small_list_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_packet_small_list_cell_terminal)
state_machine.init()

function red_packet_small_list_cell:ctor()
	self.super:ctor()
	self.roots = {}
    self.activity = {}
end

function red_packet_small_list_cell:updateDrawInfo()
    if not self.activity then
        return
    end
    local root = self.roots[1]
  
    local Text_red_packet_name = ccui.Helper:seekWidgetByName(root, "Text_red_packet_name") --name
    Text_red_packet_name:setString(self.activity.nickName)
    
    local Text_red_packet_rank = ccui.Helper:seekWidgetByName(root, "Text_red_packet_rank") --排名
    Text_red_packet_rank:setString(self.ranking)
    local Panel_rank_top = ccui.Helper:seekWidgetByName(root, "Panel_rank_top") --排名
    Panel_rank_top:removeBackGroundImage()
    if tonumber(self.ranking) <=3  then
       Panel_rank_top:setBackGroundImage(string.format("images/ui/text/GHZ_res/gh_rank_%d.png", self.ranking))
    end
    
    local Text_red_packet_n = ccui.Helper:seekWidgetByName(root, "Text_red_packet_n")   --领取个数
   
    if self.types == 1 then
        Text_red_packet_n:setString(self.activity.sendCount)
    else
        Text_red_packet_n:setString(self.activity.totalDrawGold)
    end 
   
end

function red_packet_small_list_cell:onUpdate(dt)
    
end

function red_packet_small_list_cell:onInit()
    local root = cacher.createUIRef("activity/wonderful/red_packet_rank_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if red_packet_small_list_cell.__size == nil then
        red_packet_small_list_cell.__size = root:getContentSize()
    end
  --  self:clearUIInfo()
	self:updateDrawInfo()
end

function red_packet_small_list_cell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function red_packet_small_list_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_red_packet_name = ccui.Helper:seekWidgetByName(root, "Text_red_packet_name")
    local Text_red_packet_n = ccui.Helper:seekWidgetByName(root, "Text_red_packet_n")
    local Text_red_packet_rank = ccui.Helper:seekWidgetByName(root, "Text_red_packet_rank")  --头像
        Text_red_packet_name:setString("")
        Text_red_packet_n:setString("")
        Text_red_packet_rank:setString("")
end

function red_packet_small_list_cell:reload()

end

function red_packet_small_list_cell:unload()
end

function red_packet_small_list_cell:init(params)
    self.activity = params[1]
    self.ranking =  params[2]
    self.types =  params[3]
	self:onInit()
    self:setContentSize(red_packet_small_list_cell.__size)
    return self
end

function red_packet_small_list_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/red_packet_rank_cell.csb", self.roots[1])
end