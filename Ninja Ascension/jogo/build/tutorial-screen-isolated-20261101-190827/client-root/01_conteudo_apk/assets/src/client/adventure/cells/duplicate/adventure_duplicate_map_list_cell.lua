----------------------------------------------------------------------------------------------------
-- 说明：副本地图列表项
----------------------------------------------------------------------------------------------------
AdventureDuplicateMapListCell = class("AdventureDuplicateMapListCellClass", Window)
AdventureDuplicateMapListCell.__size = nil

function AdventureDuplicateMapListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.sceneMould = nil
	self.selectSceneId = nil
	self.sceneId = -1
	self.drawIndex = 0
	
	-- Initialize adventure duplicate map list cell state machine.
	local function init_adventure_duplicate_map_list_cell_terminal()
        -- 切换场景
        local adventure_duplicate_map_list_cell_change_scene_terminal = {
            _name = "adventure_duplicate_map_list_cell_change_scene",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	if cell:isOpened() == false or cell:checkPreoSceneState() == false then
            		return false
            	end
           		local sceneId = cell.sceneId
				if cell:checkCapacity() == false then
					fwin:open(AdventureDuplicateCapacityTipDlg:new():init(cell.sceneId), fwin._ui)
					return false
				end

				--新开启关卡,需要点下一区域才能开启
				local currentScceneId = tonumber(sceneId) - 1
                local sceneMould = dms.element(dms["pve_scene"], tonumber(sceneId))
           
                if cell:isNextScene() == true and currentScceneId == tonumber(_ED.max_scene_id) then 
                    fwin:open(AdventureDuplicateCapacityTipDlg:new():init(cell.sceneId), fwin._ui)
                    state_machine.excute("adventure_duplicate_map_list_view_close_window", 0, 0)
                    return false
                 end

            	state_machine.excute("adventure_duplicate_change_map", 0, cell.sceneId)
            	state_machine.excute("adventure_duplicate_map_list_view_close_window", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_map_list_cell_change_scene_terminal)
        state_machine.init()
	end

	-- call func init adventure duplicate map list cell state machine.
	init_adventure_duplicate_map_list_cell_terminal()
end

function AdventureDuplicateMapListCell:onEnterTransitionFinish()

end

function AdventureDuplicateMapListCell:isOpened()
	local sceneId = self.sceneId
	if sceneId > 1 and tonumber(_ED.scene_current_state[sceneId - 1]) <= 0 then
		return false
	end

    if _ED.scene_current_state[sceneId] == nil or _ED.scene_current_state[sceneId] == "" then
        return false
    end
    if tonumber(_ED.scene_current_state[sceneId]) < 0 then
        -- 未开启章节
        return false
    end
    return true
end

function AdventureDuplicateMapListCell:isNextScene()
	local sceneId = self.sceneId
	-- 计算下一关是否开启 如 6-5 过了开启后, 跳转 7-1 时需要弹出提示框
	--debug.print_r(_ED.scene_current_state)
	if sceneId > 1 and tonumber(_ED.scene_current_state[sceneId]) == 0 and _ED.scene_current_state[sceneId + 1] ~= nil and tonumber(_ED.scene_current_state[sceneId + 1]) == -1 then
		return true
	end
	return false
end
function AdventureDuplicateMapListCell:checkPreoSceneState(sceneId)
	if self.sceneId > 1 and tonumber(_ED.scene_current_state[self.sceneId - 1]) <= 0 then
		return false
	end
	return true
end

function AdventureDuplicateMapListCell:checkCapacity()
	local capacity = dms.atoi(self.sceneMould, pve_scene.combat_force)
	if capacity > zstring.tonumber(_ED.user_info.fight_capacity) then
		return false
	end
	return true
end

function AdventureDuplicateMapListCell:onInit()
	local root = cacher.createUIRef("duplicate/maoxian_map_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	if AdventureDuplicateMapListCell.__size == nil then
		AdventureDuplicateMapListCell.__size = root:getContentSize()
	end

	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	local Panel_capacity = ccui.Helper:seekWidgetByName(root, "Panel_zhanli")

	local foucs = ccui.Helper:seekWidgetByName(root, "Button_2_4")
	-- 没有开启的副本添加灰度
	if self:isOpened() == false then
		foucs:setColor(cc.c3b(130, 130, 130))
		Panel_star:setVisible(false)
		Panel_capacity:setVisible(true)
	else
		if self:checkCapacity() == true then
			foucs:setColor(cc.c3b(255, 255, 255))
			Panel_star:setVisible(true)
			Panel_capacity:setVisible(false)
		else
			foucs:setColor(cc.c3b(130, 130, 130))
			Panel_star:setVisible(false)
			Panel_capacity:setVisible(true)
		end
	end

	if self.selectSceneId == self.sceneId then
		foucs:setColor(cc.c3b(250, 148, 140))
	end

	-- 绘制编号
	ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1"):setString(""..self.drawIndex)

	-- 绘制关卡名称
	local scene_name = dms.atos(self.sceneMould, pve_scene.scene_name)
	ccui.Helper:seekWidgetByName(root, "Text_guankname"):setString(scene_name)

	-- 绘制关卡底图
	local Panel_mapbg = ccui.Helper:seekWidgetByName(root, "Panel_mapbg")
	Panel_mapbg:removeAllChildren(true)
	Panel_mapbg:removeBackGroundImage()
	local picIndex = dms.atos(self.sceneMould, pve_scene.scene_entry_pic)
	Panel_mapbg:setBackGroundImage("images/ui/pve_sn/pve_duplicate_" .. picIndex ..".png")

	local Sprite_star_s = {
		Panel_star:getChildByName("Sprite_star_" .. 1),
		Panel_star:getChildByName("Sprite_star_" .. 2),
		Panel_star:getChildByName("Sprite_star_" .. 3)
	}
	for i, v in pairs(Sprite_star_s) do
		v:setVisible(false)
	end

	-- 绘制关卡的星星-根据通过难度来绘制
	local npcs = dms.atos(self.sceneMould, pve_scene.npcs)
    local lists = zstring.split(npcs, "|")
    for i, v in pairs(lists) do
    	if v ~= "" then
	    	local list = zstring.split(v, ",")
	    	local _id = tonumber(list[#list])
	    	local Sprite_star = Sprite_star_s[i]
	    	local sceneState = tonumber(_ED.npc_state[_id]) 
	    	if sceneState ~= nil then
	    		Sprite_star:setVisible(true)
		    	if sceneState > 0 then
		    		Sprite_star:setTexture("images/ui/icon/icon_star.png")
		    	else
		    		Sprite_star:setTexture("images/ui/icon/icon_star_hui.png")
		    	end
		    else
		    	print("AdventureDuplicateMapListCell@onInit()", "_ED.scene_current_state[", _id, "] is nil")
		    end
	    end
    end

    -- 绘制战力
	-- ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString(_ED.user_info.fight_capacity)
    local capacity = dms.atos(self.sceneMould, pve_scene.combat_force)
	ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString(capacity)

	-- 队伍强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2_4"),       nil, 
    {
        terminal_name = "adventure_duplicate_map_list_cell_change_scene",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateMapListCell:onExit()
	cacher.freeRef("duplicate/maoxian_map_list.csb", self.roots[1])
end

function AdventureDuplicateMapListCell:init(sceneMould, selectSceneId, drawIndex)
	self.sceneMould = sceneMould
	self.selectSceneId = selectSceneId
	self.drawIndex = drawIndex

	local sceneId = dms.atoi(self.sceneMould, pve_scene.id)
	self.sceneId = sceneId

	if drawIndex ~= nil and drawIndex < 2 then
		self:onInit()
	end
	self:setContentSize(AdventureDuplicateMapListCell.__size)
	return self
end

function AdventureDuplicateMapListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureDuplicateMapListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("duplicate/maoxian_map_list.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureDuplicateMapListCell:createCell()
	local cell = AdventureDuplicateMapListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
