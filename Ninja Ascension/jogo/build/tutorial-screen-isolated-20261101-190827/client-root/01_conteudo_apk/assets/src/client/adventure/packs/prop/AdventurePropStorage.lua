-- ----------------------------------------------------------------------------------------------------
-- 说明：道具仓库
-------------------------------------------------------------------------------------------------------
AdventurePropStorage = class("AdventurePropStorageClass", Window)
    
function AdventurePropStorage:ctor()
    self.super:ctor()
    self.roots = {}

	self.prop_list={}
	self.propInfo = nil
	self.selectIndex = nil
	
	self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self.user_prop_template_id = 0
    self.user_prop_add_times = ""
    self.current_show_type = 1 -- 1背包 2资源仓库
	
	app.load("client.adventure.cells.prop.adventure_prop_werehouse_icon_cell")
	app.load("client.adventure.cells.prop.adventure_new_prop_icon_cell")
    -- Initialize adventure prop storage state machine.
    local function init_adventure_prop_storage_terminal()
        -- 道具使用
        local adventure_prop_storage_prop_use_terminal = {
            _name = "adventure_prop_storage_prop_use",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
				if self.propInfo ~= nil then
					local function responseUsePropCallback(response)
						 if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
						 	self.propInfo = nil
						 	if 	instance.current_show_type == 1  then
                				instance:onUpdateDraw()
                			else
                				instance:onUpdateResourceDraw()
                			end
               				if tonumber(instance.user_prop_template_id) == 323  then  --搜索上限
								state_machine.excute("adventure_duplicate_box_reward_count_update", 0, 0)
							end
							self:updateOnInfo()
							local reward = getSceneReward(4)
							local isopen = false
							if reward ~= nil then 
								for i, v in pairs(reward.show_reward_list) do
									if zstring.tonumber(v.prop_type) == 1 or zstring.tonumber(v.prop_type) == 8 then
										app.load("client.adventure.packs.prop.AdventurePropRewardAnimation")
										fwin:open(AdventurePropRewardAnimation:new():init(v.prop_type,v.item_value, self), fwin._ui)
									elseif  zstring.tonumber(v.prop_type) == 26 then
										app.load("client.adventure.reward.AdventureTipReward")
										fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
										isopen = true
									end
								end
							end
							
							if reward~= nil and isopen == false then
								if tonumber(instance.user_prop_template_id) == 28 or tonumber(instance.user_prop_template_id) == 29 or tonumber(instance.user_prop_template_id) == 30 then 
									TipDlg.drawTextDailog(string.format(_string_piece_info[433],instance.user_prop_add_times))
								else
									app.load("client.adventure.reward.AdventureTipReward")
									fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
								end
							end
						
							if tonumber(instance.user_prop_template_id) == 334 then 
								TipDlg.drawTextDailog(_string_piece_info[406])
								if _ED.adventure_mine.mine_data ~= "-1" then
                            		cc.UserDefault:getInstance():setStringForKey(getKey("mine_data"), _ED.adventure_mine.mine_data or "")
                        		end
                        		state_machine.excute("adventure_mine_reset_update_draw", 0, 0)
							end
							if tonumber(instance.user_prop_template_id) == 332 then  -- 木乃伊雕像
								TipDlg.drawTextDailog(_string_piece_info[407])
							end
						end
					end

					_ED.recruit_success_ship_id = ""
                   	_ED.recruit_success_ship_ids = ""
                  	self.user_prop_template_id = tonumber(self.propInfo.user_prop_template)
                  	
                  	self.user_prop_add_times = "" .. dms.int(dms["prop_mould"], self.user_prop_template_id, prop_mould.use_of_endurance)
                  	if tonumber(self.user_prop_template_id) == 334 or tonumber(self.user_prop_template_id) == 332 then 
                  		app.load("client.adventure.packs.prop.AdventurePropUseTip")
                  		fwin:open(AdventurePropUseTip:new():init(self.propInfo.user_prop_id,self.propInfo.prop_name,self.user_prop_template_id), fwin._ui)
                  		return
                  	end
                   	
					protocol_command.prop_use.param_list = self.propInfo.user_prop_id.."\r\n" .. 1
					NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, cell, responseUsePropCallback,true, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		
		local adventure_prop_storage_update_prop_terminal = {
            _name = "adventure_prop_storage_update_prop",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self.propInfo = nil
				self:onUpdateDraw()
				self:updateOnInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		
		local adventure_prop_storage_use_prop_update_terminal = {
            _name = "adventure_prop_storage_use_prop_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		local adventure_prop_storage_update_on_info_terminal = {
            _name = "adventure_prop_storage_update_on_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.propInfo = params._datas.cell.prop
				self.selectIndex = params._datas.cell.drawIndex
                self:updateOnInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
    	local adventure_hero_package_list_manager_terminal = {
            _name = "adventure_hero_package_list_manager",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			  	if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(130, 130, 130))
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(255, 255, 255))
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                if tonumber(params._datas.current_button_type) == 1 then 
                	instance.selectIndex = nil
                	instance.propInfo = nil
                	instance:onUpdateDraw()
                else
                	instance.selectIndex = nil
                	instance.propInfo = nil
                	instance:onUpdateResourceDraw()
                end
                
               
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
        

        state_machine.add(adventure_prop_storage_prop_use_terminal)
        state_machine.add(adventure_prop_storage_update_on_info_terminal)
        state_machine.add(adventure_prop_storage_update_prop_terminal)
        state_machine.add(adventure_prop_storage_use_prop_update_terminal)
        state_machine.add(adventure_hero_package_list_manager_terminal)

        state_machine.init()
    end
    
    -- call func init adventure prop storage state machine.
    init_adventure_prop_storage_terminal()
end

function AdventurePropStorage:init()
    return self
end

function AdventurePropStorage:updateOnInfo()
	local root = self.roots[1]
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	Panel_prop:removeAllChildren(true)
	local Text_daojuname = ccui.Helper:seekWidgetByName(root, "Text_daojuname")
	local Text_daoju_info = ccui.Helper:seekWidgetByName(root, "Text_daoju_info")
	if self.propInfo ~= nil then 
		local cell = adventureNewPropIconCell:createCell()
		cell:init(0,  {mould_id = self.propInfo.user_prop_template}, 0, 0)
		local mould_data = dms.element(dms["prop_mould"], self.propInfo.user_prop_template)
		Text_daojuname:setString(dms.atos(mould_data, prop_mould.prop_name))--dms.atos(dms["prop_mould"], self.propInfo.user_prop_template, prop_mould.prop_name))
		Text_daoju_info:setString(dms.atos(mould_data, prop_mould.remarks))--dms.atos(dms["prop_mould"], self.propInfo.user_prop_template, prop_mould.remarks))
		Panel_prop:addChild(cell)
	else
		Text_daojuname:setString("")
		Text_daoju_info:setString(_string_piece_info[425])
		Text_daojuname:setVisible(true)

	end
end

function AdventurePropStorage:onUpdate(dt)
	if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
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

function AdventurePropStorage:onUpdateDraw()
	self.current_show_type = 1
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_beibao")
	m_ScrollView:removeAllChildren(true)
	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	local childs = panel:getChildren()
 	for i, v in pairs(childs) do
        v:unload()
    end
	panel:removeAllChildren(true)
	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
	local wPosition = sWidth/5
	local Hlindex = 0
	local first = nil
	self.prop_list = {}
	cellHeight = (zstring.tonumber(_ED.precious_bag_open)/5+1)*(m_ScrollView:getContentSize().width/5)
	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local indexs = 0
	local ccc = 0 
	for i,w in pairs(_ED.user_prop) do
		
		local moulddatas = dms.element(dms["prop_mould"], w.user_prop_template)
		if dms.atoi(moulddatas, prop_mould.storage_page_index) == 0 then
			for j=1, zstring.tonumber(w.prop_number) do
				indexs = indexs+1
				table.insert(self.prop_list, w)
			end
		end
		ccc = ccc + 1
	end

	for j=indexs, zstring.tonumber(_ED.precious_bag_open) do
		if j >= 100 then 
		
		else
			table.insert(self.prop_list, {user_prop_template = 0})		
		end
		
	end

	local  propCount = 0
	for k,z in pairs(self.prop_list) do
		if zstring.tonumber(z.user_prop_template) == 0 then	
		else
			propCount = propCount + 1
		end
	end
	if self.selectIndex == nil then
		 -- 第一次默认
		 self.selectIndex = 1
	elseif self.selectIndex > propCount then
		-- 上次选中的是最后一个,要向前移动
		self.selectIndex = propCount
	else
		self.selectIndex = self.selectIndex
	end
	for k,z in pairs(self.prop_list) do
		local cell = AdventurePropWerehouseIconCell:createCell()
		if zstring.tonumber(z.user_prop_template) == 0 then
			if k == #self.prop_list and k ~= 100 then
				cell:init(99,{user_prop_template = 1},k,nil)
			else
				cell:init(0,{user_prop_template = 1},k,nil)
			end
		else
			cell:init(1,z,k)
		end

		panel:addChild(cell)
		
		if k == self.selectIndex then
			first = cell 
		end
		
		tWidth = tWidth + wPosition
		if (k-1)%5 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - cell:getContentSize().height*Hlindex  
		end
		if k<= 5 then
			tHeight = sHeight - cell:getContentSize().height
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()
	if indexs >0 and first ~= nil then
		state_machine.excute("adventure_prop_werehouse_icon_selected", 0, {_datas={cell = first}})
	end
	self:updateOnInfo()
	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

--刷新资源仓库
function AdventurePropStorage:onUpdateResourceDraw()
	self.current_show_type = 2 
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_beibao")
	m_ScrollView:removeAllChildren(true)
	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	local childs = panel:getChildren()
 	for i, v in pairs(childs) do
        v:unload()
    end
	panel:removeAllChildren(true)
	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
	local wPosition = sWidth/5
	local Hlindex = 0
	local first = nil
	self.prop_list = {}
	cellHeight = (zstring.tonumber(30)/5+1)*(m_ScrollView:getContentSize().width/5)
	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local indexs = 0
	local ccc = 0 
	local  propCount = 0
	for i,w in pairs(_ED.user_prop) do
		
		local moulddatas = dms.element(dms["prop_mould"], w.user_prop_template)
		if dms.atoi(moulddatas, prop_mould.storage_page_index) == 4 then
			indexs = indexs+1
			table.insert(self.prop_list, w)
			propCount = propCount + 1
		end
		ccc = ccc + 1
	end

	for j=indexs, 30 do
		if j >= 30 then 
		
		else
			table.insert(self.prop_list, {user_prop_template = 0})		
		end
	end

	if self.selectIndex == nil then
		 -- 第一次默认
		 self.selectIndex = 1
	elseif self.selectIndex > propCount then
		-- 上次选中的是最后一个,要向前移动
		self.selectIndex = propCount
	else
		self.selectIndex = self.selectIndex
	end
	for k,z in pairs(self.prop_list) do
		local cell = AdventurePropWerehouseIconCell:createCell()
		if zstring.tonumber(z.user_prop_template) == 0 then
			cell:init(0,{user_prop_template = 1},k,nil)
		else
			cell:init(1,z,k,z.prop_number)
		end

		panel:addChild(cell)
		
		if k == self.selectIndex then
			first = cell 
		end
		
		tWidth = tWidth + wPosition
		if (k-1)%5 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - cell:getContentSize().height*Hlindex  
		end
		if k<= 5 then
			tHeight = sHeight - cell:getContentSize().height
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()
	if indexs >0 and first ~= nil then
		state_machine.excute("adventure_prop_werehouse_icon_selected", 0, {_datas={cell = first}})
	end
	self:updateOnInfo()
	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventurePropStorage:onEnterTransitionFinish()
    local csbAdventurePropStorage = csb.createNode("duplicate/beibao.csb")
    local root = csbAdventurePropStorage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventurePropStorage)

	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventurePropStorageClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shiyong"),       nil, 
    {
        terminal_name = "adventure_prop_storage_prop_use",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --道具
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_daoju"),       nil, 
    {
        terminal_name = "adventure_hero_package_list_manager",     
        current_button_name = "Button_daoju",  
        current_button_type = 1 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    local ziyuanButton = ccui.Helper:seekWidgetByName(root, "Button_ziyuan")
    ziyuanButton:setColor(cc.c3b(130, 130, 130))
    ziyuanButton:setHighlighted(false)
    ziyuanButton:setTouchEnabled(true)
    --资源仓库
    fwin:addTouchEventListener(ziyuanButton,       nil, 
    {
        terminal_name = "adventure_hero_package_list_manager",     
        current_button_name = "Button_ziyuan",  
        current_button_type = 2 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    state_machine.excute("adventure_hero_package_list_manager", 0, 
        {_datas ={
            current_button_name = "Button_daoju",        
            current_button_type = 1 ,      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
        )
end

function AdventurePropStorage:onExit()
    state_machine.remove("adventure_prop_storage_prop_use")
    state_machine.remove("adventure_prop_storage_update_prop")
    state_machine.remove("adventure_hero_package_list_manager")
    
end
