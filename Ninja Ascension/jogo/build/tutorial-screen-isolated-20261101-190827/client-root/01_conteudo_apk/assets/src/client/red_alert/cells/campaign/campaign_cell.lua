-----------------------------
--日常 历练 控件
-----------------------------
CampaignCell = class("CampaignCellClass", Window)
CampaignCell.__size = nil

--日常副本列表
local campaign_create_cell_terminal = {
    _name = "campaign_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local id = params[1]
        local cell = CampaignCell:new()
        cell:init(id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(campaign_create_cell_terminal)
state_machine.init()

function CampaignCell:ctor()
    self.super:ctor()
    self.roots = {}

    self.id = nil   --1 资源点，2 镖车，3 守卫襄阳，4 装备，5 宝石，6 一代宗师， 7 侠客行
end

--刷新列表数据
function CampaignCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_campaign_cell_infor = ccui.Helper:seekWidgetByName(root,"Text_campaign_cell_infor")
    -- 运送军资开启时间
    local Panel_ship = ccui.Helper:seekWidgetByName(root,"Panel_ship")
    Panel_ship:setVisible(false)
    -- 资源点显示开启时间
    local Image_resource_t = ccui.Helper:seekWidgetByName(root,"Image_resource_t")
    Image_resource_t:setVisible(false)
    if self.id == 1 then
        Text_campaign_cell_infor:setString(red_alert_all_str[253])
        Image_resource_t:setVisible(true)
    elseif self.id == 2 then
        local leave_tran_times = tonumber(_ED.transport_resouce_info.leave_tran_times)       --剩余运送次数
        if leave_tran_times < 0 then
            leave_tran_times = 0
        end
        local leave_attack_times = tonumber(_ED.transport_resouce_info.leave_attack_times)    --剩余掠夺次数
        if leave_attack_times < 0 then
            leave_attack_times = 0
        end
        local max_tran_times = dms.int(dms["base_consume"],70,base_consume.vip_0_value + tonumber(_ED.vip_grade))
        local max_attack_times = dms.int(dms["base_consume"],71,base_consume.vip_0_value + tonumber(_ED.vip_grade))
        Text_campaign_cell_infor:setString(string.format(red_alert_all_str[138],leave_tran_times,max_tran_times,leave_attack_times,max_attack_times))
        if leave_tran_times == 0 and leave_attack_times == 0 then
            Text_campaign_cell_infor:setString(red_alert_all_str[139])
        end
        Panel_ship:setVisible(true)
    elseif self.id == 3 then
        local max_attack_times = dms.int(dms["raiders_cut_config"],4,raiders_cut_config.param)  
        local leave_attack_times = max_attack_times - _ED.raiders_cut_attack_times 
        Text_campaign_cell_infor:setString(string.format(daily_string[self.id],leave_attack_times,max_attack_times))
        if leave_attack_times == 0 then
            Text_campaign_cell_infor:setString(red_alert_all_str[139])
        end
    elseif self.id == 4 then
        local max_times = dms.int(dms["base_consume"],69,base_consume.vip_0_value + tonumber(_ED.vip_grade))
        local leave_times = max_times - tonumber(_ED.npc_equip_all_attack_times)
        if leave_times < 0 then
            leave_times = 0
        end
        Text_campaign_cell_infor:setString(string.format(daily_string[self.id],leave_times,max_times))
        if leave_times == 0 then
            Text_campaign_cell_infor:setString(red_alert_all_str[139])
        end
    elseif self.id == 5 then
        local max_times = dms.string(dms["gem_duplicate_config"],2,gem_duplicate_config.param)
        local attack_times = 0
        for i = 1, dms.count( dms["pve_scene"] ) do 
            local scene_type = dms.int(dms["pve_scene"],i,pve_scene.scene_type)
            if scene_type == 16 then
                local scene_id = i
                if tonumber(_ED.get_star_count[scene_id]) > 0 then
                    attack_times = attack_times + 1
                end
            end
        end
        local leave_times = max_times - attack_times
        if leave_times < 0 then
            leave_times = 0
        end
        Text_campaign_cell_infor:setString(string.format(daily_string[self.id],leave_times,max_times))
        if leave_times == 0 then
            Text_campaign_cell_infor:setString(red_alert_all_str[139])
        end
    elseif self.id == 6 then
        local leave_attack_times = 1
        local max_attack_times = 1
        Text_campaign_cell_infor:setString(string.format(daily_string[self.id],leave_attack_times,max_attack_times))
        if _ED.soul_duplicate.attack_count ~= 0 then
            Text_campaign_cell_infor:setString(red_alert_all_str[139])
        end
    elseif self.id == 7 then
        Text_campaign_cell_infor:setString(red_alert_all_str[135])
    end
    local Button_campaign_cell = ccui.Helper:seekWidgetByName(root,"Button_campaign_cell")
    local button_name = string.format(config_res.images.ui.activity.daily_function, self.id)
    local sprites = cc.Sprite:create(button_name)
    Button_campaign_cell:loadTextures(button_name,button_name,button_name)
end

function CampaignCell:onEnterTransitionFinish()

end

--初始化列表
function CampaignCell:onInit( )
    local csbItem = csb.createNode(config_csb.cells.campaign.campaign_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
	
	table.insert(self.roots, root)
    if CampaignCell.__size == nil then
        CampaignCell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_campaign_cell"), nil, 
    {
        terminal_name = "campaign_click_child_page", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_campaign_cell",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_campaign_cell"),
    _id = self.id,
    _invoke = nil,
    _interval = 0.5,})

	self:onUpdateDraw()	
end

function CampaignCell:init(id)
    self.id = id
	self:onInit()
    self:setContentSize(CampaignCell.__size)
    return self
end

function CampaignCell:onExit()

end
