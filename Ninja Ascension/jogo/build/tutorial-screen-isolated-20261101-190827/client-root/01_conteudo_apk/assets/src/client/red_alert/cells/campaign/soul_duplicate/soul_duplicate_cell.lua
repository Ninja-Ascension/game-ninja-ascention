--------------------------------------------------------------------------------------------------------------
--  将魂副本伤害百分比奖励
--------------------------------------------------------------------------------------------------------------
SoulDuplicateCell = class("SoulDuplicateCellClass", Window)
SoulDuplicateCell.__size = nil
--创建cell
local soul_duplicate_create_cell_terminal = {
    _name = "soul_duplicate_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local rank_info = params[1]
        local index = params[2]
        local cell = SoulDuplicateCell:new()
        cell:init(rank_info,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(soul_duplicate_create_cell_terminal)
state_machine.init()

function SoulDuplicateCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.rank_info = nil

end

function SoulDuplicateCell:updateDraw()
    local root = self.roots[1]
           
       -- _ED.soul_duplicate_rank_info.other_info[i] = {
       --      user_id = i,
       --      user_name = "yanghan",
       --      user_camp = math.random(1,3),
       --      user_rank = i,
       --      user_damage = math.random(1,100),
       --      user_official = math.random(1,9)
       --  }
    local Image_rank_picture_1 = ccui.Helper:seekWidgetByName(root,"Image_rank_picture_1")
    local Image_rank_picture_2 = ccui.Helper:seekWidgetByName(root,"Image_rank_picture_2")
    local Image_rank_picture_3 = ccui.Helper:seekWidgetByName(root,"Image_rank_picture_3")

    Image_rank_picture_1:setVisible(false)
    Image_rank_picture_2:setVisible(false)
    Image_rank_picture_3:setVisible(false)

    local BitmapFontLabel_1 = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_1") -- 排名
    BitmapFontLabel_1:setVisible(true)
    BitmapFontLabel_1:setString("")

    if tonumber(self.rank_info.user_rank) < 4 and tonumber(self.rank_info.user_rank) ~= 0 then
        local Image_rank_picture = ccui.Helper:seekWidgetByName(root,"Image_rank_picture_"..self.rank_info.user_rank) 
        Image_rank_picture:setVisible(true)
    else
        BitmapFontLabel_1:setString(self.rank_info.user_rank)    
    end
    
    local Text_hurt_nuber = ccui.Helper:seekWidgetByName(root,"Text_hurt_nuber") -- 伤害
    Text_hurt_nuber:setString(self.rank_info.user_damage.."%")

    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name") -- 名字
    Text_name:setString(self.rank_info.user_name)

    local Text_level = ccui.Helper:seekWidgetByName(root,"Text_level") -- 官职
    Text_level:setString(red_alert_officer[tonumber(self.rank_info.user_official)])

    local Image_national_1 = ccui.Helper:seekWidgetByName(root,"Image_national_1")
    local Image_national_2 = ccui.Helper:seekWidgetByName(root,"Image_national_2")
    local Image_national_3 = ccui.Helper:seekWidgetByName(root,"Image_national_3")
    Image_national_1:setVisible(false)
    Image_national_2:setVisible(false)
    Image_national_3:setVisible(false)

    local Image_national = ccui.Helper:seekWidgetByName(root,"Image_national_"..self.rank_info.user_camp)
    Image_national:setVisible(true)
end

function SoulDuplicateCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.soul_duplicate.soul_duplicate_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if SoulDuplicateCell.__size == nil then
        SoulDuplicateCell.__size = root:getContentSize()
    end

	self:updateDraw()

end

function SoulDuplicateCell:onEnterTransitionFinish()

end

function SoulDuplicateCell:init(rank_info,index)
    self.rank_info = rank_info
    if index ~= nil and index < 5 then
	   self:onInit()
    end
    self:setContentSize(SoulDuplicateCell.__size)
end


function SoulDuplicateCell:onExit()
    cacher.freeRef(config_csb.cells.campaign.soul_duplicate.soul_duplicate_cell,self.roots[1])

end

function SoulDuplicateCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SoulDuplicateCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.campaign.soul_duplicate.soul_duplicate_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end