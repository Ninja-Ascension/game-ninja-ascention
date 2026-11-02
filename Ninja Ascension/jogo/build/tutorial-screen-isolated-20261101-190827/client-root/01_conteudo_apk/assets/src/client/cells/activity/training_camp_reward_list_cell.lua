--------------------------------------------------------------------------------------------------------------
--  说明：大师训练营奖励cell
--------------------------------------------------------------------------------------------------------------
training_camp_reward_list_cell_create = class("training_camp_reward_list_cell_createClass", Window)
training_camp_reward_list_cell_create.__size = nil

--创建cell
local training_camp_reward_list_cell_create_terminal = {
    _name = "training_camp_reward_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = training_camp_reward_list_cell_create:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(training_camp_reward_list_cell_create_terminal)
state_machine.init()

function training_camp_reward_list_cell_create:ctor()
	self.super:ctor()
	self.roots = {}
    self.activity = {}
    self._idex = 1   --1代表竖着的第一个框
    self.imageOne = false
    self.imageTwo = false
    self.imageThree = false
    self.isSpecila =false
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.traingcamp.TrainigCampReward")
end

function training_camp_reward_list_cell_create:updateDrawInfo()
    local root = self.roots[1]
   
    local Text_camp_lv = ccui.Helper:seekWidgetByName(root, "Text_camp_lv")    --等级
    local Panel_camp_elite_icon = ccui.Helper:seekWidgetByName(root, "Panel_camp_reward_icon_1")  --奖励1
    local Panel_camp_advanced_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_camp_reward_icon_2")  --奖励2
    local Panel_camp_advanced_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_camp_reward_icon_3")  --奖励3

    Panel_camp_elite_icon:removeAllChildren(true)
    Panel_camp_advanced_icon_1:removeAllChildren(true)
    Panel_camp_advanced_icon_2:removeAllChildren(true)


    local jsonFile = "images/ui/effice/effect_bkmxly2/effect_bkmxly2.json"      --背景光效
    local atlasFile = "images/ui/effice/effect_bkmxly2/effect_bkmxly2.atlas"
    local animation_1 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local animation_2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local animation_3 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
   
    if #self.activity[1] ~= 0 then
        local reward_free = self:initReward(self.activity[1],1)
        self.imageOne =true
        Panel_camp_elite_icon:addChild(reward_free) 
        if self.isSpecila  then
            animation_1:setPosition(60,60)
            Panel_camp_elite_icon:addChild(animation_1)
        end
    end
    if #self.activity[2] ~= 0 then
        local reward_master_one = self:initReward(self.activity[2],1)
        if reward_master_one then
            self.imageTwo = true
            Panel_camp_advanced_icon_1:addChild(reward_master_one) 
            if self.isSpecila  then
                animation_2:setPosition(60,60)
                Panel_camp_advanced_icon_1:addChild(animation_2)
            end
        end
        local reward_master_two = self:initReward(self.activity[2],2)
        if reward_master_two then
            self.imageThree = true
            Panel_camp_advanced_icon_2:addChild(reward_master_two) 
            if self.isSpecila  then
                animation_3:setPosition(60,60)
                Panel_camp_advanced_icon_2:addChild(animation_3)
            end
        end
    end
    Text_camp_lv:setString(self.activity[3]) 

    for i=1,3 do
        ccui.Helper:seekWidgetByName(root, "Image_icon_choose_"..i):setVisible(false)
    end  
    self:updateReward()
end

function training_camp_reward_list_cell_create:updateReward()
    local info =  json.decode(_ED.active_activity[157].activity_params)
    local Button_camp_rec =  ccui.Helper:seekWidgetByName(self.roots[1], "Button_camp_rec")  --领取按钮
    local Panel_camp_rec =  ccui.Helper:seekWidgetByName(self.roots[1], "Panel_camp_rec")  
    local Panel_camp_rec_b =  ccui.Helper:seekWidgetByName(self.roots[1], "Panel_camp_rec_b") 

    local Image_reward_g_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_reward_g_1")  --图片1
    local Image_reward_g_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_reward_g_2")  --图片2
    local Image_reward_g_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_reward_g_3")  --图片3
    
    local Image_camp_already_rec_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_camp_already_rec_1")  --勾1
    local Image_camp_already_rec_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_camp_already_rec_2")  --勾2
    local Image_camp_already_rec_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_camp_already_rec_3")  --勾3

    Button_camp_rec:setVisible(true)
    Panel_camp_rec:setVisible(true)
    Panel_camp_rec_b:setVisible(true)

    if tonumber(info.userActivityInfo.level)>= self.activity[3] then
        if (#self.activity[1] == 0) then
            Button_camp_rec:setVisible(false)
            Panel_camp_rec:setVisible(false)
            Image_reward_g_1:setVisible(false)
            if self.imageOne then
                Image_camp_already_rec_1:setVisible(true)
            end
        end
        if tonumber(info.userActivityInfo.buyMaster) == 0  then
            for k,v in pairs(info.userActivityInfo.drawFreeLevel) do
                if tonumber(v) == self.activity[3]   then
                    Button_camp_rec:setVisible(false)
                    Panel_camp_rec:setVisible(false)
                    Image_reward_g_1:setVisible(false)
                    if self.imageOne then
                        Image_camp_already_rec_1:setVisible(true)
                    end
                    return
                end
            end   
        else
            for k,v in pairs(info.userActivityInfo.drawFreeLevel) do
                if tonumber(v) == self.activity[3]   then
                    Panel_camp_rec:setVisible(false)
                    Image_reward_g_1:setVisible(false)
                    if self.imageOne then
                        Image_camp_already_rec_1:setVisible(true)
                    end
                  --  return
                end
            end              
            for k,v in pairs(info.userActivityInfo.drawMasterLevel) do   
                if tonumber(v) == self.activity[3] then
                    Button_camp_rec:setVisible(false)
                    Panel_camp_rec:setVisible(false)
                    Panel_camp_rec_b:setVisible(false)
                    Image_reward_g_2:setVisible(false)
                    Image_reward_g_3:setVisible(false)
                    if self.imageTwo then
                        Image_camp_already_rec_2:setVisible(true)
                    end
                    if self.imageThree then
                        Image_camp_already_rec_3:setVisible(true)
                    end
                    Image_reward_g_1:setVisible(false)
                    Image_camp_already_rec_1:setVisible(true)
                    return
                end
            end             
        end
    else
        Button_camp_rec:setVisible(false)
        Panel_camp_rec:setVisible(false)
        Panel_camp_rec_b:setVisible(false)
    end
end

function training_camp_reward_list_cell_create:initReward(info,idex)
     -- 奖励
    local rewards = zstring.splits(info, "|", ",")
    if not rewards[idex] then
        return
    end
    rewards = rewards[idex]
    local rewardType = zstring.tonumber(rewards[1])
    local cell = ResourcesIconCell:createCell()
    if 13 == rewardType then
        local table = {}
        if rewards[4] ~= nil and tonumber(rewards[4]) ~= -1 then
            table.shipStar = tonumber(rewards[4])
        end
        cell:init(rewardType, tonumber(rewards[3]), tonumber(rewards[2]),nil,nil,true,true,1,table)
    else
        cell:init(rewardType, tonumber(rewards[3]), tonumber(rewards[2]),nil,nil,true,true,1)
    end
    return cell
end

-- function training_camp_reward_list_cell_create:onUpdate(dt)
    
-- end


function training_camp_reward_list_cell_create:onInit()
    local root = cacher.createUIRef("activity/wonderful/training_camp_reward_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
    if training_camp_reward_list_cell_create.__size == nil then
        training_camp_reward_list_cell_create.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_rec"), nil, 
    {
        terminal_name = "training_camp_reward_draw", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
        page = self.activity[3],
        clickidex = i
    }, nil, 1)

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_camp_reward_icon_"..i), nil, 
        {
            terminal_name = "training_camp_reward_show", 
            terminal_state = 0, 
            touch_black = false,
            cells = self,
            page = self.activity[3],
            clickidex = i,
        }, nil, 1)
    end
     
    self:clearUIInfo()
	self:updateDrawInfo()
end

function training_camp_reward_list_cell_create:onEnterTransitionFinish()
    local root = self.roots[1]
end

function training_camp_reward_list_cell_create:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_camp_lv = ccui.Helper:seekWidgetByName(root, "Text_camp_lv")    --等级
    local Panel_camp_elite_icon = ccui.Helper:seekWidgetByName(root, "Panel_camp_reward_icon_1")  --奖励1
    local Panel_camp_advanced_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_camp_reward_icon_2")  --奖励2
    local Panel_camp_advanced_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_camp_reward_icon_3")  --奖励3
    local Image_reward_g_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_reward_g_1")  --图片1
    local Image_reward_g_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_reward_g_2")  --图片2
    local Image_reward_g_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_reward_g_3")  --图片3
    
    local Image_camp_already_rec_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_camp_already_rec_1")  --勾1
    local Image_camp_already_rec_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_camp_already_rec_2")  --勾2
    local Image_camp_already_rec_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_camp_already_rec_3")  --勾3

    local Button_camp_rec =  ccui.Helper:seekWidgetByName(self.roots[1], "Button_camp_rec")  --领取按钮
    local Panel_camp_rec =  ccui.Helper:seekWidgetByName(self.roots[1], "Panel_camp_rec")  
    local Panel_camp_rec_b =  ccui.Helper:seekWidgetByName(self.roots[1], "Panel_camp_rec_b") 
    if Panel_camp_elite_icon then
        Text_camp_lv:setString("")
        Panel_camp_elite_icon:removeAllChildren(true)
        Panel_camp_advanced_icon_1:removeAllChildren(true)
        Panel_camp_advanced_icon_2:removeAllChildren(true)
        Image_reward_g_1:setVisible(false)
        Image_reward_g_2:setVisible(false)
        Image_reward_g_3:setVisible(false)
        Image_camp_already_rec_1:setVisible(false)
        Image_camp_already_rec_2:setVisible(false)
        Image_camp_already_rec_3:setVisible(false)
        Button_camp_rec:setVisible(false)
        Panel_camp_rec:setVisible(false)
        Panel_camp_rec_b:setVisible(false)
    end
end

function training_camp_reward_list_cell_create:reload()
    local root = self.roots[1]
    if root ~= nil then
        return 
    end
    self:onInit()
end

function training_camp_reward_list_cell_create:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/training_camp_reward_cell.csb", root)
    root:stopAllActions()
 --   self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function training_camp_reward_list_cell_create:init(params)
    self.activity = params
    self._idex = self.activity[3]
    self.isSpecila = self.activity[4]
    if self._idex <= 5 then
        self:onInit()
    end
    self:setContentSize(training_camp_reward_list_cell_create.__size)
    return self
end

function training_camp_reward_list_cell_create:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/training_camp_reward_cell.csb", self.roots[1])
end