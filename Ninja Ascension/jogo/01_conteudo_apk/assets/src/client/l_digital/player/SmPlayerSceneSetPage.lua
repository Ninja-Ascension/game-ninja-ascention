-- ----------------------------------------------------------------------------------------------------
-- 说明：数码玩家信息背景图选择页
-------------------------------------------------------------------------------------------------------
SmPlayerSceneSetPage = class("SmPlayerSceneSetPageClass", Window)
local sm_player_scene_set_page_open_terminal = {
    _name = "sm_player_scene_set_page_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local page = SmPlayerSceneSetPage:createCell():init()
    	return page
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_scene_set_page_open_terminal)
state_machine.init()
    
function SmPlayerSceneSetPage:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	app.load("client.l_digital.cells.player.player_info_backGroudImage_cell")
    local function init_sm_player_scene_set_page_terminal()
        --显示
        local sm_player_scene_set_page_show_terminal = {
            _name = "sm_player_scene_set_page_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                	instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏
        local sm_player_scene_set_page_hide_terminal = {
            _name = "sm_player_scene_set_page_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新按钮
        local sm_player_scene_set_page_update_button_terminal = {
            _name = "sm_player_scene_set_page_update_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local itmes = ccui.Helper:seekWidgetByName(instance.roots[1], "ScrollView_bg_select"):getChildren()
                for i ,v in pairs(itmes) do
                    state_machine.excute("player_info_backGroudImage_cell_update_button",0,v)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_player_scene_set_page_show_terminal)
		state_machine.add(sm_player_scene_set_page_hide_terminal)
        state_machine.add(sm_player_scene_set_page_update_button_terminal)
        state_machine.init()
    end
    
    init_sm_player_scene_set_page_terminal()
end
function SmPlayerSceneSetPage:onUpdataDraw()
	local root = self.roots[1]
	local bgi_array = zstring.split(dms.string(dms["user_config"], 10 ,user_config.param),",")
    local ScrollView_bg_select = ccui.Helper:seekWidgetByName(root, "ScrollView_bg_select")
    ScrollView_bg_select:removeAllChildren(true)
    local cell_size = nil
    local height_n = math.ceil(#bgi_array / 3)
    for i , v in pairs(bgi_array) do 
        local cell = PlayerInfoBackGroudImageCell:createCell()
        cell:init(tonumber(v))
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
        ScrollView_bg_select:addChild(cell)
        cell:setPosition(cc.p( ((i - 1) % 3) * cell_size.width , math.ceil( i / 3) * cell_size.height))
    end
    local total_height = math.max(height_n * cell_size.height , ScrollView_bg_select:getContentSize().height)
    ScrollView_bg_select:getInnerContainer():setContentSize(cc.size(ScrollView_bg_select:getContentSize().width , total_height))
    local itmes = ScrollView_bg_select:getChildren()
end

function SmPlayerSceneSetPage:onInit()
	local csbUserInfo = csb.createNode("player/role_information_tab_3.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_tx"),nil, 
    {
        terminal_name = "sm_player_scene_set_page_change_head",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	self:onUpdataDraw()
end

function SmPlayerSceneSetPage:init(params)
    -- local _windows = params
    -- self._rootWindows = _windows
    self:onInit()
    return self
end

function SmPlayerSceneSetPage:onExit()
	state_machine.remove("sm_player_scene_set_page_show")
    state_machine.remove("sm_player_scene_set_page_hide")
    state_machine.remove("sm_player_scene_set_page_update_button")
end

function SmPlayerSceneSetPage:createCell()
    local cell = SmPlayerSceneSetPage:new()
    cell:registerOnNodeEvent(cell)
    return cell
end