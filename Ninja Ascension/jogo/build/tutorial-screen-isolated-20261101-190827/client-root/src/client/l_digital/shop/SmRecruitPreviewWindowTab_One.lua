-- ----------------------------------------------------------------------------------------------------
-- 说明：怪兽介绍控件
-------------------------------------------------------------------------------------------------------
SmRecruitPreviewWindowTab_One = class("SmRecruitPreviewWindowTab_OneClass", Window)
SmRecruitPreviewWindowTab_One.__size  = nil

-- 创建cell
local sm_recruit_preview_window_ship_one_cell_create_terminal = {
    _name = "sm_recruit_preview_window_ship_one_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmRecruitPreviewWindowTab_One:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_recruit_preview_window_ship_one_cell_create_terminal)
state_machine.init()

function SmRecruitPreviewWindowTab_One:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil
    
    -- 初始化状态机
    local function init_sm_recruit_preview_window_ship_cell_terminal()

    end 
    init_sm_recruit_preview_window_ship_cell_terminal()

end

-- 刷新
function SmRecruitPreviewWindowTab_One:updateDraw()
    local root = self.roots[1]
    local Text_cut = ccui.Helper:seekWidgetByName(root,"Text_cut")
    local Image_cut = ccui.Helper:seekWidgetByName(root,"Image_cut")

    if self._index == 1 then
        Text_cut:setString(tipStringInfo_diamond_ten_reward_tips[1])
        Image_cut:setVisible(true)
    elseif self._index == self.diamond_table_1 + 1 then
        if self.diamond_table_2 == 0 then
            Text_cut:setString(tipStringInfo_diamond_ten_reward_tips[3])
            Image_cut:setVisible(true)
        else
            Text_cut:setString(tipStringInfo_diamond_ten_reward_tips[2])
            Image_cut:setVisible(true)
        end
    elseif self._index == self.diamond_table_1 + self.diamond_table_2 + 1 then
        Text_cut:setString(tipStringInfo_diamond_ten_reward_tips[3])
        Image_cut:setVisible(true)
    else
        Text_cut:setString("")
        Image_cut:setVisible(false)
    end
end

function SmRecruitPreviewWindowTab_One:onInit()
    local root = cacher.createUIRef("shop/sm_recruit_preview_window_cutt.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmRecruitPreviewWindowTab_One.__size == nil then
        SmRecruitPreviewWindowTab_One.__size = root:getContentSize()
    end

    self:updateDraw()
end

function SmRecruitPreviewWindowTab_One:onEnterTransitionFinish()
    local root = self.roots[1]
end

function SmRecruitPreviewWindowTab_One:clearUIInfo( ... )
end

function SmRecruitPreviewWindowTab_One:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmRecruitPreviewWindowTab_One:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("shop/sm_recruit_preview_window_cutt.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function SmRecruitPreviewWindowTab_One:init(params)
    self._index = params[1]
    self._info = params[2]
    self.diamond_table = params[3]
    if self.diamond_table then
        self.diamond_table_1 = self.diamond_table[1]
        self.diamond_table_2 = self.diamond_table[2]
        self.diamond_table_3 = self.diamond_table[3]
    end

    self:onInit()
    self:setContentSize(SmRecruitPreviewWindowTab_One.__size)
    return self
end

function SmRecruitPreviewWindowTab_One:onExit()
    self:clearUIInfo()
    cacher.freeRef("shop/sm_recruit_preview_window_cutt.csb", self.roots[1])
end