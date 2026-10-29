
gray = gray or {}

--不进行灰化的对象特有的方法
gray.LIST_DONT_GRAY = {
    -- "getSprite",     --ProgressTimer
    "setString",     --Label
}
--判断能否灰化
function gray.canGray(node)
    for i,v in ipairs(gray.LIST_DONT_GRAY) do
        if node[v] then
            return false
        end
    end
    return true
end

--灰化对象
function gray.setGray(node)
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
        if gray.canGray(node) then
            -- ------------------------
			if true or cc.Application:getInstance():getTargetPlatform()	~= cc.PLATFORM_OS_WINDOWS then 
				cc.setGray(node)
			end
            
            -- ------------------------
            -- local vertDefaultSource = [[
            --         attribute vec4 a_position;
            --         attribute vec2 a_texCoord;
            --         attribute vec4 a_color;  

            --         #ifdef GL_ES
            --            varying lowp vec4 v_fragmentColor;
            --            varying mediump vec2 v_texCoord;
            --         #else
            --            varying vec4 v_fragmentColor;
            --            varying vec2 v_texCoord;
            --         #endif 

            --         void main()
            --         {
            --            gl_Position = CC_PMatrix * a_position; 
            --            v_fragmentColor = a_color;
            --            v_texCoord = a_texCoord;
            --         }   
            --     ]]
                
            -- local pszFragSource = [[
            --         #ifdef GL_ES 
            --               precision mediump float;
            --         #endif 
            --         varying vec4 v_fragmentColor; 
            --         varying vec2 v_texCoord; 

            --         void main(void) 
            --         { 
            --             vec4 c = texture2D(CC_Texture0, v_texCoord);
            --             gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b);
            --             gl_FragColor.w = c.w; 
            --         }
            --     ]]

            -- local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource, pszFragSource)
            
            -- pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
            -- pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
            -- pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
            -- pProgram:link()
            -- pProgram:updateUniforms()
            -- node:setGLProgram(pProgram) 
            

            -- ------------------------
            -- local glp = cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColorAlphaTest"))
            -- node:setGLProgramState(glp)

            -- if node.getVirtualRenderer then
            --     local img = node:getVirtualRenderer()
            --     if img.setGLProgram then
            --         img:setGLProgram(pProgram)
            --         print("---=-=-==--=-=-=-=-=-----*****")
            --     end
            -- end

            -- ------------------------
            -- local vertDefaultSource = "\n"..
            -- "attribute vec4 a_position; \n" ..
            -- "attribute vec2 a_texCoord; \n" ..
            -- "attribute vec4 a_color; \n"..                                                    
            -- "#ifdef GL_ES  \n"..
            -- "varying lowp vec4 v_fragmentColor;\n"..
            -- "varying mediump vec2 v_texCoord;\n"..
            -- "#else                      \n" ..
            -- "varying vec4 v_fragmentColor; \n" ..
            -- "varying vec2 v_texCoord;  \n"..
            -- "#endif    \n"..
            -- "void main() \n"..
            -- "{\n" ..
            -- "gl_Position = CC_PMatrix * a_position; \n"..
            -- "v_fragmentColor = a_color;\n"..
            -- "v_texCoord = a_texCoord;\n"..
            -- "}"
             
            -- local pszFragSource = "#ifdef GL_ES \n" ..
            -- "precision mediump float; \n" ..
            -- "#endif \n" ..
            -- "varying vec4 v_fragmentColor; \n" ..
            -- "varying vec2 v_texCoord; \n" ..
            -- "void main(void) \n" ..
            -- "{ \n" ..
            -- "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
            -- "gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b); \n"..
            -- "gl_FragColor.w = c.w; \n"..
            -- "}"
         
            -- local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource,pszFragSource)
             
            -- pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
            -- pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
            -- pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
            -- pProgram:link()
            -- pProgram:updateUniforms()
            -- node:setGLProgram(pProgram)
        end
        --children
        local children = node:getChildren()
        if children and table.nums(children) > 0 then
            --遍历子对象设置
            for i,v in ipairs(children) do
                if gray.canGray(v) then
                    gray.setGray(v)
                end
            end
        end
        if node.getProtectedChildren then
            local protectedChildren = node:getProtectedChildren()
            if protectedChildren and table.nums(protectedChildren) > 0 then
                --遍历子对象设置
                for i,v in ipairs(protectedChildren) do
                    if gray.canGray(v) then
                        gray.setGray(v)
                    end
                end
            end
        end
    else
        gray.removeGray(node)
    end
    node.__isGray__ = v
end

--取消灰化
function gray.removeGray(node)
    if type(node) ~= "userdata" then
        printError("node must be a userdata")
        return
    end
    if not node.__isGray__ then
        return
    end
    if gray.canGray(node) then
        -- --------------
        local glProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
        node:setGLProgram(glProgram)
        glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
        glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
        glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)
        -- 不知道为什么下面2行不能写，写了会出问题
        -- glProgram:link()
        -- glProgram:updateUniforms()

        -- --------------
        -- node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
    end
    --children
    local children = node:getChildren()
    if children and table.nums(children) > 0 then
        --遍历子对象设置
        for i, v in ipairs(children) do
            if gray.canGray(v) then
                gray.removeGray(v)
            end
        end
    end
    if node.getProtectedChildren then
        local protectedChildren = node:getProtectedChildren()
        if protectedChildren and table.nums(protectedChildren) > 0 then
            --遍历子对象设置
            for i,v in ipairs(protectedChildren) do
                if gray.canGray(v) then
                     gray.removeGray(v)
                end
            end
        end
    end
    node.__isGray__ = false
end