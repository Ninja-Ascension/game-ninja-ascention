local _jtsCacher = cc.Node:create()
_jtsCacher:retain()

cacher = cacher or {_ObjectPool = {}, _TexturePool = {}, _ArmatureFileInfo = {}, _RefPool = {}}

local textureCache = cc.Director:getInstance():getTextureCache()

function cacher.imageLoaded(jtsCacher, texture)
	if texture ~= nil then
		for i, v in pairs(cacher._TexturePool) do
			if v == texture then
				return
			end
		end
		-- texture:retain()
		-- table.insert(cacher._TexturePool, texture)
	end
end

function cacher.addTextureAsync(fileNames)
	if fileNames == nil then
		return
	end
	for i, v in pairs(fileNames) do
		textureCache:addImageAsync(v, cacher.imageLoaded, _jtsCacher, true, true)
		-- textureCache:addImageAsync(v, cacher.imageLoaded, _jtsCacher, true)
	end
end


function cacher.addTextures(fileNames)
	if fileNames == nil then
		return
	end
	for i, v in pairs(fileNames) do
		if textureCache:getTextureForKey(v) == nil then
			local texture = textureCache:addImage(v)
			texture:retain()
			-- table.insert(cacher._TexturePool, texture)
			cacher._TexturePool[v] = texture
		end
	end
end

function cacher.removeTextureForKeys(fileNames)
	if fileNames == nil then
		return
	end
	for i, v in pairs(fileNames) do
		local texture = cacher._TexturePool[v]
		cacher._TexturePool[v] = nil
		if texture ~= nil then
			texture:release()
		end
	end

	-- for i, v in pairs(cacher._TexturePool) do
	-- 	v:release()
	-- end
	-- cacher._TexturePool = {}
	textureCache:removeUnusedTextures()
end

function cacher.removeAllTextures()
	for i, v in pairs(cacher._TexturePool) do
		v:release()
	end
	cacher._TexturePool = {}
	textureCache:removeUnusedTextures()
end

function cacher.addObject(_object)
	if _object ~= nil then
		-- table.insert(cacher._ObjectPool, _object)
		cacher._ObjectPool[_object.__cname] = _object
		_object:retain()
	end
end

function cacher.getObject(_cname)
	return cacher._ObjectPool[_cname]
end

function cacher.removeObject(_cname)
	local _object = cacher._ObjectPool[_cname]
	if _object ~= nil then
		_object:release()
	end
	cacher._ObjectPool[_cname] = nil
end

function cacher.removeAllObject(_object)
	for i, v in pairs(cacher._ObjectPool) do
		v:release()
	end
	cacher._ObjectPool = {}
end

function cacher.createUIRef(_key, _rootName)
	local _ref = csbCacher.getRef(_key)
	
	if _ref == nil then
		_ref = cacher.getRef(_key)
	end
	if _ref == nil then
		_ref = csb.createNode(_key)
		if _rootName ~= nil then
			local root = _ref:getChildByName(_rootName)
			if root ~= nil then
				root:removeFromParent(false)
				_ref = root
			end
		end
		_ref.___ckey = _key
		cacher.addRef(_key, _ref)
	end
	return _ref
end

function cacher.addRef(_key, _ref)
	cacher._RefPool[_key] = cacher._RefPool[_key] or {_used = {}, _free = {}, _clone = {}}
	local pool = cacher._RefPool[_key]
	table.insert(pool._used, _ref)
	_ref:retain()
end

function cacher.getRef(_key)
	local pool = cacher._RefPool[_key]
	if pool ~= nil then
		-- print("pool:", #pool._used, #pool._free)
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

function cacher.clone(_key, _rootName)
	local _ref = cacher.getRef(_key)
	if _ref == nil then
		local pool = cacher._RefPool[_key] or {_used = {}, _free = {}, _clone = {}}
		local _object = pool._clone[1]
		if _object == nil then
			_object = csb.createNode(_key)
			if _rootName ~= nil then
				local root = _object:getChildByName(_rootName)
				if root ~= nil then
					root:removeFromParent(false)
					_object = root
				end
			end
			table.insert(pool._clone, _object)
			_object:retain()
		end

		_ref = _object:clone()
		_ref.___ckey = _key
		cacher.addRef(_key, _ref)
	end
	return _ref
end

function cacher.freeRef(_key, _ref)
	if _ref == nil then
		return nil
	end
	local result = csbCacher.freeRef(_key, _ref)

	if result == nil then
		local pool = cacher._RefPool[_key]
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
	end
end

function cacher.destoryRef(_key, _ref)
	local pool = cacher._RefPool[_key]
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

function cacher.destoryRefPool(_key)
	local pool = cacher._RefPool[_key]
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

function cacher.destoryRefPools()
	if phoneMemoryEnough == false then
		return
	end
	for k, v in pairs(cacher._RefPool) do
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
end

function cacher.addArmatureFileInfo(fileName)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
	if cacher._ArmatureFileInfo[fileName] == nil then
		cacher._ArmatureFileInfo[fileName] = 0
	end
	cacher._ArmatureFileInfo[fileName] = cacher._ArmatureFileInfo[fileName] + 1
end

function cacher.addArmatureFileInfoAsync(fileName, invoke)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, invoke)
	if cacher._ArmatureFileInfo[fileName] == nil then
		cacher._ArmatureFileInfo[fileName] = 0
	end
	cacher._ArmatureFileInfo[fileName] = cacher._ArmatureFileInfo[fileName] + 1
end

function cacher.remvoeUnusedArmatureFileInfoes()
	for i, v in pairs(cacher._ArmatureFileInfo) do
		if v == 0 then
			ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(i)
		else
			cacher._ArmatureFileInfo[i] = 0
		end
	end
end

function cacher.cleanSystemCacher()
	cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames() 
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

function cacher.cleanActionTimeline( ... )
	-- ccs.ActionManagerEx:destroyInstance()
	ccs.ActionTimelineCache:destroyInstance()
	cc.Director:getInstance():getActionManager():removeAllActions()
end

function cacher.clearWindowCacher()
	cc.Director:getInstance():purgeCachedData()
	_ED.hero_main_Preloading_1 = 0.2
	_ED.hero_main_Preloading_2 = 0.5
end

function cacher.destorySystemCacher(notRemoveArmature)
	ccs.ObjectFactory:destroyInstance()
	ccs.GUIReader:destroyInstance()
	ccs.ActionManagerEx:destroyInstance()
	-- ccs.ActionTimelineCache:destroyInstance()
	-- cc.Director:getInstance():getActionManager():removeAllActions()
	-- cc.Director:getInstance():getEventDispatcher():removeAllEventListeners()
	if notRemoveArmature == nil or (notRemoveArmature ~= nil and notRemoveArmature == false) then
		ccs.ArmatureDataManager:destroyInstance()
	end
	cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
	cc.Director:getInstance():purgeCachedData()
	cc.GLProgramCache:destroyInstance()
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end
