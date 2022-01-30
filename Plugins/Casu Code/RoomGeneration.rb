MAP_PICK_POKEMON = [88, 10, 11, 0, 'Professor Oak']

MAP_MOVE_RELEARNER = [81, 10, 11, 0, 'Move Relearner']
MAP_MART = [48, 4, 7, 0, 'Poké Mart']
MAP_CENTER = [77, 7, 8, 0, 'Poké Center']

MAP_BOSS_LIST = [
  [86, 10, 16, 0, 'Stage Boss'],
  [43, 9, 19, 0, 'Stage Boss']
]
MAP_FIGHT_TRAINER_LIST = [
  [84, 10, 11, 0, 'Fight a Trainer'],
  [42, 10, 13, 0, 'Fight a Trainer']
]
MAP_FIGHT_ELITE_TRAINER_LIST = [
  [85, 10, 11, 0, 'Fight an Elite Trainer'], # lvl 16
  [76, 10, 13, 0, 'Fight an Elite Trainer'] # lvl
]
MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST = [
  [87, 10, 11, 0, 'Fight a Rocket Grump'], # lvl 16
  [76, 10, 13, 0, 'Fight a Rocket Grump'] # lvl
]
MAP_FIGHT_TRAINER2_LIST = [
  [93, 10, 11, 0, 'Fight a Trainer'],
  [42, 10, 13, 0, 'Fight a Trainer']
]
def pbGenDest
  prev1 = pbGet(29)
  prev2 = pbGet(31)

  arr = pbGetPossDest(0, prev1)
  res = arr[rand(arr.length)]
  pbSet(29, res)
  pbSet(30, res[4])

  arr = pbGetPossDest(1, prev2)
  res = arr[rand(arr.length)]
  pbSet(31, res)
  pbSet(32, res[4])
end

def pbTransferToDest(dest)
  pbFadeOutIn do
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
  end
end

def pbGetPossDest(exit_no, prev_dest)
  stages_cleared = pbGet(48)
  rooms_cleared = pbGet(49)

  return [MAP_BOSS_LIST[stages_cleared]] if rooms_cleared >= Settings::ROOMS_PER_STAGE

  return [MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST[stages_cleared]] if rooms_cleared == Settings::ROOMS_PER_STAGE / 2

  return [MAP_FIGHT_TRAINER2_LIST[stages_cleared]] if exit_no == 0

  if rooms_cleared == Settings::ROOMS_PER_STAGE / 3 || rooms_cleared == 2 * Settings::ROOMS_PER_STAGE / 3
    return [MAP_PICK_POKEMON]
  end

  [
    MAP_FIGHT_ELITE_TRAINER_LIST[stages_cleared],
    MAP_MART,
    MAP_CENTER,
    MAP_MOVE_RELEARNER
  ].reject { |m| m == prev_dest }
end
