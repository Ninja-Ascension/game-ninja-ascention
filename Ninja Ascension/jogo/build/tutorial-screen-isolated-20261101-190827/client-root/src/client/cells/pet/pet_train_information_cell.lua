---------------------------------
---说明：宠物信息界面的 训练

---------------------------------

PetTrainInformation = class("PetTrainInformationClass", Window)
   
function PetTrainInformation:ctor()
    self.super:ctor()

    app.load("client.packs.pet.PetTrainBrowse")

	self.hero = nil
	self.userfashion = nil  
	self.info = {}
	self.listPositionX = nil
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	local function init_formation_hero_train_terminal()
        --去训练
		local pet_information_to_train_terminal = {
            _name = "pet_information_to_train",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local fun_id = 58
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
                    fun_id = 62
                end
				if dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level) > zstring.tonumber(_ED.user_info.user_grade) then
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], fun_id, fun_open_condition.tip_info))
                    return
                end
                if fwin:find("PetDevelopClass") ~= nil then
                    fwin:close(fwin:find("PetDevelopClass"))
                end                 
                local layer = PetDevelop:new()
                layer:init(params._datas._ship_id, cell)
                fwin:open(layer, fwin._viewdialog)
                state_machine.excute("pet_storage_hide_window", 0)
                state_machine.excute("pet_develop_page_manager", 0, 
                {
                    _datas = {
                        terminal_name = "pet_develop_page_manager",     
                        next_terminal_name = "pet_develop_page_open_train_page", 
                        current_button_name = "Button_pieces_tujian",
                        but_image = "",         
                        heroInstance = instance.ship,
                        terminal_state = 0,
                        openWinId = 58,
                        isPressedActionEnabled = false
                    }
                })
                state_machine.excute("pet_information_close", 0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --浏览
        local pet_information_to_browse_terminal = {
            _name = "pet_information_to_browse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship = params._datas._ship
                state_machine.excute("pet_train_browse_window_open", 0, ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_information_to_train_terminal)
        state_machine.add(pet_information_to_browse_terminal)
		state_machine.init()
	end
	init_formation_hero_train_terminal()
end

function PetTrainInformation:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local pet_id = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.base_mould2)
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
    local pet_formations = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
    for i=1,6 do
    	local image = ccui.Helper:seekWidgetByName(root, "Image_zw1_"..i)
    	image:setVisible(false)	
    	local formationText = ccui.Helper:seekWidgetByName(root, "Text_zw"..i)
    	formationText:setString("")
    end

    local level = zstring.tonumber(self.hero.train_level)
     ccui.Helper:seekWidgetByName(root, "Text_sldj_1"):setString(""..self.hero.train_level.._string_piece_info[46])
    if pet_formations ~= nil then 
        --有阵型加成
        local addFormation = nil
        for k,v in pairs(pet_formations) do
            if level == zstring.tonumber(v[3]) then 
                addFormation = v
                break
            end
        end
        if addFormation == nil then 
            return
        end
        local formations = {}
        local counts = 0
        for i=1,6 do
        	local image = ccui.Helper:seekWidgetByName(root, "Image_zw1_"..i)
    		local attribute = addFormation[5+i]
            local lenghtAdd = string.len(attribute)
            local value = 1
            local index = 1
            if lenghtAdd > 2 then 
            -- 有加层
            	image:setVisible(true)
        		local info = zstring.split("".. attribute,"|")
	        	if info ~= nil and #info == 2 then
	        		--两种属性 必然是防御 物理防御，法术防御
	        		index = 40
	        		value = zstring.tonumber(zstring.split(""..info[1],",")[2])
              	end
	         	if info ~= nil and #info == 1 then 
                    --一种属性
                    local addAttribute = zstring.split("".. info[1],",")
                    index = zstring.tonumber(addAttribute[1]) + 1
                    value = zstring.tonumber(addAttribute[2])
               	end
                counts = counts + 1
	            local formationText = ccui.Helper:seekWidgetByName(root, "Text_zw"..counts)
	            formationText:setString("" .._pet_tipString_info[13] .. i .. " " .. string_equiprety_name[index] .. value ..string_equiprety_name_vlua_type[index])
	        end
	    end
    end
    --训练满阶判断
    local Button_xunlian = ccui.Helper:seekWidgetByName(root, "Button_xunlian")
    local pet_id = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.base_mould2) 
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
    local trains = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
    if trains ~= nil then 
        local level = zstring.tonumber(self.hero.train_level)
        local currentTrainId = nil
        for i,v in pairs(trains) do
            if dms.atoi(v, pet_train_experience.train_level) == level then 
                currentTrainId = dms.atoi(v, pet_train_experience.id)
                break
            end
        end
        if currentTrainId ~= nil then 
            local nextTrainId = dms.int(dms["pet_train_experience"],currentTrainId,pet_train_experience.train_next_level)
            if nextTrainId == -1 then 
                --满级
                Button_xunlian:setTouchEnabled(false)
                Button_xunlian:setColor(cc.c3b(150, 150, 150))
            end
        end
    end
end

function PetTrainInformation:onEnterTransitionFinish()

    --获取 宠物碎片选项卡 美术资源
    local csbGeneralsInformation_4 = csb.createNode("packs/PetStorage/PetStorage_information_list_4.csb")
	local root = csbGeneralsInformation_4:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_4)

    local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xunlian"), nil, 
	{
		terminal_name = "pet_information_to_train",
		terminal_state = 0,
		_ship_id = self.hero.ship_id,
		isPressedActionEnabled = true
	}, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qh"), nil, 
    {
        terminal_name = "pet_information_to_browse",
        terminal_state = 0,
        _ship = self.hero,
        isPressedActionEnabled = true
    }, nil, 0)
    
	
	self:onUpdateDraw()
end

function PetTrainInformation:onExit()
	state_machine.remove("pet_information_to_train")
    state_machine.remove("pet_information_to_browse")
end

function PetTrainInformation:init(hero,userfashion,listPositionX)
	self.hero = hero
end

function PetTrainInformation:createCell()
	local cell = PetTrainInformation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end