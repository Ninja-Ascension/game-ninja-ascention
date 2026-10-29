----------------------------------------------------------------------------------------------------
-- 说明：facebook好友控件
-- 创建时间	2016-08-17
-- 作者：宋根旺
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
platformFbFriendCell = class("platformFbFriendCellClass", Window)
function platformFbFriendCell:ctor()
    self.super:ctor()
    self.size = nil
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.friendName = nil
	self.friendID = nil
	self.isSelect = true
	local function init_platform_fb_friend_cell_terminal()
		local is_touch_check_box_terminal = {
			_name = "is_touch_check_box",
			_init = function ( terminal )
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function (terminal,instance,params)
				local cell = params._datas._cell
				params._datas._Image_3:setTouchEnabled(false)
				state_machine.lock("invite_fb_friend")
				local function goToUpdata()
					if params._datas._checkBox:isSelected() == false then
						cell.isSelect = true
						params._datas._checkBox:setSelected(true)
						state_machine.excute("updata_friend_is_selected", 0, { _isSelect = true , _friendID = cell.friendID, _checkBox = params._datas._checkBox})	
					else
						cell.isSelect = false
						params._datas._checkBox:setSelected(false)
						state_machine.excute("updata_friend_is_selected", 0, { _isSelect = false , _friendID = cell.friendID, _checkBox = params._datas._checkBox})
					end
					params._datas._Image_3:setTouchEnabled(true)
				end
				local se = cc.Sequence:create({cc.DelayTime:create(0.1), cc.CallFunc:create(goToUpdata)})
				self:runAction(se)
				return true
			end,
			_terminal = nil,
			_terminals = nil 
		}
	
		state_machine.add(is_touch_check_box_terminal)
        state_machine.init()
	end
	init_platform_fb_friend_cell_terminal()
end

function platformFbFriendCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_facebook_player_icon_name = ccui.Helper:seekWidgetByName(root,"Text_facebook_player_icon_name")
	Text_facebook_player_icon_name:setString(self.friendName)	
end

function platformFbFriendCell:onEnterTransitionFinish()
	if table.getn(self.roots) > 0 then
		return
	end

end

function platformFbFriendCell:onInit()

	if table.getn(self.roots) > 0 then
		return
	end
	local root = cacher.createUIRef(config_csb.abroad.facebook_player_icon, "root")
	
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local Image_3 = ccui.Helper:seekWidgetByName(root,"Image_3")
	self.size = Image_3:getContentSize()
	self:setContentSize(self.size)
	Image_3:setTouchEnabled(true)
	local Panel_5 = ccui.Helper:seekWidgetByName(root,"Panel_5")
	local CheckBox_choose = ccui.Helper:seekWidgetByName(Panel_5,"CheckBox_choose")
	if self.isSelect == true then
		CheckBox_choose:setSelected(true)
	else
		CheckBox_choose:setSelected(false)
	end
	fwin:addTouchEventListener(Image_3, nil, 
	{
		terminal_name = "is_touch_check_box", 
		terminal_state = 0,
		_cell = self,
		_checkBox = CheckBox_choose,
		_Image_3 = Image_3
	},
	nil,0)
	self:onUpdateDraw()
end

function platformFbFriendCell:onExit()
	self.size = nil
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.friendName = nil
	self.friendID = nil
	cacher.freeRef(config_csb.abroad.facebook_player_icon, self.roots[1])
	state_machine.remove("is_touch_check_box")
end

function platformFbFriendCell:init(name,id,drawIndex)
	self.friendName = name
	self.friendID = id
	if drawIndex < 10 then 
		self:onInit()
	end
end

function platformFbFriendCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function platformFbFriendCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef(config_csb.abroad.facebook_player_icon, root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function platformFbFriendCell:createCell()
	local cell = platformFbFriendCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

