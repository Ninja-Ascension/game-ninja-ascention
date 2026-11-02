-----------------------------
--贡献排行
-----------------------------
CrossServerBattelServerRankList = class("CrossServerBattelServerRankListClass", Window)
CrossServerBattelServerRankList.__size = nil

local cross_server_battel_server_rank_open_list_terminal = {
    _name = "cross_server_battel_server_rank_open_list",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = CrossServerBattelServerRankList:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_server_battel_server_rank_open_list_terminal)
state_machine.init()

function CrossServerBattelServerRankList:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}

    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_rank_cell")
    local function init_cross_server_battel_server_rank_list_terminal()
		--显示界面
		local cross_server_battel_server_rank_open_list_show_terminal = {
            _name = "cross_server_battel_server_rank_open_list_show",
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
		local cross_server_battel_server_rank_open_list_hide_terminal = {
            _name = "cross_server_battel_server_rank_open_list_hide",
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

        local cross_server_battel_server_rank_refresh_list_terminal = {
            _name = "cross_server_battel_server_rank_refresh_list",
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
                    protocol_command.cross_mine_order_info.param_list = (instance.starting_point+10).."\r\n"..(instance.end_point+10).. "\r\n"..2
                    NetworkManager:register(protocol_command.cross_mine_order_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(cross_server_battel_server_rank_open_list_show_terminal)	
        state_machine.add(cross_server_battel_server_rank_open_list_hide_terminal)
		state_machine.add(cross_server_battel_server_rank_refresh_list_terminal)

        state_machine.init()
    end
    init_cross_server_battel_server_rank_list_terminal()
end

function CrossServerBattelServerRankList:onHide()
    self:setVisible(false)
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_cross_service_rank")
    ListView_phb:removeAllItems()
    self:stopAllActions()
end

function CrossServerBattelServerRankList:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function CrossServerBattelServerRankList:addnewlistCell()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_cross_service_rank")
    for i= self.starting_point,self.end_point do
        if _ED.cross_server_battel_server_rank_info.other[(i - 1)..""] ~= nil then
            local cell = state_machine.excute("cross_server_battel_rank_cell",0,{i,_ED.cross_server_battel_server_rank_info.other[(i - 1)..""],2})
            ListView_phb:addChild(cell)
        else
            self.isOver = true
        end
    end
    ListView_phb:requestRefreshView()
end

function CrossServerBattelServerRankList:onUpdateDraw()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_cross_service_rank")
    ListView_phb:removeAllItems()
    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    if table.nums(_ED.cross_server_battel_server_rank_info.other) == 0 then
        for i = 1, 3 do 
            local cell = state_machine.excute("cross_server_battel_rank_cell",0,{i, nil, 2})
            ListView_phb:addChild(cell)
        end
    else
        for i = 1, table.nums(_ED.cross_server_battel_server_rank_info.other) do
            local cell = state_machine.excute("cross_server_battel_rank_cell",0,{i,_ED.cross_server_battel_server_rank_info.other[(i - 1)..""],2})
            ListView_phb:addChild(cell)
        end
    end

    ListView_phb:refreshView()

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
            state_machine.excute("cross_server_battel_server_rank_refresh_list", 0, nil)
        end
    end
    ListView_phb:addScrollViewEventListener(scrollViewEvent)
end

function CrossServerBattelServerRankList:onUpdate(dt)
    
end

function CrossServerBattelServerRankList:onEnterTransitionFinish()

end

function CrossServerBattelServerRankList:onInit( )
    local csbItem = csb.createNode("campaign/cross_service/cross_service_rank_listview.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if CrossServerBattelServerRankList.__size == nil then
        CrossServerBattelServerRankList.__size = root:getContentSize()
    end
    self:setContentSize(CrossServerBattelServerRankList.__size)

    self:onUpdateDraw()
end

function CrossServerBattelServerRankList:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function CrossServerBattelServerRankList:onExit()
    state_machine.remove("cross_server_battel_server_rank_open_list_show")    
    state_machine.remove("cross_server_battel_server_rank_open_list_hide")
    state_machine.remove("cross_server_battel_server_rank_refresh_list")
end
