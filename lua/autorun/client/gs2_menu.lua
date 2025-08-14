if not localify then
    include("gibsplat2/localify.lua")
end
include("gibsplat2/localization.lua")

local defaults =
{
    ["gs2_bloodpool_size"] = "10",
    ["gs2_old_effects"] = "1",
    ["gs2_new_effects"] = "1",
    --["gs2_particles_linger_chance"] = "0.1",
    --["gs2_max_particles"] = "10000",
    --["gs2_particles_lifetime"] = "60",
    ["gs2_mesh_iterations"] = "10",
    ["gs2_gib_cl"] = "1",
    --["gs2_less_limbs"] = "0",
    ["gs2_constraint_strength_multiplier"] = "250",
    ["gs2_max_constraint_strength"] = "15000",
    ["gs2_min_constraint_strength"] = "4000",
    ["gs2_gib_generate_all"] = "0",
    ["gs2_max_gibs"] = "128",
    ["gs2_gib_custom"] = "1",
    ["gs2_gib_merge_chance"] = "0.7",
    ["gs2_gib_factor"] = "0.3",
    ["gs2_gib_lifetime"] = "300",
    ["gs2_gib_expensive"] = "0",
    ["gs2_pull_limb"] = "1",
    ["gs2_gib_chance"] = "0.3",
    ["gs2_gib_sv"] = "1",
    ["gs2_default_ragdolls"] = "1",
    ["gs2_max_decals_transfer"] = "5",
    --["gs2_gib_chance_explosion_multiplier"] = "10"
    ["gs2_health_multiplier"] = "1"
}

concommand.Add("gs2_reset_cvars", function()
    for cvar, val in pairs(defaults) do
        local CV = GetConVar(cvar)
        if CV then
            RunConsoleCommand(cvar, CV:GetDefault())
        end
    end
end)

local function PopulateGS2Menu(pnl)

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.enabled"), "gs2_enabled")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_enabled"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.keep_corpses"), "ai_serverragdolls")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_keep_corpses"))

    if LocalPlayer():IsAdmin() then
        pnl:Button(localify.Localize("#addon.gibsplat2.cleanup_gibs"), "gs2_cleargibs_sv")
    else
        pnl:Button(localify.Localize("#addon.gibsplat2.cleanup_gibs"), "gs2_cleargibs")
    end
    
    pnl:Button(localify.Localize("#addon.gibsplat2.reset_settings"), "gs2_reset_cvars")

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.default_ragdolls"), "gs2_default_ragdolls")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_default_ragdolls"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.player_ragdolls"), "gs2_player_ragdolls")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_player_ragdolls"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.lua_effects"), "gs2_old_effects")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_lua_effects"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.effects"), "gs2_new_effects")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_effects"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.expensive_gibs"), "gs2_gib_expensive")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_expensive_gibs"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.custom_gibs"), "gs2_gib_custom")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_custom_gibs"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.sv_gibs"), "gs2_gib_sv")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_sv_gibs"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.cl_gibs"), "gs2_gib_cl")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_cl_gibs"))

    pnl:CheckBox(localify.Localize("#addon.gibsplat2.expensive_joints"), "gs2_pull_limb")
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_expensive_joints"))


    -- pnl:NumSlider(localify.Localize("#addon.gibsplat2.max_decal_transfer"), "gs2_max_decals_transfer", 0, 15)
    -- pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_max_decal_transfer"))

    pnl:NumSlider(localify.Localize("#addon.gibsplat2.gib_limit"), "gs2_max_gibs", 0, 512)
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_gib_limit"))

    -- pnl:NumSlider(localify.Localize("#addon.gibsplat2.particle_limit"), "gs2_max_particles", 0, 500)
    -- pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_particle_limit"))

    pnl:NumSlider(localify.Localize("#addon.gibsplat2.health_multiplier"), "gs2_health_multiplier", 0, 10, 3)
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_health_multiplier"))

    pnl:NumSlider(localify.Localize("#addon.gibsplat2.explosion_gib_chance"), "gs2_gib_chance", 0, 1, 3)
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_explosion_gib_chance"))

    -- pnl:NumSlider(localify.Localize("#addon.gibsplat2.explosion_chance"), "gs2_gib_chance_explosion_multiplier", 0, 50, 3)
    -- pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_explosion_chance"))

    pnl:NumSlider(localify.Localize("#addon.gibsplat2.gib_spawnrate"), "gs2_gib_factor", 0, 1, 3)
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_gib_spawnrate"))

    pnl:NumSlider(localify.Localize("#addon.gibsplat2.gib_merge_chance"), "gs2_gib_merge_chance", 0, 1, 3)
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_gib_merge_chance"))

    pnl:NumSlider(localify.Localize("#addon.gibsplat2.gib_lifetime"), "gs2_gib_lifetime", 0, 1000)
    pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_gib_lifetime"))

    -- pnl:NumSlider(localify.Localize("#addon.gibsplat2.particle_lifetime"), "gs2_particles_lifetime", 1, 500, 3)
    -- pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_particle_lifetime"))

    -- pnl:NumSlider(localify.Localize("#addon.gibsplat2.particle_linger_chance"), "gs2_particles_linger_chance", 0, 1, 3)
    -- pnl:ControlHelp(localify.Localize("#addon.gibsplat2.desc_particle_linger_chance"))
end

-- Check if sandbox is active gamemode and add in the settings
if engine.ActiveGamemode() == "sandbox" then
    hook.Add("AddToolMenuCategories", "GibSplat2Category", function() 
        spawnmenu.AddToolCategory("Utilities", "GibSplat2", localify.Localize("#addon.gibsplat2.name"))
    end)

    hook.Add("PopulateToolMenu", "GibSplat2MenuSettings", function() 
        spawnmenu.AddToolMenuOption("Utilities", "GibSplat2", "GS2Settings", 
            localify.Localize("#addon.gibsplat2.settings"), "", "", function(pnl)
            pnl:ClearControls()
            pnl:Help(localify.Localize("#addon.gibsplat2.menu_help"))
            PopulateGS2Menu(pnl)
        end)
    end)
end
