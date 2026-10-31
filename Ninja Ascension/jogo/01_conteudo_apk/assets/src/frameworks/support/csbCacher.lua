local _jtsCsbCacher = cc.Node:create()
_jtsCsbCacher:retain()

csbCacher = csbCacher or {_ObjectPool = {}, _RefPool = {}}

local textureCache = cc.Director:getInstance():getTextureCache()

function csbCacher.addObject(_object)
	if _object ~= nil then
		csbCacher._ObjectPool[_object.__cname] = _object
		_object:retain()
	end
end

function csbCacher.getObject(_cname)
	return csbCacher._ObjectPool[_cname]
end

function csbCacher.removeObject(_cname)
	local _object = csbCacher._ObjectPool[_cname]
	if _object ~= nil then
		_object:release()
	end
	csbCacher._ObjectPool[_cname] = nil
end

function csbCacher.removeAllObject()
	for i, v in pairs(csbCacher._ObjectPool) do
		v:release()
	end
	csbCacher._ObjectPool = {}
end

function csbCacher.createUIRef(_key, _rootName)
	local _ref = csb.createNode(_key)--csbCacher.getRef(_key)
	-- if _ref == nil then
		-- _ref = csb.createNode(_key)
		if _rootName ~= nil then
			local root = _ref:getChildByName(_rootName)
			if root ~= nil then
				root:removeFromParent(false)
				_ref = root
			end
		end
		_ref.___ckey = _key
		csbCacher.addRef(_key, _ref)
	-- end
	return _ref
end

function csbCacher.addRef(_key, _ref)
	csbCacher._RefPool[_key] = csbCacher._RefPool[_key] or {_used = {}, _free = {}}
	local pool = csbCacher._RefPool[_key]
	table.insert(pool._free, _ref)
	_ref:retain()
end

function csbCacher.getRef(_key)
	local pool = csbCacher._RefPool[_key]
	if pool ~= nil then
		local _ref = pool._free[1]
		if _ref ~= nil then
			if _ref:getParent() ~= nil then
				_ref:removeFromParent(false)
			end
			table.remove(pool._free, 1, 1)
			-- Un padre con opacidad en cascada (el icono atenuado del pase de temporada)
			-- deja su opacidad MOSTRADA en el nodo libre y el siguiente que lo presta
			-- (la mochila) lo pinta medio transparente: se repone al sacarlo del pool.
			_ref:setOpacity(_ref:getOpacity())
			table.insert(pool._used, _ref)
			return _ref
		end
	end
	return nil
end

function csbCacher.freeRef(_key, _ref)
	if _ref == nil then
		return nil
	end
	local pool = csbCacher._RefPool[_key]
	if pool ~= nil then
		for i, v in pairs(pool._used) do
			if v == _ref then
				if _ref:getParent() ~= nil then
					_ref:removeFromParent(false)
				end
				table.remove(pool._used, i, 1)
				table.insert(pool._free, _ref)
				return _ref
			end
		end
	end
	return nil
end

function csbCacher.destoryRef(_key, _ref)
	local pool = csbCacher._RefPool[_key]
	if pool ~= nil then
		for i, v in pairs(pool._used) do
			if v == _ref then
				_ref:release()
				table.remove(pool._used, i, 1)
				break
			end
		end
		for i, v in pairs(pool._free) do
			if v == _ref then
				_ref:release()
				table.remove(pool._free, i, 1)
				break
			end
		end
	end
end

function csbCacher.destoryRefPool(_key)
	local pool = csbCacher._RefPool[_key]
	if pool ~= nil then
		for i, v in pairs(pool._used) do
			if v ~= nil then
				v:release()
				break
			end
		end
		for i, v in pairs(pool._free) do
			if v ~= nil then
				v:release()
				break
			end
		end
	end
end

function csbCacher.destoryRefPools()
	for k, v in pairs(csbCacher._RefPool) do
		local pool = v
		if pool ~= nil then
			for i, v in pairs(pool._used) do
				if v ~= nil then
					v:release()
				end
			end
			pool._used = {}
			for i, v in pairs(pool._free) do
				if v ~= nil then
					v:release()
				end
			end
			pool._free = {}
		end
	end
	csbCacher._RefPool = {}
end

function csbCacher.load()
	csbCacher.destoryRefPools()
	for k,v in pairs(csb_cacher_path) do
		local id = v[1]
		local path = v[2]
		local count = v[3]
		for j=1,tonumber(count) do
			csbCacher.createUIRef(path, "root")
		end
	end
end