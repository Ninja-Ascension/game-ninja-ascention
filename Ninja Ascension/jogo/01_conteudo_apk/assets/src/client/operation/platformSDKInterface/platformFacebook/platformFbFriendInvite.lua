-- ----------------------------------------------------------------------------------------------------
-- 说明：平台的facebook好友邀请功能界面
-- 创建时间	2017-05-04
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

platformFbFriendInvite = class("platformFbFriendInviteClass", Window)

local platform_fb_friend_invite_open_terminal = {
	_name = "platform_fb_friend_invite_open",
	_init = function (terminal)
	
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function (terminal,instance,params)
		local platformFbFriendInviteWindow = fwin:find("platformFbFriendInviteClass")
		if platformFbFriendInviteWindow ~= nil and platformFbFriendInviteWindow:isVisible() == true then
			return true
		elseif platformFbFriendInviteWindow ~= nil and platformFbFriendInviteWindow:isVisible() == false then
			platformFbFriendInviteWindow:setVisible(true)
			return true
		end
		local platformFbMethodWindow = fwin:find("platformFbMethodClass")
        if platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == false then
        elseif platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == true then 
        	--platformFbMethodWindow:setVisible(false)
        	platformFbMethodWindow:onHide()
        end
		state_machine.lock("platform_fb_friend_invite_open",0,"")
		local cell = platformFbFriendInvite:createCell()
		fwin:open(cell:init(),fwin._notification)
		return cell
	end,
	_terminal = nil,
	_terminals = nil
}
  
local platform_fb_friend_invite_close_terminal = {
	_name = "platform_fb_friend_invite_close",
	_init = function (terminal)
	
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function (terminal,instance,params)
		platformFbFriendInvite:closeCell()
		local platformFbMethodWindow = fwin:find("platformFbMethodClass")
        if platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == true then
        elseif platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == false then 
        	platformFbMethodWindow:onShow()
        end
        local platformFbRewardWindow = fwin:find("platformFbRewardClass")
        if platformFbRewardWindow ~= nil then
        	platformFbRewardWindow:closeCell()
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(platform_fb_friend_invite_open_terminal)
state_machine.add(platform_fb_friend_invite_close_terminal)
state_machine.init()

function platformFbFriendInvite:ctor()
    self.super:ctor()
	self.roots = {}
	self.alldata = {} -- 所有好友
	self.drawdata = {} -- 绘制的好友的下标
	self.drawCell = {} -- 绘制的好友的控件
	self.invitedIndex = {} --邀请的好友的下标
	self.invitestring = nil -- 邀请要发送的数据
	self.friendIndexByName = 0 --好友名称对应的下标
	self.size = nil
	self.isDrawEnd = false
    local function init_platform_fb_friend_invite_terminal()
    	--根据名字查找好友
    	local search_fb_friend_by_name_terminal = {
    		_name = "search_fb_friend_by_name",
    		_init = function(terminal)
    		end,
    		_inited = false,
    		_instance = self,
    		_state = 0,
    		_invoke = function(terminal,instance,params)
    			if #instance.alldata == 0 or instance.alldata == {} then
    				TipDlg.drawTextDailog(_invite_fb_friend[3])
    				return
    			end
    			instance:detachWithIME()
    			instance.friendIndexByName = 0	
				local fbFriendName = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_104")
				local fbFriendTextFieldString = fbFriendName:getString()
				local function trim_left(s)  
    				return string.gsub(s, "^%s+", "");
				end  
				if fbFriendTextFieldString == nil or #fbFriendTextFieldString == 0 or trim_left(fbFriendTextFieldString) == ""
					then
					instance.drawdata = {}
					instance.drawdata = instance:getRandomNumber(#instance.alldata)
					-- for i,v in pairs(self.alldata) do
					-- 	table.insert(self.drawdata,i)
					-- end
				else
					for i,v in pairs(instance.alldata) do
						if fbFriendTextFieldString == v.all_fb_friend_name then
							instance.friendIndexByName = i
							instance.drawdata = {}
							table.insert(instance.drawdata,i)
							break
						end
					end
					if instance.friendIndexByName == 0 then
						TipDlg.drawTextDailog(_invite_fb_friend[2])
						return
					end
				end
				instance:onUpdateDraw()
				return true
    		end,
    		_terminal = nil,
    		_terminals = nil
    	}
    	--刷新选中队列
    	local updata_friend_is_selected_terminal = {
    		_name = "updata_friend_is_selected",
    		_init = function(terminal)
    		end,
    		_inited = false,
    		_instance = self,
    		_state = 0,
    		_invoke = function(terminal,instance,params)
    			if params._isSelect == false then
    				for i,v in pairs(instance.invitedIndex) do 
    					if params._friendID == v then
    						table.remove(instance.invitedIndex,i)
    					end
    				end
    			else
    				table.insert(instance.invitedIndex,params._friendID)
    			end
    			state_machine.unlock("invite_fb_friend")
    			return true
    		end,
    		_terminal = nil,
    		_terminals = nil
    	}

    	--邀请好友
    	local invite_fb_friend_terminal = {
    		_name = "invite_fb_friend",
    		_init = function (terminal)
    			
    		end,
    		_inited = false,
    		_instance = self,
    		_state = 0,
    		_invoke = function(terminal,instance,params)
    			if #instance.alldata == 0 or instance.alldata == {} then
    				TipDlg.drawTextDailog(_invite_fb_friend[3])
    				return
    			end
    			instance.invitestring = ""
    			if instance.drawdata == {} or instance.drawdata == nil then
    				TipDlg.drawTextDailog(_invite_fb_friend[1])
    				return
    			end
    			for i,v in pairs(instance.invitedIndex) do 
    				instance.invitestring = instance.invitestring..instance.alldata[v].all_fb_friend_id.."@/*"
    			end
    			if instance.invitestring == "" then 
    				TipDlg.drawTextDailog(_invite_fb_friend[1])
    				return
    			else
    				instance.invitestring = string.sub(instance.invitestring,1,-4)--去掉末尾的连接符
    				local arrayInvite = zstring.split(instance.invitestring ,"@/*")
    				if #arrayInvite > 50 then
    					TipDlg.drawTextDailog(_invite_fb_friend[5])
    					return
    				end
    				local targetPlatform = cc.Application:getInstance():getTargetPlatform()
            		if targetPlatform == cc.PLATFORM_OS_WINDOWS then
            			m_aladion_facebook_invite = zstring.replace(instance.invitestring ,"@/**",",")
            			print("...........邀请队列",m_aladion_facebook_invite)
						state_machine.excute("platform_fb_info_command",0,2)
            		else
            			local curr_invitestring = zstring.replace(instance.invitestring ,"@/**","@/")
    					handlePlatformRequest(0, CC_FACEBOOK_FRIENDS_INVITE, curr_invitestring)
    				end
    			end
    			return true
    		end,
    		_terminal = nil,
    		_terminals = nil
   		}
   		--取消全选
   		local cancel_all_selected_terminal = {
   			_name = "cancel_all_selected",
   			_init = function(terminal)
   			end,
   			_inited = false,
   			_instance = self,
   			_state = 0,
   			_invoke = function(terminal,instance,params)
   				if #instance.alldata == 0 or instance.alldata == {} then
    				TipDlg.drawTextDailog(_invite_fb_friend[3])
    				return
    			end
   				for i,v in pairs(instance.drawCell) do 
   					local root = v:getChildByName("root")
   					if root ~= nil and root ~= "" then
   						local Panel_5 = root:getChildByName("Panel_5")
   						local CheckBox_choose = Panel_5:getChildByName("CheckBox_choose")
   						CheckBox_choose:setSelected(false)
   					end
   					v.isSelect = false
   				end
   				instance.invitedIndex = {}
   				return true
   			end,
   			_terminal = nil,
   			_terminals = nil
   		}
   		--邀请成功，刷新界面
   		local after_invite_update_list_terminal = {
   			_name = "after_invite_update_list",
   			_init = function(_terminal)
   			end,
   			_inited = false,
   			_instance = self,
   			_state = 0,
   			_invoke = function(terminal, instance, params)
   				instance.drawdata = {}
   				local _index = #instance.alldata
   				while _index > 0 do
   					for i,v in pairs(instance.invitedIndex) do
   						if _index == v then 
   							table.remove(instance.alldata, _index)
   							break
   						end
   					end
   					_index = _index - 1
   				end
   				m_aladion_facebook_graph_path = ""
				instance.drawdata = instance:getRandomNumber(#instance.alldata)
				for i,v in pairs(instance.alldata) do
					--table.insert(self.drawdata,i)
					m_aladion_facebook_graph_path = m_aladion_facebook_graph_path..v.all_fb_friend_id.."|"..v.all_fb_friend_name.."@/*" 
				end
				m_aladion_facebook_graph_path = string.sub(m_aladion_facebook_graph_path,1,-4)--去掉末尾的连接符
   				m_aladion_facebook_invite = ""
     			instance:onUpdateDraw()
     			return true
   			end,
   			_terminal = nil,
   			_terminals = nil
   		}
    	state_machine.add(search_fb_friend_by_name_terminal)
    	state_machine.add(invite_fb_friend_terminal)
    	state_machine.add(cancel_all_selected_terminal)
    	state_machine.add(after_invite_update_list_terminal)
    	state_machine.add(updata_friend_is_selected_terminal)
        state_machine.init()
    end
    
    init_platform_fb_friend_invite_terminal()
end
--用于将字符串切割放到数组中，字符串必须以"@/*"结尾
function platformFbFriendInvite:cutterData(string,dataArray)
	local length = string.len(string)
	while length > 1 do
		local f,e = string.find(string,"@/*")
		if f ~= nil then
			if f > 1 then 
				local str1 = string.sub(string, 1 ,f-1)
				local l = string.len(str1)
				local a,b = string.find(str1,"|")
				local data = {
					all_fb_friend_id = string.sub(str1, 1, a-1),
					all_fb_friend_name = string.sub(str1,b + 1,l),
				}
				table.insert(dataArray,data)
				string = string.sub(string,e + 2,length)
				length = string.len(string)
			end
		end
	end
end
function platformFbFriendInvite:detachWithIME()
	local root = self.roots[1]
	local fbFriendName = ccui.Helper:seekWidgetByName(root, "TextField_104")
	fbFriendName:didNotSelectSelf()
end

function platformFbFriendInvite:onUpdate(dt)
	if self.ScrollView ~= nil and self.isDrawEnd == true then
		local posY = self.ScrollView:getInnerContainer():getPositionY()
		if self.scrollViewInnerY == posY then
            return
        end
        self.scrollViewInnerY = posY
		local items = self.ScrollView:getChildren()
        if items[1] == nil then
            return
        end
		local itemSize = items[1]:getContentSize()
		for i,v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > self.size.height + itemSize.height * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function platformFbFriendInvite:onUpdateDraw()
	self.isDrawEnd = false
	local root = self.roots[1]
	local ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_friend")
	ScrollView:setContentSize(self.size)
	ScrollView:removeAllChildren(true)
	self.drawCell = {}
	local controlSize = ScrollView:getInnerContainerSize()
	local width = self.size.width / 5
	local cellheight = 0
	local cellwidth = 0
	local function addFbFriendCell(_index,i)
		local name = self.alldata[_index].all_fb_friend_name
		-- local row = math.floor((i - 1)/ 5) + 1
		-- local col = math.floor((i - 1) % 5)
		--单排显示
		local row = i

		local tempcell = nil
		tempcell = platformFbFriendCell:createCell()
		tempcell:init(name,_index,row)
		table.insert(self.drawCell,tempcell)
		if cellheight == 0 then
			cellheight = tempcell:getContentSize().height
		end
		if cellwidth == 0 then
			cellwidth = tempcell:getContentSize().width
		end
		local controlHeight = row * cellheight
		if controlHeight < self.size.height then
			controlSize.height = self.size.height
		else
			controlSize.height = controlHeight + cellheight
		end
		ScrollView:addChild(tempcell)
	end
	self.invitedIndex = {}
	for i,v in pairs(self.drawdata) do
		table.insert(self.invitedIndex,v)
		addFbFriendCell(v,i)
	end
	self.ScrollView = ScrollView
	ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height))
	self.scrollViewInnerY = ScrollView:getInnerContainer():getPositionY()
	local scrollViewInnerHeight = ScrollView:getInnerContainer():getContentSize().height
	for i,v in pairs(self.drawCell) do
		-- local row = math.floor((i - 1)/ 5) + 1
		-- local col = math.floor((i - 1) % 5)
		-- local pos = nil 
		-- pos=cc.p(width * col + (width - cellwidth)/2,
		-- 	scrollViewInnerHeight - cellheight * row )
		
		--单排显示
		local pos = cc.p(0,scrollViewInnerHeight - cellheight * i)
		v:setPosition(pos)
	end
	self.isDrawEnd = true
end
--如果超过50个，随机抽取50个
function platformFbFriendInvite:getRandomNumber( _maxNumber )
	local number_arry = {}
	local result = {}
	for i = 1 , _maxNumber do
		table.insert(number_arry , i)
	end
	if _maxNumber > 50 then
		local curr_number = 0
		for i = 1 , _maxNumber do
			local index_1 = math.random(i, _maxNumber)
			curr_number = number_arry[i]
			number_arry[i] = number_arry[index_1]
			number_arry[index_1] = curr_number
		end
		for i = 1 , 50 do
			table.insert(result , number_arry[i])
		end
		table.sort(result, function (a, b)
	        return a < b 
	    end)
	else
		return number_arry
	end
	return result
end

function platformFbFriendInvite:onEnterTransitionFinish()
	local csbplatformFbFriendInvite = csb.createNode(config_csb.abroad.facebook_yaoqing)
	self:addChild(csbplatformFbFriendInvite)
	local root = csbplatformFbFriendInvite:getChildByName("root")
	table.insert(self.roots, root)
	local ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_friend")
	self.size = ScrollView:getContentSize()
	local str = m_aladion_facebook_graph_path.."@/*"--给末尾添加一个连接符方便切割
	if str == "@/*" then
		TipDlg.drawTextDailog(_invite_fb_friend[3])
	else
		self:cutterData(str,self.alldata)
		self.drawdata = self:getRandomNumber(#self.alldata)
		-- for i,v in pairs(self.alldata) do
		-- 	table.insert(self.drawdata,i)
		-- end
		self:onUpdateDraw()
	end
	local Button_cancel = ccui.Helper:seekWidgetByName(root,"Button_cancel")
	fwin:addTouchEventListener(Button_cancel,nil,
		{
			terminal_name = "cancel_all_selected",
			terminal_state = 0,
			status = false,
			isPressedActionEnabled = true
		},
		nil,0)
	local Button_yaoqing = ccui.Helper:seekWidgetByName(root,"Button_yaoqing*11")
	fwin:addTouchEventListener(Button_yaoqing,nil,
		{
			terminal_name = "invite_fb_friend",
			terminal_state = 0,
			status = false,
			isPressedActionEnabled = true
		},
		nil,0)
	local Button_shousuo = ccui.Helper:seekWidgetByName(root,"Button_shousuo")
	fwin:addTouchEventListener(Button_shousuo,nil,
		{
			terminal_name = "search_fb_friend_by_name",
			terminal_state = 0,
			status = false,
			isPressedActionEnabled = true
		},
		nil,0)
	local TextField_104 = ccui.Helper:seekWidgetByName(root,"TextField_104")
	self.maxLength = 16
	if verifySupportLanguage(_lua_release_language_en) == true then
		self.maxLength = 18
	end
	draw:addEditBoxEx(TextField_104, _string_piece_info[341], "effect/effice_1500.png", Button_shousuo, maxLength, cc.KEYBOARD_RETURNTYPE_DONE)
	local Button_back = ccui.Helper:seekWidgetByName(root,"Button_back")
	fwin:addTouchEventListener(Button_back,nil,
		{
			terminal_name = "platform_fb_friend_invite_close",
			terminal_state = 0,
			status = false,
			isPressedActionEnabled = true

		},
		nil,0)
	state_machine.unlock("platform_fb_friend_invite_open",0,"")
	fwin:close(fwin:find("ConnectingViewClass"))
end

function platformFbFriendInvite:onInit()

end
function platformFbFriendInvite:init()

	return self
end

function platformFbFriendInvite:onExit()
	state_machine.remove("search_fb_friend_by_name")
	--state_machine.remove("send_invited_friend_message")
	state_machine.remove("invite_fb_friend")
	state_machine.remove("cancel_all_selected")
	state_machine.remove("after_invite_update_list")
	state_machine.remove("updata_friend_is_selected")
end

function platformFbFriendInvite:createCell( ... )
	local cell = platformFbFriendInvite:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function platformFbFriendInvite:closeCell( ... )
	local platformFbFriendInvite = fwin:find("platformFbFriendInviteClass")
	if platformFbFriendInvite == nil then 
		return
	end
	self.friendIndexByName = 0
	self.invitestring = nil 
	self.size = nil
	self.invitedIndex = {}
	self.drawdata = {} 
	self.drawCell = {}
	self.alldata = {}
	self.roots = {}
	fwin:close(platformFbFriendInvite)
end