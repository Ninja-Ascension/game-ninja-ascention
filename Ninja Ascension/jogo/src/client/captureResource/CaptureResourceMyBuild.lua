
CaptureResourceMyBuild = class("CaptureResourceMyBuildClass", Window)

function CaptureResourceMyBuild:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.buildInfo = nil
    self.current_time = nil
    self.last_time = 0
    self.name = nil
    self.mapinfo = nil
    self.number = nil
    self.index = nil
    local function init_capture_resource_my_build_terminal()
        local selected_society_build_terminal = {
            _name = "selected_society_build",
            _init = function (terminal)
                app.load("client.captureResource.CaptureResourceInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local myBuildInfo = params.buildInfo
                instance:onTouchBuild(myBuildInfo)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local captureresource_mybuild_goto_fuchou_terminal = {
            _name = "captureresource_mybuild_goto_fuchou",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _self = params._datas.cell
                _self:goToFuchou()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(selected_society_build_terminal)
        state_machine.add(captureresource_mybuild_goto_fuchou_terminal)
        state_machine.init()
    end
    init_capture_resource_my_build_terminal()
end

function CaptureResourceMyBuild:onTouchBuild( buildInfo )
    if buildInfo ~= nil then
        local posX = buildInfo.pos_x
        local posY = buildInfo.pos_y
        local mapBuild = _ED.capture_resource_build_info[""..buildInfo.map_index][posY.."-"..posX]
        state_machine.excute("goto_once_capture_resource", 0, {mapBuild = mapBuild, info = buildInfo})
    else
        state_machine.excute("capture_resource_search_capture", 0, nil)
    end        
end

function CaptureResourceMyBuild:onUpdate( dt )
    if self.timeText == nil or self.current_time == nil then 
        return
    end
    
    local time = self.current_time - os.time()
    if time >= 0 and self.last_time - time >= 1 then
        self.last_time = time
        self.timeText:setString(getTimeDesByIntervalEx(time))
    end
    
    if time <= -2 then
        self:unregisterOnNoteUpdate(self)
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                TipDlg.drawTextDailog(_string_piece_info[398])
                state_machine.excute("capture_resource_info_close", 0, nil)
            end
        end
        local posX = tonumber(self.buildInfo.pos_x) - 1
        local posY = tonumber(self.buildInfo.pos_y) - 1
        protocol_command.hold_view.param_list = self.buildInfo.map_index.."\r\n"..posX..","..posY
        NetworkManager:register(protocol_command.hold_view.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function CaptureResourceMyBuild:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end

    local buildData = dms.element(dms["grab_build_param"], self.buildInfo.build_id)
    local buildName = dms.atos(buildData, grab_build_param.build_name)
    local max_hold_time = dms.atos(buildData, grab_build_param.max_hold_time)
    local iconPath = "images/ui/play/secret_society/secret_city_"..self.buildInfo.build_id..".png"
    ccui.Helper:seekWidgetByName(root, "Panel_city"):setBackGroundImage(iconPath)
    ccui.Helper:seekWidgetByName(root, "Text_city_name"):setString(buildName)
    self.current_time = self.buildInfo.capture_time/1000
    -- local total_time = (self.buildInfo.extend_count + 1) * tonumber(max_hold_time) * 3600
    -- self.current_time = self.current_time - total_time
    self.last_time = self.current_time
    app.load("client.utils.TimeUtil")
end

function CaptureResourceMyBuild:addPushIcon(Panel_zhanling)
    local ball = cc.Sprite:create("images/ui/bar/tips.png")
    ball:setAnchorPoint(cc.p(1, 1))
    ball:setPosition(cc.p(Panel_zhanling:getContentSize().width-5, Panel_zhanling:getContentSize().height+3))
    Panel_zhanling:addChild(ball)
end

function CaptureResourceMyBuild:initDraw()
	local csbSocietyIcon = csb.createNode("secret_society/secret_society_icon.csb")
    local root = csbSocietyIcon:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocietyIcon)

    local Panel_city_kong = ccui.Helper:seekWidgetByName(root, "Panel_city_kong")
    local Panel_city = ccui.Helper:seekWidgetByName(root, "Panel_city")
    self:setContentSize(root:getContentSize())
    local Panel_fuchou = ccui.Helper:seekWidgetByName(root,"Panel_fuchou")
    Panel_fuchou:setVisible(false)    
    local touchPanel = nil

    if self.buildInfo ~= nil then
        Panel_city_kong:setVisible(false)
        Panel_city:setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_1_0"):setVisible(true)
        touchPanel = Panel_city
    else
        Panel_city_kong:setVisible(true)
        Panel_city:setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_1_0"):setVisible(false)
        touchPanel = Panel_city_kong
        local Panel_zhanling = ccui.Helper:seekWidgetByName(root, "Panel_zhanling")
        self:addPushIcon(Panel_zhanling)

        self.fuchoupanel = Panel_fuchou
        --如果外面没有传入地图信息，说明是通过单独创建的方式，添加的建筑，默认为nil 的。这种情况，自己匹配，是否有复仇，地图信息
        if self.mapinfo == nil and self.number == nil then
            self:getFuchouInfo()
        end
        self:addTouchFuchou()
        
        -- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_capture_shine",
        -- _widget = Panel_fuchou,
        -- _invoke = nil,
        -- _interval = 0.5,})        
    end                                                        
    local function panelCityTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 3 and math.abs(__spoint.y - __epoint.y) <= 3 then
                state_machine.excute("selected_society_build", 0, self)
            end
        end
    end

    touchPanel:addTouchEventListener(panelCityTouchListener)
    -- fwin:addTouchEventListener(Panel_city, nil, 
    -- {
    --     terminal_name = "selected_society_build", 
    --     terminal_state = 0,
    --     cell = self,
    --     isPressedActionEnabled = true
    -- }, 
    -- nil, 0)
    
    self.timeText = ccui.Helper:seekWidgetByName(root, "Text_1_0_0")

    touchPanel:setSwallowTouches(false)
    self:setSwallowTouches(false)
    
    if self.buildInfo ~= nil then
        self:updateDraw()
        self:registerOnNoteUpdate(self, 0.5)
    end
end

function CaptureResourceMyBuild:getFuchouInfo()
    --没有未读邮件时，不会再提示复仇
    if zstring.tonumber(_ED.no_read_mail_cont) == 0 or zstring.tonumber(_ED.no_read_mail_cont) == -1 then
        return false
    end 
    if self.number == -1 then
        return
    end
    local result = sortEmailForTime()
    -- print("=====if=======",self.number)
    --此时可能会出现两个复仇按钮，分别指向不同的对象。如果number有值，用下面的办法处理，与上层匹配
    if self.number == nil then
        local table_len = #_ED.mail_item
        for i,v in pairs(_ED.mail_item) do
            if tonumber(result[i].mailChannelChildType) == 19 then
                local info = result[i].mailContent
                local table1 = zstring.split(info,"|")

                local table2 = zstring.split(table1[3],"%%")  

                local map_table = zstring.split(result[i].mailInfo,",")
                local _map_index = map_table[1]
                local _pos_x = map_table[2]
                local _pos_y = map_table[3]
                if checkIsMyBuild(_map_index,_pos_x,_pos_y) == true then
                    self.name = table2[1]
                    self.mapinfo = result[i].mailInfo
                end
                -- print("========11111获得到的",table2[1],result[i].mailInfo)
                break
            end
        end

    else
        local table_len = #_ED.mail_item
        local name = {}
        local mapinfo = {}
        for i,v in pairs(result) do
            if tonumber(result[i].mailChannelChildType) == 19 then
                local info = result[i].mailContent
                local table1 = zstring.split(info,"|")
                local table2 = zstring.split(table1[3],"%%")  
                if self.number == i then
                    local map_table = zstring.split(result[i].mailInfo,",")
                    local _map_index = map_table[1]
                    local _pos_x = map_table[2]
                    local _pos_y = map_table[3]
                    if checkIsMyBuild(_map_index,_pos_x,_pos_y) == true then                    
                        self.name = table2[1]
                        self.mapinfo = result[i].mailInfo
                        break
                    end
                end
            end
        end
    end
    -- print("=======最后得到的",self.name,self.mapinfo)
end

function CaptureResourceMyBuild:addTouchFuchou( ... )
    local root = self.roots[1]
    local Button_fuchou_1 = ccui.Helper:seekWidgetByName(root,"Button_fuchou_1")
    local Text_fuchou = ccui.Helper:seekWidgetByName(root,"Text_fuchou")
    local Panel_fuchou = ccui.Helper:seekWidgetByName(root,"Panel_fuchou")

    fwin:addTouchEventListener(Button_fuchou_1,  nil, 
    {
        terminal_name = "captureresource_mybuild_goto_fuchou",   
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    Text_fuchou:setColor(cc.c3b(255, 0, 0))
    --print("========9090909090909090909090909090909090909090909090909090909=====",self.name ,self.mapinfo)
    if self.name ~= nil and self.mapinfo ~= nil then
        Text_fuchou:setString(self.name)
        Panel_fuchou:setVisible(true)  
    else
        Panel_fuchou:setVisible(false)  
    end
end

function CaptureResourceMyBuild:goToFuchou( ... )
    -- print("========准备匹配")
    if self.mapinfo == nil then
        -- print("========没有地图信息")
        return
    end

    local map_table = zstring.split(self.mapinfo,",")
    local _map_index = map_table[1]
    local _pos_x = map_table[2]
    local _pos_y = map_table[3]
    -- print("============去匹配",_map_index , _pos_x , _pos_y )
    state_machine.excute("goto_once_capture_for_fuchou",0,{map_index = _map_index ,pos_x = _pos_x ,pos_y = _pos_y })
    
end


function CaptureResourceMyBuild:onEnterTransitionFinish()
	
end

function CaptureResourceMyBuild:init( info , name , mapinfo , number,index)
    self.buildInfo = info
    self.name = name
    self.mapinfo = mapinfo
    self.number = number
    -- print("=============",info , name , mapinfo , number,index)
    self:initDraw()

    return self
end

function CaptureResourceMyBuild:onExit()
	state_machine.remove("selected_society_build")
end

function CaptureResourceMyBuild:CreateBuild( ... )
    local cell = CaptureResourceMyBuild:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
