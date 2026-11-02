--------------------------------------------------------------------------------------------------------------
--  说明：节日红包领取cell
--------------------------------------------------------------------------------------------------------------
red_packet_draw_list_cell = class("red_packet_draw_list_cellClass", Window)
red_packet_draw_list_cell.__size = nil

--创建cell
local red_packet_draw_list_cell_terminal = {
    _name = "red_packet_draw_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = red_packet_draw_list_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_packet_draw_list_cell_terminal)
state_machine.init()

function red_packet_draw_list_cell:ctor()
	self.super:ctor()
	self.roots = {}
    self.activity = {}
    self.isopen = false  --是否打开红包详情界面
    app.load("client.cells.campaign.icon.arena_role_icon_cell")
end

function red_packet_draw_list_cell:updateDrawInfo()
    if not self.activity then
        return
    end
    local root = self.roots[1]
  
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name") --name
    Text_player_name:setString(self.activity.nickName)
    
    local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking") --排名
    Text_ranking:setString(self.ranking)

    local Text_jiazhi_n = ccui.Helper:seekWidgetByName(root, "Text_jiazhi_n")   --领取个数
    Text_jiazhi_n:setString(self.activity.drawGold)
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")  --头像
    Panel_player_icon:removeAllChildren(true)
    local icon = ArenaRoleIconCell:createCell()
    icon:init(tonumber(self.activity.headPic), 1)
    Panel_player_icon:addChild(icon)
    
end

function red_packet_draw_list_cell:onUpdate(dt)
    
end

function red_packet_draw_list_cell:onInit()
    local root = cacher.createUIRef("activity/wonderful/red_packet_infor_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if red_packet_draw_list_cell.__size == nil then
        red_packet_draw_list_cell.__size = root:getContentSize()
    end
  --  self:clearUIInfo()
	self:updateDrawInfo()
end

function red_packet_draw_list_cell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function red_packet_draw_list_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    local Text_jiazhi_n = ccui.Helper:seekWidgetByName(root, "Text_jiazhi_n")
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")  --头像
    local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking") --排名
    if Panel_player_icon then
        Panel_player_icon:removeAllChildren(true)
        Text_player_name:setString("")
        Text_jiazhi_n:setString("")
        Text_ranking:setString("")
    end
end

function red_packet_draw_list_cell:reload()

end

function red_packet_draw_list_cell:unload()
end

function red_packet_draw_list_cell:init(params)
    self.activity = params[1]
    self.ranking =  params[2]
	self:onInit()
    self:setContentSize(red_packet_draw_list_cell.__size)
    return self
end

function red_packet_draw_list_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/red_packet_infor_cell.csb", self.roots[1])
end