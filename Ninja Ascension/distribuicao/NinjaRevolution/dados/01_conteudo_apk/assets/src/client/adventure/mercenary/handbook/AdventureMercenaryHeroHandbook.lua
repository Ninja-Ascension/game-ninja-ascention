-- ----------------------------------------------------------------------------------------------------
-- 说明：武将图鉴
-------------------------------------------------------------------------------------------------------
AdventureMercenaryHeroHandbook = class("AdventureMercenaryHeroHandbookClass", Window)

local adventure_mercenary_hero_handbook_open_terminal = {
    _name = "adventure_mercenary_hero_handbook_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        --print(" ----open")
    	-- 游戏正常启动后,不能直接OPEN ,会引起主界面地图的卡顿,这里只创建内存,在需要打开的时候,open进去
    	local herobookWindow = fwin:find("AdventureMercenaryHeroHandbookClass")
    	-- if terminal.mercenaryBookWind ~= nil then 
    	-- 	-- 第一次已经创建过这块内存了
    	-- 	if params == false then 
    	-- 		-- 换了一个玩家的情况,清空数据重新复制
    	-- 		terminal.mercenaryBookWind = nil 
    	-- 		herobookWindow = AdventureMercenaryHeroHandbook:new():init()
    	-- 		terminal.mercenaryBookWind = herobookWindow
    	-- 		terminal.mercenaryBookWind:retain()
    	-- 	else 
    	-- 		-- 需要打开界面
     --            print("-----Kkkkkkzheli")
    	-- 		if herobookWindow == nil  then
    	-- 			-- 直接使用内存中的数据打开界面 --就这一次会卡顿一下 
     --              
					-- herobookWindow = terminal.mercenaryBookWind
    	-- 			fwin:open(herobookWindow,fwin._dview)
     --                herobookWindow:setVisible(true)
    	-- 		else 
    	-- 			-- 在界面中已经找到了这个界面--- 直接显示
    	-- 			herobookWindow:setVisible(true)
    	-- 		end
    	-- 	end
    	-- else 

    	-- 	-- 没有这块内容了,首次创建
    	-- 	if params == false then 
    	-- 		herobookWindow = AdventureMercenaryHeroHandbook:new():init()
    	-- 		terminal.mercenaryBookWind = herobookWindow
    	-- 		terminal.mercenaryBookWind:retain()
    	-- 	else 

    	-- 		if herobookWindow == nil then 
     --                print("-----meiyou chuangjian ")
    	-- 			herobookWindow = AdventureMercenaryHeroHandbook:new():init()
    	-- 			terminal.mercenaryBookWind = herobookWindow
    	-- 			terminal.mercenaryBookWind:retain()
    	-- 			fwin:open(herobookWindow,fwin._dview)
    	-- 		else
     --                print("you zhege ,dakai  ")
    	-- 			herobookWindow:setVisible(true)
    	-- 		end
    	-- 	end
    	-- end
		if herobookWindow ~= nil  then
			if terminal.mercenaryBookWind ~= nil then 

			end
			herobookWindow:setVisible(true)
            herobookWindow:onEnterUpdate() --重绘
		else
			herobookWindow = AdventureMercenaryHeroHandbook:new():init()
			if terminal.mercenaryBookWind ~= nil then 
				terminal.mercenaryBookWind = nil
			else
				terminal.mercenaryBookWind = herobookWindow
				terminal.mercenaryBookWind:retain()
			end
		
			fwin:open(herobookWindow, fwin._dview)
			if params == false then 
				herobookWindow:setVisible(false)
			end
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_mercenary_hero_handbook_hide_terminal = {
    _name = "adventure_mercenary_hero_handbook_hide",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local herobookWindow = fwin:find("AdventureMercenaryHeroHandbookClass")
    	if herobookWindow ~= nil then
			herobookWindow:setVisible(false)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_mercenary_hero_handbook_open_terminal)
state_machine.add(adventure_mercenary_hero_handbook_hide_terminal)
state_machine.init()

function AdventureMercenaryHeroHandbook:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	app.load("client.loader.formula")
	self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self.firstLoadIndex = 0 
	self.showType = -1
    self.Text_tpye = nil
    self.isGetServerShipComment = false
    -- Initialize adventure mercenary hero handbook state machine.
    local function init_adventure_mercenary_hero_handbook_terminal()
        -- 改变排序
        local adventure_mercenary_hero_handbook_sort_terminal = {
            _name = "adventure_mercenary_hero_handbook_sort",
            _init = function (terminal)
                app.load("client.adventure.mercenary.package.AdventurePokedexMercenaryPackageSort")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventurePokedexMercenaryPackageSort:new():init(self.showType), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_mercenary_hero_handbook_sort_update_terminal = {
			_name = "adventure_mercenary_hero_handbook_sort_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.showType = zstring.tonumber(params._datas._showType)
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

        --更新图鉴武将信息
        local adventure_mercenary_hero_handbook_date_update_terminal = {
            _name = "adventure_mercenary_hero_handbook_date_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and  instance.roots ~= nil then 

                    instance:onUpdateHandbookChange(params)
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_mercenary_hero_handbook_sort_terminal)
        state_machine.add(adventure_mercenary_hero_handbook_sort_update_terminal)
        state_machine.add(adventure_mercenary_hero_handbook_date_update_terminal)        
        state_machine.init()
    end
    
    -- call func init adventure mercenary hero handbook state machine.
    init_adventure_mercenary_hero_handbook_terminal()
end

function AdventureMercenaryHeroHandbook:init()
    return self
end
local ship_infos = {}

function AdventureMercenaryHeroHandbook:showTypeText(index)
    -- 这个地方应该在配置文件里面加字段
    if index == -1 then  --全部
        self.Text_tpye:setString(_string_piece_info[423])
    elseif index == 5 then -- 红将
        self.Text_tpye:setString(_ship_types_by_color[6])
    elseif index == 4 then --橙将
        self.Text_tpye:setString(_ship_types_by_color[5])
    elseif index == 3 then  --紫将
        self.Text_tpye:setString(_ship_types_by_color[4])
    elseif index == 2 then  --蓝将
        self.Text_tpye:setString(_ship_types_by_color[3])
    elseif index == 1 then  --绿将
        self.Text_tpye:setString(_ship_types_by_color[2])
    elseif index == 0 then  --白将
        self.Text_tpye:setString(_ship_types_by_color[1])
    end
end

function AdventureMercenaryHeroHandbook:showlist(index)
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_role")
	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
    self:showTypeText(index)

	
	local thList = {}
	local typed_ship_mould_array = get_typed_base_ship_moulds()
	if zstring.tonumber(index) >=0 then
		local i = zstring.tonumber(index)
		for _, mould in pairs(typed_ship_mould_array[i]) do
			table.insert(thList, mould)
		end
	else
        local ship_type = 5
        if zstring.tonumber(_game_platform_version_type) == 2 then 
            ship_type = 6
        end
		for i = ship_type, 0, -1 do
			for _, mould in pairs(typed_ship_mould_array[i]) do
				table.insert(thList, mould)
			end
		end	
	end

	local wPosition = sWidth/5
	local Hlindex = 0			

	cellHeight = (#thList/5+1)*(m_ScrollView:getContentSize().width/5)
	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local collectionNumber = 0
	for j, v in pairs(thList) do
		local shipMouldId = dms.atoi(v, ship_mould.id) or 0

		local isBim = false
		local cell = AdventureHeroIconCell:createCell()
        local propr_id = dms.int(dms["ship_mould"], shipMouldId, ship_mould.refine_get_jade)
		local handbook = _ED.user_prop_soul_stone["" .. propr_id]
		if handbook ~= nil then
			cell:init(1, {ship_template_id = shipMouldId}, 1, 0, handbook, nil, nil, nil, j)
			collectionNumber = collectionNumber + 1
		else
            if _ED.hero_handbook["".. shipMouldId] ~= nil then 
                cell:init(1, {ship_template_id = shipMouldId}, 1, 0, "0", nil, nil, nil, j)    
            else
                cell:init(1, {ship_template_id = shipMouldId}, 1, nil, nil, nil, nil, nil, j)
            end
		end
	    cell:setName("" .. shipMouldId .. "handbook")
		panel:addChild(cell)
		-- for w=1, tonumber(_ED._legendNumber) do
		-- 	if zstring.tonumber(_ED._legendInfo[w].legendMouldId) == sceneId then
		-- 		cell:init(1, {ship_template_id = sceneId}, 1, 0, _ED._legendInfo[w].legendGoodOpinionLv ,nil,nil,nil,j)
		-- 		panel:addChild(cell)
		-- 		isBim = true
		-- 		collectionNumber = collectionNumber + 1
		-- 		break
		-- 	end
		-- end
		
		-- if isBim == false then
		-- 	cell:init(1, {ship_template_id = sceneId}, 1, nil, nil, nil,nil,nil,j)
		-- 	panel:addChild(cell)
		-- end
		tWidth = tWidth + wPosition
		if (j-1)%5 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - wPosition*Hlindex  
		end
		if j<= 5 then
			tHeight = sHeight - wPosition
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	local Text_xiaohao = ccui.Helper:seekWidgetByName(root, "Text_xiaohao")
	local total = #thList
	Text_xiaohao:setString(collectionNumber.."/"..total)
	
	m_ScrollView:jumpToTop()
	
	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureMercenaryHeroHandbook:onUpdateDraw()
	local root = self.roots[1]
	self:showlist(self.showType)
end

function AdventureMercenaryHeroHandbook:onEnterUpdate()
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_role")
    m_ScrollView:jumpToTop()
    --self:onUpdate(1)

end
function AdventureMercenaryHeroHandbook:onUpdateHandbookChange(params)
    local root = self.roots[1]
    if self.roots ~= nil and root ~= nil then 
        local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_role")
        local panel = m_ScrollView:getInnerContainer()
        local child = panel:getChildByName("" .. params.shipId .. "handbook")
        if child ~= nil and params ~= nil then 
            --刷新数据
            local propr_id = dms.int(dms["ship_mould"], params.shipId, ship_mould.refine_get_jade)
            local handbook = _ED.user_prop_soul_stone["" .. propr_id]
            if handbook ~= nil then

                child:init(1, {ship_template_id = params.shipId}, 1, 0, handbook, nil, nil, nil,child.drawIndex)
                child:unload()
                child:reload()
            else
                child:init(1, {ship_template_id = params.shipId}, 1, 0, "0", nil, nil, nil,child.drawIndex)
                child:unload()
                child:reload()
            end
        end
    end
    
end

function AdventureMercenaryHeroHandbook:onUpdate(dt)
	if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function AdventureMercenaryHeroHandbook:onInitScrollView()
	-- body
end
function AdventureMercenaryHeroHandbook:onEnterTransitionFinish()
    local csbAdventureMercenaryHeroHandbook = csb.createNode("packs/Mercenary/yongbing_tujian.csb")
    local root = csbAdventureMercenaryHeroHandbook:getChildByName("root")
    table.insert(self.roots, root)

    self:addChild(csbAdventureMercenaryHeroHandbook)
    self.Text_tpye = ccui.Helper:seekWidgetByName(root, "Text_16")
	self:onUpdateDraw()

    if self.isGetServerShipComment == false then 
        self.isGetServerShipComment = true
        local function responseShowShipMouldListCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            end
        end
        NetworkManager:register(protocol_command.ship_comment_init.code, nil, nil, nil, nil, responseShowShipMouldListCallback, false, nil)
    end
	-- local scheduler = cc.Director:getInstance():getScheduler()  
	-- local schedulerID = nil  
	-- local  timer = 0
	-- schedulerID = scheduler:scheduleScriptFunc(function ()
 --           self:onUpdateDraw()
 --           cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
          
 --    end,0.0,false) 

	    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "adventure_mercenary_hero_handbook_hide",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 变更排序
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose"),       nil, 
    {
        terminal_name = "adventure_mercenary_hero_handbook_sort",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureMercenaryHeroHandbook:onExit()

end
