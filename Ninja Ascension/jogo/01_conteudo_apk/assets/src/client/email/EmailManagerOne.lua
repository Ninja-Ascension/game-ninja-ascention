-- ----------------------------------------------------------------------------------------------------
-- 说明：邮件
-- 创建时间	2015-04-23
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EmailManagerOne = class("EmailManagerOneClass", Window)
    
function EmailManagerOne:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions ={}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		app.load("client.l_digital.cells.email.EmailManagerList")
		app.load("client.l_digital.email.email_infomation")
	else
		app.load("client.email.EmailManagerList")
	end
	self.count = 1
	self.num = 6
	self.listview = nil
    -- Initialize EmailManager page state machine.
    local function init_email_manager_one_terminal()
    	local email_manager_one_updata_terminal = {
            _name = "email_manager_one_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	                local posY = instance.listview_poy or 0
	                -- 邮件中领取皮肤可能会增加战力
	                smFightingChange()
	                
	                instance:onUpdateDraw()
	                if math.abs(posY) > math.abs(instance.listview_height) then
	                    posY = instance.listview_height
	                end
	                instance.listview:getInnerContainer():setPositionY(posY)
	                instance.listview:requestRefreshView()
	                instance.listview_poy = 0
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(email_manager_one_updata_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_email_manager_one_terminal()
end


function EmailManagerOne:onUpdateMore()
	local csbItem = csb.createNode("email/email_list_more.csb")
	local roots = csbItem:getChildByName("root")
	roots:removeFromParent(true)
	
	local Panel_2 = ccui.Helper:seekWidgetByName(roots, "Panel_2")
	local MySize = Panel_2:getContentSize()
	roots:setContentSize(MySize)
	
	return roots
end


function EmailManagerOne:onUpdateDraw()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_01")
	listView:requestRefreshView()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		listView:removeAllItems()
		local max_config = zstring.split(dms.string(dms["mail_config"] , 1 , mail_config.param),",")
		 -- 1 未读最大数 2 已读最大数
		-- local alreadyRead = emailLocalRead()
		local alreadyRead = {}
		local notRead = {}
		for i , v in pairs(_ED._reward_centre) do
			if tonumber(v.read_type) ==  0 then --未读
				table.insert(notRead , v)
			else
				table.insert(alreadyRead , v)
			end
		end
		local function sortTable( a, b )
	        return tonumber(a._reward_time) > tonumber(b._reward_time)
	    end
		table.sort(alreadyRead , sortTable)
		table.sort(notRead , sortTable)
		local notReadMax = math.min(#notRead , tonumber(max_config[1]))
		local alreadyReadMax = math.min(#alreadyRead , tonumber(max_config[2]))
		local index = 1
		for i = 1 , notReadMax do 
			local cell = state_machine.excute("email_manager_list_cell",0,{notRead[i] , index})
			listView:addChild(cell)
			index = index + 1
		end
		for i = 1 , alreadyReadMax do 
			local cell = state_machine.excute("email_manager_list_cell",0,{alreadyRead[i] , index})
			listView:addChild(cell)
			index = index + 1
		end

		self.listview = listView
		self.listview:requestRefreshView()
	    self.listview_poy = self.listview:getInnerContainer():getPositionY()
	    self.listview_height = self.listview:getInnerContainer():getPositionY()
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
		then
		--双列表		
		local function sortEmail( a, b )
			return tonumber(a.mailTime) < tonumber(b.mailTime)
		end
		table.sort(_ED.mail_item, sortEmail)

		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local MylistViewCell = nil
		-- _ED.mail_item
		for i = self.count, zstring.tonumber(_ED.mail_cont) do
			local cell = EmailManagerList:createCell()
			cell:init(_ED.mail_item[self.count])
			if MylistViewCell == nil then
				MylistViewCell = MultipleListViewCell:createCell()
				MylistViewCell:init(listView, cc.size(430,130))
				listView:addChild(MylistViewCell)
				MylistViewCell.prev = preMultipleCell
				if preMultipleCell ~= nil then
					preMultipleCell.next = MylistViewCell
				end
			end
			MylistViewCell:addNode(cell)
			if MylistViewCell.child2 ~= nil then
				preMultipleCell = MylistViewCell
				MylistViewCell = nil
			end
			self.count = self.count + 1
		end
	else	
		for i = self.count, tonumber(_ED.mail_cont) do
			if self.count <= self.num then
				local cell = EmailManagerList:createCell()
				cell:init(_ED.mail_item[self.count])
				listView:addChild(cell)
			else
				local cell = self:onUpdateMore()
				listView:addChild(cell)
				break
			end
			self.count = self.count + 1
		end
	end
	self.num = self.num + 6
end

function EmailManagerOne:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function EmailManagerOne:onUpdateDraw2()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_01")
	local function listViewEventCallBack(sender, evenType)
		if evenType == ccui.ScrollviewEventType.scrollToBottom then
            listView:removeItem(self.count-1)
			self:onUpdateDraw()
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
           
        end
	end
	
	listView:addScrollViewEventListener(listViewEventCallBack)
end

function EmailManagerOne:onEnterTransitionFinish()
	local csbEmailManager = csb.createNode("email/email_listview_1.csb")
	self:addChild(csbEmailManager)
	local root = csbEmailManager:getChildByName("root")
	table.insert(self.roots, root)
	

	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_red_alert 
		then
		local action = csb.createTimeline("email/email_listview_1.csb") 
		table.insert(self.actions, action )
		csbEmailManager:runAction(action)
		action:play("window_open", false)
		
	end

	local function responseInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				response.node:onUpdateDraw()
				response.node:onUpdateDraw2()		
			end
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		-- self:onUpdateDraw()

		local function responsePropCompoundCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
					response.node:onUpdateDraw()
				end
            end
        end
        NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, self, responsePropCompoundCallback, false, nil)
	elseif __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_red_alert then
		self:onUpdateDraw()
		self:onUpdateDraw2()
		_ED.no_read_mail_cont = -1
	else
		protocol_command.email_init.param_list = "-1" .."\r\n".."1" .."\r\n" ..  "30"
		NetworkManager:register(protocol_command.email_init.code, nil, nil, nil, self, responseInitCallback, false, nil)
	end
end


function EmailManagerOne:onExit()
	state_machine.remove("email_manager_one_updata")
	-- state_machine.remove("email_manager_back")
end