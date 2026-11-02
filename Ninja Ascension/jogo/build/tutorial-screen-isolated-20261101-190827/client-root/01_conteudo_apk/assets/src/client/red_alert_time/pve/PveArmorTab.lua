-- ------------------------------------------------------------------------------------------------------------
--  说明：装甲补给
-- ------------------------------------------------------------------------------------------------------------
PveArmorTab = class("PveArmorTabClass", Window)

--打开界面
local pve_armor_tab_open_terminal = {
	_name = "pve_armor_tab_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = PveArmorTab:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local pve_armor_tab_close_terminal = {
	_name = "pve_armor_tab_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveArmorTabClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pve_armor_tab_open_terminal)
state_machine.add(pve_armor_tab_close_terminal)
state_machine.init()

function PveArmorTab:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_pve_armor_arrow_down = nil
    self._Image_pve_armor_arrow_up = nil

    self._need_refresh_list = false

    app.load("client.red_alert_time.cells.pve.pve_parts_supply_sweep_cell")
    app.load("client.red_alert_time.cells.pve.pve_parts_supply_unlock_cell")
    app.load("client.red_alert_time.cells.pve.pve_parts_supply_lock_cell")
    app.load("client.red_alert_time.pve.PveArmorInfor")
    app.load("client.red_alert_time.pve.PveArmorBuyTimes")

    local function init_pve_armor_tab_terminal()
        local pve_armor_tab_show_terminal = {
            _name = "pve_armor_tab_show",
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

        local pve_armor_tab_hide_terminal = {
            _name = "pve_armor_tab_hide",
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
        local pve_armor_tab_update_draw_terminal = {
            _name = "pve_armor_tab_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance.listview_poy
                instance:updateDraw()
                if math.abs(posY) > math.abs(instance.listview_height) then
                    posY = instance.listview_height
                end
                instance.listview:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 补充次数
        local pve_armor_tab_add_times_terminal = {
            _name = "pve_armor_tab_add_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("pve_armor_buy_times_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_armor_tab_update_attack_times_terminal = {
            _name = "pve_armor_tab_update_attack_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateAttackTimes()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_armor_tab_show_terminal)
        state_machine.add(pve_armor_tab_hide_terminal)
        state_machine.add(pve_armor_tab_update_draw_terminal)
        state_machine.add(pve_armor_tab_add_times_terminal)
        state_machine.add(pve_armor_tab_update_attack_times_terminal)
        state_machine.init()
    end
    
    init_pve_armor_tab_terminal()
end

function PveArmorTab:refreshListView( ... )
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root, "ListView_pve_armor")
    ListView:jumpToTop()
    ListView:getInnerContainer():setPositionY(ListView:getInnerContainer():getPositionY() - 1)
    ListView:requestRefreshView()
end

function PveArmorTab:updateAttackTimes()
    local root = self.roots[1]
    local Text_armor_checkpoint_reset_t = ccui.Helper:seekWidgetByName(root, "Text_armor_checkpoint_reset_t")
    Text_armor_checkpoint_reset_t:removeAllChildren(true)
    -- local total_times = dms.int(dms["base_consume"], 103, base_consume.vip_0_value + tonumber(_ED.vip_grade)) + activity_add
    times = getArmorPveAttackTimes()
    local str = string.gsub(red_alert_time_str[296], "@x!", times)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setContentSize(cc.size(Text_armor_checkpoint_reset_t:getContentSize().width, Text_armor_checkpoint_reset_t:getContentSize().height))
    local fontSize = Text_armor_checkpoint_reset_t:getFontSize()
    local rt2, count2, text2 = draw.richTextCollectionMethod(_richText, 
        str, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        fontSize,
        chat_rich_text_color)
    _richText:setPosition(cc.p(Text_armor_checkpoint_reset_t:getContentSize().width / 2, Text_armor_checkpoint_reset_t:getContentSize().height / 2))
    Text_armor_checkpoint_reset_t:addChild(_richText)

    local Button_armor_add_time = ccui.Helper:seekWidgetByName(root, "Button_armor_add_time")
    local max_buy_count = dms.int(dms["base_consume"], 103, base_consume.vip_0_value + tonumber(_ED.vip_grade))
    if max_buy_count <= zstring.tonumber(_ED.armor_pve_buy_times) then
        Button_armor_add_time:setBright(false)
        Button_armor_add_time:setTouchEnabled(false)
    else
        Button_armor_add_time:setBright(true)
        Button_armor_add_time:setTouchEnabled(true)
    end
end

function PveArmorTab:updateDraw()
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root, "ListView_pve_armor")
    ListView:jumpToTop()
    ListView:removeAllItems()

    local count = 0
    for k,v in pairs(_ED.scene_current_state) do
        local _scene_type = dms.int(dms["pve_scene"], k, pve_scene.scene_type) 
        if _scene_type == battle_enum._fight_type._fight_type_15 then
            count = count + 1
            local open_level = dms.int(dms["pve_scene"], k, pve_scene.open_level) 
            if tonumber(_ED.user_info.user_grade) >= open_level then
                local cell = state_machine.excute("pve_parts_supply_unlock_create_cell", 0, {count, k, v, 2})
                ListView:addChild(cell)
            else
                local cell = state_machine.excute("pve_parts_supply_lock_create_cell", 0, {count, k, v, 2})
                ListView:addChild(cell)
            end
        end
    end

    ListView:requestRefreshView()
    self.listview = ListView
    self.listview_poy = ListView:getInnerContainer():getPositionY()
    self.listview_height = ListView:getInnerContainer():getPositionY()
    self._need_refresh_list = true

    self:updateAttackTimes()
end

function PveArmorTab:onUpdate(dt)
    if self.listview ~= nil then
        if self._need_refresh_list == true then
            self._need_refresh_list = false
            return
        end

        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_pve_armor_arrow_down:setVisible(true)
        else
            self._Image_pve_armor_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_pve_armor_arrow_up:setVisible(true)
        else
            self._Image_pve_armor_arrow_up:setVisible(false)
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
function PveArmorTab:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_armor_supply_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_add_time"), nil, 
    {
        terminal_name = "pve_armor_tab_add_times",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_armor_prompt"), nil, 
    {
        terminal_name = "pve_armor_infor_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    self._Image_pve_armor_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_pve_armor_arrow_down")
    self._Image_pve_armor_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_pve_armor_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_pve_armor_arrow_down:stopAllActions()
    self._Image_pve_armor_arrow_up:stopAllActions()
    playActions(self._Image_pve_armor_arrow_down)
    playActions(self._Image_pve_armor_arrow_up)
    self._Image_pve_armor_arrow_down:setVisible(false)
    self._Image_pve_armor_arrow_up:setVisible(false)

    self:updateDraw()
end

function PveArmorTab:onEnterTransitionFinish()

end

function PveArmorTab:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function PveArmorTab:onExit()
    state_machine.remove("pve_armor_tab_show")
    state_machine.remove("pve_armor_tab_hide")
    state_machine.remove("pve_armor_tab_update_draw")
    state_machine.remove("pve_armor_tab_add_times")
    state_machine.remove("pve_armor_tab_update_attack_times")
end