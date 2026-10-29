-- ----------------------------------------------------------------------------------------------------
-- 说明：对方公会基础信息
-------------------------------------------------------------------------------------------------------
SmUnionInfoWindow = class("SmUnionInfoWindowClass", Window)

local sm_union_info_window_window_open_terminal = {
    _name = "sm_union_info_window_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionInfoWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionInfoWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_info_window_window_close_terminal = {
    _name = "sm_union_info_window_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionInfoWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionInfoWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_info_window_window_open_terminal)
state_machine.add(sm_union_info_window_window_close_terminal)
state_machine.init()
    
function SmUnionInfoWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0

    app.load("client.l_digital.cells.union.union_logo_icon_cell")

    local function init_sm_union_info_window_window_terminal()
        -- 显示界面
        local sm_union_info_window_window_display_terminal = {
            _name = "sm_union_info_window_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionInfoWindowWindow = fwin:find("SmUnionInfoWindowClass")
                if SmUnionInfoWindowWindow ~= nil then
                    SmUnionInfoWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_info_window_window_hide_terminal = {
            _name = "sm_union_info_window_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionInfoWindowWindow = fwin:find("SmUnionInfoWindowClass")
                if SmUnionInfoWindowWindow ~= nil then
                    SmUnionInfoWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_info_window_window_display_terminal)
        state_machine.add(sm_union_info_window_window_hide_terminal)
        state_machine.init()
    end
    init_sm_union_info_window_window_terminal()
end

function SmUnionInfoWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    --公会图标
    local Panel_legion_logo = ccui.Helper:seekWidgetByName(root, "Panel_legion_logo")
    local quality = tonumber(self.example.union_icon)
    local kuang = tonumber(self.example.union_kuang)
    local cell = CnionLogoIconCell:createCell()
    cell:init(kuang,quality,nil)
    -- icon:removeAllChildren(true)
    Panel_legion_logo:addChild(cell)

    --公会名称
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    Text_legion_name:setString(self.example.union_name)
    --会长名称
    local Text_chief_name = ccui.Helper:seekWidgetByName(root, "Text_chief_name")
    Text_chief_name:setString(self.example.union_president_name)
    --工会id
    local Text_id_n = ccui.Helper:seekWidgetByName(root, "Text_id_n")
    Text_id_n:setString(self.example.union_id)
    --工会排名
    local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")
    Text_rank_n:setString(self.example.union_rank)
    --工会人数
    local Text_pepole_n = ccui.Helper:seekWidgetByName(root, "Text_pepole_n")
    local maxMember = dms.string(dms["union_lobby_param"], self.example.union_level, union_lobby_param.maxMember)
     --增加研究院能增加的人数
    -- local science_info = zstring.split(_ED.union_science_info,"|")
    -- local hall_technology = zstring.split(science_info[9],",")
    -- local cur_lv = hall_technology[1]
    -- local union_science_info = dms.searchs(dms["union_science_exp"], union_science_exp.group_id,9)
    -- local add_num = 0
    -- for i,v in ipairs(union_science_info) do
    --     if zstring.tonumber(v[union_science_exp.level]) == zstring.tonumber(cur_lv) then
    --         add_num = zstring.tonumber(v[union_science_exp.level_parameter])
    --     end
    -- end
    Text_pepole_n:setString(self.example.union_member.."/"..(zstring.tonumber(maxMember)+zstring.tonumber(self.example.union_science_num)))
    --工会宣言
    local Text_notice = ccui.Helper:seekWidgetByName(root, "Text_notice")
    Text_notice:setString(self.example.union_watchword)

end

function SmUnionInfoWindow:init(params)
    self.example = params
    self:onInit()
    return self
end

function SmUnionInfoWindow:onInit()
    local csbSmUnionInfoWindow = csb.createNode("legion/sm_legion_info_window.csb")
    local root = csbSmUnionInfoWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionInfoWindow)
    local action = csb.createTimeline("legion/sm_legion_info_window.csb")
    table.insert(self.actions, action)
    csbSmUnionInfoWindow:runAction(action)
	action:play("window_open", false)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_union_info_window_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmUnionInfoWindow:onExit()
    state_machine.remove("sm_union_info_window_window_display")
    state_machine.remove("sm_union_info_window_window_hide")
end