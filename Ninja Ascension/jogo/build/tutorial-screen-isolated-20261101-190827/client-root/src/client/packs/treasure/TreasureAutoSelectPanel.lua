-- ----------------------------------------------------------------------------------------------------
-- 说明：宝物出售二级界面 --按品级出售界面
-- 创建时间：2015-03-19
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

TreasureAutoSelectPanel = class("TreasureAutoSelectPanelClass", Window)

--记录上次选中状态
TreasureAutoSelectPanel.blue = false
TreasureAutoSelectPanel.green = false
   
function TreasureAutoSelectPanel:ctor()
    self.super:ctor()
	self.showString = {}
	self.roots = {}
	
	self.currentChooseIndex = 0
	
	self.cacheStatusBox = {}				--StatusBox钩钩的缓存
	self.cacheStatusBoxBottom = {}			--StatusBox底板缓存 数组
	self.blue = false
	self.green = false
	
    -- Initialize Home page state machine.
    local function init_treasure_sell_tip_terminal()
	
		-- 点击了一个Box
		local treasure_auto_select_on_off_terminal = {
            _name = "treasure_auto_select_on_off",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params._datas.index == 1 then
					local status = false
					for i,v in pairs(self.showString) do
						if dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 0 then
							status = true
						end
					end
					if status == true then
						instance.currentChooseIndex = params._datas.index
						instance:ChooseOne()
					else
						TipDlg.drawTextDailog(_string_piece_info[170])
					end
				elseif params._datas.index == 2 then
					local status = false
					for i,v in pairs(self.showString) do
						if dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 1 then
							status = true
						end
					end
					if status == true then
						instance.currentChooseIndex = params._datas.index
						instance:ChooseOne()
					else
						TipDlg.drawTextDailog(_string_piece_info[170])
					end
				elseif params._datas.index == 3 then
					local status = false
					for i,v in pairs(self.showString) do
						if dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) == 2 then
							status = true
						end
					end
					if status == true then
						instance.currentChooseIndex = params._datas.index
						instance:ChooseOne()
					else
						TipDlg.drawTextDailog(_string_piece_info[170])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- ok
		local treasure_auto_select_ok_terminal = {
            _name = "treasure_auto_select_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--state_machine.excute("treasure_sell_select_form_grow", 0, { instance.currentChooseIndex })
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then 
					TreasureAutoSelectPanel.blue = instance.blue
				   	TreasureAutoSelectPanel.green = instance.green
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--cancel
		local treasure_auto_select_cancel_terminal = {
            _name = "treasure_auto_select_cancel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
            		or __lua_project_id == __lua_project_warship_girl_b 
            		or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
            		then 
					TreasureAutoSelectPanel.blue = instance.blue
				   	TreasureAutoSelectPanel.green = instance.green
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(treasure_auto_select_on_off_terminal)
		state_machine.add(treasure_auto_select_ok_terminal)
		state_machine.add(treasure_auto_select_cancel_terminal)

        state_machine.init()
    end
    
    init_treasure_sell_tip_terminal()
end


function TreasureAutoSelectPanel:ChooseOne()
	if self.cacheStatusBox[self.currentChooseIndex]:isVisible() == false then
		self.cacheStatusBox[self.currentChooseIndex]:setVisible(true)
		state_machine.excute("treasure_sell_select_form_grow", 0, { self.currentChooseIndex })
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			if self.currentChooseIndex == 3 then 
				--蓝色
				self.blue = true 
				TreasureAutoSelectPanel.blue = true
			elseif self.currentChooseIndex == 2 then 
				--绿色
				self.green = true 
				TreasureAutoSelectPanel.green = true
			end
		end
	else
		self.cacheStatusBox[self.currentChooseIndex]:setVisible(false)
		state_machine.excute("treasure_sell_cancel_select_form_grow", 0, { self.currentChooseIndex })
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			if self.currentChooseIndex == 3 then 
				--蓝色
				self.blue = false 
				TreasureAutoSelectPanel.blue = false
			elseif self.currentChooseIndex == 2 then 
				--绿色
				self.green = false 
				TreasureAutoSelectPanel.green = true
			end
		end
	end
end

function TreasureAutoSelectPanel:onEnterTransitionFinish()

	--加载 并且显示动画
    local csbTreasureAutoSelectPanel = csb.createNode("packs/EquipStorage/equipment_sell_grade.csb")
	local action = csb.createTimeline("packs/EquipStorage/equipment_sell_grade.csb")
	csbTreasureAutoSelectPanel:runAction(action)
    self:addChild(csbTreasureAutoSelectPanel)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	local root = csbTreasureAutoSelectPanel:getChildByName("root")
	table.insert(self.roots, root)

	--缓存
	local tmpStatusBox
	tmpStatusBox = ccui.Helper:seekWidgetByName(root, "Image_19")
	tmpStatusBox:setTouchEnabled(false)
	table.insert(self.cacheStatusBox, tmpStatusBox)
	tmpStatusBox = ccui.Helper:seekWidgetByName(root, "Image_15")
	tmpStatusBox:setTouchEnabled(false)
	table.insert(self.cacheStatusBox, tmpStatusBox)
	tmpStatusBox = ccui.Helper:seekWidgetByName(root, "Image_17")
	tmpStatusBox:setTouchEnabled(false)
	table.insert(self.cacheStatusBox, tmpStatusBox)

	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		ccui.Helper:seekWidgetByName(root, "Image_15"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_17"):setVisible(false)
	end 

	
	--添加设置底板Touch事件 并且缓存
	local tmpBottomPanel
	tmpBottomPanel = self:addTouchEventFunc("Panel_12", "treasure_auto_select_on_off", false, 1)
	-- tmpBottomPanel:setVisible(false)
	table.insert(self.cacheStatusBoxBottom, tmpBottomPanel)
	tmpBottomPanel = self:addTouchEventFunc("Panel_10", "treasure_auto_select_on_off", false, 2)
	table.insert(self.cacheStatusBoxBottom, tmpBottomPanel)
	tmpBottomPanel = self:addTouchEventFunc("Panel_11", "treasure_auto_select_on_off", false, 3)
	table.insert(self.cacheStatusBoxBottom, tmpBottomPanel)
	
	--返回按钮
	tmpBottomPanel = self:addTouchEventFunc("Button_1", "treasure_auto_select_cancel", true, 0)
	
	--ok按钮
	tmpBottomPanel = self:addTouchEventFunc("Button_2", "treasure_auto_select_ok", true, 0)

	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
	   	ccui.Helper:seekWidgetByName(self.roots[1], "Image_15"):setVisible(TreasureAutoSelectPanel.green)
	   	self.green = TreasureAutoSelectPanel.green

	    ccui.Helper:seekWidgetByName(self.roots[1], "Image_17"):setVisible(TreasureAutoSelectPanel.blue)
	   	self.blue = TreasureAutoSelectPanel.blue
	end
end

-- function TreasureAutoSelectPanel:updateShowText()
	-- if self.cacheTextLabel ~= nil then
		-- self.cacheTextLabel:setString(self.showString)
	-- end
-- end

--通用按钮点击事件添加
function TreasureAutoSelectPanel:addTouchEventFunc(uiName, eventName, actionMode, indexValue)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		next_terminal_name = "", 
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = actionMode,
		index = indexValue
	}, 
	nil, 0)
	return tmpArt
end

function TreasureAutoSelectPanel:onExit()
	state_machine.remove("treasure_auto_select_on_off")
	state_machine.remove("treasure_auto_select_ok")
	state_machine.remove("treasure_auto_select_cancel")
end

function TreasureAutoSelectPanel:init(value)
	self.showString = value
end
