csb = csb or {}

csb.rootPath = "cocostudio/"
csb.sceneReader = ccs.SceneReader:getInstance()
csb.guiReader = ccs.GUIReader:getInstance()

function csb.luaFun(script)
    local func = assert(loadstring(script))
    if func ~= nil then
        local ret = func()
        return ret
    end
    return nil
end
-- return:(.. or var)
--  cc.p(0, 0)
--  cc.c3b(255, 255, 255)
--  string.format("%s", "text")
function csb.getCustomProperty(widget, separater, index)
    local customProperty = widget:getCustomProperty()
    local script = nil
    if customProperty ~= nil and #customProperty > 0 then
        if separater == nil or index == nil or index == 0 then
            return csb.luaFun(customProperty)
        else
            script = zstring.split(customProperty, separater)
            if #script > 0 then
                if index > 0 then
                    return csb.luaFun("return " .. script[index])
                else
                    local ret = {}
                    for i, v in pairs(script) do
                        table.insert(ret, csb.luaFun("return " .. v))
                    end
                    return ret
                end
            end
        end
    end
    return nil
end

-- Un .csb que no viaja en el paquete tumbaba el juego SIN traza de Lua:
-- CSLoader::createNode lee el flatbuffer de un buffer vacio y revienta
-- dentro del motor. La guarda convierte ese cierre nativo en un aviso
-- con el nombre del fichero y un nodo vacio con su hijo "root", que es
-- lo que buscan todos los llamantes.
function csb.createNode(fileName)
    local path = csb.rootPath .. fileName
    if cc.FileUtils:getInstance():isFileExist(path) == false then
        print("[csb] FALTA EL FICHERO: " .. path)
        local hueco = cc.Node:create()
        local root = cc.Node:create()
        root:setName("root")
        hueco:addChild(root)
        return hueco
    end
    return cc.CSLoader:createNode(path)
end

-- Misma trampa que createNode: ActionTimelineCache lee el flatbuffer de un
-- buffer vacio y el motor se cierra. Casi todos los llamantes piden la
-- timeline del MISMO .csb justo despues de createNode, asi que sin esta
-- guarda la de createNode no evitaba el cierre. Se devuelve una
-- ActionTimeline vacia (ccs.ActionTimeline:create, cocos2d-x 3.5): runAction
-- la acepta y play/gotoFrameAndPlay/gotoFrameAndPause/setTimeSpeed/
-- setFrameEventCallFunc no hacen nada; getDuration/getEndFrame dan 0 e
-- IsAnimationInfoExists da false. OJO: sus eventos de fotograma NUNCA
-- llegan, asi que lo que espere un "close"/"over" de esa animacion se queda
-- quieto en vez de cerrar el juego.
function csb.createTimeline(fileName)
    local path = csb.rootPath .. fileName
    if cc.FileUtils:getInstance():isFileExist(path) == false then
        print("[csb] FALTA EL FICHERO (timeline): " .. path)
        return ccs.ActionTimeline:create()
    end
    return cc.CSLoader:createTimeline(path)
end

function csb.createWidget(fileName)
    return csb.guiReader:widgetFromBinaryFile(csb.rootPath .. fileName)
end

function csb.createScene(fileName)
    return csb.sceneReader:createNodeWithSceneFile(csb.rootPath .. fileName)
end

function csb.changeAction_animationEventCallFunc(armatureBack,movementType,movementID)
    local id = movementID
    if armatureBack._changing == nil then
        armatureBack._changing = true
        if armatureBack._reset ~= nil then
            armatureBack._reset(armatureBack)
        end

        if nil ~= armatureBack._lockActionIndex and armatureBack._lockActionIndex > 0 then
            armatureBack._nextAction = armatureBack._lockActionIndex
        end
        if armatureBack._nextAction ~= nil and armatureBack._actionIndex ~= armatureBack._nextAction then
            armatureBack._actionIndex = armatureBack._nextAction
            armatureBack._actionLoopCount = 0
            armatureBack:getAnimation():playWithIndex(armatureBack._nextAction)
            if armatureBack.__shader_spx ~= nil then
                armatureBack.__shader_spx:getAnimation():playWithIndex(armatureBack._nextAction)
                armatureBack.__shader_spx._actionIndex = armatureBack._actionIndex
                armatureBack.__shader_spx._nextAction = armatureBack._nextAction
                if nil ~= armatureBack.__shader_spx_need_visible then
                    armatureBack.__shader_spx:setVisible(armatureBack.__shader_spx_need_visible)
                end
            end
        end
        if armatureBack._nextFunc ~= nil 
            and armatureBack._nextFunc ~= csb.changeAction_animationEventCallFunc  then
            armatureBack:getAnimation():setMovementEventCallFunc(armatureBack._nextFunc)
        end 
        armatureBack._changing = nil
        
        if armatureBack._invoke ~= nil then
            armatureBack._invoke(armatureBack)
        end
    end
    if armatureBack._actionLoopCount ~= nil then
        armatureBack._actionLoopCount = armatureBack._actionLoopCount + 1
    end
end

function csb.nil_animationEventCallFunc(armatureBack,movementType,movementID)
    -- 无效的动画帧组监听状态
    if armatureBack._changing == nil then
        armatureBack._nextFunc = nil
        armatureBack._changing = true
        armatureBack:getAnimation():removeMovementEventCallFunc()
        armatureBack._changing = nil
    end
end

function csb.animationChangeToAction(armature, changeToAction, nextAction, callInvoke)
    if nil ~= armature._lockActionIndex and armature._lockActionIndex > 0 then
        return
    end
    armature._actionLoopCount = 0
    armature._changing = true
    if changeToAction ~= nil and changeToAction > -1 then
        armature:getAnimation():playWithIndex(changeToAction)
        armature._actionIndex = changeToAction
        if armature.__shader_spx ~= nil then
            -- if armature.__shader_spx_need_visible == true then
            --     armature.__shader_spx_need_visible = false
            --     armature.__shader_spx:getAnimation():playWithIndex(changeToAction)
            --     armature.__shader_spx._actionIndex = changeToAction
            --     armature.__shader_spx._nextAction = nextAction
            --     armature.__shader_spx:setVisible(true)
            -- else
            --     armature.__shader_spx:setVisible(false)
            -- end

            armature.__shader_spx:getAnimation():playWithIndex(changeToAction)
            armature.__shader_spx._actionIndex = changeToAction
            armature.__shader_spx._nextAction = nextAction
            if nil ~= armature.__shader_spx_need_visible then
                armature.__shader_spx:setVisible(armature.__shader_spx_need_visible)
            end
        end
    end
    armature._nextAction = nextAction
    if callInvoke == true then
        if armature._invoke ~= nil then
            armature._invoke(armature)
        end
    end
    armature._changing = nil
end

-- 加载光效资源文件
function csb.loadEffect(fileName)
    -- local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
    -- CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    --local armatureName = string.format("effice_%d", fileIndex)
    return armatureName
end

function csb.deleteEffect(armatureBack)
    if armatureBack == nil then
        return
    end
    
    if armatureBack._LastsCountTurns > 0 then
        -- 删除光效
        armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns - 1
        if armatureBack._LastsCountTurns <= 0 then
            local fileName = armatureBack._fileName
            armatureBack:removeFromParent(true)
            -- 删除光效文件
            if nil ~= fileName then
                ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
            end
        end
    end
end

function csb.createEffect(armatureName, armatureFile, armaturePad, loop, ZOrder, actionTimeSpeed)
    if nil ~= armatureFile then
        csb.loadEffect(armatureFile)
    end
    local armature = ccs.Armature:create(armatureName)
    armature._fileName = armatureFile
    armature._invoke = csb.deleteEffect
    armature._actionIndex = 0
    armature._nextAction = 0
    if loop ~= nil and loop > 0 then
        armature._LastsCountTurns = loop
    else
        armature._LastsCountTurns = -1
    end
    
    if armaturePad ~= nil then
        if ZOrder ~= nil then
            armaturePad:addChild(armature, ZOrder)
        else
            armaturePad:addChild(armature)
        end
        armature:setPosition(cc.p(armaturePad:getContentSize().width/2, armaturePad:getContentSize().height/2))
    end
    if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
        armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
    end
    armature:setPosition(cc.p(armaturePad:getContentSize().width/2, armaturePad:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    return armature
end














































DisplayUtil = DisplayUtil or {}
--不进行灰化的对象特有的方法
DisplayUtil.LIST_DONT_GRAY = {
    "getSprite",     --ProgressTimer
    "setString",     --Label
}
--判断能否灰化
function DisplayUtil.canGray(node)
    for i,v in ipairs(DisplayUtil.LIST_DONT_GRAY) do
        if node[v] then
            return false
        end
    end
    return true
end
--灰化对象
function DisplayUtil.setGray(node, v)
    if type(node) ~= "userdata" then
        printError("node must be a userdata")
        return
    end
    if v == nil then
        v = true
    end
    if not node.__isGray__ then
        node.__isGray__ = false
    end
    if v == node.__isGray__ then
        return
    end
    if v then
        if DisplayUtil.canGray(node) then
        --调用C++的setGray方法
            -- setGray(tolua.cast(node, "cocos2d::Node"))
            cc.setGray(node)
            --
            -- local glProgram = node:getGLProgram()
            -- node:setGLProgram(glProgram)
            -- node:getGLProgram():bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
            -- node:getGLProgram():bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            -- node:getGLProgram():bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)
            -- --不知道为什么下面2行一定要写
            -- node:getGLProgram():link()
            -- node:getGLProgram():updateUniforms()
        end
        --children
        local children = node:getChildren()
        if children and table.nums(children) > 0 then
            --遍历子对象设置
            for i,v in ipairs(children) do
                if DisplayUtil.canGray(v) then
                    DisplayUtil.setGray(v)
                end
            end
        end
    else
        DisplayUtil.removeGray(node)
    end
    node.__isGray__ = v
end
--取消灰化
function DisplayUtil.removeGray(node)
    if type(node) ~= "userdata" then
        printError("node must be a userdata")
        return
    end
    if not node.__isGray__ then
        return
    end
    if DisplayUtil.canGray(node) then
        local glProgram = cc.GLProgramCache:getInstance():getGLProgram(
            "ShaderPositionTextureColor_noMVP")
        node:setGLProgram(glProgram)
        -- glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
        -- glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
        -- glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)
        --不知道为什么下面2行不能写，写了会出问题
        -- glProgram:link()
        -- glProgram:updateUniforms()
    end
    --children
    local children = node:getChildren()
    if children and table.nums(children) > 0 then
        --遍历子对象设置
        for i,v in ipairs(children) do
            if DisplayUtil.canGray(v) then
                DisplayUtil.removeGray(v)
            end
        end
    end
    node.__isGray__ = false
end
