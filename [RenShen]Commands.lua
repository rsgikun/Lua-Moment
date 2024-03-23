local rh = RHelper:new()

local tick = 0
local partyall_i = 1
local partyall = false
local heypixelchat = "all"

function getName() return "Commands" end

function init_script()
    client.register_command("rh",{}, "command_rhelp")
    -- label_("Help Command")
    -- text_(".rh")
    -- text_("显示lua的指令列表")
    client.register_command("binds",{}, "command_binds")
    client.register_command("crash",{}, "command_crash")
    client.register_command("fp",{}, "command_fakeplayer")
    client.register_command("irc_data",{})
    client.register_command("kick_chat",{}, "command_chatkick")
    client.register_command("kick_spwmchat",{}, "command_spwmchatkick")
    client.register_command("kick_hotbar",{}, "command_IllegalSlot")
    client.register_command("packetcrash",{}, "command_packetcrash")
    client.register_command("kick_highpos",{}, "command_highposkick")
    client.register_command("kick_manypacket",{}, "command_manypacketkick")
    client.register_command("kick_interactself",{}, "command_interactselfkick")
    client.register_command("irc_data_invite_all_party",{}, "command_partyall")
    client.register_command("name",{},"command_randomname")
    client.register_command("value",{})
    client.register_command("party",{})
    client.register_command("heychat",{})
    module_manager.enable(getName())
    function on_tick()
        tick = tick + 1
        if partyall and tick >= 10 then
            local irc = irc_data(true)
            player.send_message((bjdcheck() and "/zd i " or "/party invite").. irc[partyall_i][2])
            partyall_i = partyall_i + 1
            tick = 0
            if partyall_i > #irc then
                partyall_i = 1
                partyall = false
            end
        end
    end
    function on_chat(msg)
        if utf8_sub(msg,1,1) == "." then
            local command = split(utf8_sub(msg,2)," ")
            command[1] = command[1]:lower()
            if command[1] == "value" then
                msg = nil
                local function setmodulevalue(modulename,value_,valuetext)
                    for _, name in ipairs(module_manager.get_modules()) do
                        if name:lower():gsub(" ","") == modulename:lower() then
                            modulename = name
                            for _, value in ipairs(module_manager.get_values(modulename)) do
                                if (value:get_name():lower():gsub(" ","") == value_:lower()) then
                                    local function toboolean(value)
                                        return tostring(value) == "true" and true or (tostring(value) == "1" and true or false)
                                    end
                                    if value:is_mode() or value:is_text() then
                                        value:set_string(valuetext)
                                        if value:is_mode() and value:get_value() ~= valuetext then
                                            for i = 1,#value:get_modes() do
                                                local v = value:get_modes()[i]
                                                if v:lower():gsub(" ","") == valuetext:lower() then
                                                    value:set_string(v)
                                                    break
                                                end
                                            end
                                            if tostring(value:get_value()):lower():gsub(" ","") ~= valuetext:lower() then
                                                lprint("§3Pattern '" .. valuetext .. "' not found")
                                                return msg
                                            end
                                        end
                                    end
                                    if value:is_number() then
                                        value:set_double(valuetext)
                                    end
                                    if value:is_boolean() then
                                        value:set_boolean(toboolean(valuetext))
                                    end
                                    if value:is_color() then
                                        value:set_rgb(valuetext)
                                    end
                                    if value:is_label() then
                                        value:edit(valuetext)
                                    end
                                    if value:is_item() then
                                        value:select(valuetext)
                                    end
                                    --The range parameter of killaura
                                    lprint("§aThe §5" .. tostring(value:get_name()) .. " §avalue of the §5" .. tostring(modulename) .. "§a has been set to §5" .. tostring(value:is_color() and value:get_rgb() or value:get_value()))
                                    return ".kick a"
                                end
                            end
                            lprint("§cValue §5" .. value_ .. " §cnot found")
                            return msg
                        end
                    end
                    lprint("§cModule §5" .. modulename .. " §cnot found")
                    return msg
                end
                if #command == 1 then
                    lprint("§cModule name is empty")
                    return msg
                end
                if #command == 2 then
                    lprint("§cValue name is empty")
                    return msg
                end
                if #command == 3 then
                    lprint("§cValue is empty")
                    return msg
                end
                return setmodulevalue(command[2],command[3],table.concat(command," ",4))
            end
            if command[1] == "party" or command[1] == "partyn" then
                msg = nil
                if #command < 2 then
                    lprint("§cUsername is empty")
                    return msg
                end
                local name
                if command[1] == "partyn" then
                    name = table.concat(command," ",2)
                else
                    for _,v in ipairs(irc_data(true)) do
                        if v[1]:lower() == command[2]:lower() then
                            name = v[2]
                            break
                        end
                    end
                end
                if type(name) ~= "nil" then
                    if name == "Unknown" then
                        lprint("§c玩家未进入游戏")
                        return msg
                    end
                    if bjdcheck() then
                        local function randomlower(s)
                            local ret = ""
                            for i = 1, utf8_len(s) do
                                if utf8_sub(s,i,i):match("[a-zA-Z]") ~= nil then
                                    math.randomseed(1951*os.time() + i*player.ticks_existed()*os.clock())
                                    if math.random(1,2) == 1 then
                                        ret = ret .. utf8_sub(s,i,i):lower()
                                    else
                                        ret = ret .. utf8_sub(s,i,i):upper()
                                    end
                                else
                                    ret = ret .. utf8_sub(s,i,i)
                                end 
                            end
                            return ret
                        end
                        player.send_message("/zd i " .. randomlower(name))
                    else
                        player.send_message("/party invite " .. name)
                    end
                else
                    lprint("§cUnk§cnown Username")
                    return msg
                end
                return msg
            end
            if command[1] == "heychat" then
                msg = nil
                if command[2] == "a" or command[2] == "all" then
                    heypixelchat = "all"
                    msg = ".kick a"
                    lprint("§7Set Chat Mode to §5All")
                end
                if command[2] == "p" or command[2] == "party" then
                    heypixelchat = "party"
                    msg = ".kick a"
                    lprint("§7Set Chat Mode to §5Party")
                end
            end
            if command[1] == "irc_data" then
                msg = nil
                if command[2] == nil then
                    msg = ".kick a"
                    player.message("\n§6Client IRC Info (§a" .. #user.get_irc_data() .. " §6Online)\n" .. irc_data())
                else
                    local usern = table.concat(command," ",2)
                    for _, value in ipairs(irc_data(true)) do
                        if value[1]:lower() == usern:lower() then
                            msg = ".kick a"
                            player.message("\n§6" .. usern .. " IRC Info\n" .. "§2Username: §b" .. value[1] .. " §7| §aPlayer Name: §b" .. value[2] .. " §7| §cIP Address: §b" .. value[3] .. "\n")
                        end
                    end
                    lprint("§3Not Found Username: " .. usern)
                end
            end
        else
            if heypixelchat == "party" and utf8_sub(msg,1,1) ~= "/" and utf8_sub(msg,1,1) ~= "#" and utf8_sub(msg,1,1) ~= "@" then
                msg = "/pc " .. msg
            end
        end
        return msg
    end
    function on_message_receive(msg)
        if string.find(msg,"已收到邀请") ~= nil then
            local function removeMinecraftFormatting(inputString)
                return string.gsub(inputString, "§.", "")
            end
            local name = removeMinecraftFormatting(split(split(msg,"\n")[2],"已收到邀请")[1])
            msg = "§7[§5RenShen§f§7]§f " .. "§3已成功邀请 §7" .. name
        end
        if string.find(msg,"队伍请求已经过期") ~= nil then
            return "Anti Spammer (Heypixel Party Request Expired)"
        end
        return msg
    end
end

on_disable = function() module_manager.enable(getName()) end

function command_rhelp ()
    function print(msg,text)
        player.message("§7[§dCommands§7] §b" .. msg .. " §7--- §3" .. text)
    end
    print("kick_chat","因为Unicode字符被服务器踢出")
    print("kick_spamchat","因为刷屏被服务器踢出")
    print("kick_packet","因为Bad Packet被服务器踢出")
    print("kick_hotbar","因为Invalid hotbar被服务器踢出")
    print("kick_highpos","因为坐标过远被服务器踢出")
    print("kick_manypacket","因为过多发包被服务器踢出")
    print("kick_interactself","因为interact self被服务器踢出")
    print("binds","查看绑定的按键")
    print("crash","使客户端未响应")
    print("fp","重置假人位置")
    print("irc_data","获取所有用户的irc数据")
    print("packetcrash","因为神币原因导致客户端崩溃")
    print("value <Module> <Value Name> <Value>","修改模块的参数")
end

function command_binds ()
    local modules = {}
    for _, str in ipairs(module_manager.get_modules()) do
        if module_manager.get_key(str) ~= 0 then
            table.insert(modules, str)
        end
    end
    player.message("§7[§dRenShen§7] §bBinds:")
    for _, str in ipairs(modules) do
        local printtext = "§7[§dBinds§7] §a" .. str .. "§7 - §l" .. input.get_key_name(module_manager.get_key(str))
        player.message(printtext)
    end
end

function command_crash ()
    repeat
        for i = -2147483647 , 2147483647 do 
            while true
            do
                player.message(nil)
            end
        end
    until (false)
end

function command_fakeplayer ()
    module_manager.disable("fakeplayer") 
    module_manager.enable("fakeplayer")
    player.message("Reset Fake Player")
end

function command_chatkick ()
    player.send_message("\n§\n")
end

function command_spwmchatkick ()
    for i = 1,256 do
        player.send_message("/" .. getRandom(255))
    end
end
function command_packetcrash ()
    for i = 1, 256 do
        player.set_position(2147483648,2147483648,2147483648)
        player.set_motion(2147483648,2147483648,2147483648)
    end
end

function command_IllegalSlot()
    player.set_held_item_slot(-2147483649)
end

function command_highposkick()
    player.set_position(0,32000000,0)
end

function command_manypacketkick()
    for i = 1,1024 do
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
        player.send0x0A()
    end
end

function command_interactselfkick()
    player.send0x02(player.id(),"interact")
end


label_ = function(str) module_manager.register_label(getName(),str) end

text_ = function(str) module_manager.register_label(getName(),"----- " .. str .. " -----") end

function getRandom(n)
    local t = {
        "0","1","2","3","4","5","6","7","8","9",
        "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
        "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
        ".", ">", "<", "|", "/", ",", "[", "]", "{", "}",
    }
    local s = ""
    for i =1, n do
        s = s .. t[math.random(#t)]
    end;
    return s
end;
function command_partyall()
    if partyall == false then
        partyall = true
        partyall_i = 1
    end
end
function command_randomname()
    local function getRandom(n)
        local t = {
            "0","1","2","3","4","5","6","7","8","9",
            "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
            "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
        }
        local s = ""
        for i =1, n do
            s = s .. t[math.random(#t)]
        end;
        return s
    end;
    math.randomseed(os.time()*os.clock()*player.ticks_existed()+2495189)
    local name = "RShen_" .. getRandom(5) 
    lprint(name.. " | 已经复制至剪贴板")
    rh:java_setClipboardContent(name)
end
function irc_data(simple)
    local t = ""
    local test = {}
    for index, value in ipairs(user.get_irc_data()) do
        local temp = split(value,",")
        if simple or false then
            local name = temp[1]
            local ipaddress = temp[2]
            local username = temp[3]
            if name ~= "Unknown" then
                table.insert(test,{username,name,ipaddress})
            end
        else
            local name = utf8_sub(temp[1],1,1) .. "§b" .. utf8_sub(temp[1],2)
            local ipaddress = temp[2]
            local username = temp[3] .. "§b"
            if temp[3] == user.get_username() then
                t = t .. "§2Username: §b自己 §7| §aPlayer Name: §b自己 §7| §cIP Address: §b自己\n"
            else
                t = t .. "§2Username: §b" .. username .. " §7| §aPlayer Name: §b" .. name .. " §7| §cIP Address: §b" .. ipaddress .. "\n"
            end
        end
    end
    return simple and test or t
end





function CheckChinese(char)
    for i = 1, utf8_len(char) do
        local bytes = {string.byte(utf8_sub(char,i,i), 1, -1)}
        if #bytes == 3 then
            return true
        end
        if (bytes[1] < 0xE4 or bytes[1] > 0xE9) == false then
            return true
        end    
    end
    return false
end
function split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter == "") then return {""} end
    local pos, arr = 0, {}
    for st, sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end
function bjdcheck()
    return RHelper:serverip() == "pc.bjd-mc.com" or client.config() == "BestMotionblur"
end