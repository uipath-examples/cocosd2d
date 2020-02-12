-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 0

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false
CC_FPS = 60
CC_DEBUG_MEM_INTERVAL = 5
CC_DEBUG_MEM = false

--是否release 包
CC_RELEASE_PACK_TAG = true
--是否打开破解检测
CC_OPEN_VIOLATION = false
USE_ASSETS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 576,
    height = 1024,
    autoscale = "EXACT_FIT",
    callback = function(framesize)
        local ratio = framesize.height / framesize.width
        if ratio <= 1.34 then
            return {autoscale = "EXACT_FIT"}
        end
    end
}

-- 控制界面显示错误信息, true 打开， false 关闭，正式包必须关闭显示
SHOW_DEBUG_MSG = false
