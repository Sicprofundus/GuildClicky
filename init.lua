--[[
    Created by Sic
        Thanks to the lua peeps, SpecialEd, kaen01, dannuic, knightly, aquietone, brainiac and all the others
        This lua script is inspired by sl968

        I don't know much about lua so yikes might be ahead!
--]]
---@type Mq
local mq = require('mq')
---@type ImGui
-- Load ImGui library
require 'ImGui'

local ground = mq.TLO.Ground

local guildclickymsg = '\ao[\agGuildClicky\ao]\ag::\aw '
local guildclickyhelp = 'Please \ay\"/guildclicky \ag(or /gc)\ay help\"\aw for a list of available clickable guild portals.'

local bValidateComplete = false

-- GUI Control variables
-- TODO: create option to allow always displayed in guild hall
local bDisplayUI = false

local guildhallzonesbyID = {
    [345] = true, -- "Guild Hall"
    [737] = true, -- "Palatial Guild Hall"
    [738] = true, -- "Grand Guild Hall"
    [751] = true, -- "Modest Guild Hall"
}

local colors = {
    -- self = IM_COL32(38, 70, 83, 255),
    -- group = IM_COL32(42, 157, 143, 255),
    -- raid = IM_COL32(233, 196, 106, 255),
    -- zone = IM_COL32(244, 168, 97, 255),
    -- all = IM_COL32(42, 157, 143, 255)
    self = IM_COL32(100, 143, 255, 255),
    group = IM_COL32(120, 94, 240, 255),
    raid = IM_COL32(220, 38, 127, 255),
    zone = IM_COL32(254, 97, 0, 255),
    all = IM_COL32(255, 176, 0, 255)
}

local ClickableUIButtons = {
    [1] = { label = 'S', command = 'x', --[[junk]]  tooltip = 'Self',   color = colors.self },
    [2] = { label = 'G', command = '/dgga ',        tooltip = 'Group',  color = colors.group },
    [3] = { label = 'R', command = '/dgra ',        tooltip = 'Raid',   color = colors.raid },
    [4] = { label = 'Z', command = '/dgza ',        tooltip = 'Zone',   color = colors.zone },
    [5] = { label = 'A', command = '/dgae ',        tooltip = 'All',    color = colors.all }
}

-- this is not an exhaustive list and will get expanded
-- please post in the discussion thread for additions
local guildclickies = {
    -- name = { item = '', text = '' },
    -- [A]
    abysmal = { item = 'The Grozmok Stone', text = 'Teleport to Abysmal Sea' },
    akanon = { item = 'Shelf of Gnomish Spirits', text = 'Teleport to Ak\'Anon' },
    akanon2 = { item = 'Ak\'Anon Bubble Lamp', text = 'Teleport to Ak\'Anon' },
    arena = { item = 'Ever-Burning Brazier of War', text = 'Teleport to the Arena' },
    ashengate = { item = 'Seal of Ashengate', text = 'Teleport to Ashengate, Reliquary of the Scale' },
    aureate = { item = 'Aureate Dragon Ring', text = 'Teleport to Aureate Covert' },
    -- [B]
    blackburrow = { item = 'Banner: Blackburrow', text = 'Teleport to Blackburrow' },
    bloodykith = { item = 'Army of Light Barricade', text = 'Teleport to Bloody Kithikor' },
    brells = { item = 'Temple Torchiere', text = 'Teleport to Brell\'s Temple' },
    broodlands = { item = 'Draconic Shrine of the Brood', text = 'Teleport to The Broodlands' },
    butcherblock = { item = 'Statue of Brell', text = 'Teleport to Butcherblock Mountains' },
    -- [C]
    cabeast = { item = 'Placard: Tink N Babble', text = 'Teleport to East Cabilis' },
    cabwest = { item = 'Brain in a Jar', text = 'Teleport to West Cabilis' },
    crushbone = { item = 'Banner of Clan Crushbone', text = 'Teleport to Clan Crushbone' },
    cobalt = { item = 'Skyshrine Dragon Brazier', text = 'Teleport to Cobalt Scar' },
    crystalcaverns = { item = 'Painting: Froststone Gate', text = 'Teleport to Crystal Caverns' },
    -- [D]
    drunder = { item = 'Painting: Drunder, the Fortress of Zek', text = 'Teleport to Drunder, Fortress of Zek' },
    dulak = { item = 'Painting: Dulak\'s Harbor', text = 'Teleport to Dulak\'s Harbor' },
    -- [E]
    eldar = { item = 'Painting: Elddar Forest', text = 'Teleport to The Elddar Forest' },
    erudin = { item = 'Erudin Brazier', text = 'Teleport to Erudin' },
    everfrost = { item = 'Claw Sconce Torch', text = 'Teleport to Everfrost' },
    -- [F]
    feerrottb = { item = 'Ogrish Spit', text = 'Teleport to The Feerrott' },
    felwithesouth = { item = 'Felwithe Candelabra', text = 'Teleport to Southern Felwithe' },
    firiona = { item = 'Champion of Tunare Statue', text = 'Teleport to Firional Vie' },
    freeportn = { item = 'Painting: Tassel\'s Tavern', text = 'Teleport to North Freeport' },
    frontier = { item = 'Ancient Iksar Translocator Statue', text = 'Teleport to Frontier Mountains' },
    froststone = { item = 'Froststone Crystal Echo', text = 'Teleport to Froststone' },
    fury = { item = 'Oceanographer\'s Globe', text = 'Teleport to Hate\'s Fury' },
    -- [G]
    gfaydark = { item = 'Torch of Kelethin', text = 'Teleport to Greater Faydark' },
    gorowyn = { item = 'Gorowyn Translocator Lantern', text = 'Teleport to Skyfire Mountains' },
    grimling = { item = 'Painting: Grimling Forest Outpost', text = 'Teleport to Grimling Forest' },
    grobb = { item = 'Sign: Gunthak\'s Beltch', text = 'Teleport to Grobb' },
    grobb2 = { item = 'All-Seeing Skull', text = 'Teleport to Grobb' },
    grobb3 = { item = 'Darkone\'s Throne', text = 'Teleport to Grobb' },
    grobb4 = { item = 'Troll\'s Butchery', text = 'Teleport to Grobb' },
    growth = { item = 'Painting: Tunare\'s Tree', text = 'Teleport to Plane of Growth' },
    gunthak = { item = 'Gunthak Altar', text = 'Teleport to the Gulf of Gunthak' },
    -- [H]
    health = { item = 'Cynosure of Health', text = 'Teleport to the Plane of Health' },
    halas = { item = 'Placard: Halas', text = 'Teleport to Halas' },
    halas2 = { item = 'Mounted Snake Head', text = 'Teleport to Halas' },
    halas3 = { item = 'Mounted Bear Head', text = 'Teleport to Halas' },
    halas4 = { item = 'Mounted Tiger Head', text = 'Teleport to Halas' },
    highkeep = { item = 'Painting: High Keep Serpent', text = 'Teleport to High Keep' },
    highkeep2 = { item = 'Banner: The Knotted Serpent', text = 'Teleport to High Keep' },
    hodstock = { item = 'Aureate Dragon Ring', text = 'Teleport to Hodstock Hills' },
    hole = { item = 'Tattered Cazicite Banner', text = 'Teleport to The Ruins of Old Paineel' },
    hollowshade = { item = 'Hollowshade Moor Bonefire', text = 'Teleport to Hollowshade Moor' },
    -- [I]
    iceclad = { item = 'Banner: Gnome Pirates', text = 'Teleport to Iceclad Ocean' },
    icewell = { item = 'Dain\'s Throne Replica', text = 'Teleport to Icewell Keep' },
    innothule = { item = 'Guktan Brazier', text = 'Teleport to Innothule Swamp' },
    innovation = { item = 'Innovative Heli-Lamp', text = 'Teleport of Plane of Innovation' },
    -- [J]
    -- [K]
    kael = { item = 'Banner of the Frostborn Giants', text = 'Teleport to Kael Drakkel' },
    kaladim = { item = 'Underfoot Monument', text = 'Teleport to North Kaladim' },
    kithicor = { item = 'Painting: Kithicor Forest', text = 'Teleport to Kithicor Forrest' },
    -- [L]
    laurion = { item = 'Laurion\'s Door', text = 'Teleport to Laurion Inn' },
    library = { item = 'Library Wall Sconce', text = 'Teleport to The Library' },
    lfaydark = { item = 'Painting: Brownie Encampment', text = 'Teleport to Lesser Faydark' },
    lobby = { item = 'Shabby Lobby Door', text = 'Open the Door to the Lobby' },
    -- [M]
    marr = { item = 'Statue of Mithaniel Marr', text = 'Teleport to The Temple of Marr' },
    mesa = { item = 'Runed Dragon Totem', text = 'Teleport to Goru`kar Mesa' },
    mischief = { item = 'Mischievous Wall Torch', text = 'Teleport to Plane of Mischief' },
    mistmoore = { item = 'Castle of Mistmoore Throne', text = 'Teleport to Castle of Mistmoore' },
    misty = { item = 'Misty Thicket Halfling Bed', text = 'Teleport to Misty Thicket' },
    -- [N]
    nadox = { item = 'Nadox Chandelier', text = 'Teleport to Crypt of Nadox' },
    necropolis = { item = 'Effigy of the Necropolis', text = 'Teleport to Dragon Necropolis' },
    nedaria = { item = 'Painting: Nedaria\'s Landing', text = 'Teleport to Nedaria\'s Landing' },
    neriak = { item = 'Painting: The Blind Fish', text = 'Teleport to Neriak - Commons' },
    neriakc = { item = 'Painting: Toadstool Tavern', text = 'Teleport to Neriak - Commons' },
    neriak3rd = { item = 'Painting: Maiden\'s Fancy', text = 'Teleport to Neriak - Third Gate' },
    neriakfq = { item = 'Painting: Slugs Tavern', text = 'Teleport to Neriak - Foreign Quarter' },
    nqeynos = { item = 'Coat of Arms: Qeynos', text = 'Teleport to North Qeynos' },
    nqeynos2 = { item = 'Painting: Crow\'s Pub & Casino', text = 'Teleport to North Qeynos' },
    nqeynos3 = { item = 'Banner: Traveler\'s Tapestry', text = 'Teleport to North Qeynos' },
    -- [O]
    oggok = { item = 'Oggok Boulder Lounger', text = 'Teleport to Oggok' },
    oot = { item = 'Islander Hammock', text = 'Teleport to Ocean of Tears' },
    -- [P]
    paineel = { item = 'Bookshelf of Paineel', text = 'Teleport to Paineel' },
    permafrost = { item = 'Frozen Barbarian Adventurer', text = 'Teleport to Permafrost' },
    permafrost2 = { item = 'Frozen Barbarian Adventuress', text = 'Teleport to Permafrost' },
    -- [Q]
    -- [R]
    rathe = { item = 'Rathe Mountain Cart', text = 'Teleport to The Rathe Mountains' },
    rivervale = { item = 'Rivervale Jumjum Cart', text = 'Teleport to Rivervale' },
    runnyeye = { item = 'Runnyeye Adventurer\'s Head', text = 'Teleport to Liberated Citadel of Runnyeye' },
    -- [S]
    sanctus = { item = 'Statue: Sanctus Seru', text = 'Teleport to Sanctus Seru' },
    sanctus2 = { item = 'Banner: Sanctus Seru', text = 'Teleport to Sanctus Seru' },
    seb = { item = 'Froglok Head in a Jar', text = 'Teleport to Old Sebilis' },
    sharvhal = { item = 'Sculpted Vah Shir Effigy', text = 'Teleport to Shar Vahl' },
    shadowhaven = { item = 'Shadow Haven Teleport Pad', text = 'Teleport to Shadow Haven' },
    shadeweavers = { item = 'Banner of the Vah Shir Crest', text = 'Teleport to Shadeweaver\'s Thicket' },
    skyshrine = { item = 'Skyshrine Claw Sconce', text = 'Teleport to Skyshrine' },
    sqeynos = { item = 'Painting: Lion\'s Mane Tavern', text = 'Teleport to South Qeynos' },
    stratos = { item = 'Stratos Fire Platform', text = 'Teleport to Stratos' },
    steamfont = { item = 'Steamfont Lava Lamp', text = 'Teleport to Steamfont Mountains' },
    steamfont2 = { item = 'Fantastic Fuel Orb', text = 'Teleport to Steamfont Mountains' },
    stonebrunt = { item = 'Painting: Stonebrunt Mountains', text = 'Teleport to Stonebrunt Mountains' },
    surefall = { item = 'Brazier: The Everburning Ruby', text = 'Teleport to Surefall Glade' },
    surefall2 = { item = 'Painting: The Founder', text = 'Teleport to Surefall Glade' },
    swamp = { item = 'Statue: Iksar Head', text = 'Teleport to Swamp of No Hope' },
    ssra = { item = 'Ssraeshza Temple Sarcophagus', text = 'Teleport to Ssraeshza Temple' },
    -- [T]
    takishruins = { item = 'Painting: Ruins of Takish-Hiz', text = 'Teleport to Ruins of Takish-Hiz' },
    templeveeshan = { item = 'Banner of Veeshan', text = 'Teleport to The Temple of Veeshan' },
    thurgadin = { item = 'Dwarven Ice Statue', text = 'Teleport to Thurgadin' },
    tosk = { item = 'Statue of Toskirakk', text = 'Teleport to Toskirakk' },
    toxx = { item = 'Painting: Toxxulia Forest', text = 'Teleport to Toxxulia Forest' },
    trak = { item = 'Emperor Ganak Throne', text = 'Teleport to Trakanon\'s Teeth' },
    trak2 = { item = 'Statue: Iksar Bust', text = 'Teleport to Trakanon\'s Teeth' },
    -- [U]
    umbral =  { item = 'Umbral Plains Scrying Bowl', text = 'Teleport to Umbral Plains' },
    -- [V]    
    veksar = { item = 'Veksar Chandelier', text = 'Teleport to Veksar' },
    vexthal = { item = 'Statue of Aten Ha Ra', text = 'Teleport to Vex Thal' },
    -- [W]
    war = { item = 'Plane of War Spire', text = 'Teleport to The Plane of War' },
    warrens = { item = 'King Gragnar\'s Throne', text = 'Teleport to The Warrens' },
    westernwastes = { item = 'Trinket of the Far Frozen Wastes', text = 'Teleport to Western Wastes' },
    -- [X]
    xorbb = { item = 'Painting: Throne of Xorbb', text = 'Teleport to Valley of King Xorbb' },
    -- [Y]
    -- [Z]
    -- [#] 
}

local zoneButtonLabels = {}
local searchBuffer = ""

local function validateportal(item)
    return ground.Search(item)() ~= nil
end

local function sortvalidatedportals()
    for k,_ in pairs(guildclickies) do
        if validateportal(_.item) then
            table.insert(zoneButtonLabels, k)
        end
    end
    table.sort(zoneButtonLabels)
    bValidateComplete = true
end

local function drawGuildClickyUI()
    local bufferSize = 64
    searchBuffer = ImGui.InputText("zone name", searchBuffer, bufferSize)

    local flags = bit32.bor(ImGuiTableFlags.Borders, ImGuiTableFlags.RowBg)
    if ImGui.BeginTable("buttons", 2, flags) then
    ImGui.TableSetupColumn("Zone", ImGuiTableColumnFlags.None, 50)
    ImGui.TableSetupColumn("Command", ImGuiTableColumnFlags.None, 50)
    ImGui.TableHeadersRow()
    for k,_ in ipairs(zoneButtonLabels) do
        local text = zoneButtonLabels[k]
        local bdisplaybutton = false

        if string.len(searchBuffer) > 0 or string.len(searchBuffer) then
            if string.find(zoneButtonLabels[k]:lower(), searchBuffer:lower()) then
                bdisplaybutton = true
            end
        else
            bdisplaybutton = true
        end

        if bdisplaybutton then
            ImGui.PushID(k)
            ImGui.TableNextRow()
            ImGui.TableSetColumnIndex(0)
            ImGui.Text(text)
            if ImGui.IsItemHovered(ImGuiHoveredFlags.DelayNone) then
                if ImGui.BeginTooltip() then
                    ImGui.Text(guildclickies[_].item)
                    ImGui.EndTooltip()
                end
            end
            ImGui.TableSetColumnIndex(1)
            --ImGui.TableHeader("Command")
            local iter = 0
            for key,ui in ipairs(ClickableUIButtons) do
                if iter > 0 then
                    ImGui.SameLine()
                end

                iter = iter + 1
                ImGui.PushStyleColor(ImGuiCol.Button, ClickableUIButtons[key].color)        
                if ImGui.Button(ui.label) then
                    if ui.command == 'x' then
                        mq.cmd('/guildclicky ', zoneButtonLabels[k])
                    else
                        mq.cmd(ui.command, '/guildclicky ', zoneButtonLabels[k])
                    end
                end
                if ImGui.IsItemHovered(ImGuiHoveredFlags.DelayNone) then
                    if ImGui.BeginTooltip() then
                        if ui.command == 'x' then
                            ImGui.Text("%s %s", '/guildclicky', zoneButtonLabels[k])
                        else
                            ImGui.Text("%s %s%s", ui.command, '/guildclicky ', zoneButtonLabels[k])
                        end
                        ImGui.EndTooltip()
                    end
                end
                ImGui.PopStyleColor(1)
            end
            ImGui.PopID()
        end
    end
    ImGui.EndTable()
    end
end

local function GuildClickyUI()
    if bDisplayUI then
        ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 10)
        ImGui.PushStyleVar(ImGuiStyleVar.ScrollbarRounding, 50)
        ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 5)
        bDisplayUI, _ = ImGui.Begin('GuildClicky', true)
        drawGuildClickyUI()
        ImGui.PopStyleVar(3)
        ImGui.End()
    end
end

mq.imgui.init('GuildClickyUI', GuildClickyUI)

local function printMsg(...)
    print(guildclickymsg .. string.format(...))
end

local function validatepath(item)
    return mq.TLO.Navigation.PathExists(string.format("item %s", item))()
end

local function validatemenu(clicky)
    return mq.TLO.Menu.Name() == clicky.item
end

local function validateitemdistance(clicky)
    local distance = mq.TLO.Ground.Search(clicky.item).Distance()
    return (distance and distance <= 21) or false
end

local function interactmenu(clicky)
    -- if the item is within distance, do the thing
    if validateitemdistance(clicky) then
        mq.cmd("/click right item")
        mq.delay(5000, function() return validatemenu(clicky) end)
        mq.cmdf("/squelch /notify \"%s\" menuselect", clicky.text)
    else
        printMsg('We stopped too far away from %s', clicky.item)
        mq.cmdf('/popcustom 18 20 [GuildClicky]\nWe stopped too far away from %s', clicky.item)
    end
end

local function callnav()
    mq.cmd("/nav item")
    -- chillax while we're navigating
    while mq.TLO.Navigation.Active() do
        mq.delay(100)
    end
    mq.delay(100)
end

local function do_guildportal(clicky)
    if not validateportal(clicky.item) then
        printMsg('We could not find %s', clicky.item)
        printMsg(guildclickyhelp)
        return
    end

    if not validatepath(clicky.item) then
        printMsg('We could not find a path to %s', clicky.item)
        printMsg('Please ensure that there is a valid mesh and valid path available')
        return
    end

    -- I sure wish we could do a /itemtarget clear
    mq.cmd("/squelch /target clear")
    mq.delay(100)
    mq.cmdf('/itemtarget "${Ground.Search[%s]}"', clicky.item)
    mq.delay(100)

    if mq.TLO.ItemTarget() == clicky.item then
        callnav()
        interactmenu(clicky)
    end
end

local function help()
    printMsg('\agGuildClicky available options include:')
    local keys = {}
    for k in pairs(guildclickies) do
        if validateportal(k) then
            table.insert(keys, k)
        end
    end

    table.sort(keys)

    for _, key in ipairs(keys) do
        local v = guildclickies[key]
        printMsg('\ao\"/gc %s\" \arto use \ag%s \arto \ao%s', key, v.item, v.text)
    end
end

local function bind_guildclicky(cmd)
    if cmd == nil or cmd == 'help' then
        help()
        return
    end

    if cmd == 'ui' or cmd == 'gui' or cmd == 'show' then
        bDisplayUI = not bDisplayUI
        return
    end

    if guildclickies[cmd] then
        do_guildportal(guildclickies[cmd])
        return
    end

    -- if we didn't return after finding something, or doing help
    -- then that means it was invalid.
    printMsg('\ag%s\ax was \arinvalid.', cmd)
    printMsg(guildclickyhelp)

end

local function insideguildhall()
    return guildhallzonesbyID[mq.TLO.Zone.ID()] == true
end

local function setup()
    mq.bind('/guildclicky', bind_guildclicky)
    mq.bind('/gc', bind_guildclicky)
    printMsg('\aoby \agSic')
    printMsg('This .lua script allows you to use guildhall clickies to port you places.')
    printMsg('You can \ay\"/gc ui\"\ax to show the clickable ui buttons')
    printMsg(guildclickyhelp)
end

local function main()
    while true do
        if insideguildhall() and not bValidateComplete then
            sortvalidatedportals()
        end

        if bDisplayUI and not insideguildhall() then
            bDisplayUI = false
        end
        mq.delay(500)
    end
end

-- set it the bind and such
setup()
-- run the main loop
main()