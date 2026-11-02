--------------------------------------------------------------------------------------------------------------
--  说明：公会发红包的控件
--------------------------------------------------------------------------------------------------------------
unionHairRedEnvelopesListCell = class("unionHairRedEnvelopesListCellClass", Window)
unionHairRedEnvelopesListCell.__size = nil
function unionHairRedEnvelopesListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	app.load("client.l_digital.cells.union.union_logo_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.activity.adventure.AdventureTaskWindow")
	 -- Initialize union rank list cell state machine.
    local function init_union_hair_red_envelopes_list_cell_terminal()
    	-- 发红包
        local union_hair_red_envelopes_list_cell_hair_terminal = {
            _name = "union_hair_red_envelopes_list_cell_hair",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        	app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(25)
							fwin:open(getRewardWnd, fwin._ui)
                        	TipDlg.drawTextDailog(_new_interface_text[76])
                        	state_machine.excute("sm_union_hair_red_envelopes_update_draw", 0, "")
                        end 
                        state_machine.excute("adventure_task_window_onUpdate_data", 0, nil)
                    end
                end
                protocol_command.union_red_packet_send.param_list = (tonumber(cell.example[2])-1).."\r\n"..cell.example[1]
                NetworkManager:register(protocol_command.union_red_packet_send.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_hair_red_envelopes_list_cell_hair_terminal)

        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_hair_red_envelopes_list_cell_terminal()

end

function unionHairRedEnvelopesListCell:updateDraw()
	local root = self.roots[1]
	
	--图标
	local Panel_hb_icon = ccui.Helper:seekWidgetByName(root, "Panel_hb_icon")
	Panel_hb_icon:removeBackGroundImage()
	local prop_id = tonumber(self.example[8])
	local prop_pic = dms.int(dms["prop_mould"], prop_id, prop_mould.pic_index)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		prop_pic = setThePropsIcon(prop_id)[1]
	end
    Panel_hb_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", prop_pic))
	--名称
	local Text_hb_name = ccui.Helper:seekWidgetByName(root, "Text_hb_name")
	local names = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		names = setThePropsIcon(prop_id)[2]
	end
	Text_hb_name:setString(names)
	local prop_quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)
	Text_hb_name:setColor(cc.c3b(color_Type[prop_quality+1][1], color_Type[prop_quality+1][2], color_Type[prop_quality+1][3]))

	--需要的宝石
	local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
	Text_zuanshi_n:setString(self.example[4])
	--发红包奖励
	local rewardData = zstring.split(self.example[5],"|")
	for i=1, 2 do
		ccui.Helper:seekWidgetByName(root, "Panel_props_icon_"..i):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_props_n_"..i):setVisible(false)
	end
	for i=1, #rewardData do
		local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_"..i)
		Panel_props_icon:removeAllChildren(true)
		local Text_props_n = ccui.Helper:seekWidgetByName(root, "Text_props_n_"..i)
		Panel_props_icon:setVisible(true)
		Text_props_n:setVisible(true)
		local reward = zstring.split(rewardData[i],",")
		if tonumber(reward[1]) == 1 then
            --钱
            local cell = ResourcesIconCell:createCell()
            cell:init(reward[1], 0,-1,nil,nil,true,true)
            Panel_props_icon:addChild(cell)
        end
        if tonumber(reward[1]) == 28 then
            --工会币
            local cell = ResourcesIconCell:createCell()
            cell:init(reward[1], 0,-1,true,true)
            Panel_props_icon:addChild(cell)
        end
        if tonumber(reward[1]) == 6 then
            --道具
            local cell = ResourcesIconCell:createCell()
            cell:init(reward[1], 0, reward[2],nil,nil,true,true)
            Panel_props_icon:addChild(cell)
        end
        Text_props_n:setString(reward[3])
	end

	--红包总额
	local Panel_props_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_3")
	Panel_props_icon_3:removeAllChildren(true)
	local Text_props_n_3 = ccui.Helper:seekWidgetByName(root, "Text_props_n_3")
	local redData = zstring.split(self.example[6],",")
	local redcell = ResourcesIconCell:createCell()
    redcell:init(redData[1], 0, redData[2],nil,nil,true,true)
    Panel_props_icon_3:addChild(redcell)
    Text_props_n_3:setString(redData[3])


	for i=1, 18 do
		local Image_vip = ccui.Helper:seekWidgetByName(root, "Image_vip_"..i)
		if Image_vip ~= nil then
			Image_vip:setVisible(false)
			if i == tonumber(self.example[3]) then
				Image_vip:setVisible(true)
			end
		end
	end
end

function unionHairRedEnvelopesListCell:onInit()

	local csbunionHairRedEnvelopesListCell= csb.createNode("legion/sm_legion_red_packet_distribute_list.csb")
    local root = csbunionHairRedEnvelopesListCell:getChildByName("root")
    table.insert(self.roots, root)
	
	
	 local action = csb.createTimeline("legion/sm_legion_red_packet_distribute_list.csb")
	 root:runAction(action)
	 
    self:addChild(csbunionHairRedEnvelopesListCell)
	if unionHairRedEnvelopesListCell.__size == nil then
		unionHairRedEnvelopesListCell.__size = root:getChildByName("Panel_247"):getContentSize()
	end	

	self:updateDraw()

	-- 发红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fhb"), nil, 
    {
        terminal_name = "union_hair_red_envelopes_list_cell_hair",
        terminal_state = 0,
        cell = self,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)
end

function unionHairRedEnvelopesListCell:onEnterTransitionFinish()

end

function unionHairRedEnvelopesListCell:init(example,index)
	self.example = example
	self.index = index
	if index < 5 then
		self:onInit()
	end
	self:setContentSize(unionHairRedEnvelopesListCell.__size)
	-- self:onInit()
	return self
end

function unionHairRedEnvelopesListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionHairRedEnvelopesListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_red_packet_distribute_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function unionHairRedEnvelopesListCell:onExit()
	cacher.freeRef("legion/sm_legion_red_packet_distribute_list.csb", self.roots[1])
end

function unionHairRedEnvelopesListCell:createCell()
	local cell = unionHairRedEnvelopesListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
