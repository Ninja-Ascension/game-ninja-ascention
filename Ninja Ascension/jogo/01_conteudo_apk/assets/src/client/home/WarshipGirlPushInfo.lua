---------------------------------------------------------------------------------------------
-- 说明：舰娘跑马灯文件 --龙虎门也在用
---------------------------------------------------------------------------------------------

WarshipGirlPushInfo = class("WarshipGirlPushInfoClass", Window)
WarshipGirlPushInfo.panel_PosX = nil
WarshipGirlPushInfo.panel_PosY = nil
local warship_girl_push_info_open_terminal = {
    _name = "warship_girl_push_info_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece then
        	return
        end
       	local WarshipGirlPushInfoWindow = fwin:find("WarshipGirlPushInfoClass")
        if WarshipGirlPushInfoWindow ~= nil and WarshipGirlPushInfoWindow:isVisible() == true then
            return true
        elseif WarshipGirlPushInfoWindow ~= nil and WarshipGirlPushInfoWindow:isVisible() == false then 
        	WarshipGirlPushInfoWindow:setVisible(true)
        	return true
        end
        state_machine.lock("warship_girl_push_info_open", 0, "")
        local cell = WarshipGirlPushInfo:createCell()
        fwin:open(cell:init(params),fwin._notification)
        return cell

    end,
    _terminal = nil,
    _terminals = nil
}

local warship_girl_push_info_close_terminal = {
    _name = "warship_girl_push_info_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
      	 WarshipGirlPushInfo:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(warship_girl_push_info_open_terminal)
state_machine.add(warship_girl_push_info_close_terminal)
state_machine.init()

function WarshipGirlPushInfo:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.group = {}

    self.__cdt = 1

    self.GmInfoCount = 0
    self.PlayerInfoCount = 0

    self.cdTime = 1
    self.isPlayGmInfo = false
    self.isPlayGmInfoId = nil
    self.willPalyTable = {} -- 要被播放的队列


    self.PlayerDt = 1
    self.isPlayPlayerInfo = false

    self.openType = 0
	self.image_view = nil
    self.now_time = nil

    if __lua_project_id == __lua_project_red_alert 
    	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
    	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
    	then
    	self.send_information = _ED.push_send_information
    else
    	self.send_information = _ED.send_information
    end

    -- debug.print_r(self.send_information)
    -- print("self.send_information初始值")
    -- Initialize WarshipGirlPushInfo page state machine.
    local function init_warship_girl_push_info_terminal()
       -- 隐藏界面
        local warship_girl_push_info_hide_event_terminal = {
            _name = "warship_girl_push_info_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local warship_girl_push_info_event_terminal = {
            _name = "warship_girl_push_info_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --接收刷新数据
          local warship_girl_update_info_event_terminal = {
            _name = "warship_girl_update_info_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               -- print("输出刷新数据")
				self.send_information = _ED.push_send_information
				--debug.print_r(self.send_information)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
       

        state_machine.add(warship_girl_push_info_hide_event_terminal)
        state_machine.add(warship_girl_push_info_event_terminal)
        state_machine.add(warship_girl_update_info_event_terminal)
        state_machine.init()
    end
    
    -- call func init WarshipGirlPushInfo state machine.
    init_warship_girl_push_info_terminal()
end
function WarshipGirlPushInfo:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function WarshipGirlPushInfo:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function WarshipGirlPushInfo:cutStringInfo(str, height, fontSize, fontname)
	--print("=========self.send_information.system_info_params======",self.send_information.system_info_params)
  --    local str1 = zstring.split(self.send_information[1].system_info_params,"<")
  --    if then
  --    end
	 -- local str2 = zstring.split(str1[2],">")
    --   debug.print_r(str2)
   


	local defcolor1 = nil
	local defcolor2 = nil
	local qualitycolor = nil
	if  __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		then
		defcolor1 = cc.c3b(255, 255, 255)
		defcolor2 = cc.c3b(255, 255, 255)
		qualitycolor = tipStringInfo_quality_color_Type
	else
		defcolor1 = cc.c3b(216, 124, 42)
		defcolor2 = cc.c3b(255, 255, 255)
		qualitycolor = color_Type
	end
    local mRoot = ccui.RichText:create()
    fontSize = fontSize or 10
    local l = string.len(str)
    mRoot:ignoreContentAdaptWithSize(false)
    local count = 0

    while (l > 0) do
      
        local f,e = string.find(str, "%%%C-%%")
        if f == nil or e == nil then
            local re = nil
            re = ccui.RichElementText:create(1, defcolor1, 255, str, fontname, fontSize)
            mRoot:pushBackElement(re)
            count = count + zstring.utfstrlen(str)
            break
        end
        if f > 1 then
            local strsub = string.sub(str, 1, f-1)
            count = count + zstring.utfstrlen(strsub)

            local re = nil
            re = ccui.RichElementText:create(1, defcolor2, 255, strsub, fontname, fontSize)
       
            mRoot:pushBackElement(re)
        end
        local name = string.sub(str, f+1, e-1)
        local f1, e1 = string.find(name, "%d+")
        if name == nil or f1 == nil or e1 == nil then
        	if mRoot.removeAllChildrenWithCleanup ~= nil then
	            mRoot:removeAllChildrenWithCleanup(true)
	        end
            break
        end
        local quality = string.sub(name, f1, e1)
        local color = tonumber(quality)+1
        name = string.sub(name, e1+2, string.len(name))
        count = count + zstring.utfstrlen(name)
        if color == nil or color <= 0 or color > 11 then
        	if mRoot.removeAllChildrenWithCleanup ~= nil then
	            mRoot:removeAllChildrenWithCleanup(true)
	        end
            break
        end
        local re1 = nil
        if ___is_open_leadname == true then
        	re1 = ccui.RichElementText:create(1, cc.c3b(qualitycolor[color][1],qualitycolor[color][2],qualitycolor[color][3]), 255, name, "", fontSize)
        else
        	re1 = ccui.RichElementText:create(1, cc.c3b(qualitycolor[color][1],qualitycolor[color][2],qualitycolor[color][3]), 255, name, fontname, fontSize)
        end
        mRoot:pushBackElement(re1)
        str = string.sub(str, e+1, l)
        l = string.len(str)
    end
    if width ~= nil and width > 0 then
        mRoot:setContentSize(cc.size(width+15, height+20))
    else
        mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
    end
  --   if str2[2]  then
	 --    local path = string.format("images/ui/text/title/%d.png", str2[2])
		-- local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
	 --    mRoot:pushBackElement(reimg)
  --   end	
 
    return mRoot, count
end

function WarshipGirlPushInfo:setRichText(chat_info)
	local root = self.roots[1]
    local Text_chat_infor = ccui.Helper:seekWidgetByName(root, "Label_312")
 
    local char_str = chat_info.information_content
    local str = chat_info.send_information_name
    local pic_type = chat_info.information_type
    if tonumber(chat_info.information_type) == 0 
        or (tonumber(chat_info.send_information_id) == 0 
            and tonumber(chat_info.system_info_id) ~= 45
            and tonumber(chat_info.system_info_id) ~= 47)
        then
        str = _new_interface_text[74]
        pic_type = 0
    end
    if tonumber(chat_info.information_type) == 5 then
        pic_type = 1
    elseif tonumber(chat_info.information_type) == 6 then
        pic_type = 2
    end
    local image_str = "/"..pic_type.."|   "
    char_str = image_str.."%|2|["..str.."]%"..char_str
    local max_width = 0
    local fontSize = Text_chat_infor:getFontSize() or 24
    Text_chat_infor:setString("")
    Text_chat_infor:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = fontSize*40 + 15
    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local fontsName = Text_chat_infor:getFontName()
    if verifySupportLanguage(_lua_release_language_zh_TW) == false then
        fontsName = ""
    else
        fontsName = Text_chat_infor:getFontName()
    end
  --  print("fontsName is",fontsName)
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(224, 224, 224)
        color_Type_2 = cc.c3b(224, 224, 224)
    else
        color_Type_1 = cc.c3b(189, 206, 224)
        color_Type_2 = cc.c3b(189, 206, 224)
    end
     
    char_str = smWidthSingle(char_str,Text_chat_infor:getFontSize()/2,Text_chat_infor:getContentSize().width)
   -- print(char_str,"char_str is")
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    fontsName, 
    Text_chat_infor:getFontSize(),
    chat_rich_text_color,true)
    -- if _ED.is_can_use_formatTextExt == false then
    --     _richText2:setPositionX( - _richText2:getContentSize().width / 2 )
    -- else
    --     _richText2:formatTextExt()
    -- end
  --  print(_richText2:getPositionX(),_richText2:getPositionY(),"输出位置X,Y")

    --print(_richText2:getContentSizeX(),_richText2:getContentSizeY())
    return _richText2

    --如果formatTextExt不能用 重新计算高度和位置
    -- if _ED.is_can_use_formatTextExt == false then
    --     local heightN = math.ceil( max_width / tonumber(_richText2:getContentSize().width))
    --     local height = heightN * 19
    -- end
end

function WarshipGirlPushInfo:onUpdateDrawGmInfo()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local image = self._GmInfoLayer

	local fontSize = 20/CC_CONTENT_SCALE_FACTOR()
	local _rootm = self._GmInfoLayer:getContentSize()
	if image:getChildByTag(1) ~= nil then
		image:removeChildByTag(1) 
	end
	local hasAction = false

	local function playGmInfoOver( ... )
		if self.isPlayGmInfoId ~= nil and  _ED.gm_push_info_table[self.isPlayGmInfoId] ~= nil and _ED.gm_push_info_table[self.isPlayGmInfoId] ~= "" then
			_ED.gm_push_info_table[self.isPlayGmInfoId].play_time = tonumber(os.time())
		end
		self:onUpdateDrawGmInfo()
	end

	for i, v in pairs(self.willPalyTable) do
		if v ~= nil then
			hasAction = true
			local tableInfo = _ED.gm_push_info_table[tonumber(v)]
			self.isPlayGmInfoId = tonumber(v)
			table.remove(self.willPalyTable, i)
			if tableInfo ~= nil and tableInfo ~= "" then
				-- local str = tableInfo.information_content
				local _richText = self:setRichText(tableInfo)
				local fontname = ccui.Helper:seekWidgetByName(root, "Label_312"):getFontName()
				-- local _richText, l = self:cutStringInfo(str, _rootm.height, fontSize, fontname)
				local theW = _richText:getContentSize().width
				local time = (theW + _rootm.width)*0.016
				_richText:setAnchorPoint(cc.p(0.5, 0.5))
				local _pos = cc.p(_richText:getPositionX() -  theW/2, _richText:getPositionY())
				local action  = cc.MoveTo:create(time, _pos)
				_richText:setOpacity(100)
				_richText:setTag(1)
				self._GmInfoLayer:addChild(_richText, 100)
				_richText:setPosition(cc.p(_rootm.width + theW/2, _richText:getPositionY()))
				_richText:runAction( cc.Sequence:create(action,cc.CallFunc:create(playGmInfoOver))) 
				break
			end
		end
	end
	self.isPlayGmInfo = hasAction
	if self.isPlayGmInfo == true then
		self._GmInfoLayer:setVisible(true)
	else
		self._GmInfoLayer:setVisible(false)
	end
end
function WarshipGirlPushInfo:onUpdateDrawPlayerInfo()
	--print("刷新显示跑马灯信息")
	local root = self.roots[1]
	if root == nil or self._PlayerInfoLayer == nil then
		return
	end
	local image = self._PlayerInfoLayer
	if image:getChildByTag(1) == nil then
		local fontSize = 20/CC_CONTENT_SCALE_FACTOR()
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
		fontSize = 22
	end
		local _rootm = image:getContentSize()

		local index = 1
		local hasAction = false
		local function playerInfoOver( sender )
			-- self._PlayerInfoLayer:removeChildByTag(1)
			sender:removeFromParent(true)
			table.remove(self.send_information, index)
			self:onUpdateDrawPlayerInfo()
		end
		self.send_information = self.send_information or {}
		-- if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece  then
		-- 	if #self.send_information > 0 then
		-- 		for i=1,#self.send_information - 1 do
		-- 			table.remove(self.send_information, 1)
		-- 		end
		-- 	end
		-- end
		
		for i, v in pairs(self.send_information) do
		-- debug.print_r(v)
		-- print("============",v.information_type)
			if tonumber(v.information_type) == 7 then
				hasAction = true
				index = i
				local str = v.information_content
				local fontname = ccui.Helper:seekWidgetByName(root, "Label_312"):getFontName()
				local _richText = self:setRichText(v)

				local theW = _richText:getContentSize().width
				local time = (theW + _rootm.width)*0.01
				_richText:setAnchorPoint(cc.p(0.5, 0.5))
				local _pos = cc.p(_richText:getPositionX() -  theW/2, _richText:getPositionY())
				local action  = cc.MoveTo:create(time, _pos)
				_richText:setOpacity(100)
				_richText:setTag(1)
				image:addChild(_richText, 100)
				_richText:setPosition(cc.p(_rootm.width + theW/2, _richText:getPositionY()))
				_richText:runAction( cc.Sequence:create(action,cc.CallFunc:create(playerInfoOver))) 
				break
			end
			-- print("=ipen",self.openType)
			if  __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				if tonumber(v.information_type) == 0  
					and self.openType ~= 7 then
					hasAction = true
					index = i
					local str = v.information_content
					local fontname = ccui.Helper:seekWidgetByName(root, "Label_312"):getFontName()
					local _richText, l = self:cutStringInfo(str, _rootm.height, fontSize, fontname)
					local theW = _richText:getContentSize().width
					local time = (theW + _rootm.width)*0.01
					_richText:setAnchorPoint(cc.p(0.5, 0.5))
					local _pos = cc.p(_richText:getPositionX() -  theW/2, _richText:getPositionY())
					local action  = cc.MoveTo:create(time, _pos)
					_richText:setOpacity(100)
					_richText:setTag(1)
					image:addChild(_richText, 100)
					_richText:setPosition(cc.p(_rootm.width + theW/2, _richText:getPositionY()))
					_richText:runAction( cc.Sequence:create(action,cc.CallFunc:create(playerInfoOver))) 
					break
				end
			else
				if tonumber(v.information_type) == 0 
					and tonumber(v.send_information_id) == 0 
					and self.openType ~= 7 then
					hasAction = true
					index = i
					local str = v.information_content
					local fontname = ccui.Helper:seekWidgetByName(root, "Label_312"):getFontName()
					local _richText = self:setRichText(v)
					local theW = _richText:getContentSize().width
				
					local time = (theW + _rootm.width)*0.01
					_richText:setAnchorPoint(cc.p(0.5, 0.5))
					local _pos = cc.p(_richText:getPositionX() -  theW/2, self.image_view:getContentSize().height/2+14)
					local action  = cc.MoveTo:create(time, _pos)
					_richText:setOpacity(100)
					_richText:setTag(1)
					self.image_view:addChild(_richText, 1000)
					_richText:setPosition(cc.p(self.image_view:getContentSize().width, self.image_view:getContentSize().height/2 + 14))
					-- _richText:setPosition(cc.p(_rootm.width + theW/2, _richText:getPositionY()))
					 _richText:runAction(cc.Sequence:create(action,cc.CallFunc:create(playerInfoOver))) 
					break
				end
			end
		end
		self.isPlayPlayerInfo = hasAction
		if self.isPlayPlayerInfo == true then
			self._PlayerInfoLayer:setVisible(true)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				self.image_view:setVisible(true)
			end
		else
			self._PlayerInfoLayer:setVisible(false)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				self.image_view:setVisible(false)
			end
		end
	else
		self.isPlayPlayerInfo = false
	end
end
function WarshipGirlPushInfo:onUpdateDrawPlayerInfoDt(dt)
	if self.PlayerDt > 0 then
		self.PlayerDt = self.PlayerDt - dt
		return
	else
		self.PlayerDt = 1
	end
	if self.isPlayPlayerInfo == false then
		self:onUpdateDrawPlayerInfo()
	else
		self.isPlayPlayerInfo = true
	end
end


function WarshipGirlPushInfo:onUpdateDraw()
	local root = self.roots[1]
	if root == nil or self._GmInfoLayer == nil then
		return
	end
	local function playGmInfoOver( sender )
		sender:removeFromParent(true)
		_ED.server_push_info = ""
		self._GmInfoLayer:setVisible(false)
		self.isPlayGmInfo = false
	end
	self._GmInfoLayer:setVisible(true)
	local _rootm = self._GmInfoLayer:getContentSize()

	local fontSize = 20/CC_CONTENT_SCALE_FACTOR()
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
		fontSize = 22
	end
	local str = _ED.server_push_info
	local fontname = ccui.Helper:seekWidgetByName(root, "Label_312"):getFontName()
	local _richText, l = self:cutStringInfo(str, _rootm.height, fontSize, fontname)
	local theW = _richText:getContentSize().width
	local time = (theW + _rootm.width)*0.01
	_richText:setAnchorPoint(cc.p(0.5, 0.5))
	local _pos = cc.p(_richText:getPositionX() -  theW/2, _richText:getPositionY())
	local action  = cc.MoveTo:create(time, _pos)
	_richText:setOpacity(100)
	_richText:setTag(1)
	self._GmInfoLayer:addChild(_richText, 100)
	_richText:setPosition(cc.p(_rootm.width + theW/2, _richText:getPositionY()))
	_richText:runAction( cc.Sequence:create(action,cc.CallFunc:create(playGmInfoOver))) 
end

function WarshipGirlPushInfo:onUpdate(dt)
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim
		then
		-- local now_times = os.time()
		-- if now_times - self.now_time >= 1 then	
		if checkPushInfoOpen() == false then
			state_machine.excute("warship_girl_push_info_hide_event",0,"")
		else
			state_machine.excute("warship_girl_push_info_show_event",0,"")
		end
			-- self.now_time = now_times
		-- end


		local root = self.roots[1]
		if root == nil then
			return
		end
		local panel_root = ccui.Helper:seekWidgetByName(root,"root")
		if panel_root ~= nil then
			if fwin:find("LDuplicateWindowClass") ~= nil and fwin:find("LDuplicateWindowClass"):isVisible() == true then
				if WarshipGirlPushInfo.panel_PosY ~= nil then
					panel_root:setPositionY(WarshipGirlPushInfo.panel_PosY+67)
				end
			else
				if WarshipGirlPushInfo.panel_PosY ~= nil then
					panel_root:setPositionY(WarshipGirlPushInfo.panel_PosY)
				end				
			end
		end
	end
	if self.openType == 0 or self.openType == 7 then
		self:onUpdateDrawPlayerInfoDt(dt)
	end
	if self.cdTime > 0 then
		self.cdTime = self.cdTime - dt
		return
	else
		self.cdTime = 1
	end
	local root = self.roots[1]

	if root == nil or _ED.server_push_info == nil or _ED.server_push_info == "" then
		return
	end
	if self.isPlayGmInfo == false then
		self.isPlayGmInfo = true 
	else
		return
	end
	self:onUpdateDraw()

	if root == nil or _ED.gm_push_info_table == nil or _ED.gm_push_info_table == "" then 
		return
	end

	if self.isPlayGmInfo == true then
		return
	else
		self.isPlayGmInfo = true
	end
	local NowTime = tonumber(os.time())
	local count = 0
	self.willPalyTable = {}
	for i,v in pairs(_ED.gm_push_info_table) do 
		if v ~= nil then
			if v.begin_time < NowTime and NowTime < v.end_time then  
			-- print("NowTime - v.play_time==",NowTime - v.play_time)
				if v.play_time == 0 or (NowTime - v.play_time) >= v.space_time then
					count = count + 1
					self.willPalyTable[count] = v.id
				end
			end
		end
	end
	if count > 0 then
		self:onUpdateDrawGmInfo()
	end

end
function WarshipGirlPushInfo:onInit()
	
end
function WarshipGirlPushInfo:init(params)
	if params ~= nil and params ~= "" then
		self.openType = zstring.tonumber(params._datas._openType)
	end
	return self
end

function WarshipGirlPushInfo:onEnterTransitionFinish()
	local csbWarshipGirlPushInfoPage = csb.createNode("home/home_notice.csb")
    local root = csbWarshipGirlPushInfoPage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbWarshipGirlPushInfoPage,10000000)
    self._PlayerInfoLayer = ccui.Helper:seekWidgetByName(root, "ImageView_notice")
 	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
 		or __lua_project_id == __lua_project_red_alert 
 		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
 		then
 		local panel_root = ccui.Helper:seekWidgetByName(root,"root")
 		if WarshipGirlPushInfo.panel_PosX == nil then
	 		WarshipGirlPushInfo.panel_PosY = panel_root:getPositionY()
	 		WarshipGirlPushInfo.panel_PosX = panel_root:getPositionX()
		end
    	self._PlayerInfoLayer = ccui.Helper:seekWidgetByName(root, "Panel_20")
    	self.image_view = ccui.Helper:seekWidgetByName(root, "ImageView_notice")
    	self.image_view:setVisible(false)
	else
	    self._GmInfoLayer = ccui.Helper:seekWidgetByName(root, "ImageView_notice")      
	    self._GmInfoLayer:setVisible(false)
	    ccui.Helper:seekWidgetByName(root, "Label_312"):setVisible(false)
	end
    self._PlayerInfoLayer = ccui.Helper:seekWidgetByName(root, "ImageView_notice")
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
    	or __lua_project_id == __lua_project_red_alert 
    	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
    	then
    	self._PlayerInfoLayer = ccui.Helper:seekWidgetByName(root, "Panel_20")      
    end
    self._PlayerInfoLayer:setVisible(false)

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
    	or __lua_project_id == __lua_project_red_alert 
    	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
    	then
    	self.image_view = ccui.Helper:seekWidgetByName(root, "ImageView_notice")
    	self.image_view:setVisible(false)
    end
 
    ccui.Helper:seekWidgetByName(root, "Label_312"):setVisible(false)
     -- self._GmInfoLayer:setOpacity(100)
    self:onInit()
    state_machine.unlock("warship_girl_push_info_open", 0, "")
end

function WarshipGirlPushInfo:onExit()
	state_machine.remove("warship_girl_push_info_hide_event")
	state_machine.remove("warship_girl_push_info_show_event")
end

function WarshipGirlPushInfo:createCell( ... )
    local cell = WarshipGirlPushInfo:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function WarshipGirlPushInfo:closeCell( ... )
    local WarshipGirlPushInfo = fwin:find("WarshipGirlPushInfoClass")
    if WarshipGirlPushInfo == nil then
        return
    end
    fwin:close(WarshipGirlPushInfo)
end