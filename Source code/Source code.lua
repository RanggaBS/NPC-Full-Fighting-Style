--[[
	NPC Full Fighting Style v1.2
	Author: RBS ID
]]

-- Change the value of this variables to true / false. true = enable the exclusive throwing node, false = disable
local garyBricksThrow = true
local darbyBottlesThrow = true
local tedWftbombsThrow = true

--local nortonHP;
--local fattyHP;

function LoadAnims()
	local animGroup, actionTree = {
		--[["Authority",]] "Boxing", "B_Striker", --[["CV_Female", "CV_Male",]] "DO_Edgar", "DO_Grap", "DO_StrikeCombo", "DO_Striker", "Earnest", 
		--[["F_Adult",]] "F_BULLY", "F_Crazy", "F_Douts", "F_Girls", "F_Greas", "F_Jocks", "F_Nerds", --[["F_OldPeds", "F_Pref",]]
		"F_Preps", "G_Grappler", "G_Johnny", "G_Striker", "Grap", "J_Damon", "J_Grappler", "J_Melee", "J_Ranged", "J_Striker", 
		--[["LE_Orderly",]] "Nemesis", "NPC_Mascot", "N_Ranged", "N_Striker", "N_Striker_A", "N_Striker_B", "P_Grappler", "P_Striker", --"PunchBag",
		"Qped", --[["RAT_PED",]] "Russell", "Russell_Pbomb", "Straf_Dout", "Straf_Fat", "Straf_Female", "Straf_Male", "Straf_Nerd", "Straf_Prep", 
		"Straf_Savage", "Straf_Wrest", --[["TE_Female",]] "Ambient", "Ambient2", "Ambient3", "N2B Dishonerable", "MINI_React"
	}, {
		"Act/AI/AI_BOXER.act", "Act/Anim/BoxingPlayer.act", "Act/AI/AI_RUSSEL_1_B.act", "Act/Anim/BOSS_Darby.act", "Act/AI/AI_MASCOT_4_05.act",
		"Act/Anim/DO_Edgar.act", "Act/AI/AI_EDGAR_5_B.act", "Act/Conv/5_B.act", "Act/AI/AI_Gary.act", "Act/AI/AI_Norton.act", "Act/Anim/3_05_Norton.act"
	}
	for i, v in ipairs(animGroup) do
		--if not HasAnimGroupLoaded(v) then
			LoadAnimationGroup(v)
		--end
	end
	for i, v in ipairs(actionTree) do
		LoadActionTree(v)
	end
end

function T_NPC_Full_Fighting_Style()
	while true do
		Wait(0)
		for doi, ped in {PedFindInAreaXYZ(0, 0, 0, 999)} do
			if PedIsValid(ped) and ped ~= gPlayer then

				-- Russell:
				if PedIsModel(ped, 75) or PedIsModel(ped, 176) then
					if not MissionActiveSpecific("1_B") then
						if PedIsInCombat(ped) then
							if DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) >= 3 then
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/B_Striker_A", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
									PedSetActionTree(ped, "/Global/B_Striker_A", "Act/Anim/B_Striker_A.act")
									PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
								end
							else
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/BOSS_Russell", true) and not PedIsDoingTask(ped, "/Global/RusselAI", true) and PedHasWeapon(ped, -1) then
									PedSetActionTree(ped, "/Global/BOSS_Russell", "Act/Anim/BOSS_Russell.act")
									PedSetAITree(ped, "/Global/RusselAI", "Act/AI/AI_RUSSEL_1_B.act")
								end
								FightingSpeech(ped)
								if PedMePlaying(ped, "Default_KEY") and not SoundSpeechPlaying(ped) and math.random(400) < 4 then
									--local russellSpeech = math.random(2)
									--if russellSpeech == 1 then
										local russellSpeechM_1_B = {2, 3, 5, 7--[[2, 8, 10, 12]]}
										SoundPlayScriptedSpeechEvent(ped, "M_1_B", russellSpeechM_1_B[math.random(table.getn(russellSpeechM_1_B))], "large")
									--else
										--SoundPlay3D(PedGetPosXYZ(ped), math.random(2) == 1 and "RUSS_CHARGE" or "RUSS_ROAR")
									--end
								end
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/B_Striker_A", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
								PedSetActionTree(ped, "/Global/B_Striker_A", "Act/Anim/B_Striker_A.act")
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
						end
					end
				end
				
				-- Darby:
				if PedIsModel(ped, 37) or PedIsModel(ped, 218) then
					if not MissionActiveSpecific("2_B") then
						if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/BOSS_Darby", true) and PedHasWeapon(ped, -1) then
							PedSetActionTree(ped, "/Global/BOSS_Darby", "Act/Anim/BOSS_Darby.act")
						end
						if GameGetPedStat(ped, 17) ~= "Generic" then
							PedOverrideStat(ped, 17, "Generic")
						end
						if PedIsInCombat(ped) then
							if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/DarbyAI", true) then
								PedSetAITree(ped, "/Global/DarbyAI", "Act/AI/AI_DARBY_2_B.act")
							end
							if DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) < 3 and PedMePlaying(ped, "Default_KEY") and math.random(450) < 4 then
								local darbyNodes, darbyNodes_rand = {
									{"/Global/BOSS_Darby/Offense/Special/Dash/Dash/Uppercut/ShortDarby", "Act/Anim/BOSS_Darby.act"},
									{"/Global/BOSS_Darby/Defense/Evade/EvadeDuck/HeavyAttacks/EvadeDuckPunch", "Act/Anim/BOSS_Darby.act"},
									{"/Global/BOSS_Darby/Defense/Evade/EvadeLeft/HeavyAttacks/EvadeRightPunch", "Act/Anim/BOSS_Darby.act"},
									{"/Global/BOSS_Darby/Defense/Evade/EvadeRight/HeavyAttacks/EvadeLeftPunch", "Act/Anim/BOSS_Darby.act"}
								}, math.random(4)
								PedSetActionNode(ped, darbyNodes[darbyNodes_rand][1], darbyNodes[darbyNodes_rand][2])
							end
							if darbyBottlesThrow and DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) >= 3 and PedMePlaying(ped, "Default_KEY") and math.random(500) <= 5 then
								PedSetActionNode(ped, "/Global/BOSS_Darby/Special/Throw", "Act/Anim/BOSS_Darby.act")
							end
							FightingSpeech(ped)
							if PedMePlaying(ped, "Default_KEY") and not SoundSpeechPlaying(ped) and math.random(400) < 4 then
								SoundPlayScriptedSpeechEvent(ped, "M_2_B", 14, "large")
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/AI", true) then
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
							if PedHasWeapon(ped, 327) then
								PedDestroyWeapon(ped, 327)
							end
						end
					end
				end

				-- Bif (boxing outfit):
				if PedIsModel(ped, 133) or PedIsModel(ped, 172) or PedIsModel(ped, 243) then
					if not MissionActiveSpecific("2_09") then
						if PedIsInCombat(ped) then
							if DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) <= 2 then
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Bif", true) and not PedIsDoingTask(ped, "/Global/AI_BOXER", true) and PedHasWeapon(ped, -1) then
									PedSetActionTree(ped, "/Global/P_Bif", "Act/Anim/P_Bif.act")
									PedSetAITree(ped, "/Global/AI_BOXER", "Act/AI/AI_BOXER.act")
								end
								FightingSpeech(ped) -- Not working for damaged face boxer
							else
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Striker_A", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
									PedSetActionTree(ped, "/Global/P_Striker_A", "Act/Anim/P_Striker_A.act")
									PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
								end
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Striker_A", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
								PedSetActionTree(ped, "/Global/P_Striker_A", "Act/Anim/P_Striker_A.act")
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
						end
					end
				end
			
				-- Justin & Parker (boxing outfit):
				if PedIsModel(ped, 118) or PedIsModel(ped, 119) or PedIsModel(ped, 244) or PedIsModel(ped, 245) or PedIsModel(ped, 246) or PedIsModel(ped, 247) then
					if not MissionActiveSpecific2("2_R11_Justin") and not MissionActiveSpecific2("2_R11_Parker") and not MissionActiveSpecific2("2_R11_Random") and not MissionActiveSpecific("3_R09_P3") then
						if PedIsInCombat(ped) then
							if DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) <= 2 then
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Bif", true) and not PedIsDoingTask(ped, "/Global/AI_BOXER", true) and PedHasWeapon(ped, -1) then
									PedSetActionTree(ped, "/Global/P_Bif", "Act/Anim/P_Bif.act")
									PedSetAITree(ped, "/Global/AI_BOXER", "Act/AI/AI_BOXER.act")
								end
								FightingSpeech(ped) -- Not working for damaged face boxer
							else
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Striker_B", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
									PedSetActionTree(ped, "/Global/P_Striker_B", "Act/Anim/P_Striker_B.act")
									PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
								end
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Striker_B", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
								PedSetActionTree(ped, "/Global/P_Striker_B", "Act/Anim/P_Striker_B.act")
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
						end
					end
				end
			
				-- Chad & Bryce boxing outfit:
				if PedIsModel(ped, 36) or PedIsModel(ped, 117) or PedIsModel(ped, 239) or PedIsModel(ped, 240) or PedIsModel(ped, 241) or PedIsModel(ped, 242) then
					if not MissionActiveSpecific2("2_R11_Chad") and not MissionActiveSpecific2("2_R11_Bryce") and not MissionActiveSpecific2("2_R11_Random") and not MissionActiveSpecific("3_R09_P3") then
						if PedIsInCombat(ped) then
							if DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) <= 2 then
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Bif", true) and not PedIsDoingTask(ped, "/Global/AI_BOXER", true) and PedHasWeapon(ped, -1) then
									PedSetActionTree(ped, "/Global/P_Bif", "Act/Anim/P_Bif.act")
									PedSetAITree(ped, "/Global/AI_BOXER", "Act/AI/AI_BOXER.act")
								end
								FightingSpeech(ped) -- Not working for damaged face boxer
							else
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Grappler_A", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
									PedSetActionTree(ped, "/Global/P_Grappler_A", "Act/Anim/P_Grappler_A.act")
									PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
								end
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/P_Grappler_A", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
								PedSetActionTree(ped, "/Global/P_Grappler_A", "Act/Anim/P_Grappler_A.act")
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
						end
					end
				end

				-- Johnny:
				if PedIsModel(ped, 23) or PedIsModel(ped, 217) then
					if not MissionActiveSpecific("3_B") and not MissionActiveSpecific("3_06") then
						if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/G_Johnny", true) and PedHasWeapon(ped, -1) then
							PedSetActionTree(ped, "/Global/G_Johnny", "Act/Anim/G_Johnny.act")
						end
						if PedIsInCombat(ped) then
							if DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) <= 2 and PedMePlaying(ped, "Default_KEY") and math.random(494) < 3 then
								PedSetActionNode(ped, "/Global/G_Johnny/Default_KEY/RisingAttacks/HeavyAttacks/RisingAttacks", "Act/Anim/G_Johnny.act")
							end
						end
					end
				end

				-- Norton William:
				if PedIsModel(ped, 29) or PedIsModel(ped, 201) then
					if not MissionActiveSpecific("3_05") then
						if PedIsInCombat(ped) then
							if PedHasWeapon(ped, 324) then
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/Norton", true) and not PedIsDoingTask(ped, "/Global/NortonAI", true) then
									--nortonHP = PedGetHealth(ped)
									--PedSetStatsType(ped, "STAT_3_05_NORTON")
									--PedSetHealth(ped, nortonHP)
									PedSetActionTree(ped, "/Global/Norton", "Act/Anim/3_05_Norton.act")
									PedSetAITree(ped, "/Global/NortonAI", "Act/AI/AI_Norton.act")
								end
								FightingSpeech(ped)
								if PedMePlaying(ped, "Default_KEY") and not SoundSpeechPlaying(ped) and math.random(400) < 4 then
									SoundPlayScriptedSpeechEvent(ped, "M_3_05", 18, "large")
								end
							else
								if PedMePlaying(ped, "Default_KEY") then
									if not PedIsPlaying(ped, "/Global/G_Grappler_A", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
										--nortonHP = PedGetHealth(ped)
										--PedSetStatsType(ped, "STAT_G_GRAPPLER_A")
										--PedSetHealth(ped, nortonHP)
										PedSetActionTree(ped, "/Global/G_Grappler_A", "Act/Anim/G_Grappler_A.act")
										PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
									end
									if math.random(1100) == 99 then
										PedSetWeapon(ped, 324, 1)
									end
								end
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/G_Grappler_A", true) and not PedIsDoingTask(ped, "/Global/AI", true) and PedHasWeapon(ped, -1) then
								--nortonHP = PedGetHealth(ped)
								--PedSetStatsType(ped, "STAT_G_GRAPPLER_A")
								--PedSetHealth(ped, nortonHP)
								PedSetActionTree(ped, "/Global/G_Grappler_A", "Act/Anim/G_Grappler_A.act")
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
							if PedHasWeapon(ped, 324) then
								PedDestroyWeapon(ped, 324)
							end
						end
					end
				end

				-- Earnest Jones:
				if PedIsModel(ped, 10) or PedIsModel(ped, 215) then
					if not MissionActiveSpecific("4_B1") then
						if GameGetPedStat(ped, 11) < 70 then
							PedOverrideStat(ped, 11, math.random(70, 100))
						end
						if PedIsInCombat(ped) then
							if PedMePlaying(ped, "Default_KEY") and DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) > 3 and math.random(309) >= 306 then
								local Action_Earnest, Random_Earnest = {
									{"/Global/N_Earnest/Offense/FireSpudGun", "Act/Anim/N_Earnest.act", {305, 50}},
									{"/Global/N_Earnest/Offense/ThrowBombs", "Act/Anim/N_Earnest.act", {417, 8}}
								}, math.random(2) 
								PedSetWeaponNow(ped, unpack(Action_Earnest[Random_Earnest][3]))
								Wait(200)
								PedSetActionNode(ped, Action_Earnest[Random_Earnest][1], Action_Earnest[Random_Earnest][2])
								Wait(math.random(200, 500))
								SoundPlayScriptedSpeechEvent(ped, "M_4_B1", math.random(3), "large")
							end
						else
							if PedHasWeapon(ped, 305) then
								PedDestroyWeapon(ped, 305)
							elseif PedHasWeapon(ped, 417) then
								PedDestroyWeapon(ped, 417)
							end
						end
					end
				end

				-- Ted:
				if PedIsModel(ped, 19) or PedIsModel(ped, 110) or PedIsModel(ped, 216) then
					if not MissionActiveSpecific("4_B2") then
						if GameGetPedStat(ped, 11) < 60 then
							PedOverrideStat(ped, 11, math.random(60, 100)) -- Projectile frequency
						end
						if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/J_Ted", true) and PedHasWeapon(ped, -1) then
							PedSetActionTree(ped, "/Global/J_Ted", "Act/Anim/J_Ted.act")
						end
						if PedIsInCombat(ped) then
							if PedMePlaying(ped, "Default_KEY") then
								if tedWftbombsThrow and not PedHasWeapon(ped, 400) and DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) > 3 and math.random(500) > 498 then
									PedSetWeapon(ped, 400, 1)
									Wait(math.random(200, 500))
									SoundPlayScriptedSpeechEvent(ped, "M_4_B2", 4, "large")
								elseif DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) <= 1.75 and math.random(110) == 5 then
									PedSetActionNode(ped, "/Global/J_Melee_A/Offense/Medium/Strikes/Unblockable", "Act/Anim/J_Melee_A.act")
								end
							end
						else
							if PedHasWeapon(ped, 400) then
								PedDestroyWeapon(ped, 400)
							end
						end
					end
				end

				-- Damon West:
				if PedIsModel(ped, 12) or PedIsModel(ped, 112) or PedIsModel(ped, 168) or PedIsModel(ped, 205) then
					if not MissionActiveSpecific("4_B2") then
						if PedIsInCombat(ped) then
							if not PedIsInAnyVehicle(PedGetTargetPed(ped)) --[[and PedHasWeapon(ped, -1)]] and DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) < 5 and PedMePlaying(ped, "Default_KEY") and math.random(550) <= 2 then
								PedSetActionNode(ped, "/Global/J_Damon/Offense/SpecialStart/StartRun", "Act/Anim/J_Damon.act")
							end
						end
					end
				end
			
				-- Casey Harris & Bo Jackson
				if PedIsModel(ped, 17) or PedIsModel(ped, 164) or PedIsModel(ped, 232) or PedIsModel(ped, 18) or PedIsModel(ped, 204) or PedIsModel(ped, 231) then
					if PedIsInCombat(ped) then
						if DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) <= 1.75 and PedMePlaying(ped, "Default_KEY") and math.random(450) >= 448 then
							PedSetActionNode(ped, "/Global/J_Melee_A/Offense/Medium/Strikes/Unblockable", "Act/Anim/J_Melee_A.act")
						end
					end
				end
			
				-- Mascot:
				if PedIsModel(ped, 88) then
					if not MissionActiveSpecific("4_05") then
						--if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/J_Mascot", true) and PedHasWeapon(ped, -1) then
							--PedSetActionTree(ped, "/Global/J_Mascot", "Act/Anim/J_Mascot.act")
						--end
						if PedIsInCombat(ped) then
							if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/AI_MASCOT_4_05", true) then
								PedSetAITree(ped, "/Global/AI_MASCOT_4_05", "Act/AI/AI_MASCOT_4_05.act")
							end
							if not PedIsInAnyVehicle(PedGetTargetPed(ped)) and DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) <= 3 and PedMePlaying(ped, "Default_KEY") and math.random(324) < 4 then
								local mascotNodes, mascotNodes_random = {
									{"/Global/J_Mascot/Offense/Special/Mascot/Mascot/SpecialChoose/Headbutt/Invincible/Headbutt", "Act/Anim/J_Mascot.act"},
									{"/Global/J_Mascot/Offense/Short", "Act/Anim/J_Mascot.act"}
								}, math.random(2)
								PedSetActionNode(ped, mascotNodes[mascotNodes_random][1], mascotNodes[mascotNodes_random][2])
							end
							FightingSpeech(ped)
							if PedMePlaying(ped, "Default_KEY") and not SoundSpeechPlaying(ped) and math.random(400) < 4 then
								SoundPlayScriptedSpeechEvent(ped, "M_4_05", math.random(2) == 1 and 50 or 58, "large")
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/AI", true) then
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
						end
					end
				end

				--Edgar:
				if PedIsModel(ped, 91) or PedIsModel(ped, 196) then
					if not MissionActiveSpecific("5_B") then
						if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/DO_Edgar", true) and PedHasWeapon(ped, -1) then
							PedSetActionTree(ped, "/Global/DO_Edgar", "Act/Anim/DO_Edgar.act")
						end
						if GameGetPedStat(ped, 13) < 60 then
							PedOverrideStat(ped, 13, math.random(60, 100))
						end
						if PedIsInCombat(ped) then
							if PedIsDoingTask(ped, "/Global/AI_EDGAR_5_B", true) then
								FightingSpeech(ped)
							end
							if PedHasWeapon(ped, 342) then
								if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/AI_EDGAR_5_B", true) then
									PedSetAITree(ped, "/Global/AI_EDGAR_5_B", "Act/AI/AI_EDGAR_5_B.act")
								end
							else
								if math.random(1682) == 500 then
									PedSetWeapon(ped, 342, 1)
								end
								if PedHasWeapon(PedGetTargetPed(ped), 342) then
									if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/AI_EDGAR_5_B", true) then
										PedSetAITree(ped, "/Global/AI_EDGAR_5_B", "Act/AI/AI_EDGAR_5_B.act")
									elseif PedMePlaying(ped, "Default_KEY") and not SoundSpeechPlaying(ped) and math.random(400) < 4 then
										SoundPlayScriptedSpeechEvent(ped, "M_5_B", 4, "large")
									end
								else
									if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/AI", true) then
										PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
									end
								end
								if PedMePlaying(ped, "Default_KEY") and math.random(250) == 25 then
									PedSetActionNode(ped,"/Global/DO_Striker_A/Offense/Medium/HeavyAttacks","Act/Anim/DO_Striker_A.act")
								end
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/AI", true) then
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
							if PedHasWeapon(ped, 342) then
								PedDestroyWeapon(ped, 342)
							end
						end
					end
				end
				
				-- Gary:
				if PedIsModel(ped, 130) or PedIsModel(ped, 160) then
					if not MissionActiveSpecific("6_B") then
						if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/Nemesis", true) and PedHasWeapon(ped, -1) then
							PedSetActionTree(ped, "/Global/Nemesis", "Act/Anim/Nemesis.act")
						end
						if GameGetPedStat(ped, 11) < 50 then
							PedOverrideStat(ped, 11, math.random(50, 100))
						elseif GameGetPedStat(ped, 13) < 50 then
							PedOverrideStat(ped, 13, math.random(50, 100))
						end
						if PedIsInCombat(ped) then
							if PedMePlaying(ped, "Default_KEY") then
								if garyBricksThrow and DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) >= 3 and math.random(481) <= 3 then
									PedSetActionNode(ped, "/Global/Nemesis/Special/Throw", "Act/Anim/Nemesis.act")
									Wait(math.random(200, 500))
									SoundPlayScriptedSpeechEvent(ped, "M_6_B", 15, "large")
								end
								if not PedIsDoingTask(ped, "/Global/GaryAI", true) then
									PedSetAITree(ped, "/Global/GaryAI", "Act/AI/AI_Gary.act")
								end
								FightingSpeech(ped)
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsDoingTask(ped, "/Global/AI", true) then
								PedSetAITree(ped, "/Global/AI", "Act/AI/AI.act")
							end
							if PedHasWeapon(ped, 311) then
								PedDestroyWeapon(ped, 311)
							end
						end
					end
				end

				-- Fatty (wrestle):
				if PedIsModel(ped, 122) then
					if not MissionActiveSpecific("C_Wrestling_1") and not MissionActiveSpecific("C_Wrestling_2") and not MissionActiveSpecific("C_Wrestling_3") and not MissionActiveSpecific("C_Wrestling_4") and not MissionActiveSpecific("C_Wrestling_5") then
						if PedIsInCombat(ped) then
							if DistanceBetweenPeds2D(ped, PedGetTargetPed(ped)) <= 3 then
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/J_Grappler_A", true) and PedHasWeapon(ped, -1) then
									--fattyHP = PedGetHealth(ped)
									--PedSetStatsType(ped, "STAT_J_GRAPPLER_A")
									--PedSetHealth(ped, fattyHP)
									PedSetActionTree(ped, "/Global/J_Grappler_A", "Act/Anim/J_Grappler_A.act")
								end
							else
								if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/N_Striker_A", true) and PedHasWeapon(ped, -1) then
									--fattyHP = PedGetHealth(ped)
									--PedSetStatsType(ped, "STAT_N_STRIKER_A")
									--PedSetHealth(ped, fattyHP)
									PedSetActionTree(ped, "/Global/N_Striker_A", "Act/Anim/N_Striker_A.act")
								end
							end
						else
							if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/N_Striker_A", true) and PedHasWeapon(ped, -1) then
								--fattyHP = PedGetHealth(ped)
								--PedSetStatsType(ped, "STAT_N_STRIKER_A")
								--PedSetHealth(ped, fattyHP)
								PedSetActionTree(ped, "/Global/N_Striker_A", "Act/Anim/N_Striker_A.act")
							end
						end
					end
				end

				-- Bob:
				if PedIsModel(ped, 121) then
					if PedGetFaction(ped) ~= 2 then
						PedSetFaction(ped, 2)
					end
					if PedMePlaying(ped, "Default_KEY") and not PedIsPlaying(ped, "/Global/J_Grappler_A", true) and PedHasWeapon(ped, -1) then
						PedSetActionTree(ped, "/Global/J_Grappler_A", "Act/Anim/J_Grappler_A.act")
					end
				end

				-- Vance (Pirate costume):
				if PedIsModel(ped, 173) then
					if MiniObjectiveGetIsComplete(16) then -- Vance's(pirate costume) faction changed to greaser after you beat him on wrecked ship island
						if PedGetFaction(ped) ~= 4 then
							PedSetFaction(ped, 4)
						end
					end
				end

			end
		end
	end
end

function FightingSpeech(PED)
	if PedMePlaying(PED, "Default_KEY") and not SoundSpeechPlaying(PED) then
		if PedGetTargetPed(PED) ~= gPlayer and SoundSpeechPlaying(PedGetTargetPed(PED), "FIGHTING") or math.random(400) < 4 then
			SoundPlayAmbientSpeechEvent(PED, math.random(2) == 1 and "FIGHTING" or (math.random(2) == 1 and "LAUGH_CRUEL" or "LAUGH_FRIENDLY"))
		elseif (PlayerIsTaunting(PED) and math.random(6) > 4) or math.random(400) < 4 then
			SoundPlayAmbientSpeechEvent(PED, math.random(2) == 1 and "FIGHTING" or (math.random(2) == 1 and "LAUGH_CRUEL" or "LAUGH_FRIENDLY"))
		end
	end
end

function PlayerIsTaunting(PED)
	if PedGetTargetPed(gPlayer) == PED and (SoundSpeechPlaying(gPlayer, "PLAYER_TAUNT") or SoundSpeechPlaying(gPlayer, "PLAYER_TAUNT_COMBAT") or SoundSpeechPlaying(gPlayer, "PLAYER_TAUNT_COMBAT_SHOVE")) then
		return true
	end
	return false
end

local thread_NPCfFS;
function NPC_Full_Fighting_Style_mod()
	LoadAnims()
	SoundLoadBank("MISSION\\1_B.bnk")
	--ide()
	thread_NPCfFS = CreateThread("T_NPC_Full_Fighting_Style")
end

function main()
	while not SystemIsReady() or AreaIsLoading() do
		Wait(0)
	end
	NPC_Full_Fighting_Style_mod()
	while true do
		Wait(0)
		if F_PlayerIsDead() then
			TerminateThread(thread_NPCfFS)
			thread_NPCfFS = CreateThread("T_NPC_Full_Fighting_Style")
		end
	end
end
--[[
function ide()
	local SetupPed = {
		{10, "NDLead_Earnest", "NDlead_Earnest_W", 0, "Medium", "NERD", "STAT_N_EARNEST", "F_Nerds", "N_Striker", "N_Ranged", "Straf_Nerd", "/Global/N_Earnest", "Act/Anim/N_Earnest.act"}, 
		{19, "JKlead_Ted", "JKlead_Ted_W", 0, "Large", "JOCK", "STAT_J_TED", "F_Jocks", "J_Striker", "null", "null", "/Global/J_Ted", "Act/Anim/J_Ted.act"}, 
		{}
	}
	for num = 1, table.getn(SetupPed) do
		local Data, Texture = SetupPed[num], function()
			if ChapterGet() == 2 then
				return SetupPed[num][3]
			else
				return SetupPed[num][2]
			end
		end
	end
	SetupPedObject(Data[1], Data[2], Texture(), Data[4], Data[5], Data[6], Data[7], Data[8], Data[9], Data[10], Data[11], 1, Data[12], Data[13], "/Global/AI", "Act/AI/AI.act")
end
]]
