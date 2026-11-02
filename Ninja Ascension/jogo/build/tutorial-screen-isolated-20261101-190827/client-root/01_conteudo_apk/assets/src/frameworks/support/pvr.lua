local pvr = {}

function pvr.convert(filePath)
	local img = cc.Sprite:create(filePath)
	img:setPosition(cc.p(0,0))
	img:setAnchorPoint(cc.p(0,0))
	local sz = img:getContentSize()
	
	local pRT = cc.RenderTexture:create(sz.width, sz.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	pRT:clear(1,1,1,0)
	pRT:begin()
	img:visit()
	pRT:endToLua()
    cc.render()

	local strSaveFile = zstring.replace(filePath, ".pvr.ccz", "")
	strSaveFile = strSaveFile .. ".png";

	print(strSaveFile)

	local pImage = pRT:newImage(true);
	pImage:saveToFile(strSaveFile, false);
	pImage:release()
	pImage = nil
end


function pvr.converts(path)
	local fileInfo = io.popen('find * ' .. path)
	-- debug.print_r(fileInfo)
	local fileTable = {}
	for file in fileInfo:lines() do 
		print(file)
		if string.find(file, "%.ccz$") then
			-- print(file)
			table.insert(fileTable, file)
		end
	end

	for i, v in pairs(fileTable) do
		pvr.convert(v)
	end
end

return pvr


-- print("Lua Script Start")

-- function getFileName( path )
--     len = string.len(PNG_PATH);
--     return string.sub(path, len+2) --  remove "/"
-- end

-- function isInIt( file,name )
--     --print(file .. " -- " .. name )
--     for line in io.lines(file) do
--         if isContain(line , name) then 
--             return true;
--         end
--     end
--     return false;
-- end

-- function isContain( line , str )
--     return string.find(line , str);
-- end

-- PNG_PATH = "user/image" 
-- getPngFileTable = io.popen('find * ' .. PNG_PATH)

-- pngFileTable = {};
-- for file in getPngFileTable:lines() do 
--     if string.find(file,"%.png$") then
--         fileName = getFileName(file);
--         print(fileName)
--         table.insert(pngFileTable,fileName);
--     end
-- end
-- print("png count is :"..#pngFileTable);

-- LUA_PATH = "/Users/apple/Desktop/201803301945499e59d2_jm_uc/assets/1"
-- getLuaFileInfo = io.popen('find * ' .. LUA_PATH)
-- luaFileTable = {};
-- for file in getLuaFileInfo:lines() do 
--     if string.find(file,"%.lua$") then
--         --print(file)
--         table.insert(luaFileTable,file);
--     end
-- end

-- local pairs = pairs
-- for _,name in pairs(pngFileTable) do
--     flag = 0;
--     for _,file in pairs(luaFileTable) do
--         if isInIt(file , name) then 
--             flag = 1;
--             break;
--         end
--     end
--     if flag == 0 then 
--         print(name)
--     end
-- end