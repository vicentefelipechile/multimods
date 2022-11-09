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
-----------  -----------
-----------------------------

local function addProp(model, group, price, health, donator, desc)
    if not desc then return end

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

addProp("models/props_c17/FurnitureTable002a.mdl",          1,  50,  25, false, "Wooden Table")
addProp("models/props_c17/gravestone003a.mdl",              2, 160,  80, false, "Gravestone")
addProp("models/props_c17/oildrum001.mdl",                  2,  60,  30, false, "Oil Drum")
addProp("models/props_c17/concrete_barrier001a.mdl",        2, 150,  75, false, "Concrete Barrier")
addProp("models/props_c17/gravestone_coffinpiece002a.mdl",  2, 160,  80, false, "Coffin Piece")
addProp("models/props_c17/display_cooler01a.mdl",           2, 260, 130, false, "Display Case")
addProp("models/props_c17/bench01a.mdl",                    1,  40,  20, false, "Wooden Bench")
addProp("models/props_c17/FurnitureCouch001a.mdl",          2, 400, 200, false, "Red Couch")
addProp("models/Combine_Helicopter/helicopter_bomb01.mdl"   1,  30,  15, false, "HeliBomb")
addProp("models/props_c17/shelfunit01a.mdl",                1, 180,  90, false, "Wooden Shelf 1")
addProp("models/props_c17/shelfunit01a.mdl",                1, 180,  90, false, "Wooden Shelf 1")
addProp("models/props_c17/FurnitureShelf001a.mdl",          1, 200, 100, false, "Wooden Shelf 2")
addProp("models/props_interiors/Furniture_shelf01a.mdl",    1, 450, 225, false, "Wooden Shelf 3")
addProp("models/props_c17/Lockers001a.mdl",                 2, 700, 350, false, "Metal Locker")
addProp("models/props_debris/metal_panel02a.mdl",           2, 100,  50, false, "Metal Panel 1")
addProp("models/props_debris/metal_panel01a.mdl",           2, 200, 100, false, "Metal Panel 2")
addProp("models/props_c17/canister_propane01a.mdl",         2, 150,  75, false, "Gas Canister 1")
addProp("models/props_c17/canister01a.mdl",                 2, 100,  50, false, "Gas Canister 2")
addProp("models/props_doors/door03_slotted_left.mdl",       1, 250, 125, false, "Door")
addProp("models/props_docks/dock03_pole01a_256.mdl",        1, 400, 200, false, "Wooden Pole 1")
addProp("models/props_docks/dock01_pole01a_128.mdl",        1, 200, 100, false, "Wooden Pole 2")
addProp("models/props_interiors/BathTub01a.mdl",            2, 800, 400, false, "Bathtub")
addProp("models/props_interiors/Furniture_Desk01a.mdl",     1, 160,  80, false, "Wooden Desk")
addProp("models/props_interiors/refrigerator01a.mdl",       2, 600, 300, false, "Refrigerator")
addProp("models/props_interiors/refrigeratorDoor01a.mdl",   2, 300, 150, false, "Refrigerator Door")
addProp("models/props_interiors/VendingMachineSoda01a.mdl", 1,1200, 600, false, "Vending Machine")
addProp("models/props_interiors/VendingMachineSoda01a_door.mdl",            1, 600, 300, false, "Vending Machine Door")
addProp("models/props_building_details/Storefront_Template001a_Bars.mdl",   2, 220, 110, false, "Window Bars")
addProp("models/props_borealis/bluebarrel001.mdl",          1,  50,  25, false, "Gravestone")

-- Weapons
Weapons[1] = {Model = "models/weapons/w_crossbow.mdl", Group = 1, Class = "weapon_crossbow", Name = "Crossbow", 25000, Ammo = 1000, AmmoClass = "XBowBolt", Damage = 10, false}
Weapons[2] = {Model = "models/weapons/w_rocket_launcher.mdl", Group = 1, Class = "weapon_rpg", Name = "RPG", 37500, Ammo = 3, AmmoClass = "RPG_Round", Damage = 50, false}
Weapons[3] = {Model = "models/weapons/W_357.mdl", Group = 1, Class = "weapon_357", Name = "357 Magnum", 10000, Ammo = 1000, AmmoClass = "357", Damage = 4, false}
Weapons[4] = {Model = "models/weapons/w_grenade.mdl", Group = 1, Class = "weapon_frag", Name = "Frag Grenade", 11250, Ammo = 3, AmmoClass = "Grenade", Damage = 15, false}
Weapons[6] = {Model = "models/weapons/w_crowbar.mdl", Group = 1, Class = "weapon_crowbar", Name = "Crowbar", 5000, Ammo = 0, AmmoClass = "Pistol", Damage = 20, false}
Weapons[7] = {Model = "models/weapons/w_shotgun.mdl", Group = 1, Class = "weapon_shotgun", Name = "Shotgun", 200000, Ammo = 100, AmmoClass = "Buckshot", Damage = 8, false}
Weapons[8] = {Model = "models/weapons/w_slam.mdl", Group = 1, Class = "weapon_slam", Name = "SLAM", 12500, Ammo = 2, AmmoClass = "slam", Damage = 25, false}
Weapons[9] = {Model = "models/weapons/w_smg1.mdl", Group = 1, Class = "weapon_smg1", Name = "SMG", 250000, Ammo = 500, AmmoClass = "SMG1", Damage = 2, false}
Weapons[10] = {Model = "models/weapons/w_irifle.mdl", Group = 1, Class = "weapon_ar2", Name = "AR2", 750000, Ammo = 1000, AmmoClass = "AR2", Damage = 3, false}
