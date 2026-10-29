-- ----------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------

CaptureResourceRewardListCell = class("CaptureResourceRewardListCellClass", Window)
CaptureResourceRewardListCell.__size = nil
function CaptureResourceRewardListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.reward_data = nil
end



function CaptureResourceRewardListCell:onEnterTransitionFinish()

end

function CaptureResourceRewardListCell:onInit()

	local root = cacher.createUIRef("secret_society/secret_award_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if CaptureResourceRewardListCell.__size == nil then
	 	local Panel_269 = ccui.Helper:seekWidgetByName(root, "Panel_269")
		local MySize = Panel_269:getContentSize()
	 	CaptureResourceRewardListCell.__size = MySize
	end
	-- local minrank = dms.atoi(self.reward_data,hold_reward_param.hold_order_begin)
	-- local maxrank = dms.atoi(self.reward_data,hold_reward_param.hold_order_end)
	-- local Button_523 = ccui.Helper:seekWidgetByName(root, "Button_523")
	-- fwin:addTouchEventListener(Button_523,nil, 
	-- {
	-- 	terminal_name = "capture_resource_get_reward", 
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true,
	-- 	btn_cell = Button_523
	-- }
	-- ,nil, 0)

	-- local myrank = tonumber(_ED.capture.my_rank)
	-- -- print("===============",minrank,maxrank)
	-- if myrank >= minrank and myrank <= maxrank and tonumber(_ED.capture.rank_reward_state) ~= 1 then
	-- 	Button_523:setVisible(true)
	-- else
	-- 	Button_523:setVisible(false)
	-- end
	self:updateDraw()
end

function CaptureResourceRewardListCell:updateDraw()
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")  
	local root = self.roots[1]
	local Panel_mingci = ccui.Helper:seekWidgetByName(root, "Panel_mingci")
	Panel_mingci:removeBackGroundImage()
	Panel_mingci:setBackGroundImage("images/ui/play/secret_society/paihang_"..self.index..".png")

	local ListView_112 = ccui.Helper:seekWidgetByName(root, "ListView_112")
	ListView_112:removeAllItems()

	local reward_silver = dms.atoi(self.reward_data,hold_reward_param.hold_reward_silver)
	if reward_silver ~= -1 then
        local cell = propMoneyIcon:createCell()
        cell:init("1",reward_silver)
        ListView_112:addChild(cell)  
	end
	local reward_gold = dms.atoi(self.reward_data,hold_reward_param.hold_reward_gold)
	if reward_gold ~= -1 then
        local cell = propMoneyIcon:createCell()
        cell:init("2",reward_gold)
        ListView_112:addChild(cell)  	
	end
	local reward_prop_1 = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop1)
	local reward_prop_2 = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop2)
	local reward_prop_3 = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop3)
	local reward_prop_4 = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop4)
	local reward_prop_5 = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop5)
	if reward_prop_1 ~= -1 then
		local number = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop_count1)
		local cell = PropIconCell:createCell()
		cell:init(35,reward_prop_1,number,false)
		ListView_112:addChild(cell)
	end

	if reward_prop_2 ~= -1 then
		local number = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop_count2)
		local cell = PropIconCell:createCell()
		cell:init(35,reward_prop_2,number,false)
		ListView_112:addChild(cell)
	end

	if reward_prop_3 ~= -1 then
		local number = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop_count3)
		local cell = PropIconCell:createCell()
		cell:init(35,reward_prop_3,number,false)
		ListView_112:addChild(cell)
	end

	if reward_prop_4 ~= -1 then
		local number = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop_count4)
		local cell = PropIconCell:createCell()
		cell:init(35,reward_prop_4,number,false)
		ListView_112:addChild(cell)
	end

	if reward_prop_5 ~= -1 then
		local number = dms.atoi(self.reward_data,hold_reward_param.hold_reward_prop_count5)
		local cell = PropIconCell:createCell()
		cell:init(35,reward_prop_5,number,false)
		ListView_112:addChild(cell)
	end
	ListView_112:requestRefreshView()
end

function CaptureResourceRewardListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CaptureResourceRewardListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("secret_society/secret_award_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function CaptureResourceRewardListCell:init(reward_data,index)
	self.reward_data = reward_data
	self.index = index
	if index ~= nil and index < 5 then
		self:onInit()
	end
	self:setContentSize(CaptureResourceRewardListCell.__size)
	return self
end

function CaptureResourceRewardListCell:createCell()
	local cell = CaptureResourceRewardListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function CaptureResourceRewardListCell:onExit()
	cacher.freeRef("secret_society/secret_award_list.csb", self.roots[1])
end

