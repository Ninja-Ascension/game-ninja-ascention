-----------------------------
--宝石副本出战
-----------------------------
GemDuplicateTow = class("GemDuplicateTowClass", Window)

local gem_duplicate_tow_window_open_terminal = {
    _name = "gem_duplicate_tow_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)

        if nil == fwin:find("GemDuplicateTowClass") then
            local npc_state = params[1]
            local gem_duplicate = params[2]
            fwin:open(GemDuplicateTow:new():init(npc_state,gem_duplicate), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local gem_duplicate_tow_window_close_terminal = {
    _name = "gem_duplicate_tow_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GemDuplicateTowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(gem_duplicate_tow_window_open_terminal)
state_machine.add(gem_duplicate_tow_window_close_terminal)
state_machine.init()

function GemDuplicateTow:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file
    app.load("client.red_alert.cells.campaign.gemduplicate.gem_duplicate_tow_cell")
    -- var
    -- npc信息 -table
    self.npc_state = nil
    -- 副本信息 -table
    self.gem_duplicate  = nil 

    -- Initialize gem_duplicate_tow state machine.
    local function init_gem_duplicate_tow_terminal()
	
    end
    
    -- call func init gem_duplicate_tow state machine.
    init_gem_duplicate_tow_terminal()
end


function GemDuplicateTow:onUpdateDraw()
    local root = self.roots[1]
    local Text_drop_thing = ccui.Helper:seekWidgetByName(root,"Text_drop_thing") -- 目标
    Text_drop_thing:setString(gems_duplicate_name[self.gem_duplicate.id]..self.gem_duplicate.name)

    --绘制掉落
    for i,v in pairs(self.gem_duplicate.reward_data) do
        local Panel_drop_reward = ccui.Helper:seekWidgetByName(root,"Panel_drop_reward_"..i)
        Panel_drop_reward:removeAllChildren(true)
        local cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,false,false})
        Panel_drop_reward:addChild(cell)
    end

    --绘制难度选择
    local ListView_duplicate = ccui.Helper:seekWidgetByName(root,"ListView_duplicate")
    ListView_duplicate:removeAllItems()
    local index = 0 
    for i=1,6 do
        local cell = state_machine.excute("gem_duplicate_tow_create_cell",0,{self.npc_state[i],i,self.gem_duplicate.scene_id})
        if tonumber(self.npc_state[i].state) >= 0 then 
            index = index + 1
        end
        ListView_duplicate:addChild(cell)
    end
    ListView_duplicate:requestRefreshView()
    ListView_duplicate:getInnerContainer():setPosition(cc.p(-(index-2) * GemDuplicateTowCell.__size.width,0))
end

function GemDuplicateTow:onEnterTransitionFinish()

end

function GemDuplicateTow:onInit( )
   local csbItem = csb.createNode(config_csb.campaign.gemduplicate.gem_duplicate_tow)
   self:addChild(csbItem)
	 local root = csbItem:getChildByName("root")
	 table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_gem_duplicate_tow"), nil, 
    {
        terminal_name = "gem_duplicate_tow_window_close", 
        terminal_state = 0, 
    }, nil, 0)
    
	 self:onUpdateDraw()
end

function GemDuplicateTow:initData()
   

end

function GemDuplicateTow:init(npc_state,gem_duplicate)
    self.npc_state = npc_state
    self.gem_duplicate  = gem_duplicate 
	self:onInit()
    return self
end

function GemDuplicateTow:onExit()

end
