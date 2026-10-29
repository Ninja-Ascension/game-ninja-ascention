--------------------------------------------------------------------------------------------------------------
--  说明：背景音乐cell
--------------------------------------------------------------------------------------------------------------
PlayerInfoBackGroudMusicCell = class("PlayerInfoBackGroudMusicCellClass", Window)
PlayerInfoBackGroudMusicCell.__size = nil
function PlayerInfoBackGroudMusicCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.soundId = 0
    self.index = 0
    self.try_play = 0 -- 试听
	 -- Initialize union duplicate clearance reward list cell state machine.
    local function init_player_info_backGroudMusic_cell_terminal()
        --切换背景音乐
        local player_info_backGroudMusic_cell_choose_terminal = {
            _name = "player_info_backGroudMusic_cell_choose",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local currHomeBgm = readKey("m_curr_home_bgm")
                if tonumber(currHomeBgm) == tonumber(_ED.init_home_bgm[cell.index]) then
                else
                    writeKey("m_curr_home_bgm" , _ED.init_home_bgm[cell.index])
                    cc.UserDefault:getInstance():flush()
                    local total_bgm = dms.searchs(dms["sound_effect_param"], sound_effect_param.sound_effect, currHomeBgm)
                    for i , v in pairs(total_bgm) do
                        local x = dms.string(dms["sound_effect_param"] , tonumber(v[1]) , sound_effect_param.sound_effect)
                        local data = dms.element(dms["sound_effect_param"] , tonumber(v[1]))
                        data[sound_effect_param.sound_effect] = "".._ED.init_home_bgm[cell.index]
                    end
                    fwin._current_music = tonumber(_ED.init_home_bgm[cell.index])
                    fwin._last_music = tonumber(_ED.init_home_bgm[cell.index])
                    fwin:find("MenuClass").__cmusic = fwin._current_music
                    playBgm(formatMusicFile("background", tonumber(_ED.init_home_bgm[cell.index])))
                    state_machine.excute("sm_player_music_set_page_update",0,"sm_player_music_set_page_update.")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --试听
        local player_info_backGroudMusic_cell_try_play_terminal = {
            _name = "player_info_backGroudMusic_cell_try_play",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local currHomeBgm = readKey("m_curr_home_bgm")
                if tonumber(currHomeBgm) == tonumber(_ED.init_home_bgm[cell.index]) then
                else
                    state_machine.excute("sm_player_music_set_page_try_play",0,tonumber(_ED.init_home_bgm[cell.index]))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(player_info_backGroudMusic_cell_choose_terminal)
        state_machine.add(player_info_backGroudMusic_cell_try_play_terminal)
        state_machine.init()
    end
    init_player_info_backGroudMusic_cell_terminal()

end

function PlayerInfoBackGroudMusicCell:updateDrawButton(cell)
    local root = cell.roots[1]

end

function PlayerInfoBackGroudMusicCell:updateDraw()
    local root = self.roots[1]
    local music_data = dms.element(dms["sound_effect_param"], self.soundId)
    local name = dms.atos(music_data , sound_effect_param.window_name)
    local Text_bgm_name = ccui.Helper:seekWidgetByName(root, "Text_bgm_name")
    Text_bgm_name:setString(name)
    Text_bgm_name:setColor(PlayerInfoBackGroudMusicCell.initTextColor)

    local currBgm = tonumber(_ED.init_home_bgm[self.index])

    local Image_bar_2 = ccui.Helper:seekWidgetByName(root, "Image_bar_2")--当前背景音乐高亮图/当前选择背景音乐点击控件(DSC)
    if __lua_project_id == __lua_project_l_digital then 
        -- DSC重塑
        Image_bar_2:setTouchEnabled(true)
    else
        Image_bar_2:setTouchEnabled(false)
        Image_bar_2:setVisible(false)
    end
    local Button_play = ccui.Helper:seekWidgetByName(root, "Button_play")
    Button_play:setVisible(true)
    local currHomeBgm = readKey("m_curr_home_bgm")
    local Image_bgm_select_hook = ccui.Helper:seekWidgetByName(root, "Image_bgm_select_hook")
    Image_bgm_select_hook:setVisible(false)
    if currBgm == tonumber(currHomeBgm) then
        if __lua_project_id == __lua_project_l_digital then 
            -- DSC重塑
            Image_bar_2:setTouchEnabled(false)
        else
            Image_bar_2:setVisible(true)
            Button_play:setVisible(false)
        end
        
        Text_bgm_name:setColor(cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]))
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            Text_bgm_name:setColor(cc.c3b(71, 71, 71))
        end
        Image_bgm_select_hook:setVisible(true)
    end

    local bofangTexture = "images/ui/text/XTSZ_res/bofang.png"
    local tingzhiTexture = "images/ui/text/XTSZ_res/tingzhi.png"
    Button_play:loadTextures(bofangTexture,bofangTexture,bofangTexture)
    if self.try_play == tonumber(_ED.init_home_bgm[self.index]) then
        Text_bgm_name:setColor(cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]))
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            Text_bgm_name:setColor(cc.c3b(71, 71, 71))
        end
        Button_play:loadTextures(tingzhiTexture,tingzhiTexture,tingzhiTexture)
    end
    -- DSC重塑
    local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    if Panel_1 ~= nil then 
        Panel_1:removeBackGroundImage()
        Panel_1:setBackGroundImage(string.format("image/setting/setting_music_%s.png", self.index))
    end
end

function PlayerInfoBackGroudMusicCell:onInit()
    local csbItem = csb.createNode("player/role_information_tab_4_cell.csb")
    local root = csbItem:getChildByName("root")
    -- local root = cacher.createUIRef("player/role_information_tab_4_cell.csb","root")
    table.insert(self.roots, root)
    self:addChild(csbItem)
    if PlayerInfoBackGroudMusicCell.__size == nil then
        local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
        PlayerInfoBackGroudMusicCell.__size = Panel_2:getContentSize()
    end

    if __lua_project_id == __lua_project_l_digital then 
        -- DSC重塑
        local Image_bar_2 = ccui.Helper:seekWidgetByName(root, "Image_bar_2")
        Image_bar_2:setTouchEnabled(true)
        fwin:addTouchEventListener(Image_bar_2,  nil, 
        {
            terminal_name = "player_info_backGroudMusic_cell_choose",
            terminal_state = 0,
            _cell = self,
        }, 
        nil, 0)
    else
        --切换背景音乐
        local Image_bgm_select_slot = ccui.Helper:seekWidgetByName(root, "Image_bgm_select_slot")
        Image_bgm_select_slot:setTouchEnabled(true)
        fwin:addTouchEventListener(Image_bgm_select_slot,  nil, 
        {
            terminal_name = "player_info_backGroudMusic_cell_choose",
            terminal_state = 0,
            _cell = self,
        }, 
        nil, 0)
    end

    --试听
    local Image_bar_1 = ccui.Helper:seekWidgetByName(root, "Image_bar_1")
    fwin:addTouchEventListener(Image_bar_1,  nil, 
    {
        terminal_name = "player_info_backGroudMusic_cell_try_play",
        terminal_state = 0,
        _cell = self,
    }, 
    nil, 0)

    local Button_play = ccui.Helper:seekWidgetByName(root, "Button_play")
    fwin:addTouchEventListener(Button_play,  nil, 
    {
        terminal_name = "player_info_backGroudMusic_cell_try_play",
        terminal_state = 0,
        _cell = self,
    }, 
    nil, 0)

    if PlayerInfoBackGroudMusicCell.initTextColor == nil then
        PlayerInfoBackGroudMusicCell.initTextColor = ccui.Helper:seekWidgetByName(root, "Text_bgm_name"):getColor()
    end
	self:updateDraw()
end

function PlayerInfoBackGroudMusicCell:onEnterTransitionFinish()

end

function PlayerInfoBackGroudMusicCell:init( soundId,index,try_play)
    self.soundId = soundId
    self.index = index
    self.try_play = try_play
	self:onInit()
    self:setContentSize(PlayerInfoBackGroudMusicCell.__size)
	return self
end

function PlayerInfoBackGroudMusicCell:onExit()
    cacher.freeRef("player/role_information_tab_4_cell.csb", self.roots[1])
end

function PlayerInfoBackGroudMusicCell:createCell()
	local cell = PlayerInfoBackGroudMusicCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function PlayerInfoBackGroudMusicCell:unload()
end
