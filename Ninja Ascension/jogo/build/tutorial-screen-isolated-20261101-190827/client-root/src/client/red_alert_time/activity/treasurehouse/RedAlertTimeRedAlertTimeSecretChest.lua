-----------------------------
--科威特秘密的2级界面
-----------------------------
RedAlertTimeRedAlertTimeSecretChest = class("RedAlertTimeRedAlertTimeSecretChestClass", Window)

local red_alert_time_red_alert_time_secret_chest_window_open_terminal = {
    _name = "red_alert_time_red_alert_time_secret_chest_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeRedAlertTimeSecretChestClass") then
			fwin:open(RedAlertTimeRedAlertTimeSecretChest:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_red_alert_time_secret_chest_window_close_terminal = {
    _name = "red_alert_time_red_alert_time_secret_chest_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeRedAlertTimeSecretChestClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_red_alert_time_secret_chest_window_open_terminal)
state_machine.add(red_alert_time_red_alert_time_secret_chest_window_close_terminal)
state_machine.init()

function RedAlertTimeRedAlertTimeSecretChest:ctor()
    self.super:ctor()
    self.roots = {}
    self._index = nil
    self._reworld_id = nil
    --load lua file

    -- Initialize red_alert_time_red_alert_time_secret_chest state machine.
    local function init_red_alert_time_red_alert_time_secret_chest_terminal()
      
	  
        state_machine.init()
    end
    
    -- call func init red_alert_time_red_alert_time_secret_chest state machine.
    init_red_alert_time_red_alert_time_secret_chest_terminal()
end


function RedAlertTimeRedAlertTimeSecretChest:onUpdateDraw()
    local root = self.roots[1]
	local reworld = zstring.split(dms.string(dms["scene_reward"], self._reworld_id, scene_reward.call_library_group),"|")
	local datas = zstring.split(reworld[self._index], ",")
	local _drawMonth = dms.searchs(dms["scene_reward_drop"], scene_reward_drop.library_group, tonumber(datas[1]))
	local m_reworld = zstring.split(_drawMonth[1][5],"|")
	for i=1,#m_reworld do
		local Panel_seek_treasure_equ_icon = ccui.Helper:seekWidgetByName(root,"Panel_seek_treasure_equ_icon_"..i)
		Panel_seek_treasure_equ_icon:removeAllChildren(true)
        Panel_seek_treasure_equ_icon:removeBackGroundImage()
		local datas = zstring.split(m_reworld[i], ",")
		if tonumber(datas[1]) == -1 then
			datas[1] = resource_prop_id[tonumber(datas[2])]
			datas[2] = 1
		end
		local prop_type = tonumber(datas[2])
		local show_type = 9
		if tonumber(datas[2]) == 13 then --坦克
			prop_type = 3
		elseif tonumber(datas[2]) == 6 then --道具	
			prop_type = 1
		elseif tonumber(datas[2]) == 7 then --配件	
			prop_type = 7
		else
			prop_type = 1
		end
		-- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
		local cell = nil
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), 0})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_type, tonumber(datas[1]), tonumber(prop_type), 0})
		end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setVisible(false)
		Panel_seek_treasure_equ_icon:addChild(cell)
		
		--名称+数量
		local Text_seek_treasure_equ_name = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_equ_name_"..i)
		Text_seek_treasure_equ_name:removeAllChildren(true)
		local _richText1 = ccui.RichText:create()
		_richText1:ignoreContentAdaptWithSize(false)
		local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
		local re1 =ccui.RichElementText:create(1, color,255, dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.prop_name), config_res.font.font_name,20)
		_richText1:pushBackElement(re1)
		local color2 = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
		local number = zstring.split(datas[3], "-")
		local re2 =ccui.RichElementText:create(1, color2,255, "*"..number[1], config_res.font.font_name,20)
		_richText1:pushBackElement(re2)
		_richText1:setContentSize(cc.size(Text_seek_treasure_equ_name:getContentSize().width,20))
		_richText1:setPositionX(Text_seek_treasure_equ_name:getContentSize().width/2)
		_richText1:setPositionY(Text_seek_treasure_equ_name:getContentSize().height/2)
		Text_seek_treasure_equ_name:addChild(_richText1)
		
		-- dms.int(dms["prop_mould"], tonumber(datas[1]), prop_mould.prop_name)
		--积分
		local Text_seek_treasure_equ_integral = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_equ_integral_"..i)
		Text_seek_treasure_equ_integral:removeAllChildren(true)
		local str = activity_str_tip[42]
		local _richText2 = ccui.RichText:create()
		_richText2:ignoreContentAdaptWithSize(false)
		local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
		local re3 =ccui.RichElementText:create(1, color,255, str, config_res.font.font_name,20)
		_richText2:pushBackElement(re3)
		local color2 = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
		local re4 =ccui.RichElementText:create(1, color2,255, dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.exchange_get_of_bounty) * tonumber(number[1]), config_res.font.font_name,20)
		_richText2:pushBackElement(re4)
		_richText2:setContentSize(cc.size(Text_seek_treasure_equ_integral:getContentSize().width,20))
		_richText2:setPositionX(Text_seek_treasure_equ_integral:getContentSize().width/2)
		_richText2:setPositionY(Text_seek_treasure_equ_integral:getContentSize().height/2)
		Text_seek_treasure_equ_integral:addChild(_richText2)
	end
end

function RedAlertTimeRedAlertTimeSecretChest:onEnterTransitionFinish()

end

function RedAlertTimeRedAlertTimeSecretChest:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_equipment_preview)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_seek_treasure_equipment_close"), nil, 
    {
        terminal_name = "red_alert_time_red_alert_time_secret_chest_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
	
	self:onUpdateDraw()
end

function RedAlertTimeRedAlertTimeSecretChest:init(params)
    self._index = tonumber(params[1])
    self._reworld_id = tonumber(params[2])
	self:onInit()
    return self
end

function RedAlertTimeRedAlertTimeSecretChest:onExit()
	
end
