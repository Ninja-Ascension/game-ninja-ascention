-- ----------------------------------------------------------------------------------------------------
-- 说明：排位赛战斗结算
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftFightResult = class("AdventureArenaWarcraftFightResultClass", Window)
    
function AdventureArenaWarcraftFightResult:ctor()
    self.super:ctor()
    self.roots = {}
    self.reward = nil
      -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_fight_result_terminal()
    
        --返回
        local adventure_arena_warcraft_fight_result_close_terminal = {
            _name = "adventure_arena_warcraft_fight_result_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureArenaWarcraftFightResultClass"))
                local tipType = getResultTipType()
                if tipType == 3 or tipType == 0 then
                    checkResultTip()
                else
                    state_machine.excute("adventure_arena_warcraft_reward_tip_action_update",0,tipType) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }        
        state_machine.add(adventure_arena_warcraft_fight_result_close_terminal)    
        
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_fight_result_terminal()
end

function AdventureArenaWarcraftFightResult:init(result)
    self.reward = result
	return self
end


function AdventureArenaWarcraftFightResult:checkResultTip()
   
end

function AdventureArenaWarcraftFightResult:onUpdateDraw()
	local root = self.roots[1]
    if root == nil then 
        return
    end
   
    local Panel_win = ccui.Helper:seekWidgetByName(root, "Panel_jiantou_sd")
    local Panel_jifen = ccui.Helper:seekWidgetByName(root, "Panel_jiantou_jf")

    local Text_win = ccui.Helper:seekWidgetByName(root, "Text_sd_number")
    local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jf_number")
    Text_win:setString("+0")
    Text_jifen:setString("+0")
    Panel_win:removeAllChildren(true)
    Panel_win:removeBackGroundImage()
    
    Panel_jifen:removeAllChildren(true)
    Panel_jifen:removeBackGroundImage()
    for i, v in pairs(self.reward.show_reward_list) do
        if zstring.tonumber(v.prop_type) == 29 then       --胜点
           self:onUpdateResultImage(Panel_win,Text_win,v.item_value)
        elseif zstring.tonumber(v.prop_type) == 30 then      --积分
           self:onUpdateResultImage(Panel_jifen,Text_jifen,v.item_value)
        end
    end
end

function  AdventureArenaWarcraftFightResult:onUpdateResultImage(nodePanel,nodeText,itemvalue)
    if nodePanel == nil or nodeText == nil then 
        return
    end
    if zstring.tonumber(itemvalue) > 0 then 
        --上升图标
        nodePanel:setBackGroundImage("images/ui/button/button_rewardbtn_icon_lvup.png") 
        nodeText:setString("+" .. itemvalue)  
    end
    if zstring.tonumber(itemvalue) < 0 then 
        --下降图标
        nodePanel:setBackGroundImage("images/ui/button/button_rewardbtn_icon_lvup_1.png")   
        nodeText:setString("" .. itemvalue)  
    end
end

function AdventureArenaWarcraftFightResult:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_pws_jiesuan.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
    self:onUpdateDraw()
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_fight_result_close",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    
end

function AdventureArenaWarcraftFightResult:onExit()
    self.roots = nil
    state_machine.remove("adventure_arena_warcraft_fight_result_close")
end