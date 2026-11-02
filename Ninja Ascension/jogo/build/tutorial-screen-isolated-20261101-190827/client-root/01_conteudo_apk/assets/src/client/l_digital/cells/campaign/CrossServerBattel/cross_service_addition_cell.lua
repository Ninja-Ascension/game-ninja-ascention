----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战单元项
----------------------------------------------------------------------------------------------------
CrossServiceAdditionCell = class("CrossServiceAdditionCellClass", Window)
CrossServiceAdditionCell.__size = nil

function CrossServiceAdditionCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_cross_server_battel_cell_terminal()
	--使用按钮的点击
		local cross_server_battel_addition_inspire_terminal = {
            _name = "cross_server_battel_addition_inspire",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelAddition")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	local all_money = zstring.tonumber(_ED.cross_server_battel_mineral_num)

            	if cell.left_time <= 0 then
            		TipDlg.drawTextDailog(tipStringInfo_cross_server_battel_tips[27])
            		return
            	else
            		if tonumber(all_money) < tonumber(cell.consume[3]) then
	            		TipDlg.drawTextDailog(tipStringInfo_cross_server_battel_tips[7])
	            		return
	            	end
            	end

	            local function responseCrossServerBattelAdditionBuyCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node and response.node.roots[1] then
							TipDlg.drawTextDailog(tipStringInfo_cross_server_battel_tips[26])
							response.node:initDate()
							response.node:onUpdateDraw()
							state_machine.excute("cross_server_battel_addition_update",0,response.node.add_type)
						end
					end
				end
				protocol_command.cross_mine_user_feed.param_list = cell.id .. "\r\n" .. cell.add_type .. "\r\n" .. 2
				NetworkManager:register(protocol_command.cross_mine_user_feed.code, nil, nil, nil, cell, responseCrossServerBattelAdditionBuyCallback, false, nil)
   			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(cross_server_battel_addition_inspire_terminal)
        state_machine.init()
	end
	init_cross_server_battel_cell_terminal()
end


function CrossServiceAdditionCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_cross_add_exp_n = ccui.Helper:seekWidgetByName(root, "Text_cross_add_exp_n")
	local img_cost = ccui.Helper:seekWidgetByName(root, "Image_66_0")
	local Text_cross_add_gold_n = ccui.Helper:seekWidgetByName(root, "Text_cross_add_gold_n")
	local Text_cross_add_consume_inspire_n = ccui.Helper:seekWidgetByName(root, "Text_cross_add_consume_inspire_n")
	local Text_cross_add_time_n = ccui.Helper:seekWidgetByName(root, "Text_cross_add_time_n")
	local Button_cross_add_inspire = ccui.Helper:seekWidgetByName(root, "Button_cross_add_inspire")

	local cost_images = {
		[2] = "images/ui/icon/zuanshi.png",   		-- 钻石
		[2] = "images/ui/icon/jinbi.png",   		-- 金币
		[65] = "images/ui/text/cross_service/ico_kuang_s.png" -- 矿石
	}


	self.consume = zstring.split(dms.atos(self.add_info, cross_mine_war_encouraging_param.consume), ",")
	local resource = zstring.split(dms.atos(self.add_info, cross_mine_war_encouraging_param.resource), ",")
	local exp = dms.atoi(self.add_info, cross_mine_war_encouraging_param.exps)

	Text_cross_add_exp_n:setString("+" .. exp)
	img_cost:loadTexture(cost_images[tonumber(resource[1])])
	Text_cross_add_gold_n:setString("+" .. resource[3])
	Text_cross_add_consume_inspire_n:setString("-" .. self.consume[3])
	Text_cross_add_time_n:setString(self.left_time .. "/" .. self.times)
	local color = self.left_time <= 0 and cc.c3b(255,0,0) or cc.c3b(63,255,55)
	Text_cross_add_time_n:setColor(color)
	Button_cross_add_inspire:setTitleText(tipStringInfo_cross_server_battel_tips[self.id+1])
end

function CrossServiceAdditionCell:onInit()
    local root = cacher.createUIRef("campaign/cross_service/cross_service_addition_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_add_inspire"), nil, 
	{
		terminal_name = "cross_server_battel_addition_inspire", 
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true
	},
	nil, 2)

	self:onUpdateDraw()
	local panel_size = root:getContentSize()
	self:setContentSize(panel_size)
	if CrossServiceAdditionCell.__size == nil then
		CrossServiceAdditionCell.__size = panel_size
	end
end

function CrossServiceAdditionCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    root:setSwallowTouches(false)
    self:onInit()
end

function CrossServiceAdditionCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_service/cross_service_addition_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function CrossServiceAdditionCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_cross_add_exp_n = ccui.Helper:seekWidgetByName(root, "Text_cross_add_exp_n")
	local Text_cross_add_gold_n = ccui.Helper:seekWidgetByName(root, "Text_cross_add_gold_n")
	local Text_cross_add_time_n = ccui.Helper:seekWidgetByName(root, "Text_cross_add_time_n")
	local Text_cross_add_consume_inspire_n = ccui.Helper:seekWidgetByName(root, "Text_cross_add_consume_inspire_n")

	if Text_cross_add_exp_n ~= nil then
		Text_cross_add_exp_n:setString("")
	end
	if Text_cross_add_gold_n then
		Text_cross_add_gold_n:setString("")
	end
	if Text_cross_add_time_n then
		Text_cross_add_time_n:setString("")
	end
	if Text_cross_add_consume_inspire_n then
		Text_cross_add_consume_inspire_n:setString("")
	end
end

function CrossServiceAdditionCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_service/cross_service_addition_cell.csb", self.roots[1])
end

function CrossServiceAdditionCell:initDate()
	self.id = dms.atoi(self.add_info, cross_mine_war_encouraging_param.id)
	self.times = dms.atoi(self.add_info, cross_mine_war_encouraging_param.times)
	local current_info = _ED.cross_server_battel_addition_info.userOreBeastInfo
	if current_info then
		local left_times = self.add_type == 2 and current_info.buyCountForSelf or current_info.buyCountForServer
		self.left_time = self.times - tonumber(left_times[self.id .. ""])
	end
end

function CrossServiceAdditionCell:init(params)
	self.add_info = params[1]
	self.add_type = params[2]

	self:initDate()
	self:onInit()
	self:setContentSize(CrossServiceAdditionCell.__size)
end

function CrossServiceAdditionCell:createCell()
	local cell = CrossServiceAdditionCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


