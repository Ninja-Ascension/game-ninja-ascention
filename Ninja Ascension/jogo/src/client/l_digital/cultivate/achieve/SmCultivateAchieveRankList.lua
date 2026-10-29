-----------------------------
--战斗力排行
-----------------------------
SmCultivateAchieveRankList = class("SmCultivateAchieveRankListClass", Window)
SmCultivateAchieveRankList.__size = nil

local sm_cultivate_achieve_rank_open_list_terminal = {
    _name = "sm_cultivate_achieve_rank_open_list",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmCultivateAchieveRankList:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_achieve_rank_open_list_terminal)
state_machine.init()

function SmCultivateAchieveRankList:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}

    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    app.load("client.l_digital.cells.activity.wonderful.sm_activity_all_ranking_information_cell")
    local function init_sm_rank_combat_power_terminal()
		--显示界面
		local sm_cultivate_achieve_rank_open_list_show_terminal = {
            _name = "sm_cultivate_achieve_rank_open_list_show",
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
		local sm_cultivate_achieve_rank_open_list_hide_terminal = {
            _name = "sm_cultivate_achieve_rank_open_list_hide",
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

        local sm_cultivate_achieve_rank_refresh_list_terminal = {
            _name = "sm_cultivate_achieve_rank_refresh_list",
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
                    protocol_command.order_get_info.param_list = 8 .."\r\n"..(instance.starting_point+10).."\r\n"..(instance.end_point+10)
                    NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(sm_cultivate_achieve_rank_open_list_show_terminal)	
        state_machine.add(sm_cultivate_achieve_rank_open_list_hide_terminal)
		state_machine.add(sm_cultivate_achieve_rank_refresh_list_terminal)

        state_machine.init()
    end
    init_sm_rank_combat_power_terminal()
end

function SmCultivateAchieveRankList:onHide()
    self:setVisible(false)
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    ListView_phb:removeAllItems()
    self:stopAllActions()
end

function SmCultivateAchieveRankList:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function SmCultivateAchieveRankList:addnewlistCell()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    for i= self.starting_point,self.end_point do
        if _ED.user_achieve_score_rank.other_user[i] ~= nil then
            local cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{_ED.user_achieve_score_rank.other_user[i],8})
            ListView_phb:addChild(cell)
        else
            self.isOver = true
        end
    end
    ListView_phb:requestRefreshView()
end

function SmCultivateAchieveRankList:onUpdateDraw()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    ListView_phb:removeAllItems()
    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    for i, v in ipairs(_ED.user_achieve_score_rank.other_user) do 
        local cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{v,8})
        ListView_phb:addChild(cell)
    end
    ListView_phb:requestRefreshView()

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
            state_machine.excute("sm_cultivate_achieve_rank_refresh_list", 0, nil)
        end
    end
    ListView_phb:addScrollViewEventListener(scrollViewEvent)
end

function SmCultivateAchieveRankList:onUpdate(dt)
    
end

function SmCultivateAchieveRankList:onEnterTransitionFinish()

end

function SmCultivateAchieveRankList:onInit( )
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
    if SmCultivateAchieveRankList.__size == nil then
        SmCultivateAchieveRankList.__size = root:getContentSize()
    end
    self:setContentSize(SmCultivateAchieveRankList.__size)

    self:onUpdateDraw()
end

function SmCultivateAchieveRankList:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmCultivateAchieveRankList:onExit()
    state_machine.remove("sm_cultivate_achieve_rank_open_list_show")    
    state_machine.remove("sm_cultivate_achieve_rank_open_list_hide")
end
