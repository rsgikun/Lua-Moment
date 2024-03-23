local rh = RHelper:new()
local json_config = {Values = {}}

local startmsg_enable
local startmsg_checktext
local startmsg_msg

local autogg_enable
local autogg_checktext
local autogg_ggtext
function getName()
    return "Game Helper"
end
function init_script()
    local function label(text)
        module_manager.register_label(getName(),text)
    end
    label("Auto GG")
    autogg_enable = module_manager.register_boolean(getName(),"Toggled",true)
    autogg_checktext = module_manager.register_text(getName(),"Check String","获得胜利")
    autogg_ggtext = module_manager.register_text(getName(),"GG Text","GG")
    label("Start Message")
    startmsg_enable = module_manager.register_boolean(getName(),"Toggled",false)
    startmsg_checktext = module_manager.register_text(getName(),"Check String","游戏已开始")
    startmsg_msg = module_manager.register_text(getName(),"Message","我正在使用Styles")
    client.register_command("gamehelper_config",{})
    rh:config_init(json_config,getName(),true)
    function on_message_receive(msg)
        local checkmsg = rh:removeMinecraftFormatting(msg)
        if autogg_enable:get_boolean() and string.find(checkmsg,autogg_checktext:get_string()) ~= nil then
            player.send_message(autogg_ggtext:get_string())
        end
        if startmsg_enable:get_boolean() and string.find(checkmsg,startmsg_checktext:get_string()) ~= nil then
            player.send_message(startmsg_msg:get_string())
        end
        return msg
    end
    function on_chat(msg)
        if utf8_sub(msg,1,1) == "." then
            local command = split(utf8_sub(msg,2)," ")
            if command[1] == "gamehelper_config" then
                msg = ".kick a"
                rh:config_chatcheck(json_config,command,getName(),true)
            end
        end
        return msg
    end
end