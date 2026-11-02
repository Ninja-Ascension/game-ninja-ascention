-- ----------------------------------------------------------------------------------------------------
-- 说明：挖矿NPC事件
-------------------------------------------------------------------------------------------------------
AdventureMineEventNpcDlg = class("AdventureMineEventNpcDlgClass", Window)
    
function AdventureMineEventNpcDlg:ctor()
    self.super:ctor()
    self.roots = {}
    self.mould_date = nil
    self.npcId = nil
    self.tileCell = nil
    self.min_npc_datas = nil
    self.cell_data = nil
   
    -- Initialize adventure prop storage state machine.
    local function init_adventure_mine_event_box_terminal()
	
		--战斗
        local adventure_mine_event_npc_fight_terminal = {
            _name = "adventure_mine_event_npc_fight",
            _init = function (terminal)
                app.load("client.adventure.battle.AdventureBattle")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            local function responseBattleInitCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

                        instance.tileCell.tileType = "0" 
                        instance.tileCell.__tile._tileType = "0"
                        instance.tileCell.__tile._focus = nil
                        instance.tileCell.__tile._exploit = false
                        _ED.adventure_mine.current_mine.x = 0
                        _ED.adventure_mine.current_mine.y = 0
                        _ED.adventure_mine.current_mine.mining_cd = 0
                        instance.tileCell:unload()
                        instance.tileCell:reload()
                        instance.tileCell:updateDraw()
                       -- state_machine.excute("adventure_mine_tile_cell_battle_update",0,{cell = instance.mineData})
                        state_machine.excute("adventure_mine_reset_add_draw", 0, "adventure_mine_reset_add_draw.")
                    
                    cacher.removeAllTextures()
                    
                    fwin:removeAll()
                    cc.Director:getInstance():purgeCachedData()
                    fwin:open(AdventureBattle:new():init(), fwin._background)

                end
            end
                _ED._battle_map_type = 2
                protocol_command.mine_event_launch.param_list = ""..self.tileCell.tileX.."\r\n"..self.tileCell.tileY
                NetworkManager:register(protocol_command.mine_event_launch.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

       
        state_machine.add(adventure_mine_event_npc_fight_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure prop storage state machine.
    init_adventure_mine_event_box_terminal()
end

function AdventureMineEventNpcDlg:init(npcId,cell)
    self.npcId = npcId
    self.tileCell = cell
    return self
end

function AdventureMineEventNpcDlg:updateOnInfo()
	local root = self.roots[1]
	
end


function AdventureMineEventNpcDlg:onUpdateDraw()
	local root = self.roots[1]
    local npc_array =zstring.split(_ED.mine_random_npc_infos ,"|")
    self.min_npc_datas = {}
    local dialogIndex = math.random(1,9)
    if dialogIndex >8 or dialogIndex < 1 then 
        dialogIndex = 3
    end

    self.cell_data = nil
    self.cell_data = _ED.mine_random_npc_cells["" .. self.tileCell.tileX .. "," .. self.tileCell.tileY]
    if self.cell_data == nil then 

        return
    end
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_npc") -- 上面
    Panel_role:removeAllChildren(true)
    local Panel_role_own = ccui.Helper:seekWidgetByName(root, "Panel_own") -- 下面
    Panel_role_own:removeAllChildren(true)
    local Text_up = ccui.Helper:seekWidgetByName(root, "Text_npc_word") -- 上面
    local Text_down = ccui.Helper:seekWidgetByName(root, "Text_own_word") -- 上面
    local dialog_info = dms.string(dms["mine_npc_dialogue"], dialogIndex, mine_npc_dialogue.npc_dialogue)

    -- 0 主角 1 怪物
    local info_arr = zstring.split(dialog_info , "|")
    local dialog = zstring.split("".. info_arr[1],"-")
    
    if tonumber(dialog[1]) == 0  then 
        Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.cell_data._headPic))
        Panel_role_own:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(_ED.user_info.user_head) + 500))
        Text_up:setString("" .. dialog[2])
        Text_down:setString("" .. zstring.split("".. info_arr[2],"-")[2])
        
    else
        Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.cell_data._headPic))
        Panel_role_own:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(_ED.user_info.user_head) + 500))
        Text_up:setString("" .. dialog[2])
        Text_down:setString("" .. zstring.split("".. info_arr[2],"-")[2])
    end
  
    ccui.Helper:seekWidgetByName(root, "Text_title"):setString(self.cell_data._nickName)   
end


function AdventureMineEventNpcDlg:onEnterTransitionFinish()
    local csbEnvetBoss = csb.createNode("campaign/Mining/wakuang_shijian_npc.csb")
    local root = csbEnvetBoss:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbEnvetBoss)


	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineEventNpcDlgClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_know"),       nil, 
    {
        terminal_name = "adventure_mine_event_npc_fight",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

end

function AdventureMineEventNpcDlg:onExit()
    state_machine.remove("adventure_mine_event_npc_fight")
end
