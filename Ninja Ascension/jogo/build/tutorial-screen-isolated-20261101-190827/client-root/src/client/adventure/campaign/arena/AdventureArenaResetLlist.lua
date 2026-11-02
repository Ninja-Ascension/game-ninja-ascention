-- ----------------------------------------------------------------------------------------------------
-- 说明：重置竞技场列表
-------------------------------------------------------------------------------------------------------
AdventureArenaResetLlist = class("AdventureArenaResetLlistClass", Window)
    
function AdventureArenaResetLlist:ctor()
    self.super:ctor()
    self.roots = {}
    self.type = nil
    self.type_text = nil
    self.interval = 0
    self.Text_cd = nil
    self.strtime = nil
	app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_reset_llist_terminal()
		local adventure_arena_reset_llist_request_terminal = {
            _name = "adventure_arena_reset_llist_request",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell.type == 1 then
                    -- 1 竞技场刷新传过来的消耗血钻提示框
                    local function requestArenaRefushCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("adventure_arena_straight_request_update_interface", 0, nil)
                            
                        end
                        fwin:close(fwin:find("AdventureArenaResetLlistClass"))
                    end
                    protocol_command.arena2_refush.param_list = "1"
                    NetworkManager:register(protocol_command.arena2_refush.code, nil, nil, nil, nil, requestArenaRefushCallback, false, nil)
                
                elseif cell.type == 2   then
                    -- 2 黑市刷新传过来的消耗血钻提示框
                    local function requestArenaRefushCallback(response)
                     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("adventure_black_market_refresh_cooltime_cd", 0, 0) 
                        
                     end
                     fwin:close(fwin:find("AdventureArenaResetLlistClass"))
                    end
                 NetworkManager:register(protocol_command.black_shop_refush.code, nil, nil, nil, nil, requestArenaRefushCallback, false, nil)
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_arena_reset_llist_request_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_reset_llist_terminal()
end

function AdventureArenaResetLlist:init(type,strtime)
    self.type = type
    self.strtime = strtime
    if self.type == 1 then
        -- 获取竞技场刷新时间
        self.interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_info[2].arena_challenge_lasttime)) - os.time()
    elseif self.type == 2 then
        self.interval = (_ED.native_time + zstring.tonumber(_ED.refreshTime)) - os.time()
    end
	return self
end

function AdventureArenaResetLlist:onUpdate(dt)
    if self.type == 1 then
        -- 显示竞技场刷新CD
         if self.interval > 0 then
            local interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_info[2].arena_challenge_lasttime)) - os.time()
            if self.interval ~= interval then
                self.interval = interval
                self:updateRefreshCd()
            end
        else
            local root = self.roots[1]
            ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("00:00:00")
         end
    elseif self.type == 2 then
        -- 显示黑市刷新CD
        if self.interval > 0 then
             local interval = (_ED.native_time + zstring.tonumber(_ED.refreshTime)/1000) - os.time()
            if self.interval ~= interval then
                self.interval = interval
                self:updateRefreshCd()
            end
         end
    end
end

function AdventureArenaResetLlist:updateRefreshCd()
    local interval = self.interval

    if interval <= 0 then
        local root = self.roots[1]
        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("00:00:00")
    else
        self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)
        self.Text_cd:setString(str)
    end  
end

function AdventureArenaResetLlist:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_shuaxin.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    -- 获取显示CD的标签
    self.Text_cd = ccui.Helper:seekWidgetByName(root, "Text_cd")
    if self.strtime == nil then 
        self.Text_cd:setString("00:00:00")
    else
        self.Text_cd:setString(""..self.strtime)
    end
    
    self:addChild(csbAdventureArena)
	local ListView_prop = ccui.Helper:seekWidgetByName(root, "ListView_prop")
	ListView_prop:removeAllItems()
	local cell = adventureNewSmallPropIconCell:createCell()
	 -- 获取显示消耗血钻提示标签
    self.type_text = ccui.Helper:seekWidgetByName(root, "Text_10_0")
    if  self.type == 1 then
        cell:init(0, {resource_type = 2} , dms.string(dms["pirates_config"], 315, pirates_config.param), nil, 0, 0)
    elseif self.type == 2 then
        self.type_text:setString(_string_piece_info[389])
        local number = dms.string(dms["pirates_config"], 316, pirates_config.param)
        number = zstring.split(number, ",")[2]
        cell:init(0, {resource_type = 2} , number, nil, 0, 0)
    end
	ListView_prop:addChild(cell)
	ListView_prop:requestRefreshView()
   
	--刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"), nil, 
    {
        terminal_name = "adventure_arena_reset_llist_request", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaResetLlistClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaResetLlistClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
end

function AdventureArenaResetLlist:onExit()

end