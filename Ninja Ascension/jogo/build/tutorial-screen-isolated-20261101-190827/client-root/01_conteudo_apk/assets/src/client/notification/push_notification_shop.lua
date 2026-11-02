-- Initialize push notification center state machine.
local function init_push_notification_center_shop_terminal()
	--首页商店按钮的推送
    local push_notification_center_shop_all_terminal = {
        _name = "push_notification_center_shop_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED.return_vip_number==nil or _ED.return_vip_number == "" then
				-- TODO 减少进入游戏前端向后端请求的次数
				-- protocol_command.shop_view.param_list = "1"
				-- NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, nil, nil, false, nil)
			end	
			if getShopRecruitmentAllTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	--商店战将招募图标的推送
	local push_notification_center_shop_small_building_terminal = {
        _name = "push_notification_center_shop_small_building",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getSmallBuildingTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then			--龙虎门项目控制
						ball:setAnchorPoint(cc.p(0, 0))
					else
						ball:setAnchorPoint(cc.p(1, 1))
					end
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width / 2, params._widget:getContentSize().height-ball:getContentSize().height / 2))
					elseif __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width-10, params._widget:getContentSize().height-ball:getContentSize().height-7))
					elseif __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width/2, params._widget:getContentSize().height-ball:getContentSize().height*3))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
					end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	--商店界面神将招募图片的推送
	local push_notification_center_shop_large_building_terminal = {
        _name = "push_notification_center_shop_large_building",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getTheLargeBuildingTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then			--龙虎门项目控制
						ball:setAnchorPoint(cc.p(0, 0))
					else
						ball:setAnchorPoint(cc.p(1, 1))
					end
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width / 2, params._widget:getContentSize().height-ball:getContentSize().height / 2))
					elseif __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width-10, params._widget:getContentSize().height-ball:getContentSize().height-7))
					elseif __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width/2, params._widget:getContentSize().height-ball:getContentSize().height*3))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
					end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	
	--商店界面zhengy招募图片的推送
	local push_notification_center_shop_zhengy_building_terminal = {
        _name = "push_notification_center_shop_zhengy_building",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getTheZhengyBuildingTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width/2, params._widget:getContentSize().height-ball:getContentSize().height*3))
					
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	--商店界面VIP礼包购买按钮的推送
	local push_notification_centervip_package_terminal = {
        _name = "push_notification_center_vip_package",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getVIPPackageTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = nil
					if __lua_project_id == __lua_project_adventure then 
						ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					else
						ball = cc.Sprite:create("images/ui/bar/tips.png")
					end
					
					
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then			--龙虎门项目控制
						ball:setAnchorPoint(cc.p(0, 0))
					else
						ball:setAnchorPoint(cc.p(1, 1))
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then			--龙虎门项目控制
						ball:setPosition(cc.p(params._widget:getContentSize().width/10*9, params._widget:getContentSize().height/4*3))
					elseif __lua_project_id == __lua_project_adventure then 
						ball:setPosition(cc.p(params._widget:getContentSize().width + 17, params._widget:getContentSize().height + 15))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	

    	--首页新商店按钮的推送-龙虎门
    local push_notification_center_new_shop_terminal = {
        _name = "push_notification_center_new_shop",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        	else
				if _ED.return_vip_number==nil or _ED.return_vip_number == "" then
					-- TODO 减少进入游戏前端向后端请求的次数
					-- protocol_command.shop_view.param_list = "1"
					-- NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, nil, nil, false, nil)
				end
			end	
			if getShopRecruitmentForshop() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_l_digital then 
						ball:setAnchorPoint(cc.p(0.5, 0.5))
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					else
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					end
					
					if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						ball:setPosition(cc.p(params._widget:getContentSize().width-15, params._widget:getContentSize().height))
					end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    	--首页新招募按钮的推送-龙虎门
    local push_notification_center_new_recruit_terminal = {
        _name = "push_notification_center_new_recruit",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED.return_vip_number==nil or _ED.return_vip_number == "" then
				-- TODO 减少进入游戏前端向后端请求的次数
				-- protocol_command.shop_view.param_list = "1"
				-- NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, nil, nil, false, nil)
			end	
			if getShopRecruitment() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					if __lua_project_id == __lua_project_yugioh then
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-150))
					elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						ball:setPosition(cc.p(params._widget:getContentSize().width-15, params._widget:getContentSize().height))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if params._widget.Armature ~= nil then
					if params._widget._istips == true then
						params._widget:setOpacity(0)
						local balltwo = cc.Sprite:create("images/ui/bar/tips.png")
						balltwo:setAnchorPoint(cc.p(1, 1))
						balltwo:setPosition(cc.p(params._widget:getContentSize().width/2, params._widget:getContentSize().height/2))
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							balltwo:setPosition(cc.p(params._widget:getContentSize().width/2-15, params._widget:getContentSize().height/2))
						end
						balltwo:setTag(255)
						params._widget.Armature:addChild(balltwo,9999)
					else
						params._widget:setOpacity(255)
						if params._widget.Armature:getChildByTag(255) ~= nil then 
							params._widget.Armature:removeChildByTag(255)
						end
					end
					params._widget.Armature:setVisible(params._widget._istips)
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    --数码装备宝箱标签页推送
    local push_notification_center_sm_chest_store_terminal = {
        _name = "push_notification_center_sm_chest_store",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getShopRecruitmentForshop(1) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local _form = params._datas._form 
						if _form ~= nil and _form == "ShopPropBuyListViewClass" then
							local ChestStoreWindow = fwin:find("SmShopChestStoreClass")
							if ChestStoreWindow ~= nil and ChestStoreWindow:isVisible() == true then
								ball:setVisible(false)
							end
						end
					end
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

	-- DSC新招募系统首页按钮推送
	local push_notification_center_new_recruit_system_terminal = {
		_name = "push_notification_center_new_recruit_system",
		_init = function (terminal)
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			-- if _ED.newRecruitInfo==nil or _ED.newRecruitInfo == "" then
			-- 	protocol_command.shop_view.param_list = "1"
			-- 	NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, nil, nil, false, nil)
			-- end	
			if getNewShopRecruitmentAllTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					-- DSC重塑
					if __lua_project_id == __lua_project_l_digital then
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
			if __lua_project_id == __lua_project_l_digital then
				if params._widget.Armature ~= nil then
					if params._widget._istips == true then
						params._widget:setOpacity(0)
						local balltwo = cc.Sprite:create("images/ui/bar/tips.png")
						balltwo:setAnchorPoint(cc.p(1, 1))
						balltwo:setPosition(cc.p(params._widget:getContentSize().width/2, params._widget:getContentSize().height/2))
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							balltwo:setPosition(cc.p(params._widget:getContentSize().width/2-15, params._widget:getContentSize().height/2))
						end
						balltwo:setTag(255)
						params._widget.Armature:addChild(balltwo,9999)
					else
						params._widget:setOpacity(255)
						if params._widget.Armature:getChildByTag(255) ~= nil then 
							params._widget.Armature:removeChildByTag(255)
						end
					end
					params._widget.Armature:setVisible(params._widget._istips)
				end
			end
			return true
		end,
		_terminal = nil,
		_terminals = nil
	}

	 --新招募系统单抽免费按钮红点
	 local push_notification_center_new_recruit_free_terminal = {
        _name = "push_notification_center_new_recruit_free",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			-- print(getNewShopRecruitmentFreeTime(), "======getNewShopRecruitmentFreeTime免费")

			if params._widget ~= nil then
				if getNewShopRecruitmentFreeTime() == true then
					params._widget:setVisible(true)
				else
					params._widget:setVisible(false)
				end
			end
			
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

	--新招募系统十连按钮
	local push_notification_center_new_recruit_ten_terminal = {
        _name = "push_notification_center_new_recruit_ten",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			
			if params._widget ~= nil then
				
				if (getNewShopRecruitmentFirstLogin("ten") == true and getNewRecruitTenDiamondEnough()) or (getNewRecruitTenPropEnough() == true) then
					params._widget:setVisible(true)
				else
					params._widget:setVisible(false)
				end
			end
			
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

	--新招募系统心愿单按钮
	local push_notification_center_new_recruit_wishlist_terminal = {
        _name = "push_notification_center_new_recruit_wishlist",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			-- print("====================心愿单", getNewShopRecruitmentWishlistContent())

			if params._widget ~= nil then
				if getNewShopRecruitmentWishlistContent() == true then
					params._widget:setVisible(true)
				else
					params._widget:setVisible(false)
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

	--新招募系统招募商店按钮
	local push_notification_center_new_recruit_shop_terminal = {
        _name = "push_notification_center_new_recruit_shop",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)

			if params._widget ~= nil then
				if getNewShopRecruitmentFirstLogin("shop") == true and getNewShopRecruitmentShopCanBuy() then
					params._widget:setVisible(true)
				else
					params._widget:setVisible(false)
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(push_notification_center_shop_all_terminal)
    state_machine.add(push_notification_center_shop_small_building_terminal)
    state_machine.add(push_notification_center_shop_large_building_terminal)
    state_machine.add(push_notification_centervip_package_terminal)
    state_machine.add(push_notification_center_shop_zhengy_building_terminal)
    state_machine.add(push_notification_center_new_shop_terminal)
    state_machine.add(push_notification_center_new_recruit_terminal)
    state_machine.add(push_notification_center_sm_chest_store_terminal)
    state_machine.add(push_notification_center_new_recruit_system_terminal)
    state_machine.add(push_notification_center_new_recruit_free_terminal)
    state_machine.add(push_notification_center_new_recruit_ten_terminal)
    state_machine.add(push_notification_center_new_recruit_wishlist_terminal)
    state_machine.add(push_notification_center_new_recruit_shop_terminal)
    state_machine.init()
end
init_push_notification_center_shop_terminal()

-- 返回新招募首页图标红点
function getNewShopRecruitmentAllTips()
	if getNewShopRecruitmentFirstLogin() then
		if getNewRecruitTenDiamondEnough() then
			return true
		end

		if getNewShopRecruitmentShopCanBuy() then
			return true
		end
	end

	if getNewRecruitTenPropEnough() then
		return true
	end

	if getNewShopRecruitmentFreeTime() then
		return true
	end
	if getNewShopRecruitmentWishlistContent() then
		return true
	end
	return false
end

-- 是否每日首次登录
function getNewShopRecruitmentFirstLogin(identifier)
	local identifierStr = ""
	if identifier ~= nil then
		identifierStr = identifier
	end
	local nowSeverTime = os.time() + _ED.time_add_or_sub
	
    local day = math.floor(nowSeverTime / 86400)
    local openState = cc.UserDefault:getInstance():getStringForKey("new_recruit_shop".._ED.user_info.user_id..identifierStr, "")
    if openState == "" or openState == nil then
        cc.UserDefault:getInstance():setStringForKey("new_recruit_shop".._ED.user_info.user_id..identifierStr, day)
        cc.UserDefault:getInstance():flush()
        return true
    end
    if tonumber(day) == tonumber(openState) then
        return false
	else
		cc.UserDefault:getInstance():setStringForKey("new_recruit_shop".._ED.user_info.user_id..identifierStr, day)
        cc.UserDefault:getInstance():flush()
	end
	
	return true
end

-- 是否拥有免费抽卡次数
function getNewShopRecruitmentFreeTime()
	local result = true
	local data = _ED.newRecruitInfo
	local freeTime = data.free_times
	result = (freeTime > 0)
	return result
end

-- 十连抽招募券是否足够
function getNewRecruitTenPropEnough()
	-- 获取招募券消耗数量
	local needInfo = dms.string(dms["play_config"], 258, play_config.param)
	local needTicketsCount = tonumber(zstring.split(needInfo, ",")[2])

	-- 获取招募券拥有数量
	local propID = tonumber(zstring.split(dms.string(dms["play_config"], 255, activity_config.param), ",")[2])
	local havePropTickets = tonumber(getPropAllCountByMouldId(propID))
	if (havePropTickets >= needTicketsCount) then
		return true
	end

	return false
end

-- 十连抽钻石是否足够
function getNewRecruitTenDiamondEnough()
	-- 获取消耗钻石的数量
	local needInfo = dms.string(dms["play_config"], 257, play_config.param)
	local needCount = tonumber(zstring.split(needInfo, ",")[2])

	local havePropNum = _ED.user_info.user_gold
	if tonumber(havePropNum) >= tonumber(needCount) then
		return true
	end

	return false
end

-- 心愿单是否有许愿内容，并且有许愿次数
function getNewShopRecruitmentWishlistContent()
	if _ED.active_activity[184] == nil then
		return false
	end
	local activity_params = json.decode(_ED.active_activity[184].activity_params)
	local chooseInfo = activity_params.wishRewardSet
	if tonumber(chooseInfo) == -1 and tonumber(activity_params.lastDrawCount) > 0 then
		return true
	end
	return false
end

-- 招募商店是否有可购买的东西
function getNewShopRecruitmentShopCanBuy()
	local data = _ED.newRecruitInfo
	if data == nil or type(data.shopRemainInfo) ~= "string" then
		return false
	end
	local result = zstring.split(data.shopRemainInfo, ",")

	for k, v in pairs(result) do
		local itemInfo = {}
		local exchangeTerms = dms.string(dms["new_draw_card_shop"], k, new_draw_card_shop.exchangeCondition)	-- 兑换条件
		itemInfo.remain_counts = tonumber(v)
		itemInfo.exchangeTerms = exchangeTerms
		-- 0代表可兑换，1代表没有数码兽，2代表未达到等级，3代表没有兑换次数
		local state = getNewShopRecruitmentListState(itemInfo)
		-- 判断该商品属于什么展示类型
        if state == 0 then
            return true
        end
    end
	return false
end

function getShopRecruitmentAllTips()
	if getSmallBuildingTips() == true then
		return true
	elseif getTheLargeBuildingTips() == true then
		return true
	elseif getVIPPackageTips() == true then
		return true
	elseif getTheZhengyBuildingTips() == true then
		return true
	end
	return false
end

function getShopRecruitment()
	if getSmallBuildingTips() == true then
		return true
	elseif getTheLargeBuildingTips() == true then
		return true
		--阵营招募还没开启
	-- elseif getTheZhengyBuildingTips() == true then
	-- 	return true
	end
	return false
end

function getShopRecruitmentForshop(_type)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if _type ~= nil and _type == 1 then
			local ShopPropBuyListView = fwin:find("ShopPropBuyListViewClass")
			if ShopPropBuyListView ~= nil and ShopPropBuyListView.index == 1 then
				return false
			end
		end
    	if funOpenDrawTip(115,false) == false then
    		local everyDayFreeTime = tonumber(_ED.free_info[3].surplus_free_number) or 0
    		local key_mouldId = dms.int(dms["shop_config"] , 8 , shop_config.param)
    		local key_number = tonumber(getPropAllCountByMouldId(key_mouldId))
    		if everyDayFreeTime > 0 or key_number > 0 then
    			return true
    		end
    	end

  		if getShopUpdateTime() == true then
  			return true
  		end
	else
		if getVIPPackageTips() == true then
			return true
		end
	end
	return false
end

function getShopUpdateTime()
	--获取系统时间
	local server_time = getCurrentGTM8Time()
	local currTimes = server_time.hour * 3600 + server_time.min * 60 + server_time.sec
	local refresh_times = zstring.split(dms.string(dms["shop_config"], 1, shop_config.param) , ",")
	local nextReresh = 0
	local currhour = server_time.hour
	for i , v in pairs(refresh_times) do
		local _hour = tonumber(zstring.split(v , ":")[1])
		if tonumber(currhour) <= _hour then
			--找到下个时间点
			nextReresh = _hour
			break
		end
	end
	if nextReresh ~= 0 then
		if math.abs(nextReresh*3600 - currTimes) < 10 then
			return true
		end
	end
	return false
end

function getSmallBuildingTips()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		local RecruitStr =dms.string(dms["pirates_config"], 273, pirates_config.param)
		local pMouID = zstring.split(RecruitStr,",")
		if tonumber(getPropAllCountByMouldId(pMouID[13])) > 0 then
			return true
		end
	end
	if _ED.free_info[1]~= nil and _ED.free_info[1]~="" then
		local remainTime = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))--战将刷新时间
		if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            remainTime = remainTime - (_ED.system_time + (os.time() - _ED.native_time))
        end
		if tonumber(_ED.free_info[1].surplus_free_number) > 0 and remainTime <= 0 then
			return true
		end
	end
	return false
end

function getTheLargeBuildingTips()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		local RecruitStr =dms.string(dms["pirates_config"], 273, pirates_config.param)
		local pMouID = zstring.split(RecruitStr,",")
		if tonumber(getPropAllCountByMouldId(pMouID[14])) > 0 then
			return true
		end
	end
	if _ED.free_info[2]~= nil and _ED.free_info[2]~="" then
		local remainTime1 = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))--神将刷新时间
		if tonumber(_ED.free_info[2].surplus_free_number) > 0 and remainTime1<=0 then
			return true
		end
	end
	return false
end

function getVIPPackageTips()
	if __lua_project_id == __lua_project_adventure then 
		for i, v in pairs(_ED.return_vip_prop) do
		
			if zstring.tonumber(v.VIP_can_buy) <= zstring.tonumber(_ED.vip_grade) then
				if zstring.tonumber(v.VIP_buy_times) > zstring.tonumber(v.buy_times) then
					return true
				end
			end
		end	
		return false
	else
		for i, v in pairs(_ED.return_vip_prop) do
		local propNameBig = zstring.split(v.mould_name,"VIP")
		local propNameLittle = zstring.split(v.mould_name,"vip")
			if table.getn(propNameBig) >= 2 or table.getn(propNameLittle) >= 2 then
				if zstring.tonumber(v.VIP_can_buy) <= zstring.tonumber(_ED.vip_grade) then
					if zstring.tonumber(v.VIP_buy_times) > zstring.tonumber(v.buy_times) then
						return true
					end
				end
			end
		end
		return false
	end
end
function getTheZhengyBuildingTips()
	if _ED.user_bounty_info ~= nil and _ED.user_bounty_info.has_free ~= nil then
		if _ED.user_bounty_info.has_free == 0 then
			return true
		end
	end
	return false
end
