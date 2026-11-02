----------------------------------------------------------------------------------------------------
-- 说明：战报信息cell
-------------------------------------------------------------------------------------------------------
MailPresentationInfoCell = class("MailPresentationInfoCellClass", Window)
MailPresentationInfoCell.__size = nil

local mail_presentation_info_cell_create_terminal = {
    _name = "mail_presentation_info_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = MailPresentationInfoCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_presentation_info_cell_create_terminal)
state_machine.init()

function MailPresentationInfoCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0         -- 1：配件，2：装甲，3：将领
    self._is_show = false
    self._my_info = ""
    self._enemy_info = ""

    local function init_mail_presentation_info_cell_terminal()
        -- 升级
        local mail_presentation_info_cell_click_terminal = {
            _name = "mail_presentation_info_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local is_show = not cell._is_show
                local params = {nil, nil, nil}
                params[cell._index] = is_show
                state_machine.excute("mail_presentation_info_show_equipment_info", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(mail_presentation_info_cell_click_terminal)
        state_machine.init()
    end
    init_mail_presentation_info_cell_terminal()         
end

function MailPresentationInfoCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_leader_fight_me_t = ccui.Helper:seekWidgetByName(root,"Text_leader_fight_me_t")
    local Text_leader_fight_me_n = ccui.Helper:seekWidgetByName(root,"Text_leader_fight_me_n")
    local Text_leader_fight_enemy_t = ccui.Helper:seekWidgetByName(root,"Text_leader_fight_enemy_t")
    local Text_leader_fight_enemy_n = ccui.Helper:seekWidgetByName(root,"Text_leader_fight_enemy_n")
    local Image_arrow_1 = ccui.Helper:seekWidgetByName(root,"Image_arrow_1")
    local Image_arrow_2 = ccui.Helper:seekWidgetByName(root,"Image_arrow_2")

    Text_leader_fight_me_t:setString(mail_tip_text[63 + self._index])
    Text_leader_fight_enemy_t:setString(mail_tip_text[63 + self._index])
    Text_leader_fight_me_n:setString(self._my_info)
    Text_leader_fight_enemy_n:setString(self._enemy_info)

    if self._is_show == true then
        Image_arrow_1:setVisible(false)
        Image_arrow_2:setVisible(true)
    else
        Image_arrow_1:setVisible(true)
        Image_arrow_2:setVisible(false)
    end
end

function MailPresentationInfoCell:onEnterTransitionFinish()

end

function MailPresentationInfoCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.cells.mail.mail_presentation_cell, 12), "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if MailPresentationInfoCell.__size == nil then
        MailPresentationInfoCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_leader_fight_list_bg_0"), nil, 
    {
        terminal_name = "mail_presentation_info_cell_click", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)  

    self:onUpdateDraw()
end

function MailPresentationInfoCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.mail.mail_presentation_cell, 12), self.roots[1])
end

function MailPresentationInfoCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function MailPresentationInfoCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.mail.mail_presentation_cell, 12), root)
    root:removeFromParent(false)
    self.roots = {}
end

function MailPresentationInfoCell:clearUIInfo()
    local root = self.roots[1]
    local Text_leader_fight_me_t = ccui.Helper:seekWidgetByName(root,"Text_leader_fight_me_t")
    local Text_leader_fight_me_n = ccui.Helper:seekWidgetByName(root,"Text_leader_fight_me_n")
    local Text_leader_fight_enemy_t = ccui.Helper:seekWidgetByName(root,"Text_leader_fight_enemy_t")
    local Text_leader_fight_enemy_n = ccui.Helper:seekWidgetByName(root,"Text_leader_fight_enemy_n")
    if Text_leader_fight_me_t ~= nil then
        Text_leader_fight_me_t:setString("")
        Text_leader_fight_me_n:setString("")
        Text_leader_fight_enemy_t:setString("")
        Text_leader_fight_enemy_n:setString("")
    end
end

function MailPresentationInfoCell:init(params)
    self._index = params[1]         -- 1：配件，2：装甲，3：将领
    self._is_show = params[2]
    self._my_info = params[3]
    self._enemy_info = params[4]

    -- if self._index <= 8 then
       self:onInit()
    -- end
    self:setContentSize(MailPresentationInfoCell.__size)
end

