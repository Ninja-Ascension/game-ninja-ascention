-----------------------------
--疯狂矿工
-----------------------------
RedAlertTimeActivityInsaneMiner = class("RedAlertTimeActivityInsaneMinerClass", Window)

local red_alert_time_insane_miner_window_open_terminal = {
    _name = "red_alert_time_insane_miner_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeActivityInsaneMinerClass") then
            local panel = RedAlertTimeActivityInsaneMiner:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_insane_miner_window_open_terminal)
state_machine.init()

function RedAlertTimeActivityInsaneMiner:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
    self.m_times = 0
    self._scroll_view = nil
    self._scroll_view_poy = 0
    self._scroll_view_height = 0
    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil

    local function init_red_alert_time_activity_insane_miner_terminal()
	
        --去采集
        local red_alert_time_goto_collect_terminal = {
            _name = "red_alert_time_goto_collect",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	state_machine.excute("short_cut_go_to_other_window",0,{14})
                state_machine.excute("wonderful_window_close",0,nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_goto_collect_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_troops_assembled state machine.
    init_red_alert_time_activity_insane_miner_terminal()
end

function RedAlertTimeActivityInsaneMiner:onUpdateDraw()
    local root = self.roots[1]
    local Text_insane_miner_p_2 = ccui.Helper:seekWidgetByName(root, "Text_insane_miner_p_2") -- 描述
	local Text_insane_miner_time_n = ccui.Helper:seekWidgetByName(root, "Text_insane_miner_time_n") -- 时间
    local Text_insane_miner_time_t = ccui.Helper:seekWidgetByName(root, "Text_insane_miner_time_t")
    local Text_insane_miner_name = ccui.Helper:seekWidgetByName(root, "Text_insane_miner_name") --名称
    local ScrollView_insane_miner_reward = ccui.Helper:seekWidgetByName(root, "ScrollView_insane_miner_reward")
    ScrollView_insane_miner_reward:removeAllChildren(true)
    local controlSize = ScrollView_insane_miner_reward:getContentSize()
    local reward_arry = {}

    Text_insane_miner_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
    Text_insane_miner_p_2:setString(_ED.activity_info[""..self.activity_type].activity_dec)
    Text_insane_miner_time_n:setVisible(false)
    Text_insane_miner_time_t:removeAllChildren(true)
    Text_insane_miner_time_t:setString("")
    local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    --掉落绘制
    local cell_height = nil
    local cell_width = nil 
    local drop_library = tonumber(timesData[3])
    local reward_items = dms.string(dms["scene_reward"], drop_library, scene_reward.reward_items)
    rewarldData = zstring.split(reward_items,"|")
    for i=1 ,#rewarldData do
        local datas = zstring.split(rewarldData[i], ",")
        if tonumber(datas[1]) == -1 then
            datas[1] = resource_prop_id[tonumber(datas[2])]
            datas[2] = 1
        end
        local prop_type = tonumber(datas[2])
        local show_type = 6
        local prop_from_type = 3
        if tonumber(datas[2]) == 13 then --坦克
            prop_type = 3
            prop_from_type = 10
        elseif tonumber(datas[2]) == 6 then --道具    
            prop_type = 1
            prop_from_type = 1
        elseif tonumber(datas[2]) == 7 then --配件    
            prop_type = 7
            prop_from_type = 4
        else
            prop_type = 1
            prop_from_type = 1
        end
        local cell = nil
        if prop_type == 7 then
            local equip_datas = {}
            equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
            equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
        else
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
        end
        table.insert(reward_arry , cell)
        if cell_height == nil then
            cell_height = cell:getContentSize().height + 50
        end
        if cell_width == nil then
            cell_width = cell:getContentSize().width
        end
        ScrollView_insane_miner_reward:addChild(cell)
    end
    local innerHeight = math.max(math.ceil(#rewarldData / 4) * cell_height, controlSize.height) 
    ScrollView_insane_miner_reward:setInnerContainerSize(cc.size(controlSize.width, innerHeight))
    local interval = (controlSize.width - 4 * cell_width - 20) / 3
    for i , v in pairs(reward_arry) do 
       v:setPositionY(innerHeight - math.ceil(i / 4) * cell_height + 50) 
       v:setPositionX(((i - 1) % 4) * (cell_width + interval) + 10)
    end
    self._scroll_view = ScrollView_insane_miner_reward
    self._scroll_view_poy = self._scroll_view:getInnerContainer():getPositionY()
    self._scroll_view_height = self._scroll_view:getInnerContainer():getPositionY()

    local font_size = Text_insane_miner_time_t:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_insane_miner_time_t:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_insane_miner_time_t:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_insane_miner_time_t:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_insane_miner_time_t:addChild(time_int_1)
end

function RedAlertTimeActivityInsaneMiner:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_insane_miner_time_t"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_insane_miner_time_t"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
    if self._scroll_view ~= nil then
        local size = self._scroll_view:getContentSize()
        local posY = self._scroll_view:getInnerContainer():getPositionY()
        if self._scroll_view_height == 0 then
            self._scroll_view_height = posY
        end
        if self._scroll_view_poy <= -30 then
            self._Image_act_share_arrow_down:setVisible(true)
        else
            self._Image_act_share_arrow_down:setVisible(false)
        end
        if self._scroll_view_poy >= self._scroll_view_height + 30 then
            self._Image_act_share_arrow_up:setVisible(true)
        else
            self._Image_act_share_arrow_up:setVisible(false)
        end
        if self._scroll_view_poy == posY then
            return
        end
        self._scroll_view_poy = posY
    end
end

function RedAlertTimeActivityInsaneMiner:onEnterTransitionFinish()

end


function RedAlertTimeActivityInsaneMiner:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_insane_miner)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
    --升级科技
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_insane_miner_go"), nil, 
    {
        terminal_name = "red_alert_time_goto_collect", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 3)

    self._Image_act_share_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_insane_miner_arrow_down")
    self._Image_act_share_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_insane_miner_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_act_share_arrow_down:stopAllActions()
    self._Image_act_share_arrow_up:stopAllActions()
    playActions(self._Image_act_share_arrow_down)
    playActions(self._Image_act_share_arrow_up)
    self._Image_act_share_arrow_down:setVisible(false)
    self._Image_act_share_arrow_up:setVisible(false)

	self:onUpdateDraw()
end

function RedAlertTimeActivityInsaneMiner:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeActivityInsaneMiner:onExit()
    state_machine.remove("red_alert_time_goto_collect")
end
