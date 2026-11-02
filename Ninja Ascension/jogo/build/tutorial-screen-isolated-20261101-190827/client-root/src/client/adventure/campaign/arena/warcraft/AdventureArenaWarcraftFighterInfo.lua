-- ----------------------------------------------------------------------------------------------------
-- 说明：排位玩家信息
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftFighterInfo = class("AdventureArenaWarcraftFighterInfoClass", Window)
    
function AdventureArenaWarcraftFighterInfo:ctor()
    self.super:ctor()
    self.roots = {}
	self.isTouchLock = false
	self.hero = nil 
	app.load("client.adventure.utils.AdventureSprite")
    -- Initialize adventure arena state machine.
  --   local function init_adventure_arena_warcraft_fi_terminal()

  --       --返回
		-- local adventure_arena_warcraft_rule_close_terminal = {
  --           _name = "adventure_arena_warcraft_rule_close",
  --           _init = function (terminal)
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
		-- 		fwin:close(fwin:find("AdventureArenaWarcraftRuleClass"))
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }
	
		-- state_machine.add(adventure_arena_warcraft_rule_close_terminal)
  --       state_machine.init()
  --   end
    
  --   -- call func init adventure arena state machine.
  --   init_adventure_arena_warcraft_rule_terminal()
end

function AdventureArenaWarcraftFighterInfo:init(hero)
 
    return self
end

function AdventureArenaWarcraftFighterInfo:onUpdateDraw()
	local root = self.roots[1]
  if root == nil then 
    return
  end
   ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_ED.warcraft_info.fighter_info.nickname)-- 玩家昵称
  ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString("".._ED.warcraft_info.fighter_info.fighting)   --战力
  
  local formations = zstring.split(_ED.warcraft_info.fighter_info.formation,",")
  if formations == nil then 
      return
  end
  if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
    or __lua_project_id == __lua_project_pokemon 
    or __lua_project_id == __lua_project_rouge
    or __lua_project_id == __lua_project_yugioh 
    or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
    or __lua_project_id == __lua_project_warship_girl_b 
    then 
      app.load("client.cells.ship.ship_body_cell")
      for i=1,6 do
        local shipId = zstring.tonumber(formations[i])
        local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i) --我的整形到 25
        rolePanel:removeBackGroundImage()
        rolePanel:removeAllChildren(true)
        if shipId > 0 then 
          local cell = ShipBodyCell:createCell()
          local heroData = dms.element(dms["ship_mould"], shipId)  
          local picIndex = dms.int(dms["ship_mould"], temple_id, ship_mould.All_icon)
          cell:initShipMID(nil,picIndex,nil)
          rolePanel:addChild(cell)
        end
      end
  else
    ccui.Helper:seekWidgetByName(root, "Text_xiangong_1"):setString("".._ED.warcraft_info.fighter_info.speed)   --先攻
    ccui.Helper:seekWidgetByName(root, "Text_fangyu_1"):setString("".._ED.warcraft_info.fighter_info.defence)   --防御
    ccui.Helper:seekWidgetByName(root, "Text_shanbi_1"):setString("".._ED.warcraft_info.fighter_info.avd)   --闪避
    ccui.Helper:seekWidgetByName(root, "Text_wangzhe_1"):setString("".._ED.warcraft_info.fighter_info.authority)   --王者
      for i=1,25 do
        local shipId = zstring.tonumber(formations[i])
        local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i) --我的整形到 25
        rolePanel:removeBackGroundImage()
        rolePanel:removeAllChildren(true)
        if shipId > 0 then 
            local heroData = dms.element(dms["ship_mould"], shipId)  
            
            local temp_bust_index = dms.atoi(heroData, ship_mould.bust_index)

            local role = AdventureSpriteBattle:create(temp_bust_index, 9) -- ccs.Armature:create("spirte_" .. temp_bust_index)
            local size = role:getContentSize()
            role:getAnimation():playWithIndex(0)
            role:setAnchorPoint(cc.p(0.5,0.0))
            role:setPosition(cc.p(rolePanel:getContentSize().width /2 , -size.height/2))
            role:getAnimation():setSpeedScale(0.4)
            local shadow = cc.Sprite:create("images/ui/bg/shadow.png")
            shadow:setScale(0.5)
            rolePanel:addChild(shadow, -1)
            shadow:setPosition(cc.p(rolePanel:getContentSize().width /2,0 ))
            rolePanel:addChild(role, 1)
        end
      end
    end    
end

function AdventureArenaWarcraftFighterInfo:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_pws_zx.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
    self:onUpdateDraw()
	-- -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaWarcraftFighterInfoClass"))]], 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureArenaWarcraftFighterInfo:onExit()
    self.roots = nil
end