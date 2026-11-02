-----------------------------
--战斗力排行
-----------------------------
SmCultivateConstellationRankList = class("SmCultivateConstellationRankListClass", Window)
SmCultivateConstellationRankList.__size = nil

local sm_cultivate_constellation_rank_open_list_terminal = {
    _name = "sm_cultivate_constellation_rank_open_list",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmCultivateConstellationRankList:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_constellation_rank_open_list_terminal)
state_machine.init()

function SmCultivateConstellationRankList:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}

    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    app.load("client.l_digital.cells.activity.wonderful.sm_activity_all_ranking_information_cell")
    local function init_sm_rank_constellation_rank_list_terminal()
		--显示界面
		local sm_cultivate_constellation_rank_open_list_show_terminal = {
            _name = "sm_cultivate_constellation_rank_open_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_cultivate_constellation_rank_open_list_hide_terminal = {
            _name = "sm_cultivate_constellation_rank_open_list_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local sm_cultivate_constellation_rank_refresh_list_terminal = {
            _name = "sm_cultivate_constellation_rank_refresh_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.isOver == false then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            instance.starting_point = instance.starting_point+10
                            instance.end_point = instance.end_point+10
                            instance:addnewlistCell()
                        end
                    end
                    local energyData = zstring.split(dms.string(dms["user_config"], 8, user_config.param), ",")
                    if tonumber(energyData[1]) <= instance.end_point then
                        instance.isOver = true
                        return
                    end
                    protocol_command.order_get_info.param_list = 9 .."\r\n"..(instance.starting_point+10).."\r\n"..(instance.end_point+10)
                    NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(sm_cultivate_constellation_rank_open_list_show_terminal)	
        state_machine.add(sm_cultivate_constellation_rank_open_list_hide_terminal)
		state_machine.add(sm_cultivate_constellation_rank_refresh_list_terminal)

        state_machine.init()
    end
    init_sm_rank_constellation_rank_list_terminal()
end

function SmCultivateConstellationRankList:onHide()
    self:setVisible(false)
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    ListView_phb:removeAllItems()
    self:stopAllActions()
end

function SmCultivateConstellationRankList:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function SmCultivateConstellationRankList:addnewlistCell()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    for i= self.starting_point,self.end_point do
        if _ED.user_constellation_price_rank.other_user[i] ~= nil then
            local cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{_ED.user_constellation_price_rank.other_user[i],9})
            ListView_phb:addChild(cell)
        else
            self.isOver = true
        end
    end
    ListView_phb:requestRefreshView()
end

function SmCultivateConstellationRankList:onUpdateDraw()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    ListView_phb:removeAllItems()
    self.starting_point = 1
    self.end_point = 10
    self.isOver = false

     if #_ED.user_constellation_price_rank.other_user == 0 then
        for i = 1, 3 do 
            local cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{{user_rank = i,},9})
            ListView_phb:addChild(cell)
        end
    else
        for i, v in ipairs(_ED.user_constellation_price_rank.other_user) do
            local cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{v,9})
            ListView_phb:addChild(cell)
        end
    end

    
    ListView_phb:requestRefreshView()

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
            state_machine.excute("sm_cultivate_constellation_rank_refresh_list", 0, nil)
        end
    end
    ListView_phb:addScrollViewEventListener(scrollViewEvent)
end

function SmCultivateConstellationRankList:onUpdate(dt)
    
end

function SmCultivateConstellationRankList:onEnterTransitionFinish()

end

function SmCultivateConstellationRankList:onInit( )
    local csbItem = csb.createNode("system/sm_ranking_listview.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        root:setContentSize(self._rootWindows:getContentSize())
        local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
        ListView_phb:setContentSize(self._rootWindows:getContentSize())
    end
    if SmCultivateConstellationRankList.__size == nil then
        SmCultivateConstellationRankList.__size = root:getContentSize()
    end
    self:setContentSize(SmCultivateConstellationRankList.__size)

    self:onUpdateDraw()
end

function SmCultivateConstellationRankList:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmCultivateConstellationRankList:onExit()
    state_machine.remove("sm_cultivate_constellation_rank_open_list_show")    
    state_machine.remove("sm_cultivate_constellation_rank_open_list_hide")
    state_machine.remove("sm_cultivate_constellation_rank_refresh_list")
end
