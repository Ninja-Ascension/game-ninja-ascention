
CaptureResource = class("CaptureResourceClass", Window)

CaptureResource._BaseWidth = 1320
CaptureResource._BaseHeight = 896

local capture_resource_open_terminal = {
	_name = "capture_resource_open",
	_init = function (terminal)
        -- app.load("client.player.UserInformationShop")
        app.load("client.player.UserTopInfoA")
        app.load("client.captureResource.CaptureResourceLayer")
        app.load("client.captureResource.CaptureResourceScene")
        app.load("client.captureResource.CaptureResourceInfo")
        app.load("client.captureResource.CaptureResourceMyBuild")
        app.load("client.captureResource.CaptureFormation")
        app.load("client.captureResource.CaptureResourceBuild")
        app.load("client.captureResource.CaptureSearch")
        app.load("client.captureResource.CaptureSearchPos")
        app.load("client.captureResource.CaptureResourceReward")
        app.load("client.captureResource.CaptureResourceRank")
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local CaptureResourceWindow = fwin:find("CaptureResourceClass")
        if params == nil then
    		if CaptureResourceWindow ~= nil and CaptureResourceWindow:isVisible() == true then
    			return true
    		end
        end
        state_machine.lock("capture_resource_open")
		fwin:open(CaptureResource:new(), fwin._view)
        fwin:close(fwin:find("UserTopInfoAClass"))
        fwin:open(UserTopInfoA:new(), fwin._view)
        if params ~= nil then
            state_machine.excute("capture_resource_begin_search_pos", 0, params)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local capture_resource_close_terminal = {
	_name = "capture_resource_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local CaptureResourceWindow = fwin:find("CaptureResourceClass")
		if CaptureResourceWindow ~= nil then
			fwin:close(CaptureResourceWindow)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(capture_resource_open_terminal)
state_machine.add(capture_resource_close_terminal)
state_machine.init()

function CaptureResource:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.layerList = {}
	self.infoListView = nil

    self.map_posX = 0
    self.map_posY = 0

    local function init_capture_resource_terminal()
		--返回主页
		local capture_resource_return_home_terminal = {
            _name = "capture_resource_return_home",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responsePropCompoundCallback( response )
                end
                NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                if fwin:find("MenuClass") == nil then
                    fwin:open(Menu:new(), fwin._taskbar)
                end
                if fwin:find("HomeClass") == nil then
                    state_machine.excute("menu_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "menu_manager",     
                                next_terminal_name = "menu_show_home_page", 
                                current_button_name = "Button_home",
                                but_image = "Image_home",       
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        }
                    )
                end                
    			state_machine.excute("menu_back_home_page", 0, "")

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local society_email_button_touch_terminal = {
            _name = "society_email_button_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.email.EmailManager")
				fwin:open(EmailManager:new():init(true), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local society_shuoming_button_touch_terminal = {
            _name = "society_shuoming_button_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.refinery.TreasureInfo")
				local cell = TreasureInfo:new()
                cell:init(7)
                fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local society_open_info_touch_terminal = {
            _name = "society_open_info_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateRightInfoVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local society_close_info_touch_terminal = {
            _name = "society_close_info_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateRightInfoVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local goto_once_capture_resource_terminal = {
            _name = "goto_once_capture_resource",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:moveToOnePos(params.mapBuild.map_index, params.mapBuild.pos_x, params.mapBuild.pos_y)
                state_machine.excute("capture_resource_info_open", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local goto_once_capture_for_fuchou_terminal = {
            _name = "goto_once_capture_for_fuchou",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --instance:moveToOnePos(params.map_index, params.pos_x, params.pos_y)
                instance:setTouchEfficByBuildXy(params.map_index, params.pos_x , params.pos_y )        
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_search_capture_terminal = {
            _name = "capture_resource_search_capture",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("capture_search_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_search_pos_capture_terminal = {
            _name = "capture_resource_search_pos_capture",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("capture_search_pos_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_begin_search_capture_terminal = {
            _name = "capture_resource_begin_search_capture",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:searchNoneCapture(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_begin_search_pos_terminal = {
            _name = "capture_resource_begin_search_pos",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:serachPos(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_update_ower_info_terminal = {
            _name = "capture_resource_update_ower_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local captureResource = fwin:find("CaptureResourceClass")
                if captureResource ~= nil and captureResource.roots ~= nil then
                    instance:updateMyInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_update_layer_build_info_terminal = {
            _name = "capture_resource_update_layer_build_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local captureResource = fwin:find("CaptureResourceClass")
                if captureResource ~= nil and captureResource.roots ~= nil then
                    instance:updateBuildInfo(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_add_capture_times_terminal = {
            _name = "capture_resource_add_capture_times",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addCaptureTimes()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_update_notice_terminal = {
            _name = "capture_resource_update_notice",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(params) == 16 then   --抢地盘失败
                    -- TipDlg.drawTextDailog(_string_piece_info[400])
                elseif tonumber(params) == 17 then   --抢地盘成功
                    -- TipDlg.drawTextDailog(_string_piece_info[400])
                elseif tonumber(params) == 18 then   --地盘被抢夺失败
                    -- TipDlg.drawTextDailog(_string_piece_info[400])
                elseif tonumber(params) == 19 then   --地盘被抢夺成功
                    TipDlg.drawTextDailog(_string_piece_info[397])
                elseif tonumber(params) == 20 then   --放弃地盘
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(capture_resource_return_home_terminal)
		state_machine.add(society_email_button_touch_terminal)
		state_machine.add(society_shuoming_button_touch_terminal)
		state_machine.add(society_open_info_touch_terminal)
		state_machine.add(society_close_info_touch_terminal)
        state_machine.add(goto_once_capture_resource_terminal)
        state_machine.add(capture_resource_search_capture_terminal)
        state_machine.add(capture_resource_search_pos_capture_terminal)
        state_machine.add(capture_resource_begin_search_capture_terminal)
        state_machine.add(capture_resource_begin_search_pos_terminal)
        state_machine.add(capture_resource_update_ower_info_terminal)
        state_machine.add(capture_resource_update_layer_build_info_terminal)
        state_machine.add(capture_resource_change_info_visible_terminal)
        state_machine.add(capture_resource_add_capture_times_terminal)
        state_machine.add(capture_resource_update_notice_terminal)
        state_machine.add(goto_once_capture_for_fuchou_terminal)
        state_machine.init()
    end
	
    init_capture_resource_terminal()
end

function CaptureResource:addCaptureTimes(surenumber)
    if surenumber == 1 then
        return
    end
    local buildOpenInfo = zstring.split(dms.string(dms["pirates_config"], 292, pirates_config.param), ",")
    if tonumber(_ED.open_resource_bulid_max_count) == tonumber(buildOpenInfo[2]) then
        TipDlg.drawTextDailog(_string_piece_info[405])
        return
    end
    local buytimes = tonumber(_ED.open_resource_bulid_max_count) - buildOpenInfo[1]
    local money = tonumber(buildOpenInfo[3])
    for i=1, buytimes do
        money = money * 2
    end
    if surenumber == nil then
        app.load("client.utils.ConfirmTip")
        local tip = ConfirmTip:new()
        tip:init(self,self.addCaptureTimes,string.format(_string_piece_info[406],money),nil,nil)
        fwin:open(tip,fwin._windows)
        return
    end
    if surenumber == 0 then
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                TipDlg.drawTextDailog(_string_piece_info[407])
                response.node:updateDraw()
            end
        end
        protocol_command.basic_consumption.param_list = "58\r\n0\r\n0"
        NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function CaptureResource:updateAddTimesInfo( ... )
    local root = self.roots[1]
    local currentCount = 0
    if _ED.captureResourceInfo ~= nil then
        currentCount = table.nums(_ED.captureResourceInfo)
    end
    ccui.Helper:seekWidgetByName(root, "Text_zhanlin_number"):setString(currentCount.."/".._ED.open_resource_bulid_max_count)
end

function CaptureResource:searchNoneCapture( searchIndex )
    self:removeGuideEffect()
    local result = {}
    for i=1, table.nums(_ED.capture_resource_map_info) do
        local mapBuildList = _ED.capture_resource_map_info[""..i]
        local buildlist = _ED.capture_resource_build_info[""..i]
        for hor, horBuildList in pairs(mapBuildList) do
            for ver, verBuildId in pairs(horBuildList) do
                if tonumber(verBuildId) == tonumber(searchIndex) then
                    local buildInfo = buildlist[hor.."-"..ver]
                    table.insert(result, buildInfo)
                end
            end
        end
    end
    local searchBuild = nil
    for k,v in pairs(result) do
        if v.captureName == "" then
            searchBuild = v
            break
        end
    end
    if searchBuild == nil then
        TipDlg.drawTextDailog(_string_piece_info[411])
        return
    end
    if searchBuild ~= nil then
        self:moveToOnePos(searchBuild.map_index, searchBuild.pos_x, searchBuild.pos_y)
        local function delatEnd( sender )
            local hor = math.ceil(searchBuild.map_index%3)
            local ver = math.ceil(searchBuild.map_index/3)
            if hor == 0 then
                hor = 3
            end
            local mapLayer = self.layerList[ver][hor]
            if mapLayer ~= nil then
                mapLayer:addGuideEffect(searchBuild)
            end
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(delatEnd)))
    end
end

--与下面的searchpos函数有点像，xy是邮件里面的，服务器和前端下标起始不同，所以匹配的时候，邮件类的xy+1，index 不用加
function CaptureResource:setTouchEfficByBuildXy(index , x , y)
    self:removeGuideEffect()
    local searchBuild = nil
    local result = {}
    for i=1, table.nums(_ED.capture_resource_map_info) do
        local mapBuildList = _ED.capture_resource_map_info[""..i]
        local buildlist = _ED.capture_resource_build_info[""..i]
        for hor, horBuildList in pairs(mapBuildList) do
            for ver, verBuildId in pairs(horBuildList) do
                local buildInfo = buildlist[hor.."-"..ver]
                table.insert(result, buildInfo)
            end
        end
    end    
    for k,v in pairs(result) do
        if tonumber(v.map_index) == tonumber(index) and tonumber(v.pos_x) == tonumber(x) + 1 and tonumber(v.pos_y) == tonumber(y)+1 then
            searchBuild = v
        end
    end
    -- print("=======搜索到的======",searchBuild.map_index, searchBuild.pos_x, searchBuild.pos_y)
    if searchBuild == nil then
        TipDlg.drawTextDailog("未找到对应建筑")
        return
    end
    self:moveToOnePos(searchBuild.map_index, searchBuild.pos_x, searchBuild.pos_y)
    local function delatEnd( sender )
        local hor = math.ceil(searchBuild.map_index%3)
        local ver = math.ceil(searchBuild.map_index/3)
        if hor == 0 then
            hor = 3
        end
        local mapLayer = self.layerList[ver][hor]
        if mapLayer ~= nil then
            mapLayer:addGuideEffect(searchBuild)
        end
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(delatEnd)))
end
function CaptureResource:serachPos( params )
    self:removeGuideEffect()
    local mapIndex = tonumber(params[1])
    local pos_x = tonumber(params[2])
    local pos_y = tonumber(params[3])
    if mapIndex == nil then
        TipDlg.drawTextDailog(_string_piece_info[417])
        return
    end
    if pos_x == nil then
        TipDlg.drawTextDailog(_string_piece_info[418])
        return
    end
    if pos_y == nil then
        TipDlg.drawTextDailog(_string_piece_info[419])
        return
    end
    if mapIndex > table.nums(_ED.capture_resource_map_info) then
        TipDlg.drawTextDailog(_string_piece_info[415])
        return
    end
    local mapBuilds = _ED.capture_resource_map_info[""..mapIndex]
    if pos_y > table.nums(mapBuilds) then
        TipDlg.drawTextDailog(_string_piece_info[416])
        return
    end
    local horBuilds = mapBuilds[pos_y]
    if pos_x > table.nums(horBuilds) then
        TipDlg.drawTextDailog(_string_piece_info[416])
        return
    end
    local info = _ED.capture_resource_build_info[""..mapIndex]
    local searchBuild = info[pos_y.."-"..pos_x]
    self:moveToOnePos(mapIndex, pos_x, pos_y)
    local function delatEnd( sender )
        local hor = math.ceil(searchBuild.map_index%3)
        local ver = math.ceil(searchBuild.map_index/3)
        if hor == 0 then
            hor = 3
        end
        local mapLayer = self.layerList[ver][hor]
        if mapLayer ~= nil then
            mapLayer:addGuideEffect(searchBuild)
        end
    end
    if searchBuild ~= nil then
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(delatEnd)))
    end
end

function CaptureResource:removeGuideEffect( ... )
    if table.nums(self.layerList) == 0 then
        return
    end
    for k,v in pairs(self.layerList) do
        for k1,v1 in pairs(v) do
            if v1 ~= nil then
                v1:removeMapGuideEffect()
            end
        end
    end
end

function CaptureResource:moveToOnePos( mapIndex, posX, posY )
    -- print("------------", mapIndex, posX, posY)
    local mapHor = math.ceil(mapIndex%3)
    local mapVer = math.ceil(mapIndex/3)
    if mapHor == 0 then
        mapHor = 3
    end

    local sceneHor = math.ceil(posX/3)
    local sceneVer = math.ceil(posY/8)
    if sceneVer == 0 then
        sceneVer = 3
    end

    local sceneMoveHorIndex = math.ceil(posX%3)
    if sceneMoveHorIndex == 0 then
        sceneMoveHorIndex = 3
    end
    local sceneMoveVerIndex = math.ceil(posY%8)
    if sceneMoveVerIndex == 0 then
        sceneMoveVerIndex = 8
    end
    -- 地图内根据实际坐标移动
    local currentScenePosX = (sceneMoveHorIndex - 0.5) * CaptureResourceBuild.__size.width
    local currentScenePosY = CaptureResource._BaseHeight - (sceneMoveVerIndex - 0.5) * CaptureResourceBuild.__size.height/2
    -- print("..............", currentScenePosX, currentScenePosY)
    currentScenePosX = currentScenePosX - (app.screenSize.width / app.scaleFactor)/2
    currentScenePosY = currentScenePosY - (app.screenSize.height / app.scaleFactor)/2

    -- 地图移动整屏移动
    local movePosX = (mapHor - 1) * CaptureResource._BaseWidth * 3
    local movePosY = (_ED.capture_total_open_hor_map_count - mapVer) * CaptureResource._BaseHeight * 3
    -- print("-------", mapHor, mapVer, sceneHor, sceneVer, movePosX, movePosY)
    movePosX = movePosX + (sceneHor - 1) * CaptureResource._BaseWidth
    movePosY = movePosY + (3 - sceneVer) * CaptureResource._BaseHeight
    -- print("-------=========", movePosX, movePosY)
    
    -- 总移动值
    movePosX = -(movePosX + currentScenePosX)
    movePosY = -(movePosY + currentScenePosY)

    if movePosX <= app.screenSize.width / app.scaleFactor - self.Panel_map:getContentSize().width then
        movePosX = app.screenSize.width / app.scaleFactor - self.Panel_map:getContentSize().width
    elseif movePosX >= 0 then
        movePosX = 0
    end
    if movePosY <= app.screenSize.height / app.scaleFactor - self.Panel_map:getContentSize().height then
        movePosY = app.screenSize.height / app.scaleFactor - self.Panel_map:getContentSize().height
    elseif movePosY >= 0 then
        movePosY = 0
    end
    self.Panel_map:setPosition(cc.p(movePosX, movePosY))
end

function CaptureResource:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:updateMyInfo()
end

function CaptureResource:updateMyInfo(  )
    local buildOpenInfo = zstring.split(dms.string(dms["pirates_config"], 292, pirates_config.param), ",")
	self.infoListView:removeAllItems()
    local initCount = tonumber(buildOpenInfo[1])
    local captureCount = 0
	if _ED.captureResourceInfo ~= nil then
        captureCount = table.nums(_ED.captureResourceInfo)
	end
    local names , mapinfos = self:getFuchouInfo()
    local number = 0
    if captureCount >= initCount then
        if captureCount < tonumber(_ED.open_resource_bulid_max_count) then
            local cell = CaptureResourceMyBuild:CreateBuild():init(nil)
            self.infoListView:addChild(cell)
        end
        for k,v in pairs(_ED.captureResourceInfo) do
            local cell = CaptureResourceMyBuild:CreateBuild():init(v)
            self.infoListView:addChild(cell)
        end
    else
        for i=1,initCount do
            local build = nil
            if _ED.captureResourceInfo ~= nil and captureCount >= i then
                build = _ED.captureResourceInfo[i]
            end

            local cell = nil
            if build ~= nil then
                cell = CaptureResourceMyBuild:CreateBuild():init(build)
            else
                if names == nil then
                    cell = CaptureResourceMyBuild:CreateBuild():init(build,nil,nil,-1)
                else
                    -- print("====----------------------===---------------------",names[i],mapinfos[i],number)
                    number = number + 1
                    cell = CaptureResourceMyBuild:CreateBuild():init(build,names[number],mapinfos[number],number)
                end
                
            end
            self.infoListView:addChild(cell)
        end
    end
    self:updateAddTimesInfo()
    self.infoListView:requestRefreshView()
end

function CaptureResource:getFuchouInfo()
    --没有未读邮件时，不会再提示复仇
    if zstring.tonumber(_ED.no_read_mail_cont) == 0 or zstring.tonumber(_ED.no_read_mail_cont) == -1 then
        return nil , nil , nil
    end 
    local table_len = #_ED.mail_item
    local name = {}
    local mapinfo = {}
    local number = 0
    local result = sortEmailForTime()
    -- debug.print_r(_ED.mail_item)
    -- debug.print_r(result)
    for i,v in pairs(result) do
        if i <= tonumber(_ED.no_read_mail_cont) then
            if tonumber(result[i].mailChannelChildType) == 19 then
                local info = result[i].mailContent
                local table1 = zstring.split(info,"|")

                local table2 = zstring.split(table1[3],"%%")  
                -- print("=======0000000===",table2[1],result[i].mailInfo)
                local map_table = zstring.split(result[i].mailInfo,",")
                local _map_index = map_table[1]
                local _pos_x = map_table[2]
                local _pos_y = map_table[3]
                if checkIsMyBuild(_map_index,_pos_x,_pos_y) == true then
                    table.insert(name,table2[1])
                    table.insert(mapinfo,result[i].mailInfo)
                    number = number + 1 
                    if number == 2 then
                        break
                    end
                end
            end
        end
    end
    -- print("==============",name,mapinfo)
    return name,mapinfo
end

function CaptureResource:updateBuildInfo( params )
    for k,v in pairs(params) do
        local hor = math.ceil(v.map_index%3)
        local ver = math.ceil(v.map_index/3)
        if hor == 0 then
            hor = 3
        end
        local mapLayer = self.layerList[ver][hor]
        if mapLayer ~= nil then
            mapLayer:updateBuild(v)
        end
    end
end

function CaptureResource:onUpdate(dt)
    if self.Panel_map == nil then
        return
    end
    local mapPositionX = math.abs(self.Panel_map:getPositionX())
    local mapPositionY = math.abs(self.Panel_map:getPositionY())
    for k,v in pairs(self.layerList) do
        for k1,v1 in pairs(v) do
            v1:changeLoadState(self.Panel_map:getPositionX(), self.Panel_map:getPositionY(), self)
        end
    end
    local mapPosX = mapPositionX%(CaptureResource._BaseWidth * 3)
    local mapPosY = (mapPositionY + app.screenSize.height / app.scaleFactor)%(CaptureResource._BaseHeight * 3)
    local mapIndexX = math.ceil(mapPositionX/(CaptureResource._BaseWidth * 3))
    if mapIndexX == 0 then
        mapIndexX = 1
    end
    local mapIndexY = math.ceil((mapPositionY + app.screenSize.height / app.scaleFactor)/(CaptureResource._BaseHeight * 3))
    mapIndexY = _ED.capture_total_open_hor_map_count + 1 - mapIndexY
    local posx = math.ceil(mapPosX/CaptureResourceBuild.__size.width + 0.5)
    local posy = math.ceil(mapPosY*2/CaptureResourceBuild.__size.height)
    if posy == 0 then
        posy = 24
    end
    posy = 25 - posy
    -- print("----------", mapIndexX, mapIndexY, posx, posy)
    if self.map_posX ~= mapIndexX or self.map_posY ~= mapIndexY then
        self.map_posX = mapIndexX
        self.map_posY = mapIndexY
        local result = self.map_posX + (self.map_posY - 1) * 3
        self.Panel_map_name:setBackGroundImage(string.format("images/ui/play/secret_society/map_name_%s.png", result))
        local mapIndex = self.map_posX + (self.map_posY - 1) * 3
        self.Text_map_id:setString("00"..mapIndex)
    end
    self.Text_xy_y:setString("x:"..posx.." , y:"..posy)
end

function CaptureResource:updateRightInfoVisible( isShow )
    local action = self.actions[1]
	if isShow == true then
		action:play("wodipanxinxi_1", false)
	else
		action:play("wodipanxinxi_2", false)
	end
end

function CaptureResource:updateMap( ... )
    self.Panel_map:removeAllChildren(true)
    self.layerList = {}
    local totalWidth = 0
    local totalHeight = 0
    local mapIndex = 0
    for i=1,_ED.capture_total_open_hor_map_count do
        local horList = {}
        for j=1,3 do
            mapIndex = mapIndex + 1
            local layer = CaptureResourceLayer:CreateLayer():init(mapIndex, self)
            self.Panel_map:addChild(layer)
            totalWidth = layer:getContentSize().width * j
            totalHeight = layer:getContentSize().height * i
            layer:setPosition(layer:getContentSize().width*(j - 1), layer:getContentSize().height*(_ED.capture_total_open_hor_map_count - i))
            table.insert(horList, layer)
        end
        table.insert(self.layerList, horList)
    end
    self.Panel_map:setContentSize(cc.size(totalWidth, totalHeight))
    self.Panel_map:setPosition(0, app.screenSize.height / app.scaleFactor - totalHeight)
end

function CaptureResource:onEnterTransitionFinish( ... )
    local oneLinePos = zstring.split(capture_resource[1], ",")
    local secondLinePos = zstring.split(capture_resource[2], ",")
    local baseWidth = math.abs(oneLinePos[1] - secondLinePos[1])
    local baseHeight = math.abs(oneLinePos[2] - secondLinePos[2])
    CaptureResourceBuild.__size = {width = 2*baseWidth, height = 2*baseHeight}
    _ED.capture_push_info = false 
    self:onLoad()
    local homeWindow = fwin:find("HomeClass")
    if homeWindow ~= nil and homeWindow:isVisible() == true then
        homeWindow:setVisible(false)
    end

    local csbSociety = csb.createNode("secret_society/secret_society.csb")
    local root = csbSociety:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSociety)
    self:setContentSize(root:getContentSize())
    
    local action = csb.createTimeline("secret_society/secret_society.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("wodipanxinxi_1", false)

    local Button_dipan_1 = ccui.Helper:seekWidgetByName(root, "Button_dipan_1")
    local Button_dipan_2 = ccui.Helper:seekWidgetByName(root, "Button_dipan_2")
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "wodipanxinxi_2_over" then
            Button_dipan_1:setVisible(true)
            Button_dipan_2:setVisible(false)
        elseif str == "wodipanxinxi_1_over" then
            Button_dipan_1:setVisible(false)
            Button_dipan_2:setVisible(true)
        end
    end)
    self.Text_xy_y = ccui.Helper:seekWidgetByName(root, "Text_xy_y")
    self.Text_map_id = ccui.Helper:seekWidgetByName(root, "Text_map_id")
    self.Panel_map_name = ccui.Helper:seekWidgetByName(root, "Panel_map_name")
    self.infoListView = ccui.Helper:seekWidgetByName(root, "ListView_wodedipan")
    self.Panel_map = ccui.Helper:seekWidgetByName(root, "Panel_map")
    self:updateMap()

    local Panel_youjian_light = ccui.Helper:seekWidgetByName(root,"Panel_youjian_light")
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_capture_shine",
    _widget = Panel_youjian_light,
    _invoke = nil,
    _interval = 0.5,})
    local function mapTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
            self.began_position = cc.p(sender:getPosition())
        elseif eventType == ccui.TouchEventType.moved then
            local posX = (__mpoint.x - __spoint.x) + self.began_position.x
            local posY = (__mpoint.y - __spoint.y) + self.began_position.y
            if posX <= (app.screenSize.width / app.scaleFactor - sender:getContentSize().width) then
                posX = (app.screenSize.width / app.scaleFactor - sender:getContentSize().width)
            elseif posX >= 0 then
                posX = 0
            end
            if posY <= (app.screenSize.height / app.scaleFactor - sender:getContentSize().height) then
                posY = (app.screenSize.height / app.scaleFactor - sender:getContentSize().height)
            elseif posY >= 0 then
                posY = 0
            end
            self:removeGuideEffect()
            sender:setPosition(cc.p(posX, posY))
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
        end
    end
    self.Panel_map:addTouchEventListener(mapTouchListener)

    local myFristBuild = _ED.captureResourceInfo[1]
    if myFristBuild ~= nil then
        self:moveToOnePos(myFristBuild.map_index, myFristBuild.pos_x, myFristBuild.pos_y)
    end

    local Button_emil = ccui.Helper:seekWidgetByName(root, "Button_emil")
    fwin:addTouchEventListener(Button_emil, nil, 
    {
        terminal_name = "society_email_button_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, 
    { 
        _terminal_name = "push_notification_center_mall_all",
        _widget = Button_emil,
        _invoke = nil,
        _interval = 0.5,
    })

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shuoming"), nil, 
    {
        terminal_name = "society_shuoming_button_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_map_ui_back"), nil, 
    {
        terminal_name = "capture_resource_return_home", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_xiangyin"), nil, 
    {
        terminal_name = "capture_resource_search_pos_capture", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(Button_dipan_1, nil, 
    {
        terminal_name = "society_open_info_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(Button_dipan_2, nil, 
    {
        terminal_name = "society_close_info_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "capture_resource_add_capture_times", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jiangli"), nil, 
    {
        terminal_name = "capture_resource_reward_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_paihang"), nil, 
    {
        terminal_name = "capture_resource_rank_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)   

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_capture_get_reward",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_paihang"),
    _invoke = nil,
    _interval = 0.5,})
    self:updateDraw()

    state_machine.unlock("capture_resource_open")

    if _ED._capture_resource_fight_win ~= nil then
        if tonumber(_ED._capture_resource_fight_win) == 0 then
            -- TipDlg.drawTextDailog(_string_piece_info[400])
        else
            TipDlg.drawTextDailog(_string_piece_info[399])
        end
    end
    _ED._capture_resource_fight_win = nil
end

function CaptureResource:close()
    for k,v in pairs(self.layerList) do
        for k1,v1 in pairs(v) do
            v1:removeFromParent(true)
        end
    end
    self.layerList = {}
    self.Panel_map:removeAllChildren(true)
    cacher.destoryRefPools()
    cacher.removeAllTextures()
    cacher.cleanSystemCacher()
    if fwin:find("GameTipDialogClass") ~= nil then
        fwin:close(fwin:find("GameTipDialogClass"))
    end   
end

function CaptureResource:onExit()
    self:unLoad()
	state_machine.remove("capture_resource_return_home")
	state_machine.remove("society_email_button_touch")
	state_machine.remove("society_shuoming_button_touch")
	state_machine.remove("society_open_info_touch")
	state_machine.remove("society_close_info_touch")
    state_machine.remove("goto_once_capture_resource")
    state_machine.remove("capture_resource_search_capture")
    state_machine.remove("capture_resource_search_pos_capture")
    state_machine.remove("capture_resource_begin_search_capture")
    state_machine.remove("capture_resource_begin_search_pos")
    state_machine.remove("capture_resource_update_ower_info")
    state_machine.remove("capture_resource_update_layer_build_info")
    state_machine.remove("capture_resource_add_capture_times")
    state_machine.remove("capture_resource_update_notice")
    state_machine.remove("goto_once_capture_for_fuchou")
end

function CaptureResource:onLoad()
    local effect_paths = "images/ui/effice/effice_arrow_up_1/effice_arrow_up_1.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_qiangduo_zhiying/effect_qiangduo_zhiying.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end

function CaptureResource:unLoad()
    local effect_paths = "images/ui/effice/effice_arrow_up_1/effice_arrow_up_1.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_qiangduo_zhiying/effect_qiangduo_zhiying.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
end