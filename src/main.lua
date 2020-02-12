--[[
	设置搜索路径
]]
local function addSearchPaths()
	local ccFileUtils = cc.FileUtils:getInstance()
	WRITABLE_PATH = string.gsub(ccFileUtils:getWritablePath(), "\\", "/") .. "xxdlData/"
    AVATAR_IMG_PATH = WRITABLE_PATH .. "avatar_img/"

	ccFileUtils:addSearchPath(WRITABLE_PATH)
	ccFileUtils:addSearchPath(WRITABLE_PATH .. "src/")
	ccFileUtils:addSearchPath(WRITABLE_PATH .. "res/")
	ccFileUtils:addSearchPath(WRITABLE_PATH .. "res/ui/")
    ccFileUtils:addSearchPath(WRITABLE_PATH .. "res/effect/")
	ccFileUtils:addSearchPath(WRITABLE_PATH .. "pb/")
    ccFileUtils:addSearchPath(AVATAR_IMG_PATH)

    ccFileUtils:addSearchPath("res/")
    ccFileUtils:addSearchPath("res/ui/")
    ccFileUtils:addSearchPath("res/effect/")
	ccFileUtils:addSearchPath("pb/")
	ccFileUtils:addSearchPath("src/")
	ccFileUtils:setPopupNotify(false)
end
addSearchPaths()

--为了在eclipse调试时可以用信息输出
-- print = function(...)

-- end

if jit.arch == "arm64" then 
    cc.LuaLoadChunksFromZIP("game_arm64.zip")
else
    cc.LuaLoadChunksFromZIP("game.zip")
end

local function main()
    require("app.myApp"):create():run()
end

local trace = function(...)
    print(string.format(...))
end

function __G__TRACKBACK__(errorMessage)
	local errMsg = "LUA ERROR: " .. tostring(errorMessage) .. "\n"
    errMsg = errMsg .. debug.traceback("",2)
    trace("THE ERROR INFO LOG BEGIN ------------------------------")
    trace(errMsg)
    trace("THE ERROR INFO LOG END ------------------------------")

    -- local curErrMsg = errMsg
    -- curErrMsg = string.gsub(curErrMsg, '"', '|')
    -- curErrMsg = string.gsub(curErrMsg, "'", '|')
    -- app.ctrls.system:pushCode(curErrMsg)

 	if SHOW_DEBUG_MSG then
 		local debugLayoutName = "debugLayout"
        local director = cc.Director:getInstance()
        local scene = director:getRunningScene()
        if scene then
            local layout = scene:getChildByName(debugLayoutName)
            if scene and not layout then
                local designSize = director:getOpenGLView():getDesignResolutionSize()
                local layout = ccui.Layout:create()
                layout:setName(debugLayoutName)
                layout:setContentSize(designSize)
                layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
                layout:setBackGroundColor(cc.c3b(0,0,0))
                layout:setBackGroundColorOpacity(128)

                local scrollView = ccui.ScrollView:create()
                scrollView:setLocalZOrder(1)
                scrollView:setContentSize(designSize)
                scrollView:setDirection(ccui.ScrollViewDir.vertical)
                layout:addChild(scrollView)

                local text = ccui.Text:create()
                text:setAnchorPoint(0, 0)
                text:ignoreContentAdaptWithSize(true)
                text:setTextAreaSize(cc.size(designSize.width, 0))
                text:setFontSize(30)
                text:setString("\n" .. errMsg .. "\n\n")
                scrollView:addChild(text)
                scrollView:setInnerContainerSize(text:getContentSize())

                local button = ccui.Text:create()
                button:setLocalZOrder(2)
                button:setFontSize(25)
                button:setString("关闭")
                local buttonSize = button:getContentSize()
                button:setPosition(designSize.width - buttonSize.width / 2 - 5, designSize.height - buttonSize.height / 2 - 5)
                button:setTouchEnabled(true)
                function onButtonTouch(sender, eventType)
                    if eventType == ccui.TouchEventType.ended then
                        layout:removeFromParent()
                    end
                end
                button:addTouchEventListener(onButtonTouch)
                layout:addChild(button)

                scene:addChild(layout)
            end
        end
    else
        if buglyReportLuaException then
            buglyReportLuaException(tostring(errMsg), debug.traceback())
        end
 	end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
