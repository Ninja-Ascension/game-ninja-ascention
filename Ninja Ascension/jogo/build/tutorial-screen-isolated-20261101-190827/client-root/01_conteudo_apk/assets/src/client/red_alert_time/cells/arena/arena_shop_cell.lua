-----------------------------
--战地争霸的商店列表的cell
-----------------------------
ArenaShopCell = class("ArenaShopCellClass", Window)
ArenaShopCell.__size = nil

local arena_shop_cell_terminal = {
    _name = "arena_shop_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaShopCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_shop_cell_terminal)
state_machine.init()

function ArenaShopCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = nil
	self._index = 0
	
	-- app.load("client.red_alert_time.mail.MailPresentationInfo")
	
	-- app.load("client.red_alert_time.cells.worldMap.player_head_icon")
	app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
	
 	local function init_arena_shop_cell_terminal()
	
		local arena_shop_cell_response_terminal = {
            _name = "arena_shop_cell_response",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 5}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--确认兑换
		local arena_shop_cell_exchange_confirmation_terminal = {
            _name = "arena_shop_cell_exchange_confirmation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
                local exchange_stat = zstring.split(_ED.arena_info.status_clump, ",")
                if tonumber(exchange_stat[zstring.tonumber(cell._index)]) == 1 then
                    TipDlg.drawTextDailog(red_alert_time_str[232])
                    return true
                end
                local consumption = zstring.split(dms.string(dms["arena_shop_info"],zstring.tonumber(cell._info),arena_shop_info.need_to_consume), ",")
                if tonumber(_ED.user_info.user_honour) < tonumber(consumption[3]) then
                    TipDlg.drawTextDailog(arena_tip_text[20])
                    return
                end
				local function responseCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node:onUpdateDraw()
						end
						checkRewardObtainDraw()
						state_machine.excute("arena_shop_tab_update_honour", 0, 0)
						TipDlg.drawTextDailog(red_alert_time_str[36])
					end
				end
				protocol_command.arena_shop_exchange.param_list = tonumber(cell._index)-1
				NetworkManager:register(protocol_command.arena_shop_exchange.code, nil, nil, nil, cell, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(arena_shop_cell_response_terminal)
		state_machine.add(arena_shop_cell_exchange_confirmation_terminal)
        state_machine.init()
    end
	init_arena_shop_cell_terminal()        	
end

function ArenaShopCell:onUpdateDraw()
	local root = self.roots[1]
	local item_info = dms.string(dms["arena_shop_info"],zstring.tonumber(self._info),arena_shop_info.item_info)
	local item_data = zstring.split(item_info, ",")
	local consumption = zstring.split(dms.string(dms["arena_shop_info"],zstring.tonumber(self._info),arena_shop_info.need_to_consume), ",")
	--图片id
	local Panel_shop_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_shop_props_icon")
	Panel_shop_props_icon:removeAllChildren(true)

    local cell = nil
    local use_of_ship = dms.int(dms["prop_mould"], tonumber(item_data[1]), prop_mould.use_of_ship)
    if use_of_ship > 0 then
        cell = state_machine.excute("props_icon_create_cell",0,{1,8,tonumber(item_data[1]),1})
    else
        cell = state_machine.excute("props_icon_create_cell",0,{4,1,tonumber(item_data[1]),1})
    end
	Panel_shop_props_icon:addChild(cell)
	--描述
	local Text_shop_props_infor = ccui.Helper:seekWidgetByName(root, "Text_shop_props_infor")
	Text_shop_props_infor:setString(dms.string(dms["prop_mould"],zstring.tonumber(item_data[1]),prop_mould.remarks))
	--消耗
	local Text_medal_have_n = ccui.Helper:seekWidgetByName(root, "Text_medal_have_n")
	local resourcesName =  dms.string(dms["prop_mould"],zstring.tonumber(resource_prop_id[tonumber(consumption[2])]),prop_mould.prop_name)
	Text_medal_have_n:setString(consumption[3]..resourcesName)
	--道具名称
	local Text_shop_props_name = ccui.Helper:seekWidgetByName(root, "Text_shop_props_name")
	Text_shop_props_name:setString(dms.string(dms["prop_mould"],zstring.tonumber(item_data[1]),prop_mould.prop_name).."*"..item_data[3])
	local exchange_stat = zstring.split(_ED.arena_info.status_clump, ",")
	if tonumber(exchange_stat[zstring.tonumber(self._index)]) == 1 then
        ccui.Helper:seekWidgetByName(root,"Button_shop_change"):setTitleText(red_alert_time_str[231])
		ccui.Helper:seekWidgetByName(root,"Button_shop_change"):setBright(false)
	else
        ccui.Helper:seekWidgetByName(root,"Button_shop_change"):setTitleText(red_alert_time_str[133])
		ccui.Helper:seekWidgetByName(root,"Button_shop_change"):setBright(true)
	end
	-- local data1 = string.gsub(arena_tip_text[19], "x", consumption[3])
	-- local data2 = string.gsub(data1, "y", resourcesName)
	-- local data3 = string.gsub(data2, "z", dms.string(dms["prop_mould"],zstring.tonumber(item_data[1]),prop_mould.prop_quality))
	-- local data4 = string.gsub(data3, "a", dms.string(dms["prop_mould"],zstring.tonumber(item_data[1]),prop_mould.prop_name))
	-- self._tip_info = data4
    local quality_str = dms.string(dms["prop_mould"],zstring.tonumber(item_data[1]),prop_mould.prop_quality)
    local name_str = dms.string(dms["prop_mould"],zstring.tonumber(item_data[1]),prop_mould.prop_name)
    self._tip_info = string.format(arena_tip_text[19],consumption[3],resourcesName,quality_str,name_str)
end


function ArenaShopCell:onEnterTransitionFinish()

end

function ArenaShopCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.arena.arena_shop_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if ArenaShopCell.__size == nil then
		ArenaShopCell.__size = root:getContentSize()
	end
	
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop_change"), nil, 
    {
        terminal_name = "arena_shop_cell_response", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self,
    }, nil, 1)
	
	self:onUpdateDraw()
end

function ArenaShopCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_shop_cell, root)
end

function ArenaShopCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaShopCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_shop_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaShopCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_shop_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_shop_props_icon")
    local Text_shop_props_infor = ccui.Helper:seekWidgetByName(root, "Text_shop_props_infor")
    local Text_medal_have_n = ccui.Helper:seekWidgetByName(root, "Text_medal_have_n")
    local Text_shop_props_name = ccui.Helper:seekWidgetByName(root, "Text_shop_props_name")
    local Button_shop_change = ccui.Helper:seekWidgetByName(root, "Button_shop_change")

    if Panel_shop_props_icon ~= nil then
        Panel_shop_props_icon:removeAllChildren(true)
        Text_shop_props_infor:setString("")
        Text_medal_have_n:setString("")
        Text_shop_props_name:setString("")
        Button_shop_change:setTouchEnabled(true)
        Button_shop_change:setBright(true)
    end
end

function ArenaShopCell:init(params)
	self._info = params[1]
	self._index = params[2]
	if self._index ~= nil and self._index <= 7 then
        self:onInit()
    end
	self:setContentSize(ArenaShopCell.__size)
    return self
end

