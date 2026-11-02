-- 组合卡道具领取界面

CombinePropWindow = class("CombinePropWindowClass", Window)

local combine_prop_window_open_terminal = {
	_name = "combine_prop_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("CombinePropWindowClass") == nil then
			fwin:open(CombinePropWindow:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local combine_prop_window_close_terminal = {
	_name = "combine_prop_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CombinePropWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(combine_prop_window_open_terminal)
state_machine.add(combine_prop_window_close_terminal)
state_machine.init()

function CombinePropWindow:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")


    local function init_combine_prop_window_terminal()
        -- 领取奖励
        local combine_prop_window_get_award_terminal = {
            _name = "combine_prop_window_get_award",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd,fwin._ui)

                            state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw", 0 , "sm_role_strengthen_tab_rising_star_update_draw.")
                            state_machine.excute("home_update_top_activity_info_state",0,"")
                        end
                    end

	            	protocol_command.combine_ship_prop_receive.param_list = ""
                    NetworkManager:register(protocol_command.combine_ship_prop_receive.code, nil, nil, nil, instance, responseCallback, false, nil)
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

       
        state_machine.add(combine_prop_window_get_award_terminal)
        state_machine.init()
    end
    init_combine_prop_window_terminal()
end

function CombinePropWindow:onUpdateDraw()
    local root = self.roots[1]
    -- 海报添加

    -- 道具添加
    local propsData = dms.string(dms["activity_config"], 71, activity_config.param)
    local propsDatas = zstring.split(propsData,",")
    local cell = self:addResourcesIconCell(propsDatas)
    local Panel_item = ccui.Helper:seekWidgetByName(root,"Panel_item")
    cell:setAnchorPoint(0.5,0.5)
    cell:setPosition(cc.p(Panel_item:getContentSize().width/2,Panel_item:getContentSize().height/2))
    Panel_item:addChild(cell)

    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")

    local prop_name = ""
    local mouldId = tonumber(propsDatas[2])

    -- 道具
	if tonumber(propsDatas[1]) == 6 then
        prop_name = dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            prop_name = setThePropsIcon(propsDatas[2])[2]
        end
	-- 武器
	elseif tonumber(propsDatas[1]) == 7 then
	    local prop_info = dms.element(dms["equipment_mould"], mouldId)
        prop_name = smEquipWordlFundByIndex(mouldId , 1)

    elseif tonumber(propsDatas[1]) == 13 then
        local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        -- local ship_evo = zstring.split(hero.evolution_status, "|")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        prop_name = word_info[3]
	elseif tonumber(propsDatas[1]) == 71 then 
			--获取锦囊名称索引
			local nameindex = dms.int(dms["ship_silk_bag_mould"], mouldId, equipment_mould.equipment_name)
			--通过锦囊索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local names = word_info[3]
			--绘制
			prop_name = names	
	else
		if prop_name == "" then
	        prop_name = _All_tip_string_info._fundName
	    end
	end
    Text_name:setString(prop_name)

end


function CombinePropWindow:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end


function CombinePropWindow:init(params)
	self:onInit()
    return self
end

function CombinePropWindow:onInit()
    local csbItem = csb.createNode("cultivate/Combination_card/Combination_card_tuisong.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_download"), nil, 
    {
        terminal_name = "combine_prop_window_get_award", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "combine_prop_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function CombinePropWindow:onEnterTransitionFinish()
end

function CombinePropWindow:onExit()
	state_machine.remove("combine_prop_window_get_award")
end

