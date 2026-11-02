--------------------------------------------------------------------------------------------------------------
--  说明：副本章节界面
--------------------------------------------------------------------------------------------------------------
PveChapter = class("PveChapterClass", Window)

--打开界面
local pve_chapter_open_terminal = {
	_name = "pve_chapter_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = PveChapter:new():init(params)
    	fwin:open(panel, fwin._ui)
	    return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local pve_chapter_close_terminal = {
	_name = "pve_chapter_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveChapterClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pve_chapter_open_terminal)
state_machine.add(pve_chapter_close_terminal)
state_machine.init()

function PveChapter:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil

    self._current_count = nil
    self._last_count = nil
    self._last_chapter_cell = nil       -- 最后开启的章节

    local function init_pve_chapter_terminal()
        local pve_chapter_show_terminal = {
            _name = "pve_chapter_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_chapter_hide_terminal = {
            _name = "pve_chapter_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local pve_chapter_update_draw_terminal = {
            _name = "pve_chapter_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateListInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_chapter_show_terminal)
        state_machine.add(pve_chapter_hide_terminal)
        state_machine.add(pve_chapter_update_draw_terminal)
        state_machine.init()
    end
    
    init_pve_chapter_terminal()
end

function PveChapter:checkCompleteChapter()
    if self._current_count ~= nil and self._last_count ~= nil and self._last_chapter_cell ~= nil then
        if self._last_count < self._current_count then
            self._last_count = self._current_count
            state_machine.excute("pve_chapter_cell_play_complete_effect", 0, self._last_chapter_cell)
        end
    end
end

function PveChapter:refreshListView( ... )
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root, "ListView_chapter")
    ListView:jumpToTop()
    ListView:getInnerContainer():setPositionY(ListView:getInnerContainer():getPositionY() - 1)
    ListView:requestRefreshView()
end

function PveChapter:updateListInfo( ... )
    local root = self.roots[1]
    self.listview:jumpToTop()
    local isNext = false
    local normalScene = {}
    local count = 0

    for k,v in pairs(_ED.scene_current_state) do
        local _scene_type = dms.int(dms["pve_scene"], k, pve_scene.scene_type) 
        if _scene_type == battle_enum._fight_type._fight_type_0 then
            local open_level = dms.int(dms["pve_scene"], k, pve_scene.open_level) 
            -- if tonumber(_ED.user_info.user_grade) >= open_level then
                if tonumber(v) < 0 then
                    if isNext == true then
                        break
                    else
                        isNext = true
                    end
                end
                count = count + 1
                table.insert(normalScene, v)
            -- end
        end
    end

    if self._current_count == nil then
        self._current_count = count - 1
        self._last_count = count - 1
    end
    self._current_count = count - 1
    self._last_chapter_cell = nil

    local items = self.listview:getItems()
    for k,v in pairs(items) do
        state_machine.excute("pve_chapter_cell_update_info", 0, {cell = v, index = k, scene_id = count, state = normalScene[count]})
        if self._last_chapter_cell == nil and normalScene[count] ~= nil and tonumber(normalScene[count]) > 0 then
            self._last_chapter_cell = v
        end
        count = count - 1
    end

    if #items > #normalScene then
        local index = 0
        for i=#normalScene + 1, #items do
            self.listview:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #normalScene then
        for i=#items + 1, #normalScene do
            local cell = state_machine.excute("pve_chapter_create_cell", 0, {i, count, normalScene[count]})
            self.listview:addChild(cell)
            if self._last_chapter_cell == nil and normalScene[count] ~= nil and tonumber(normalScene[count]) > 0 then
                self._last_chapter_cell = cell
            end
            count = count - 1
        end
    end

    self.listview:requestRefreshView()
    self.listview_poy = self.listview:getInnerContainer():getPositionY()
    self.listview_height = self.listview:getInnerContainer():getPositionY()
    
    local ListView_attribute_icon = ccui.Helper:seekWidgetByName(root, "ListView_attribute_icon")
    local items = ListView_attribute_icon:getItems()
    for k,v in pairs(items) do
        state_machine.excute("pve_gain_cell_update_info", 0, {cell = v})
    end

    self:checkCompleteChapter()
end

function PveChapter:updateDraw()
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root, "ListView_chapter")
    ListView:jumpToTop()
    ListView:removeAllItems()

    local isNext = false
    local normalScene = {}
    local count = 0

    for k,v in pairs(_ED.scene_current_state) do
        local _scene_type = dms.int(dms["pve_scene"], k, pve_scene.scene_type) 
        if _scene_type == battle_enum._fight_type._fight_type_0 then
            local open_level = dms.int(dms["pve_scene"], k, pve_scene.open_level) 
            -- if tonumber(_ED.user_info.user_grade) >= open_level then
                if tonumber(v) < 0 then
                    if isNext == true then
                        break
                    else
                        isNext = true
                    end
                end
                count = count + 1
                table.insert(normalScene, v)
            -- end
        end
    end

    if self._current_count == nil then
        self._current_count = count - 1
        self._last_count = count - 1
    end
    self._current_count = count - 1
    self._last_chapter_cell = nil
    for k,v in pairs(normalScene) do
        local cell = state_machine.excute("pve_chapter_create_cell", 0, {k, count, normalScene[count]})
        ListView:addChild(cell)
        if self._last_chapter_cell == nil and tonumber(normalScene[count]) > 0 then
            self._last_chapter_cell = cell
        end
        count = count - 1
    end

    ListView:requestRefreshView()
    self.listview = ListView
    self.listview_poy = ListView:getInnerContainer():getPositionY()
    self.listview_height = ListView:getInnerContainer():getPositionY()
	
	--关卡增益
	local ListView_attribute_icon = ccui.Helper:seekWidgetByName(root, "ListView_attribute_icon")
	ListView_attribute_icon:removeAllItems()
	for i=1 , 7 do
		local cell = state_machine.excute("pve_gain_cell", 0, {i,0,true})
		ListView_attribute_icon:addChild(cell)
	end
	ListView_attribute_icon:requestRefreshView()

    self:checkCompleteChapter()
end

function PveChapter:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_player_build_arrow_down:setVisible(true)
        else
            self._Image_player_build_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_player_build_arrow_up:setVisible(true)
        else
            self._Image_player_build_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

--初始化
function PveChapter:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_chapter_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_player_build_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_production_arrow_down")
    self._Image_player_build_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_production_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_player_build_arrow_down:stopAllActions()
    self._Image_player_build_arrow_up:stopAllActions()
    playActions(self._Image_player_build_arrow_down)
    playActions(self._Image_player_build_arrow_up)
    self._Image_player_build_arrow_down:setVisible(false)
    self._Image_player_build_arrow_up:setVisible(false)

    self:updateDraw()
end

function PveChapter:onEnterTransitionFinish()

end

function PveChapter:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function PveChapter:onExit()
    state_machine.remove("pve_chapter_show")
    state_machine.remove("pve_chapter_hide")
    state_machine.remove("pve_chapter_update_draw")
end