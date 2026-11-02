
RankingUnionMember = class("RankingUnionMemberClass", Window)

local ranking_union_member_window_open_terminal = {
    _name = "ranking_union_member_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local union_info = params
        fwin:open(RankingUnionMember:new():init(union_info), fwin._ui)
    end,
    _terminal = nil,
    _terminals = nil
}

local ranking_union_member_window_close_terminal = {
    _name = "ranking_union_member_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RankingUnionMemberClass"))
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_union_member_window_open_terminal)
state_machine.add(ranking_union_member_window_close_terminal)
state_machine.init()

function RankingUnionMember:ctor()
	self.super:ctor()
	self.roots = {}

    self._union_info = nil               --帮派信息

    local function init_ranking_union_member_terminal()
   
    end
    init_ranking_union_member_terminal()
end

function RankingUnionMember:updateDraw()
    local root = self.roots[1]

    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")             --帮派名
    local Text_player_lv_n = ccui.Helper:seekWidgetByName(root, "Text_player_lv_n")             --帮派等级
    local Text_legion_n = ccui.Helper:seekWidgetByName(root, "Text_legion_n")                   --帮主名
    local Text_player_legion_n = ccui.Helper:seekWidgetByName(root, "Text_player_legion_n")     --帮派成员数
    local Text_player_build_n = ccui.Helper:seekWidgetByName(root, "Text_player_build_n")       --帮派领地数
    local Text_player_legion_infor = ccui.Helper:seekWidgetByName(root, "Text_player_legion_infor")       --帮派领宣言
    local Panel_camp_icon = ccui.Helper:seekWidgetByName(root, "Panel_camp_icon")               --帮派阵营图片

    Text_player_name:setString(self._union_info.union_name)
    Text_player_lv_n:setString(self._union_info.union_level)
    Text_legion_n:setString(self._union_info.union_president_name)
    Text_player_legion_n:setString(self._union_info.union_member)
    Text_player_build_n:setString(self._union_info.union_build_number)
    Text_player_legion_infor:setString(self._union_info.watchword)

    --显示帮派旗帜  
    Panel_camp_icon:removeBackGroundImage()
    Panel_camp_icon:setBackGroundImage(string.format("images/ui/quality/camp_%d.png", zstring.tonumber(self._union_info.union_camp)))
end

function RankingUnionMember:onInit()
    local csbItem = csb.createNode(config_csb.rank.ranking_legion_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_player_look"), nil, 
    {
        terminal_name = "ranking_union_member_window_close", 
        terminal_state = 0,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    self:updateDraw()
end

function RankingUnionMember:onEnterTransitionFinish()
    
end

function RankingUnionMember:init(union_info)
    self._union_info = union_info
    self:onInit()
    return self
end

function RankingUnionMember:onExit()
   
end