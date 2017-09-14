-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')


-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  local children = hero:GetChildren()
  for k,child in pairs(children) do
     if child:GetClassname() == "dota_item_wearable" then
         child:RemoveSelf()
     end
  end

  hero:MoveToPosition( hero:GetAbsOrigin() )
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

  Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self

  self.m_TeamColors = {}
  self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
  self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
  self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --      Pink
  self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --    Orange
  self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --    Blue
  self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --    Green
  self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --    Brown
  self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --    Cyan
  self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --    Olive
  self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --    Purple

  for team = 0, (DOTA_TEAM_COUNT-1) do
    color = self.m_TeamColors[ team ]
    if color then
      SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
    end
  end

  self.m_VictoryMessages = {}
  self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
  self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

  self.m_GatheredShuffledTeams = {}
  self.numSpawnCamps = 5
  self.specialItem = ""
  self.spawnTime = 120
  self.nNextSpawnItemNumber = 1
  self.hasWarnedSpawn = false
  self.allSpawned = false
  self.leadingTeam = -1
  self.runnerupTeam = -1
  self.leadingTeamScore = 0
  self.runnerupTeamScore = 0
  self.isGameTied = true
  self.countdownEnabled = false
  self.itemSpawnIndex = 1
  self.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
  self.tier1ItemBucket = {}
  self.tier2ItemBucket = {}
  self.tier3ItemBucket = {}
  self.tier4ItemBucket = {}

  self.TEAM_KILLS_TO_WIN = 25
  self.CLOSE_TO_VICTORY_THRESHOLD = 5

  self:GatherAndRegisterValidTeams()

  -- Adding Many Players
  if GetMapName() == "desert_quintet" then
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 5 )
    self.m_GoldRadiusMin = 300
    self.m_GoldRadiusMax = 1400
    self.m_GoldDropPercent = 8
    MAX_NUMBER_OF_TEAMS = 3
  elseif GetMapName() == "temple_quartet" then
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 4 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 4 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 4 )
    self.m_GoldRadiusMin = 300
    self.m_GoldRadiusMax = 1400
    self.m_GoldDropPercent = 10
    MAX_NUMBER_OF_TEAMS = 4
  elseif GetMapName() == "mines_trio" then
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3 )
    self.m_GoldRadiusMin = 250
    self.m_GoldRadiusMax = 550
    self.m_GoldDropPercent = 4
    MAX_NUMBER_OF_TEAMS = 3
  elseif GetMapName() == "desert_duo" then
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 2 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 2 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 2 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 2 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 2 )
    self.m_GoldRadiusMin = 250
    self.m_GoldRadiusMax = 550
    self.m_GoldDropPercent = 4
    MAX_NUMBER_OF_TEAMS = 5
  elseif GetMapName() == "forest_solo" then
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_5, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_6, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_7, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_8, 1 )
    self.m_GoldRadiusMin = 250
    self.m_GoldRadiusMax = 550
    self.m_GoldDropPercent = 4
    MAX_NUMBER_OF_TEAMS = 10
  end

  GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
  GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
  GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 0 )
  GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 0 )
  GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 0 )
  GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( GameMode, "BountyRunePickupFilter" ), self )
  GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( GameMode, "ExecuteOrderFilter" ), self )

  --ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameRulesStateChange' ), self )
  --ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
  ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( GameMode, 'OnTeamKillCredit' ), self )
  --ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
  ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( GameMode, "OnItemPickedUp"), self )
  ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( GameMode, "OnNPCGoalReached" ), self )

  GameMode:SetUpFountains()
  GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 

  -- Spawning monsters
  spawncamps = {}
  for i = 1, self.numSpawnCamps do
    local campname = "camp"..i.."_path_customspawn"
    spawncamps[campname] =
    {
      NumberToSpawn = RandomInt(3,5),
      WaypointName = "camp"..i.."_path_wp1"
    }
  end
end


function GameMode:CustomSpawnCamps()
  for name,_ in pairs(spawncamps) do
  spawnunits(name)
  end
end

---------------------------------------------------------------------------
-- Set up fountain regen
---------------------------------------------------------------------------
function GameMode:SetUpFountains()

  LinkLuaModifier( "modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_fountain_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

  local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
  for _,fountainEnt in pairs( fountainEntities ) do
    --print("fountain unit " .. tostring( fountainEnt ) )
    fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
  end
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function GameMode:ColorForTeam( teamID )
  local color = self.m_TeamColors[ teamID ]
  if color == nil then
    color = { 255, 255, 255 } -- default to white
  end
  return color
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
function GameMode:EndGame( victoryTeam )
  local overBoss = Entities:FindByName( nil, "@overboss" )
  if overBoss then
    local celebrate = overBoss:FindAbilityByName( 'dota_ability_celebrate' )
    if celebrate then
      overBoss:CastAbilityNoTarget( celebrate, -1 )
    end
  end

  GameRules:SetGameWinner( victoryTeam )
end


---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function GameMode:UpdatePlayerColor( nPlayerID )
  if not PlayerResource:HasSelectedHero( nPlayerID ) then
    return
  end

  local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
  if hero == nil then
    return
  end

  local teamID = PlayerResource:GetTeam( nPlayerID )
  local color = self:ColorForTeam( teamID )
  PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end


---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function GameMode:UpdateScoreboard()
  local sortedTeams = {}
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
  end

  -- reverse-sort by score
  table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

  for _, t in pairs( sortedTeams ) do
    local clr = self:ColorForTeam( t.teamID )

    -- Scaleform UI Scoreboard
    local score = 
    {
      team_id = t.teamID,
      team_score = t.teamScore
    }
    FireGameEvent( "score_board", score )
  end
  -- Leader effects (moved from OnTeamKillCredit)
  local leader = sortedTeams[1].teamID
  --print("Leader = " .. leader)
  self.leadingTeam = leader
  self.runnerupTeam = sortedTeams[2].teamID
  self.leadingTeamScore = sortedTeams[1].teamScore
  self.runnerupTeamScore = sortedTeams[2].teamScore
  if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
    self.isGameTied = true
  else
    self.isGameTied = false
  end
  local allHeroes = HeroList:GetAllHeroes()
  for _,entity in pairs( allHeroes) do
    if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
      if entity:IsAlive() == true then
        -- Attaching a particle to the leading team heroes
        local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
            if existingParticle == -1 then
              local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
          ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
          entity:Attribute_SetIntValue( "particleID", particleLeader )
        end
      else
        local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
        if particleLeader ~= -1 then
          ParticleManager:DestroyParticle( particleLeader, true )
          entity:DeleteAttribute( "particleID" )
        end
      end
    else
      local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
      if particleLeader ~= -1 then
        ParticleManager:DestroyParticle( particleLeader, true )
        entity:DeleteAttribute( "particleID" )
      end
    end
  end
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function GameMode:OnThink()
  for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
    self:UpdatePlayerColor( nPlayerID )
  end
  
  self:UpdateScoreboard()
  -- Stop thinking if game is paused
  if GameRules:IsGamePaused() == true then
        return 1
    end

  if self.countdownEnabled == true then
    CountdownTimer()
    if nCOUNTDOWNTIMER == 30 then
      CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
    end
    if nCOUNTDOWNTIMER <= 0 then
      --Check to see if there's a tie
      if self.isGameTied == false then
        GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
        GameMode:EndGame( self.leadingTeam )
        self.countdownEnabled = false
      else
        self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
        local broadcast_killcount = 
        {
          killcount = self.TEAM_KILLS_TO_WIN
        }
        CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
      end
        end
  end
  
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    --Spawn Gold Bags
    GameMode:ThinkGoldDrop()
    GameMode:ThinkSpecialItemDrop()
  end

  return 1
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function GameMode:GatherAndRegisterValidTeams()
--  print( "GatherValidTeams:" )

  local foundTeams = {}
  for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
    foundTeams[  playerStart:GetTeam() ] = true
  end

  local numTeams = TableCount(foundTeams)
  print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
  
  local foundTeamsList = {}
  for t, _ in pairs( foundTeams ) do
    table.insert( foundTeamsList, t )
  end

  if numTeams == 0 then
    print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
    table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
    table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
    numTeams = 2
  end

  local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

  self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

  print( "Final shuffled team list:" )
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
  end

  print( "Setting up teams:" )
  for team = 0, (DOTA_TEAM_COUNT-1) do
    local maxPlayers = 0
    if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
      maxPlayers = maxPlayersPerValidTeam
    end
    print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
    GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
  end
end

-- Spawning individual camps
function GameMode:spawncamp(campname)
  spawnunits(campname)
end

-- Simple Custom Spawn
function spawnunits(campname)
  local spawndata = spawncamps[campname]
  local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
    local SpawnLocation = Entities:FindByName( nil, campname )
    local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )
  if SpawnLocation == nil then
    return
  end

    local randomCreature = 
      {
      "basic_zombie",
      "berserk_zombie"
      }
  local r = randomCreature[RandomInt(1,#randomCreature)]
  --print(r)
    for i = 1, NumberToSpawn do
        local creature = CreateUnitByName( "npc_dota_creature_" ..r , SpawnLocation:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
        --print ("Spawning Camps")
        creature:SetInitialGoalEntity( waypointlocation )
    end
end

--------------------------------------------------------------------------------
-- Event: Filter for inventory full
--------------------------------------------------------------------------------
function GameMode:ExecuteOrderFilter( filterTable )
  --[[
  for k, v in pairs( filterTable ) do
    print("EO: " .. k .. " " .. tostring(v) )
  end
  ]]

  local orderType = filterTable["order_type"]
  if ( orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1 ) then
    return true
  else
    local item = EntIndexToHScript( filterTable["entindex_target"] )
    if item == nil then
      return true
    end
    local pickedItem = item:GetContainedItem()
    --print(pickedItem:GetAbilityName())
    if pickedItem == nil then
      return true
    end
    if pickedItem:GetAbilityName() == "item_treasure_chest" then
      local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
      local hero = player:GetAssignedHero()
      if hero:GetNumItemsInInventory() < 6 then
        --print("inventory has space")
        return true
      else
        --print("Moving to target instead")
        local position = item:GetAbsOrigin()
        filterTable["position_x"] = position.x
        filterTable["position_y"] = position.y
        filterTable["position_z"] = position.z
        filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
        return true
      end
    end
  end
  return true
end