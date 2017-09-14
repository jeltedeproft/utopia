-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')
require( "items" )
require( "utility_functions" )

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  PrecacheModel("models/goofygood6/goofygood6.vmdl", context)
  PrecacheItemByNameSync( "item_bag_of_gold", context )
  PrecacheItemByNameSync( "item_bag_of_gold_goofy", context )

  PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_ui.vsndevts", context)

  PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context ) 

  PrecacheItemByNameSync( "item_treasure_chest", context )
  PrecacheModel( "item_treasure_chest", context )

--Cache the creature models
  PrecacheUnitByNameSync( "npc_dota_creature_basic_zombie", context )
      PrecacheModel( "npc_dota_creature_basic_zombie", context )

      PrecacheUnitByNameSync( "npc_dota_creature_berserk_zombie", context )
      PrecacheModel( "npc_dota_creature_berserk_zombie", context )

      PrecacheUnitByNameSync( "npc_dota_treasure_courier", context )
      PrecacheModel( "npc_dota_treasure_courier", context )

  --Cache new particles
      PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
      PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
      PrecacheResource( "particle", "particles/last_hit/last_hit.vpcf", context )
      PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", context )
      PrecacheResource( "particle", "particles/addons_gameplay/player_deferred_light.vpcf", context )
      PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
      PrecacheResource( "particle", "particles/treasure_courier_death.vpcf", context )
      PrecacheResource( "particle", "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", context )
      PrecacheResource( "particle", "particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_dust_cauldron.vpcf", context )
      PrecacheResource( "particle", "particles/newplayer_fx/npx_landslide_debris.vpcf", context )
      
    --Cache particles for traps
      PrecacheResource( "particle_folder", "particles/units/heroes/hero_dragon_knight", context )
      PrecacheResource( "particle_folder", "particles/units/heroes/hero_venomancer", context )
      PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )
      PrecacheResource( "particle_folder", "particles/units/heroes/hero_life_stealer", context )

    --Cache sounds for traps
      PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
      PrecacheResource( "soundfile", "soundevents/soundevents_conquest.vsndevts", context )
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end