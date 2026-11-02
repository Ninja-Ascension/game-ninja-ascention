-- ----------------------------------------------------------------------------------------------------
-- 说明：数码玩家信息页
-------------------------------------------------------------------------------------------------------
SmPlayerMusicSetPage = class("SmPlayerMusicSetPageClass", Window)
local sm_player_music_set_page_open_terminal = {
    _name = "sm_player_music_set_page_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local page = SmPlayerMusicSetPage:createCell():init()
    	return page
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_music_set_page_open_terminal)
state_machine.init()
    
function SmPlayerMusicSetPage:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
    self.try_play = 0 -- 当前试听
	app.load("client.l_digital.cells.player.player_info_backGroudMusic_cell")
    local function init_sm_player_music_set_page_terminal()
        --显示
        local sm_player_music_set_page_show_terminal = {
            _name = "sm_player_music_set_page_show",
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
        local sm_player_music_set_page_hide_terminal = {
            _name = "sm_player_music_set_page_hide",
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

        --刷新
        local sm_player_music_set_page_update_terminal = {
            _name = "sm_player_music_set_page_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.try_play = 0
                instance:onUpdataDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --试听
        local sm_player_music_set_page_try_play_terminal = {
            _name = "sm_player_music_set_page_try_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.try_play ~= tonumber(params) then 
                    instance.try_play = params
                    playBgm(formatMusicFile("background", tonumber(instance.try_play)))
                    instance:onUpdataDraw()
                else
                    instance.try_play = 0
                    local currHomeBgm = readKey("m_curr_home_bgm")
                    playBgm(formatMusicFile("background", tonumber(currHomeBgm)))
                    instance:onUpdataDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_player_music_set_page_show_terminal)
		state_machine.add(sm_player_music_set_page_hide_terminal)
        state_machine.add(sm_player_music_set_page_update_terminal)
        state_machine.add(sm_player_music_set_page_try_play_terminal)
        state_machine.init()
    end
    
    init_sm_player_music_set_page_terminal()
end
function SmPlayerMusicSetPage:onUpdataDraw()
	local root = self.roots[1]
    local bgm_array = zstring.split(dms.string(dms["user_config"], 11 ,user_config.param),",")
    local ScrollView_bgm_select = ccui.Helper:seekWidgetByName(root, "ScrollView_bgm_select")
    if ScrollView_bgm_select then 
        -- DSC重塑使用ScrollView
        local cellList = {}
        for i ,v in pairs(bgm_array) do
            local cell = PlayerInfoBackGroudMusicCell:createCell()
            cell:init(tonumber(v) , i , self.try_play)
            table.insert(cellList,cell)
        end
        addNodeToScrollView({targetScrollView = ScrollView_bgm_select,nodeList = cellList,columns = 2})
    else
        local ListView_bgm_select = ccui.Helper:seekWidgetByName(root, "ListView_bgm_select")
        ListView_bgm_select:removeAllItems()
        app.load("client.cells.utils.multiple_list_view_cell")
        local preMultipleCell = nil
        local multipleCell = nil
        for i ,v in pairs(bgm_array) do
            local cell = PlayerInfoBackGroudMusicCell:createCell()
            cell:init(tonumber(v) , i , self.try_play)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                if multipleCell == nil then
                    multipleCell = MultipleListViewCell:createCell()
                    multipleCell:init(ListView_bgm_select, PlayerInfoBackGroudMusicCell.__size)
                    ListView_bgm_select:addChild(multipleCell)
                    multipleCell.prev = preMultipleCell
                    if preMultipleCell ~= nil then
                        preMultipleCell.next = multipleCell
                    end
                end
                multipleCell:addNode(cell)
                if multipleCell.child2 ~= nil then
                    preMultipleCell = multipleCell
                    multipleCell = nil
                end
            else
                ListView_bgm_select:addChild(cell)
            end
        end
        ListView_bgm_select:requestRefreshView()
    end
end

function SmPlayerMusicSetPage:onInit()
	local csbUserInfo = csb.createNode("player/role_information_tab_4.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdataDraw()
end

function SmPlayerMusicSetPage:init(params)
    -- local _windows = params
    -- self._rootWindows = _windows
    self:onInit()
    return self
end

function SmPlayerMusicSetPage:onExit()
    local currHomeBgm = readKey("m_curr_home_bgm")
    if nil ~= currHomeBgm and self.try_play ~= 0 and self.try_play ~= zstring.tonumber(currHomeBgm) then 
        playBgm(formatMusicFile("background", tonumber(currHomeBgm)))
    end
	state_machine.remove("sm_player_music_set_page_show")
    state_machine.remove("sm_player_music_set_page_hide")
    state_machine.remove("sm_player_music_set_page_update")
    state_machine.remove("sm_player_music_set_page_try_play")
end

function SmPlayerMusicSetPage:createCell()
    local cell = SmPlayerMusicSetPage:new()
    cell:registerOnNodeEvent(cell)
    return cell
end