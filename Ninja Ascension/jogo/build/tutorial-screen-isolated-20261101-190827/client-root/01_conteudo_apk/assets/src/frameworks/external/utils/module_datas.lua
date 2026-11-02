nds = nds or {}

function nds:insert(_nd, _replace, _index, _value)
	if _replace == true then
		local result, index = nds:find(_nd, _index, _value, true)
		if result ~= nil and index ~= nil then
			nds[index] = nil
		end
	end
	-- talbe.insert(nds, _nd)
	nds[_index] = _nd
end

function nds:remove(_index)
    _nd[_index] = nil
end

function nds:removeElement(_index)
    _nd[_index] = nil
end

function nds:element(_nd, _index)
    local result = _nd[_index] 
    return result
end

function nds:index(_nd, _index)
    local result = _nd[_index] 
    return result
end

function nds:find(_nd, _index, _value, _rIndex)
    local result = nil
    local index = nil
    for i, v in pairs(_nd) do
    	if v[_index] == _value then
    		if _rIndex ~= true then
    			return v
    		end
    		result = v
    		index = i
    		break
    	end
    end
    return result, index
end

function nds:contains(_nd, _index, _value)
	local result = nds:find(_nd, _index, _value, false) ~= nil
    return result
end