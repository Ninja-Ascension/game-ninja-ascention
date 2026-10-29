--------------------------------------------------------------------------------------------------------------
--  将魂副本伤害排行奖励
--------------------------------------------------------------------------------------------------------------
SoulDuplicateRewardCell = class("SoulDuplicateRewardCellClass", Window)
SoulDuplicateRewardCell.__size = nil
--创建cell
local soul_duplicate_reward_create_cell_terminal = {
    _name = "soul_duplicate_reward_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local reward_id = params[1]
        local index = params[2]
        local cell = SoulDuplicateRewardCell:new()
        cell:init(reward_id,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(soul_duplicate_reward_create_cell_terminal)
state_machine.init()

function SoulDuplicateRewardCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.reward_id = nil

end

function SoulDuplicateRewardCell:updateDraw()
    local root = self.roots[1]
    -- id = 1 ,            -- int not null 主键，自增长
    -- reward_type = 2 ,   -- int 奖励类型 1伤害百分比 2总排行
    -- need_condition = 3 , --string
    -- reward_items = 4 ,  -- string
    local reward_id = self.reward_id
    local need_condition = dms.string(dms["soul_copy_reward"],reward_id,soul_copy_reward.need_condition)
    local scene_reward_id = dms.int(dms["soul_copy_reward"],reward_id,soul_copy_reward.reward_items)
    local reward_type = dms.int(dms["soul_copy_reward"],reward_id,soul_copy_reward.reward_type)
    local reward_items = dms.string(dms["scene_reward"],scene_reward_id,scene_reward.reward_items)
    reward_items = zstring.split(reward_items,",")
    local prop_item_temp = reward_items[1]
    local prop_type_temp = reward_items[2]
    local item_value_temp = reward_items[3]
    local data = {
        item_value = item_value_temp,
        prop_type = prop_type_temp,
        prop_item = prop_item_temp
    }
    local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward")
    Panel_reward:removeAllChildren(true)
    local reward_cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,false})   
    Panel_reward:addChild(reward_cell)

    local Panel_reward_small = ccui.Helper:seekWidgetByName(root,"Panel_reward_small")
    Panel_reward_small:removeBackGroundImage()
    if tonumber(prop_type_temp) == 1 then
        Panel_reward_small:setBackGroundImage("images/ui/props/props_4002.png")
    elseif tonumber(prop_type_temp) == 2 then
        Panel_reward_small:setBackGroundImage("images/ui/props/props_4001.png")
    elseif tonumber(prop_type_temp) == 5 then
        Panel_reward_small:setBackGroundImage("images/ui/props/props_4008.png")
    elseif tonumber(prop_type_temp) == 6 then
        local pic_index = dms.int(dms["prop_mould"],prop_item_temp,prop_mould.pic_index)
        Panel_reward_small:setBackGroundImage("images/ui/props/props_"..pic_index..".png")        
    elseif tonumber(prop_type_temp) == 7 then
      
    elseif tonumber(prop_type_temp) == 13 then
      
    elseif tonumber(prop_type_temp) == 31 then
        Panel_reward_small:setBackGroundImage("images/ui/props/props_4016.png")
    elseif tonumber(prop_type_temp) == 32 then
        Panel_reward_small:setBackGroundImage("images/ui/props/props_4017.png")
    elseif tonumber(prop_type_temp) == 34 then
       
    end         


    local Text_reward_v = ccui.Helper:seekWidgetByName(root,"Text_reward_v") --奖励数量
    Text_reward_v:setString("x"..item_value_temp)

    local Text_harm_v = ccui.Helper:seekWidgetByName(root,"Text_harm_v") --伤害值  排名

    local Text_harm = ccui.Helper:seekWidgetByName(root,"Text_harm")

    if reward_type == 1 then
        Text_harm_v:setString(need_condition.."%")
        Text_harm:setString(red_alert_all_str[103])
    elseif reward_type == 2 then
        need_condition = zstring.split(need_condition,"|")
        if tonumber(need_condition[1]) == 1 then 
            Text_harm_v:setString(need_condition[1])
        else
            Text_harm_v:setString(need_condition[1] .. "-" ..need_condition[2])
        end
        Text_harm:setString(red_alert_all_str[104])
    end


end

function SoulDuplicateRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.soul_duplicate.soul_duplicate_reward_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SoulDuplicateRewardCell.__size == nil then
        SoulDuplicateRewardCell.__size = root:getContentSize()
    end

	self:updateDraw()

end

function SoulDuplicateRewardCell:onEnterTransitionFinish()

end

function SoulDuplicateRewardCell:init(reward_id,index)
    self.reward_id = reward_id
    if index ~= nil and index < 5 then
	   self:onInit()
    end
    self:setContentSize(SoulDuplicateRewardCell.__size)
end

function SoulDuplicateRewardCell:close()

end

function SoulDuplicateRewardCell:onExit()
    local Panel_reward = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_reward")
    if Panel_reward ~= nil then
        Panel_reward:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.campaign.soul_duplicate.soul_duplicate_reward_cell,self.roots[1])
end

function SoulDuplicateRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SoulDuplicateRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward")
    Panel_reward:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.campaign.soul_duplicate.soul_duplicate_reward_cell,root)
    root:removeFromParent(false)
    self.roots = {}
end