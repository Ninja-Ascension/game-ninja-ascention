-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏公告
-------------------------------------------------------------------------------------------------------
AdventureNotice = class("AdventureNoticeClass", Window)
    
function AdventureNotice:ctor()
    self.super:ctor()
    self.roots = {}
    self.show_type = 1
    app.load("client.adventure.cells.announce.adventure_announce_list_cell")
    app.load("client.loader.formula")
    -- Initialize adventure notice state machine.
    local function init_adventure_notice_terminal()

        local adventure_notice_close_terminal = {
            _name = "adventure_notice_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.show_type == 1 then 
                    state_machine.excute("login_ui_control", 0, true)
                    if app.configJson.OperatorName == "pocket" then
                        state_machine.excute("login_vali_register", 0, "login_vali_register")
                    end
                end
                fwin:close(instance)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_notice_close_terminal)
        state_machine.init()
    end
    
    -- call func init adventure notice state machine.
    init_adventure_notice_terminal()
end

function AdventureNotice:init(show_type)
    self.show_type = show_type
	return self
end

function AdventureNotice:onUpdateDraw()
    local root = self.roots[1]
    
    -- _ED.system_notice = "title1\r\n|1\r\n|1\r\n|images/ui/play/system_menu/game_list_1.png\r\n|1600///%|2|活动信息活动112344565234543645765756234235436409%/!0,-200,0,-500,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png\r\n|"
                      -- .."title2\r\n|1\r\n|1\r\n|images/ui/play/system_menu/game_list_2.png\r\n|1600///%|2|活动信息活动1%/!0,-200,0,-300,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png\r\n|"
                      -- .."title3\r\n|1\r\n|1\r\n|images/ui/play/system_menu/game_list_3.png\r\n|1600///%|2|活动信息活动1%/!0,-200,0,-300,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png\r\n|"
                      -- .."title4\r\n|1\r\n|2\r\n|\r\n|1600///%|2|活动信息活动1%/!0,-200,0,-300,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png\r\n|"
                      -- .."title5\r\n|1\r\n|2\r\n|\r\n|1600///%|2|活动信息活动1%/!0,-200,0,-300,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png"
    if _ED.system_notice_ex == nil then 
        return
    end

    
    local systemNotice = zstring.split(_ED.system_notice_ex,"\\r\\n|") --格式化的内容

    local nCount = 10000
    local nIndex = 1
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_2")
    local first_one = nil 
    listView:removeAllItems()
    local  indexdd = 1
    local langueageIndex = get_language_index()
    nIndex = (langueageIndex - 1 ) * 5 + 1
    while true do
        nCount = nCount - 1
        indexdd  = indexdd + 1
        if nCount < 0 then
            break
        end
        
        local title = systemNotice[nIndex]
        local isNew = systemNotice[nIndex + 1]
        local nType = systemNotice[nIndex + 2] -- 判断是否为图片
        local titleImage = systemNotice[nIndex + 3]

        local content = systemNotice[nIndex + 4]
        
        if title == nil or isNew == nil or nType == nil or titleImage == nil or content == nil then
            break
        end
    
        nIndex = nIndex + 5
        if nType == "2" then
            -- 绘制列表项
            local list_item = AdventureAnnounceListCell:createCell()
            list_item:init(isNew, title, content)
            listView:addChild(list_item)
            ---只显示一条记录
            break
        end
    end
    listView:requestRefreshView()    
end

function AdventureNotice:onEnterTransitionFinish()
    local csbAdventureNotice = csb.createNode("system/game_notice.csb")
    local root = csbAdventureNotice:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureNotice)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
		terminal_name = "adventure_notice_close",
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2) 

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close_1"),       nil, 
    {
		terminal_name = "adventure_notice_close",
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2) 

    local function responseSystemNotice(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            self:onUpdateDraw()
        end
    end

    if _ED.system_notice_ex == nil or _ED.system_notice_ex == "" then
        if app.configJson.urlForAnnounce == nil then 
            app.configJson.urlForAnnounce = "192.168.8.12:50000/iniServer"
        end
        
        NetworkManager:register(protocol_command.get_system_notice.code, app.configJson.urlForAnnounce, nil, nil, nil, responseSystemNotice, false, nil)
    else
        self:onUpdateDraw()
    end
end

function AdventureNotice:onExit()
    
end