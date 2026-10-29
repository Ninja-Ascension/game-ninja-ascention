--大师训练营兑换界面
TrainigCampChange = class("TrainigCampChangeClass", Window)

local training_camp_change_open_terminal = {
	_name = "training_camp_change_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("TrainigCampChangeClass") == nil then
			fwin:open(TrainigCampChange:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local training_camp_change_close_terminal = {
	_name = "training_camp_change_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TrainigCampChangeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(training_camp_change_open_terminal)
state_machine.add(training_camp_change_close_terminal)
state_machine.init()

function TrainigCampChange:ctor()
	self.super:ctor()
	self.roots = {}
    self._idex =  1
    self.popinfo = {}
    self._cells = {}
    app.load("client.cells.activity.training_camp_change_list_cell")
    local function init_training_camp_change_terminal()
        local training_camp_change_terminal = {
            _name = "training_camp_change_check",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._idex = params._datas.idex
                for k,v in pairs(instance._cells) do
                    if v.roots[1] then
                       if tonumber(k) == instance._idex then
                            ccui.Helper:seekWidgetByName(v.roots[1], "Image_icon_change_choose"):setVisible(true)
                        else
                            ccui.Helper:seekWidgetByName(v.roots[1], "Image_icon_change_choose"):setVisible(false)
                       end
                    end
                end
                instance:onUpdateRight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_change_send_call_terminal = {
            _name = "training_camp_change_send_call",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local rewardinfo = dms.searchs(dms["activity_pm_exchange_reward_mould"],1,instance._idex)
                local info = json.decode(_ED.active_activity[157].activity_params)
               
                if tonumber(info.userActivityInfo.level) < tonumber(rewardinfo[1][6]) then
                    TipDlg.drawTextDailog(tipStringInfo_training_camp_name[4])
                else
                    local function callBack( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                          TipDlg.drawTextDailog(tipStringInfo_training_camp_name[6])
                        end
                    end
                    protocol_command.activity_pokemon_master_exchage_reward.param_list = instance._idex
                    NetworkManager:register(protocol_command.activity_pokemon_master_exchage_reward.code, nil, nil, nil, instance, callBack, false, nil)
                return true
                end
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local training_camp_change_update_info_terminal = {
            _name = "training_camp_change_update_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for k,v in pairs(instance._cells) do
                    if v.roots[1] then
                       v:onUpdateInfo()
                    end
                end
                instance:onUpdateRight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_change_hide_ui_terminal = {
            _name = "training_camp_change_hide_ui",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_change_show_ui_terminal = {
            _name = "training_camp_change_show_ui",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(training_camp_change_terminal)
        state_machine.add(training_camp_change_send_call_terminal)
        state_machine.add(training_camp_change_update_info_terminal)
        state_machine.add(training_camp_change_show_ui_terminal)
        state_machine.add(training_camp_change_hide_ui_terminal)
        state_machine.init()
    end
    init_training_camp_change_terminal()
end

function TrainigCampChange:onUpdateDraw()
    self._cells = {}
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_camp_change")
    local number = #(_ED.training_camp_reward_info.exchangeReard)  
    local rewards = {}
    for i=1,number do
        local reward = dms.searchs(dms["activity_pm_exchange_reward_mould"],1,i)
       table.insert(rewards,reward)
    end
    if table.nums(rewards) > 0 then
        m_ScrollView:removeAllChildren(true)
        local horizontalNumber = 4
        local panel = m_ScrollView:getInnerContainer()
        panel:setContentSize(m_ScrollView:getContentSize())
        panel:setPosition(cc.p(0,0))
        panel:removeAllChildren(true)
        local sSize = panel:getContentSize()
        local sHeight = sSize.height
        local sWidth = sSize.width
        local controlSize = m_ScrollView:getInnerContainerSize()
        local nextY = sSize.height
        local nextX = sSize.widtj
        local tHeight = 0
        local cellHeight = 0
        local tWidth = 0
        local wPosition = sWidth/horizontalNumber
        local Hlindex = 0
        local m_number = math.ceil(number/horizontalNumber)
        cellHeight = m_number*(m_ScrollView:getContentSize().width/horizontalNumber)
        sHeight = math.max(sHeight, cellHeight)
        panel:setContentSize(m_ScrollView:getContentSize().width, sHeight + 10)

        local totalRewardCount = 0
        for j, v in pairs(rewards) do
            local cell = state_machine.excute("training_camp_change_list_cell_create",0,{v,j})
            table.insert(self._cells,cell)   
            panel:addChild(cell)
            tWidth = tWidth + wPosition
            if (j-1)%horizontalNumber == 0 then
                Hlindex = Hlindex+1
                tWidth = 0
                tHeight = sHeight - (wPosition + 2)*Hlindex  
            end
            if j <= horizontalNumber then
                tHeight = sHeight - wPosition
            end
            cell:setPosition(cc.p(tWidth, tHeight))
            totalRewardCount = totalRewardCount + 1
        end
        m_ScrollView:jumpToTop()
    end
    self.currentScrollView = m_ScrollView
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end


function TrainigCampChange:onUpdateRight()
    local Text_change_props_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_change_props_name")  --名称

    local Text_camp_reward_infor = ccui.Helper:seekWidgetByName(self.roots[1], "Text_camp_reward_infor")  --描述
    
    local rewardinfo = dms.searchs(dms["activity_pm_exchange_reward_mould"],1,self._idex)
    local Text_camp_icon_consume_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_camp_icon_consume_n")  --训练币
    Text_camp_icon_consume_n:setString(rewardinfo[1][3])
    
    local Image_15 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_15")  --兑换
    local Image_unlock = ccui.Helper:seekWidgetByName(self.roots[1], "Image_unlock")  --为解锁

    local info = json.decode(_ED.active_activity[157].activity_params)
    if tonumber(info.userActivityInfo.level) < tonumber(rewardinfo[1][6]) then
        Image_unlock:setVisible(true)
        Image_15:setVisible(false)
    else
        Image_unlock:setVisible(false)
        Image_15:setVisible(true)
    end  

    local end_time = os.date("%m"..".".."%d".."  ".."%H"..":".."%M", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.training_camp_reward_info.closeTime)/1000)))
    local Text_camp_end_time_n =  ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_end_time_n")  --时间
    Text_camp_end_time_n:setString(end_time)

    local Panel_reward_view = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_reward_view")  --图标
    Panel_reward_view:removeAllChildren(true)

    local rewards = zstring.split(_ED.training_camp_reward_info.exchangeReard[self._idex], ",")
    
    if #(rewards[1]) ~= 0 then
        local rewardType = zstring.tonumber(rewards[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if rewards[4] ~= nil and tonumber(rewards[4]) ~= -1 then
                table.shipStar = tonumber(rewards[4])
            end
            cell:init(rewardType, tonumber(rewards[3]), tonumber(rewards[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(rewards[3]), tonumber(rewards[2]),nil,nil,true,true,1)
        end
        Panel_reward_view:addChild(cell) 

        local props = self:getPropByType(rewardType,tonumber(rewards[2]))
        
        local describe = ""
        if tonumber(rewards[2]) ~= -1 then
            describe = drawPropsDescription(tonumber(rewards[2]))
        else
            describe = _All_tip_string_info_description._fundNameDescription
        end
        Text_camp_reward_infor:setString(describe)
        Text_change_props_name:setString(props.mould_name)
        local quality = tonumber(props.prop_quality)
        Text_change_props_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
    end

    local Text_camp_num =  ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_num")  --赛季
    Text_camp_num:setString(string.format(tipStringInfo_training_camp_name[16],_ED.training_camp_reward_info.season))
end

function TrainigCampChange:getPropByType(_type,mould_id)
    local prop = {}
    prop.type= _type
    prop.mould_id = mould_id
    local prop_info = nil
    if prop.type == 6 then
        prop_info = dms.element(dms["prop_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                prop.mould_name = setThePropsIcon(prop.mould_id)[2]
            end
        end
        if prop.prop_quality == nil then
            prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
        end
        prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            prop.mould_remarks = drawPropsDescription(prop.mould_id)
        end
    elseif prop.type == 7 then
        prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
        end
        prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
        if prop.prop_quality == 0 then
            prop.prop_quality = 3
        end
        prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
    end
    return prop
end

function TrainigCampChange:onUpdate(dt)
  
end

function TrainigCampChange:init(params)
    self._rootWindows = params[1]
	self:onInit()
    return self
end

function TrainigCampChange:onInit()
    local csbItem = csb.createNode("activity/wonderful/training_camp_change_tab.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_change"), nil,   --兑换
    {
        terminal_name = "training_camp_change_send_call", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
    self:onUpdateRight()
    if self._cells[1] then
        ccui.Helper:seekWidgetByName(self._cells[1].roots[1], "Image_icon_change_choose"):setVisible(true)
    end
end

function TrainigCampChange:onEnterTransitionFinish()
end

function TrainigCampChange:onExit()
	state_machine.remove("training_camp_change_check")
	state_machine.remove("training_camp_change_send_call")
    state_machine.remove("training_camp_change_update_info")
    state_machine.remove("training_camp_change_hide_ui")
    state_machine.remove("training_camp_change_show_ui")
end

