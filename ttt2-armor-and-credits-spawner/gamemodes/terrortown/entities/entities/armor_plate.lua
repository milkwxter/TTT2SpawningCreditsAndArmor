if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("ttt_base_placeable")

if CLIENT then
    ENT.PrintName = "Armor plate"
end

ENT.Base = "ttt_base_placeable"
ENT.Model = "models/weapons/w_armorplateanim.mdl"

---
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)

    BaseClass.Initialize(self)

    local b = 8

    self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b, b, b))

    if SERVER then
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:SetMass(50)
        end

        self:SetUseType(SIMPLE_USE)
    end
end

local soundPickup = Sound("plate_in.wav")

if SERVER then
    ---
    -- @param Player ply
    -- @realm server
    function ENT:Use(ply)
        -- make sure the guy using the item exists
        if not IsValid(ply) or not ply:IsPlayer() or not ply:IsActive() then return end
		
        -- make sound for feedback
        self:EmitSound(soundPickup)
		
		-- do something for the player
		ply:GiveArmor(20)
		
        -- delete item so he cant use it again
        self:Remove()
    end
else
    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local key_params = {
        usekey = Key("+use", "USE"),
        walkkey = Key("+walk", "WALK"),
    }

    ---
    -- Hook that is called if a player uses their use key while focusing on the entity.
    -- Early check if client can use the item
    -- @return bool True to prevent pickup
    -- @realm client
    function ENT:ClientUse()
        local client = LocalPlayer()

        if not IsValid(client) or not client:IsPlayer() or not client:IsActive() then
            return true
        end
    end

    -- handle looking at item
    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDArmorPlate", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not IsValid(client)
            or not client:IsTerror()
            or not client:Alive()
            or not IsValid(ent)
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "armor_plate"
        then
            return
        end

        -- enable targetID rendering
        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(TryT(ent.PrintName))
        tData:SetSubtitle("Press [E] to pick up the armor plate.")

        tData:AddDescriptionLine("Armor reduces incoming damage, and can become reinforced if you find enough.")
    end)
end