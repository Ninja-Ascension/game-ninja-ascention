-- ----------------------------------------------------------------------------------------------------
-- 说明：添加图鉴评论对话框
-------------------------------------------------------------------------------------------------------
AdventureMercenaryAddEvaluationDialog = class("AdventureMercenaryAddEvaluationDialogClass", Window)
    
function AdventureMercenaryAddEvaluationDialog:ctor()
    self.super:ctor()
    self.roots = {}

    self.ship_id = nil
    self.text_number = nil


    -- Initialize adventure mercenary equipment fate state machine.
    local function init_adventure_mercenary_evaluation_comment_add_terminal()
       
        -- 回复
        local adventure_mercenary_equipment_comment_add_terminal = {
            _name = "adventure_mercenary_equipment_comment_add",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local text = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_word")
                local str = zstring.exchangeTo(text:getString())
                if str == "" then 
                    TipDlg.drawTextDailog(_string_piece_info[257])
                    return true
                end
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:close(instance)
                        state_machine.excute("adventure_mercenary_equipment_evaluation_update", 0, 0)
                        state_machine.excute("adventure_hero_information_evaluation_count_update", 0, 0)
                    end
                end
    
                
                protocol_command.ship_comment_add.param_list = instance.ship_id .."\r\n".. str

                NetworkManager:register(protocol_command.ship_comment_add.code, nil, nil, nil, nil, responseSendMessageCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_equipment_comment_add_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary equipment fate state machine.
    init_adventure_mercenary_evaluation_comment_add_terminal()
end

function AdventureMercenaryAddEvaluationDialog:init(shipid)
    self.ship_id = shipid
    return self
end

-- 绘制当前的装备信息
function AdventureMercenaryAddEvaluationDialog:updateDraw(cell)
    local root = self.roots[1]

 
end
function AdventureMercenaryAddEvaluationDialog:onUpdate(dt )
    if self.textfield_word ~= nil and self.text_number ~= nil then
        local num = 40 - string.len(self.textfield_word:getString())
        if num <= 0 then 
            num = 0 
        end
        self.text_number:setString("" .. num)
    end
    -- body
end
function AdventureMercenaryAddEvaluationDialog:onEnterTransitionFinish()
    local csbAdventureMercenaryplunAdd = csb.createNode("packs/Mercenary/yongbing_pinglun_add.csb")
    local root = csbAdventureMercenaryplunAdd:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryplunAdd)
    self.textfield_word = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("TextField_word")
    self.text_number = ccui.Helper:seekWidgetByName(root, "Text_pl_number_2")
    self.text_number:setString("40")
    local replayButton = ccui.Helper:seekWidgetByName(root, "Button_replay")
    draw:addEditBox(self.textfield_word, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_replay"), 40, cc.KEYBOARD_RETURNTYPE_DONE)
    replayButton:setSwallowTouches(false)

    --添加评论
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_replay"),       nil, 
    {
        terminal_name = "adventure_mercenary_equipment_comment_add",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryAddEvaluationDialogClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureMercenaryAddEvaluationDialog:onExit()
    state_machine.remove("adventure_mercenary_equipment_comment_add")
end


