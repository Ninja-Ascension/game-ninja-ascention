--------------------------------------------------------------------------------------------------------------
--  说明：日常活动
--------------------------------------------------------------------------------------------------------------
CampaignList = class("CampaignListClass", Window)

--打开界面
local campaign_list_open_terminal = {
	_name = "campaign_list_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = CampaignList:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(campaign_list_open_terminal)
state_machine.init()

function CampaignList:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._page = 0

    local function init_campaign_list_terminal()
        local campaign_list_update_terminal = {
            _name = "campaign_list_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                    params:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(campaign_list_update_terminal)
        state_machine.init()
    end
    
    init_campaign_list_terminal()
end

function CampaignList:updateDraw()
    local root = self.roots[1]
    local ListView_campaign = ccui.Helper:seekWidgetByName(root, "ListView_campaign")
    ListView_campaign:jumpToTop()
    ListView_campaign:removeAllItems()

    local result = {}
    for k, v in pairs(_ED.fight_center_list_info) do
        if self._page - 1 == v.list_type then
            table.insert(result, v)
        end
    end
    function sortByIndex(a, b)
        return a.id < b.id
    end
    table.sort(result, sortByIndex)
    for k, v in pairs(result) do
        v.index = k
    end
    function sortFunction(a, b)
        return a.order < b.order
    end
    table.sort(result, sortFunction)
    for k,v in pairs(result) do
        local cell = state_machine.excute("campaign_create_cell", 0, {v.index, v, self._page})
        ListView_campaign:addChild(cell)
    end
    ListView_campaign:requestRefreshView()
end

--初始化
function CampaignList:onInit()
    local csbItem = csb.createNode(config_csb.campaign.campaign_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function CampaignList:onEnterTransitionFinish()

end

function CampaignList:init(param)
    self._rootWindows = param[1]
    self._page = param[2]
	self:onInit()
    return self
end

function CampaignList:onExit()
    state_machine.remove("campaign_list_update")
end