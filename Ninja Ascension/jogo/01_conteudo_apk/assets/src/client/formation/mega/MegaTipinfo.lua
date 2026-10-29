--------------------------------------------------------------------------------------------------------------
--  说明：超进化提示界面  
--------------------------------------------------------------------------------------------------------------
MegaTipinfo = class("MegaTipinfoClass", Window)

local megatipinfo_open_terminal = {
    _name = "megatipinfo_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaTipinfoClass") == nil then           
            fwin:open(MegaTipinfo:new():init(params), fwin._viewdialog)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local megatipinfo_close_terminal = {
    _name = "megatipinfo_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaTipinfoClass") then
            fwin:close(fwin:find("MegaTipinfoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(megatipinfo_open_terminal)
state_machine.add(megatipinfo_close_terminal)
state_machine.init()

function MegaTipinfo:ctor()
    self.super:ctor()
    self.roots = {} 
    self.allinfo = {}
    app.load("client.formation.mega.MegaUnlockSuccess") 
    app.load("client.formation.mega.MegaSmallTree")  
    local function init_megatipinfo_terminal()
        local init_megatipinfo_unlock_terminal = {
            _name = "megatipinfo_unlock",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
           _invoke = function(terminal, instance, params)
            state_machine.excute("megasmalltree_isuse_skill",0,params) 
            if params._datas.isuse == 1 then
                state_machine.excute("megaunlocksuccess_open",0,instance.allinfo) 
            end
            state_machine.excute("megatipinfo_close",0,nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
     state_machine.add(init_megatipinfo_unlock_terminal) 
    end
   init_megatipinfo_terminal()
end

function MegaTipinfo:onUpdate(dt)
    
end

function MegaTipinfo:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/sm_role_evolution_tips_window.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "megatipinfo_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil, 
    {
        terminal_name = "megatipinfo_unlock", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        isuse = 1,
    }, nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Cancel"), nil, 
    {
        terminal_name = "megatipinfo_unlock", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        isuse = 2,
    }, nil, 0)
    local Text_tips_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tips_1")   
    Text_tips_1:setString(tipStringInfo_maga_unlock[15])

end


function MegaTipinfo:init(params)
    self.allinfo = params
    return self
end

function MegaTipinfo:onExit()
    
end