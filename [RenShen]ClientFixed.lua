---@diagnostic disable: assign-type-mismatch
local rh = RHelper:new()
local json_config = {Values = {}}

local cheat_enable
local cheat_killauracps_enable
local cheat_killauracps_min
local cheat_killauracps_max
local cheat_killaurarange_enable
local cheat_killaurarange_ground
local cheat_killaurarange_air
local cheat_timerfix_enable
local cheat_kaabfix_enable
local cheat_hypixelvelocityfix_enable
local cheat_modulecheck_enable
local cheat_modulecheck_lastrange = {0,0}
local cheat_modulecheck_onenable = false

local client_enable
local client_givec_autoplayername


function getName()
    return "Client Fixed"
end

function init_script()
    rh:modules_reload()
    if user.get_username() == "renshengongji" then 
        if client.config() == "BestMotionblur" then
            rh:setmodulevalue("killaura","max angle",360,"double")
        end
    end
    cheat_enable = module_manager.register_boolean(getName(),"Enable Cheat Fixed",true)
    module_manager.register_label(getName(),"Cheat")
    cheat_killauracps_enable = module_manager.register_boolean(getName(),"Override KillAura APS",false)
    cheat_killauracps_max = module_manager.register_number(getName(),"Max APS",30,1,50,1)
    cheat_killauracps_min = module_manager.register_number(getName(),"Min APS",30,1,50,1)
    fenge()
    cheat_killaurarange_enable = module_manager.register_boolean(getName(),"Override KillAura Range",false)
    cheat_killaurarange_ground = module_manager.register_number(getName(),"Ground Range",3.1,0,20,0.1)
    cheat_killaurarange_air = module_manager.register_number(getName(),"Air Range",3,0,20,0.1)
    fenge()
    cheat_timerfix_enable = module_manager.register_boolean(getName(),"Timer Fix",true)
    fenge()
    cheat_kaabfix_enable = module_manager.register_boolean(getName(),"Autoblock Fix",string.find(client.config(),"hypixel")) cheat_kaabfix_enable:get_description("修复不拿剑没伤害")
    fenge()
    cheat_hypixelvelocityfix_enable = module_manager.register_boolean(getName(),"Hypixel Velocity Fix",string.find(client.config(),"hypixel")) cheat_hypixelvelocityfix_enable:set_description("修复站着不动不工作")
    fenge()
    cheat_modulecheck_enable = module_manager.register_boolean(getName(),"Modules State Check",true) cheat_modulecheck_enable:set_description("Blink Check For Range Modules")

    bfenge()
    if client.config():lower() == "hypixel" then
        rh:setmodulevalue("killaura","Max Angle",360,"double")
    end
    client_enable = module_manager.register_boolean(getName(),"Enable Client Fixed",true)
    module_manager.register_label(getName(),"Client")
    client_givec_autoplayername = module_manager.register_boolean(getName(),"Command Auto Name",true)
    client.register_command("clientfixed_config",{})
    rh:config_init(json_config,getName(),true)
    function on_pre_update()
        rh:modules_reloadtoggled(on_module_toggled)
        if cheat_enable:get_boolean() then
            rh:setmodulevalue("Baritone","chatControl",false,"boolean")
            if cheat_killauracps_enable:get_boolean() then
                rh:setmodulevalue("Kill Aura","Minimum APS",cheat_killauracps_min:get_double(),"double")
                rh:setmodulevalue("Kill Aura","Maximum APS",cheat_killauracps_max:get_double(),"double")
            end
            if cheat_killaurarange_enable:get_boolean() and not (module_manager.get_state("blink") or client.blinking() or (rh:module_state("autotoggle") and rh:module_state("scaffoldhelper"))) then
                rh:setmodulevalue("killaura","range",player.on_ground() and cheat_killaurarange_ground:get_double() or cheat_killaurarange_air:get_double(),"double")
            end
            if cheat_timerfix_enable:get_boolean() then
                if world.timer() ~= 1 and not module_manager.get_state("Gamespeed") and not module_manager.get_state("Speed") and not rh:module_state("rtimer") and not (rh:module_state("velocity") and rh:getmodulevalue("velocity","mode") == "Buffer") then
                    world.set_timer(1)
                    lprint("Failed Timer Detected")
                end
            end
            if cheat_hypixelvelocityfix_enable:get_boolean() then
                rh:setmodulevalue2("Velocity","Hypixel Mode",(player.on_ground() and player.is_moving()) and "Zero" or "Basic")
            end
            if cheat_modulecheck_enable:get_boolean() then
                if module_manager.get_state("blink") or client.blinking() or (rh:module_state("autotoggle") and rh:module_state("scaffoldhelper")) then
                    if rh:getmodulevalue("killaura","range") ~= 0 and cheat_modulecheck_onenable and rh:getmodulevalue("killaura","range") ~= cheat_modulecheck_lastrange[1] then
                        cheat_modulecheck_lastrange[1] = rh:getmodulevalue("killaura","range")
                        lprint("§4Set New Killaura Range: §7" .. rh:getmodulevalue("killaura","range"))
                    end
                    if rh:getmodulevalue("bedbreaker","break radius") ~= 0 and cheat_modulecheck_onenable and rh:getmodulevalue("bedbreaker","break radius") ~= cheat_modulecheck_lastrange[2] then
                        cheat_modulecheck_lastrange[2] = rh:getmodulevalue("bedbreaker","break radius")
                        lprint("§4Set New BedBreaker Radius: §7" .. rh:getmodulevalue("bedbreaker","break radius"))
                    end

                    cheat_modulecheck_onenable = true
                    rh:setmodulevalue("killaura","range",0,"double")
                    rh:setmodulevalue("bedbreaker","break radius",0,"double")
                else
                    if cheat_modulecheck_onenable then
                        rh:setmodulevalue("killaura","range",cheat_modulecheck_lastrange[1],"double")
                        rh:setmodulevalue("bedbreaker","break radius",cheat_modulecheck_lastrange[2],"double")
                        cheat_modulecheck_onenable = false
                    end
                    cheat_modulecheck_lastrange[1],cheat_modulecheck_lastrange[2] = rh:getmodulevalue("killaura","range"),rh:getmodulevalue("bedbreaker","break radius")
                end
            end

            if cheat_kaabfix_enable:get_boolean() and module_manager.get_state("killaura") and client.nullCheck() then
                local function ab(bool)
                    rh:setmodulevalue("Killaura","Autoblock",bool,"boolean")
                end
                ab(false)
                if string.sub(player.held_item():get_name(),1,10) == "item.sword" then
                    ab(true)
                end
            end
        end
    end
    function on_module_toggled(module,state)
        if module == "Big God" and state and player.ticks_existed() <= 3 then
            debug("Anti Big God")
            module_manager.disable("biggod")
        end
    end
    function on_chat(msg)
        if client_enable:get_boolean() and client_givec_autoplayername:get_boolean() then
            if string.sub(msg,1,5) == "/give" and player.get_serverip() ~= "mc.loyisa.cn" and player.get_serverip() ~= "eu.loyisa.cn" then
                msg = "/give " .. player.name() .. string.sub(msg,6)
            end
            if string.sub(msg,1,10) == "/playsound" then
                local arr = split(msg," ")
                if arr[3] ~= player.name() then
                    table.insert(arr,3,player.name())
                end
                local mess = ""
                for i = 1, #arr do
                    mess = mess .. arr[i] .. " "
                end
                msg = mess
            end
        end
        if utf8_sub(msg,1,1) == "." then
            local command = split(utf8_sub(msg,2)," ")
            if command[1] == "clientfixed_config" then
                msg = ".kick a"
                rh:config_chatcheck(json_config,command,getName(),true)
            end
        end
        return msg
    end
end




function fenge()
    module_manager.register_label(getName(),"-----------------------------")
end
function bfenge()
    module_manager.register_label(getName(),"----------------------------------------------")
end
function player.get_serverip()
    if world.is_singlePlayer() then
        return "Local Server"
    else
        return world.get_server()
    end
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