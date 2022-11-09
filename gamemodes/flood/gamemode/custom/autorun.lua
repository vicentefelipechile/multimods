--------------------------
---- Custom Lua Files ----
--------------------------
GM_Name = "flood"

GM_Path = GM_Name .. "/gamemode/custom/"

local prefix = "[GM-Custom]"

local m {
    SV = function(s)
        MsgC( Color(56, 228, 255, 200), prefix, " ", Color(184, 246, 255, 200), tostring(s).."\n")
    end,

    CL = function(s)
        MsgC( Color(255, 235, 56, 200), prefix, " ", Color(184, 246, 255, 200), tostring(s).."\n")
    end,

    SH = function(s)
        MsgC( Color(167, 255, 167, 200), prefix, " ", Color(184, 246, 255, 200), tostring(s).."\n")
    end
}

local function AddDir(dir)
    dir = dir .. "/"

    local files, directories = file.Find(GM_Name .. dir .. "*", "LUA")
    for _, v in ipairs(files) do
        if string.EndsWith(v, ".lua") then
            include(v)
            m.SV("RUNNING: " .. v)
        end
    end
end
AddDir("autorun")