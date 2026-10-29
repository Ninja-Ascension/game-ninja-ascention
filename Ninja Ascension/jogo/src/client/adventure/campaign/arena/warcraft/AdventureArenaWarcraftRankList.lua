-- ----------------------------------------------------------------------------------------------------
-- 说明：排位赛排行列表
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftRankList = class("AdventureArenaWarcraftRankListClass", Window)
    
function AdventureArenaWarcraftRankList:ctor()
    self.super:ctor()
    self.roots = {}
	self.isTouchLock = false
	self.interval = 0
    self.needUpdateRefreshCd = false
    -- 显示CD的时间
    self.strtime = nil
    self.isGetServer = false
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    app.load("client.adventure.cells.arena.AdventureArenaWarcraftRankListCell")
	
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_refresh_rival_terminal()

        --返回
		local adventure_arena_warcraft_rank_list_close_terminal = {
            _name = "adventure_arena_warcraft_rank_list_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("AdventureArenaWarcraftRankListClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换按钮
        local adventure_arena_warcraft_rank_list_manager_terminal = {
            _name = "adventure_arena_warcraft_rank_list_manager",
            _init = function (terminal)
                
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
    
	
		state_machine.add(adventure_arena_warcraft_rank_list_close_terminal)
        state_machine.add(adventure_arena_warcraft_rank_list_manager_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_refresh_rival_terminal()
end

function AdventureArenaWarcraftRankList:init(isGetServer)
    if isGetServer ~= nil and isGetServer == true then 
        self.isGetServer = true
    else
        self.isGetServer = false
    end
	return self
end

function AdventureArenaWarcraftRankList:onUpdateStates(show_type)
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local rankText = ccui.Helper:seekWidgetByName(root, "Text_2")
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        if zstring.tonumber(_ED.warcraft_info.current_rank) == 0 then 
            rankText:setString(warcraft_tip[1])
        else
            rankText:setString(_string_piece_info[2] .. _ED.warcraft_info.current_rank .. _string_piece_info[317])
        end
    else
        if zstring.tonumber(_ED.warcraft_info.current_rank) == 0 then 
            rankText:setString(_string_piece_info[440])
        else
            rankText:setString(_string_piece_info[2] .. _ED.warcraft_info.current_rank .. _string_piece_info[317])
        end
    end
    

    local listView = ccui.Helper:seekWidgetByName(root, "ListView_paihang")
    listView:removeAllItems()
    listView:jumpToTop()
    if show_type == 1 then 
        
        for k,v in pairs(_ED.warcraft_info.ranking_list) do
            local cell = AdventureArenaWarcraftRankListCell:createCell()
            cell:init(v,k)
            listView:addChild(cell)
            
        end
        if #_ED.warcraft_info.ranking_list == 0 then
            ccui.Helper:seekWidgetByName(root, "Text_tips"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Text_tips"):setVisible(false)
        end
    else
       for k,v in pairs(_ED.warcraft_info.ranking_next_list) do
            local cell = AdventureArenaWarcraftRankListCell:createCell()
            cell:init(v,k)
            listView:addChild(cell) 
        end
        if #_ED.warcraft_info.ranking_next_list == 0 then
            ccui.Helper:seekWidgetByName(root, "Text_tips"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Text_tips"):setVisible(false)
        end
    end
    listView:requestRefreshView()
    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureArenaWarcraftRankList:onUpdateDraw()
	
end

function AdventureArenaWarcraftRankList:onUpdate(dt)
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        -- local size = self.currentListView:getContentSize()
        -- local posY = self.currentInnerContainer:getPositionY()
        -- if self.currentInnerContainerPosY == posY then
        --     return
        -- end
        -- self.currentInnerContainerPosY = posY
        -- local items = self.currentListView:getItems()
        -- if items[1] == nil then
        --     return
        -- end
        -- local itemSize = items[1]:getContentSize()
        -- for i, v in pairs(items) do
        --     local tempY = v:getPositionY() + posY
        --     if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
        --         v:unload()
        --     else
        --         v:reload()
        --     end
        -- end
    end
end

function AdventureArenaWarcraftRankList:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_paiweisai.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
    	
	-- -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_rank_list_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --本周排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_now"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_rank_list_manager",     
        current_button_name = "Button_now",  
        current_button_type = 1 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    --上周排行
    local nextButton = ccui.Helper:seekWidgetByName(root, "Button_next")
    nextButton:setColor(cc.c3b(130, 130, 130))
    nextButton:setHighlighted(false)
    nextButton:setTouchEnabled(true)
    --
    fwin:addTouchEventListener(nextButton,       nil, 
    {
        terminal_name = "adventure_arena_warcraft_rank_list_manager",     
        current_button_name = "Button_next",  
        current_button_type = 2 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    state_machine.excute("adventure_arena_warcraft_rank_list_manager", 0, 
        {_datas ={
            current_button_name = "Button_now",        
            current_button_type = 1 ,      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
    )
end

function AdventureArenaWarcraftRankList:onExit()
    self.roots = nil
    state_machine.remove("adventure_arena_warcraft_rank_list_close")
    
end