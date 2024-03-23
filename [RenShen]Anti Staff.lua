local rh = RHelper:new()
local json_config = {Values = {}}
local stafflist = {
    heypixel = {["元宵"] = "客服",["练书法的苦力怕"] = "客服",["艾米丽"] = "客服",["抖音丶小匪"] = "客服",["抑郁的元宵"] = "客服",["nightbary"] = "客服",["绿豆乃SAMA"] = "客服",["元宵睡不醒"] = "客服",["WS故"] = "客服",["xiaotufei"] = "小匪的游玩号",["KiKiAman"] = "元宵的游玩号",["元宵的测试号"] = "元宵",["可比不来嗯忑"] = "能ban人的玩家",["彩笔"] = "能ban人的玩家",["布吉岛打工仔"] = "Heypixel Owner"}
}
local hasdetectstaff = {}

local server
local sendmessage
local sendmessagetext
function getName()
    return "Staff Detected"
end
function init_script()
    server = module_manager.register_mode(getName(),"Staff Mode",{"Heypixel"},"Heypixel")
    sendmessage = module_manager.register_boolean(getName(),"Send Message",false)
    sendmessagetext = module_manager.register_text(getName(),"Message","/hub")
    rh:config_init(json_config,getName())
    client.register_command("antistaff_config",{})
    function on_pre_update()
        if player.ticks_existed() <= 1 then
            hasdetectstaff = {}
        else
            for _, entityid in ipairs(world.entities()) do
                if entity.is_player(entityid) then
                    local name = entity.get_name(entityid)
                    local success,beizu = isontable(stafflist[server:get_string():lower()],name:lower())
                    if success and not isontable(hasdetectstaff,name) then
                        table.insert(hasdetectstaff,name)
                        lprint("§cDetected Blacklist Name §3" .. name .. " §7| §cReason: §3" .. beizu)
                        if sendmessage:get_boolean() then
                            player.send_message(sendmessagetext:get_string())
                        end
                        if server:get_string() == "Heypixel" then
                            for i = 1, 6 do
                                player.send_message("/pc Detected Blacklist Name '" .. name .. "' | Reason: " .. beizu)
                            end
                        end
                    end
                end
            end
        end
    end
    function on_enable()
        hasdetectstaff = {}
    end
    function on_chat(msg)
        if utf8_sub(msg,1,1) == "." then
            local command = split(utf8_sub(msg,2)," ")
            if command[1] == "antistaff_config" then
                msg = ".kick a"
                rh:config_chatcheck(json_config,command,getName())
            end
        end
        return msg
    end
end
function isontable(t,n)
    for name, value in pairs(t) do
        if n:lower() == name:lower() or tostring(value):lower() == tostring(n):lower() then
            return true,value
        end
    end
    return false,""
end
