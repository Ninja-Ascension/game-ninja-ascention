--------------------------------------------------------------------------------------------------------------
--  说明：背景图

--------------------------------------------------------------------------------------------------------------
PlayerInfoBackGroudImageCell = class("PlayerInfoBackGroudImageCellClass", Window)
PlayerInfoBackGroudImageCell.__size = nil
function PlayerInfoBackGroudImageCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.index = 0
	 -- Initialize union duplicate clearance reward list cell state machine.
    local function init_player_info_backGroudImage_cell_terminal()
        local player_info_backGroudImage_cell_choose_terminal = {
            _name = "player_info_backGroudImage_cell_choose",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local backGroundImage = cc.UserDefault:getInstance():getStringForKey(getKey("backGroundImage"))
                if tonumber(backGroundImage) == tonumber(cell.index) then
                else
                    writeKey("backGroundImage",cell.index)
                    state_machine.excute("home_hero_change_backGroudImage",0,"home_hero_change_backGroudImage.")
                    state_machine.excute("sm_player_scene_set_page_update_button",0,"sm_player_scene_set_page_update_button.")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local player_info_backGroudImage_cell_update_button_terminal = {
            _name = "player_info_backGroudImage_cell_update_button",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawButton(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(player_info_backGroudImage_cell_update_button_terminal)
		state_machine.add(player_info_backGroudImage_cell_choose_terminal)
        state_machine.init()
    end
    init_player_info_backGroudImage_cell_terminal()

end

function PlayerInfoBackGroudImageCell:updateDrawButton(cell)
    local root = cell.roots[1]
    local Button_bg_select = ccui.Helper:seekWidgetByName(root, "Button_bg_select")
    local backGroundImage = cc.UserDefault:getInstance():getStringForKey(getKey("backGroundImage"))
    local notChangeTexture = "images/ui/text/XTSZ_res/cjsz_kuang.png"
    local changeTexture = "images/ui/text/XTSZ_res/cjsz_kuang2.png"
    if tonumber(backGroundImage) == tonumber(cell.index) then
        Button_bg_select:loadTextures(changeTexture,changeTexture,changeTexture)
    else
        Button_bg_select:loadTextures(notChangeTexture,notChangeTexture,notChangeTexture)
    end
end

function PlayerInfoBackGroudImageCell:updateDraw()
    local root = self.roots[1]
    local Panel_bg_view = ccui.Helper:seekWidgetByName(root, "Panel_bg_view")
    Panel_bg_view:removeBackGroundImage()
    Panel_bg_view:setBackGroundImage(string.format("images/ui/bg/home_bg_view_%d.png", tonumber(self.index)))
    self:updateDrawButton(self)

    local Text_bg_name = ccui.Helper:seekWidgetByName(root, "Text_bg_name")
    Text_bg_name:setString(_back_groud_image_name[tonumber(self.index)])
end

function PlayerInfoBackGroudImageCell:onInit()
    local root = cacher.createUIRef("player/role_information_tab_3_cell.csb","root")
    table.insert(self.roots, root)
    self:addChild(root)
    if PlayerInfoBackGroudImageCell.__size == nil then
        local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
        PlayerInfoBackGroudImageCell.__size = Panel_2:getContentSize()
    end
    local Button_bg_select = ccui.Helper:seekWidgetByName(root, "Button_bg_select")
    fwin:addTouchEventListener(Button_bg_select,  nil, 
    {
        terminal_name = "player_info_backGroudImage_cell_choose",
        terminal_state = 0,
        _cell = self,
    }, 
    nil, 0)
    
	self:updateDraw()
end

function PlayerInfoBackGroudImageCell:onEnterTransitionFinish()

end

function PlayerInfoBackGroudImageCell:init(index)
    self.index = index
	self:onInit()
    self:setContentSize(PlayerInfoBackGroudImageCell.__size)
	return self
end

function PlayerInfoBackGroudImageCell:onExit()
    cacher.freeRef("player/role_information_tab_3_cell.csb", self.roots[1])
end

function PlayerInfoBackGroudImageCell:createCell()
	local cell = PlayerInfoBackGroudImageCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
