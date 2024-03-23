local rh = RHelper:new()
local invaildProtocolText

local array_x
local array_xbase
local array_y
local array_rect_left
local array_rect_right
local array_rect_top
local array_rect_down
local array_font
local array_case
local array_sort
local array_reversesort
local array_suffix
local array_suffixcolor
local array_textshadow
local array_textheight
local array_background
local array_textcolormode
local array_backgroundcolormode
local array_textcolor
local array_textcolor2
local array_bgcustomcolor
local array_overlaybg
local array_fadespeed
local array_fadetick
local array_rainbows
local array_rainbowl
local array_rectcolormode
local array_rect_width
local array_texty
local array_namespilt
local array_smarthide
local array_backgroundalpha
local array_colorfollowclient
---
local fadecolortable = {}
local doublecolortable = {}
local rainbowcolortable = {}

local fadecolorendcolor = {}
local doublecolorendcolor = {}

local fadecolorlaststartcolor = {}
local doublecolorlaststartcolor = {}

local fadecolortick = 0
local doublecolortick = 0
local rainbowcolortick = 0

local rainbowcolorh = 0
local renshenlua = {"arraylist","visuals","scaffoldhelper","rspeed","autotoggle","d1sabler","rfly","staffdetected","insult"}
local json_config = {Values = {},Hide_Modules = {"Interface"}}
function getName()
    return "Arraylist"
end
function init_script()
    invaildProtocolText = getRandom(8)
    module_manager.register_label(getName(),"Basic Options")
    array_x = module_manager.register_text(getName(),"X Pos","1.5")
    array_y = module_manager.register_text(getName(),"Y Pos","0")
    array_xbase = module_manager.register_mode(getName(),"X Base",{"Left","Center","Right"},"Right")
    array_font = module_manager.register_mode(getName(),"Font",{"Vanilla","微软雅黑", "Rubik14", "Rubik16", "Rubik18", "SFDisplay16", "SFDisplay18", "MuseoCyrl16", "MuseoCyrl18"},"Rubik14")
    array_sort = module_manager.register_mode(getName(),"Sort",{"None","Length","ABC"},"Length")
    array_reversesort = module_manager.register_boolean(getName(),"Reverse Sort",false)
    array_textheight = module_manager.register_text(getName(),"Text Height","5")
    array_suffix = module_manager.register_mode(getName(),"Suffix",{"None","Space","-","( )","[ ]","{ }","< >"},"Space")
    array_suffixcolor = module_manager.register_mode(getName(),"Suffix Color",{"White","Gray"},"Gray")
    array_smarthide = module_manager.register_boolean(getName(),"Hide Category",true)
    module_manager.register_label(getName(),"Text & Background")
    array_case = module_manager.register_mode(getName(),"Text Case",{"Lower","Normal","Upper"},"Lower")
    array_textshadow = module_manager.register_boolean(getName(),"Text Shadow",false)
    array_texty = module_manager.register_text(getName(),"Text Y","0")
    array_namespilt = module_manager.register_boolean(getName(),"Name Spilt",true)
    array_background = module_manager.register_mode(getName(),"Background",{"None","Normal","Round"},"Normal")
    array_overlaybg = module_manager.register_boolean(getName(),"Background Overlay",false)
    module_manager.register_label(getName(),"Element")
    array_rect_width = module_manager.register_text(getName(),"Rect Width","0.8")
    array_rect_left = module_manager.register_mode(getName(),"Left Rect",{"None","Rise","Normal"},"None")
    array_rect_right = module_manager.register_mode(getName(),"Right Rect",{"None","Rise","Normal"},"Normal")
    array_rect_top = module_manager.register_boolean(getName(),"Top Rect",false)
    array_rect_down = module_manager.register_boolean(getName(),"Down Rect",false)
    module_manager.register_label(getName(),"Color Options")
    array_fadespeed = module_manager.register_number(getName(),"Fade Speed",20,1,100,0.5)
    array_fadetick = module_manager.register_number(getName(),"Fade Tick",2,1,60,1)
    array_textcolormode = module_manager.register_mode(getName(),"Text Color",{"Custom","Fade","Double","Rainbow"},"Double")
    array_rectcolormode = module_manager.register_mode(getName(),"Rect Color",{"Text","Custom","Fade","Double","Rainbow"},"Text")
    array_backgroundcolormode = module_manager.register_mode(getName(),"Background Color",{"Custom","Fade","Double","Rainbow"},"Custom")
    array_textcolor = module_manager.register_color(getName(),"Color",-1)
    array_textcolor2 = module_manager.register_color(getName(),"Color2",-1)
    array_colorfollowclient = module_manager.register_boolean(getName(),"Follow Client Color",true)
    array_bgcustomcolor = module_manager.register_color(getName(),"Background Custom Color",-1)
    array_backgroundalpha = module_manager.register_number(getName(),"Background Alpha",128,0,255,1)
    array_rainbows = module_manager.register_number(getName(),"Rainbow Saturation",1,0,1,0.05)
    array_rainbowl = module_manager.register_number(getName(),"Rainbow Lightness",0.5,0,1,0.05)
    client.register_command("array_hide",{})
    client.register_command("array_config",{})
    rh:config_init(json_config,getName())
    function on_render_screen(event)
        local sr = event:scaled_resolution()
        local x = sr:width() - (tonumber(array_x:get_string()) or 0) - 3.5
        local y = (tonumber(array_y:get_string()) or 0) + 2.7
        local font = array_font:get_string()
        local modules = {}
        local modulessort = {}
        local textcolor1 = dergba(array_textcolor:get_rgb())
        local textcolor2 = dergba(array_textcolor2:get_rgb())
        local bgcolor1 = dergba(array_bgcustomcolor:get_rgb()) bgcolor1[4] = array_backgroundalpha:get_double()
        if array_colorfollowclient:get_boolean() then
            textcolor1 = dergba(rh:getmodulevalue("interface","Color (Global)"))
            textcolor2 = dergba(rh:getmodulevalue("interface","Color (Double)"))
        end

        for _, module in ipairs(module_manager.get_modules()) do -- 检测是否启用并放入table中
            local cate = module_manager.get_category(module):lower()
            if module_manager.get_state(module) and (array_smarthide:get_boolean() and (cate ~= "visuals" and cate ~= "entity" and cate ~= "component" and (cate == "scripts" and hasrlua(module) or cate ~= "scripts")) or not array_smarthide:get_boolean()) and rh:luadetected(module) and not hashidemodule(module) then
                table.insert(modules, (not array_namespilt:get_boolean() and module:gsub(" ","") or module) .. (array_suffix:get_string() ~= "None" and (array_suffixcolor:get_string() == "Gray" and "§7" or "§f") .. modulesuffix(module) or ""))
                if array_case:get_string() == "Lower" then
                    modules[#modules] = modules[#modules]:lower()
                end
                if array_case:get_string() == "Upper" then
                    modules[#modules] = modules[#modules]:upper()
                end
                if array_sort:get_string() == "Length" then
                    table.insert(modulessort, rh:shader_string_width(font,modules[#modules]))
                elseif array_sort:get_string() == "ABC" then
                    table.insert(modulessort, get_first_string(module))
                end
            end
        end
        -- 排序
        if array_sort:get_string() ~= "None" then
            Sort(modulessort,modules)
        end
        if array_reversesort:get_boolean() then
            modules = reverseTable(modules)
            modulessort = reverseTable(modulessort)
        end
        -- 排序
        for index, module in ipairs(modules) do
            local textcolor = color(table.unpack(textcolor1))
            local rectcolor = color(table.unpack(textcolor1))
            local backgroundcolor = color(table.unpack(bgcolor1))
            local space = (tonumber(array_textheight:get_string()) or 3)
            local ypad = (index - 1) * (rh:shader_font_height(font)+space)
            local xpad = rh:shader_string_width(font,module) * (array_xbase:get_string() == "Center" and 0.5 or (array_xbase:get_string() == "Right" and 1 or 0))
            ---color
            local function getbgcolor(rgbTable)
                return color(rgbTable[1], rgbTable[2], rgbTable[3], bgcolor1[4])
            end
            local function colorsystemhelper(color)
                return array_textcolormode:get_string() == color or array_backgroundcolormode:get_string() == color or array_rectcolormode:get_string() == color
            end
            if colorsystemhelper("Fade") then -- Fade
                local brightness = 0.25
                table.remove(fadecolortable,#module_manager.get_modules() + 1)
                ---初始化
                if #fadecolorlaststartcolor == 0 then
                    fadecolorlaststartcolor = textcolor1
                end
                if not tableq(fadecolorlaststartcolor,textcolor1) then
                    fadecolorlaststartcolor = textcolor1
                    fadecolortable = {}
                    fadecolorendcolor = {}
                end
                if #fadecolortable ~= #module_manager.get_modules() then
                    fadecolortable = {}
                    for i = 1, #module_manager.get_modules() do
                        table.insert(fadecolortable,textcolor1)
                    end
                end
                ---初始化

                if tableq(fadecolortable[1],colorbrightness(textcolor1,brightness)) then
                    fadecolorendcolor = textcolor1
                end
                if tableq(fadecolortable[1],textcolor1) then
                    fadecolorendcolor = colorbrightness(textcolor1,brightness)
                end
                if fadecolortick >= array_fadetick:get_double() then
                    table.insert(fadecolortable,1,getgracolor(fadecolortable[1],fadecolorendcolor,array_fadespeed:get_double(),1))
                    fadecolortick = 0
                end
                if array_textcolormode:get_string() == "Fade" then
                    textcolor = color(table.unpack(fadecolortable[index]))
                end
                if array_rectcolormode:get_string() == "Fade" then
                    rectcolor = color(table.unpack(fadecolortable[index]))
                end
                if array_backgroundcolormode:get_string() == "Fade" then
                    backgroundcolor = getbgcolor(fadecolortable[index])
                end
            end
            if colorsystemhelper("Double") then -- Double
                table.remove(doublecolortable,#module_manager.get_modules() + 1)
                ---初始化
                if #doublecolorlaststartcolor == 0 then
                    doublecolorlaststartcolor = textcolor1
                end
                if not tableq(doublecolorlaststartcolor,textcolor1) then
                    doublecolorlaststartcolor = textcolor1
                    doublecolortable = {}
                    doublecolorendcolor = {}
                end
                if #doublecolortable ~= #module_manager.get_modules() then
                    doublecolortable = {}
                    for i = 1, #module_manager.get_modules() do
                        table.insert(doublecolortable,textcolor1)
                    end
                end
                ---初始化

                if tableq(doublecolortable[1],textcolor2) then
                    doublecolorendcolor = textcolor1
                end
                if tableq(doublecolortable[1],textcolor1) then
                    doublecolorendcolor = textcolor2
                end
                if doublecolortick >= array_fadetick:get_double() then
                    table.insert(doublecolortable,1,getgracolor(doublecolortable[1],doublecolorendcolor,array_fadespeed:get_double(),10))
                    doublecolortick = 0
                end
                if array_textcolormode:get_string() == "Double" then
                    textcolor = color(table.unpack(doublecolortable[index]))
                end
                if array_rectcolormode:get_string() == "Double" then
                    rectcolor = color(table.unpack(doublecolortable[index]))
                end
                if array_backgroundcolormode:get_string() == "Double" then
                    backgroundcolor = getbgcolor(doublecolortable[index])
                end
            end
            if colorsystemhelper("Rainbow") then -- Rainbow
                local function hueTorgb(p, q, t)
                    if t < 0 then
                        t = t + 1
                    end
                    if t > 1 then
                        t = t - 1
                    end
                    if t < 1 / 6 then
                        return p + (q - p) * 6 * t
                    end
                    if t < 1 / 2 then
                        return q
                    end
                    if t < 2 / 3 then
                        return p + (q - p) * (2 / 3 - t) * 6
                    end
                    return p
                end
                local function hslToRgb(h, s, l)
                    local r, g, b
                    if s == 0 then
                        r = l
                        g = l
                        b = l
                    else
                        local q
                        if l < 0.5 then
                            q = l * (1 + s)
                        else
                            q = l + s - l * s
                        end
                        local p = 2 * l - q
                        r = hueTorgb(p, q, h + 1 / 3)
                        g = hueTorgb(p, q, h)
                        b = hueTorgb(p, q, h - 1 / 3)
                    end
                    --player.message(math.floor(r * 255 + 0.5) .. "  " .. math.floor(g * 255 + 0.5) .. "  " .. math.floor(b * 255 + 0.5))
                    return {math.floor(r * 255 + 0.5) or 0, math.floor(g * 255 + 0.5) or 0, math.floor(b * 255 + 0.5) or 0,textcolor1[4]}
                end
                table.remove(rainbowcolortable,#module_manager.get_modules() + 1)
                ---初始化
                if #rainbowcolortable ~= #module_manager.get_modules() then
                    rainbowcolortable = {}
                    for i = 1, #module_manager.get_modules() do
                        table.insert(rainbowcolortable,hslToRgb(0,array_rainbows:get_double(),array_rainbowl:get_double()))
                    end
                    rainbowcolorh = 0
                end
                ---初始化
                if rainbowcolortick >= array_fadetick:get_double() then
                    table.insert(rainbowcolortable,1,hslToRgb(rainbowcolorh%1,array_rainbows:get_double(),array_rainbowl:get_double()))
                    rainbowcolorh = rainbowcolorh + array_fadespeed:get_double()/1000
                    rainbowcolortick = 0
                end
                if array_textcolormode:get_string() == "Rainbow" then
                    textcolor = color(table.unpack(rainbowcolortable[index]))
                end
                if array_rectcolormode:get_string() == "Rainbow" then
                    rectcolor = color(table.unpack(rainbowcolortable[index]))
                end
                if array_backgroundcolormode:get_string() == "Rainbow" then
                    backgroundcolor = getbgcolor(rainbowcolortable[index])
                end
            end
            if array_rectcolormode:get_string() == "Text" then
                rectcolor = textcolor
            end
            ---color
            ---background
            if array_background:get_string() ~= "None" then
                if array_overlaybg:get_boolean() then
                    shader.round_rect(x - xpad - 1,y + ypad - (space/2 - 0.5),rh:shader_string_width(font,module) + 3.65,rh:shader_font_height(font) + space-1.35,array_background:get_string() == "Round" and 1 or 0,color(table.unpack(bgcolor1)))
                end
                shader.round_rect(x - xpad - 1,y + ypad - (space/2 - 0.5),rh:shader_string_width(font,module) + 3.65,rh:shader_font_height(font) + space-1.35,array_background:get_string() == "Round" and 1 or 0,backgroundcolor)
            end
            ---background
            ---Rect
            local width = tonumber(array_rect_width:get_string()) or 1
            if array_rect_left:get_string() == "Rise" then
                shader.round_rect(x - xpad - 2,y + ypad - (rh:shader_font_height(font)+space/2)/2 + 3,width,(rh:shader_font_height(font)+space/2) - 1.5,0,rectcolor)
            end
            if array_rect_left:get_string() == "Normal" then
                shader.round_rect(x - xpad - 2.5,y + ypad - 2,width,(rh:shader_font_height(font)+space) - 1.5,0,rectcolor)
            end
            if array_rect_right:get_string() == "Rise" then
                shader.round_rect(x - xpad + rh:shader_string_width(font,module) + 3,y + ypad - (rh:shader_font_height(font)+space/2)/2 + 3,width,(rh:shader_font_height(font)+space/2),0,rectcolor)
            end
            if array_rect_right:get_string() == "Normal" then
                shader.round_rect(x - xpad + rh:shader_string_width(font,module) + 3.65,y + ypad - 2,width,(rh:shader_font_height(font)+space) - 1.4,0,rectcolor)
            end
            if array_rect_top:get_boolean() and index == 1 then
                shader.round_rect(x - xpad - width - (array_rect_left:get_string() == "Normal" and 1 or 0.1),y - (space/2) - width,rh:shader_string_width(font,modules[1]) + 4 + (array_rect_left:get_string() == "Normal" and width or 0.1) + (array_rect_right:get_string() == "Normal" and width or 0.1),width,0,rectcolor)
            end
            if array_rect_down:get_boolean() and index == #modules then
                shader.round_rect(x - xpad - width - (array_rect_left:get_string() == "Normal" and 1 or 0.1),y - space/2 - width + index * (rh:shader_font_height(font)+space) + 1,rh:shader_string_width(font,modules[#modules]) + 4 + (array_rect_left:get_string() == "Normal" and width or 0.1) + (array_rect_right:get_string() == "Normal" and width or 0.1),width,0,rectcolor)
            end
            ---Rect
            rh:shader_draw_string(font,module,x - xpad,y + ypad + (tonumber(array_texty:get_string()) or 0) - 0.5,textcolor,array_textshadow:get_boolean()) -- 绘制text
        end
    end
    function on_tick()
        fadecolortick = fadecolortick + 1
        doublecolortick = doublecolortick + 1
        rainbowcolortick = rainbowcolortick + 1
    end
    function on_chat(msg)
        if utf8_sub(msg,1,1) == "." then
            local command = split(utf8_sub(msg,2)," ")
            if command[1] == "array_hide" then
                msg = nil
                if #command ~= 2 then
                    lprint("§3Empty Module")
                    return msg
                end
                if command[2] == "_list" then
                    if #json_config == 0 then
                        lprint("§3No Hide Modules")
                        return ".kick a"
                    end
                    lprint("§3Hide Modules List:")
                    for index, value in ipairs(json_config) do
                        player.message("§6" .. value)
                    end
                    return ".kick a"
                end
                if command[2] == "_clear" then
                    json_config = {}
                    lprint("§3Clear All Hide Module")
                    return ".kick a"
                end
                for index, value in ipairs(module_manager.get_modules()) do
                    if value:gsub(" ",""):lower() == command[2]:lower() then
                        table.insert(json_config.Hide_Modules,value)
                        lprint("§3Hide Module §5" .. value)
                        rh:config_savefile(json_config,getName())
                        return ".kick a"
                    end
                end
                lprint("§3Not Found Module §5" .. command[2])
            end
            if command[1] == "array_config" then
                msg = ".kick a"
                rh:config_chatcheck(json_config,command,getName())
            end
        end
        return msg
    end
end

function Sort(arr,arr2)
	local len = #arr
	for i = 2,len do
		local temp = arr[i]
        local temp2 = arr2[i]
		local j = i-1
		while(j >= 1 and temp > arr[j]) do
			arr[j+1] = arr[j]
            arr2[j+1] = arr2[j]
			j = j-1;
		end
		arr[j+1] = temp;
        arr2[j+1] = temp2;
	end
end
function reverseTable(tab)
    local tmp = {}
    for i = 1, #tab do
        local key = #tab + 1 - i
        tmp[i] = tab[key]
    end
    return tmp
end
function modulesuffix(m)
    local pre = array_suffix:get_string() == "Space" and " " or " " .. (split(array_suffix:get_string(), " ")[1] == "-" and "- " or split(array_suffix:get_string(), " ")[1])
    local suf = split(array_suffix:get_string(), " ")[2]
    local suffix = hasrlua(m) and rh:lua_module_suffix(m) or module_manager.get_suffix(m)
    if m == "Velocity" and rh:getmodulevalue("clientfixed","Hypixel Velocity Fix") and rh:module_state("clientfixed") then
        suffix = "Hypixel Fix"
    end
    if m == "Scaffold" and rh:module_state("scaffoldhelper") and rh:getmodulevalue("scaffoldhelper","BPS Mode") ~= "Disable" then
        suffix = rh:getmodulevalue("scaffoldhelper","BPS Mode") == "Custom" and "Hypixel" or rh:getmodulevalue("scaffoldhelper","BPS Mode")  
    end
    if m == "Protocol" and rh:module_state("pvisual") and rh:serverip() == "pc.bjd-mc.com" then
        suffix = invaildProtocolText
    end
    return (suffix ~= "" and pre or "" ).. tostring(suffix) .. (suffix ~= "" and suf or "" )
end

function getgracolor(color1,color2,speed,fix)
    local r,g,b,a = table.unpack(color1)
    local er,eg,eb,ea = table.unpack(color2)
    local function rgblimit(num,ed)
        fix = fix or 5
        local v = math.min(math.max(num,0),255) - math.min(math.max(num,0),255)%0.0001
        if tonumber(ed) > tonumber(v) then
            return ed - fix-v <= 0 and ed or v
        end
        return ed + fix-v >= 0 and ed or v
    end
    local R = (er - r) / 100 * speed
    local G = (eg - g) / 100 * speed
    local B = (eb - b) / 100 * speed
    local A = (ea - a) / 100 * speed
    return {rgblimit(R +r,er),rgblimit(g+G,eg),rgblimit(B + b,eb),rgblimit(A + a,ea)}
end
function tableq(arr,arr1)
    if #arr ~= #arr1 then
        return false
    end
    for i in pairs(arr) do
        if arr[i] ~= arr1[i] then
            return false
        end
    end
    return true
end
function colorbrightness(color,level)
    local r,g,b,a = table.unpack(color)
    return {r*level,g*level,b*level,a}
end
function hasrlua(m)
    for _, v in ipairs(renshenlua) do
        if v == m:lower():gsub(" ","") then
            return true
        end
    end
    return false
end
function get_first_string(string)
    local first = string.sub(string,1,1)
    local zm = {"A", "B" ,"C" ,"D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
    local szm = {"a", "b" ,"c" ,"d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x", "y","z"}
    for i = 1,26 do
        if zm[i] == first or szm[i] == first then
            return 26 - i
        end
    end
    return 0
end
function hashidemodule(module)
    for _, value in ipairs(json_config.Hide_Modules) do
        if module == value then
            return true
        end
    end
    return false
end
function getRandom(n)
    local t = {
        "0","1","2","3","4","5","6","7","8","9",
        "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
        "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
        --".", ">", "<", "|", "/", ",", "[", "]", "{", "}",
    }
    local s = ""
    for i =1, n do
        s = s .. t[math.random(#t)]
    end;
    return s
end;