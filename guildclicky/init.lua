--[[
    Created by Sic
        Thanks to the lua peeps, SpecialEd, kaen01, dannuic, knightly, aquietone, brainiac and all the others
        This lua script is inspired by sl968

        I don't know much about lua so yikes might be ahead!
--]]

local mq = require("mq")

local ground = mq.TLO.Ground

local guildclickymsg = '\ao[\agGuildClicky\ao]\ag::\aw'
local guildclickyhelp = 'Please \ay\"/guildclicky \ag(or /gc)\ay help\"\aw for a list of available clickable guild portals.'

-- this is not an exhaustive list and will get expanded
-- please post in the discussion thread for additions
local guildclickies = {
    -- name = { item = '', text = ''},
    umbral =  { item = 'Umbral Plains Scrying Bowl', text = 'Teleport to Umbral Plains'},
    cobalt = { item = 'Skyshrine Dragon Brazier', text = 'Teleport to Cobalt Scar'},
    froststone = { item = 'Froststone Crystal Echo', text = 'Teleport to Froststone'},
    lobby = { item = 'Shabby Lobby Door', text = 'Open the Door to the Lobby'},
    neriak = { item = 'Painting: The Blind Fish', text = 'Teleport to Neriak - Commons'},
    neriakc = { item = 'Painting: Toadstool Tavern', text = 'Teleport to Neriak - Commons'},
    neriak3rd = { item = 'Painting: Maiden\'s Fancy', text = 'Teleport to Neriak - Third Gate'},
    neriakfq = { item = 'Painting: Slugs Tavern', text = 'Teleport to Neriak - Foreign Quarter'},
    health = { item = 'Cynosure of Health', text = 'Teleport to the Plane of Health'},
    halas = { item = 'Placard: Halas', text = 'Teleport to Halas'},
    halas2 = { item = 'Mounted Snake Head', text = 'Teleport to Halas'},
    halas3 = { item = 'Mounted Bear Head', text = 'Teleport to Halas'},
    halas4 = { item = 'Mounted Tiger Head', text = 'Teleport to Halas'},
    surefall = { item = 'Brazier: The Everburning Ruby', text = 'Teleport to Surefall Glade'},
    surefall2 = { item = 'Painting: The Founder', text = 'Teleport to Surefall Glade'},
    swamp = { item = 'Statue: Iksar Head', text = 'Teleport to Swamp of No Hope'},
    oldseb = { item = 'Froglok Head in a Jar', text = 'Teleport to Old Sebilis'},
    eastcab = { item = 'Placard: Tink N Babble', text = 'Teleport to East Cabilis'},
    westcab = { item = 'Brain in a Jar', text = 'Teleport to West Cabilis'},
    trak = { item = 'Emperor Ganak Throne', text = 'Teleport to Trakanon\'s Teeth'},
    trak1 = { item = 'Statue: Iksar Bust', text = 'Teleport to Trakanon\'s Teeth'},
    everfrost = { item = 'Claw Sconce Torch', text = 'Teleport to Everfrost'},
    goro = { item = 'Gorowyn Translocator Lantern', text = 'Teleport to Skyfire Mountains'},
    stratos = { item = 'Stratos Fire Platform', text = 'Teleport to Stratos'},
    nadox = { item = 'Nadox Chandelier', text = 'Teleport to Crypt of Nadox'},
    abysmal = { item = 'The Grozmok Stone', text = 'Teleport to Abysmal Sea'},
    mistmoore = { item = 'Castle of Mistmoore Throne', text = 'Teleport to Castle of Mistmoore'},
    lfaydark = { item = 'Painting: Brownie Encampment', text = 'Teleport to Lesser Faydark'},
    gfaydark = { item = 'Torch of Kelethin', text = 'Teleport to Greater Faydark'},
    steamfont = { item = 'Steamfont Lava Lamp', text = 'Teleport to Steamfont Mountains'},
    steamfont1 = { item = 'Fantastic Fuel Orb', text = 'Teleport to Steamfont Mountains'},
    oot = { item = 'Islander Hammok', text = 'Teleport to Ocean of Tears'},
    highkeep = { item = 'Painting: High Keep Serpent', text = 'Teleport to High Keep'},
    highkeep2 = { item = 'Banner: The Knotted Serpent', text = 'Teleport to High Keep'},
    xorbb = { item = 'Painting: Throne of Xorbb', text = 'Teleport to Valley of King Xorbb'},
    misty = { item = 'Misty Thicket Halfling Bed', text = 'Teleport to Misty Thicket'},
    iceclad = { item = 'Banner: Gnome Pirates', text = 'Teleport to Iceclad Ocean'},
    akanon = { item = 'Shelf of Gnomish Spirits', text = 'Teleport to Ak\'Anon'},
    akanon2 = { item = 'Ak\'Anon Bubble Lamp', text = 'Teleport to Ak\'Anon'},
    frontier = { item = 'Ancient Iksar Translocator Statue', text = 'Teleport to Frontier Mountains'},
    rivervale = { item = 'Rivervale Jumjum Cart', text = 'Teleport to Rivervale'},
    grobb = { item = 'Sign: Gunthak\'s Beltch', text = 'Teleport to Grobb'},
    thurgadin = { item = 'Dwarven Ice Statue', text = 'Teleport to Thurgadin'},
    sanctus = { item = 'Statue: Sanctus Seru', text = 'Teleport to Sanctus Seru'},
    runnyeye = { item = 'Runnyeye Adventurer\'s Head', text = 'Teleport to Liberated Citadel of Runnyeye'},
    kaladim = { item = 'Underfoot Monument', text = 'Teleport to North Kaladim'},
    fury = { item = 'Oceanographer\'s Globe', text = 'Teleport to Hate\'s Fury'},
    nqeynos = { item = 'Coat of Arms: Qeynos', text = 'Teleport to North Qeynos'},
    sqeynos = { item = 'Painting: Lion\'s Mane Tavern', text = 'Teleport to South Qeynos'},
    dulak = { item = 'Painting: Dulak\'s Harbor', text = 'Teleport to Dulak\'s Harbor'},
    war = { item = 'Plane of War Spire', text = 'Teleport to The Plane of War'},
    drunder = { item = 'Painting: Drunder, the Fortress of Zek', text = 'Teleport to Drunder, Fortress of Zek'},
    hole = { item = 'Tattered Cazicite Banner', text = 'Teleport to The Ruins of Old Paineel'},
    stonebrunt = { item = 'Painting: Stonebrunt Mountains', text = 'Teleport to Stonebrunt Mountains'},
    toxx = { item = 'Painting: Toxxulia Forest', text = 'Teleport to Toxxulia Forest'},
    paineel = { item = 'Bookshelf of Paineel', text = 'Teleport to Paineel'},
    erudin = { item = 'Erudin Brazier', text = 'Teleport to Erudin'},
    warrens = { item = 'King Gragnar\'s Throne', text = 'Teleport to The Warrens'},
    shadowhaven = { item = 'Shadow Haven Teleport Pad', text = 'Teleport to Shadow Haven'},
    butcherblock = { item = 'Statue of Brell', text = 'Teleport ot Butcherblock Mountains'},
    oggok = { item = 'Oggok Boulder Lounger', text = 'Teleport to Oggok'},
    growth = { item = 'Painting: Tunare\'s Tree', text = 'Teleport to Plane of Growth'},
    crystalcaverns = { item = 'Painting: Froststone Gate', text = 'Teleport to Crystal Caverns'},
    permafrost = { item = 'Frozen Barbarian Adventurer', text = 'Teleport to Permafrost'},
    innovation = { item = 'Innovative Heli-Lamp', text = 'Teleport of Plane of Innovation'},
    tosk = { item = 'Statue of Toskirakk', text = 'Teleport to Toskirakk'},

}

local function printf(s,...)
    return print(string.format(s,...))
end

local function validateportal(item)
    return ground.Search(item)() ~= nil
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
        printf('%s We stopped too far away from %s', guildclickymsg, clicky.item)
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
        printf('%s We could not find %s', guildclickymsg, clicky.item)
        printf('%s %s', guildclickymsg, guildclickyhelp)
        return
    end

    if not validatepath(clicky.item) then
        printf('%s We could not find a path to %s', guildclickymsg, clicky.item)
        printf('%s Please ensure that there is a valid mesh and valid path available', guildclickymsg)
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
    printf('%s \agGuildClicky available options include:', guildclickymsg)

    for k,_ in pairs(guildclickies) do
        if validateportal(_.item) then
            printf('%s \ao\"/gc %s\" \arto use \ag%s \arto \ao%s', guildclickymsg, k, _.item, _.text)
        end
    end
end

local function bind_guildclicky(cmd)
    if cmd == nil or cmd == 'help' then
        help()
        return
    end

    if guildclickies[cmd] then
        do_guildportal(guildclickies[cmd])
        return
    end

    -- if we didn't return after finding something, or doing help
    -- then that means it was invalid.
    printf('%s \ag%s\ax was \arinvalid.', guildclickymsg, cmd)
    printf('%s %s', guildclickymsg, guildclickyhelp)

end

local function setup()
    mq.bind('/guildclicky', bind_guildclicky)
    mq.bind('/gc', bind_guildclicky)
    printf('%s \aoby \agSic', guildclickymsg)
    printf('%s This .lua script allows you to use guildhall clickies to port you places.', guildclickymsg)
    printf('%s %s', guildclickymsg, guildclickyhelp)
end

local function main()
    while true do
        mq.delay(100)
    end
end

-- set it the bind and such
setup()
-- run the main loop
main()