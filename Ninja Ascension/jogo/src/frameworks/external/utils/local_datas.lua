dms = dms or {}

function dms.unload( filePath )
    if filePath == nil then
        debug.log(true, "dms moudle in function 「dms.load」: filePath is nil.")
        return nil
    end
    local strLength = string.len(filePath)
    local fileName = strippath(filePath) --stripExtension(strippath(filePath)))
    local extensionName = getExtension(fileName)
    fileName = stripExtension(fileName)
    extensionName = "."..extensionName
    dms[fileName] = nil
end

function dms.load(filePath)
    if filePath == nil then
        debug.log(true, "dms moudle in function 「dms.load」: filePath is nil.")
        return nil
    end
    local strLength = string.len(filePath)
    local fileName = strippath(filePath) --stripExtension(strippath(filePath)))
    local extensionName = getExtension(fileName)
    fileName = stripExtension(fileName)
    extensionName = "."..extensionName
    if dms[fileName] ~= nil then
        return dms[fileName]
    end
    
    local lua = ".lua"
    local luac = ".luac"
    if extensionName == lua or extensionName == luac then
        return app.load(filePath)
    end

    local txt = ".txt"
	local cdn = ".cdn"
    if extensionName == txt or extensionName == cdn then
        local data, len = cc.dms_load(filePath) -- app.fileUtils:getStringFromFile(filePath)
        if len ~= nil and len > 0 then
            data = string.sub(data, 1, len)
        end
        local element = split(data, "\r\n")
        if element[1] == data then
            element = split(data, "\n")
        end
        if element[table.getn(element)] == "" then
            element[table.getn(element)] = nil
        end
        -- element.data = data
        dms[fileName] = element
    else
        local data = cc.dms_load(filePath) -- app.fileUtils:getStringFromFile(filePath)
        local element = split(data, "\r\n")
        if element[1] == data then
            element = split(data, "\n")
        end
        if element[table.getn(element)] == "" then
            element[table.getn(element)] = nil
        end
        -- element.data = data
        dms[fileName] = element
    end
    return dms[fileName]
end

function dms.count(element)
    if element == nil then
        debug.log(true, "dms moudle in function 「dms.element」: element ", element)
        return nil
    end
    -- return table.getn(element)
    return table.nums(element)
end

function dms.element(element, row, format)
	if element == nil or row == nil then
        debug.log(true, "dms moudle in function 「dms.element」: element ", element, " row ", row)
        return nil
    end
	row = tonumber(""..row)
    if element[row] == nil then
        debug.log(true, "dms moudle in function 「dms.element」: element[", row, "] is nil.")
        return nil
    end
    if true == format then
        local data = element[row]
        if nil ~= data and "string" == type(data) then
            data = split(data, "\t")
            return data
        end
    end
    return element[row]
end

function dms._element(data, column, _value, _rcolumn)
	if data ~= nil and _value ~= nil then
		for i, v in pairs(data) do
			if dms.atos(v, column) == "".._value then
				return dms.atos(v, _rcolumn)
			end
		end
	end
	return nil
end

function dms.atos(data, column)
	if data == nil or column == nil then
        debug.log(true, "dms moudle in function 「dms.atos」: data ", data, " column ", column)
        return nil
    end
	column = tonumber(""..column)
	if data[column] == nil then
        data = split(data, "\t")
    end
    if data[column] == nil then
        debug.log(true, "dms moudle in function 「dms.atos」: [", column, "] is nil.")
        return nil
    end
    return data[column]
end

function dms.atoi(data, column)
	local value = dms.atof(data, column)
	if value ~= nil then
        value = math.round(value)
    end
    return value
end

function dms.atof(data, column)
	local value = dms.atos(data, column)
    if value ~= nil then
        value = tonumber(value)
    end
    return value
end

function dms.string(element, row, column)
    if element == nil or row == nil or column == nil then
        debug.log(true, "dms moudle in function 「dms.string」: element ", element, " row ", row, " column ", column)
        return nil
    end
	row = tonumber(""..row)
	column = tonumber(""..column)
    if element[row] == nil then
        debug.log(true, "dms moudle in function 「dms.string」: element[", row, "] is nil.")
        return nil
    end
    if element[row][column] == nil then
        element[row] = split(element[row], "\t")
    end
    if element[row][column] == nil then
        debug.log(true, "dms moudle in function 「dms.string」: element[", row, "][", column, "] is nil.")
        return nil
    end
    return element[row][column]
end

function dms.int(element, row, column)
    local value = dms.float(element, row, column)
    if value ~= nil then
        value = math.round(value)
    end
    return value
end

function dms.float(element, row, column)
    local value = dms.string(element, row, column)
    if value ~= nil then
        value = tonumber(value)
    end
    return value
end

function dms.format(fileName, keyIndex)
    keyIndex = keyIndex or 1
    local element = dms[fileName]
    local datas = {}
    for i, data in ipairs(element) do
        if type(data) == "string" then
            local tdata = split(data, "\t")
            datas[tonumber(tdata[keyIndex])] = tdata
        end
    end
    dms[fileName] = datas
end

function dms.searchs(element, column1, value1, column2, value2)
	if element == nil or column1 == nil or value1 == nil then
        debug.log(true, "dms moudle in function 「dms.searchs」: element ", element, " column ", column1, " value ", value1)
        return nil
    end
	column1 = tonumber(""..column1)
	local datas = {}
	for i, data in ipairs(element) do
		if data[column1] == nil then
			element[i] = split(data, "\t")
            data = element[i]
		end
		if data[column1] == nil then
			debug.log(true, "dms moudle in function 「dms.searchs」: element[", i, "][", column1, "] is nil.")
			-- return nil
            break
		end
		if data[column1] == tostring(value1) then
			if column2 ~= nil and value2 ~= nil then
				column2 = tonumber(""..column2)
				if data[column2] == nil then
					debug.log(true, "dms moudle in function 「dms.searchs」: element[", i, "][", column2, "] is nil.")
					--return nil
                    break
				end
				if data[column2] == tostring(value2) then
					table.insert(datas, data)
				end
			else
				table.insert(datas, data)
			end
		end	
	end
    if #datas <= 0 then
        return nil
    end
	return datas
end

-- function dms.searchsEX(element, ...)
	-- if element == nil or arg[1] == nil or arg[2] == nil then
        -- debug.log(true, "dms moudle in function 「dms.searchsEX」: element ", element, " column ", arg[1], " value ", arg[2])
        -- return nil
    -- end
	
	-- -- local size = 0
	-- -- for i = 1, select('#', ...) do
		-- -- size = size + 1
	-- -- end
	
	-- local index = 1
	-- local column = tonumber(""..arg[1])
	-- local datas = {}
	-- for i, data in ipairs(element) do
		-- if data[column] == nil then
			-- data = split(data, "\t")
		-- end
		-- if data[column] == nil then
			-- debug.log(true, "dms moudle in function 「dms.searchs」: element[", i, "][", column, "] is nil.")
			-- return nil
		-- end
		-- if data[column] == tostring(arg[2]) then
			-- index = index + 2
			
			-- local function findNextCondition()
				-- if arg[index] ~= nil and arg[index+1] ~= nil then
					-- column = tonumber(""..arg[index])
					-- if data[column] == nil then
						-- debug.log(true, "dms moudle in function 「dms.searchs」: element[", i, "][", column, "] is nil.")
						-- return false
					-- end
					-- if data[column] ~= tostring(arg[index+1]) then
						-- return false
					-- else
						-- local size = #arg
						-- if size < index then
							-- return true
						-- else
							-- index = index + 2
							-- findNextCondition()
						-- end
					-- end
				-- end
				-- return false
			-- end
		
			-- if findNextCondition() then
				-- table.insert(datas, data)
			-- else
				-- return nil
			-- end
		-- end	
	-- end
	
	-- return datas
-- end