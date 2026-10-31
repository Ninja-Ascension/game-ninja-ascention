----------------------------------------------------------------------------------------------------
-- 说明：免战牌使用界面
-------------------------------------------------------------------------------------------------------
PlunderUseProp = class("PlunderUsePropClass", Window)

function PlunderUseProp:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	app.load("client.cells.prop.model_prop_icon_cell")
	app.load("client.utils.ConfirmTip")
	local function init_plunder_use_prop_terminal()
		local plunder_use_prop_close_terminal = {
            _name = "plunder_use_prop_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 使用和购买 都调这个,只是更新数量
		local prop_buy_prompt_use_info_to_plunder_use_prop_terminal = {
            _name = "prop_buy_prompt_use_info_to_plunder_use_prop",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:changeData(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(prop_buy_prompt_use_info_to_plunder_use_prop_terminal)
		state_machine.add(plunder_use_prop_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_plunder_use_prop_terminal()
end




-- 返回格式化时间,参数是秒
function PlunderUseProp:formatTime (second)
	local timeTabel = {}
	local day = 0
	local hour = math.floor(tonumber(second)/3600)
	local minute = math.floor((tonumber(second)%3600)/60)
	local second = math.ceil(tonumber(second)%60)
	if second == 60 then
		second = 0
		minute = minute + 1
	end
	if minute == 60 then
		minute = 0
		hour = hour + 1
	end
	
	if hour < 10 then
		hour = "0"..hour
	end
	
	if minute < 10 then
		minute = "0"..minute
	end
	
	if second < 10 then
		second = "0"..second
	end
	local str = hour..":"..minute..":"..second
	return str
end

function PlunderUseProp:showConfirmTip(n)
	if n == 0 then
		-- yes
		self:useProp()
	else
		-- no
	end
end

function PlunderUseProp:checkupUse(item_mouldid)
	
	self._use_item_mouldid = item_mouldid
	
	local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	local bigAvoidTemplateId =  tonumber(config[12])
	local smallAvoidTemplateId =  tonumber(config[11])
	if smallAvoidTemplateId == tonumber(item_mouldid) or bigAvoidTemplateId == tonumber(item_mouldid) then
		local timer = getAvoidFightTime()
		if timer > 0 then
			local tip = ConfirmTip:new()
			tip:init(self, self.showConfirmTip, string.format(tipStringInfo_plunder[8], self:formatTime(timer/1000)))
			fwin:open(tip,fwin._dialog)
			return
		end
	end

	self:showConfirmTip(0)
end

function PlunderUseProp:useProp(item_mouldid)

	item_mouldid = self._use_item_mouldid
	
	 local function responseUsePropCallback(response)
		 if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
			-- 根据不同使用物品的提示不同
			local propName = dms.string(dms["prop_mould"],tonumber(response.node),prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        propName = setThePropsIcon(tonumber(response.node))[2]
			end
			local str = string.format(tipStringInfo_prop_buy_tip[3], propName)
		
			local propremark = dms.string(dms["prop_mould"],tonumber(response.node),prop_mould.remarks)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				propremark = drawPropsDescription(tonumber(response.node))
			end
			TipDlg.drawTextDailog(str..propremark)
			--发出消息使用了东西了.
			state_machine.excute("prop_buy_prompt_use_info_to_plunder", 0, {mould_id = zstring.tonumber(response.node), count = 1})
			
			self:changeData({mould_id = zstring.tonumber(response.node), count = 1})
			
		end
	end

	local _count = 1
	local prop = fundPropWidthId(item_mouldid)
	local _prop_id = prop.user_prop_id
	
	protocol_command.prop_use.param_list = _prop_id.."\r\n" .. _count
	NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, item_mouldid, responseUsePropCallback,false, nil)

end


function PlunderUseProp:getIconCell()
	local cell = ModelPropIconCell:createCell()
	return cell
end

function PlunderUseProp:getIconCellTouchEvent(iconCell)
	self:onIconCellTouchEvent(iconCell)
end

function PlunderUseProp:onIconCellTouchEvent(iconCell)

	local config = iconCell:getConfig()
	local item_mouldid = tonumber(config.mouldId)

	if nil == item_mouldid then
		return
	end
	
	-- 判断数量
	local itemCount = tonumber(getPropAllCountByMouldId(item_mouldid))
	
	--print("itemCount----------",itemCount)
	
	if itemCount > 0 then
		-- --发起使用
		self:checkupUse(item_mouldid)
	else
		-- --提示购买
		app.load("client.cells.prop.prop_buy_prompt")
		local win = PropBuyPrompt:new()
		win:init(item_mouldid)
		fwin:open(win, fwin._view)
	end
end

function PlunderUseProp:changeData(params)
	--检查道具模板id
	local params_id = params.mould_id
	
	if zstring.tonumber(self.smallAvoidTemplateId) == params_id then
		local smallCount = getPropAllCountByMouldId(self.smallAvoidTemplateId) 
		local config = self.smallAvoidCell:getConfig()
		config.count = smallCount
		self.smallAvoidCell:updateConfig(config)
	elseif zstring.tonumber(self.bigAvoidTemplateId) == params_id then
		local bigCount = getPropAllCountByMouldId(self.bigAvoidTemplateId) 
		local config = self.bigAvoidCell:getConfig()
		config.count = bigCount
		self.bigAvoidCell:updateConfig(config)
	end
end

function PlunderUseProp:onUpdateDraw()
	local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	-- 11 小免
	local smallAvoidTemplateId = tonumber(config[11])
	self.smallAvoidTemplateId = smallAvoidTemplateId
	-- 12 大免
	local bigAvoidTemplateId = tonumber(config[12])
	self.bigAvoidTemplateId = bigAvoidTemplateId
	
	-- 时间取第24个 好感度/熟练度 (时间单位为小时)
	local smallAvoidTime = dms.string(dms["prop_mould"], smallAvoidTemplateId, prop_mould.use_of_experience)
	local bigAvoidTime = dms.string(dms["prop_mould"], bigAvoidTemplateId, prop_mould.use_of_experience)
	
	-- 获取当前背包中免战令数量
	local smallCount = getPropAllCountByMouldId(smallAvoidTemplateId) 
	local bigCount = getPropAllCountByMouldId(bigAvoidTemplateId) 
	
	--创建 icons
	local smallAvoidCell = self:getIconCell()
	self.smallAvoidCell = smallAvoidCell
	local smallConfig = smallAvoidCell:createConfig(smallAvoidTemplateId, smallCount, false)
	smallAvoidCell:init(smallConfig, self.getIconCellTouchEvent ,self)
	self.smallPanel:removeAllChildren(true)
	self.smallPanel:addChild(smallAvoidCell)
	self.smallText:setString(string.format(tipStringInfo_plunder[1], smallAvoidTime))

	local bigAvoidCell = self:getIconCell()
	self.bigAvoidCell = bigAvoidCell
	local bigConfig = bigAvoidCell:createConfig(bigAvoidTemplateId, bigCount, false)
	bigAvoidCell:init(bigConfig, self.getIconCellTouchEvent ,self)
	self.bigPanel:removeAllChildren(true)
	self.bigPanel:addChild(bigAvoidCell)
	self.bigText:setString(string.format(tipStringInfo_plunder[1], bigAvoidTime))
end

function PlunderUseProp:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/Snatch/snatch_war_free.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self.smallPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_5")
	
	self.smallText = ccui.Helper:seekWidgetByName(self.roots[1], "Label_consume_0")
	
	self.bigPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4")

	self.bigText = ccui.Helper:seekWidgetByName(self.roots[1], "Label_consume")

	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_colose"), nil, 
	{
		terminal_name = "plunder_use_prop_close", 
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 2)		
end

function PlunderUseProp:onExit()
	state_machine.remove("plunder_use_prop_close")
	state_machine.remove("prop_buy_prompt_use_info_to_plunder_use_prop")
	
end

function PlunderUseProp:init(propMould)
	
end