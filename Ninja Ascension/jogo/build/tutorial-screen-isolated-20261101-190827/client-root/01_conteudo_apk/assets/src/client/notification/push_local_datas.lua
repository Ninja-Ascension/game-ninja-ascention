dms2 = dms2 or {}

function dms2.searchs(element, column1, value1, column2, value2)
	if element == nil or column1 == nil or value1 == nil then
        debug.log(true, "dms2 moudle in function 「dms2.searchs」: element ", element, " column ", column1, " value ", value1)
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
			debug.log(true, "dms2 moudle in function 「dms2.searchs」: element[", i, "][", column1, "] is nil.")
			-- return nil
            break
		end
		if data[column1] == tostring(value1) then
			if column2 ~= nil and value2 ~= nil then
				column2 = tonumber(""..column2)
				if data[column2] == nil then
					debug.log(true, "dms2 moudle in function 「dms2.searchs」: element[", i, "][", column2, "] is nil.")
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
