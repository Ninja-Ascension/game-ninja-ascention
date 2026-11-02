-- ----------------------------------------------------------------------------------------------------
-- 说明：数码的觉醒装备碎片信息
-------------------------------------------------------------------------------------------------------
SmEquipAwakenPropInformation = class("SmEquipAwakenPropInformationClass", Window)

local sm_equip_awaken_prop_information_window_open_terminal = {
    _name = "sm_equip_awaken_prop_information_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipAwakenPropInformationClass")
        if nil == _homeWindow then
            local panel = SmEquipAwakenPropInformation:createCell()
            panel:init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_equip_awaken_prop_information_close_terminal = {
    _name = "sm_equip_awaken_prop_information_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local _homeWindow = fwin:find("SmEquipAwakenPropInformationClass")
    	if _homeWindow ~= nil then
			fwin:close(_homeWindow)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_equip_awaken_prop_information_window_open_terminal)
state_machine.add(sm_equip_awaken_prop_information_close_terminal)
state_machine.init()

function SmEquipAwakenPropInformation:ctor()
    self.super:ctor()
	self.roots = {}
	self.mouldId = 0
    local function init_sm_equip_awaken_prop_information_terminal()
		--合成
		local sm_equip_awaken_prop_compose_terminal = {
            _name = "sm_equip_awaken_prop_compose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responsePropCompoundCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	app.load("client.reward.DrawRareReward")
                        local equip = _ED.user_equiment[_ED.new_equip_get]
                        local rewardInfo = {}
                        rewardInfo.show_reward_item_count = 1
                        rewardInfo.show_reward_list = {
                            { 
                                item_value = 1,
                                prop_type = 7,
                                prop_item = tonumber(equip.user_equiment_template),

                            },
                        }
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(0,rewardInfo)
                        fwin:open(getRewardWnd,fwin._ui)
                    	state_machine.excute("sm_equipment_tab_awakening_update_draw",0,"sm_equipment_tab_awakening_update_draw.")
                    	state_machine.excute("sm_equip_awaken_prop_information_close",0,"sm_equip_awaken_prop_information_close.")
                    end
                end
                local prop = fundPropWidthId(instance.mouldId)
				local str = prop.user_prop_id .. "\r\n" .. "0" .. "\r\n" .. "1"
				protocol_command.prop_compound.param_list = str
                NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, params, responsePropCompoundCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--来源
		local sm_equip_awaken_prop_to_get_way_terminal = {
            _name = "sm_equip_awaken_prop_to_get_way",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local prop = instance.mouldId --道具模板id
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(prop,2)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --来源
        local sm_equip_awaken_prop_information_updata_terminal = {
            _name = "sm_equip_awaken_prop_information_updata",
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
		state_machine.add(sm_equip_awaken_prop_to_get_way_terminal)
		state_machine.add(sm_equip_awaken_prop_compose_terminal)
        state_machine.add(sm_equip_awaken_prop_information_updata_terminal)
        state_machine.init()
    end
    init_sm_equip_awaken_prop_information_terminal()
end

function SmEquipAwakenPropInformation:onUpdateDraw()
	local root = self.roots[1]
	local sherd_info = dms.element(dms["prop_mould"] , self.mouldId)
	--图标
	local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop")
	Panel_prop:removeAllChildren(true)
	local cell = PropIconNewCell:createCell()
	cell:init(cell.enum_type._SHOW_EQUIP_INFO, self.mouldId)
	Panel_prop:addChild(cell)
	-- 描述
	local Text_tip = ccui.Helper:seekWidgetByName(root,"Text_tip")
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        Text_tip:setString(drawPropsDescription(self.mouldId))
    else
        Text_tip:setString(zstring.exchangeFrom(dms.atos(sherd_info , prop_mould.remarks)))
    end
	
	-- 道具名称
	local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name") 
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        Text_props_name:setString(setThePropsIcon(self.mouldId)[2])
    else
    	Text_props_name:setString(zstring.exchangeFrom(dms.atos(sherd_info , prop_mould.prop_name)))
    end
	local quality = dms.atoi(sherd_info , prop_mould.prop_quality)
	Text_props_name:setColor(cc.c3b(color_Type[quality + 1][1],color_Type[quality + 1][2],color_Type[quality + 1][3]))
	-- 拥有数量
	local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n")
	local needNumber = dms.atoi(sherd_info , prop_mould.split_or_merge_count)
	local haveNumber = tonumber(getPropAllCountByMouldId(self.mouldId))
	Text_have_n:setString(haveNumber.."/"..needNumber)
	--进度条
	local LoadingBar_number = ccui.Helper:seekWidgetByName(root,"LoadingBar_number")
    LoadingBar_number._self = self
	local percent = math.floor(haveNumber * 100 / needNumber)
	percent = math.min(percent , 100) 
	LoadingBar_number:setPercent(percent)
	local Button_laiyuan = ccui.Helper:seekWidgetByName(root,"Button_laiyuan")
	local Button_hecheng = ccui.Helper:seekWidgetByName(root,"Button_hecheng")
	Button_laiyuan:setVisible(false)
	Button_hecheng:setVisible(false)
	if haveNumber < needNumber then
		Button_laiyuan:setVisible(true)
	else
		Button_hecheng:setVisible(true)
	end
end

function SmEquipAwakenPropInformation:onEnterTransitionFinish()
	local csbSmEquipAwakenPropInformation= csb.createNode(config_csb.packs.to_get_window)
	
    self:addChild(csbSmEquipAwakenPropInformation)
	local root = csbSmEquipAwakenPropInformation:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()

	--碎片合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hecheng"), nil, 
    {
        terminal_name = "sm_equip_awaken_prop_compose", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "sm_equip_awaken_prop_information_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --路径跳转
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_laiyuan"), nil, 
    {
        terminal_name = "sm_equip_awaken_prop_to_get_way", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
end

function SmEquipAwakenPropInformation:onExit()
	state_machine.remove("sm_equip_awaken_prop_compose")
	state_machine.remove("sm_equip_awaken_prop_to_get_way")
    state_machine.remove("sm_equip_awaken_prop_information_updata")
end

function SmEquipAwakenPropInformation:init(mouldId)
	self.mouldId = tonumber(mouldId)			
end

function SmEquipAwakenPropInformation:createCell()
	local cell = SmEquipAwakenPropInformation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end