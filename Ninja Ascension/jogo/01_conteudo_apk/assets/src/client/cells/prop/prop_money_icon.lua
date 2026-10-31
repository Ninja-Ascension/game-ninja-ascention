----------------------------------------------------------------------------------------------------
-- 特殊道具类的封装(金钱,砖石,荣誉等等..)			--请不要随意乱改结构
----------------------------------------------------------------------------------------------------
propMoneyIcon = class("propMoneyIconClass", Window)

function propMoneyIcon:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

	app.load("client.cells.prop.prop_money_info")
	self.types = nil				--类型(区分是什么)
	self.propNum = nil				--数量(没有就不显示)
	self.propName = nil				--名称(没有就不显示)
	self.vipGrade = nil 			--vip双倍(没有就不显示)
	self.showDouble = nil			--是否显示活动双倍(没有就不显示)
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_prop_money_icon_cell_terminal()
		local prop_money_icon_cell_show_info_terminal = {
            _name = "prop_money_icon_cell_show_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local prop = params._datas._prop
				local cell = propMoneyInfo:new()
				cell:init(prop)
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					then
					fwin:open(cell, fwin._windows)
				elseif __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_warship_girl_b 
					then 
					fwin:open(cell, fwin._dialog)
				else
					fwin:open(cell, fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(prop_money_icon_cell_show_info_terminal)
		
        state_machine.init()
	end
	init_prop_money_icon_cell_terminal()
end

function propMoneyIcon:setActivityDouble( isShow )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
	if Image_double ~= nil then
    	Image_double:setVisible(isShow)
    end
end

function propMoneyIcon:getColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])

end

function propMoneyIcon:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	if Image_2 ~= nil then
		Image_2:setSwallowTouches(false)
	end
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	local vip_double = ccui.Helper:seekWidgetByName(root, "Panel_4")--左上角VIP双倍

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        local spanel = Panel_kuang
        Panel_kuang = Panel_prop
        Panel_prop = spanel
    end
	
	
	local num = tonumber(self.propNum)
	local name = self.propName
	local vip = tonumber(self.vipGrade)
	local quality = 1
	if self.types == "1" then			--银币(钢铝)
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4002.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_1.png")
		end
		quality = 1
		if __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			self.propName = _All_tip_string_info._fundName
		end
		
	elseif self.types == "2" then		--金币(砖石)
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4001.png")
		end
		if Panel_kuang ~= nil then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_3.png")
			else
				Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_7.png")
			end
		end
		quality = 7
	elseif self.types == "3" then		--声望(威望)
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4004.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
	elseif self.types == "4" then		--将魂(舰魂)
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4007.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_5.png")
		end
		quality		= 5
	elseif self.types == "5" then		--魂玉(水雷魂)
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4008.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
	elseif self.types == "6" then		--决斗荣誉(荣誉)
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4006.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
	elseif self.types == "7" then		--叛军战功
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4005.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
	elseif self.types == "8" then		--体力道具
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_2801.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_1.png")
		end
		quality		= 4
	elseif self.types == "28" then		--军团贡献
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4013.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_5.png")
		end
		quality		= 5
	elseif self.types == "18" then		--威名
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4006.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
	elseif self.types == "29" then  -- 胜点，排位赛使用
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/play/pws/pws_shengdian.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
		ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(false)
	elseif self.types == "33" then --驯兽魂
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_3088.png")
			Panel_prop:setTouchEnabled(false)
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
	elseif self.types == "31" then --战神令
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage("images/ui/props/props_4016.png")
		end
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
	end
	if num ~= nil and zstring.tonumber(num) > 0 then
		str = ""
		if num > 10000 then
			local k = math.floor(num/1000)
			str = k .. string_equiprety_name[40]
		else
			str = num
		end
		if item_order_level ~= nil then
			item_order_level:setString("x" .. str)				--数量
		end
	end
	if item_name ~= nil then
		if name ~= nil then
			item_name:setString(name)					--名字
			item_name:setColor(self:getColor(quality))
		end
	end
	if vip_double ~= nil then
		if vip ~= nil then
			vip_double:setVisible(true)
			vip_double:setBackGroundImage(string.format("images/ui/vip/mrqd_shuangbei_v%d.png",vip))
		end
	end
	if self.showDouble == true then
		if ccui.Helper:seekWidgetByName(root, "Image_nub2") ~= nil then
			ccui.Helper:seekWidgetByName(root, "Image_nub2"):setVisible(true)
		end
	end
	for i=1,5 do
		local Image = ccui.Helper:seekWidgetByName(self.roots[1], "Image_o_"..i)
		if Image ~= nil then
			Image:setVisible(false)
		end
		Image = ccui.Helper:seekWidgetByName(self.roots[1], "Image_o_up_"..i)
		if Image ~= nil then
			Image:setVisible(false)
		end
	end
end

function propMoneyIcon:onEnterTransitionFinish()
end
function propMoneyIcon:onInit()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
		if root._x == nil then
			root._x = 0
		end
		if root._y == nil then
			root._x = 0
		end
	else
		local csbItem = csb.createNode("icon/item.csb")
		root = csbItem:getChildByName("root")
	end

	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end
	
	self:clearUIInfo()
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
	{
		terminal_name = "prop_money_icon_cell_show_info", 
		terminal_state = 0, 
		_prop = self.types
	},
	nil,0)
end

function propMoneyIcon:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
		if root._x ~= nil then
			root:setPositionX(root._x)
		end
		if root._y ~= nil then
			root:setPositionY(root._y)
		end
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function propMoneyIcon:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
	    cacher.freeRef("icon/item.csb", root)
	end
end

function propMoneyIcon:init(types, propNum, propName, vipGrade, showDouble)
	self.types = types				--类型(区分是什么)
	self.propNum = propNum			--数量(没有就不显示)
	self.propName = propName		--名称(没有就不显示)
	self.vipGrade = vipGrade		--vip双倍(没有就不显示)
	self.showDouble = showDouble    --是否显示活动双倍

	self:onInit()
end

function propMoneyIcon:createCell()
	local cell = propMoneyIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

