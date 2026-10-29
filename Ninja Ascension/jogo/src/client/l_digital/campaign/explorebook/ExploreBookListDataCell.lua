----------------------------------------------------------------------------------------------------
-- 说明：探索图鉴单元项数据
----------------------------------------------------------------------------------------------------
ExploreBookListDataCell = class("ExploreBookListDataCellClass", Window)
ExploreBookListDataCell.__size = nil

function ExploreBookListDataCell:ctor()
    self.super:ctor()



    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	self.talentPointIsUp = false
	self.talentPointIsActivation = true
	self.page = 1
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.l_digital.campaign.explorebook.ExploreBookWindow")
	app.load("client.l_digital.campaign.explorebook.ExploreBookListCell")
	app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCell")
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_Button_exploration_book_data_terminal()
	-- 激活-可激活，升级-查看
	--查看按钮的点击
		local Button_exploration_book_activation_name_terminal = {
            _name = "Button_exploration_book_activation_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cells = params._datas.cells
            	local data = params._datas.data
            	state_machine.lock("Button_exploration_book_activation_name")
            	--local index = cell.index
            	-- local cell = params[1]
            	-- local root = cell.roots[1]
    --         	local book_id_n = zstring.split(dms.string(dms["explore_achievement_world_mould"],self.page,4),",")
				-- local book_name = dms.string(dms["explore_achievement_tree_mould"],book_id_n[cells.index],2)
				-- local word_info = dms.element(dms["word_mould"], book_name)
    --         	state_machine.excute("explore_book_attribute_cell_open",0,{word_info,cells.index})
		        
		        -- 此处注销，激活改为查看
		        local function responseGrowPlanPurchaseCallback(response)
		            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		            end
		        end
				local book_id_n = zstring.split(dms.string(dms["explore_achievement_world_mould"],instance.page,5),",")
				local book_name = dms.string(dms["explore_achievement_tree_mould"],book_id_n[cells.index],2)
				local word_info = dms.element(dms["word_mould"], book_name)
				state_machine.excute("explore_book_attribute_cell_open",0,{instance.page,data,cells.index})  
				state_machine.unlock("Button_exploration_book_activation_name")
		        instance:onUpdateDraw()
		        local idx = tonumber(instance.page)*tonumber(cells.index)
		        --protocol_command.exlore_achievement_unlock.param_list = ""..data
		        --NetworkManager:register(protocol_command.exlore_achievement_unlock.code, nil, nil, nil, instance, responseGrowPlanPurchaseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 升级
        local Button_exploration_book_up_name_terminal = {
            _name = "Button_exploration_book_up_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cells = params._datas.cells
            	local dataID = params._datas.data
            	state_machine.lock("Button_exploration_book_up_name")
            	--local index = cell.index
            	-- local cell = params[1]
            	-- local root = cell.roots[1]
	            local book_id_n = zstring.split(dms.string(dms["explore_achievement_world_mould"],instance.page,5),",")
				local book_name = dms.string(dms["explore_achievement_tree_mould"],book_id_n[cells.index],2)
				local word_info = dms.element(dms["word_mould"], book_name)
            	state_machine.excute("explore_book_attribute_cell_open",0,{instance.page,dataID,cells.index})
                state_machine.excute("explore_book_main_up_updata", 0, "")
                instance:onUpdateDraw()
                state_machine.unlock("Button_exploration_book_up_name")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新列表
		local Button_exploration_book_activation_refush_terminal = {
            _name = "Button_exploration_book_activation_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--local root = params.roots[1]
            	--local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
            	instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(Button_exploration_book_activation_name_terminal)
		state_machine.add(Button_exploration_book_up_name_terminal)
		state_machine.add(Button_exploration_book_activation_refush_terminal)
        state_machine.init()
	end
	init_Button_exploration_book_data_terminal()
end

function ExploreBookListDataCell:onUpdateDraw()
	local root = self.roots[1]
	local book_id_n = zstring.split(dms.string(dms["explore_achievement_world_mould"],self.page,5),",")
	if self.page == nil then
		self.page = 1 
	end

	local book_tree_id = zstring.split(dms.string(dms["explore_achievement_tree_mould"],book_id_n[self.index],4),",")
    local book_data_max_id = nil
    for i, v in pairs(book_tree_id) do
        book_data_max_id = tonumber(v)
    end
    local data = {}
    for i, v in pairs(_ED.explore_book_data.telent.information) do
    	if v.id >= tonumber(book_tree_id[1]) and v.id <= book_data_max_id then
    		table.insert(data,v)
    	end
    end
    local level_add_num = 0
    for i, v in pairs (data) do
    	level_add_num = level_add_num + v.level
    end

	local book_name = dms.string(dms["explore_achievement_tree_mould"],book_id_n[self.index],2)
	local word_info = dms.element(dms["word_mould"], book_name)
	local Text_exploration_book_name = ccui.Helper:seekWidgetByName(root, "Text_exploration_book_name")
	Text_exploration_book_name:setString(word_info[3])    -- book_id_n[self.page]
	local Text_exploration_book_lv_n = ccui.Helper:seekWidgetByName(root, "Text_exploration_book_lv_n")
	Text_exploration_book_lv_n:setString("Lv"..tonumber(level_add_num))
	local Panel_exploration_book_pic = ccui.Helper:seekWidgetByName(root, "Panel_exploration_book_pic")
	local Sprite_exploration_book_pic = root:getChildByName("Sprite_exploration_book_pic") 

	local Image_exploration_book_pic = ccui.Helper:seekWidgetByName(root, "Image_exploration_book_pic")
	local book_background_id = dms.string(dms["explore_achievement_tree_mould"],self.data,5)
	--Image_exploration_book_pic:loadTexture(string.format("res/images/ui/text/exploration/book_pic_%s.png", 1)) 
	Sprite_exploration_book_pic:setTexture(string.format("images/ui/text/exploration/book_pic_big_%s.png", tonumber(book_background_id)))
	Image_exploration_book_pic:setVisible(false)
	Sprite_exploration_book_pic:setVisible(true)
	--display:gray(Sprite_exploration_book_pic)

	local Button_exploration_book_up = ccui.Helper:seekWidgetByName(root, "Button_exploration_book_up")
	local Button_exploration_book_activation = ccui.Helper:seekWidgetByName(root, "Button_exploration_book_activation")

	if _ED.explore_book_data.tree ==  nil then
		Button_exploration_book_up:setVisible(false)
		Button_exploration_book_activation:setVisible(true)
		display:gray(Sprite_exploration_book_pic)
		self.talentPointIsUp = false
		self.talentPointIsActivation = true
	else
        Button_exploration_book_up:setVisible(false)
		self.Image_red:setVisible(false)
        Button_exploration_book_activation:setVisible(true)
        display:gray(Sprite_exploration_book_pic)
        for i= 1,#(_ED.explore_book_data.tree)do
        	if tonumber(_ED.explore_book_data.tree[i] )== tonumber(self.data) then
                Button_exploration_book_up:setVisible(true)
				self.Image_red:setVisible(false)      -- true
				Button_exploration_book_activation:setVisible(false)
				display:ungray(Sprite_exploration_book_pic)
        	end
        end

        local exploration_book_item = dms.string(dms["explore_achievement_tree_mould"],self.data,3)
		local item_data_n = zstring.split(exploration_book_item,"|")
		local universalId = dms.int(dms["shop_config"], 5 , shop_config.param)
    	local _max_select_num = zstring.tonumber(getPropAllCountByMouldId(universalId))
	    for k, v in pairs(item_data_n) do
	        local item_data = zstring.split(v,",")
	        if tonumber(item_data[1]) == 6 then	        	
	        	if tonumber(_max_select_num) < tonumber(item_data[3])  then
	        		-- display:gray(Sprite_exploration_book_pic)
	        		-- Button_exploration_book_activation:setVisible(false)
	        		-- Button_exploration_book_up:setVisible(true)
	        		-- self.Image_red:setVisible(false)

	        		--_new_interface_text[27]
	        	end
	        end

	        if tonumber(item_data[1]) == 1 then
	        	if tonumber(_ED.user_info.user_gold) < tonumber(item_data[3]) then
	        		-- display:gray(Sprite_exploration_book_pic)
	        		-- Button_exploration_book_activation:setVisible(false)
	        		-- Button_exploration_book_up:setVisible(true)
	        		-- self.Image_red:setVisible(false)

	        		--TipDlg.drawTextDailog(_string_piece_info[128])   
	        	end
	        end
	    end
	end
end



function ExploreBookListDataCell:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_book_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local panel_size = root:getContentSize()
	--self:onUpdateDraw()
	self:setContentSize(panel_size)
	if ExploreBookListDataCell.__size == nil then
		ExploreBookListDataCell.__size = panel_size
	end

	local Button_exploration_book_up = ccui.Helper:seekWidgetByName(root, "Button_exploration_book_up")
	fwin:addTouchEventListener(Button_exploration_book_up, nil, 
	{
		terminal_name = "Button_exploration_book_up_name",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		cells = self,
		data = self.data
	},
	nil, 0)

 	local Button_exploration_book_activation = ccui.Helper:seekWidgetByName(root, "Button_exploration_book_activation")
	fwin:addTouchEventListener(Button_exploration_book_activation, nil, 
	{
		terminal_name = "Button_exploration_book_activation_name", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		cells = self,
		data = self.data
	},
	nil, 0)

	local book_id_n = zstring.split(dms.string(dms["explore_achievement_world_mould"],self.page,5),",")
	self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")

	self:onUpdateDraw()
end

function ExploreBookListDataCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ExploreBookListDataCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	--self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_book_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ExploreBookListDataCell:clearUIInfo( ... )
end

function ExploreBookListDataCell:onExit()
	--self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_book_cell.csb", self.roots[1])
end

function ExploreBookListDataCell:init(page,index,data)
	self.page = page
	self.index = index
	self.data = data
	self:onInit()
	self:setContentSize(ExploreBookListDataCell.__size)
end

function ExploreBookListDataCell:createCell()
	local cell = ExploreBookListDataCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


