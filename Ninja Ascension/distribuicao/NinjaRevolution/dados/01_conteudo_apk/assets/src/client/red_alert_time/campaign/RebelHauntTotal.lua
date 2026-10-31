--------------------------------------------------------------------------------------------------------------
--  说明：叛军出没-总排行
--------------------------------------------------------------------------------------------------------------
RebelHauntTotal = class("RebelHauntTotalClass", Window)

--打开界面
local rebel_haunt_total_open_terminal = {
	_name = "rebel_haunt_total_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = RebelHauntTotal:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rebel_haunt_total_open_terminal)
state_machine.init()

function RebelHauntTotal:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_rebel_rank_arrow_down = nil
    self._Image_rebel_rank_arrow_up = nil

    local function init_rebel_haunt_total_terminal()
        local rebel_haunt_total_show_terminal = {
            _name = "rebel_haunt_total_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rebel_haunt_total_hide_terminal = {
            _name = "rebel_haunt_total_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rebel_haunt_total_update_draw_terminal = {
            _name = "rebel_haunt_total_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(rebel_haunt_total_show_terminal)
        state_machine.add(rebel_haunt_total_hide_terminal)
        state_machine.add(rebel_haunt_total_update_draw_terminal)
        state_machine.init()
    end
    init_rebel_haunt_total_terminal()
end

function RebelHauntTotal:refreshListView()
    if self._list_view ~= nil then
        self._list_view:jumpToTop()
        self._list_view:requestRefreshView()
    end
end

function RebelHauntTotal:onUpdateDraw()
    local root = self.roots[1]
    local Text_rebel_week_all_attack_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_week_all_attack_n")
    local Text_rebel_week_all_integral_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_week_all_integral_n")
    local Text_rebel_integral_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_integral_rank_n")
    local ListView_rebel_week_rank = ccui.Helper:seekWidgetByName(root, "ListView_rebel_week_rank")
    Text_rebel_week_all_attack_n:removeAllChildren(true)
    self._list_view = ListView_rebel_week_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local user_info = nil
    for k, v in pairs(_ED.user_rebel_haunt_total_rank_info) do
        if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
            user_info = v
        end
        local cell = state_machine.excute("rebel_week_rank_create_cell", 0, {v, k, 1})
        self._list_view:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

    local min_score = zstring.split(dms.string(dms["rebel_haunt_config"], 5, rebel_haunt_config.param), ",")[2]
    if user_info == nil then
        Text_rebel_integral_rank_n:setString(tipStringInfo_campaign_info[4])
    else
        if tonumber(user_info.rank) > 0 and tonumber(user_info.score) >= tonumber(min_score) then
            Text_rebel_integral_rank_n:setString(user_info.rank)
        else
            Text_rebel_integral_rank_n:setString(tipStringInfo_campaign_info[4])
        end
    end

    Text_rebel_week_all_integral_n:setString(_ED.user_rebel_haunt_user_info.total_score)

    local kill_info = zstring.split(_ED.user_rebel_haunt_user_info.total_kill_info, ",")
    local little_count =  tonumber(kill_info[1])
    local bettle_count = tonumber(kill_info[2])
    local boss_count = tonumber(kill_info[3])

    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local color = cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3])
    local re1 = ccui.RichElementText:create(1, color, 255, tipStringInfo_campaign_info[1], "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re1)
    color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    local re1_1 = ccui.RichElementText:create(1, color, 255, "("..little_count..")    ", "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re1_1)
    color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
    local re2 = ccui.RichElementText:create(1, color, 255, tipStringInfo_campaign_info[2], "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re2)
    color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    local re2_1 = ccui.RichElementText:create(1, color, 255, "("..bettle_count..")    ", "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re2_1)
    color = cc.c3b(color_Type[4][1],color_Type[4][2],color_Type[4][3])
    local re3 = ccui.RichElementText:create(1, color, 255, tipStringInfo_campaign_info[3], "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re3)
    color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    local re3_1 = ccui.RichElementText:create(1, color, 255, "("..boss_count..")", "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re3_1)
    _richText_2:setPosition(cc.p(Text_rebel_week_all_attack_n:getContentSize().width/2,Text_rebel_week_all_attack_n:getContentSize().height/2))
    _richText_2:setContentSize(cc.size(Text_rebel_week_all_attack_n:getContentSize().width,20))
    Text_rebel_week_all_attack_n:addChild(_richText_2)
end

function RebelHauntTotal:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_rebel_rank_arrow_down:setVisible(true)
        else
            self._Image_rebel_rank_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_rebel_rank_arrow_up:setVisible(true)
        else
            self._Image_rebel_rank_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function RebelHauntTotal:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.rebel_haunt_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_rebel_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_rebel_rank_arrow_down")
    self._Image_rebel_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_rebel_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_rebel_rank_arrow_down:stopAllActions()
    self._Image_rebel_rank_arrow_up:stopAllActions()
    playActions(self._Image_rebel_rank_arrow_down)
    playActions(self._Image_rebel_rank_arrow_up)
    self._Image_rebel_rank_arrow_down:setVisible(false)
    self._Image_rebel_rank_arrow_up:setVisible(false)

    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    protocol_command.rebel_haunt_rank_list_get.param_list = "1".. "\r\n" .."1".. "\r\n" .."20"
    NetworkManager:register(protocol_command.rebel_haunt_rank_list_get.code, nil, nil, nil, self, responseCallback, false, nil)
end

function RebelHauntTotal:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function RebelHauntTotal:onExit()
    state_machine.remove("rebel_haunt_total_show")
    state_machine.remove("rebel_haunt_total_hide")
    state_machine.remove("rebel_haunt_total_update_draw")
end