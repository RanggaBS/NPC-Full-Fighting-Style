---@diagnostic disable: deprecated, lowercase-global

--[[
	NPC Full Fighting Style - Lite v1
	Author: RBS ID
]]

--[[
Features:
- Unique combat taunts
- NPC boss style
- Special moves
- Some will randomly equips a weapon
]]

if gDerpyScriptLoader then DontAutoStartScript() end

-- -------------------------------------------------------------------------- --
-- Global Variable                                                            --
-- -------------------------------------------------------------------------- --

_G.NPC_FULL_FIGHTING_STYLE = {
  Enum = {},
  Config = {},
  PedBehaviors = {},
  Util = {},
}

local Enum = NPC_FULL_FIGHTING_STYLE.Enum
local Util = NPC_FULL_FIGHTING_STYLE.Util

-- -------------------------------------------------------------------------- --
-- Configuration                                                              --
-- -------------------------------------------------------------------------- --

NPC_FULL_FIGHTING_STYLE.Config = {
  BoxerCloseCombatDistance = 2,
  DamonMaxRunThrowDist = 5,
  DamonRunThrowChance = 2,
  DamonRunThrowCooldown = 12000, -- 12 seconds before allowed to running throw again
  DamonRunThrowRandomness = 550,
  DerbyBottleThrow = true,
  DerbyBottleThrowChance = 5,
  DerbyBottleThrowRandomness = 500,
  DerbyMaxCloseCombatDist = 3,
  DerbyMaxEvadeFreq = 100,
  DerbyMinBottleThrowDist = 3.0001,
  DerbyMinEvadeFreq = 60,
  DerbySpecialMoveChance = 5,
  DerbySpecialMoveRandomness = 700,
  DerbySpeechChance = 4,
  DerbySpeechRandomness = 800,
  EarnestMaxProjAttFreq = 100,
  EarnestMaxSpecialAttackPerformed = 1,
  EarnestMinProjAttFreq = 70,
  EarnestMinSpecialAttackDist = 3,
  EarnestSpecialAttackChance = 2,
  EarnestSpecialAttackRandomness = 537,
  EdgarMaxEvadeFreq = 100,
  EdgarMinEvadeFreq = 60,
  EdgarOverhandSwingChance = 3,
  EdgarOverhandSwingRandomness = 250,
  EdgarPipeChance = 6,
  EdgarPipeRandomness = 1400,
  EdgarSpeechChance = 4,
  EdgarSpeechRandomness = 400,
  GaryBrickThrow = true,
  GaryBrickThrowChance = 3,
  GaryBrickThrowRandomness = 480,
  GaryMaxEvadeFreq = 100,
  GaryMinBrickThrowDist = 3,
  GaryMinEvadeFreq = 60,
  JMeleeAMaxShoulderBargeDist = 2,
  JMeleeAShoulderBargeChance = 3,
  JMeleeAShoulderBargeRandomness = 450,
  JohnnyMinThroatgrabDist = 2,
  JohnnyThroatgrabChance = 3,
  JohnnyThroatgrabRandomness = 494,
  MascotMaxSpecialMovesDist = 3,
  MascotSpecialMovesChance = 4,
  MascotSpecialMovesRandomness = 324,
  MascotSpeechChance = 4,
  MascotSpeechRandomness = 400,
  MelvinYardstickChance = 5,
  MelvinYardstickRandomness = 100,
  NMeleeAYardstickChance = 3,
  NMeleeAYardstickRandomness = 800,
  NortonSledgehammerChance = 11,
  NortonSledgehammerRandomness = 1100,
  NortonSpeechChance = 4,
  NortonSpeechRandomness = 800,
  RussellCombatDist = 3,
  RussellSpeechChance = 4,
  RussellSpeechRandomness = 400,
  TedBombThrow = true,
  TedMaxProjAttFreq = 100,
  TedMaxShoulderBargeDist = 2,
  TedMaxThrowCount = 2, -- Max bomb throwed
  TedMinProjAttFreq = 60,
  TedMinThrowDist = 3,
  TedShoulderBargeChance = 2,
  TedShoulderBargeRandomness = 110,
  TedThrowChance = 5,
  TedThrowRandomness = 500,
}
local Config = NPC_FULL_FIGHTING_STYLE.Config

-- -------------------------------------------------------------------------- --
-- Setup                                                                      --
-- -------------------------------------------------------------------------- --

function Setup()
  -- Load animation groups

  local animationGroups = {
    'Ambient',
    'Ambient2',
    'Ambient3',
    'B_Striker',
    'Boxing',
    'DO_Edgar',
    'DO_Grap',
    'DO_StrikeCombo',
    'DO_Striker',
    'Earnest',
    'F_BULLY',
    'F_Crazy',
    'F_Douts',
    'F_Girls',
    'F_Greas',
    'F_Jocks',
    'F_Nerds',
    'F_Preps',
    'G_Grappler',
    'G_Johnny',
    'G_Striker',
    'Grap',
    'J_Damon',
    'J_Grappler',
    'J_Melee',
    'J_Ranged',
    'J_Striker',
    'MINI_React',
    'N2B Dishonerable',
    'NPC_Mascot',
    'N_Ranged',
    'N_Striker',
    'N_Striker_A',
    'N_Striker_B',
    'Nemesis',
    'P_Grappler',
    'P_Striker',
    'Qped',
    'Russell',
    'Russell_Pbomb',
    'Straf_Dout',
    'Straf_Fat',
    'Straf_Female',
    'Straf_Male',
    'Straf_Nerd',
    'Straf_Prep',
    'Straf_Savage',
    'Straf_Wrest',
  }
  for _, animGroup in ipairs(animationGroups) do
    if not HasAnimGroupLoaded(animGroup) then LoadAnimationGroup(animGroup) end
  end

  -- Load action trees

  local actionTrees = {
    'Act/AI/AI_BOXER.act',
    'Act/AI/AI_EDGAR_5_B.act',
    'Act/AI/AI_Gary.act',
    'Act/AI/AI_MASCOT_4_05.act',
    'Act/AI/AI_Norton.act',
    'Act/AI/AI_RUSSEL_1_B.act',
    'Act/Anim/3_05_Norton.act',
    'Act/Anim/BOSS_Darby.act',
    'Act/Anim/BoxingPlayer.act',
    'Act/Anim/DO_Edgar.act',
    'Act/Conv/5_B.act',
  }

  for _, actionTree in ipairs(actionTrees) do
    if not IsActionTreeLoaded(actionTree) then LoadActionTree(actionTree) end
  end

  -- Load sound banks

  SoundLoadBank('MISSION\\1_B.bnk')
end

-- -------------------------------------------------------------------------- --
-- Entry Point                                                                --
-- -------------------------------------------------------------------------- --

function main()
  while not SystemIsReady() or AreaIsLoading() do
    Wait(0)
  end

  Setup()

  local pedBehaviors = NPC_FULL_FIGHTING_STYLE.PedBehaviors
  local model, target, dist

  while true do
    Wait(0)

    for _, ped in ipairs({ PedFindInAreaXYZ(0, 0, 0, 99999) }) do
      if PedIsValid(ped) and ped ~= gPlayer then
        for _, behavior in pairs(pedBehaviors) do
          model = Util.GetPedModelId(ped)
          target = PedGetTargetPed(ped)

          if
            Util.ModelIn(model, behavior.models)
            and (
              type(behavior.missionExclusions) ~= 'table'
              or not Util.IsMissionDisabled(behavior.missionExclusions)
            )
          then
            if PedIsInCombat(ped) and (target ~= -1 and PedIsValid(target)) then
              dist = DistanceBetweenPeds3D(ped, target)
              if behavior.OnCombat then
                behavior.OnCombat(behavior, ped, target, dist)
              end
            else
              if behavior.OnIdle then behavior.OnIdle(behavior, ped) end
            end
          end
        end
      end
    end
  end
end

-- -------------------------------------------------------------------------- --
-- Ped Behaviors                                                              --
-- -------------------------------------------------------------------------- --

---@type table<string, PedBehavior>
NPC_FULL_FIGHTING_STYLE.PedBehaviors = {
  -- ------------------------------------------------------------------------ --
  -- Russell Northrop                                                         --
  -- ------------------------------------------------------------------------ --

  ---@type PedBehavior
  Russell = {
    models = { 75, 176 },
    missionExclusions = { '1_B' },
    bossNode = { '/Global/BOSS_Russell', 'Act/Anim/BOSS_Russell.act' },
    bossAi = { '/Global/RusselAI', 'Act/AI/AI_RUSSEL_1_B.act' },
    normalNode = { '/Global/B_Striker_A', 'Act/Anim/B_Striker_A.act' },
    ---@param self PedBehavior
    ---@param ped integer
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.normalNode[1], self.normalNode[2])
      end
      Util.SetToDefaultAI(ped)
    end,
    ---@param self PedBehavior
    ---@param ped integer
    ---@param target integer
    ---@param dist number
    OnCombat = function(self, ped, target, dist)
      if dist <= Config.RussellCombatDist then
        if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
          Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
        end
        Util.SetPedAI(ped, self.bossAi[1], self.bossAi[2])

        Util.HandleFightingSpeeches(ped)

        if
          not PedMePlaying(ped, 'HitTree')
          and not SoundSpeechPlaying(ped)
          and math.random(Config.RussellSpeechRandomness)
            < Config.RussellSpeechChance
        then
          if math.random(2) == 1 then
            local tauntSpeechIds = { 2, 3, 5, 7 }
            local id = tauntSpeechIds[math.random(table.getn(tauntSpeechIds))]
            SoundPlayScriptedSpeechEvent(ped, 'M_1_B', id, 'large')
          else
            local x, y, z = PedGetPosXYZ(ped)
            local sound = math.random(2) == 1 and 'RUSS_CHARGE' or 'RUSS_ROAR'
            SoundPlay3D(x, y, z, sound)
          end
        end
      -- > dist
      else
        if self.OnIdle then self.OnIdle(self, ped) end
      end
    end,
  },

  -- ------------------------------------------------------------------------ --
  -- Derby Harrington                                                         --
  -- ------------------------------------------------------------------------ --

  ---@type PedBehavior
  Derby = {
    models = { 37, 218 },
    missionExclusions = { '2_B' },
    bossNode = { '/Global/BOSS_Darby', 'Act/Anim/BOSS_Darby.act' },
    bossAi = { '/Global/DarbyAI', 'Act/AI/AI_DARBY_2_B.act' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end
      Util.SetToDefaultAI(ped)

      if PedHasWeapon(ped, Enum.Weapon.Bbagbottle) then
        PedDestroyWeapon(ped, Enum.Weapon.Bbagbottle)
      end
    end,
    OnCombat = function(self, ped, target, dist)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end
      Util.SetPedAI(ped, self.bossAi[1], self.bossAi[2])

      Util.HandleFightingSpeeches(ped)

      -- Special moves
      if
        dist <= Config.DerbyMaxCloseCombatDist
        and PedMePlaying(ped, 'Default_KEY')
        and math.random(Config.DerbySpecialMoveRandomness)
          < Config.DerbySpecialMoveChance
      then
        local nodes = {
          '/Global/BOSS_Darby/Offense/Special/Dash/Dash/Uppercut/ShortDarby',
          '/Global/BOSS_Darby/Defense/Evade/EvadeDuck/HeavyAttacks/EvadeDuckPunch',
          '/Global/BOSS_Darby/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeRightPunch',
          '/Global/BOSS_Darby/Defense/Evade/EvadeRight/HeavyAttacks/EvadeLeftPunch',
        }
        local index = math.random(table.getn(nodes))
        PedSetActionNode(ped, nodes[index], self.bossNode[2])
      end

      -- Bottle throws
      if
        Config.DarbyBottleThrow
        and dist > Config.DerbyMinBottleThrowDist
        and PedMePlaying(ped, 'Default_KEY')
        and math.random(Config.DerbyBottleThrowRandomness)
          <= Config.DerbyBottleThrowChance
      then
        local throwNode = '/Global/BOSS_Darby/Special/Throw'
        PedSetActionNode(ped, throwNode, self.bossNode[2])
      end

      -- "I've had enough of this!" speech
      if
        not PedMePlaying(ped, 'HitTree')
        and not SoundSpeechPlaying(ped)
        and math.random(Config.DerbySpeechRandomness)
          < Config.DerbySpeechChance
      then
        SoundPlayScriptedSpeechEvent(ped, 'M_2_B', 14, 'large')
      end

      -- Ped stat: evade frequency
      if
        GameGetPedStat(ped, Enum.PedStat.EvadeFrequency)
        <= Config.DerbyMinEvadeFreq
      then
        local freq =
          math.random(Config.DerbyMinEvadeFreq, Config.DerbyMaxEvadeFreq)
        PedOverrideStat(ped, Enum.PedStat.EvadeFrequency, freq)
      end

      -- 38	Grap1Reversal (Strikes)
      -- 39 Grap2Reversal (Grapples)
      PedOverrideStat(ped, 38, 50)
      PedOverrideStat(ped, 39, 50)

      if dist <= 2 and Util.IsPedAttacking(target) then
        local evadeFreq = GameGetPedStat(ped, Enum.PedStat.EvadeFrequency) --[[@as number]]
        Util.HandleAutoEvade(ped, evadeFreq)
      end
    end,
  },

  -- ------------------------------------------------------------------------ --
  -- Bif Taylor                                                               --
  -- ------------------------------------------------------------------------ --

  ---@type PedBehavior
  Bif = {
    models = {
      33, -- normal
      133, -- boxing
      172, -- boxing bruised 1
      243, -- boxing bruised 2
    },
    missionExclusions = { '2_09' },
    bossNode = { '/Global/P_Bif', 'Act/Anim/P_Bif.act' },
    bossAi = { '/Global/AI_BOXER', 'Act/AI/AI_BOXER.act' },
    normalNode = { '/Global/P_Striker_A', 'Act/Anim/P_Striker_A.act' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.normalNode[1], self.normalNode[2])
      end
      Util.SetToDefaultAI(ped)
    end,
    OnCombat = function(self, ped, target, dist)
      if dist <= Config.BoxerCloseCombatDistance then
        if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
          Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
        end
        Util.SetPedAI(ped, self.bossAi[1], self.bossAi[2])

        Util.HandleFightingSpeeches(ped) -- bruised boxer can't speak
      else
        self.OnIdle(self, ped)
      end
    end,
  },

  -- ------------------------------------------------------------------------ --
  -- Justin Boxer (P_Striker_B)                                               --
  -- ------------------------------------------------------------------------ --

  JustinBoxer = {
    models = { 118, 244, 245 },
    missionExclusions = {
      '2_R11_Justin',
      '2_R11_Random',
      '3_R09_P3',
    },
    bossNode = { '/Global/P_Bif', 'Act/Anim/P_Bif.act' },
    bossAi = { '/Global/AI_BOXER', 'Act/AI/AI_BOXER.act' },
    normalNode = { '/Global/P_Striker_A', 'Act/Anim/P_Striker_A.act' },
    OnIdle = function(self, ped)
      NPC_FULL_FIGHTING_STYLE.PedBehaviors.Bif.OnIdle(self, ped)
    end,
    OnCombat = function(self, ped, target, dist)
      NPC_FULL_FIGHTING_STYLE.PedBehaviors.Bif.OnCombat(self, ped, target, dist)
    end,
  },

  -- ------------------------------------------------------------------------ --
  -- Parker Boxer (P_Striker_B)                                               --
  -- ------------------------------------------------------------------------ --

  ParkerBoxer = {
    models = { 119, 246, 247 },
    missionExclusions = {
      '2_R11_Parker',
      '2_R11_Random',
      '3_R09_P3',
    },
    bossNode = { '/Global/P_Bif', 'Act/Anim/P_Bif.act' },
    bossAi = { '/Global/AI_BOXER', 'Act/AI/AI_BOXER.act' },
    normalNode = { '/Global/P_Striker_A', 'Act/Anim/P_Striker_A.act' },
    OnIdle = function(self, ped)
      NPC_FULL_FIGHTING_STYLE.PedBehaviors.Bif.OnIdle(self, ped)
    end,
    OnCombat = function(self, ped, target, dist)
      NPC_FULL_FIGHTING_STYLE.PedBehaviors.Bif.OnCombat(self, ped, target, dist)
    end,
  },

  -- ------------------------------------------------------------------------ --
  -- Chad Boxer (P_Grappler_A)                                                --
  -- ------------------------------------------------------------------------ --

  ChadBoxer = {
    models = { 117, 241, 242 },
    missionExclusions = { '2_R11_Chad', '2_R11_Random', '3_R09_P3' },
    bossNode = { '/Global/P_Bif', 'Act/Anim/P_Bif.act' },
    bossAi = { '/Global/AI_BOXER', 'Act/AI/AI_BOXER.act' },
    normalNode = { '/Global/P_Grappler_A', 'Act/Anim/P_Grappler_A.act' },
    OnIdle = function(self, ped)
      NPC_FULL_FIGHTING_STYLE.PedBehaviors.Bif.OnIdle(self, ped)
    end,
    OnCombat = function(self, ped, target, dist)
      NPC_FULL_FIGHTING_STYLE.PedBehaviors.Bif.OnCombat(self, ped, target, dist)
    end,
  },

  -- ------------------------------------------------------------------------ --
  -- Bryce Boxer (P_Grappler_A)                                               --
  -- ------------------------------------------------------------------------ --

  BryceBoxer = {
    models = { 36, 239, 240 },
    missionExclusions = { '2_R11_Bryce', '2_R11_Random', '3_R09_P3' },
    bossNode = { '/Global/P_Bif', 'Act/Anim/P_Bif.act' },
    bossAi = { '/Global/AI_BOXER', 'Act/AI/AI_BOXER.act' },
    normalNode = { '/Global/P_Grappler_A', 'Act/Anim/P_Grappler_A.act' },
    OnIdle = function(self, ped)
      NPC_FULL_FIGHTING_STYLE.PedBehaviors.Bif.OnIdle(self, ped)
    end,
    OnCombat = function(self, ped, target, dist)
      NPC_FULL_FIGHTING_STYLE.PedBehaviors.Bif.OnCombat(self, ped, target, dist)
    end,
  },

  Johnny = {
    models = { 23, 217 },
    missionExclusions = { '3_B', '3_06' },
    bossNode = { '/Global/G_Johnny', 'Act/Anim/G_Johnny.act' },
    bossAi = { '/Global/AI', 'Act/AI/AI.act' },
    normalNode = { '/Global/G_Johnny', 'Act/Anim/G_Johnny.act' },
    OnIdle = nil,
    OnCombat = function(self, ped, target, dist)
      if
        dist <= Config.JohnnyMinThroatgrabDist
        and PedMePlaying(ped, 'Default_KEY')
        and math.random(Config.JohnnyThroatgrabRandomness)
          <= Config.JohnnyThroatgrabChance
      then
        local throatgrabNode =
          '/Global/G_Johnny/Default_KEY/RisingAttacks/HeavyAttacks/RisingAttacks'
        PedSetActionNode(ped, throatgrabNode, self.bossNode[2])
      end
    end,
  },

  Norton = {
    models = { 29, 201 },
    missionExclusions = { '3_05' },
    bossNode = { '/Global/Norton', 'Act/Anim/3_05_Norton.act' },
    bossAi = { '/Global/NortonAI', 'Act/AI/AI_Norton.act' },
    normalNode = { '/Global/G_Grappler_A', 'Act/Anim/G_Grappler_A.act' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.normalNode[1], self.normalNode[2])
      end
      Util.SetToDefaultAI(ped)

      if PedHasWeapon(ped, Enum.Weapon.Sledgehammer) then
        PedDestroyWeapon(ped, Enum.Weapon.Sledgehammer)
      end
    end,
    OnCombat = function(self, ped, target, dist)
      if PedHasWeapon(ped, Enum.Weapon.Sledgehammer) then
        if PedMePlaying(ped, 'Default_KEY') then
          Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
        end
        Util.SetPedAI(ped, self.bossAi[1], self.bossAi[2])

        Util.HandleFightingSpeeches(ped)

        -- "I just love wrecking things with my hammer!" speech
        if
          not PedMePlaying(ped, 'HitTree')
          and not SoundSpeechPlaying(ped)
          and math.random(Config.NortonSpeechRandomness)
            <= Config.NortonSpeechChance
        then
          SoundPlayScriptedSpeechEvent(ped, 'M_3_05', 18, 'large')
        end
      -- If not equipping the hammer
      else
        if PedMePlaying(ped, 'Default_KEY') then
          if PedHasWeapon(ped, -1) then
            Util.SetPedActionTree(ped, self.normalNode[1], self.normalNode[2])
          end

          -- Immediately equip the hammer once reach 10% health
          if PedGetHealth(ped) <= PedGetMaxHealth(ped) * 0.1 then
            PedSetWeaponNow(ped, Enum.Weapon.Sledgehammer)
          -- Randomly equip sledgehammer
          elseif
            math.random(Config.NortonSledgehammerRandomness)
            <= Config.NortonSledgehammerChance
          then
            PedSetWeaponNow(ped, Enum.Weapon.Sledgehammer)
          end
        end

        Util.SetToDefaultAI(ped)
      end
    end,
  },

  Earnest = {
    models = { 10, 215 },
    missionExclusions = { '4_B1' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, Enum.Weapon.Spudgun) then
        PedDestroyWeapon(ped, Enum.Weapon.Spudgun)
      elseif PedHasWeapon(ped, Enum.Weapon.Detonator) then
        PedDestroyWeapon(ped, Enum.Weapon.Detonator)
      end

      -- Reset
      self.specialAttackPerformed = 0
    end,
    OnCombat = function(self, ped, target, dist)
      if type(self.specialAttackPerformed) ~= 'number' then
        self.specialAttackPerformed = 0
      end

      if
        dist >= Config.EarnestMinSpecialAttackDist
        and PedMePlaying(ped, 'Default_KEY')
        and math.random(Config.EarnestSpecialAttackRandomness) <= Config.EarnestSpecialAttackChance
        and self.specialAttackPerformed
          < Config.EarnestMaxSpecialAttackPerformed
      then
        local actions = {
          {
            nodes = {
              '/Global/N_Earnest/Offense/FireSpudGun',
              'Act/Anim/N_Earnest.act',
            },
            loadout = { Enum.Weapon.Spudgun, 50 }, -- weaponid, ammo
          },
          {
            nodes = {
              '/Global/N_Earnest/Offense/ThrowBombs',
              'Act/Anim/N_Earnest.act',
            },
            loadout = { Enum.Weapon.Detonator, 8 },
          },
        }

        local action = actions[math.random(table.getn(actions))]
        local weapon = action.loadout[1]
        local ammo = action.loadout[2]

        PedSetWeaponNow(ped, weapon, ammo)

        -- Force equip weapon (in case of delay)

        local startTime = GetTimer()
        local timeout = 500 -- 500ms
        while not PedHasWeapon(ped, weapon) do
          Wait(0)
          if GetTimer() - startTime > timeout then break end
          PedSetWeaponNow(ped, weapon, ammo)
        end

        PedSetActionNode(ped, action.nodes[1], action.nodes[2])
        Wait(math.random(200, 500))
        SoundPlayScriptedSpeechEvent(ped, 'M_4_B1', math.random(3), 'large')

        -- Increment
        self.specialAttackPerformed = self.specialAttackPerformed + 1
      end
    end,
  },

  Cornelius = {
    models = { 9 },
    OnCombat = function(self, ped, target, dist)
      if
        PedHasWeapon(ped, -1)
        and PedMePlaying(ped, 'Default_KEY')
        and math.random(Config.NMeleeAYardstickRandomness)
          <= Config.NMeleeAYardstickChance
      then
        PedSetWeaponNow(ped, Enum.Weapon.Yardstick)
      end
    end,
  },

  Thad = {
    models = { 7, 174, 210, 224 },
    OnCombat = function(self, ped, target, dist)
      if
        PedHasWeapon(ped, -1)
        and PedMePlaying(ped, 'Default_KEY')
        and math.random(Config.NMeleeAYardstickRandomness)
          <= Config.NMeleeAYardstickChance
      then
        PedSetWeaponNow(ped, Enum.Weapon.Yardstick)
      end
    end,
  },

  Melvin = {
    models = { 6 },
    OnCombat = function(self, ped, target, dist)
      if
        PedHasWeapon(ped, -1)
        and PedMePlaying(ped, 'Default_KEY')
        and math.random(Config.MelvinYardstickRandomness)
          <= Config.MelvinYardstickChance
      then
        PedSetWeaponNow(ped, Enum.Weapon.Yardstick)
      end
    end,
  },

  Ted = {
    models = { 19, 110, 216 },
    missionExclusions = { '4_B2' },
    bossNode = { '/Global/J_Ted', 'Act/Anim/J_Ted.act' },
    bossAi = { '/Global/AI', 'Act/AI/AI.act' },
    normalNode = { '/Global/J_Ted', 'Act/Anim/J_Ted.act' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end

      if PedHasWeapon(ped, Enum.Weapon.Wftbomb) then
        PedDestroyWeapon(ped, Enum.Weapon.Wftbomb)
      end

      -- Reset
      self.bombThrowedCount = 0
    end,
    OnCombat = function(self, ped, target, dist)
      if type(self.bombThrowedCount) ~= 'number' then
        self.bombThrowedCount = 0
      end

      if PedMePlaying(ped, 'Default_KEY') then
        if
          Config.TedBombThrow
          and dist >= Config.TedMinThrowDist
          and not PedHasWeapon(ped, Enum.Weapon.Wftbomb)
          and math.random(Config.TedThrowRandomness) <= Config.TedThrowChance
          and self.bombThrowedCount < Config.TedMaxThrowCount
        then
          PedSetWeaponNow(ped, Enum.Weapon.Wftbomb)
          Wait(math.random(200, 500))
          SoundPlayScriptedSpeechEvent(ped, 'M_4_B2', 4, 'large')

          self.bombThrowedCount = self.bombThrowedCount + 1

        -- Shoulder barge
        elseif
          dist <= Config.TedMaxShoulderBargeDist
          and math.random(Config.TedShoulderBargeRandomness)
            <= Config.TedShoulderBargeChance
        then
          PedSetActionNode(
            ped,
            '/Global/J_Melee_A/Offense/Medium/Strikes/Unblockable',
            'Act/Anim/J_Melee_A.act'
          )
        end
      end
    end,
  },

  Damon = {
    models = { 12, 112, 168, 205 },
    missionExclusions = { '4_B2' },
    OnCombat = function(self, ped, target, dist)
      if not self.lastRunThrow then self.lastRunThrow = GetTimer() end

      if
        PedHasWeapon(ped, -1)
        and PedMePlaying(ped, 'Default_KEY')
        and not PedIsInAnyVehicle(target)
        and dist <= Config.DamonMaxRunThrowDist
        and math.random(Config.DamonRunThrowRandomness) <= Config.DamonRunThrowChance
        and GetTimer() - self.lastRunThrow > Config.DamonRunThrowCooldown
      then
        PedSetActionNode(
          ped,
          '/Global/J_Damon/Offense/SpecialStart/StartRun',
          'Act/Anim/J_Damon.act'
        )
        self.lastRunThrow = GetTimer()
      end
    end,
  },

  Casey = {
    models = { 17, 164, 232 },
    OnCombat = function(self, ped, target, dist)
      if
        dist <= Config.JMeleeAMaxShoulderBargeDist
        and PedMePlaying(ped, 'Default_KEY')
        and math.random(Config.JMeleeAShoulderBargeRandomness)
          <= Config.JMeleeAShoulderBargeChance
      then
        PedSetActionNode(
          ped,
          '/Global/J_Melee_A/Offense/Medium/Strikes/Unblockable',
          'Act/Anim/J_Melee_A.act'
        )
      end
    end,
  },

  Bo = {
    models = { 18, 204, 231 },
    OnCombat = function(self, ped, target, dist)
      if
        PedMePlaying(ped, 'Default_KEY')
        and dist <= Config.JMeleeAMaxShoulderBargeDist
        and math.random(Config.JMeleeAShoulderBargeRandomness)
          <= Config.JMeleeAShoulderBargeChance
      then
        PedSetActionNode(
          ped,
          '/Global/J_Melee_A/Offense/Medium/Strikes/Unblockable',
          'Act/Anim/J_Melee_A.act'
        )
      end
    end,
  },

  Mascot = {
    models = { 88 },
    missionExclusions = { '4_05' },
    bossNode = { '/Global/J_Mascot', 'Act/Anim/J_Mascot.act' },
    bossAi = { '/Global/AI_MASCOT_4_05', 'Act/AI/AI_MASCOT_4_05.act' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end

      Util.SetToDefaultAI(ped)
    end,
    OnCombat = function(self, ped, target, dist)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end
      Util.SetPedAI(ped, self.bossAi[1], self.bossAi[2])

      Util.HandleFightingSpeeches(ped)

      if
        not PedIsInAnyVehicle(target)
        and PedMePlaying(ped, 'Default_KEY')
        and dist <= Config.MascotMaxSpecialMovesDist
        and math.random(Config.MascotSpecialMovesRandomness)
          <= Config.MascotSpecialMovesChance
      then
        local nodes = {
          '/Global/J_Mascot/Offense/Short',
          '/Global/J_Mascot/Offense/Short/Heavy',
          '/Global/J_Mascot/Offense/Short/Heavy/Stunners',
          '/Global/J_Mascot/Offense/Short/Heavy/Stunners/HeadButt',
          '/Global/J_Mascot/Offense/Short/Heavy/Stunners/Sack',
          '/Global/J_Mascot/Offense/Special/Mascot/Mascot/SpecialChoose/Headbutt/Invincible/Headbutt',
        }
        local node = nodes[math.random(table.getn(nodes))]
        PedSetActionNode(ped, node, self.bossNode[2])
      end

      if
        not PedMePlaying(ped, 'HitTree')
        and not SoundSpeechPlaying(ped)
        and math.random(Config.MascotSpeechRandomness)
          < Config.MascotSpeechChance
      then
        local index = math.random(2) == 1 and 50 or 58
        SoundPlayScriptedSpeechEvent(ped, 'M_4_05', index, 'large')
      end
    end,
  },

  Edgar = {
    models = { 91, 196 },
    missionExclusions = { '5_B' },
    bossNode = { '/Global/DO_Edgar', 'Act/Anim/DO_Edgar.act' },
    bossAi = { '/Global/AI_EDGAR_5_B', 'Act/AI/AI_EDGAR_5_B.act' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end
      Util.SetToDefaultAI(ped)

      if PedHasWeapon(ped, Enum.Weapon.Wtrpipe) then
        PedDestroyWeapon(ped, Enum.Weapon.Wtrpipe)
      end

      if
        GameGetPedStat(ped, Enum.PedStat.EvadeFrequency)
        < Config.EdgarMinEvadeFreq
      then
        local freq =
          math.random(Config.EdgarMinEvadeFreq, Config.EdgarMaxEvadeFreq)
        PedOverrideStat(ped, Enum.PedStat.EvadeFrequency, freq)
      end
    end,
    OnCombat = function(self, ped, target, dist)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end

      if PedHasWeapon(ped, Enum.Weapon.Wtrpipe) then
        Util.SetPedAI(ped, self.bossAi[1], self.bossAi[2])
      else
        -- Randomly equip water pipe
        if
          PedMePlaying(ped, 'Default_KEY')
          and math.random(Config.EdgarPipeRandomness)
            <= Config.EdgarPipeChance
        then
          PedSetWeaponNow(ped, Enum.Weapon.Wtrpipe)
        end

        -- If the enemy equips water pipe
        if PedHasWeapon(target, Enum.Weapon.Wtrpipe) then
          Util.SetPedAI(ped, self.bossAi[1], self.bossAi[2])

          if
            not PedMePlaying(ped, 'HitTree')
            and not SoundSpeechPlaying(ped)
            and math.random(Config.EdgarSpeechRandomness)
              <= Config.EdgarSpeechChance
          then
            SoundPlayScriptedSpeechEvent(ped, 'M_5_B', 4, 'large')
          end
        -- If the target is not holding water pipe
        else
          Util.SetToDefaultAI(ped)
        end

        if
          dist <= 3
          and PedMePlaying(ped, 'Default_KEY')
          and math.random(Config.EdgarOverhandSwingRandomness) <= Config.EdgarOverhandSwingChance
          and not PedMePlaying(ped, 'Offense')
        then
          PedSetActionNode(
            ped,
            '/Global/DO_Striker_A/Offense/Medium/HeavyAttacks', -- ...Medium/HeavyAttacks/OverhandSwing
            'Act/Anim/DO_Striker_A.act'
          )
        end
      end

      Util.HandleFightingSpeeches(ped)
    end,
  },

  Gary = {
    models = { 130, 160 },
    missionExclusions = { '6_B' },
    bossNode = { '/Global/Nemesis', 'Act/Anim/Nemesis.act' },
    bossAi = { '/Global/GaryAI', 'Act/AI/AI_Gary.act' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end

      Util.SetToDefaultAI(ped)

      if PedHasWeapon(ped, Enum.Weapon.Brick) then
        PedDestroyWeapon(ped, Enum.Weapon.Brick)
      end
    end,
    OnCombat = function(self, ped, target, dist)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end

      Util.SetPedAI(ped, self.bossAi[1], self.bossAi[2])

      if
        GameGetPedStat(ped, Enum.PedStat.EvadeFrequency)
        < Config.GaryMinEvadeFreq
      then
        local freq =
          math.random(Config.GaryMinEvadeFreq, Config.GaryMaxEvadeFreq)
        PedOverrideStat(ped, Enum.PedStat.EvadeFrequency, freq)
      end

      if
        Config.GaryBrickThrow
        and PedMePlaying(ped, 'Default_KEY')
        and dist >= Config.GaryMinBrickThrowDist
        and math.random(Config.GaryBrickThrowRandomness)
          <= Config.GaryBrickThrowChance
      then
        -- PedSetWeapon(ped, Enum.Weapon.Brick)
        PedSetActionNode(ped, '/Global/Nemesis/Special/Throw', self.bossNode[2])
        Wait(math.random(100, 300))
        SoundPlayScriptedSpeechEvent(ped, 'M_6_B', 15, 'large')
      end

      Util.HandleFightingSpeeches(ped)
    end,
  },

  ---@type PedBehavior
  Fatty = {
    models = { 122 },
    missionExclusions = {
      'C_Wrestling_1',
      'C_Wrestling_2',
      'C_Wrestling_3',
      'C_Wrestling_4',
      'C_Wrestling_5',
    },
    bossNode = { '/Global/J_Grappler_A', 'Act/Anim/J_Grappler_A.act' },
    normalNode = { '/Global/N_Striker_A', 'Act/Anim/N_Striker_A.act' },
    OnIdle = function(self, ped)
      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.normalNode[1], self.normalNode[2])
      end
    end,
    OnCombat = function(self, ped, target, dist)
      local MAX_DIST = 3
      if dist <= MAX_DIST then
        if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
          Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
        end
      else
        if self.OnIdle then self.OnIdle(self, ped) end
      end
    end,
  },

  Bob = {
    models = { 121 },
    bossNode = { '/Global/J_Grappler_A', 'Act/Anim/J_Grappler_A.act' },
    normalNode = { '/Global/J_Grappler_A', 'Act/Anim/J_Grappler_A.act' },
    OnIdle = function(self, ped)
      if PedGetFaction(ped) ~= Enum.Faction.Jock then
        PedSetFaction(ped, Enum.Faction.Jock)
      end

      if PedHasWeapon(ped, -1) and PedMePlaying(ped, 'Default_KEY') then
        Util.SetPedActionTree(ped, self.bossNode[1], self.bossNode[2])
      end
    end,
  },

  Vance = {
    models = { 173 },
    OnIdle = function(self, ped)
      -- Vance's(pirate costume) faction changed to greaser after you beat him
      -- on wrecked ship island
      if
        MiniObjectiveGetIsComplete(16)
        and PedGetFaction(ped) ~= Enum.Faction.Greaser
      then
        PedSetFaction(ped, Enum.Faction.Greaser)
      end
    end,
  },
}

-- -------------------------------------------------------------------------- --
-- Utilities / Helper Functions                                               --
-- -------------------------------------------------------------------------- --

---@param id integer
---@param list integer[]
---@return boolean
function Util.ModelIn(id, list)
  for _, l_id in ipairs(list) do
    if l_id == id then return true end
  end
  return false
end

---@param missions? string[]
---@return boolean
function Util.IsMissionDisabled(missions)
  local specific1, specific2 = MissionActiveSpecific, MissionActiveSpecific2
  for _, mission in ipairs(missions or {}) do
    if specific1(mission) or specific2(mission) then return true end
  end
  return false
end

---@param ped integer
---@return integer|-1
function Util.GetPedModelId(ped)
  for id = 0, 258 do
    if PedIsModel(ped, id) then return id end
  end
  return -1
end

function Util.HandleFightingSpeeches(ped)
  if PedMePlaying(ped, 'HitTree') or SoundSpeechPlaying(ped) then return end
  if math.random(500) > 3 then return end
  SoundPlayAmbientSpeechEvent(ped, 'FIGHTING')
end

---@param ped integer
---@param node string
---@param actFilePath string
function Util.SetPedActionTree(ped, node, actFilePath)
  if PedIsPlaying(ped, node, true) then return end
  PedSetActionTree(ped, node, actFilePath)
end

---@param ped integer
---@return boolean
function Util.IsDefaultAI(ped)
  return PedIsDoingTask(ped, '/Global/AI', true)
end

---@param ped integer
function Util.SetToDefaultAI(ped)
  if Util.IsDefaultAI(ped) then return end
  PedSetAITree(ped, '/Global/AI', 'Act/AI/AI.act')
end

---@param ped integer
---@param node? string
---@param actFilePath? string
function Util.SetPedAI(ped, node, actFilePath)
  node = node or '/Global/AI'
  actFilePath = actFilePath or 'Act/AI/AI.act'
  if PedIsDoingTask(ped, node, true) then return end
  PedSetAITree(ped, node, actFilePath)
end

---@param ped integer
---@param chance number
function Util.HandleAutoEvade(ped, chance)
  if math.random(0, 100) > chance then return end
  if PedMePlaying(ped, 'Evade') or not PedMePlaying(ped, 'Default_KEY') then
    return
  end

  local nodes = {
    { '/Global/P_Bif/Defense/Evade/EvadeRight', 'Act/Anim/P_Bif.act' },
    { '/Global/P_Bif/Defense/Evade/EvadeLeft', 'Act/Anim/P_Bif.act' },
    { '/Global/P_Bif/Defense/Evade/EvadeDuck', 'Act/Anim/P_Bif.act' },
    { '/Global/P_Striker_A/Defense/Evade', 'Act/Anim/P_Striker_A.act' },
    { '/Global/BOSS_Darby/Defense/Evade', 'Act/Anim/BOSS_Darby.act' },
  }
  local node = nodes[math.random(table.getn(nodes))]
  PedSetActionNode(ped, node[1], node[2])
end

---@param ped integer
---@return boolean
function Util.IsPedAttacking(ped)
  if PedMePlaying(ped, 'Offense') or PedMePlaying(ped, 'Attacks') then
    return true
  end

  local nodeTrees = {
    '/Global/BOSS_Darby/Special',
    '/Global/BOSS_Russell/Special',
    '/Global/G_Johnny/Special',
    '/Global/J_Mascot/Special',
    '/Global/Nemesis/Special',
    '/Global/P_Bif/Special',
  }
  for _, nodeTree in ipairs(nodeTrees) do
    if PedIsPlaying(ped, nodeTree, true) then return true end
  end
  return false
end

-- -------------------------------------------------------------------------- --
-- Enumeration                                                                --
-- -------------------------------------------------------------------------- --

-- Faction

Enum.Faction = {
  Jock = 2,
  Greaser = 4,
}

-- Ped stat

Enum.PedStat = {
  ProjectileAttackFrequency = 11,
  EvadeFrequency = 13,
}

-- Weapon

Enum.Weapon = {
  Bbagbottle = 327,
  Brick = 311,
  Detonator = 417,
  Sledgehammer = 324,
  Spudgun = 305,
  Wftbomb = 400,
  Wtrpipe = 342,
  Yardstick = 299,
}

-- -------------------------------------------------------------------------- --
-- Types                                                                      --
-- -------------------------------------------------------------------------- --

---@alias PedBehavior { models: integer[], missionExclusions: string[], bossNode: [string, string], bossAi: [string, string], normalNode: [string, string], OnIdle?: fun(self: PedBehavior, ped: integer), OnCombat?: fun(self: PedBehavior, ped: integer, target: integer, dist: number) }
