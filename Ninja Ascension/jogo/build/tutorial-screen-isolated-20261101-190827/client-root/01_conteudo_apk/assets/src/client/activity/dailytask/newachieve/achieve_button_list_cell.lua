----------------------------------------------------------------------------------------------------
-- 说明：成就新版列表控件
--yanghan 
----------------------------------------------------------------------------------------------------
AchievementButtonListCell = class("AchievementButtonListCellClass", Window)
AchievementButtonListCell.__size = nil
function AchievementButtonListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._button = nil
    self.achieve_type = nil
    self.name = nil
    self.pic_index = nil
    local function init_achievement_ex_list_cell_terminal()

    end
    init_achievement_ex_list_cell_terminal()
end


function AchievementButtonListCell:onUpdateDraw()

end

function AchievementButtonListCell:onInit()

    local root= cacher.createUIRef("activity/DailyTasks/achieve_button_cell.csb","root")
    self:addChild(root)
    table.insert(self.roots, root)

    if AchievementButtonListCell.__size == nil then
        AchievementButtonListCell.__size = root:getContentSize()
    end

    local achieve_type = self.achieve_type 
    local name = self.name 
    local pic_index = self.pic_index 

    local Text_tab_name = ccui.Helper:seekWidgetByName(root, "Text_tab_name")
    Text_tab_name:setString(name)
    local Panel_tab_icon = ccui.Helper:seekWidgetByName(root, "Panel_tab_icon")
    Panel_tab_icon:removeBackGroundImage()
    Panel_tab_icon:setBackGroundImage(string.format("images/ui/function_icon/achieve_icon_%d.png", pic_index))

    local Button_cj_tab = ccui.Helper:seekWidgetByName(root, "Button_cj_tab")
    self._button = Button_cj_tab
    -- Button_cj_tab._istips = nil
    -- Button_cj_tab:removeChild(Button_cj_tab._nodeChild, true)
    -- Button_cj_tab._nodeChild = nil
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_daily_activity_achievement_page_button_of_kinds",
    _widget = Button_cj_tab,
    _achieve_type = achieve_type,
    _invoke = nil,
    _interval = 0.5,})
    local function addButtonTouchEvent(button , _terminal_name , _next_terminal_name , _achieve_type)
        fwin:addTouchEventListener(button, nil, 
        {
            terminal_name = _terminal_name,     
            next_terminal_name = _next_terminal_name, 
            current_button =  button , 
            achieve_type = _achieve_type,
            terminal_state = 0, 
            isPressedActionEnabled = false
        }, 
        nil, 0) 
    end

    if achieve_type == 1 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_level",achieve_type)
    elseif achieve_type == 2 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_pass_duplicute",achieve_type)
    elseif achieve_type == 3 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_fight_up",achieve_type)
    elseif achieve_type == 4 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_fight_top",achieve_type)
    elseif achieve_type == 5 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_vip",achieve_type)
    elseif achieve_type == 6 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_equip",achieve_type)
    elseif achieve_type == 7 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_treasure",achieve_type)
    elseif achieve_type == 8 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_formation",achieve_type)
    elseif achieve_type == 9 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_trialtower",achieve_type)
    elseif achieve_type == 10 then    
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_skill",achieve_type)
    elseif achieve_type == 11 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_mine",achieve_type)
    elseif achieve_type == 12 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_worldboss",achieve_type)
    elseif achieve_type == 13 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_stars",achieve_type)
    elseif achieve_type == 14 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_awaken",achieve_type)
    elseif achieve_type == 15 then
        addButtonTouchEvent(Button_cj_tab,"achieve_develop_manager","achieve_develop_open_ability",achieve_type)
    end 
end

function AchievementButtonListCell:onEnterTransitionFinish()
    
end
function AchievementButtonListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function AchievementButtonListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef("activity/DailyTasks/achieve_button_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end
function AchievementButtonListCell:onExit()
    if root == nil then
        return
    end
    cacher.freeRef("activity/DailyTasks/achieve_button_cell.csb", root)
end

function AchievementButtonListCell:init(achieve_type , name , pic_index ,index)
    self.achieve_type = achieve_type
    self.name = name
    self.pic_index = pic_index
    if index ~= nil and index < 20 then
        self:onInit()       
    end
    
    self:setContentSize(AchievementButtonListCell.__size)

    return self
end

function AchievementButtonListCell:createCell()
    local cell = AchievementButtonListCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

