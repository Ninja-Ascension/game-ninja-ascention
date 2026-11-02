----------------------------------------------------------------------------------------------------
-- 说明：星座数码兽控件
----------------------------------------------------------------------------------------------------
ConstellationShipActivationCell = class("ConstellationShipActivationCellClass", Window)

function ConstellationShipActivationCell:ctor()
    self.super:ctor()
    self.roots = {}
	local function init_constellation_ship_activation_cell_terminal()
		local constellation_ship_buy_terminal = {
            _name = "constellation_ship_buy",
            _init = function (terminal) 
                app.load("client.l_digital.cultivate.constellation.ConstellationShipInfo")
                app.load("client.l_digital.cultivate.constellation.SmCultivateConstellationWindow")
                app.load("client.l_digital.cultivate.constellation.ConstellationShipActivation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local _type = params._datas._type

                local buy_param = zstring.split(cell.constellation_group_info[constellation_group.buy_param], ",")
                local need_type = tonumber(buy_param[1])
                local need_money = tonumber(buy_param[3])
                if _type == 1 and need_type == 1 and need_money > tonumber(_ED.user_info.user_silver) then
                    app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                    local fightWindow = HeroPatchInformationPageGetWay:new()
                    fightWindow:init(0,6)
                    fwin:open(fightWindow, fwin._windows)
                    return
                end
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node and response.node.roots and response.node.roots[1] then
                            TipDlg.drawTextDailog(tipStringInfo_constellation_tips[tonumber(_type) + 5])
                            if fwin:find("SmCultivateConstellationWindowClass") then
                                state_machine.excute("sm_cultivate_constellat_update_choose_state", 0, response.node.constellation_mould_id)
                            end
                            state_machine.excute("constellation_ship_update", 0, response.node.cell)

                            if fwin:find("ConstellationShipInfoClass") then
                                state_machine.excute("constellat_ship_info_update", 0, "")
                            end
                            if fwin:find("ConstellationShipActivationClass") then
                                state_machine.excute("constellat_ship_activation_update", 0, "")
                            end
                        end
                        -- Cartel de "+N poder", igual que el artefacto y la aleacion.
                        -- El S2C 128 de la respuesta ya trae el total nuevo; sin esta
                        -- llamada nadie lo comparaba con el de antes y no salia nada.
                        smFightingChange()
                    end
                end
                if _type == 1 then
                    protocol_command.constellation_buy.param_list = cell.constellation_mould_id .. "\r\n" .. tonumber(cell.index) - 1 .. "\r\n" .. cell.constellation_group_id
                    NetworkManager:register(protocol_command.constellation_buy.code, nil, nil, nil, cell, responseGetServerListCallback, false, nil)
                elseif _type == 2 then
                    protocol_command.constellation_exchange.param_list = cell.constellation_mould_id .. "\r\n" .. tonumber(cell.index) - 1 .. "\r\n" .. cell.constellation_group_id
                    NetworkManager:register(protocol_command.constellation_exchange.code, nil, nil, nil, cell, responseGetServerListCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(constellation_ship_buy_terminal)
        state_machine.init()
	end
	init_constellation_ship_activation_cell_terminal()
end

function ConstellationShipActivationCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_xz_box_quality = ccui.Helper:seekWidgetByName(root,"Panel_xz_hero_q_box")
    local ship_icon = ccui.Helper:seekWidgetByName(root,"Panel_xz_hero_head")
    local Panel_xz_lv_text = ccui.Helper:seekWidgetByName(root,"Panel_xz_lv_text")
    local Text_xz_act_jinbi_n = ccui.Helper:seekWidgetByName(root,"Text_xz_act_jinbi_n")
    local Image_icon_gold = ccui.Helper:seekWidgetByName(root,"Image_icon_gold")
    local Image_icon_gem = ccui.Helper:seekWidgetByName(root,"Image_icon_gem")
    local Panel_xz_lock = ccui.Helper:seekWidgetByName(root,"Panel_xz_lock")
    local Text_xz_lock_role_name = ccui.Helper:seekWidgetByName(root,"Text_xz_lock_role_name")

    local Text_xz_gj_n = ccui.Helper:seekWidgetByName(root,"Text_xz_gj_n")
    local Text_xz_fy_n = ccui.Helper:seekWidgetByName(root,"Text_xz_fy_n")
    local Text_xz_sm_n = ccui.Helper:seekWidgetByName(root,"Text_xz_sm_n")

    local Button_xz_act = ccui.Helper:seekWidgetByName(root,"Button_xz_act")
    local Image_xz_lv_use = ccui.Helper:seekWidgetByName(root,"Image_xz_lv_use")
    local Button_xz_change = ccui.Helper:seekWidgetByName(root,"Button_xz_change")

    Text_xz_act_jinbi_n:setString("")
    ship_icon:removeBackGroundImage()
    Panel_xz_lv_text:removeBackGroundImage()
    Button_xz_act:setVisible(false)
    Image_xz_lv_use:setVisible(false)
    Button_xz_change:setVisible(false)
    Button_xz_act:setBright(false)
    Button_xz_act:setTouchEnabled(false)
    Image_icon_gold:setVisible(false)
    Image_icon_gem:setVisible(false)
    Text_xz_act_jinbi_n:setVisible(false)
    Panel_xz_lock:setVisible(false)



    --进化形象
    local evo_image = dms.string(dms["ship_mould"], self.ship_template_id, ship_mould.fitSkillTwo)
    local initial_ship = dms.string(dms["ship_mould"], self.ship_template_id, ship_mould.captain_name)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local quality = self.constellation_group_info[constellation_group.level_id]
    local level_type = (tonumber(self.constellation_group_info[constellation_group.level_type]))
    local evo_mould_id = evo_info[zstring.tonumber(initial_ship)]
    if self.ship then
        evo_mould_id = smGetSkinEvoIdChange(self.ship)
    end
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local hero_name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

    Panel_xz_lv_text:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/%d.png", level_type+25))
    Panel_xz_box_quality:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/txk_s_%d.png", quality))
    ship_icon:setBackGroundImage(string.format("images/ui/pve_sn/props_%d.png", picIndex))

    local buy_param = zstring.split(self.constellation_group_info[constellation_group.buy_param], ",")

    Text_xz_act_jinbi_n:setString(buy_param[3])
    Text_xz_lock_role_name:setString(hero_name)

    local add_additional = zstring.splits(self.constellation_group_info[constellation_group.add_additional], "|", ",")
    Text_xz_gj_n:setString(add_additional[1][2])
    Text_xz_fy_n:setString(add_additional[2][2])
    Text_xz_sm_n:setString(add_additional[3][2])

    -- 激活、更换、使用按钮的显示
    local need_have_ship = tonumber(self.constellation_group_info[constellation_group.lock])
    
    if not self.ship and need_have_ship == 1 then
        Button_xz_act:setVisible(true)
        Image_xz_lv_use:setVisible(false)
        Button_xz_change:setVisible(false)
        Button_xz_act:setBright(false)
        Button_xz_act:setTouchEnabled(false)
        Image_icon_gold:setVisible(tonumber(buy_param[1]) == 1)
        Image_icon_gem:setVisible(tonumber(buy_param[1]) == 2)
        Text_xz_act_jinbi_n:setVisible(true)
        Panel_xz_lock:setVisible(true)
    else
        Button_xz_act:setBright(true)
        Button_xz_act:setTouchEnabled(true)
        Panel_xz_lock:setVisible(false)
        if not self.is_purchased_ship then
            Button_xz_act:setVisible(true)
            Image_xz_lv_use:setVisible(false)
            Button_xz_change:setVisible(false)
            Image_icon_gold:setVisible(tonumber(buy_param[1]) == 1)
            Image_icon_gem:setVisible(tonumber(buy_param[1]) == 2)
            Text_xz_act_jinbi_n:setVisible(true)
        else
            Image_icon_gold:setVisible(false)
            Image_icon_gem:setVisible(false)
            Text_xz_act_jinbi_n:setVisible(false)
            if not self.is_used_ship then
                Button_xz_act:setVisible(false)
                Image_xz_lv_use:setVisible(false)
                Button_xz_change:setVisible(true)
            else
                Button_xz_act:setVisible(false)
                Image_xz_lv_use:setVisible(true)
                Button_xz_change:setVisible(false)
            end
        end
    end
end

function ConstellationShipActivationCell:onInit()
    local csbDailyTaskListCell= csb.createNode("cultivate/constellation_star_activation_cell.csb")
    local root = csbDailyTaskListCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

    self:initData()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_xz_act"), nil, 
    {
        terminal_name = "constellation_ship_buy", 
        terminal_state = 0,
        _cell = self, 
        _type = 1,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_xz_change"), nil, 
    {
        terminal_name = "constellation_ship_buy", 
        terminal_state = 0, 
        _cell = self, 
        _type = 2,
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function ConstellationShipActivationCell:onEnterTransitionFinish()
end

function ConstellationShipActivationCell:onExit()
end

function ConstellationShipActivationCell:init(params)
    if params then
        self.constellation_group_id = params[1]
        self.index = params[2]
        self.constellation_mould_id = params[3] .. ""
        self.cell = params[4]
    else
        return
    end
    -- print("self.is_purchased_ship========================", self.is_purchased_ship, self.is_used_ship)
    self:onInit()
end

function ConstellationShipActivationCell:initData()
    self.constellation_group_info = dms.element(dms["constellation_group"], self.constellation_group_id)
    local ship_ids = dms.string(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_ship_id)
    self.ship_template_id = zstring.split(ship_ids, ",")[tonumber(self.index)]

    self.ship = nil
    for i,ship in pairs(_ED.user_ship) do
        if tonumber(ship.ship_template_id) == tonumber(self.ship_template_id) then
            self.ship = ship
        end
    end

    local purchased_ship_infos = _ED.constellation_info.hba
    local used_ship_infos = _ED.constellation_info.uc

    local is_purchased = false
    local current_purchased_ship_infos = purchased_ship_infos[self.constellation_mould_id]
    -- print("purchased_ships================", current_purchased_ship_infos, current_purchased_ship_infos[self.index -1], current_purchased_ship_infos[self.index -1][(index - 1)])
    if not current_purchased_ship_infos then
        is_purchased = false
    else
        local purchased_ships = current_purchased_ship_infos[tostring(tonumber(self.index) - 1)]
        if not  purchased_ships then
            is_purchased = false
        else
            if not purchased_ships then
                is_purchased = false
            else
                for k,v in pairs(purchased_ships) do
                    if zstring.tonumber(v) == zstring.tonumber(self.constellation_group_id) then
                        is_purchased = true
                        break
                    else
                        is_purchased = false
                    end
                end
            end
        end
    end
    self.is_purchased_ship = is_purchased


    local is_used = false
    local current_used_ship_infos = used_ship_infos[self.constellation_mould_id]
    -- print("v.id================================", v[constellation_group.id], current_used_ship_infos, current_used_ship_infos[self.index - 1])
    if not current_used_ship_infos then
        is_used = false
    else
        local used_ship_id = current_used_ship_infos[tostring(tonumber(self.index) - 1)]
        if not used_ship_id or zstring.tonumber(used_ship_id) ~= zstring.tonumber(self.constellation_group_id) then
            is_used = false
        else
            is_used = true
        end
    end

    self.is_used_ship = is_used
end

function ConstellationShipActivationCell:createCell()
	local cell = ConstellationShipActivationCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

