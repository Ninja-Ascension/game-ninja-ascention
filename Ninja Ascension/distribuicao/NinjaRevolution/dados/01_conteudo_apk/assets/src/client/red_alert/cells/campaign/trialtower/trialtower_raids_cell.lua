-----------------------------
--三国无双扫荡奖励
-----------------------------
TrialtowerRaidsCell = class("TrialtowerRaidsCellClass", Window)
TrialtowerRaidsCell.__size1 = nil
TrialtowerRaidsCell.__size2 = nil

local trialtower_raids_create_cell_terminal = {
    _name = "trialtower_raids_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local reward_data = params[1]
        local floor = params[2]
        local index = params[3]
        local collect = params[4]
        local cell = TrialtowerRaidsCell:new()
        cell:init(reward_data,floor,index,collect)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_raids_create_cell_terminal)
state_machine.init()

function TrialtowerRaidsCell:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    --奖励信息
    self.reward_data = nil
    --当前层数
    self.floor = nil
    -- 汇总
    self.collect = nil
end


function TrialtowerRaidsCell:onUpdateDraw()
    local root = self.roots[1]
    local col_number = 1
    local col = self:getAllNumbers()
    local Panel_raids_1 = ccui.Helper:seekWidgetByName(root,"Panel_raids_1")
    local Panel_raids_2 = ccui.Helper:seekWidgetByName(root,"Panel_raids_2")
    local Panel_raids_3 = ccui.Helper:seekWidgetByName(root,"Panel_raids_3")
    Panel_raids_1:setVisible(false)
    Panel_raids_2:setVisible(false)
    Panel_raids_3:setVisible(false)
    if tonumber(col) > 5 then
        col_number = 2
    end
    ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_1"):removeAllChildren(true)
    ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_2"):removeAllChildren(true)
    if self.reward_data == nil then 
        Panel_raids = ccui.Helper:seekWidgetByName(root,"Panel_raids_3")
    else
        Panel_raids = ccui.Helper:seekWidgetByName(root,"Panel_raids_"..col_number)
    end
    Panel_raids:setVisible(true)
    local Panel_duplicate_raids_1 = ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_"..col_number)
    Panel_duplicate_raids_1:removeAllChildren(true)
    local Text_duplicate_raids_finish = ccui.Helper:seekWidgetByName(root,"Text_duplicate_raids_finish")
    local Text_duplicate_raids_time = ccui.Helper:seekWidgetByName(root,"Text_duplicate_raids_time_"..col_number)
    local Image_time_bg_1 = ccui.Helper:seekWidgetByName(root,"Image_time_bg_1_"..col_number)
    local Image_time_bg_2 = ccui.Helper:seekWidgetByName(root,"Image_time_bg_2_"..col_number)
    
    if self.reward_data == nil then
        Text_duplicate_raids_finish:setVisible(true)
        Text_duplicate_raids_time:setVisible(false)
        if nil ~= Image_time_bg_1 then
            Image_time_bg_1:setVisible(false)
            Image_time_bg_2:setVisible(false)
        end
        return
    else
        Text_duplicate_raids_finish:setVisible(false)
        Text_duplicate_raids_time:setVisible(true)
        if nil ~= Image_time_bg_1 then
            Image_time_bg_1:setVisible(true)
            Image_time_bg_2:setVisible(true)
        end
        Text_duplicate_raids_time:setString(string.format(red_alert_all_str[118],self.floor))
        if self.collect ~= nil then 
            Text_duplicate_raids_time:setString(red_alert_all_str[200])
            Text_duplicate_raids_time:setVisible(false)
            Image_time_bg_1:setVisible(false)
            Image_time_bg_2:setVisible(false)
        end
    end
    for i,data in pairs(self.reward_data) do
        local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        cell:setAnchorPoint(cc.p(0,0))
        local cell_height = cell:getContentSize().height
        local cell_width = cell:getContentSize().width
        if col_number == 1 then 
            cell:setPosition(cc.p((i-1)*cell_width,0))
        else
            if tonumber(i) > 5 then 
                cell:setPosition(cc.p((i-6)*cell_width,0))
            else
                cell:setPosition(cc.p((i-1)*cell_width,cell_height))
            end
        end
        Panel_duplicate_raids_1:addChild(cell)
    end
    if col > 5 then
        self:setContentSize(TrialtowerRaidsCell.__size2)
    else
        self:setContentSize(TrialtowerRaidsCell.__size1)
    end
end

function TrialtowerRaidsCell:getAllNumbers( )
    if self.reward_data == nil then
        return 1
    end
    local index = 1
    for k,v in pairs(self.reward_data) do
        index = index + 1
    end
    return index
end

function TrialtowerRaidsCell:onEnterTransitionFinish()

end

function TrialtowerRaidsCell:onInit( )
    local root = cacher.createUIRef(config_csb.cells.campaign.trialtower.trialtower_raids_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root)

    if TrialtowerRaidsCell.__size2 == nil then
        local Panel_raids_2 = ccui.Helper:seekWidgetByName(root,"Panel_raids_2")
        TrialtowerRaidsCell.__size2 = Panel_raids_2:getContentSize()
    end
    if TrialtowerRaidsCell.__size1 == nil then
        local Panel_raids_1 = ccui.Helper:seekWidgetByName(root,"Panel_raids_1")
        TrialtowerRaidsCell.__size1 = Panel_raids_1:getContentSize()
    end

	self:onUpdateDraw()	
end


function TrialtowerRaidsCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function TrialtowerRaidsCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_duplicate_raids_1 = ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_1")
    Panel_duplicate_raids_1:removeAllChildren(true)
    local Panel_duplicate_raids_2 = ccui.Helper:seekWidgetByName(root,"Panel_duplicate_raids_2")
    Panel_duplicate_raids_2:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.campaign.trialtower.trialtower_raids_cell)
    root:removeFromParent(false)
    self.roots = {}
end

function TrialtowerRaidsCell:init(reward_data,floor,index,collect)
    self.reward_data = reward_data
    self.floor = floor
    self.collect = collect
    if index ~= nil and index < 6 then
	   self:onInit()
    end
    local col = self:getAllNumbers()
    if col > 5 then
        self:setContentSize(TrialtowerRaidsCell.__size2)
    else
        self:setContentSize(TrialtowerRaidsCell.__size1)
    end
    return self
end

function TrialtowerRaidsCell:onExit()
    local Panel_duplicate_raids_1 = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_duplicate_raids_1")
    if Panel_duplicate_raids_1 ~= nil then
        Panel_duplicate_raids_1:removeAllChildren(true)
    end
    local Panel_duplicate_raids_2 = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_duplicate_raids_2")
    if Panel_duplicate_raids_2 ~= nil then
        Panel_duplicate_raids_2:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.campaign.trialtower.trialtower_raids_cell,self.roots[1])
end
