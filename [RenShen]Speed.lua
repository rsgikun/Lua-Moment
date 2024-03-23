local rh = RHelper:new()
local mode
local grimentityspeed
local HypixelBHop_is_first_jump
local vanillacorrent
local hypixelstrafetestdata = {0,15}
local json_config = {Values = {}}

function getName()
    return "RSpeed"
end
function init_script()
    mode = module_manager.register_mode(getName(),"Mode",{"Grim Entity","AAC4 Hop","NCP Hop","Ground Strafe","Falldown Boost","Hypixel BHop","Hypixel Strafe Test","Heypixel Entity","Strafe hop","Themis Lowhop"},"Strafe hop")
    grimentityspeed = module_manager.register_number(getName(),"Grim Entity Speed",0.6,0.1,5,0.1)
    vanillacorrent = module_manager.register_boolean(getName(),"Vanilla Corrent",true)
    rh:config_init(json_config,getName())
    client.register_command("speed_config",{})
    math.randomseed(os.clock())
    if user.get_username() == "renshengongji" and (string.find(client.config(),"hypixel") or string.find(client.config(),"Motionblur")) then
        player.send_message(".bind rspeed q")
    end
    function on_pre_motion(pre)
        if vanillacorrent:get_boolean() and not (player.is_in_water() or player.is_in_lava() or player.is_in_cobweb() or player.dead()) or not vanillacorrent:get_boolean() then
            if mode:get_string() == "Grim Entity" then
                --event:set_yaw(player.angles_for_cords(math.floor(entity.get_x(114514)),math.floor(entity.get_y(114514)),math.floor(entity.get_z(114514))):get_yaw())
                --event:set_pitch(player.angles_for_cords(math.floor(entity.get_x(114514)),math.floor(entity.get_y(114514)),math.floor(entity.get_z(114514))):get_pitch())
                if in_hitbox2() then
                    player.set_speed(grimentityspeed:get_double())
                end
            end
            if mode:get_string() == "AAC4 Hop" then
                if player.on_ground() and player.is_moving() then
                    player.jump()
                end
                if player.fall_distance() >0.9 and player.fall_distance() < 1.3 then
                    world.set_timer(1.8)
                else
                    world.set_timer(1)
                end
            end
            if mode:get_string() == "NCP Hop" then
                player.set_speed(0.23 * (math.random(100,115)/100))
                if player.on_ground() and player.is_moving() then
                    player.jump()
                end
            end
            if mode:get_string() == "Ground Strafe" then
                if player.on_ground() and player.is_moving() then
                    player.set_speed(player.get_speed())
                    player.jump()
                end
            end
            if mode:get_string() == "Falldown Boost" then
                if player.on_ground() and player.is_moving() then
                    player.set_speed(player.get_speed()*(math.random(56,105))/100)
                    player.jump()
                end
                if player.fall_distance() >0.9 and player.fall_distance() < 1.3 then
                    player.set_speed(player.get_speed()*1.5)
                end
            end
            if mode:get_string() == "Hypixel BHop" or mode:get_string() == "Hypixel Strafe Test" then
                math.randomseed(os.time()+os.clock()*player.ticks_existed())
                if not input.is_key_down(17) and not input.is_key_down(30) and not input.is_key_down(31) and not input.is_key_down(32) and player.on_ground() then
                    HypixelBHop_is_first_jump = true
                end
                local player_base_speed = player.base_speed()
                if player.is_moving() and player.on_ground() and not input.is_key_down(57) then
                    local speed = 1
                    if not input.is_key_down(17) then
                        if player_base_speed > 0.40222 then
                            speed = 1.04
                        elseif player_base_speed > 0.34476 then
                            speed = 1.02
                        end
                        speed = 0.1528 * speed
                    else
                        if HypixelBHop_is_first_jump then
                            if player_base_speed > 0.40222 then
                                speed = 1.04
                            elseif player_base_speed > 0.34476 then
                                speed = 1.02
                            end
                            speed = 0.1538 * speed
                        else
                            if player_base_speed > 0.40222 then
                                speed = 1.04
                            elseif player_base_speed > 0.34476 then
                                speed = 1.02
                            end
                            speed = 0.2852 * speed
                        end
                    end
                    if (input.is_key_down(17) or input.is_key_down(31)) and (input.is_key_down(30) or input.is_key_down(32)) then
                        speed = speed / (1.2 + math.random(-12,5)/100)
                    end
                    player.set_speed(speed)
                    player.jump()
                    HypixelBHop_is_first_jump = false
                end
            end
            if mode:get_string() == "Heypixel Entity" then
                --module_manager.set_state("targetstrafe",math.abs(player.moveInput():move_forward()) + math.abs(player.moveInput():move_strafe()) ~= 0)
                if player.on_ground() and tostring(player.get_motion_y()) == "-0.0784" and math.abs(player.moveInput():move_forward()) + math.abs(player.moveInput():move_strafe()) ~= 0 then
                    player.jump()
                end
                if in_hitbox2() and not player.on_ground() then
                    player.set_speed(0.42)
                end
            end
            if mode:get_string() == "Strafe hop" then
                player.set_speed(player.get_speed())
                if player.on_ground() and player.is_moving() then
                    player.jump()
                end
            end
        end
    end
    function on_player_move(event)
        if vanillacorrent:get_boolean() and not (player.is_in_water() or player.is_in_lava() or player.is_in_cobweb() or player.dead()) or not vanillacorrent:get_boolean() then
            if mode:get_string() == "Hypixel Strafe Test" and not player.on_ground() then
                math.randomseed(os.time()*os.clock()*player.ticks_existed() *hypixelstrafetestdata[2])
                if hypixelstrafetestdata[1] > hypixelstrafetestdata[2] then
                    hypixelstrafetestdata[1] = 0
                    hypixelstrafetestdata[2] = math.random(12,25)
                    lprint("Strafe | After Tick: " .. hypixelstrafetestdata[2])
                    if (input.is_key_down(17) or input.is_key_down(31)) and (input.is_key_down(30) or input.is_key_down(32)) then
                        player.convert_speed(event,player.get_speed()/0.4)
                    else
                        player.convert_speed(event,player.get_speed()/0.9)
                    end
                end
            end
            if mode:get_string() == "Themis Lowhop" then
                rh:setmodulevalue("sprint","mode",input.is_key_down(57) and "Basic" or "Omni","string")
                if player.hurt_time() <= 7 then
                    player.convert_speed(event,input.is_key_down(57) and math.max(player.hurt_time() <= 5 and player.get_speed() or 0,0.3) or player.get_speed())
                    if input.is_key_down(57) then
                        if player.on_ground() then
                            player.set_motion_y(0.21)
                            if player.collided_horizontally() then
                                player.set_motion_y(0.42)
                            end
                        end
                    end
                end
            end
        end
        return event
    end
    function on_tick()
        if (vanillacorrent:get_boolean() and not (player.is_in_water() or player.is_in_lava() or player.is_in_cobweb() or player.dead() or input.is_key_down(57)) or not vanillacorrent:get_boolean()) and mode:get_string() == "Hypixel Strafe Test" then
            hypixelstrafetestdata[1] = hypixelstrafetestdata[1] + 1
        end
    end    
    function on_disable()
        world.set_timer(1)
        if mode:get_string() == "Themis Lowhop" then rh:setmodulevalue("sprint","mode","Basic","string") end
    end
    function on_chat(msg)
        if utf8_sub(msg,1,1) == "." then
            local command = split(utf8_sub(msg,2)," ")
            if command[1] == "speed_config" then
                msg = ".kick a"
                rh:config_chatcheck(json_config,command,getName())
            end
        end
        return msg
    end
end

function entity.low_distance_entity()
    local entity = {}
    local entitys = {}
    for k,v in ipairs(world.livings()) do
        if test(v) == false then
            table.insert(entity,player.distance_to_entity(v))
            table.insert(entitys,v)
        end
    end
    sort(entity,entitys)
    if type(entitys[#entitys]) ~= "number" then
        return 0
    end
    return entitys[#entitys]
end
function sort(arr,arr2)
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
function test(eid)
    if eid ~= player.id() or not entity.is_self(eid) then
        return false
    end
    return entity.get_x(eid) + entity.get_y(eid) + entity.get_z(eid) == entity.get_x(player.id()) + entity.get_y(player.id()) + entity.get_z(player.id())
end
function in_hitbox()
    local eid = entity.low_distance_entity()
    if (math.floor(entity.get_x(eid)) == math.floor(entity.get_x(player.id())) and math.floor(entity.get_y(player.id())) == math.floor(entity.get_y(eid))) or (math.floor(entity.get_y(player.id())) == math.floor(entity.get_y(eid)) and math.floor(entity.get_z(eid)) == math.floor(entity.get_z(player.id()))) then
        return true
    end
    return false
end
function in_hitbox2()
    local eid = entity.low_distance_entity()
    if eid == 0 then
        return false
    end
    if player.distance_to_entity(eid) < 1 then
        return true
    end
    return false
end
function setmodulevalue(modulename,value_,valuetext,mode)
    mode = mode:lower()
    for key, value in ipairs(module_manager.get_values(modulename)) do
        if (value:get_name() == value_) then
            if mode == "string" then
                value:set_string(valuetext)
            end
            if mode == "double" then
                value:set_double(valuetext)
            end
            if mode == "int" then
                value:set_int(valuetext)
            end
            if mode == "boolean" then
                value:set_boolean(valuetext)
            end
            if mode == "description" then
                value:set_description(valuetext)
            end
            if mode == "rgb" then
                value:set_rgb(valuetext)
            end
            if mode == "label" then
                value:edit(valuetext)
            end
            if mode == "item" then
                value:select(valuetext)
            end
            if mode == "hue" then
                value:set_hue(valuetext)
            end
            if mode == "brightness" then
                value:set_brightness(valuetext)
            end
            if mode == "saturation" then
                value:set_saturation(valuetext)
            end
            return true
        end
    end
    return false
end