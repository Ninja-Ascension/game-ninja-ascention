----------------------------------------------------------------------------------------------------
-- 说明：活动图标绘制
----------------------------------------------------------------------------------------------------
AdventureActivityIcon = class("AdventureActivityIconClass", Window)
AdventureActivityIcon.__size = nil

function AdventureActivityIcon:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.activityButton = nil
	self.enum_type = {
		ACTIVITY_PACKAGE_EXCHANGE 							= 1,	-- 	1:礼包兑换
		ACTIVITY_CUMULATIVE_RECRUIT 						= 2,	-- 	2:累计招募
		ACTIVITY_DEKARON_BOSS 								= 3,	-- 	3:挑战boss
		ACTIVITY_CUMULATIVE_FIRE 							= 4,	-- 	4:累计解雇
		ACTIVITY_GIFTS			 							= 5,	-- 	5:友情送礼
		ACTIVITY_CUSTOMS_CLEARANCE			 				= 6	,	-- 	6:过关斩将
		ACTIVITY_XUEYUXINFENG			 					= 7	,	-- 	7:血雨腥风
		ACTIVITY_CAPABILITY_UP			 					= 8	,	-- 	8:战力爆表
		ACTIVITY_BINQIANGMAZHUANG			 				= 9	,	-- 	9:兵强马壮
		ACTIVITY_COMPETITIVE_KING			 				= 10,	-- 	10:竞技王者
		ACTIVITY_CUMULATIVE_RECHARGE			 			= 11,	-- 	11:累计充值
		ACTIVITY_CUMULATIVE_CONSUMPTION			 			= 12,	-- 	12:累计消费
		ACTIVITY_FIRST_RECHARGE			 					= 13,	-- 	13:首充奖励
		ACTIVITY_COMPETITIVE_KING_TWO			 			= 14,	-- 	14:竞技王者(20胜利)
		ACTIVITY_DIAMONDS_RECRUIT			 				= 15,	-- 	15:血钻招募
		ACTIVITY_KILL_SOLDIER			 					= 16,	-- 	16:击杀杂兵
		ACTIVITY_SINGLE_RECHARGE			 				= 17,	-- 	17:单日充值
		ACTIVITY_SIGNIN_SIGN			 					= 18,	-- 	18:登陆签到
		ACTIVITY_SINGLE_SROCK_RECHARGE			 			= 19,	-- 	19:单笔充值
		ACTIVITY_CUMULATIVE_CONSUMPTION_LONG			 	= 20,	-- 	20:累计消费(长期)
		ACTIVITY_SIGNIN_SIGN_NEW			 				= 21,	-- 	21:新登入签到
		
	}

	self.current_type = 0
	
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_activity_icon_terminal()
		local adventure_activity_icon_warehouse_larger_terminal = {
            _name = "adventure_activity_icon_warehouse_larger",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				
				if terminal.largerId == cell then
					return false
				end
				if terminal.largerId ~= nil then
					terminal.largerId.roots[1]:setColor(cc.c3b(150, 150, 150))
				end
				terminal.largerId = cell
				cell.roots[1]:setColor(cc.c3b(255, 255, 255))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_activity_icon_selected_terminal = {
            _name = "adventure_activity_icon_selected",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_activity_icon_warehouse_larger", 0, params)
				state_machine.excute("adventure_activity_interface_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_activity_icon_warehouse_larger_terminal)
		state_machine.add(adventure_activity_icon_selected_terminal)
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_activity_icon_terminal()
end

function AdventureActivityIcon:updateDraw()
	local root = self.roots[1]
	self.activityButton:removeBackGroundImage()
	self.activityButton:setBackGroundImage(_activity_icon_image[self.current_type])
	root:setColor(cc.c3b(150, 150, 150))
end

function AdventureActivityIcon:onInit()
	local root = cacher.createUIRef("activity/wonderful/wonderful_button.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	self.activityButton  = ccui.Helper:seekWidgetByName(root, "Panel_wdf_button")
	fwin:addTouchEventListener(self.activityButton ,       nil, 
	{
		terminal_name = "adventure_activity_icon_selected",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	-- local can_fetch = false
	-- debug.print_r(_ED.fetchable_activities)
	-- for i,v in pairs(_ED.fetchable_activities) do
	-- 	if self.current_type == tonumber(v) then 
	-- 		can_fetch = true
	-- 		break
	-- 	end 
	-- end

	-- if can_fetch == true then
	-- 		--需要渲染加提示点 
	-- 	local tipBall = self.activityButton:getChildByTag(500)
	-- 	if tipBall ~= nil then 
	-- 		self.activityButton:removeChildByTag(500)
	-- 	end
	-- 	local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
	-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
	-- 	ball:setTag(500)
	-- 	ball:setPosition(cc.p(self.activityButton:getContentSize().width-ball:getContentSize().width*0.5,self.activityButton:getContentSize().height-ball:getContentSize().height*0.5))
	-- 	self.activityButton:addChild(ball)
		
	-- else 
	-- 	local tipBall = self.activityButton:getChildByTag(500)
	-- 	if tipBall ~= nil then 
	-- 		self.activityButton:removeChildByTag(500)
	-- 	end
	-- end

	-- Get size for root node.
	if AdventureActivityIcon.__size == nil then
		local size = root:getContentSize()
		AdventureActivityIcon.__size = size
	end
	
	self:updateDraw()
end

-- 有活动更新的时候刷新提示
function AdventureActivityIcon:onUpdateIconTip()
	-- if #self.roots > 0  and self.current_type ~= 0 then  --有可能该容器已经 unload
	-- 	local can_fetch = false
	-- 	for i,v in pairs(_ED.fetchable_activities) do
	-- 		if self.current_type == tonumber(v) then 
	-- 			can_fetch = true
	-- 			break
	-- 		end 
	-- 	end
	-- 	if can_fetch == true then
	-- 		--需要渲染加提示点 
	-- 		local tipBall = self.activityButton:getChildByTag(500)
	-- 		if tipBall ~= nil then 
	-- 			self.activityButton:removeChildByTag(500)
	-- 		end
	-- 		local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
	-- 		ball:setAnchorPoint(cc.p(0.5, 0.5))
	-- 		ball:setTag(500)
	-- 		ball:setPosition(cc.p(self.activityButton:getContentSize().width-ball:getContentSize().width*0.5,self.activityButton:getContentSize().height-ball:getContentSize().height*0.5))
	-- 		self.activityButton:addChild(ball)
			
	-- 	else 
	-- 		local tipBall = self.activityButton:getChildByTag(500)
	-- 		if tipBall ~= nil then 
	-- 			self.activityButton:removeChildByTag(500)
	-- 		end
	-- 	end
	-- end
	
end

function AdventureActivityIcon:onExit()
	cacher.freeRef("activity/wonderful/wonderful_button.csb", self.roots[1])
end

function AdventureActivityIcon:init(interfaceType)
	self.current_type = interfaceType
	self:onInit()
	
	self:setContentSize(AdventureActivityIcon.__size)
	return self
end
function AdventureActivityIcon:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureActivityIcon:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("activity/wonderful/wonderful_button.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureActivityIcon:createCell()
	local cell = AdventureActivityIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

