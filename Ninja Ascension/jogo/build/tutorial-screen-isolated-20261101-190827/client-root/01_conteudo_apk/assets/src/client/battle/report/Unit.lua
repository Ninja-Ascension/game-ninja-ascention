
Unit = {}

function Unit.getRandomWithNoRepeat(list, count)
	local randList = {}
	local vector = {}
	for i,v in pairs(list) do
		table.insert(vector,i)
	end
	local tempCount = #list
	for i=1,tonumber(count) do
		local id = math.random(1,tempCount)
		if vector[id] ~= nil then
			local k = vector[id]
			local object = list[k]
			table.insert(randList,object)
		else
		end
		table.remove(vector,id)
		tempCount = tempCount-1
	end
	return randList
end

