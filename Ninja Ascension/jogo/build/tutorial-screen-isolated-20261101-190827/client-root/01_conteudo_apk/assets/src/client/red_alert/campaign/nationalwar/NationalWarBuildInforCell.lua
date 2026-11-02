-----------------------------
--军情界面阵营cell
-----------------------------
NationalWarBuildInforCell = class("NationalWarBuildInforCellClass", Window)

local national_war_build_infor_create_cell_terminal = {
    _name = "national_war_build_infor_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local camp = params[1]
        local people_numbers = params[2]
        local camp_type = params[3]
        local cell = NationalWarBuildInforCell:new()
        cell:init(camp,people_numbers,camp_type)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_build_infor_create_cell_terminal)
state_machine.init()

function NationalWarBuildInforCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.camp = nil
    self.people_numbers = nil
    self.camp_type = nil -- 1 攻击方 2 防守方
end


function NationalWarBuildInforCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_build_infor_camp = ccui.Helper:seekWidgetByName(root, "Panel_build_infor_camp")
    local Text_build_infor_camp_v = ccui.Helper:seekWidgetByName(root,"Text_build_infor_camp_v")
    local Panel_build_infor_pk = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_pk")
    if self.camp == nil then
        Panel_build_infor_camp:setBackGroundImage("images/ui/text/vs.png")
        Panel_build_infor_camp:setScale(0.7)
        Text_build_infor_camp_v:setVisible(false)
        Panel_build_infor_pk:setVisible(false)
        return
    end
    Panel_build_infor_pk:removeBackGroundImage()
    Panel_build_infor_pk:setBackGroundImage("images/ui/play/nationalwar/nationalwar_text_"..self.camp_type .. ".png")
    Panel_build_infor_camp:setBackGroundImage("images/ui/quality/camp_"..self.camp..".png")
    Text_build_infor_camp_v:setString("("..self.people_numbers..")")
end

function NationalWarBuildInforCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.campaign.nationalwar.nationalwar_build_infor_cell)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)

    self:setContentSize(root:getContentSize())
    table.insert(self.roots, root)
    self:onUpdateDraw() 
end

function NationalWarBuildInforCell:init(camp,people_numbers,camp_type)
    self.camp = camp
    self.people_numbers = people_numbers
    self.camp_type = camp_type
    self:onInit()
    return self
end

function NationalWarBuildInforCell:onExit()

end
