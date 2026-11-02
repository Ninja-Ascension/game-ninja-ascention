-- ----------------------------------------------------------------------------------------------------
-- 说明： 选择语言
-------------------------------------------------------------------------------------------------------
MoreSystemChooseLanguage = class("MoreSystemChooseLanguageClass", Window)
    
function MoreSystemChooseLanguage:ctor()
    self.super:ctor()
    self.roots = {}
	self.goodsInfoList = {}
    self.current_choose_type = ""
    self.show_type = 1

	local function init_moreSystem_choose_language_terminal()
	
        -- 选择语言
        local more_sytem_choose_language_terminal = {
            _name = "more_sytem_choose_language",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                local languageString = params._datas.current_type
                if languageString == "zh" or languageString == "vi" or languageString == "th" then 
                    if instance.current_choose_type ~= languageString then 
                        instance.current_choose_type = languageString
                        if self.show_type == 1 then 
                            --登入的时候
                            app.unload("data.TipStringInfo")
                            cc.UserDefault:getInstance():setStringForKey("current_language",languageString)
                            app.setSearchPaths(languageString)
                            fwin:close(fwin:find("MoreSystemChooseLanguageClass"))
                            state_machine.excute("logo_check_assets", 0, "change to 'AssetsManagerEx'")
                        else
                            TipDlg.drawTextDailog(_string_piece_info[434])
                            cc.UserDefault:getInstance():setStringForKey("current_language",languageString)
                            instance:onUpdateDraw()
                        end
                        
                        --app.setSearchPaths(languageString)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


	 state_machine.add(more_sytem_choose_language_terminal)
	
	 state_machine.init()
	end  	 
	init_moreSystem_choose_language_terminal()
end

function MoreSystemChooseLanguage:init(showtype)
    self.show_type = showtype
	return self
end

function MoreSystemChooseLanguage:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local language = cc.UserDefault:getInstance():getStringForKey("current_language","")
    local image_select_zh = ccui.Helper:seekWidgetByName(root, "Image_chinese")
    local image_select_vi = ccui.Helper:seekWidgetByName(root, "Image_vietnamese")
    local image_select_th = ccui.Helper:seekWidgetByName(root, "Image_Thai")
    image_select_zh:setVisible(false)
    image_select_vi:setVisible(false)
    image_select_th:setVisible(false)
    self.current_choose_type = language
    if language == "" then 
        image_select_zh:setVisible(true)
    elseif language == "zh" then 
        image_select_zh:setVisible(true)
    elseif language == "vi" then 
        image_select_vi:setVisible(true)
    elseif language == "th" then 
        image_select_th:setVisible(true)
    end
end

function MoreSystemChooseLanguage:onEnterTransitionFinish()
	
    local csbMoreSystem = csb.createNode("home/home_more_yuyan.csb")
    local root = csbMoreSystem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbMoreSystem)

	self:onUpdateDraw()
		
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("MoreSystemChooseLanguageClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_chinese"),       nil, 
    {
        terminal_name = "more_sytem_choose_language",        
        terminal_state = 0, 
        current_type = "zh",
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_vietnamese"),       nil, 
    {
        terminal_name = "more_sytem_choose_language",        
        terminal_state = 0, 
        current_type = "vi",
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_Thai"),       nil, 
    {
        terminal_name = "more_sytem_choose_language",        
        terminal_state = 0, 
        current_type = "th",
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function MoreSystemChooseLanguage:onExit()
	
end