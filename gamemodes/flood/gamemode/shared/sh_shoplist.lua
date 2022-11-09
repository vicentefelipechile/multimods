-----------------------------
-------- Core Tables --------
-----------------------------

PropCategories = {}
Props = {}
WeaponCategories = {}
Weapons = {}

-----------------------------
------ Prop categories ------
-----------------------------
PropCategories[1] = "Bouyant "
PropCategories[2] = "Armor "


-----------------------------
----- Weapon Categories -----
-----------------------------
WeaponCategories[1] = "Basic Weapons"

-----------------------------
----------- Props -----------
-----------------------------

local function addProp(model, group, price, health, donator, desc)
    if desc == nil then return end

    local tbl = {
        ["Model"] = model,
        ["Group"] = group,
        ["Price"] = price,
        ["Health"] = health,
        ["DonatorOnly"] = donator,
        ["Description"] = desc
    }
    
    table.insert(Props, tbl)
end

addProp("models/props_c17/FurnitureTable002a.mdl",              1,  50,  25, false, "Wooden Table")
addProp("models/props_c17/gravestone003a.mdl",                  2, 160,  80, false, "Gravestone")
addProp("models/props_c17/oildrum001.mdl",                      2,  60,  30, false, "Oil Drum")
addProp("models/props_c17/concrete_barrier001a.mdl",            2, 150,  75, false, "Concrete Barrier")
addProp("models/props_c17/gravestone_coffinpiece002a.mdl",      2, 160,  80, false, "Coffin Piece")
addProp("models/props_c17/display_cooler01a.mdl",               2, 260, 130, false, "Display Case")
addProp("models/props_c17/bench01a.mdl",                        1,  40,  20, false, "Wooden Bench")
addProp("models/props_c17/FurnitureCouch001a.mdl",              2, 400, 200, false, "Red Couch")
addProp("models/Combine_Helicopter/helicopter_bomb01.mdl",      1,  30,  15, false, "HeliBomb")
addProp("models/props_c17/shelfunit01a.mdl",                    1, 180,  90, false, "Wooden Shelf 1")
addProp("models/props_c17/shelfunit01a.mdl",                    1, 180,  90, false, "Wooden Shelf 1")
addProp("models/props_c17/FurnitureShelf001a.mdl",              1, 200, 100, false, "Wooden Shelf 2")
addProp("models/props_interiors/Furniture_shelf01a.mdl",        1, 450, 225, false, "Wooden Shelf 3")
addProp("models/props_c17/Lockers001a.mdl",                     2, 700, 350, false, "Metal Locker")
addProp("models/props_debris/metal_panel02a.mdl",               2, 100,  50, false, "Metal Panel 1")
addProp("models/props_debris/metal_panel01a.mdl",               2, 200, 100, false, "Metal Panel 2")
addProp("models/props_c17/canister_propane01a.mdl",             2, 150,  75, false, "Gas Canister 1")
addProp("models/props_c17/canister01a.mdl",                     2, 100,  50, false, "Gas Canister 2")
addProp("models/props_doors/door03_slotted_left.mdl",           1, 250, 125, false, "Door")
addProp("models/props_docks/dock03_pole01a_256.mdl",            1, 400, 200, false, "Wooden Pole 1")
addProp("models/props_docks/dock01_pole01a_128.mdl",            1, 200, 100, false, "Wooden Pole 2")
addProp("models/props_interiors/BathTub01a.mdl",                2, 800, 400, false, "Bathtub")
addProp("models/props_interiors/Furniture_Desk01a.mdl",         1, 160,  80, false, "Wooden Desk")
addProp("models/props_interiors/refrigerator01a.mdl",           2, 600, 300, false, "Refrigerator")
addProp("models/props_interiors/refrigeratorDoor01a.mdl",       2, 300, 150, false, "Refrigerator Door")
addProp("models/props_interiors/VendingMachineSoda01a.mdl",     1,1200, 600, false, "Vending Machine")
addProp("models/props_interiors/VendingMachineSoda01a_door.mdl",            1, 600, 300, false, "Vending Machine Door")
addProp("models/props_building_details/Storefront_Template001a_Bars.mdl",   2, 220, 110, false, "Window Bars")
addProp("models/props_borealis/bluebarrel001.mdl",              1,  50,  25, false, "Gravestone")


-----------------------------
---------- Weapons ----------
-----------------------------

local function addWeapon(model, group, class, name, price, ammo, ammoclass, damage, donator)
    if donator == nil then return end

    local tbl = {
        ["Model"] = model,
        ["Group"] = group,
        ["Class"] = class,
        ["Name"] = name,
        ["Price"] = price,
        ["Ammo"] = ammo,
        ["AmmoClass"] = ammoclass,
        ["Damage"] = damage,
        ["DonatorOnly"] = donator
    }
    
    table.insert(Weapons, tbl)
end

--        "Modelo del arma"                     Grupo, "nombre_entidad",    "Nombre Arma", Precio, Ammo, Tipo de Ammo, Daño, Vip?
addWeapon("models/weapons/w_crossbow.mdl",          1, "weapon_crossbow",   "Crossbow",     25000, 1000, "XBowBolt",    10, false)
addWeapon("models/weapons/w_rocket_launcher.mdl",   1, "weapon_rpg",        "RPG",          37500,    3, "RPG_Round",   50, false)
addWeapon("models/weapons/W_357.mdl",               1, "weapon_357",        "357 Magnum",   10000, 1000, "357",          4, false)
addWeapon("models/weapons/w_grenade.mdl",           1, "weapon_frag",       "Frag Grenade", 11250,    3, "Grenade",     15, false)
addWeapon("models/weapons/w_crowbar.mdl",           1, "weapon_crowbar",    "Crowbar",       5000,    0, "Pistol",      20, false)
addWeapon("models/weapons/w_shotgun.mdl",           1, "weapon_shotgun",    "Shotgun",      20000,  100, "Buckshot",     8, false)
addWeapon("models/weapons/w_slam.mdl",              1, "weapon_slam",       "SLAM",         12500,    2, "slam",        25, false)
addWeapon("models/weapons/w_smg1.mdl",              1, "weapon_smg1",       "SMG",         250000,  500, "SMG1",         2, false)
addWeapon("models/weapons/w_irifle.mdl",            1, "weapon_ar2",        "AR2",         750000, 1000, "AR2",          3, false)
