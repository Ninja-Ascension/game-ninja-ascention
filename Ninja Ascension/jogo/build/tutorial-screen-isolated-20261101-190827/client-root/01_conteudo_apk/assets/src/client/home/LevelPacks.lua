-- ----------------------------------------------------------------------------------------------------
-- 说明：等级礼包
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
LevelPacks = class("LevelPacksClass", Window)

local level_packs_open_terminal = {
		_name = "level_packs_open",
		_init = function (terminal) 
			
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			local level_packs = LevelPacks:new()
			level_packs:init()
			fwin:open(level_packs,fwin._viewdialog)
			return true
		end,
		_terminal = nil,
		_terminals = nil
	}
local level_packs_close_terminal = {
		_name = "level_packs_close",
		_init = function (terminal) 
			
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			fwin:close(fwin:find("LevelPacksClass"))
	        -- state_machine.excute("menu_back_home_page", 0, "") 
            -- state_machine.excute("menu_clean_page_state", 0, "")
            state_machine.unlock("menu_manager_change_to_page", 0, "")
            state_machine.unlock("menu_manager", 0, "")
            local menu_manager_terminal = state_machine.find("menu_manager")
            if menu_manager_terminal ~= nil then
                menu_manager_terminal.last_terminal_name = nil
            end
			return true
		end,
		_terminal = nil,
		_terminals = nil
	}	
state_machine.add(level_packs_open_terminal)
state_machine.add(level_packs_close_terminal)
state_machine.init()
function LevelPacks:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.levels = {}
    -- Initialize PushInfo page state machine.
    local function init_level_packs_terminal()
    	local level_packs_close_action_terminal = {
			_name = "level_packs_close_action",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance.actions[1]:play("window_close",false)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local level_packs_get_reward_terminal = {
			_name = "level_packs_get_reward",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if tonumber(instance.levels[params._datas.index]) > tonumber(_ED.user_info.user_grade) then
					TipDlg.drawTextDailog(string.format(_string_piece_info[390],instance.levels[params._datas.index]))
					return
				end
				local index = params._datas.index - 1
    			local function responseActivityCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- print("====领取成功===")
						-- debug.print_r(_ED.active_activity[12])
						if response.node ~= nil and response.node.roots ~=nil and response.node.onUpdateData ~= nil then
							response.node:onUpdateData()
							state_machine.excute("home_check_level_packs",0,"")
							local getRewardWnd = DrawRareReward:new()
						    getRewardWnd:init(7)
						    fwin:open(getRewardWnd,fwin._ui)

						end
					end
				end
				-- print("====================================",index)
				protocol_command.get_activity_reward.param_list = _ED.active_activity[12].activity_id.."\r\n"..index.."\r\n"..0
				NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseActivityCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(level_packs_close_action_terminal)
		state_machine.add(level_packs_get_reward_terminal)
        state_machine.init()
    end

    -- call func init hom state machine.
    init_level_packs_terminal()
end


function LevelPacks:onUpdateData()
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.reward.DrawRareReward")
	local level_tabel = zstring.split(_ED.active_activity[12].activity_login_day,",")
	self.levels = level_tabel
	-- debug.print_r(_ED.active_activity[12])
	local activity_data = _ED.active_activity[12].activity_Info
	local activity_number = #_ED.active_activity[12].activity_Info
	for i=1 , activity_number do
		if i > 3 then
			break
		end
		-- print("============level_tabel========",level_tabel[i])
		self:onUpdatePack(i,level_tabel[i],activity_data[i])
	end
end
function LevelPacks:onUpdatePack(index,level,activity_data)
	local root = self.roots[1]
	local Panel_lv_icon = ccui.Helper:seekWidgetByName(root,"Panel_lv_icon_"..index)
	local Button_lingqu = ccui.Helper:seekWidgetByName(root,"Button_lingqu_"..index)
	local Text_icon_name = ccui.Helper:seekWidgetByName(root,"Text_icon_name_"..index)
	local BitmapFontLabel_level = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_level_"..index)
	local Image_lingqu = ccui.Helper:seekWidgetByName(root,"Image_lingqu_"..index)
	local rewardData = activity_data
	local prop_name = ""
	-- debug.print_r(rewardData)
	-- print("=====level=====",index,level)
	local title = string.format(_string_piece_info[390],level)
	BitmapFontLabel_level:setString(title)
	if rewardData.activityInfo_gold ~= "0" then
		prop_name = _All_tip_string_info._crystalName 
		local cell = propMoneyIcon:createCell()
		cell:init("2",nil,nil)
		Panel_lv_icon:addChild(cell)
		-- print("============1=========",rewardData.activityInfo_gold)
		Text_icon_name:setString(prop_name.."x"..rewardData.activityInfo_gold)
	elseif #rewardData.activityInfo_equip_info ~= 0 then
		local equip_id = rewardData.activityInfo_equip_info[1].equipMould
		prop_name = dms.string(dms["equipment_mould"],tonumber(equip_id),equipment_mould.equipment_name)
		local cell = EquipIconCell:createCell()
		cell:init(13,nil,equip_id)
		Panel_lv_icon:addChild(cell)
		-- print("===========2=========",equip_id)
		Text_icon_name:setString(prop_name.."x"..1)
	elseif #rewardData.activityInfo_prop_info ~= 0 then
		local prop_id = rewardData.activityInfo_prop_info[1].propMould
		prop_name = dms.string(dms["prop_mould"],tonumber(prop_id),prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        prop_name = setThePropsIcon(tonumber(prop_id))[2]
	    end
		local cell = PropIconNewCell:createCell()
		cell:init(7,prop_id)
		Panel_lv_icon:addChild(cell)
		-- print("========3============",prop_id)
		Text_icon_name:setString(prop_name.."x"..1)
	end
	if rewardData.activityInfo_isReward == "1" then
		Button_lingqu:setBright(false)
		Button_lingqu:setTouchEnabled(false)
		Button_lingqu:setVisible(false)
		Image_lingqu:setVisible(true)
	end
	fwin:addTouchEventListener(Button_lingqu,  nil, 
    {
        terminal_name = "level_packs_get_reward", 
        index = index,  
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

end


function LevelPacks:onEnterTransitionFinish()
end

function LevelPacks:onUpdateDraw()
	
end

function LevelPacks:onInit()
	local csbLevelPacks = csb.createNode("activity/wonderful/level_packs.csb")
	local root = csbLevelPacks:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbLevelPacks)
    local action = csb.createTimeline("activity/wonderful/level_packs.csb")
  	table.insert(self.actions, action)
    csbLevelPacks:runAction(action)

    action:play("window_open",false)

    self:onUpdateData()

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("level_packs_close",0,"")
        end
        
    end)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_6"),  nil, 
    {
        terminal_name = "level_packs_close_action",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

end
function LevelPacks:init()
	self:onInit()
end
function LevelPacks:onExit()
	state_machine.remove("level_packs_close_action",0,"")
	state_machine.remove("level_packs_get_reward",0,"")
end