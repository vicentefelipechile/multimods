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
PropCategories[1] = "Bouyant Props"
PropCategories[2] = "Armor Props"


-----------------------------
----- Weapon Categories -----
-----------------------------
WeaponCategories[1] = "Basic Weapons"

-----------------------------
----------- Props -----------
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
addProp
Props[9] = {Model = "models/Combine_Helicopter/helicopter_bomb01.mdl", Group = 1, Price = 30, Health = 15, DonatorOnly = false, Description = "HeliBomb"}
Props[10] = {Model = "models/props_c17/shelfunit01a.mdl", Group = 1, Price = 180, Health = 90, DonatorOnly = false, Description = "Wooden Shelf 1"}
Props[11] = {Model = "models/props_c17/FurnitureShelf001a.mdl", Group = 1, Price = 200, Health = 100, DonatorOnly = false, Description = "Wooden Shelf 2"}
Props[12] = {Model = "models/props_interiors/Furniture_shelf01a.mdl", Group = 1, Price = 450, Health = 225, DonatorOnly = false, Description = "Wooden Shelf 3"}
Props[13] = {Model = "models/props_c17/Lockers001a.mdl", Group = 2, Price = 700, Health = 350, DonatorOnly = false, Description = "Metal Locker"}
Props[14] = {Model = "models/props_debris/metal_panel02a.mdl", Group = 2, Price = 100, Health = 50, DonatorOnly = false, Description = "Metal Panel 1"}
Props[15] = {Model = "models/props_debris/metal_panel01a.mdl", Group = 2, Price = 200, Health = 100, DonatorOnly = false, Description = "Metal Panel 2"}
Props[16] = {Model = "models/props_c17/canister_propane01a.mdl", Group = 2, Price = 150, Health = 75, DonatorOnly = false, Description = "Gas Canister 1"}
Props[17] = {Model = "models/props_c17/canister01a.mdl", Group = 2, Price = 100, Health = 50, DonatorOnly = false, Description = "Gas Canister 2"}
Props[18] = {Model = "models/props_doors/door03_slotted_left.mdl", Group = 1, Price = 250, Health = 125, DonatorOnly = false, Description = "Door"}
Props[19] = {Model = "models/props_docks/dock03_pole01a_256.mdl", Group = 1, Price = 400, Health = 200, DonatorOnly = false, Description = "Wooden Pole 1"}
Props[20] = {Model = "models/props_docks/dock01_pole01a_128.mdl", Group = 1, Price = 200, Health = 100, DonatorOnly = false, Description = "Wooden Pole 2"}
Props[21] = {Model = "models/props_interiors/BathTub01a.mdl", Group = 2, Price = 800, Health = 400, DonatorOnly = false, Description = "Bathtub"}
Props[22] = {Model = "models/props_interiors/Furniture_Desk01a.mdl", Group = 1, Price = 160, Health = 80, DonatorOnly = false, Description = "Wooden Desk"}
Props[23] = {Model = "models/props_interiors/refrigerator01a.mdl", Group = 2, Price = 600, Health = 300, DonatorOnly = false, Description = "Refrigerator"}
Props[24] = {Model = "models/props_interiors/refrigeratorDoor01a.mdl", Group = 2, Price = 300, Health = 150, DonatorOnly = false, Description = "Refrigerator Door"}
Props[25] = {Model = "models/props_interiors/VendingMachineSoda01a.mdl", Group = 1, Price = 1200, Health = 600, DonatorOnly = false, Description = "Vending Machine"}
Props[26] = {Model = "models/props_interiors/VendingMachineSoda01a_door.mdl", Group = 1, Price = 600, Health = 300, DonatorOnly = false, Description = "Vending Machine Door"}
Props[27] = {Model = "models/props_building_details/Storefront_Template001a_Bars.mdl", Group = 2, Price = 220, Health = 110, DonatorOnly = false, Description = "Window Bars"}
Props[28] = {Model = "models/props_borealis/bluebarrel001.mdl", Group = 1, Price = 50, Health = 25, DonatorOnly = false, Description = "Gravestone"}

-- Weapons
Weapons[1] = {Model = "models/weapons/w_crossbow.mdl", Group = 1, Class = "weapon_crossbow", Name = "Crossbow", Price = 25000, Ammo = 1000, AmmoClass = "XBowBolt", Damage = 10, DonatorOnly = false}
Weapons[2] = {Model = "models/weapons/w_rocket_launcher.mdl", Group = 1, Class = "weapon_rpg", Name = "RPG", Price = 37500, Ammo = 3, AmmoClass = "RPG_Round", Damage = 50, DonatorOnly = false}
Weapons[3] = {Model = "models/weapons/W_357.mdl", Group = 1, Class = "weapon_357", Name = "357 Magnum", Price = 10000, Ammo = 1000, AmmoClass = "357", Damage = 4, DonatorOnly = false}
Weapons[4] = {Model = "models/weapons/w_grenade.mdl", Group = 1, Class = "weapon_frag", Name = "Frag Grenade", Price = 11250, Ammo = 3, AmmoClass = "Grenade", Damage = 15, DonatorOnly = false}
Weapons[6] = {Model = "models/weapons/w_crowbar.mdl", Group = 1, Class = "weapon_crowbar", Name = "Crowbar", Price = 5000, Ammo = 0, AmmoClass = "Pistol", Damage = 20, DonatorOnly = false}
Weapons[7] = {Model = "models/weapons/w_shotgun.mdl", Group = 1, Class = "weapon_shotgun", Name = "Shotgun", Price = 200000, Ammo = 100, AmmoClass = "Buckshot", Damage = 8, DonatorOnly = false}
Weapons[8] = {Model = "models/weapons/w_slam.mdl", Group = 1, Class = "weapon_slam", Name = "SLAM", Price = 12500, Ammo = 2, AmmoClass = "slam", Damage = 25, DonatorOnly = false}
Weapons[9] = {Model = "models/weapons/w_smg1.mdl", Group = 1, Class = "weapon_smg1", Name = "SMG", Price = 250000, Ammo = 500, AmmoClass = "SMG1", Damage = 2, DonatorOnly = false}
Weapons[10] = {Model = "models/weapons/w_irifle.mdl", Group = 1, Class = "weapon_ar2", Name = "AR2", Price = 750000, Ammo = 1000, AmmoClass = "AR2", Damage = 3, DonatorOnly = false}
