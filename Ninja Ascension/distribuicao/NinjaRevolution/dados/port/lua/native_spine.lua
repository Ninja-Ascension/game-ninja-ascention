-- Original Spine Lua surface backed by the pinned, rendering Spine 2.1 C runtime.
local M={}
function M.armar()
    assert(type(cc.nrSpineCreate)=='function','Native Spine bridge not registered')
    sp=sp or {}
    -- Valores do Spine 2.1 REAL (o runtime que este build usa), conforme
    -- build/deps/spine-2.1.25/spine-c/include/spine/AnimationState.h:42-44:
    --     typedef enum { SP_ANIMATION_START, SP_ANIMATION_END,
    --                    SP_ANIMATION_COMPLETE, SP_ANIMATION_EVENT }
    -- ou seja START=0, END=1, COMPLETE=2, EVENT=3.
    --
    -- A tabela anterior reproduzia o Spine 3.x do Cocos2d-x
    -- (START=0, INTERRUPT=1, END=2, COMPLETE=3, DISPOSE=4, EVENT=5), que tem
    -- dois tipos a mais e desloca todos os valores. Efeito medido: o acervo
    -- registrava o callback em ANIMATION_COMPLETE=3 e o despacho nativo
    -- chegava com 2, portanto csb.changeAction_animationEventCallFunc nunca
    -- era chamado — a onda 2 era criada mas nunca liberada.
    --
    -- INTERRUPT e DISPOSE nao existem no 2.1. Ficam apontados para os tipos
    -- mais proximos para que codigo do acervo escrito para 3.x nao quebre ao
    -- ler o campo, mas nenhum evento nativo despacha esses numeros.
    sp.EventType={ANIMATION_START=0,ANIMATION_END=1,ANIMATION_COMPLETE=2,
        ANIMATION_EVENT=3,
        ANIMATION_INTERRUPT=1,ANIMATION_DISPOSE=2}
    function __nrSpineDispatch(node,kind,event)
        event.skeletonAnimation=node
        local handler=node.__nrSpineHandlers and node.__nrSpineHandlers[kind]
        if handler then handler(event) end
    end
    local methods={}
    -- The original Spine runtime only logs an unknown animation name and keeps
    -- the current pose (e.g. SoulWardingWindow asks for "animation1", which the
    -- asset does not have); the pinned bridge would throw instead.
    local function hasAnimation(self,name)
        for _,v in ipairs(self.__nrNames or self.animationNameList or {}) do if v==name then return true end end
        return false
    end
    function methods:setAnimation(track,name,loop)
        if not hasAnimation(self,name) then
            print('HOST_NATIVE_SPINE missing animation ignored: '..tostring(name))
            return nil
        end
        local duration=cc.nrSpineCommand(self,'play',track,name,loop)
        return {animation={name=name,duration=duration},trackIndex=track}
    end
    function methods:addAnimation(track,name,loop,delay)
        if not hasAnimation(self,name) then return nil end
        local duration=cc.nrSpineCommand(self,'queue',track,name,loop,delay or 0)
        return {animation={name=name,duration=duration},trackIndex=track}
    end
    function methods:setTimeScale(speed) cc.nrSpineCommand(self,'speed',speed) end
    function methods:setSkin(name) cc.nrSpineCommand(self,'skin',name) end
    function methods:setToSetupPose() cc.nrSpineCommand(self,'setup') end
    function methods:setMix(from,to,duration) cc.nrSpineCommand(self,'mix',from,to,duration) end
    function methods:getAnimationDurationEx(name) return cc.nrSpineCommand(self,'duration',name) end
    function methods:getMovementCountEx() return #cc.nrSpineCommand(self,'names') end
    function methods:clearTracks() cc.nrSpineCommand(self,'clear') end
    function methods:registerSpineEventHandler(handler,kind)
        assert(type(handler)=='function','Spine handler must be a function')
        self.__nrSpineHandlers=self.__nrSpineHandlers or {};self.__nrSpineHandlers[kind]=handler
    end
    function methods:unregisterSpineEventHandler(kind)
        if self.__nrSpineHandlers then self.__nrSpineHandlers[kind]=nil end
    end
    -- Diagnostic outlines are optional; animation and gameplay calls above are real.
    function methods:setDebugSlotsEnabled(enabled) self.__nrDebugSlots=enabled end
    function methods:setDebugBonesEnabled(enabled) self.__nrDebugBones=enabled end
    sp.SkeletonAnimation={}
    function sp.SkeletonAnimation:create(json,atlas,scale)
        local node,err=cc.nrSpineCreate(json,atlas,scale or 1)
        assert(node,err or 'Native Spine creation failed')
        for name,fn in pairs(methods) do node[name]=fn end
        node.animationNameList=cc.nrSpineCommand(node,'names')
        node.__nrNames=node.animationNameList  -- real names; callers may replace animationNameList
        print('HOST_NATIVE_SPINE created '..json..' animations='..#node.animationNameList)
        return node
    end
    print('HOST_NATIVE_SPINE adapter installed; invisible fallback disabled')
end
return M
