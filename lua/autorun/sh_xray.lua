if CLIENT then
    surface.CreateFont("xray1", {
        font = "HudDefault",
        size = 30,
        weight = 800,
        antialias = true
    })

    local function drawxray()

        // For Players
        local pls = player.GetAll()
        for i = 1, #pls do
            local xraytarg = pls[i]
            if not IsValid(xraytarg) or not xraytarg:IsPlayer() or xraytarg == LocalPlayer() or not xraytarg:Alive() then continue end

            local pos = xraytarg:GetShootPos():ToScreen()
            if not pos.visible then continue end

            local x, y = pos.x, pos.y

            local name = xraytarg:Nick()
            local hp = xraytarg:Health()

            surface.SetTextColor(0, 220, 0, 255)
            surface.SetFont("xray1")
            local namew, nameh = surface.GetTextSize(name)
            surface.SetTextPos(x - namew / 2, y - 48)
            surface.DrawText(name)

            surface.SetTextColor(255, 255, 255, 255)
            surface.SetFont("xray1")
            surface.SetTextPos(x - namew / 2, y - 26)
            surface.DrawText(hp)
        end

        // For NPCs
        for _, ent in ipairs(ents.GetAll()) do
            if not IsValid(ent) or not ent:IsNPC() then continue end

            local headPos = ent:GetPos() + Vector(0, 0, 72)
            local pos = headPos:ToScreen()
            local x, y = pos.x, pos.y

            local name = "NPC" --ent:GetClass() // use this if you want to display the NPC class (like npc_antlionguard) instead
            local hp = ent:Health()

            surface.SetTextColor(255, 0, 0, 255)
            surface.SetFont("xray1")
            local namew, nameh = surface.GetTextSize(name)
            surface.SetTextPos(x - namew / 2, y - 48)
            surface.DrawText(name)

            surface.SetTextColor(255, 255, 255, 255)
            surface.SetFont("xray1")
            surface.SetTextPos(x - namew / 2, y - 26)
            surface.DrawText(hp)
        end

    end

    local xray = false

    concommand.Add("xray", function(ply)
        if ply:IsSuperAdmin() or ply:IsAdmin() then // you COULD add custom checks here (like SAM or sum stuff) 
            xray = not xray
        else
            ply:ChatPrint("You do not look like an Administrator? Fuck off!")
        end
    end)

    hook.Add("HUDPaint", "AdminHUD", function()
        if xray then
            drawxray()
        end
    end)
end

if SERVER then
    hook.Add("PlayerSay", "xray", function(ply, text, team)
        if string.sub(text, 1, 5) == "/xray" then
            ply:ConCommand("xray")
            return ""
        end
    end)
end