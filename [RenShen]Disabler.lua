local rh = RHelper:new()
local disablermode

local hypixel_c03
local hypixel_guimove
local hypixel_guimovekey

local grim_fastbreak
local grim_fastbreak_onbreak = false
local grim_superinventory

local oninv = false
local oninv_v = 0
local debug
function getName()
	return "D1sabler"
end
function init_script()
    disablermode = module_manager.register_mode(getName(),"Mode",{"Hypixel","Grim"},"Grim")
    module_manager.register_label(getName(),"Hypixel Options")
    hypixel_c03 = module_manager.register_boolean(getName(),"C03",false)
    hypixel_guimove = module_manager.register_boolean(getName(),"Guimove",true)
    hypixel_guimovekey = module_manager.register_text(getName(),"Inventory Key","B")
    module_manager.register_label(getName(),"Grim Options")
    grim_fastbreak = module_manager.register_boolean(getName(),"Fast Break",client.config():lower() == "quickmacro")
    grim_superinventory = module_manager.register_boolean(getName(),"Better Skywars Manager",true)

    module_manager.register_label(getName(),"Misc")
    debug = module_manager.register_boolean(getName(),"Debug",false)
    function on_enable() oninv = false end
    function on_key_press(key)
        if key == input.get_key_number(hypixel_guimovekey:get_string()) then
            oninv_v = oninv_v + 1
        end
        if oninv_v >= 2 then
            oninv = not oninv
            oninv_v = 0
        end
    end
    function on_pre_update()
        if disablermode:get_string() == "Grim" then
            if grim_fastbreak:get_boolean() and grim_fastbreak_onbreak then
                player.send0x07("ABORT_DESTROY_BLOCK",player.facing(),player.position())
            end
            if grim_superinventory:get_boolean() then
                rh:setmodulevalue("inventorymanager","delay",0,"double")
                rh:setmodulevalue("autoarmor","delay",0,"double")
                rh:setmodulevalue("cheststealer","delay",0,"double")
            end
        end
    end
    function on_send_packet(packet)
        if packet == 0x07 then
            if player.get_serverip() == "mc.hypixel.net" then oninv = false end
            if disablermode:get_string() == "Grim" and grim_fastbreak:get_boolean() then
                rh:setmodulevalue("Speed Mine","Amount",0.1,"double")
                grim_fastbreak_onbreak = true
            end
        end
        if disablermode:get_string() == "Hypixel" then
            if hypixel_c03:get_boolean() then
                if (packet == 0x03) then
                    if(player.is_moving() == false)then
                        if debug:get_boolean() then
                            lprint("Cancel Packet")
                        end
                        return true
                    end
                end
            end
        end
        return false
    end
    function on_player_move(event)
        if disablermode:get_string() == "Hypixel" and hypixel_guimove:get_boolean() and oninv then
            player.convert_speed(event,0)
        end
    end
end



function player.get_serverip()
    if world.is_singlePlayer() then
        return "Local Server"
    else
        return world.get_server()
    end
end