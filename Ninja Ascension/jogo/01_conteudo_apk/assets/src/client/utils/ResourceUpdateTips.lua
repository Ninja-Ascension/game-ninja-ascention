-- ----------------------------------------------------------------------------------------------------
-- 说明：资源更新确认界面和系统特殊提示界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：李文鋆
-- 时间 : 2017-11-27
-------------------------------------------------------------------------------------------------------
ResourceUpdateTips = class("ResourceUpdateTipsClass", Window)
    
function ResourceUpdateTips:ctor()
    self.super:ctor()
    self.roots = {}
    self._txt = ""

    -- Initialize ResourceUpdateTips state machine.
    local function init_ResourceUpdateTips_terminal()
		-- 界面确定按钮
        local resource_update_tips_ok_terminal = {
            _name = "resource_update_tips_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance.m_type) == 1 then
                    fwin:removeAll()
                    fwin:reset(nil)
                    localData_list_new_unload_next()
                    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
                    if targetPlatform == cc.PLATFORM_OS_WINDOWS and false then     
                        app.load("client.login.AssetsManager")
                        app.load("client.login.login")
                        fwin:open(Login:new(), fwin._view)
                    else
                        app.load("client.assets.AssetsManager")
                        fwin:open(AssetsManager:new(), fwin._background)
                    end
                elseif tonumber(instance.m_type) == 2 then
                    local function responseListCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            app.load("client.home.Menu")
                            fwin:open(Menu:new(), fwin._taskbar)
                            if fwin:find("HomeClass") == nil then
                                state_machine.excute("menu_manager", 0, 
                                    {
                                        _datas = {
                                            terminal_name = "menu_manager",     
                                            next_terminal_name = "menu_show_home_page", 
                                            current_button_name = "Button_home",
                                            but_image = "Image_home",       
                                            terminal_state = 0, 
                                            _needOpenHomeHero = true,
                                            isPressedActionEnabled = true
                                        }
                                    }
                                )
                            else
                                fwin:cleanView(fwin._ui)
                            end
                            state_machine.excute("menu_back_home_page", 0, "")
                            state_machine.excute("home_change_open_atrribute", 0, false)
                            _ED.integral_current_index = 0
                            state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit")
                            state_machine.excute("notification_center_update", 0, "push_notification_center_activity_all")
                        end
                        fwin:close(fwin:find("ResourceUpdateTipsClass"))
                    end
                    NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, responseListCallback, false, nil)
                elseif tonumber(instance.m_type) == 3 then
                    state_machine.excute("sm_equipment_tab_awakening_treasure_less", 0, "")
                    fwin:close(fwin:find("ResourceUpdateTipsClass"))
                end
                -- app.load("client.assets.AssetsManager")
                -- fwin:open(AssetsManager:new(), fwin._background)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local resource_update_tips_close_terminal = {
            _name = "resource_update_tips_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("ResourceUpdateTipsClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(resource_update_tips_ok_terminal)
        state_machine.add(resource_update_tips_close_terminal)
        state_machine.init()
    end
    
    -- call func init ResourceUpdateTips state machine.
    init_ResourceUpdateTips_terminal()
end

function ResourceUpdateTips:onInit()
	local csbResourceUpdateTips = csb.createNode("utils/prompt_1.csb")
    self:addChild(csbResourceUpdateTips)
	
	local root = csbResourceUpdateTips:getChildByName("root")
    table.insert(self.roots, root)
	
    local Text_141 = ccui.Helper:seekWidgetByName(root, "Text_141")
    if Text_141 ~= nil then
        if tonumber(self.m_type) == 3 then
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)
            _richText:setContentSize(cc.size(Text_141:getContentSize().width, 0))
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 
            255, _new_interface_text[283], Text_141:getFontName(), Text_141:getFontSize())
            local path = "images/ui/icon/zuanshi.png"
            local pathSprite = cc.Sprite:create(path)
            pathSprite:setScale(0.8)
            pathSprite:setContentSize(cc.size(pathSprite:getContentSize().width*0.8,pathSprite:getContentSize().height*0.8))
            local reimg = ccui.RichElementCustomNode:create(2, cc.c3b(255, 255, 255), 255, pathSprite)
            local good = dms.string(dms["equipment_config"], 17, equipment_config.param)
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 
            255, good, Text_141:getFontName(), Text_141:getFontSize())
            _richText:pushBackElement(re1)
            _richText:pushBackElement(reimg)
            _richText:pushBackElement(re2)
            _richText:formatTextExt()
            _richText:setAnchorPoint(CCPoint(0, 0.5))
            _richText:setPosition(cc.p((Text_141:getContentSize().width-_richText:getContentSize().width)/2, Text_141:getContentSize().height))  
            Text_141:addChild(_richText)
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)
            _richText2:setContentSize(cc.size(Text_141:getContentSize().width, 0))
            local re21 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 
            255, _new_interface_text[284], Text_141:getFontName(), Text_141:getFontSize())
            _richText2:pushBackElement(re21)
            _richText2:formatTextExt()
            _richText2:setAnchorPoint(CCPoint(0, 0.5))
            _richText2:setPosition(cc.p((Text_141:getContentSize().width-_richText2:getContentSize().width)/2, Text_141:getContentSize().height-Text_141:getFontSize()*2))  
            if __lua_project_id == __lua_project_onepiece and tipStringInfo_language_control[1] == "zh_TW" then
                _richText2:setPosition(cc.p((Text_141:getContentSize().width-_richText2:getContentSize().width)/2, Text_141:getContentSize().height-Text_141:getFontSize()*3))
            end
            Text_141:addChild(_richText2)
        else
            Text_141:setString(self.content)
        end
    end

    local Text_1_2 = ccui.Helper:seekWidgetByName(root, "Text_1_2")
    if Text_1_2 ~= nil then
        Text_1_2:setString(self.title)
    end

	local ok_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), nil, {
		terminal_name = "resource_update_tips_ok", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)
    if tonumber(self.m_type) == 3 then
        local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"), nil, {
            terminal_name = "resource_update_tips_close", 
            terminal_state = 1,
            taget = self,
            isPressedActionEnabled = true
            }, nil, 0)
    else
        local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"), nil, {
            terminal_name = "resource_update_tips_ok", 
            terminal_state = 1,
            taget = self,
            isPressedActionEnabled = true
            }, nil, 0)
    end
end

function ResourceUpdateTips:onEnterTransitionFinish()
    
end

function ResourceUpdateTips:init(m_type,title,content)
    self.m_type = m_type
    self.content = content
    self.title = title
	self:onInit()
    return self
end

function ResourceUpdateTips:onExit()
	state_machine.remove("resource_update_tips_ok")
end