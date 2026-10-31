----------------------------------------------------------------------------------------------------
-- 说明：等级礼包cell
-------------------------------------------------------------------------------------------------------

ActivityLevelGiftPageViewCell = class("ActivityLevelGiftPageViewCellClass", Window)
    
function ActivityLevelGiftPageViewCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.mouldId = 0
    self.function_id = 0
    self.button_go = nil
        
    -- Initialize all server welfare activity page state machine.
    local function init_activity_level_gift_pageview_cell_terminal()
        local activity_level_gift_pageview_cell_goto_terminal = {
            _name = "activity_level_gift_pageview_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:cleanView(fwin._background)
                fwin:cleanView(fwin._view)
                fwin:cleanView(fwin._viewdialog)
                fwin:cleanView(fwin._ui)
                fwin:open(Home:new(), fwin._view)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if fwin:find("ActivityWindowClass") ~= nil then
                        state_machine.excute("activity_window_hide",0,"")
                    end
                end
                if fwin:find("MenuClass") == nil then
                    fwin:open(Menu:new(), fwin._taskbar)
                end
                if fwin:find("HomeClass") == nil then
                    state_machine.excute("menu_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "menu_manager",     
                                next_terminal_name = "menu_show_home_page", 
                                current_button_name = "Button_home",
                                but_image = "Image_home",       
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        })
                end
                state_machine.excute("menu_back_home_page", 0, "")
                state_machine.excute("menu_clean_page_state", 0, "")
                local cell = params._datas.cell
                state_machine.excute("shortcut_function_trace", 0, {trace_function_id = cell.function_id, _datas = {}})
                state_machine.excute("menu_adventure_open_button", 0, 0) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_level_gift_pageview_cell_goto_terminal)
        state_machine.init()
        
    end
    
    -- call func init all server welfare activity state machine.
    init_activity_level_gift_pageview_cell_terminal()
end



function ActivityLevelGiftPageViewCell:onInit()
    local csbActivityLevelGiftPageViewCell = csb.createNode("activity/wonderful/activity_Levelpacks_page.csb")
    self:addChild(csbActivityLevelGiftPageViewCell)

    local root = csbActivityLevelGiftPageViewCell:getChildByName("root")
    table.insert(self.roots, root)
    
    self:setContentSize(cc.size(80,248))
    self.button_go = ccui.Helper:seekWidgetByName(root, "Button_go")
    self:onUpdateDraw()
    
    fwin:addTouchEventListener(self.button_go, nil, 
    {
        terminal_name = "activity_level_gift_pageview_cell_goto",
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function ActivityLevelGiftPageViewCell:setBGColor(types)
    local root = self.roots[1]
    if types == 1 then 
        root:setColor(cc.c3b(150,150,150))
    else 
        root:setColor(cc.c3b(255,255,255))
    end
end

function ActivityLevelGiftPageViewCell:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local mouldData = dms.element(dms["level_gift_bag_param"], self.mouldId)
    local levelText = ccui.Helper:seekWidgetByName(root, "Text_032")
    local level = dms.atoi(mouldData,level_gift_bag_param.level_limit)
    if levelText ~= nil then
        levelText:setString("" .. level .. _string_piece_info[6])
    end
    self.function_id = dms.atoi(mouldData,level_gift_bag_param.user_fos_idx)
    
    local functionData = dms.element(dms["function_param"],self.function_id)
    local openIcon = dms.atoi(functionData ,function_param.icon) --图标
    local openName = dms.atos(functionData ,function_param.name) --名字
    local openDescribe = dms.atos(functionData,function_param.describe) --描述信息
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local describeInfo = ""
        local describeData = zstring.split(openDescribe, "|")
        for i, v in pairs(describeData) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            describeInfo = describeInfo .. word_info[3]
        end
        
        openDescribe = describeInfo
    end
    --self.openType = dms.string(dms["function_param"],self.functionId ,function_param.genre) --类型
    local panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    panel_1:removeBackGroundImage()
    local IconWay = string.format("images/ui/function_icon/function_icon_%d.png", openIcon)
    panel_1:setBackGroundImage(IconWay)

    ccui.Helper:seekWidgetByName(root, "Text_id"):setString(openName)
    ccui.Helper:seekWidgetByName(root, "Text_7"):setString(openDescribe)
    local user_level = zstring.tonumber(_ED.user_info.user_grade)

    local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
    if user_level >= level then 
        --可以前往
        self.button_go:setVisible(true)
        Text_lv:setVisible(false)
    else
        --不能前往
        self.button_go:setVisible(false)
        Text_lv:setVisible(true)
    end
end

function ActivityLevelGiftPageViewCell:onEnterTransitionFinish()
   
end

function ActivityLevelGiftPageViewCell:onExit()
	
end

function ActivityLevelGiftPageViewCell:init(id)
    self.mouldId = id
    self:onInit()
end

function ActivityLevelGiftPageViewCell:createCell()
    local cell = ActivityLevelGiftPageViewCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end