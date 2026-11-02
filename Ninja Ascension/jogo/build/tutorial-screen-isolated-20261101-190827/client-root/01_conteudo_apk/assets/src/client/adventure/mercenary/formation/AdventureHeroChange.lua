-- ----------------------------------------------------------------------------------------------------
-- 说明：转换四维属性
-------------------------------------------------------------------------------------------------------
AdventureHeroChage = class("AdventureHeroChageClass", Window)
    
function AdventureHeroChage:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.hero = nil
    self.list_huode = nil
    self.hero_list_cell = nil
    self.refreshRushName = nil
    --转换
    self.ArmatureNode_change = nil
    app.load("client.loader.formula")

    -- Initialize adventure hero awaken state machine.
    local function init_adventure_hero_awaken_terminal()
        -- 转换
        local adventure_hero_siwei_change_terminal = {
            _name = "adventure_hero_siwei_change",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)                
                
                local cell = params._datas.cell
                local function responseRushAttributeCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node.ArmatureNode_change:setVisible(true)
                            csb.animationChangeToAction(response.node.ArmatureNode_change, 0, 0, false)
                            response.node.ArmatureNode_change._invoke = function(armatureBack)
                                response.node.ArmatureNode_change:setVisible(false)
                            end
                            response.node:updateDraw()
                             
                        else 
                        end  

                        if params._datas.cell.refreshRushName ~= nil then
                            state_machine.excute(params._datas.cell.refreshRushName , 0 , 0)
                            if instance.hero_list_cell ~= nil then 
                                instance.hero_list_cell:updateDraw()
                            end
                        end
                        --state_machine.excute("adventure_fate_strengthen_update_hero_list_cell", 0, 0)
                    end
                end

                protocol_command.rush_four_attribute.param_list =  self.hero.ship_id .. "\r\n"
                NetworkManager:register(protocol_command.rush_four_attribute.code, nil, nil, nil, self, responseRushAttributeCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_hero_siwei_change_terminal)
        state_machine.init()
    end
    
    -- call func init adventure hero awaken state machine.
    init_adventure_hero_awaken_terminal()
end

function AdventureHeroChage:init(hero,cell,stateName)
    self.hero = hero
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    self.hero_list_cell = cell
    self.refreshRushName = stateName
    return self
end

function AdventureHeroChage:updateDraw()
    local root = self.roots[1]
    if root == nil then 
    
        return
    end

    self.list_huode = ccui.Helper:seekWidgetByName(root, "ListView_1")
    local picIndex =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.head_icon)
    
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    Panel_role:removeAllChildren(true)
    Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
    

    local Panel_siwei = ccui.Helper:seekWidgetByName(root, "Panel_siwei")
    local Text_siwei = ccui.Helper:seekWidgetByName(root, "Text_siwei_name")
    local Text_current = ccui.Helper:seekWidgetByName(root, "Text_shuxin_1") --当前
    local Text_max = ccui.Helper:seekWidgetByName(root, "Text_shuxin_max") --最大

    local siweiIndex ,leavel = getSiweiAttribute(self.hero)
    
    local base2 =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.base_mould2)
    
    local max_num =dms.int(dms["contract_hidden_param"], base2, contract_hidden_param.attribute_limit)
    Text_max:setString("" .. max_num)
    if siweiIndex == -1 then 
        --没有四维属性
        Text_current:setString("".. 0)
    else
        Text_current:setString("".. leavel)
        Panel_siwei:setBackGroundImage(string.format("images/ui/icon/icon_shuxin_%d.png", siweiIndex))
    end
    local shipItems = zstring.split(dms.string(dms["pirates_config"], 332, pirates_config.param), "!")
    local quality = dms.atoi(self.mould_data, ship_mould.ship_type)
    local _width = 0
    local _nCount = 0
    
    local rewardItems = {}
    self.list_huode:removeAllItems()
    local quality = dms.atoi(self.mould_data, ship_mould.ship_type) + 1
    
    local items = zstring.split("" .. shipItems[quality], "|")
    for i,v in pairs(items) do
        local one_prop = zstring.split("" .. v, ",")
        if zstring.tonumber(one_prop[1]) == 1 then 
            local cell = adventureNewSmallPropIconCell:createCell()
            cell:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(one_prop[3]), nil, 0, 0)
        
            self.list_huode:addChild(cell)
            _nCount = _nCount + 1
        end
        if zstring.tonumber(one_prop[1]) == 4 then 
            local cell = adventureNewSmallPropIconCell:createCell()
            cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(one_prop[3]), nil, 0, 0,nil)
            self.list_huode:addChild(cell)
            _nCount = _nCount + 1
        end
        if zstring.tonumber(one_prop[1]) == 6 then 
            local cell = adventureNewSmallPropIconCell:createCell()
            cell:init(0, {mould_id = one_prop[2]} , "" .. getResourceValueToStringForAdventure(one_prop[3]), nil, 0, 0,nil,{show_quantity = true})
            self.list_huode:addChild(cell)
            _nCount = _nCount + 1
        end

    end

   
    if self.list_huode._x == nil then
        self.list_huode._x = self.list_huode:getPositionX()
    end
    self.list_huode:setPositionX(self.list_huode._x - (80 + self.list_huode:getItemsMargin()) * (_nCount - 1) / 2)
    
    self.list_huode:requestRefreshView() 
    -- 绘制觉醒后的突破信息
end

function AdventureHeroChage:onEnterTransitionFinish()
    local csbAdventureHeroAwaken = csb.createNode("duplicate/siwei_zhuanhuan.csb")
    local root = csbAdventureHeroAwaken:getChildByName("root")
    self.roots = {}
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroAwaken)

    local armaturePanel = ccui.Helper:seekWidgetByName(root, "Panel_15")
    self.ArmatureNode_change = armaturePanel:getChildByName("ArmatureNode_1") -- 动画
    draw.initArmature( self.ArmatureNode_change, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_change, 0, 0, false)
    self.ArmatureNode_change:setVisible(false)
    self:updateDraw()
    -- 觉醒
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zh_over"),       nil, 
    {
        terminal_name = "adventure_hero_siwei_change",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureHeroChageClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureHeroChage:onExit()
    state_machine.remove("adventure_hero_siwei_change")
end
