----------------------------------------------------------------------------------------------------
-- 说明：全民福利
-------------------------------------------------------------------------------------------------------

ActivityPeopleWeal = class("ActivityPeopleWealClass", Window)
    
function ActivityPeopleWeal:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.cells.activity.activity_limit_people_weal_list_cell")

    -- Initialize all server welfare activity page state machine.
    local function init_activity_people_weal_terminal()
        local activity_people_weal_update_draw_terminal = {
            _name = "activity_people_weal_update_draw",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if fwin:find("ActivityPeopleWealClass") ~= nil then
					instance:onRefreshDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(activity_people_weal_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init all server welfare activity state machine.
    init_activity_people_weal_terminal()
end

function ActivityPeopleWeal:onUpdateDraw()
    local root = self.roots[1]
    
    local datas = dms['limited_welfare']
    if (type(datas) == 'string') then
        datas = datas.split("\r\n")
    end
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_kf_5")
    for i,v in ipairs (datas) do
        local cell = ActivityLimitPeopleWealListCell:createCell()
        cell:init(v)
        listView:addChild(cell)
    end
    self:onRefreshDraw()
end

function ActivityPeopleWeal:onRefreshDraw()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_kf_5")
    local items = listView:getItems()
    if items == nil then 
        return
    end
    for k,v in pairs(items) do
        v:onRefreshDraw()
    end
    local stopNumbers = {}
    local get_count = string.format("%05d",_ED.limit_recharege_info.buy_player_counts)
    for i=1,5 do
         local numberText = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_fl_" .. i)
        local pushString = get_count
        local tetttt = string.sub(pushString,i,i)
        numberText:setString(tetttt)
    end
end

function ActivityPeopleWeal:onEnterTransitionFinish()
    local csbActivityPeopleWeal = csb.createNode("activity/wonderful/limited_time_discount_3.csb")
    self:addChild(csbActivityPeopleWeal)

    local root = csbActivityPeopleWeal:getChildByName("root")
    table.insert(self.roots, root)
    self:onUpdateDraw()
end


function ActivityPeopleWeal:onExit()
    state_machine.remove("activity_people_weal_goto_buy_page")
end

function ActivityPeopleWeal:init()
end

function ActivityPeopleWeal:createCell()
    local cell = ActivityPeopleWeal:new()
    cell:registerOnNodeEvent(cell)
    return cell
end