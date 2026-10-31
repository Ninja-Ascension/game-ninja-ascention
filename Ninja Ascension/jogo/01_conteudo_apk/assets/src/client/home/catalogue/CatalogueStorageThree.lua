-- ----------------------------------------------------------------------------------------------------
-- 说明：图鉴阵容3
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
CatalogueStorageThree = class("CatalogueStorageThreeClass", Window)
	
function CatalogueStorageThree:ctor()
    self.super:ctor()
    self.roots = {}
	self.all = {}
	self.allHero = {}
    -- Initialize CatalogueStorage page state machine.
    
    -- call func init hom state machine.
end

function CatalogueStorageThree.loading(texture)
	local myListView = CatalogueStorageThree.myListView
	if myListView ~= nil then
		local cell = nil
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			then
			cell = CatalogueStorageListNew:createCell()
			cell:init(CatalogueStorageThree.dTreasureArray[CatalogueStorageThree.asyncIndex], 1)
		else
			cell = CatalogueStorageList:createCell()
			cell:init(CatalogueStorageThree.dTreasureArray[CatalogueStorageThree.asyncIndex])
		end
		
		myListView:addChild(cell)
		CatalogueStorageThree.asyncIndex = CatalogueStorageThree.asyncIndex + 1
		myListView:requestRefreshView()
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			cell:addHeroPanel()
		end
	end
end

function CatalogueStorageThree:onUpdateDraw()
	local root = self.roots[1]
	-- camp_preference		阵营
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_03")
	local loadBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_3")
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_13")
	listView:requestRefreshView()
	
	if _ED._legendInfoStatus == "" then
		local data = zstring.split(_ED.catalogue_hero_is_have, ",")
		for i = 1 , table.getn(data)-1 do
			self.allHero[i] =  data[i]
		end
	else
		local data = zstring.split(_ED.catalogue_hero_is_have, ",")
		local nums = 0
		for i = 1 , table.getn(data)-1 do
			self.allHero[i] =  data[i]
			nums = i
		end
		for i = nums+1 , tonumber(_ED._legendNumber) do
			self.allHero[i] =  _ED._legendInfo[i].legendMouldId
		end
	end
	
	local white = {}
	local green = {}
	local blue = {}
	local purple = {}
	local orange = {}
	local red = {}
	local num = 0
	local temp = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		data = _ED.all_ship_mould[1]	
	else
		data = dms.searchs(dms["ship_mould"], ship_mould.camp_preference, 1)
	end
	for i, v in pairs(data) do
		if tonumber(v[4]) == 1 and tonumber(v[45]) == 0 and tonumber(v[6]) == 1 then
			if tonumber(v[36]) == 0 then
				table.insert(white,v[1])
				num = num + 1
			elseif tonumber(v[36]) == 1 then
				table.insert(green,v[1])
				num = num + 1
			elseif tonumber(v[36]) == 2 then
				table.insert(blue,v[1])
				num = num + 1
			elseif tonumber(v[36]) == 3 then
				table.insert(purple,v[1])
				num = num + 1
			elseif tonumber(v[36]) == 4 then
				table.insert(orange,v[1])
				num = num + 1
			elseif tonumber(v[36]) == 5 then
				table.insert(red,v[1])
				num = num + 1
			end
		end
	end
	
	local allNum = 1
	if table.getn(red) ~= 0 then
		-- local cell = CatalogueStorageList:createCell()
		-- cell:init(red)
		-- listView:addChild(cell)
		self.all[allNum] = red
		allNum = allNum + 1
	end
	
	if table.getn(orange) ~= 0 then
		-- local cell = CatalogueStorageList:createCell()
		-- cell:init(orange)
		-- listView:addChild(cell)
		self.all[allNum] = orange
		allNum = allNum + 1
	end
	
	if table.getn(purple) ~= 0 then
		-- local cell = CatalogueStorageList:createCell()
		-- cell:init(purple)
		-- listView:addChild(cell)]
		self.all[allNum] = purple
		allNum = allNum + 1
	end

	if table.getn(blue) ~= 0 then
		-- local cell = CatalogueStorageList:createCell()
		-- cell:init(blue)
		-- listView:addChild(cell)
		self.all[allNum] = blue
		allNum = allNum + 1
	end
	
	if table.getn(green) ~= 0 then
		-- local cell = CatalogueStorageList:createCell()
		-- cell:init(green)
		-- listView:addChild(cell)
		self.all[allNum] = green
		allNum = allNum + 1
	end
	
	if table.getn(white) ~= 0 then
		-- local cell = CatalogueStorageList:createCell()
		-- cell:init(white)
		-- listView:addChild(cell)
		self.all[allNum] = white
		allNum = allNum + 1
	end
	
	local kNum = 0
	for i,v in pairs(self.all) do
		for a,b in pairs(v) do
			for j,k in pairs(self.allHero) do
				if tonumber(b) == tonumber(k) then
					kNum = kNum + 1
					break
				end
			end
		end
	end
	
	CatalogueStorageThree.myListView = listView
	CatalogueStorageThree.dTreasureArray = self.all
	CatalogueStorageThree.asyncIndex = 1
	
	-- if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
	-- 	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- 	for i,v in pairs(self.all) do
	-- 		self.loading()--cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, )
	-- 	end
	-- else
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		for i,v in pairs(self.all) do
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
		end
	-- end
	
	Text_2:setString(_string_piece_info[293])
	local expCount = (kNum)/(num)*100
	loadBar:setPercent(expCount)
end

function CatalogueStorageThree:onEnterTransitionFinish()
	-- local csbCatalogueStorageThree = csb.createNode("system/Atlas_listview_3.csb")

	-- self:addChild(csbCatalogueStorageThree)
	
	-- local root = csbCatalogueStorageThree:getChildByName("root")
	-- table.insert(self.roots, root)
	
	-- self:onUpdateDraw()
   
end
function CatalogueStorageThree:onInit()
	local csbCatalogueStorageThree = csb.createNode("system/Atlas_listview_3.csb")

	self:addChild(csbCatalogueStorageThree)
	
	local root = csbCatalogueStorageThree:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function CatalogueStorageThree:init()
	self:onInit()
	
end

function CatalogueStorageThree:onExit()
	-- if fwin:find("CatalogueStorageThreeClass") ~= nil then
	
		CatalogueStorageThree.myListView = nil
		CatalogueStorageThree.asyncIndex = 1
	-- end
end