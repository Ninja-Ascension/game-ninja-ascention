-----------------------------
--宝石副本难度选择cell
-----------------------------
GemDuplicateTowCell = class("GemDuplicateTowCellClass", Window)
GemDuplicateTowCell.__size = nil

--创建cell
local gem_duplicate_tow_create_cell_terminal = {
    _name = "gem_duplicate_tow_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local npc_data = params[1]
        local gem_duplicate_level = params[2]
        local scene_id = params[3]
        local cell = GemDuplicateTowCell:new()
        cell:init(npc_data,gem_duplicate_level,scene_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(gem_duplicate_tow_create_cell_terminal)
state_machine.init()

function GemDuplicateTowCell:ctor()
    self.super:ctor()
    self.roots = {}

    -- var

    --npc信息
    self.npc_data = nil
    
    --难度
    self.gem_duplicate_level = nil

    --场景id
    self.scene_id = nil

    -- load lua file


    -- Initialize gem_duplicate_tow_cell state machine.
    local function init_gem_duplicate_tow_cell_terminal()
	  --点击打开对应的宝石副本出战界面
        local gem_duplicate_tow_cell_click_terminal = {
            _name = "gem_duplicate_tow_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local state = cell.npc_data.state
                local npc_id = tonumber(cell.npc_data.npc_id)
                local scene_id = tonumber(cell.scene_id)
                local open_level = dms.int(dms["npc"],npc_id,npc.attack_level_limit)
                if open_level > tonumber(_ED.user_info.user_grade) then
                    return
                end
                --todo 请求
                if state > 0 then
                    if tonumber(_ED.get_star_count[scene_id]) > 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                    local function responsePlotCopySweepCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("reward_obtain_window_open",0,{2})
                            state_machine.excute("gem_duplicate_tow_window_close",0,"")
                            state_machine.excute("campaign_updatedraw_cell",0,{5})
                            state_machine.excute("packs_scrollview_all_update_draw",0,"")
                            state_machine.excute("packs_scrollview_jewelry_onupdate_all_jewelry",0,"")
                            state_machine.excute("gem_duplicate_update_draw",0,"")
                        end
                    end
                    _ED.show_reward_list_group = {}
                    protocol_command.gem_sweep.param_list = "" .. npc_id .."\r\n".. 1 .."\r\n".. 1 .."\r\n".. scene_id
                    NetworkManager:register(protocol_command.gem_sweep.code, nil, nil, nil, instance, responsePlotCopySweepCallback, false, nil)
                    -- print("==宝石副本扫荡,npc_id",npc_id)
                elseif state == 0 then
                    if tonumber(_ED.get_star_count[scene_id]) > 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                    app.load("client.red_alert.battle.battle_enum")
                    -- print("==宝石副本攻击,进入场景,npc_id",npc_id)
                    _ED.npc_last_state[npc_id] = "".._ED.npc_state[npc_id]
                    _ED._current_scene_id = scene_id
                    _ED._scene_npc_id = npc_id
                    _ED._npc_difficulty_index = "1"
                    local function responseBattleStartCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            protocol_command.battle_result_verify.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
                            app.load("client.red_alert.battle.battle_loading")
                            state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_16)                                            
                        end
                    end
                    _ED.show_reward_list_group = {}
                    _ED._battle_init_type = battle_enum._fight_type._fight_type_16
                    protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_16.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
                    NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                elseif state < 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[106])
                    return
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(gem_duplicate_tow_cell_click_terminal)
        state_machine.init()
    end
    
    -- call func init gem_duplicate_tow_cell state machine.
    init_gem_duplicate_tow_cell_terminal()
end


function GemDuplicateTowCell:onUpdateDraw()
    local root = self.roots[1]
    local Image_raids = ccui.Helper:seekWidgetByName(root,"Image_raids") -- 扫荡标志
    local Text_dup_name = ccui.Helper:seekWidgetByName(root,"Text_dup_name") -- 难度
    local Button_dup = ccui.Helper:seekWidgetByName(root,"Button_dup") --出战

    local npc_id = self.npc_data.npc_id
    local open_level = dms.int(dms["npc"],npc_id,npc.attack_level_limit)
    local button_name = string.format(config_res.images.ui.play.gemduplicate.gem_duplicate, self.gem_duplicate_level)
    --npc是否开启
    if self.npc_data.state > 0 then
        Image_raids:setVisible(true)
    elseif self.npc_data.state < 0 then
        Button_dup:setBright(false)
        button_name = string.format(config_res.images.ui.play.gemduplicate.gem_duplicate_g, self.gem_duplicate_level)
    end
    Button_dup:loadTextures(button_name,button_name,button_name) 
    --是否达到开启等级
    if open_level > tonumber(_ED.user_info.user_grade) then
        Button_dup:setBright(false)
        Text_dup_name:setString(string.format(red_alert_all_str[107],open_level))
        Text_dup_name:setVisible(true)
    else
        Text_dup_name:setVisible(false)
    end
    local Panel_difficulty = ccui.Helper:seekWidgetByName(root,"Panel_difficulty")
    Panel_difficulty:removeBackGroundImage()
    Panel_difficulty:setBackGroundImage(string.format(config_res.images.ui.play.gemduplicate.difficulty, self.gem_duplicate_level))
end


function GemDuplicateTowCell:onEnterTransitionFinish()

end

function GemDuplicateTowCell:onInit( )
    local csbItem = csb.createNode(config_csb.cells.campaign.gemduplicate.gem_duplicate_tow_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
	
	table.insert(self.roots, root)
    if GemDuplicateTowCell.__size == nil then
        GemDuplicateTowCell.__size = root:getContentSize()
    end
    --出战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dup"), nil, 
    {
        terminal_name = "gem_duplicate_tow_cell_click", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end

function GemDuplicateTowCell:init(npc_data,gem_duplicate_level,scene_id)
    self.npc_data = npc_data
    self.gem_duplicate_level = gem_duplicate_level
    self.scene_id = scene_id
	self:onInit()
    self:setContentSize(GemDuplicateTowCell.__size)
    return self
end

function GemDuplicateTowCell:onExit()

end
