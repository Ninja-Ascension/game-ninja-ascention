----------------------------------------------------------------------------------------------------
-- 特殊道具类的封装(金钱,砖石,荣誉等等..)			--请不要随意乱改结构
----------------------------------------------------------------------------------------------------
propMoneyNewIcon = class("propMoneyNewIconClass", Window)

function propMoneyNewIcon:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

	app.load("client.cells.prop.prop_money_info")
	self.types = nil				--类型(区分是什么)
	-- 初始化道具小图标事件响应需要使用的状态机
	
end

function propMoneyNewIcon:onUpdateDraw()
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
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	
	local qualityPicIndex = 1
	if self.types == "1" then			--银币(钢铝)
		Panel_prop:setBackGroundImage(getPropsPath(4002))
		qualityPicIndex = 1 
	elseif self.types == "2" then		--金币(砖石)
		Panel_prop:setBackGroundImage(getPropsPath(4001))
		qualityPicIndex = 5 
	elseif self.types == "3" then		--声望(威望)
		Panel_prop:setBackGroundImage(getPropsPath(4004))
		qualityPicIndex = 4
	elseif self.types == "4" then		--将魂(舰魂)
		Panel_prop:setBackGroundImage(getPropsPath(4007))
		qualityPicIndex = 5 
	elseif self.types == "5" then		--魂玉(水雷魂)
		Panel_prop:setBackGroundImage(getPropsPath(3000))      --4008
		qualityPicIndex = 4 
	elseif self.types == "6" then		--决斗荣誉(荣誉)
		Panel_prop:setBackGroundImage(getPropsPath(4006))
		qualityPicIndex = 4 
	elseif self.types == "7" then		--叛军战功
		Panel_prop:setBackGroundImage(getPropsPath(4005))
		qualityPicIndex = 4 
	elseif self.types == "8" then		--战队经验
		Panel_prop:setBackGroundImage(getPropsPath(4003))
		qualityPicIndex = 4 

	-- 体力
	elseif self.types == "12" then
		Panel_prop:setBackGroundImage(getPropsPath(4005))
		qualityPicIndex = 5

	-- vip经验
	elseif self.types == "39" then
		Panel_prop:setBackGroundImage(getPropsPath(4039))
		qualityPicIndex = 5 

	elseif self.types == "28" then		--军团贡献
		Panel_prop:setBackGroundImage(getPropsPath(4013)) -- 还没加
		qualityPicIndex = 4 
	elseif self.types == "18" then		--威名
		Panel_prop:setBackGroundImage("images/ui/props/props_4006.png")
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			qualityPicIndex = 4
		else
			Panel_kuang:setBackGroundImage("images/ui/quality/icon_enemy_4.png")
		end
		quality		= 4
	elseif self.types == "31" then		--战神令
		Panel_prop:setBackGroundImage("images/ui/props/props_4016.png")
		quality		= 4
	elseif self.types == "34" then		--天赋点
		Panel_prop:setBackGroundImage(getPropsPath(4008)) -- 还没加
		qualityPicIndex = 4
	elseif self.types == "65" then		--矿石
		Panel_prop:setBackGroundImage("images/ui/props/props_4065.png") --矿石
		qualityPicIndex = 5
	elseif self.types == "67" then		--精华
		Panel_prop:setBackGroundImage("images/ui/props/props_4067.png") --精华
		qualityPicIndex = 4		

	-- 探索币
	elseif self.types == "68" then		
		Panel_prop:setBackGroundImage("images/ui/props/props_4009.png")
		qualityPicIndex = 5
	elseif self.types == "70" then	-- 探索币(口袋)	
		Panel_prop:setBackGroundImage("images/ui/props/props_4009.png")
		qualityPicIndex = 5

	-- 圣物精华
	elseif self.types == "69" then		
		Panel_prop:setBackGroundImage("images/ui/props/props_4069.png")
		qualityPicIndex = 4		
	
    -- 经验代币
	elseif self.types == "75" then		
		Panel_prop:setBackGroundImage("image/activity/passport/activity_passport_icon_exchange.png")
		qualityPicIndex = 3
	end
	
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png",qualityPicIndex))
	else

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			for i , v in pairs(_props_image_name) do
				if tonumber(self.types) == i then
					qualityPicIndex = tonumber(zstring.split(v , ",")[2]) + 1
				end
			end
			Panel_ditu:setVisible(true)
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png",qualityPicIndex))
		else
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png",qualityPicIndex))
		end
		
	end
end

function propMoneyNewIcon:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local root = cacher.createUIRef("icon/item.csb","root")
		self:addChild(root)
		table.insert(self.roots, root)
		root:setColor(cc.c3b(255, 255, 255))
		self:onUpdateDraw()
	else
		local csbItem = csb.createNode("icon/item_big.csb")
		local root = csbItem:getChildByName("root")
		root:removeFromParent(false)
		self:addChild(root)
		table.insert(self.roots, root)
		self:onUpdateDraw()
	end
	local root = self.roots[1]
	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end
end

function propMoneyNewIcon:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
        local root = self.roots[1]
        if root == nil then
            return
        end
        local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
        local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
        local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
        local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")
        local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
        local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
        if Panel_star ~= nil then
    		if Panel_star:getChildByTag(9527) ~= nil then
        		Panel_star:removeChildByTag(9527)
        	end
        	Panel_star:removeBackGroundImage()
        	Panel_star:removeAllChildren(true)
        end
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
	    if Panel_props_left_icon ~= nil then
		    Panel_props_left_icon:removeAllChildren(true)
		end
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
	    if Panel_props_right_icon ~= nil then
	    	Panel_props_right_icon:removeAllChildren(true)
	    end
        if Panel_kuang ~= nil then
        	Panel_kuang:removeAllChildren(true)
        	Panel_kuang:removeBackGroundImage()
        end
        if Panel_prop ~= nil then
        	Panel_prop:removeAllChildren(true)
        	Panel_prop:removeBackGroundImage()
        end
        if Panel_ditu ~= nil then
        	Panel_ditu:removeAllChildren(true)
        	Panel_ditu:removeBackGroundImage()
        	fwin:removeTouchEventListener(Panel_ditu)
        end
        if Panel_num ~= nil then
        	Panel_num:removeAllChildren(true)
        	Panel_num:removeBackGroundImage()
        end
        if Panel_5 ~= nil then
        	Panel_5:removeAllChildren(true)
        	Panel_5:removeBackGroundImage()
        end

        local Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
        local Image_zhushou = ccui.Helper:seekWidgetByName(root, "Image_zhushou")
        local Image_tuijian = ccui.Helper:seekWidgetByName(root, "Image_tuijian") 
        local Image_bidiao = ccui.Helper:seekWidgetByName(root, "Image_bidiao")
        local Image_dangqian = ccui.Helper:seekWidgetByName(root, "Image_dangqian")
        local Image_yichuandai = ccui.Helper:seekWidgetByName(root, "Image_yichuandai")
        local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
        local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
        if Image_4 ~= nil then
        	Image_4:setVisible(false)
        end
        if Image_zhushou ~= nil then
        	Image_zhushou:setVisible(false)
        end
        if Image_tuijian ~= nil then
        	Image_tuijian:setVisible(false)
        end
        if Image_bidiao ~= nil then
        	Image_bidiao:setVisible(false)
        end
        if Image_dangqian ~= nil then
        	Image_dangqian:setVisible(false)
        end
        if Image_yichuandai ~= nil then
        	Image_yichuandai:setVisible(false)
        end

        local Label_lorder_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
        local Label_name = ccui.Helper:seekWidgetByName(root, "Label_name")
        local Label_quantity = ccui.Helper:seekWidgetByName(root, "Label_quantity")
        local Label_shuxin =ccui.Helper:seekWidgetByName(root, "Label_shuxin")
        local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
        if Label_lorder_level ~= nil then
        	Label_lorder_level:setVisible(true)
	    	if Label_lorder_level._x then
		    	Label_lorder_level:setPositionX(Label_lorder_level._x)
		    end
        	Label_lorder_level:setString("")
        end
        if Label_name ~= nil then
        	Label_name:setString("")
        	Label_name:setVisible(true)
        end
        if Label_quantity ~= nil then
        	Label_quantity:setString("")
        end
        if Label_shuxin ~= nil then
        	Label_shuxin:setString("")
        end
        if Text_1 ~= nil then
        	Text_1:setString("")
        end

        cacher.freeRef("icon/item.csb", root)
    end
end

function propMoneyNewIcon:init(types, propName)
	self.types = types				--类型(区分是什么)
	
end

function propMoneyNewIcon:createCell()
	local cell = propMoneyNewIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

