----------------------------------------------------------------------------------------------------
-- 说明：探索图鉴单元项
----------------------------------------------------------------------------------------------------
ExploreBookListCell = class("ExploreBookListCellClass", Window)
ExploreBookListCell.__size = nil

function ExploreBookListCell:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.l_digital.campaign.explorebook.ExploreBookWindow")
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_explore_book_list_cell_data_terminal()
	--使用按钮的点击
		local explore_book_list_cell_terminal = {
            _name = "explore_book_list_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local index = params._datas.index
            	local cell = params._datas.cell
            	state_machine.lock("explore_book_list_cell")
            	local lv = zstring.split(dms.string(dms["explore_achievement_world_mould"],index,4),",")
		        if tonumber(_ED.user_info.user_grade) < tonumber(lv[1]) or tonumber(_ED.explore_book_data.countLevel) < tonumber(lv[2]) then
		          	TipDlg.drawTextDailog(tipStringInfo_exploreBook_unlock_tips[1])
		          	state_machine.unlock("explore_book_list_cell")
		          	return
		        end
            	-- local cell = params[1]
            	-- local root = cell.roots[1]
            	state_machine.excute("explore_book_main_window_change_page",0,index)
            	state_machine.unlock("explore_book_list_cell")
            	--instance:buttonChangeStatus(index)
            	-- 	state_machine.excute("sm_shop_buy_open",0,{cell.prop , cell , cell.index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新列表
		local explore_book_list_cell_refush_terminal = {
            _name = "explore_book_list_cell_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--local root = params.roots[1]
            	if instance then
                   instance:onUpdateDraw()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(explore_book_list_cell_terminal)
		state_machine.add(explore_book_list_cell_refush_terminal)
        state_machine.init()
	end
	init_explore_book_list_cell_data_terminal()
end


function ExploreBookListCell:onUpdateDraw()
	local root = self.roots[1]
	local book_name = dms.string(dms["explore_achievement_world_mould"],self.index,2)
	local book_lv = zstring.split(dms.string(dms["explore_achievement_world_mould"],self.index,4),",")
	local word_info = dms.element(dms["word_mould"], book_name)
	local Text_exploration_book_name = ccui.Helper:seekWidgetByName(root, "Text_exploration_book_name")
	Text_exploration_book_name:setString(word_info[3])
	local Text_exploration_book_lv_n = ccui.Helper:seekWidgetByName(root, "Text_exploration_book_pic_lv_n")
	Text_exploration_book_lv_n:setString("Lv"..tonumber(book_lv[1]))
	local Panel_exploration_book_pic = ccui.Helper:seekWidgetByName(root, "Panel_exploration_book_pic")

	local Image_exploration_book_pic = ccui.Helper:seekWidgetByName(root, "Image_exploration_book_pic")
	local book_background_id = dms.string(dms["explore_achievement_world_mould"],self.index,6)
	Image_exploration_book_pic:loadTexture(string.format("images/ui/text/exploration/book_pic_%s.png", tonumber(book_background_id)))
end

function ExploreBookListCell:buttonChangeStatus( page )
	local root = self.roots[1]
	local cell_number_mx = dms.float(dms["play_config"], 126, pirates_config.param)
end

function ExploreBookListCell:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_book_btn_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local panel_size = root:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)
	if ExploreBookListCell.__size == nil then
		ExploreBookListCell.__size = panel_size
	end

 	local Button_exploration_book = ccui.Helper:seekWidgetByName(root, "Button_exploration_book")
	fwin:addTouchEventListener(Button_exploration_book, nil, 
	{
		terminal_name = "explore_book_list_cell", 
		terminal_state = 0,   
		isPressedActionEnabled = true,
		index = self.index,
		cell = self
	},
	nil, 0)
	--self.btEb = Button_exploration_book
	-- if not self.isopen then
 --      Button_exploration_book:setEnabled(false)
	-- end
end

function ExploreBookListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ExploreBookListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	--self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_book_btn_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ExploreBookListCell:clearUIInfo( ... )
    local root = self.roots[1]
end

function ExploreBookListCell:onExit()
	--self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_book_btn_cell.csb", self.roots[1])
end

function ExploreBookListCell:initIcion(isopen) --by zy
  self.isopen = isopen
  --self.btEb:setEnabled(isopen)
end

function ExploreBookListCell:init(index,isopen,page)
	self.index = index
	self.isopen = isopen
	self.page = page
	self:onInit()
	self:setContentSize(ExploreBookListCell.__size)
end

function ExploreBookListCell:createCell()
	local cell = ExploreBookListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


