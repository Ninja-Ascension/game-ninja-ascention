-- ----------------------------------------------------------------------------------------------------
-- 说明：训练浏览
-------------------------------------------------------------------------------------------------------

PetTrainBrowse = class("PetTrainBrowseClass", Window)
   
local pet_train_browse_window_open_terminal = {
    _name = "pet_train_browse_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PetTrainBrowseClass") then
        	local browseWindow = PetTrainBrowse:new()
			browseWindow:init(params)
			fwin:open(browseWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pet_train_browse_window_open_terminal)
state_machine.init()

function PetTrainBrowse:ctor()
    self.super:ctor()
	self.roots = {}
	self._pet = nil
	
    -- Initialize Home page state machine.
    local function init_pet_train_browse_terminal()
		
    end
    
    init_pet_train_browse_terminal()
end

function PetTrainBrowse:onUpdateDraw()
	local root = self.roots[1]
	local shipData = dms.element(dms["ship_mould"], self._pet.ship_template_id)
	
	local pet_id = dms.atoi(shipData, ship_mould.base_mould2)
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)

	local trains = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
	
	if trains == nil then 
		return
	end
	local currentLevel = zstring.tonumber(self._pet.train_level)
	local currentTrainId = nil
	for i,v in pairs(trains) do
		if dms.atoi(v, pet_train_experience.train_level) == currentLevel then 
			currentTrainId = dms.atoi(v, pet_train_experience.id)
			break
		end
	end
	if currentTrainId == nil then 
		--找不到数据
		return
	end
	ccui.Helper:seekWidgetByName(root, "Text_zsx_0"):setString("".._pet_tipString_info[22] .. currentLevel .._string_piece_info[46])
	local cururentTrainData = dms.element(dms["pet_train_experience"], currentTrainId)
	ccui.Helper:seekWidgetByName(root, "Text_dqxl_1"):setString("" ..currentLevel.._string_piece_info[46])
	self:onUpdateTrainInfo(1,cururentTrainData)
	local maxId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_max_id)
	local maxTrainData = dms.element(dms["pet_train_experience"],maxId)
	self:onUpdateTrainInfo(2,maxTrainData)
	local maxLevel = dms.atoi(maxTrainData,pet_train_experience.train_level)
	ccui.Helper:seekWidgetByName(root, "Text_ysx_0"):setString("".._pet_tipString_info[22] .. maxLevel .._string_piece_info[46] .. "(".._pet_tipString_info[23] ..")")
end

--刷新加成前后数据
-- @ index 1 前 2 后
-- @ data　加层数据
function PetTrainBrowse:onUpdateTrainInfo(index,data)
	local counts = 0
	local imageName = {"Image_zw1_","Image_zw1_1_"}
	local textName = {"Text_zsx_","Text_ysx_"}
	local root = self.roots[1]
    for i=1,6 do
    	local image = ccui.Helper:seekWidgetByName(root, "" ..imageName[index] ..i)
		local attribute = dms.atos(data,pet_train_experience.need_experience + i)

        local lenghtAdd = string.len(attribute)
        local value = 1
        local indexValue = 1
        if lenghtAdd > 2 then 
        -- 有加层
        	image:setVisible(true)
    		local info = zstring.split("".. attribute,"|")
        	if info ~= nil and #info == 2 then
        		--两种属性 必然是防御 物理防御，法术防御
        		indexValue = 40
        		value = zstring.tonumber(zstring.split(""..info[1],",")[2])
          	end
         	if info ~= nil and #info == 1 then 
                --一种属性
                local addAttribute = zstring.split("".. info[1],",")
                indexValue = zstring.tonumber(addAttribute[1]) + 1
                value = zstring.tonumber(addAttribute[2])
           	end
            counts = counts + 1
            local nameText = ccui.Helper:seekWidgetByName(root, "" ..textName[index] ..counts)
            nameText:setString("" ..i .. " " .. string_equiprety_name[indexValue]
            	 .. " " .. value ..string_equiprety_name_vlua_type[indexValue])
        end
    end
end

function PetTrainBrowse:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("packs/PetStorage/PetStorage_xunlian_yulan.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		func_string = [[fwin:close(fwin:find("PetTrainBrowseClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)
end


function PetTrainBrowse:onExit()
end

function PetTrainBrowse:init(ship)
	self._pet = ship
end
