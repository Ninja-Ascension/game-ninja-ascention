-- ----------------------------------------------------------------------------------------------------
-- 说明： 选择语言
-------------------------------------------------------------------------------------------------------
MoreSystemChooseLanguage = class("MoreSystemChooseLanguageClass", Window)
    
function MoreSystemChooseLanguage:ctor()
    self.super:ctor()
    self.roots = {}
	self.goodsInfoList = {}
    self.current_choose_type = ""
    self.initialLanguage = ""
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
            if languageString == instance.initialLanguage then
                return
            end
            app.load("client.utils.ChangeLanguageConfirm")
            local cell = ChangeLanguageConfirm:new()
            cell:init(languageString)
            fwin:open(cell,fwin._ui)
            --instance:setVisible(false)
            -- if languageString == "zh_TW" or languageString == "en" then 
            --     if instance.current_choose_type ~= languageString then 
            --         instance.current_choose_type = languageString
            --     end
            -- end
            -- instance:onUpdateDraw()
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    -- local choose_language_ok_terminal = {
    --     _name = "choose_language_ok",
    --     _init = function (terminal)
            
    --     end,
    --     _inited = false,
    --     _instance = self,
    --     _state = 0,
    --     _invoke = function(terminal, instance, params)
    --         if instance.current_choose_type == "" or instance.current_choose_type == nil then
    --             return
    --         end
    --         local languageString = instance.current_choose_type
    --         cc.UserDefault:getInstance():setStringForKey("current_language",languageString)
    --         cc.UserDefault:getInstance():flush()
    --         if instance.show_type == 1 then 
    --             --登入的时候
    --             app.setSearchPaths(languageString)
    --             app.unload("data.TipStringInfo")
    --             state_machine.excute("logo_check_assets", 0, "change to 'AssetsManagerEx'")
    --         else
    --             if instance.current_choose_type ~= instance.initialLanguage then
    --                 TipDlg.drawTextDailog(chooseLanguageStr)
    --             end
    --         end
    --         fwin:close(fwin:find("MoreSystemChooseLanguageClass"))
    --         return true
    --     end,
    --     _terminal = nil,
    --     _terminals = nil
    -- }

	state_machine.add(more_sytem_choose_language_terminal)
	--state_machine.add(choose_language_ok_terminal)
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
    local language = self.current_choose_type
    local image_select_tw = ccui.Helper:seekWidgetByName(root, "Image_tw_2")
    local image_select_en = ccui.Helper:seekWidgetByName(root, "Image_en_2")
    --local Button_sure = ccui.Helper:seekWidgetByName(root, "Button_sure")
    image_select_tw:setVisible(false)
    image_select_en:setVisible(false)
    --Button_sure:setVisible(true)
    if language == "" then
        --Button_sure:setVisible(false)
    elseif language == "zh_TW" then 
        image_select_tw:setVisible(true)
    elseif language == "en" then 
        image_select_en:setVisible(true)
    end
end

function MoreSystemChooseLanguage:onEnterTransitionFinish()
	
    local csbMoreSystem = csb.createNode("home/home_more_yuyan.csb")
    local root = csbMoreSystem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbMoreSystem)
    self.initialLanguage = m_curr_choose_language
    self.current_choose_type = m_curr_choose_language
    local closeButton = ccui.Helper:seekWidgetByName(root, "Button_close_language")
    if self.show_type == 1 then
       closeButton:setVisible(false) 
    end
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close_language"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("MoreSystemChooseLanguageClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_tw"),       nil, 
    {
        terminal_name = "more_sytem_choose_language",        
        terminal_state = 0, 
        current_type = "zh_TW",
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_en"),       nil, 
    {
        terminal_name = "more_sytem_choose_language",        
        terminal_state = 0, 
        current_type = "en",
        isPressedActionEnabled = true
    }, 
    nil, 0)
    local Button_sure = ccui.Helper:seekWidgetByName(root, "Button_sure")
    if Button_sure ~= nil then
        Button_sure:setVisible(false)
        fwin:addTouchEventListener(Button_sure,       nil, 
        {
            terminal_name = "choose_language_ok",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end
    self:onUpdateDraw()
end

function MoreSystemChooseLanguage:onExit()
	
end