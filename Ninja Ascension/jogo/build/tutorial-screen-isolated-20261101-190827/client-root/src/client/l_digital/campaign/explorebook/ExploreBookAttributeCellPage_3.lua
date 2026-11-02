----------------------------------------------------------------------------------------------------
-- 说明：列表cell中的icon cell
----------------------------------------------------------------------------------------------------
ExploreBookAttributeCellPage_3 = class("ExploreBookAttributeCellPage_3_Class", Window)
ExploreBookAttributeCellPage_3.__size = nil

function ExploreBookAttributeCellPage_3:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCellPageInfo")

	local function init_explore_book_attribute_cell_page_3_terminal()
		-- 点击icon
		local explore_book_attribute_cell_page_icon_click_terminal = {
            _name = "explore_book_attribute_cell_page_icon_click",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local idx = params._datas.idx
            	local cell = params._datas.cell
            	-- debug.print_r(cell)
            	--self.Image_holy_right_icon_hook = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_hook")
            	--if tonumber(idx) == tonumber(cell.index) then
            	--cell.Image_holy_right_icon_hook:setVisible(true)
             --   print(idx,"打印哪一个的icon")

             	--state_machine.excute("explore_book_refreshListView", 0, idx)

             	local book_talent_level = nil
			    for i, v in pairs(_ED.explore_book_data.telent.information) do
			        if v.id ~= nil then       
			            if v.id == self.index then 
			                book_talent_level = v.level
			            end
			        else
			            book_talent_level = nil
			        end
			    end

			    local book_talent_id_info = dms.searchs(dms["explore_achievement_talent_mould"], 2, idx)
			    local talent_info = {}
			    for j, k in pairs(book_talent_id_info) do
			        if tonumber(k[3]) == book_talent_level then
			            table.insert(talent_info,k)
			        end
			    end

			    if  talent_info[1] == nil then
			        return
			    end
            	state_machine.excute("ExploreBookAttributeCellPageInfo_open", 0, {cell,idx})
            
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏选中动画
        local explorebook_holy_cell_icon_hide_select_anim_terminal = {
            _name = "explorebook_holy_cell_icon_hide_select_anim",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- local cell = params.cell
            	-- local cell = params._datas.cell

            	--cell.Image_holy_right_icon_hook:setVisible(false)
            	self.Image_holy_right_icon_hook:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local explore_book_attribute_cell_page_icon_info_refresh_terminal = {
            _name = "explore_book_attribute_cell_page_icon_info_refresh",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- local cell = params.cell
            	-- local cell = params._datas.cell
            	instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --升级动画
        -- local explore_book_attribute_cell_page_icon_uplvani_terminal = {
        --     _name = "explore_book_attribute_cell_page_icon_uplvani",
        --     _init = function (terminal) 
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --     	print("=======升级动画=======")
        --     	debug.print_r(params)
            	--instance:playani(params)
            	--instance:onUpdateDraw(params)
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- } 


		state_machine.add(explore_book_attribute_cell_page_icon_click_terminal)
		state_machine.add(explorebook_holy_cell_icon_hide_select_anim_terminal)
		state_machine.add(explore_book_attribute_cell_page_icon_info_refresh_terminal)
		--state_machine.add(explore_book_attribute_cell_page_icon_uplvani_terminal)
        state_machine.init()
	end

	init_explore_book_attribute_cell_page_3_terminal()
end

function ExploreBookAttributeCellPage_3:onUpdateDraw(params)
	local root = self.roots[1]

	-- 隐藏所有箭头先
	self.Sprite_holy_right_icon_arrow_1:setVisible(false)
	self.Sprite_holy_right_icon_arrow_3:setVisible(false)
	self.Sprite_holy_right_icon_arrow_2:setVisible(false)
	self.Sprite_holy_right_icon_arrow_1_1:setVisible(false)
	self.Sprite_holy_right_icon_arrow_3_1:setVisible(false)

	-- 如果是单数行，箭头向右
	-- if self.holycell2.index % 2 ~= 0 then
	-- 	if self.taskData.idx ~= self.taskData.maxNum then
	-- 		self.Sprite_holy_right_icon_arrow_2:setVisible(true)
	-- 	end
	    -- 如果是偶数行，箭头向左
	-- else
	-- 	if self.taskData.idx ~= self.taskData.maxNum then
	-- 		self.Sprite_holy_right_icon_arrow_3_1:setVisible(true)
	-- 	end
	-- end

	-- 第4个显示朝下的箭头
	if self.index == 4 then
		self.Sprite_holy_right_icon_arrow_1:setVisible(true)
	end

	if tonumber(self.taskData.idx) == tonumber(self.taskData.maxNum) then
		self.Sprite_holy_right_icon_arrow_1:setVisible(false)
	end

	-- self.Text_holy_right_icon_n:setString(self.taskData.idx)
	-- self.Text_holy_right_icon_n:setVisible(true)


	-- 加锁 self.taskData.idx
	for i, v in pairs(_ED.explore_book_data.telent.information) do
        if v.id ~= nil then       
            if v.id == self.taskData.idx then 
                self.Image_holy_right_icon_lock:setVisible(false)
            end
        else
            self.Image_holy_right_icon_lock:setVisible(true)
        end
    end

    --self.Panel_holy_up_effect:setVisible(false)

    self:lockani()
    --self:playani()


    local book_talent_level = nil
    for i, v in pairs(_ED.explore_book_data.telent.information) do
        if v.id ~= nil then       
            if v.id == self.taskData.idx then 
                book_talent_level = v.level
                self.Panel_holy_lock_effect:setVisible(false)
                -- if params and params[2] then
                -- 	if params[2] == self.taskData.idx then
                -- 		self.Panel_holy_up_effect:setVisible(true)
                -- 	else
                -- 		self.Panel_holy_up_effect:setVisible(false)
                -- 	end
                -- end
            end
   --          if params and params[2] then
   --          	if params[2] == self.taskData.idx and v.id == self.taskData.idx then
			-- 	    self.Panel_holy_up_effect:setVisible(true)
			-- 	end
			-- end
        else
            book_talent_level = nil
            --self.Panel_holy_up_effect:setVisible(true)
        end
    end

    self.Panel_holy_up_effect:setVisible(false)
    if self.book_anim_id then
    	if self.book_anim_id == self.taskData.idx then
		   	self.Panel_holy_up_effect:removeAllChildren(true)
		    self.Panel_holy_up_effect:setVisible(true)
			local jsonFile = "images/ui/effice/effect_liuguang/effect_liuguang.json"
			local atlasFile = "images/ui/effice/effect_liuguang/effect_liuguang.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
			self.Panel_holy_up_effect:addChild(animation)
		end
	end

    self.Text_holy_right_icon_n:setString(book_talent_level)
	self.Text_holy_right_icon_n:setVisible(true)

    local book_talent_id_info = dms.searchs(dms["explore_achievement_talent_mould"], 2, self.index)
    local talent_info = {}
    for j, k in pairs(book_talent_id_info) do
        if tonumber(k[3]) == book_talent_level then
            table.insert(talent_info,k)
        end
    end
end

function ExploreBookAttributeCellPage_3:playani(params) --by zy
	local root = self.roots[1]
	local Panel_holy_up_effect = ccui.Helper:seekWidgetByName(root, "Panel_holy_up_effect")

	self.Panel_holy_up_effect:removeAllChildren(true)
	local jsonFile = "images/ui/effice/effect_liuguang/effect_liuguang.json"
	local atlasFile = "images/ui/effice/effect_liuguang/effect_liuguang.atlas"
	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
	self.Panel_holy_up_effect:addChild(animation)
	self.Panel_holy_up_effect:setVisible(false)

    for i, v in pairs(_ED.explore_book_data.telent.information) do
        if v.id ~= nil then       
            if tonumber(v.id) == tonumber(params[2]) then 
            	self.Panel_holy_up_effect:setVisible(true)
            end
        else
        	self.Panel_holy_up_effect:setVisible(false)
        end
    end
 --    self.Panel_holy_up_effect:removeAllChildren(true)
 --    self.Panel_holy_up_effect:setVisible(false)
	-- local jsonFile = "images/ui/effice/effect_liuguang/effect_liuguang.json"
	-- local atlasFile = "images/ui/effice/effect_liuguang/effect_liuguang.atlas"
	-- local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
	-- self.Panel_holy_up_effect:addChild(animation)
end

function ExploreBookAttributeCellPage_3:lockani() --by zy
    self.Panel_holy_lock_effect:removeAllChildren(true)
    self.Panel_holy_lock_effect:setVisible(true)
	local jsonFile = "images/ui/effice/effect_suo/effect_suo.json"
	local atlasFile = "images/ui/effice/effect_suo/effect_suo.atlas"
	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
	self.Panel_holy_lock_effect:addChild(animation)
end

function ExploreBookAttributeCellPage_3:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_book_add_icon_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	-- 选中动画  root:getChildByName
	self.Image_holy_right_icon_hook = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_hook")
	self.Image_holy_right_icon_hook:setVisible(false)
	-- 背景1
	self.Image_holy_right_icon_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_bg_1")
	-- 背景2
	self.Image_holy_right_icon_bg_2 = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_bg_2")
	-- 图标
	local Panel_holy_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_holy_right_icon")
    
    --升级流光效果动画
	self.Panel_holy_up_effect = ccui.Helper:seekWidgetByName(root, "Panel_holy_up_effect")
	--锁动画
    self.Panel_holy_lock_effect = ccui.Helper:seekWidgetByName(root, "Panel_holy_lock_effect")
	--self:lockani()

	fwin:addTouchEventListener(Panel_holy_right_icon, nil,
    {
        terminal_name = "explore_book_attribute_cell_page_icon_click", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        idx = self.taskData.idx,
        cell = self
    }, 
    nil, 0)

    local book_name = dms.string(dms["explore_achievement_talent_mould"],(self.taskData.idx)*2,9)
    Panel_holy_right_icon:removeAllChildren(true)

	if book_name then
	    local spriteImage = string.format("images/ui/talent_icon/talent_icon_%s.png", ""..book_name)
	    local currSprite = cc.Sprite:create(spriteImage)
	    currSprite:setAnchorPoint(0,0)
	    Panel_holy_right_icon:addChild(currSprite)
	end

	-- 等级数
	self.Text_holy_right_icon_n = ccui.Helper:seekWidgetByName(root, "Text_holy_right_icon_n")
	-- 解锁条件
	self.Text_holy_right_icon_lock_n = ccui.Helper:seekWidgetByName(root, "Text_holy_right_icon_lock_n")
	-- 锁图标
	self.Image_holy_right_icon_lock = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_lock")
	-- 下边箭头，朝下
	self.Sprite_holy_right_icon_arrow_1 = root:getChildByName("Sprite_holy_right_icon_arrow_1")
	-- 左边箭头，朝右
	self.Sprite_holy_right_icon_arrow_3 = root:getChildByName("Sprite_holy_right_icon_arrow_3")
	-- 右边箭头，朝右
	self.Sprite_holy_right_icon_arrow_2 = root:getChildByName("Sprite_holy_right_icon_arrow_2")
	-- 右边箭头，朝左
	self.Sprite_holy_right_icon_arrow_1_1 = root:getChildByName("Sprite_holy_right_icon_arrow_1_1")
	-- 左边箭头，朝左
	self.Sprite_holy_right_icon_arrow_3_1 = root:getChildByName("Sprite_holy_right_icon_arrow_3_1")
	
	local panel_size = root:getContentSize()
	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if ExploreBookAttributeCellPage_3.__size == nil then
		ExploreBookAttributeCellPage_3.__size = panel_size
	end

end

function ExploreBookAttributeCellPage_3:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function ExploreBookAttributeCellPage_3:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()

    cacher.freeRef("campaign/exploration/exploration_book_add_icon_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ExploreBookAttributeCellPage_3:clearUIInfo()
    local root = self.roots[1]
    if self.Image_holy_right_icon_hook then
    	self.Image_holy_right_icon_hook:setVisible(false)
    end
    if self.Panel_holy_up_effect then
    	self.Panel_holy_up_effect:removeAllChildren(true)
    	self.Panel_holy_up_effect:setVisible(false)
    end
end

function ExploreBookAttributeCellPage_3:onExit()
	self:clearUIInfo()

    cacher.freeRef("campaign/exploration/exploration_book_add_icon_cell.csb", self.roots[1])
end

function ExploreBookAttributeCellPage_3:init(params, index, holycell2, animID)
	self.taskData = params or {}
	self.holycell2 = holycell2
	self.index = index
	if animID then
		self.book_anim_id = animID
	end
	self:onInit()

	 -- print("====图鉴===属性====3333====",self.index,self.page)
	 -- debug.print_r(self.taskData)
	 -- print("=========self.holycell2=============")
	 -- debug.print_r(self.holycell2)

	if ExploreBookAttributeCellPage_3.__size then
		self:setContentSize(ExploreBookAttributeCellPage_3.__size)
	end
end

function ExploreBookAttributeCellPage_3:createCell()
	local cell = ExploreBookAttributeCellPage_3:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


