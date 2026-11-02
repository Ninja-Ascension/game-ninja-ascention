-----------------------------
--副本宝箱
-----------------------------
DuplicateStarBoxWindow = class("DuplicateStarBoxWindowClass", Window)

--打开副本宝箱
local duplicate_star_box_window_window_open_terminal = {
    _name = "duplicate_star_box_window_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("DuplicateStarBoxWindowClass")
        if nil == _Window then
            fwin:open(DuplicateStarBoxWindow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭副本宝箱
local duplicate_star_box_window_window_close_terminal = {
    _name = "duplicate_star_box_window_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("DuplicateStarBoxWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_star_box_window_window_open_terminal)
state_machine.add(duplicate_star_box_window_window_close_terminal)
state_machine.init()

function DuplicateStarBoxWindow:ctor()
    self.super:ctor()
    self.roots = {}

    --var

    self.floor = nil
    --宝箱类型
    self.box_type = nil
    --场景id
    self.scene_ID = nil
    --宝箱领取    0 未达成 1 可领取 2  已领取
    self.box_state = nil
    --星数奖励id
    self.reward_id = nil
    self.all_reward_datas = {}
    --星数奖励表
    self.all_reward_datas.show_reward_list = {}
    --load lua file
    app.load("client.red_alert.battle.battle_enum")
    -- Initialize DuplicateTitle state machine.
    local function init_duplicate_star_box_terminal()
	
    		--上一个
    		local duplicate_star_box_turn_left_terminal = {
            _name = "duplicate_star_box_turn_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if _ED.scene_current_state[instance.scene_ID - 1] == nil 
                   or dms.int(dms["pve_scene"],instance.scene_ID - 1,pve_scene.scene_type) + 1 ~= tonumber(instance.box_type)  then
                   return
                end

                instance.scene_ID = instance.scene_ID -1
                instance:onUpdateDraw()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
    		--下一个
    		local duplicate_star_box_turn_right_terminal = {
            _name = "duplicate_star_box_turn_right",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
    
                if _ED.scene_current_state[instance.scene_ID + 1] == nil 
                    or dms.int(dms["pve_scene"],instance.scene_ID + 1,pve_scene.scene_type) + 1 ~= tonumber(instance.box_type)
                    or _ED.scene_current_state[instance.scene_ID + 1] == "" 
                    or tonumber(_ED.scene_current_state[instance.scene_ID + 1]) == -1 then
                    return
                end
                instance.scene_ID = instance.scene_ID + 1
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        --领取奖励
        local duplicate_star_box_get_reward_terminal = {
            _name = "duplicate_star_box_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseRewardCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                      if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                         response.node:onUpdateDraw()
                         state_machine.excute("reward_obtain_window_open",0,{nil,response.node.all_reward_datas})
                         state_machine.excute("star_box_duplicate_cell_updatedraw",0,{response.node.cell})
                      end
                    end
                end
                -- print("=============",instance.scene_ID .."\r\n" .. instance.reward_id)
                protocol_command.draw_scene_rewad.param_list = ""..instance.scene_ID .."\r\n" .. 0
                NetworkManager:register(protocol_command.draw_scene_rewad.code, nil, nil, nil, instance, responseRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

		state_machine.add(duplicate_star_box_turn_left_terminal)	
		state_machine.add(duplicate_star_box_turn_right_terminal)
        state_machine.add(duplicate_star_box_get_reward_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_duplicate_star_box_terminal()
end

--刷新宝箱界面
function DuplicateStarBoxWindow:onUpdateDraw()   
    local root = self.roots[1]
    self.all_reward_datas = {}
    self.all_reward_datas.show_reward_list = {}     
    local Text_star_number = ccui.Helper:seekWidgetByName(root,"Text_star_number")          --星数

    local total_stars = dms.int(dms["pve_scene"],self.scene_ID,pve_scene.total_star)        --总星数
    Text_star_number:setString(zstring.tonumber(_ED.get_star_count[self.scene_ID]) .. "/" .. total_stars)
    
    local scene_type = dms.int(dms["pve_scene"], self.scene_ID, pve_scene.scene_type) 
    local npcs = zstring.split(dms.string(dms["pve_scene"], tonumber(self.scene_ID), pve_scene.npcs), ",")
    local scene_state = tonumber(_ED.scene_current_state[self.scene_ID])    -- 已击败npc数量
    if scene_type == battle_enum._fight_type._fight_type_104 then
        local Image_7 = ccui.Helper:seekWidgetByName(root,"Image_7"):setVisible(false)
        local Image_star_box_6 = ccui.Helper:seekWidgetByName(root,"Image_star_box_6"):setVisible(false)
        Text_star_number:setString("")
    end
    local Panel_star_box_4 = ccui.Helper:seekWidgetByName(root,"Panel_star_box_4")          --章节名
    Panel_star_box_4:removeBackGroundImage()
    Panel_star_box_4:setBackGroundImage("images/ui/pve_sn/pve_map_chapt/pve_map_chapter_name_"..self.scene_ID..".png")
    self.box_state = nil
    if zstring.tonumber(_ED.get_star_count[self.scene_ID] ) < total_stars then
        self.box_state = 0
    elseif zstring.tonumber(_ED.get_star_count[self.scene_ID] ) >= total_stars and tonumber(_ED.star_reward_state[self.scene_ID]) ~= 1 then
        self.box_state = 1
        if scene_type == battle_enum._fight_type._fight_type_104 then   -- 区分七星台和其他副本宝箱领取状态判断
            if #npcs == scene_state then
                self.box_state = 1
            else
                self.box_state = 0
            end
        end
    elseif zstring.tonumber(_ED.get_star_count[self.scene_ID] ) >= total_stars and tonumber(_ED.star_reward_state[self.scene_ID]) == 1 then
        self.box_state = 2 
    end
    --print("=========_ED.star_reward_state[self.scene_ID]==============",_ED.star_reward_state[self.scene_ID])
    --  self.box_state      0 未达成 1 可领取 2  已领取

    local Text_star_have_not = ccui.Helper:seekWidgetByName(root,"Text_star_have_not")                      --未达成
    local Button_star_box_receive = ccui.Helper:seekWidgetByName(root,"Button_star_box_receive")            --可领取
    local Image_star_box_have_received = ccui.Helper:seekWidgetByName(root,"Image_star_box_have_received")  --已领取

    if self.box_state == 0 then
      Text_star_have_not:setVisible(true)
      Button_star_box_receive:setVisible(false)
      Image_star_box_have_received:setVisible(false)
    elseif self.box_state == 1 then
      Text_star_have_not:setVisible(false)
      Button_star_box_receive:setVisible(true)
      Image_star_box_have_received:setVisible(false)
    elseif self.box_state == 2 then
      Text_star_have_not:setVisible(false)
      Button_star_box_receive:setVisible(false)
      Image_star_box_have_received:setVisible(true)      
    end

    local pveReward_tab = dms.string(dms["pve_scene"], self.scene_ID, pve_scene.star_reward_id)          --星数奖励id(奖励表)
    if pveReward_tab == nil or pveReward_tab == "-1" then
        return
    end
    local reward_id_tab = zstring.split(pveReward_tab,",")
    self.reward_id = tonumber(reward_id_tab[1])
    local ListView_star_reward = ccui.Helper:seekWidgetByName(root,"ListView_star_reward")
    ListView_star_reward:removeAllItems()
    if self.reward_id > 0 then
        local reward_items = dms.string(dms["scene_reward"], self.reward_id, scene_reward.reward_items)
        reward_items = zstring.split(reward_items,"|")
        for i,reward in ipairs(reward_items) do
            local reward_tab = zstring.split(reward,",")
            local _prop_type = tonumber(reward_tab[2])
            local _prop_item = tonumber(reward_tab[1])
            local _prop_numbers = tonumber(reward_tab[3])
            local data = 
            {
                item_value = _prop_numbers,
                prop_type = _prop_type,
                prop_item = _prop_item,
            }
            table.insert(self.all_reward_datas.show_reward_list,data)
            local cell = nil
            if _prop_type == 6 then
                local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], _prop_item, prop_mould.change_of_equipment))
                local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],_prop_item, prop_mould.use_of_ship))
                if equipment_mould_id > 0 or ship_mould_id > 0 then
                    cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false})
                end
                ListView_star_reward:addChild(cell)
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false})
                ListView_star_reward:addChild(cell)
            end
        end
    end    
    ListView_star_reward:requestRefreshView()

    local Button_star_box_light = ccui.Helper:seekWidgetByName(root,"Button_star_box_light")    --下一个
    
    if tonumber(_ED.scene_current_state[self.scene_ID + 1]) == -1 
        or dms.int(dms["pve_scene"],self.scene_ID + 1,pve_scene.scene_type) + 1 ~= tonumber(self.box_type)  then
        Button_star_box_light:setVisible(false)
    else
        Button_star_box_light:setVisible(true)
    end  
    local Button_star_box_left = ccui.Helper:seekWidgetByName(root,"Button_star_box_left")      --上一个
    if _ED.scene_current_state[self.scene_ID - 1] == nil 
        or dms.int(dms["pve_scene"],self.scene_ID - 1,pve_scene.scene_type) + 1 ~= tonumber(self.box_type)  then
        Button_star_box_left:setVisible(false)
    else
        Button_star_box_left:setVisible(true)
    end
end

function DuplicateStarBoxWindow:onEnterTransitionFinish()

end

--初始化宝箱界面
function DuplicateStarBoxWindow:onInit( )
    local csbItem = csb.createNode(config_csb.duplicate.duplicate_star_box_window)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_star_box_window"), nil, 
    {
        terminal_name = "duplicate_star_box_window_window_close", 
        terminal_state = 0, 
    }, nil, 0)

    -- 上一关
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_star_box_left"), nil, 
    {
        terminal_name = "duplicate_star_box_turn_left", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 下一关
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_star_box_light"), nil, 
    {
        terminal_name = "duplicate_star_box_turn_right", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_star_box_receive"), nil, 
    {
        terminal_name = "duplicate_star_box_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   


    
    self:onUpdateDraw()
end

--宝箱领取    0 未达成 1 可领取 2  已领取
function DuplicateStarBoxWindow:getLimitCanGetReward(index)
    local total_stars = dms.int(dms["pve_scene"],index,pve_scene.total_star)        --总星数
    local box_state = 0
    -- print("=========",total_stars,index)
    if zstring.tonumber(_ED.get_star_count[index]) < total_stars then
        box_state = 0
    elseif zstring.tonumber(_ED.get_star_count[index] ) >= total_stars and tonumber(_ED.star_reward_state[index]) ~= 1 then
        box_state = 1
    elseif zstring.tonumber(_ED.get_star_count[index] ) >= total_stars and tonumber(_ED.star_reward_state[index]) == 0 then
        box_state = 2 
    end
    return box_state
end

function DuplicateStarBoxWindow:init(params)
    self.cell = params[1]
    self.floor = params[2]
    self.box_type = params[3]
    -- debug.print_r(_ED.get_star_count)
    -- debug.print_r(_ED.scene_current_state)
    if tonumber(self.box_type) == 3 then
        self.box_type = 16
    end
    local numbers = 0
    -- print("============self.box_type",self.box_type)
    for i, v in pairs(_ED.scene_current_state) do  
        if tonumber(self.box_type) == dms.int(dms["pve_scene"],i,pve_scene.scene_type) + 1 then --场景类型(0:普通 1:精英 2活动 3:试练塔)
            if tonumber(_ED.scene_current_state[i]) == 0 then
                self.scene_ID = i
            end
            if _ED.scene_current_state[i] == "" then
                self.scene_ID = i - 1
                -- print("========1")
                break
            end
            if self:getLimitCanGetReward(i) == 1 then
                self.scene_ID = i
                -- print("========2")
                break
            end
            if tonumber(v) == -1 then
                self.scene_ID = i - 1
                -- print("========3")
                break
            end
            numbers = numbers + 1
        end
    end 
    -- print("=====scene_ID======",self.scene_ID)
    if self.scene_ID == nil then
        self.scene_ID = #_ED.scene_current_state
    end
    
    if params[4] ~= nil then
        self.scene_ID = params[4]
    end
    
    self:onInit()
    return self
end

--移除状态机
function DuplicateStarBoxWindow:onExit()
  state_machine.remove("duplicate_star_box_turn_left")  
  state_machine.remove("duplicate_star_box_turn_right")
  state_machine.remove("duplicate_star_box_get_reward")
end
