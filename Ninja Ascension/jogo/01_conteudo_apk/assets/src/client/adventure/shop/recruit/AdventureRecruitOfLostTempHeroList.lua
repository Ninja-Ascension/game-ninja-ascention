----------------------------------------------------------------------------------------------------
-- 说明：神殿的武将列表控件
----------------------------------------------------------------------------------------------------
AdventureRecruitOfLostTempHeroList = class("AdventureRecruitOfLostTempHeroListClass", Window)
AdventureRecruitOfLostTempHeroList.__size = nil

function AdventureRecruitOfLostTempHeroList:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.heroInfo = nil
	self.index = 0
    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_recruit_of_lost_temp_hero_list_terminal()
		local adventure_recruit_of_lost_temp_hero_list_request_terminal = {
            _name = "adventure_recruit_of_lost_temp_hero_list_request",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				if zstring.tonumber(_ED.recruit_sky_temple.exchange_count) < 1 then
					local function responseChoiceHeroBattleCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("adventure_recruit_of_lost_temple_update_number", 0, "adventure_recruit_of_lost_temple_update_number.")
							TipDlg.drawTextDailog(_string_piece_info[408])
							--武将动画
						 	local heroIds = zstring.split(_ED.recruit_success_ship_ids, ",")
							if heroIds == nil then 
								return
							end
							if #heroIds > 1 then 
								app.load("client.adventure.shop.recruit.AdventureRecruitSuccessTen")
								fwin:open(AdventureRecruitSuccessTen:new():init(), fwin._ui)
							else 
								app.load("client.adventure.shop.recruit.AdventureRecruitSuccess")
								fwin:open(AdventureRecruitSuccess:new():init(), fwin._ui)
							end
						end
					end
					protocol_command.sky_temple_exchange.param_list = zstring.tonumber(cell.index)-1
					NetworkManager:register(protocol_command.sky_temple_exchange.code, nil, nil, nil, nil, responseChoiceHeroBattleCallback, true, nil)
				else
					TipDlg.drawTextDailog(_string_piece_info[409])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_recruit_of_lost_temp_hero_list_request_terminal)
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_recruit_of_lost_temp_hero_list_terminal()
end

function AdventureRecruitOfLostTempHeroList:updateDraw()
	local root = self.roots[1]
	
end

function AdventureRecruitOfLostTempHeroList:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_yongbin_buy.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_buy"),       nil, 
	{
		terminal_name = "adventure_recruit_of_lost_temp_hero_list_request",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
		
	
	local mouldData = dms.element(dms["ship_mould"], self.heroInfo.exchange_id)
	local Panel_pingzi = ccui.Helper:seekWidgetByName(root, "Panel_pingzi")
	Panel_pingzi:removeAllChildren(true)
	local cell = AdventureHeroIconCell:createCell()
	cell:init(1, {ship_template_id = self.heroInfo.exchange_id}, 1, 0, nil, nil, nil, nil, 0)
	Panel_pingzi:addChild(cell)
	local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
	Text_role_name:setString(dms.atos(mouldData, ship_mould.captain_name))
	
	local Text_word = ccui.Helper:seekWidgetByName(root, "Text_word")
	Text_word:setString(dms.atos(mouldData, ship_mould.sign_msg))
	
	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
	Text_11:setString(self.heroInfo.exchange_price)

	-- Get size for root node.
	if AdventureRecruitOfLostTempHeroList.__size == nil then
		local size = root:getContentSize()
		AdventureRecruitOfLostTempHeroList.__size = size
	end

	self:updateDraw()
end

function AdventureRecruitOfLostTempHeroList:onExit()
	cacher.freeRef("list/list_yongbin_buy.csb", self.roots[1])
end

function AdventureRecruitOfLostTempHeroList:init(tempheroInfo,indexs)
	self.heroInfo = tempheroInfo
	self.index = indexs
	-- if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	-- end

	self:setContentSize(AdventureRecruitOfLostTempHeroList.__size)
	return self
end

function AdventureRecruitOfLostTempHeroList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureRecruitOfLostTempHeroList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_yongbin_buy.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureRecruitOfLostTempHeroList:createCell()
	local cell = AdventureRecruitOfLostTempHeroList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

