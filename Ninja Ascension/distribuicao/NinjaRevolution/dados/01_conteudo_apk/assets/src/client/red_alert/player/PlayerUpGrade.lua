--------------------------------------------------------------------------------------------------------------
--  说明：升级界面
--------------------------------------------------------------------------------------------------------------
PlayerUpGrade = class("PlayerUpGradeClass", Window)

--打开界面
local player_upgrade_window_open_terminal = {
	_name = "player_upgrade_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerUpGradeClass") == nil then
            local last_level = params[1]
            local last_food = params[2]
            fwin:open(PlayerUpGrade:new():init(last_level,last_food), fwin._windows)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_upgrade_window_close_terminal = {
	_name = "player_upgrade_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerUpGradeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_upgrade_window_open_terminal)
state_machine.add(player_upgrade_window_close_terminal)
state_machine.init()

function PlayerUpGrade:ctor()
	self.super:ctor()
	self.roots = {}

    -- load lua file
    
    --var 
    --原等级
    self.last_level = nil
    --原体力
    self.last_food = nil

end

function PlayerUpGrade:onUpdate(dt)
    if fwin:find("TuitionControllerClass") ~= nil and fwin:find("TuitionControllerClass"):isVisible() == true then
        fwin:find("TuitionControllerClass"):setVisible(false)
    end
    if fwin:find("WindowLockClass") ~= nil and fwin:find("WindowLockClass"):isVisible() == true then
        fwin:find("WindowLockClass"):setVisible(false)
    end
    if fwin:find("RoleDialogueClass") ~= nil and fwin:find("RoleDialogueClass"):isVisible() == true then
        fwin:find("RoleDialogueClass"):setVisible(false)
    end
    
end

--初始化界面
function PlayerUpGrade:updateDraw()
    local root = self.roots[1]
    local jsonPath = nil
    local atlasPath = nil
    -- 绘制主公动画
    local Panel_player_upgrade_big_head = ccui.Helper:seekWidgetByName(root,"Panel_player_upgrade_big_head")
    if nil ~= Panel_player_upgrade_big_head and Panel_player_upgrade_big_head:isVisible() == true then
        Panel_player_upgrade_big_head:removeAllChildren(true)
        if tonumber(_ED.user_info.user_gender) == 1 then
            jsonPath = "sprite/spirte_nanzhu.json"
            atlasPath = "sprite/spirte_nanzhu.atlas"
        elseif tonumber(_ED.user_info.user_gender) == 2 then    
            jsonPath = "sprite/spirte_nvzhu.json"
            atlasPath = "sprite/spirte_nvzhu.atlas"
        end
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(Panel_player_upgrade_big_head:getContentSize().width/2,Panel_player_upgrade_big_head:getContentSize().height/2))
        Panel_player_upgrade_big_head:addChild(animation)
    end

    -- 绘制主公半身体像
    local Panel_big_head = ccui.Helper:seekWidgetByName(root,"Panel_big_head")
    if nil ~= Panel_big_head and Panel_big_head:isVisible() == true then
        local headImageFile = nil
        if tonumber(_ED.user_info.user_gender) == 1 then
            jsonPath = "images/face/big_head/big_head_1.json"
            atlasPath = "images/face/big_head/big_head_1.atlas"
        elseif tonumber(_ED.user_info.user_gender) == 2 then
            jsonPath = "images/face/big_head/big_head_2.json"
            atlasPath = "images/face/big_head/big_head_2.atlas"
        end
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
        animation:setPosition(cc.p(Panel_big_head:getContentSize().width / 2, 0))
        Panel_big_head:addChild(animation)
    end

    local Text_player_upgrade_lv_before = ccui.Helper:seekWidgetByName(root,"Text_player_upgrade_lv_before")        --原等级
    local Text_player_upgrade_lv_up = ccui.Helper:seekWidgetByName(root,"Text_player_upgrade_lv_up")                --当前等级
    local Text_player_upgrade_power_before = ccui.Helper:seekWidgetByName(root,"Text_player_upgrade_power_before")  --原体力
    local Text_player_upgrade_power_up = ccui.Helper:seekWidgetByName(root,"Text_player_upgrade_power_up")          --当前体力
    Text_player_upgrade_lv_before:setString(_ED.last_level)
    Text_player_upgrade_lv_up:setString(_ED.user_info.user_grade)
    Text_player_upgrade_power_before:setString(math.max(0,tonumber(self.last_food)))
    Text_player_upgrade_power_up:setString(_ED.user_info.user_food)

    state_machine.excute("main_window_update_build",0,"")
end

--初始化
function PlayerUpGrade:onInit()
    local csbItem = csb.createNode(config_csb.player.player_upgrade)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.player.player_upgrade)
    action:setTimeSpeed(app.getTimeSpeed())
    action:play("window_open", false)
    csbItem:runAction(action)
    --确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_upgrade_determine"), nil, 
    {
        terminal_name = "player_upgrade_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    self:updateDraw()
    _ED.last_level = _ED.user_info.user_grade
    _ED.last_user_food = _ED.user_info.user_food
end

function PlayerUpGrade:onEnterTransitionFinish()

end

function PlayerUpGrade:init(last_level,last_food)
    self.last_level = last_level
    self.last_food = last_food
	self:onInit()
    return self
end

function PlayerUpGrade:onExit()
    state_machine.remove("player_info_window_show")
    state_machine.remove("player_info_window_hide")
    state_machine.remove("player_info_update_draw")
end

function PlayerUpGrade:destroy()
    -- 还原教学
    if fwin:find("TuitionControllerClass") ~= nil then
        fwin:find("TuitionControllerClass"):setVisible(true)
    end
    if fwin:find("WindowLockClass") ~= nil then
        fwin:find("WindowLockClass"):setVisible(true)
    end
    if fwin:find("RoleDialogueClass") ~= nil then
        fwin:find("RoleDialogueClass"):setVisible(true)
    end
    if _ED._open_new_scene == true then  
        state_machine.excute("easy_duplicate_update_list_view",0,"")
        state_machine.excute("hard_duplicate_update_list_view",0,"")
        state_machine.excute("normal_duplicate_update_list_view",0,"")
    end
end