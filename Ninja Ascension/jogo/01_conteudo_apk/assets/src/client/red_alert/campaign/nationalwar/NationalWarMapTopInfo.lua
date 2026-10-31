-----------------------------
--国战地图顶部信息
-----------------------------
NationalWarMapTopInfo = class("NationalWarMapTopInfoClass", Window)

local national_warmap_top_info_window_open_terminal = {
    _name = "national_warmap_top_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarMapTopInfoClass") == nil then
            fwin:open(NationalWarMapTopInfo:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_warmap_top_info_window_close_terminal = {
    _name = "national_warmap_top_info_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarMapTopInfoClass"))      
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_warmap_top_info_window_open_terminal)
state_machine.add(national_warmap_top_info_window_close_terminal)
state_machine.init()

function NationalWarMapTopInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.gem_text = nil
    self.forage_text = nil
    self.honor_text = nil
end


function NationalWarMapTopInfo:onUpdateDraw()
    local root = self.roots[1]
    local Text_gem_number = ccui.Helper:seekWidgetByName(root,"Text_gem_number")
    Text_gem_number:setString(_ED.user_info.user_gold)
    local Text_forage_number = ccui.Helper:seekWidgetByName(root,"Text_forage_number")
    Text_forage_number:setString(_ED.selfWarProvisions)
    local Text_honor_number = ccui.Helper:seekWidgetByName(root,"Text_honor_number")
    Text_honor_number:setString(_ED.selfHonnor)
    self.gem_text = Text_gem_number
    self.forage_text = Text_forage_number
    self.honor_text = Text_honor_number    
end

function NationalWarMapTopInfo:onUpdate(dt)
    if self.gem_text ~= nil then
        self.gem_text:setString(_ED.user_info.user_gold)
        self.forage_text:setString(_ED.selfWarProvisions)
        self.honor_text:setString(_ED.selfHonnor)
    end
end

function NationalWarMapTopInfo:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_map_top_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --充值
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
    else
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gem_add"), nil, 
        {
            terminal_name = "recharge_dialog_window_open", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
    end

    -- 购买军粮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_forage_add"), nil, 
    {
        terminal_name = "natinal_war_buy_resource_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    
    self:onUpdateDraw() 
end

function NationalWarMapTopInfo:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self:onInit()
    return self
end

function NationalWarMapTopInfo:onExit()

end
