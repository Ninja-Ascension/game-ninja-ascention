--[[ ----------------------------------------------------------------------------
-- 心愿单奖励cell
--]] ----------------------------------------------------------------------------
NewRecruitWishList = class("NewRecruitWishListcLASS", Window)
NewRecruitWishList.__size = nil

-- 创建Cell实例
local new_recruit_wish_list_create_terminal = {
	_name = "new_recruit_wish_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if NewRecruitWishList then
			local cell = NewRecruitWishList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_wish_list_create_terminal)
state_machine.init()

-- 构造器
function NewRecruitWishList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.propInfo = {}      -- 当前道具信息
    self.curIndex = 1       -- 当前道具下标
	self.chooseIdX = -1	-- 被选中的道具下标

	-- load lua files.

    app.load("client.cells.utils.sm_item_icon_cell")
	-- Initialize service carnival reward review list page state machine.
	local function init_new_recruit_wish_list_terminal()

		-- 更新选中框的显示
		local new_recruit_wish_list_choose_terminal = {
			_name = "new_recruit_wish_list_choose",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local idx = params
					instance:updateChoose(idx)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(new_recruit_wish_list_choose_terminal)
		state_machine.init()
	end
	-- call func init service carnival reward review list state machine.
	init_new_recruit_wish_list_terminal()
end

-- 对象初始化
function NewRecruitWishList:init(params)
	self.propInfo = params[1]
    self.curIndex = params[2]
	self.chooseIdX = params[3]
	-- if self.index <= 4 then
	self:onInit()
	-- end
	self:setContentSize(NewRecruitWishList.__size)
	return self
end

function NewRecruitWishList:updateChoose(idx)
	local children = self.Panel_role_pic:getChildren()
	local cell = children[1]
	if cell ~= nil then
		if idx == self.curIndex then
			cell:setChooseSelectState(true)
		else
			cell:setChooseSelectState(false)
		end
	end
end

function NewRecruitWishList:onUpdateDraw()
	local root = self.roots[1]
	self.Image_2:setVisible(self.isChoosed)
    self.Panel_role_pic:removeAllChildren()
	local data = {}
    local info = zstring.split(self.propInfo, ",")
    local table = {}
    data.prop_type = info[1]
    data.prop_item = info[2]
    data.item_value = info[3]
    -- 获取星级
    if info[4] ~= nil and tonumber(info[4]) > 0 then
        table.shipStar = tonumber(info[4])
    end
    local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{data.prop_type,data.prop_item,data.item_value},false,true,false,true,table})
    self.Panel_role_pic:addChild(cell)
	self:updateChoose(self.chooseIdX)
end

function NewRecruitWishList:onEnterTransitionFinish()
	
end

function NewRecruitWishList:onInit()
	-- 加载ServiceCarnivalRewardReviewListWindow界面资源.
	-- res.activity.service_carnival.new_recruit_wish_list = res/shop/new_recruit_role_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("shop/new_recruit_role_item.csb.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("shop/new_recruit_role_item.csb", "root")
	-- ]]
	-- root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)

	if NewRecruitWishList.__size == nil then
		NewRecruitWishList.__size = root:getContentSize()
	end
    -- 选择按钮
    self.Button_choose = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role_pic"), nil,
	{
		terminal_name = "new_recruit_wish_update_choose",
		terminal_state = 0,
		isPressedActionEnabled = true,
        info = self.propInfo,
        idx = self.curIndex,
	}, nil, 0)	
    self.Panel_role_pic = ccui.Helper:seekWidgetByName(root, "Panel_role_pic")

	self.Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")

	self:onUpdateDraw()
end

function NewRecruitWishList:onExit()
	-- 释放ServiceCarnivalRewardReviewListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("shop/new_recruit_role_item.csb", root)
	-- ]]
end

function NewRecruitWishList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function NewRecruitWishList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("shop/new_recruit_role_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
