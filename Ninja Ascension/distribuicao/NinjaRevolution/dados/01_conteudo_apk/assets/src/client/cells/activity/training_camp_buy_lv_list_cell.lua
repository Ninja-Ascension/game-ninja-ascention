--------------------------------------------------------------------------------------------------------------
--  说明：大师训练营购买等级cell
--------------------------------------------------------------------------------------------------------------
training_camp_buy_lv_list_cell = class("training_camp_buy_lv_list_cellClass", Window)
training_camp_buy_lv_list_cell.__size = nil

--创建cell
local training_camp_buy_lv_list_cell_terminal = {
    _name = "training_camp_buy_lv_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = training_camp_buy_lv_list_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(training_camp_buy_lv_list_cell_terminal)
state_machine.init()

function training_camp_buy_lv_list_cell:ctor()
	self.super:ctor()
	self.roots = {}
    self.activity = {}
    self._grade = 1
    
    app.load("client.activity.traingcamp.TrainigCampBuyLv")
end

function training_camp_buy_lv_list_cell:updateDrawInfo()
    local root = self.roots[1]
    local exp = dms.int(dms["activity_config"], 37, activity_config.param)
    local AtlasLabel_camp_buy_lv = ccui.Helper:seekWidgetByName(root, "AtlasLabel_camp_buy_lv")    --经验值
    local Text_buy_lv_up = ccui.Helper:seekWidgetByName(root, "Text_buy_lv_up")  --描述1
    local Text_buy_reward_n = ccui.Helper:seekWidgetByName(root, "Text_buy_reward_n")  --描述2
    local Text_buy_lv_gem_n = ccui.Helper:seekWidgetByName(root, "Text_buy_lv_gem_n")  --点劵数
    AtlasLabel_camp_buy_lv:setString(self.activity[1]*exp)
    Text_buy_lv_up:setString(string.format(tipStringInfo_training_camp_name[8],tonumber(self.activity[1])))
    Text_buy_lv_gem_n:setString(self.activity[2])
end


function training_camp_buy_lv_list_cell:onUpdate(dt)
    
end


function training_camp_buy_lv_list_cell:onInit()
    local root  = cacher.createUIRef("activity/wonderful/training_camp_buy_lv_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
    if training_camp_buy_lv_list_cell.__size == nil then
        training_camp_buy_lv_list_cell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_buy_lv") , nil, 
    {
        terminal_name = "training_camp_buy_confirm_tip", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
        lv = self.activity[1],
        grade = self._grade,
        donation = self.activity[2],
    }, nil, 1)
     
    self:clearUIInfo()
	self:updateDrawInfo()
end

function training_camp_buy_lv_list_cell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function training_camp_buy_lv_list_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local AtlasLabel_camp_buy_lv = ccui.Helper:seekWidgetByName(root, "AtlasLabel_camp_buy_lv")    --经验值
    local Text_buy_lv_up = ccui.Helper:seekWidgetByName(root, "Text_buy_lv_up")  --描述1
    local Text_buy_reward_n = ccui.Helper:seekWidgetByName(root, "Text_buy_reward_n")  --描述2
    local Text_buy_lv_gem_n = ccui.Helper:seekWidgetByName(root, "Text_buy_lv_gem_n")  --点劵数
    
    
    if AtlasLabel_camp_buy_lv then
        AtlasLabel_camp_buy_lv:setString("")
        Text_buy_lv_up:setString("")
        Text_buy_reward_n:setString("")
        Text_buy_lv_gem_n:setString("")
    end
end

function training_camp_buy_lv_list_cell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function training_camp_buy_lv_list_cell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/training_camp_buy_lv_cell.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function training_camp_buy_lv_list_cell:init(params)
    self.activity = params[1]
    self._grade = params[2]
	self:onInit()
    self:setContentSize(training_camp_buy_lv_list_cell.__size)
    return self
end

function training_camp_buy_lv_list_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/training_camp_buy_lv_cell.csb", self.roots[1])
end