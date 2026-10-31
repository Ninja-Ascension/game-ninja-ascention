-- ----------------------------------------------------------------------------------------------------
-- 说明：段位奖励 这个界面不要了
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftLevelReward = class("AdventureArenaWarcraftLevelRewardClass", Window)
    
function AdventureArenaWarcraftLevelReward:ctor()
    self.super:ctor()
    self.roots = {}
	self.isTouchLock = false
	self.interval = 0
    self.needUpdateRefreshCd = false
    -- 显示CD的时间
    self.strtime = nil
    self.isGetServer = false
	app.load("client.adventure.cells.prop.adventure_new_prop_activity_icon_cell")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_level_reard_terminal()
    
        --返回
		local adventure_arena_warcraft_level_reward_close_terminal = {
            _name = "adventure_arena_warcraft_level_reward_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("AdventureArenaWarcraftLevelRewardClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --得到奖励
        local adventure_arena_warcraft_level_get_reward_terminal = {
            _name = "adventure_arena_warcraft_level_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更多
        local adventure_arena_warcraft_level_reward_more_terminal = {
            _name = "adventure_arena_warcraft_level_reward_more",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftMoreReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureArenaWarcraftMoreReward:new(),fwin._ui)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(adventure_arena_warcraft_level_get_reward_terminal)	
        state_machine.add(adventure_arena_warcraft_level_reward_more_terminal)   
        state_machine.add(adventure_arena_warcraft_level_reward_close_terminal)   
        state_machine.add(adventure_arena_warcraft_level_reward_more_terminal)   
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_level_reard_terminal()
end

function AdventureArenaWarcraftLevelReward:init(isGetServer)
    if isGetServer ~= nil and isGetServer == true then 
        self.isGetServer = true
    else
        self.isGetServer = false
    end
	return self
end

function AdventureArenaWarcraftLevelReward:onUpdate(dt)

end

function AdventureArenaWarcraftLevelReward:onUpdateDraw()
	local root = self.roots[1]
    if root == nil then 
        return
    end
    ccui.Helper:seekWidgetByName(root, "Text_67"):setString(dms.string(dms["warcraft_mould"], _ED.warcraft_info.current_title_id, warcraft_mould.title_name))-- 当前段位
    local rewardlist = dms.string(dms["warcraft_mould"], _ED.warcraft_info.current_title_id, warcraft_mould.rank_reward)
    local list_arr = zstring.split("".. rewardlist,"|")
    for i=1,3 do
        local daojuPanel = ccui.Helper:seekWidgetByName(root, "Panel_daoju_" .. i)
        daojuPanel:removeAllChildren(true)
        if i <= #list_arr then 
            local itemList = zstring.split("".. list_arr[i],",")
            if zstring.tonumber(itemList[1]) == 1 then 
                --金币
                local cell = adventureNewSmallPropIconCell:createCell()
                cell:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0)
                daojuPanel:addChild(cell)
            end
            if zstring.tonumber(itemList[1]) == 6 then 
                --道具
                local cell = adventureNewSmallPropIconCell:createCell()
                cell:init(0, {mould_id = itemList[2]} ,"" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0 )
                daojuPanel:addChild(cell)
            end
            if zstring.tonumber(itemList[1]) == 4 then 
                --荣誉碎片
                local cell = adventureNewSmallPropIconCell:createCell()
                cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0)
                daojuPanel:addChild(cell)
            end
        end
    end
end

function AdventureArenaWarcraftLevelReward:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_pws_jiangli.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)

	-- -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_level_reward_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 更多
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_level_reward_more", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_level_get_reward", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    self:onUpdateDraw()
    
end

function AdventureArenaWarcraftLevelReward:onExit()
    self.roots = nil
    state_machine.remove("adventure_arena_warcraft_level_reward_close")
end