----------------------------------------------------------------------------------------------------
-- 说明：副本地图NPC绘制
----------------------------------------------------------------------------------------------------
AdventureDuplicateMapNpcCell = class("AdventureDuplicateMapNpcCellClass", Window)
AdventureDuplicateMapNpcCell.__size = nil

function AdventureDuplicateMapNpcCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.sceneId = 0
	self.npcId = 0
	self.drawIndex = 0
	self.selected = false

	-- Initialize adventure duplicate map npc cell state machine.
	local function init_adventure_duplicate_map_npc_cell_terminal()
        -- 切换场景
        local adventure_duplicate_map_npc_cell_change_scene_terminal = {
            _name = "adventure_duplicate_map_npc_cell_change_scene",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	if cell:isOpened() == false then
            		TipDlg.drawTextDailog(_string_piece_info[374])
            		return false
            	end
            	state_machine.excute("adventure_duplicate_map_change_scene", 0, cell)
            	state_machine.excute("adventure_duplicate_map_npc_cell_selected", 0, cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 校验焦点
        local adventure_duplicate_map_npc_cell_check_selected_terminal = {
            _name = "adventure_duplicate_map_npc_cell_check_selected",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params.cell
            	local npcId = params.npcId
            	if cell ~= nil and zstring.tonumber(cell.npcId) == zstring.tonumber(npcId) then
            		cell:selectedCell()
            		return true
            	end
                return false
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择焦点
        local adventure_duplicate_map_npc_cell_selected_terminal = {
            _name = "adventure_duplicate_map_npc_cell_selected",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params
            	cell:selectedCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 取消选择状态
        local adventure_duplicate_map_npc_cell_unselected_terminal = {
            _name = "adventure_duplicate_map_npc_cell_unselected",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params
            	cell:unselectedCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_map_npc_cell_change_scene_terminal)
        state_machine.add(adventure_duplicate_map_npc_cell_check_selected_terminal)
        state_machine.add(adventure_duplicate_map_npc_cell_selected_terminal)
        state_machine.add(adventure_duplicate_map_npc_cell_unselected_terminal)
        state_machine.init()
	end

	-- call func init adventure duplicate map npc cell state machine.
	init_adventure_duplicate_map_npc_cell_terminal()
end

function AdventureDuplicateMapListCell:onEnterTransitionFinish()

end

function AdventureDuplicateMapNpcCell:selectedCell()
	self.selected = true
	local root = self.roots[1]
	root:setColor(cc.c3b(255, 255, 255))
	root:setScale(1.3)
end

function AdventureDuplicateMapNpcCell:unselectedCell()
	self.selected = false
	local root = self.roots[1]
	root:setColor(cc.c3b(130, 130, 130))
	root:setScale(1)
end

function AdventureDuplicateMapNpcCell:isOpened()
	if tonumber(_ED.npc_state[tonumber(""..self.npcId)]) < 0 then
		return false
	end
    return true
end

function AdventureDuplicateMapNpcCell:onInit()
	local root = cacher.createUIRef("duplicate/maoxian_map.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if (tonumber(self.sceneId) == tonumber(_ED.on_hook_reward_scene) and tonumber(self.npcId) == tonumber(_ED.on_hook_reward_npc) ) then
 		self:selectedCell()
 	else
 		self:unselectedCell()
 	end
	
    if AdventureDuplicateMapNpcCell.__size == nil then
		AdventureDuplicateMapNpcCell.__size = root:getContentSize()
	end

	-- 没有开启的副本添加灰度
	if self:isOpened() == false or self.selected == false then
		root:setColor(cc.c3b(130, 130, 130))
	else
		root:setColor(cc.c3b(255, 255, 255))
	end

	-- 设置纹理
	local Panel_stage = ccui.Helper:seekWidgetByName(root, "Panel_stage")
	local mapIndex = dms.int(dms["npc"], self.npcId, npc.map_index)
	Panel_stage:removeBackGroundImage()
    Panel_stage:setBackGroundImage("map/pve_npc/fuben_gk_" .. mapIndex .. ".png")

	-- 显示星星
	local attacked = tonumber(_ED.npc_state[tonumber(""..self.npcId)]) > 0 and true or false
	local Image_star_hui = ccui.Helper:seekWidgetByName(root, "Image_star_hui")
	local Image_star_liang = ccui.Helper:seekWidgetByName(root, "Image_star_liang")
	Image_star_hui:setVisible(attacked == true and false or true)
	Image_star_liang:setVisible(attacked)

	-- 绘制关卡名称
	ccui.Helper:seekWidgetByName(root, "Text_guanka"):setString("".. self.sceneId .. "-" .. self.drawIndex)

	-- 绘制关卡类型
	local type_images = {
		"images/ui/icon/icon_exp_1.png",
		"images/ui/icon/icon_gold_1.png",
		"images/ui/icon/icon_star.png",
		"images/ui/icon/icon_item.png",
		"images/ui/icon/icon_boss.png",
	}
	local Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")
	Panel_image:removeBackGroundImage()
	Panel_image:setBackGroundImage(type_images[self.drawIndex])

	-- 队伍强化
    fwin:addTouchEventListener(Panel_stage,       nil, 
    {
        terminal_name = "adventure_duplicate_map_npc_cell_change_scene",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
end

function AdventureDuplicateMapNpcCell:onExit()
	cacher.freeRef("duplicate/maoxian_map.csb", self.roots[1])
end

function AdventureDuplicateMapNpcCell:init(sceneId, npcId, drawIndex)
	self.sceneId = sceneId
	self.npcId = npcId
	self.drawIndex = drawIndex

	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end

	self:setContentSize(AdventureDuplicateMapNpcCell.__size)
	return self
end

function AdventureDuplicateMapNpcCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureDuplicateMapNpcCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("duplicate/maoxian_map.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureDuplicateMapNpcCell:createCell()
	local cell = AdventureDuplicateMapNpcCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
