
AssetsNotice = class("AssetsNoticeClass", Window)

function AssetsNotice:ctor()
	self.super:ctor()
    self.roots = {}

	local function init_assets_notice_terminal()
        local assets_notice_manager_terminal = {
            _name = "assets_notice_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(instance)
            	state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_update")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_notice_exit_game_terminal = {
            _name = "assets_notice_exit_game",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	os.exit()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(assets_notice_exit_game_terminal)
		state_machine.add(assets_notice_manager_terminal)
        state_machine.init()
    end

    init_assets_notice_terminal()
end

function AssetsNotice:onEnterTransitionFinish()
	local csbAssetsNotice = csb.createNode("utils/update_get_prompt.csb")
    self:addChild(csbAssetsNotice)

    local root = csbAssetsNotice:getChildByName("root")
	table.insert(self.roots, root)

    -- 绘制更新的公告信息
	local list = {}
    for i, v in pairs(_ED.resource_package_notices) do
        ccui.Helper:seekWidgetByName(root, string.format("Text_0%s", i + 4)):setString(zstring.exchangeFrom(v.tile .." ".. v.notice))
		table.insert(list, ccui.Helper:seekWidgetByName(root, string.format("Text_0%s", i + 4)))
    end

	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_gp_2")
	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	
	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local tHeight = 0
	local thList = {}
	for i, v in ipairs(list) do
		v:removeFromParent(false)
		panel:addChild(v)
		tHeight = tHeight + v:getContentSize().height
	end
	
	sHeight = math.max(sHeight, tHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	
    if list ~= nil and #list > 0 then
    	list[1]:setPosition(cc.p(0,sHeight))
    	
    	for i = 2, table.getn(list) do
    		list[i]:setPosition(cc.p(0,sHeight - list[i-1]:getContentSize().height))
    	end
    end
	
	m_ScrollView:jumpToTop()

    local function getDataSize()
        local totalSize = 0
        local dIdx = 0
        local downloadIndex = -1
        local package_version = cc.UserDefault:getInstance():getStringForKey("package")
        if package_version == nil or package_version == "" then
            package_version = "0"
        end
        for i, v in pairs(_ED.resource_package) do
            if dIdx >= downloadIndex then
                v.package_url = zstring.exchangeFrom(v.package_url)
                local tempData = ""..v.package_url
                tempData = zstring.replace(tempData, " ", "")
                tempData = zstring.split(tempData, "\r\n")
                if #tempData > 1 then
                    local tempUrl = tempData[1]
                    local downloadCount = 0
                    for i = 2, table.getn(tempData) do
                        local downloadData = zstring.split(tempData[i], ",")
                        if table.getn(downloadData) == 3 then
                            if zstring.tonumber(package_version) < zstring.tonumber(downloadData[2]) then
                                totalSize = totalSize + tonumber(downloadData[3])
                            end
                        end
                    end
                else
                    totalSize = totalSize + tonumber(v.package_size)
                end
            end
            dIdx = dIdx + 1
        end
        return totalSize
    end
    local totalSize = getDataSize()
    local dataString = ""
    if (totalSize < 1024) then
        dataString = string.format("%02dB", totalSize)
    elseif (totalSize < 1024 * 1024) then
        dataString = string.format("%.2fKB", totalSize/1024.0)
    else
        dataString = string.format("%.2fMB", totalSize/1024.0/1024.0)
    end
    -- 绘制资源更新大小的提示信息
    local downloadDataSizeString = ccui.Helper:seekWidgetByName(root, "Text_gp_2")
    downloadDataSizeString:setString(dataString)

    -- 退出游戏
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gp_1"),          nil, 
	{
		terminal_name = "assets_notice_exit_game",
		isPressedActionEnabled = true
	}, nil, 0)

	-- 更新资源
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gp_2"),          nil, 
	{
		terminal_name = "assets_notice_manager",
		isPressedActionEnabled = true
	}, nil, 0)
end

function AssetsNotice:onExit()
	state_machine.remove("assets_notice_manager")
	state_machine.remove("assets_notice_exit_game")
end