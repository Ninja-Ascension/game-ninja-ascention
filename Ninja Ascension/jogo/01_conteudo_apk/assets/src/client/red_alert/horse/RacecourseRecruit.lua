-----------------------------
--相马获得提示
-----------------------------
RacecourseRecruit = class("RacecourseRecruitClass", Window)
--打开
local racecourse_recruit_window_open_terminal = {
    _name = "racecourse_recruit_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _RacecourseRecruitWindow = fwin:find("RacecourseRecruitClass")
        if nil == _RacecourseRecruitWindow then
            local reward_data = params[1]
            fwin:open(RacecourseRecruit:new():init(reward_data), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_recruit_window_close_terminal = {
    _name = "racecourse_recruit_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseRecruitClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_recruit_window_open_terminal)
state_machine.add(racecourse_recruit_window_close_terminal)
state_machine.init()

function RacecourseRecruit:ctor()
    self.super:ctor()
    self.roots = {}
    self._horse = nil
    self._index = 0

    local function init_racecourse_recruit_terminal()
        --确定
        local racecourse_recruit_comfirm_terminal = {
            _name = "racecourse_recruit_comfirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(instance._reward_data.show_reward_item_count) > 1 then 
                    state_machine.excute("reward_obtain_window_open",0,{nil,instance._reward_data})
                end
                state_machine.excute("racecourse_recruit_window_close",0,"")
                state_machine.excute("racecourse_show_panel_treasure",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(racecourse_recruit_comfirm_terminal)

        state_machine.init()
    end
    init_racecourse_recruit_terminal()
end 

function RacecourseRecruit:onUpdateDraw()
    local root = self.roots[1]
    for i,v in pairs(self._reward_data.show_reward_list) do
        if tonumber(v.prop_type) == 35 then
            --宝物名
            local Text_treasure_name = ccui.Helper:seekWidgetByName(root, "Text_treasure_name")
            local horse_name = dms.string(dms["horse_mould"], v.prop_item, horse_mould.horse_name)
            local quality = dms.int(dms["horse_mould"], v.prop_item, horse_mould.quality)
            Text_treasure_name:setString(horse_name)
            Text_treasure_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
            --宝物属性
            local Text_attribution = ccui.Helper:seekWidgetByName(root, "Text_attribution")
            local Image_attribution_bg = ccui.Helper:seekWidgetByName(root, "Image_attribution_bg")
            local width = Image_attribution_bg:getContentSize().width
            local height = Image_attribution_bg:getContentSize().height
            local horse = _ED.horses[""..v.prop_id]
            local infos = zstring.split(horse.attribute, "|")
            local info = ""
            local index = 0
            for k,v in pairs(infos) do
                index = index + 1 
                local spirit_info = zstring.split(v, ",")
                if index == 3 then 
                    info = info ..attribute[tonumber(spirit_info[1]) + 1] .. "+".. spirit_info[2] .. "%   ".."\r\n"
                else
                    info = info ..attribute[tonumber(spirit_info[1]) + 1] .. "+".. spirit_info[2] .. "%   " 
                end
            end
            if index > 3 then
                Image_attribution_bg:setContentSize(cc.size(width,height*2))
            end
            Text_attribution:setString(info)
            Text_attribution:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
            --宝物星级
            local Panel_reward_obtain = ccui.Helper:seekWidgetByName(root, "Panel_reward_obtain")
            local star = dms.string(dms["horse_mould"], v.prop_item, horse_mould.star)
            local ArmatureNode_star = Panel_reward_obtain:getChildByName("ArmatureNode_star_"..star)
            ArmatureNode_star:setVisible(true)
            local animation = ArmatureNode_star:getAnimation()
            animation:playWithIndex(0, 0, 0)
            --宝物图片
            local Panel_treasure = ccui.Helper:seekWidgetByName(root, "Panel_treasure")
            Panel_treasure:removeAllChildren(true)
            local body_icon = dms.int(dms["horse_mould"], v.prop_item, horse_mould.body_icon)
            -- Panel_treasure:setBackGroundImage(string.format("images/ui/big_treasure/big_treasure_%d.png", body_icon))
            
            local baseName = "sprite/spirte_" .. body_icon
            local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
            skeletonNode:registerSpineEventHandler(function (event)
            end, sp.EventType.ANIMATION_COMPLETE)
            skeletonNode:setAnimation(0, "animation", true)
            Panel_treasure:addChild(skeletonNode)
        end
    end
end

function RacecourseRecruit:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_get_treasure)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_get_treasure_receive"), nil, 
    {
        terminal_name = "racecourse_recruit_comfirm", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function RacecourseRecruit:init(reward_data)
    self._reward_data = reward_data
	self:onInit()
    return self
end

function RacecourseRecruit:onExit()
    state_machine.remove("racecourse_recruit_comfirm")
end