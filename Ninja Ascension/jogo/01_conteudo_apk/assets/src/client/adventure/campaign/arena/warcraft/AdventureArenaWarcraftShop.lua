-- ----------------------------------------------------------------------------------------------------
-- 说明：排位赛商店
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftShop = class("AdventureArenaWarcraftShopClass", Window)
    
function AdventureArenaWarcraftShop:ctor()
    self.super:ctor()
    self.roots = {}
	self.isTouchLock = false
	self.interval = 0
    self.needUpdateRefreshWarcraft = false
    -- 显示CD的时间
    self.strtime = nil
    self.isGetServer = false
    self.current_show_type = 0

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self.diffTimes = 0
    self.is_digimon = false --是否是数码宝贝

	app.load("client.adventure.cells.arena.AdventureArenaWarcraftShopListCell")
    app.load("client.utils.TimeUtil")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_shop_terminal()
        --商店
		local adventure_arena_warcraft_shop_manager_terminal = {
            _name = "adventure_arena_warcraft_shop_manager",
            init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(130, 130, 130))
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(255, 255, 255))
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                instance:onUpdateStates(tonumber(params._datas.current_button_type))
                return true
            end,

            _terminal = nil,
            _terminals = nil
        }

         --刷新
        local adventure_arena_warcraft_shop_buy_update_terminal = {
            _name = "adventure_arena_warcraft_shop_buy_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --返回
		local adventure_arena_warcraft_shop_close_terminal = {
            _name = "adventure_arena_warcraft_shop_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
				fwin:close(fwin:find("AdventureArenaWarcraftShopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(adventure_arena_warcraft_shop_manager_terminal)
		state_machine.add(adventure_arena_warcraft_shop_close_terminal)
        state_machine.add(adventure_arena_warcraft_shop_buy_update_terminal)
    
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_shop_terminal()
end

function AdventureArenaWarcraftShop:init(isGetServer)
    if isGetServer ~= nil and isGetServer == true then 
        self.isGetServer = true
    else
        self.isGetServer = false
    end
	return self
end

function AdventureArenaWarcraftShop:updateRefreshWarcraft()
    if self.needUpdateRefreshWarcraft == false then
        return
    end
    local root = self.roots[1]
    local interval = self.intervalWarcraft
    if interval <= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("00:00:00")
    else
        self.intervalWarcraft = math.max(0, self.intervalWarcraft)

        local timeTabel = formatTime(self.intervalWarcraft)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString(str)
    end
    
end

function AdventureArenaWarcraftShop:onUpdate(dt)

    if self.intervalWarcraft > 0  and  self.current_show_type == 1 then 
        local interval2 = 0 
        if _ED.active_activity[72] ~= nil then 
            interval2 =  zstring.tonumber(_ED.active_activity[72].activity_end_day) - _ED.system_time  - self.diffTimes + _ED.native_arena_two_time - os.time()
        else
            interval2 =  zstring.tonumber(_ED.warcraft_info.end_time/1000) - _ED.system_time  - self.diffTimes + _ED.native_arena_two_time - os.time()
        end

        if self.intervalWarcraft ~= interval2 then 
            self.intervalWarcraft = interval2
            self:updateRefreshWarcraft()
        end
    end
    ----
    -- if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
    --     local size = self.currentListView:getContentSize()
    --     local posY = self.currentInnerContainer:getPositionY()
    --     if self.currentInnerContainerPosY == posY then
    --         return
    --     end
    --     self.currentInnerContainerPosY = posY
    --     local items = self.currentListView:getItems()
    --     if items[1] == nil then
    --         return
    --     end
    --     local itemSize = items[1]:getContentSize()
    --     for i, v in pairs(items) do
    --         local tempY = v:getPositionY() + posY
    --         if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
    --             v:unload()
    --         else
    --             v:reload()
    --         end
    --     end
    -- end
end

function AdventureArenaWarcraftShop:onUpdateDraw()
	local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_num = ccui.Helper:seekWidgetByName(root, "Text_jf")
    local Text_info = ccui.Helper:seekWidgetByName(root, "Text_dqjf")
    if self.current_show_type == 1 then 
        if self.is_digimon == true then 
            Text_info:setString(warcraft_tip[13])
        else
            Text_info:setString(_string_piece_info[453])
        end
        
        Text_num:setString("".. _ED.warcraft_info.current_integral)
    else
        if self.is_digimon == true then 
            Text_info:setString(warcraft_tip[14])
        else
            Text_info:setString(_string_piece_info[454])
        end
        
        Text_num:setString("".. _ED.warcraft_info.current_win_count)
    end
end

function AdventureArenaWarcraftShop:onUpdateStates(show_type)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_num = ccui.Helper:seekWidgetByName(root, "Text_jf")
    local Text_info = ccui.Helper:seekWidgetByName(root, "Text_dqjf")
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_paihang")
    listView:removeAllItems()
    self.current_show_type = show_type
    if show_type == 1 then 
        --积分 配置表
        local datas = dms['warcraft_shop_info']
        if (type(datas) == 'string') then
            datas = datas.split("\r\n")
        end

        for i=1,#datas do
            local cell = AdventureArenaWarcraftShopListCell:createCell()
            cell:init(0,i)
            listView:addChild(cell)
        end
        local is_over = false
        if self.is_digimon == true then 
            Text_info:setString(warcraft_tip[13])
            is_over = zstring.tonumber(_ED.warcraft_info.is_action_over) >= 1
        else
            Text_info:setString(_string_piece_info[453])
            is_over = _ED.active_activity[72] == nil
        end


        Text_num:setString("".. _ED.warcraft_info.current_integral)
        

        if is_over == false then 
            --
            if self.is_digimon == true then 
                ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(warcraft_tip[15])
            else
                ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(_string_piece_info[455])
            end
            
        else
            if self.is_digimon == true then 
                ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(warcraft_tip[17])
            else
                ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(_string_piece_info[457])
            end
            
            ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("")
        end

    else
        local shop_datas = zstring.split(_ED.warcraft_info.win_shop_state_info, "\\r\\n")
        --胜点  读取活动
        for i,v in pairs(shop_datas) do
            local cell = AdventureArenaWarcraftShopListCell:createCell()
            cell:init(1,i)
            listView:addChild(cell)    
        end
        if self.is_digimon == true then 
            Text_info:setString(warcraft_tip[14])
        else
            Text_info:setString(_string_piece_info[454])
        end
        
        Text_num:setString("".. _ED.warcraft_info.current_win_count)
        local end_time = os.date("%Y".."/"
                                        .."%m".."/"
                                        .."%d"
                                        , zstring.exchangeFrom(zstring.tonumber(_ED.warcraft_info.end_time/1000))) 

        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString(end_time)
        if self.is_digimon == true then 
            ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(warcraft_tip[16])
        else
            ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(_string_piece_info[456])
        end
        
    end
    listView:requestRefreshView()
    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureArenaWarcraftShop:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_paiweisai_jfsd.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
    local is_over = false
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        self.is_digimon = true
        is_over = zstring.tonumber(_ED.warcraft_info.is_action_over) >= 1
    else
        self.is_digimon = false
        is_over = _ED.active_activity[72] == nil
    end
    if is_over == false then 
        --可以显示排位赛倒计时
        self.diffTimes = os.time() - _ED.native_time
        local remainTimes = zstring.tonumber(_ED.warcraft_info.end_time)/1000 - _ED.system_time  - self.diffTimes
        if remainTimes > 24 * 60 *60 then 
            --大于一天
            self.needUpdateRefreshWarcraft = false
            if self.is_digimon == true then 
                ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(warcraft_tip[15])
            else
                ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(_string_piece_info[455])    
            end
            
            ccui.Helper:seekWidgetByName(root, "Text_cd"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("" .. math.floor(remainTimes/(24 * 60 *60)) ..tipStringInfo_time_info[4] )
            self.intervalWarcraft = 0
        else
            self.needUpdateRefreshWarcraft = true
            self.intervalWarcraft = (zstring.tonumber(_ED.native_arena_two_time) + remainTimes) - os.time()
        end
        if self.is_digimon == true then 
            ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(warcraft_tip[15])
        else
            ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(_string_piece_info[455])    
        end
        
    else
        --已经结束
        self.needUpdateRefreshWarcraft = false
        self.intervalWarcraft = 0
        
        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("")
        if self.is_digimon == true then 
            ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(warcraft_tip[17])
        else
            ccui.Helper:seekWidgetByName(root, "Text_shengyucd"):setString(_string_piece_info[457])
        end
        
    end
	self:onUpdateDraw()
	-- -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_shop_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    --积分商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jifen"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_shop_manager",     
        current_button_name = "Button_jifen",  
        current_button_type = 1 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    local shengdianButton = ccui.Helper:seekWidgetByName(root, "Button_shengdian")
    shengdianButton:setColor(cc.c3b(130, 130, 130))
    shengdianButton:setHighlighted(false)
    shengdianButton:setTouchEnabled(true)
    --胜点商店
    fwin:addTouchEventListener(shengdianButton,       nil, 
    {
        terminal_name = "adventure_arena_warcraft_shop_manager",     
        current_button_name = "Button_shengdian",  
        current_button_type = 2 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    state_machine.excute("adventure_arena_warcraft_shop_manager", 0, 
        {_datas ={
            current_button_name = "Button_jifen",        
            current_button_type = 1 ,      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
    )
end

function AdventureArenaWarcraftShop:onExit()
     self.roots = nil
    state_machine.remove("adventure_arena_warcraft_shop_manager")
    state_machine.remove("adventure_arena_warcraft_shop_close")
    
end