MAP_PICK_POKEMON = [
  [33, 10, 13, 0, "Choose a Pokemon"]
]

MAP_FIGHT_TRAINER = [
  [42, 10, 13, 0, "Fight a Trainer"]
]
MAP_MOVE_RELEARNER = [
  [22, 10, 13, 0, "Move Relearner"]
]
MAP_MART = [
  [48, 4, 7, 0, "Poké Mart"]
]
MAP_CENTER = [
  [77, 7, 8, 0, "Poké Center"]
]

MAP_BOSS = [
  [43, 9, 19, 0, "Stage Boss"]
]
MAP_FIGHT_ELITE_TRAINER = [
  [76, 10, 13, 0, "Fight an Elite Trainer"]
]

def pbGenPokeChoice(lvl = 50)
  pkmn = pbChooseRandomPokemon(
  whiteList=nil,
  blackList="suggested",
  addList=nil,
  base_only=true,
  choose_gen=[1,2,3,4,5])
  
  pbSet(26, pbGetCorrectEvo(pkmn, lvl))
  
  pkmn = pbChooseRandomPokemon(
  whiteList=nil,
  blackList="suggested",
  addList=nil,
  base_only=true,
  choose_gen=[1,2,3,4,5])
  
  pbSet(27, pbGetCorrectEvo(pkmn, lvl))
  
  pkmn = pbChooseRandomPokemon(
  whiteList=nil,
  blackList="suggested",
  addList=nil,
  base_only=true,
  choose_gen=[1,2,3,4,5])
  
  pbSet(28, pbGetCorrectEvo(pkmn, lvl))
end

def pbGenDest
  prev = [pbGet(29), pbGet(31)]
  
  arr = pbGetPossDest(0, prev )
  res = arr[rand(arr.length)]
  pbSet(29, res)
  pbSet(30, res[4])
  
  arr = pbGetPossDest(1, prev )
  res = arr[rand(arr.length)]
  pbSet(31, res)
  pbSet(32, res[4])
end

def pbTransferToDest(dest)
    pbFadeOutIn {
      $game_temp.player_new_map_id = 32
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
      
      $game_temp.player_new_map_id    = dest[0]
      $game_temp.player_new_x         = dest[1]
      $game_temp.player_new_y         = dest[2]
      $game_temp.player_new_direction = dest[3]
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
    }
end

def pbGetPossDest(exit_no, prev_dest)
  stages_cleared = pbGet(48)
  rooms_cleared = pbGet(49)

  if rooms_cleared >= Settings::ROOMS_PER_STAGE
    return [MAP_BOSS[stages_cleared]]
  end

  if rooms_cleared == Settings::ROOMS_PER_STAGE / 2
    return [MAP_FIGHT_ELITE_TRAINER[stages_cleared]]
  end
  
  if exit_no == 0
    return [MAP_FIGHT_TRAINER[stages_cleared]]
  end
  
  if rooms_cleared == Settings::ROOMS_PER_STAGE / 3 || rooms_cleared == 2 * Settings::ROOMS_PER_STAGE / 2
    return [MAP_PICK_POKEMON[stages_cleared]]
  end
  
  return [
    MAP_FIGHT_ELITE_TRAINER[stages_cleared],
    MAP_MART[stages_cleared],
    MAP_CENTER[stages_cleared],
    MAP_MOVE_RELEARNER[stages_cleared]
  ]

end
