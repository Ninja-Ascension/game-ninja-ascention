-- ----------------------------------------------------------------------------------------------------
-- 说明：数码招募数码兽cell
-------------------------------------------------------------------------------------------------------
SmActivityRecruitShipCell = class("SmActivityRecruitShipCellClass", Window)
    
function SmActivityRecruitShipCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	self.example = nil
	self.index = 0
	self.activityType = 0
	self.trace_id = 0
	self.rewardState = 0
    -- Initialize SmActivityRecruitShipCell state machine.
    local function init_SmActivityRecruitShipCell_terminal()
		
		--领取
		local sm_activity_recruit_ship_reward_terminal = {
            _name = "sm_activity_recruit_ship_reward",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local index = params._datas._index
					local tempCell = params._datas._cell
					local _replyPhysical = params._datas.replyPhysical
					local param = params._datas
	            	local activityType = tempCell.activityType
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								if response.node._cell ~= nil and response.node._cell.roots ~= nil and response.node._cell.roots[1] ~= nil then
									response.node._cell:rewadDraw(response.node._index)
								end
							end
							state_machine.excute("activity_window_update_activity_page", 0, activityType)

							local rewardinfo = {}
					        rewardinfo.type = 1
					        rewardinfo.id = -1
					        rewardinfo.number = tonumber(_ED.active_activity[activityType].activity_Info[index].activityInfo_silver)

					        local temp = {}
					        temp[#temp + 1] = rewardinfo

							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7, nil, temp)
							fwin:open(getRewardWnd, fwin._ui)
						end
					end
					local activityId = _ED.active_activity[tempCell.activityType].activity_id	
					protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n1"
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, param, responseGetServerListCallback, false, nil)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --招募
		local sm_activity_recruit_ship_to_get_terminal = {
            _name = "sm_activity_recruit_ship_to_get",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
				local shipIds = zstring.split(cell.example.activityInfo_need_day,",")
				if tonumber(shipIds[1]) == 47 
					and _ED.active_activity[93] ~= nil 
					and _ED.active_activity[93] ~= "" 
					and funOpenDrawTip(152, false) == false
					then
			        state_machine.excute("activity_window_open", 0, {"client.l_digital.activity.wonderful.SmDayDiscountWindow", "SmDayDiscountWindow"})
			        state_machine.excute("activity_window_open_page_activity",0,{"SmDayDiscountWindow"})
				else
            		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = cell.trace_id, _datas = {}})
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(sm_activity_recruit_ship_reward_terminal)
        state_machine.add(sm_activity_recruit_ship_to_get_terminal)
        state_machine.init()
    end
    
    -- call func init SmActivityRecruitShipCell state machine.
    init_SmActivityRecruitShipCell_terminal()
end

function SmActivityRecruitShipCell:rewadDraw(_index)
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7)
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[self.activityType]
	
	local Image_received = ccui.Helper:seekWidgetByName(root, "Image_received")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_receive")
	--> print("tonumber(activity.activity_Info[_index].activityInfo_isReward)===",tonumber(activity.activity_Info[_index].activityInfo_isReward))
	if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1	then--DOTO	明明满足条件了。
		Image_received:setVisible(true)
		GetButton:setVisible(false)
	end
end

function SmActivityRecruitShipCell:updateGetRewardEnd( _index )
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7)
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[self.activityType]
	
	local Image_received = ccui.Helper:seekWidgetByName(root, "Image_received")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_receive")
	--> print("tonumber(activity.activity_Info[_index].activityInfo_isReward)===",tonumber(activity.activity_Info[_index].activityInfo_isReward))
	-- if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1	then--DOTO	明明满足条件了。
		Image_received:setVisible(true)
		GetButton:setVisible(false)
	-- end
end

function SmActivityRecruitShipCell:getPropIconCell(mid)
    app.load("client.cells.prop.model_prop_icon_cell")
    local iconCell = ModelPropIconCell:createCell()
    local config = iconCell:createConfig(mid, 1, true, 1, 13)
    config.isDebris = true
    iconCell:init(config)
    return iconCell
end

function SmActivityRecruitShipCell:onUpdateDraw()
	local root = self.roots[1]
	local Image_received_0 = ccui.Helper:seekWidgetByName(root, "Image_received_0")
	Image_received_0:setVisible(true)
	local activity = _ED.active_activity[self.activityType]
	local titleListText = ccui.Helper:seekWidgetByName(root, "Text_11")
	titleListText:setString("")
	titleListText:removeAllChildren(true)
	local _richText1 = ccui.RichText:create()
    _richText1:ignoreContentAdaptWithSize(false)

    local richTextWidth = titleListText:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = titleListText:getFontSize() * 6
    end
			    
    _richText1:setContentSize(cc.size(richTextWidth, 0))
    _richText1:setAnchorPoint(cc.p(0, 0))
    local char_str = self.example.activityInfo_name

    -- FURY: `activityInfo_name` lo compone el servidor con el tercer campo del
    -- `param` del catalogo (migracion 1140, '19,291,Super-Android-17'), que va
    -- en INGLES y con guiones porque el sobre legado se parte por espacios
    -- (limited_event_tabs.erl:166-176). El servidor NO sabe en que idioma juega
    -- el cliente -la sesion no lo recibe nunca- asi que el nombre localizado
    -- tiene que salir de aqui. Y sale sin inventar nada: el PRIMER campo de
    -- `activityInfo_need_day` es el molde del heroe -el mismo que esta celda
    -- pinta como icono en :233- y la cadena ship_mould -> ship_evo_mould ->
    -- word_mould da su nombre en el paquete de idioma cargado. Es la misma
    -- cadena que ya usan veinte pantallas del cliente
    -- (ActivityExchangePropList.lua:105-110, CombinationCardHandle.lua:111-122).
    local _mouldId = zstring.tonumber(zstring.split(self.example.activityInfo_need_day, ",")[1])
    if _mouldId > 0 then
        local _evoImage = dms.string(dms["ship_mould"], _mouldId, ship_mould.fitSkillTwo)
        if _evoImage ~= nil and _evoImage ~= "" then
            local _evoInfo = zstring.split(_evoImage, ",")
            local _evoMouldId = _evoInfo[dms.int(dms["ship_mould"], _mouldId, ship_mould.captain_name)]
            local _nameMouldId = dms.int(dms["ship_evo_mould"], _evoMouldId, ship_evo_mould.name_index)
            local _wordInfo = dms.element(dms["word_mould"], _nameMouldId)
            if _wordInfo ~= nil and _wordInfo[3] ~= nil and _wordInfo[3] ~= "" then
                char_str = _wordInfo[3]
            end
        end
    end

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	color_Type_1 = cc.c3b(71, 71, 71)
    	color_Type_2 = cc.c3b(71, 71, 71)
    else
    	color_Type_1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    	color_Type_2 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    end
    
    local rt, count, text = draw.richTextCollectionMethod(_richText1, 
    char_str, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    titleListText:getFontName(), 
    titleListText:getFontSize(),
    chat_rich_text_color)
    _richText1:setPositionX((_richText1:getPositionX() - _richText1:getContentSize().width / 2) + (titleListText:getContentSize().width-_richText1:getContentSize().width)/2)
    local rsize = _richText1:getContentSize()
    _richText1:setPositionY(titleListText:getContentSize().height)
    titleListText:addChild(_richText1)
	
	local Panel_reward_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_1")
	Panel_reward_1:removeAllChildren(true)
	local selectInfo = activity.activity_Info[self.index].activityInfo_reward_select
	if tonumber(activity.activity_Info[self.index].activityInfo_silver) > 0 then--可领取银币数量
		local cell = ResourcesIconCell:createCell()
        cell:init(1, tonumber(activity.activity_Info[self.index].activityInfo_silver), -1,nil,nil,true,true)
        Panel_reward_1:addChild(cell)
	end
	local shipIds = zstring.split(self.example.activityInfo_need_day,",")
	local shipId = tonumber(shipIds[1])
	self.trace_id = tonumber(shipIds[2])
	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")
	Panel_digimon_icon:removeAllChildren(true)
    -- 类型、ID、数量、星级
    local cell = ResourcesIconCell:createCell()
    cell:init(13, 0, shipId,nil,nil,true,true,1)
    Panel_digimon_icon:addChild(cell)
    local isComplete = false
    local other_info = zstring.split(activity.activity_params, "|")
    local activity_params = other_info[1]
    if activity_params == "" then
    else
		local getShipIds = zstring.split(activity_params, ",")
		for i , v in pairs (getShipIds) do
			if tonumber(v) == shipId then
				isComplete = true
				break
			end
		end
	end
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_receive")
	local Image_received = ccui.Helper:seekWidgetByName(root, "Image_received")
	local Button_zhaomu = ccui.Helper:seekWidgetByName(root, "Button_zhaomu")
	Button_zhaomu:setVisible(false)
	GetButton:setVisible(false)
	Image_received:setVisible(false)
	if isComplete == false then
		self.rewardState = 0
		Button_zhaomu:setVisible(true)
	elseif tonumber(self.example.activityInfo_isReward) == 0 then
		self.rewardState = 1
		GetButton:setVisible(true)
	else
		self.rewardState = 2
		Image_received:setVisible(true)
	end
end

function SmActivityRecruitShipCell:onEnterTransitionFinish()

end

function SmActivityRecruitShipCell:onInit()
	local root = cacher.createUIRef("activity/wonderful/landed_gifts_list_zhaomu.csb", "root")
	-- local csbSmActivityRecruitShipCell = csb.createNode("activity/wonderful/landed_gifts_list_zhaomu.csb")
 --    local root = csbSmActivityRecruitShipCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.AccumlateConsumption)
	
	self:clearUIInfo()
	self:onUpdateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
		{
			terminal_name = "sm_activity_recruit_ship_reward", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,			
			isPressedActionEnabled = true
		},
		nil,0)
	--招募
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhaomu"), nil, 
		{
			terminal_name = "sm_activity_recruit_ship_to_get", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,			
			isPressedActionEnabled = true
		},
		nil,0)
end

function SmActivityRecruitShipCell:clearUIInfo( ... )
    local root = self.roots[1]
	local ListView_011_2_0 = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
	local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	local Button_12_4 = ccui.Helper:seekWidgetByName(root, "Button_12_4")
	local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")

	local Button_zhaomu = ccui.Helper:seekWidgetByName(root, "Button_zhaomu")
	local Button_receive = ccui.Helper:seekWidgetByName(root, "Button_receive")
	local Image_received = ccui.Helper:seekWidgetByName(root, "Image_received")
	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")
	local Image_received_0 = ccui.Helper:seekWidgetByName(root, "Image_received_0")
	local Panel_reward_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_1")
	local Panel_land_list = ccui.Helper:seekWidgetByName(root, "Panel_land_list")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
	else
		Panel_land_list = ccui.Helper:seekWidgetByName(root, "Panel_Exchange")
	end
	local zhuangbei_jiantou_1_0 = Panel_land_list:getChildByName("zhuangbei_jiantou_1_0")
	local zhuangbei_jiantou_1 = Panel_land_list:getChildByName("zhuangbei_jiantou_1")
	if ListView_011_2_0 ~= nil then
		ListView_011_2_0:removeAllItems()
		Text_11:setString("")
		Text_11:removeAllChildren(true)
		Text_13:setString("")
		Button_12_4:setBright(true)
		Button_12_4:setTouchEnabled(true)
		Button_12_4:setVisible(false)
		Panel_reward_2:removeAllChildren(true)
		Button_zhaomu:setVisible(false)
		Button_receive:setVisible(false)
		Image_received:setVisible(false)
		Panel_digimon_icon:removeAllChildren(true)
		Image_received_0:setVisible(false)
		Panel_reward_1:removeAllChildren(true)
		zhuangbei_jiantou_1_0:setVisible(false)
		zhuangbei_jiantou_1:setVisible(false)
	end
end

function SmActivityRecruitShipCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/landed_gifts_list_zhaomu.csb", self.roots[1])
end

function SmActivityRecruitShipCell:init(example,index,activityType)
	self.example = example
	self.index = index
	self.activityType = activityType
	self:onInit()
end

function SmActivityRecruitShipCell:createCell()
	local cell = SmActivityRecruitShipCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end