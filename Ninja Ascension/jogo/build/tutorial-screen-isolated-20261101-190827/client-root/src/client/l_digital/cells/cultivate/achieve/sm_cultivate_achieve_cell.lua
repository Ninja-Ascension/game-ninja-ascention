--------------------------------------------------------------------------------------------------------------
--  说明：成就单个控件
--------------------------------------------------------------------------------------------------------------
SmCultivateAchieveCell = class("SmCultivateAchieveCellClass", Window)
SmCultivateAchieveCell.__size = nil

--创建cell
local sm_cultivate_achieve_cell_terminal = {
    _name = "sm_cultivate_achieve_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCultivateAchieveCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_cultivate_achieve_cell_terminal)
state_machine.init()

function SmCultivateAchieveCell:ctor()
	self.super:ctor()
	self.roots = {}

	 -- Initialize sm_cultivate_spirit_cell state machine.
    local function init_sm_cultivate_spirit_cell_terminal()
        
        local sm_cultivate_spirit_cell_check_terminal = {
            _name = "sm_cultivate_spirit_cell_check",
            _init = function (terminal)
                app.load("client.l_digital.cultivate.achieve.SmCultivateAchieveWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell.params.speed < cell.params.condition then
                    return
                end
                --控制按钮连点
                local btn = params._datas.terminal_button
                if btn then
                    btn:setTouchEnabled(false)
                    btn:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                        btn:setTouchEnabled(true)
                    end)})
                    )
                end
                local function responseDrawAchieveRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("sm_cultivate_achieve_update_choose_state", 0, response.node.index)
                        end
                    end
                end
                protocol_command.draw_achievement_reward.param_list = ""..cell.params.id
                NetworkManager:register(protocol_command.draw_achievement_reward.code, nil, nil, nil, cell, responseDrawAchieveRewardCallback, false, nil)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_spirit_cell_update_terminal = {
            _name = "sm_cultivate_spirit_cell_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params[1]
                cells:unload()
                cells:reload()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_spirit_cell_check_terminal)
        state_machine.add(sm_cultivate_spirit_cell_update_terminal)
        state_machine.init()
    end 
    -- call func sm_cultivate_spirit_cell create state machine.
    init_sm_cultivate_spirit_cell_terminal()

end

function SmCultivateAchieveCell:updateDraw()
    local root = self.roots[1]

    local panel_list = ccui.Helper:seekWidgetByName(root, "Panel_list")
    panel_list:removeBackGroundImage()

    local Text_change_name = ccui.Helper:seekWidgetByName(root, "Text_change_name")
    Text_change_name:setString(self.params.name)

    local txt_des = ccui.Helper:seekWidgetByName(root, "Text_change_name_0")
    txt_des:setString(self.params.des)

    local txt_speed = ccui.Helper:seekWidgetByName(root, "Text_speed")
    txt_speed:setString(self.params.reward)

    local Text_loading = ccui.Helper:seekWidgetByName(root, "Text_loading")
    Text_loading:setString(self.params.speed .. "/" .. self.params.condition)

    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    LoadingBar_1:setPercent(self.params.speed/self.params.condition*100)

    local path = self.params.speed == -1 and "images/ui/bar/sm_list_bar4.png" or "images/ui/bar/sm_list_bar3.png"

    panel_list:setBackGroundImage(path)

    -- txt_des:removeAllChildren(true)
    -- local richTextName = ccui.RichText:create()
    -- local size = txt_des:getContentSize()
    -- txt_des:setString(self.params.des)
    -- richTextName:ignoreContentAdaptWithSize(false)
    -- richTextName:setContentSize(cc.size(size.width, 0))
    -- richTextName:setAnchorPoint(0, 0)
    -- local rt, count, text = draw.richTextCollectionMethod(richTextName, 
    -- self.params.des, 
    -- cc.c3b(255, 255, 255),
    -- cc.c3b(255, 255, 255),
    -- 0, 
    -- 0, 
    -- txt_des:getFontName(), 
    -- txt_des:getFontSize(),
    -- chat_rich_text_color)
    -- richTextName:formatTextExt()
    -- local rich_size = richTextName:getContentSize()
    -- richTextName:setPositionY(size.height/2 + rich_size.height/2)
    -- txt_des:addChild(richTextName)

    local img = ccui.Helper:seekWidgetByName(root, "Image_14")
    if tonumber(self.params.is_display) == 0 then
        Text_loading:setVisible(false)
        LoadingBar_1:setVisible(false)
        img:setVisible(false)
        --txt_des:setPositionY(txt_des:getPositionY() - 10)
    else
        Text_loading:setVisible(true)
        LoadingBar_1:setVisible(true)
        img:setVisible(true)
    end

    if self.params.speed == -1 then
        Text_loading:setVisible(false)
        LoadingBar_1:setVisible(false)
        img:setVisible(false)
        txt_speed:setVisible(false)
    else
        Text_loading:setVisible(true)
        LoadingBar_1:setVisible(true)
        img:setVisible(true)
        txt_speed:setVisible(true)
    end

    local panel_list = ccui.Helper:seekWidgetByName(root, "Panel_land_list_3")     

    local startAnimation = panel_list:getChildByName("ArmatureNode_2")
    local ArmatureNode_speed = panel_list:getChildByName("ArmatureNode_speed")
    
    local animation_index = self.params.speed >= self.params.condition and 0 or 1

    draw.initArmature(ArmatureNode_speed, nil, -1, 0, 1)
    csb.animationChangeToAction(ArmatureNode_speed, animation_index, animation_index, false)

    draw.initArmature(startAnimation, nil, -1, 0, 1)
    csb.animationChangeToAction(startAnimation, animation_index, animation_index, false)

    ArmatureNode_speed:setVisible(self.params.speed ~= -1)

    local img_ywc = ccui.Helper:seekWidgetByName(root, "Image_ywc")
    img_ywc:setVisible(self.params.speed == -1)

    for i=1,3 do
        local img_start = ccui.Helper:seekWidgetByName(root, "Image_star_".. i)
        local Image_star_bg = ccui.Helper:seekWidgetByName(root, "Image_star_bg_".. i)
        local show_stars = (self.params.speed == -1 or self.params.condition == self.params.speed) and self.params.stars or (self.params.stars - 1)
        if img_start ~= nil and i <= zstring.tonumber(self.params.stars) then
            img_start:setVisible(true)
        else
            img_start:setVisible(false)
        end
        if Image_star_bg and i <= zstring.tonumber(self.params.have_stars) then
            Image_star_bg:setVisible(true)
        else
            Image_star_bg:setVisible(false)
        end
    end
end

function SmCultivateAchieveCell:onInit()
    local root = cacher.createUIRef("cultivate/cultivate_achievement_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if SmCultivateAchieveCell.__size == nil then
        SmCultivateAchieveCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_land_list_3"):getContentSize()
    end

    -- 领取奖励的事件响应
    local Button_1 = ccui.Helper:seekWidgetByName(root, "Panel_list")
    fwin:addTouchEventListener(Button_1, nil, 
    {
        terminal_name = "sm_cultivate_spirit_cell_check",      
        terminal_state = 0, 
        cell = self,
        terminal_button = Button_1,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function SmCultivateAchieveCell:onEnterTransitionFinish()

end

function SmCultivateAchieveCell:clearUIInfo( ... )
    local root = self.roots[1]
    for i=1,3 do
        local Panel_digimon_head = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
        if Panel_digimon_head ~= nil then
            Panel_digimon_head:setVisible(false)
        end
    end
    local Panel_name = ccui.Helper:seekWidgetByName(root, "Text_change_name")
    local Panel_name0 = ccui.Helper:seekWidgetByName(root, "Text_change_name_0")
    local Text_speed = ccui.Helper:seekWidgetByName(root, "Text_speed")
    if Panel_name ~= nil then
        Panel_name:setString("")
    end
    if Panel_name0 ~= nil then
        Panel_name0:setString("")
    end
    if Text_speed ~= nil then
        Text_speed:setString("")
    end
end

function SmCultivateAchieveCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmCultivateAchieveCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_achievement_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmCultivateAchieveCell:init(params)
    self.params = params[1]
    self.index = params[2]
    -- self.current_index = params[2]
    self:onInit()
    if SmCultivateAchieveCell.__size then
        self:setContentSize(SmCultivateAchieveCell.__size)
    end
    return self
end

function SmCultivateAchieveCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("cultivate/cultivate_achievement_list.csb", self.roots[1])
end