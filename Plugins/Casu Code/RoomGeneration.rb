MAP_PICK_POKEMON = { id: 88, name: 'Professor Oak', posx: 10, posy: 11 }

MAP_MOVE_RELEARNER = { id: 81, name: 'Move Relearner', posx: 10, posy: 11 }
MAP_MART = { id: 48, name: 'Poké Mart', posx: 4, posy: 7 }
MAP_CENTER = { id: 77, name: 'Poké Center', posx: 7, posy: 8 }

MAP_BOSS_LIST = [
  { id: 86, name: '1st Floor Boss', posx: 10, posy: 16 }, # 1st floor
  { id: 95, name: '2nd Floor Boss', posx: 10, posy: 16 } # 2nd floor
]
MAP_FIGHT_TRAINER_LIST = [
  { id: 84, name: 'Fight a Trainer', posx: 10, posy: 11 }, # 1st floor
  { id: 93, name: 'Fight a Trainer', posx: 10, posy: 11 } # 2nd floor
]
MAP_FIGHT_ELITE_TRAINER_LIST = [
  { id: 85, name: 'Fight an Elite Trainer', posx: 10, posy: 11 }, # 1st floor
  { id: 96, name: 'Fight an Elite Trainer', posx: 10, posy: 11 } # 2nd floor
]
MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST = [
  { id: 87, name: 'Fight a Rocket Grump', posx: 10, posy: 11 }, # 1st floor
  { id: 94, name: 'Fight a Rocket Grump', posx: 10, posy: 11 } # 2nd floor
]

def pbGenDest
  prev1 = pbGet(29)
  prev2 = pbGet(31)

  arr = pbGetPossDest(0, prev1)
  room = arr[rand(arr.length)]
  pbSet(29, room)
  pbSet(30, room[:name])

  arr = pbGetPossDest(1, prev2)
  room = arr[rand(arr.length)]
  pbSet(31, room)
  pbSet(32, room[:name])
end

def pbTransferToDest(dest)
  pbFadeOutIn do
    $game_temp.player_new_map_id = 32
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh

    $game_temp.player_new_map_id    = dest[:id]
    $game_temp.player_new_x         = dest[:posx]
    $game_temp.player_new_y         = dest[:posy]
    $game_temp.player_new_direction = 0
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
  end
end

def pbGetPossDest(exit_no, prev_dest)
  stages_cleared = pbGet(48)
  rooms_cleared = pbGet(49)

  # Show boss if all rooms are cleared on both exits
  return [MAP_BOSS_LIST[stages_cleared]] if rooms_cleared >= Settings::ROOMS_PER_STAGE

  # Show middle trainer on both exits
  return [MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST[stages_cleared]] if rooms_cleared == Settings::ROOMS_PER_STAGE / 2

  # Show Oak on both exits
  if rooms_cleared == Settings::ROOMS_PER_STAGE / 3 || rooms_cleared == 2 * Settings::ROOMS_PER_STAGE / 3
    return [MAP_PICK_POKEMON]
  end

  # Left exit is always trainer fight
  return [MAP_FIGHT_TRAINER_LIST[stages_cleared]] if exit_no == 0

  # Right exit without last room
  [
    MAP_FIGHT_ELITE_TRAINER_LIST[stages_cleared],
    MAP_MART,
    MAP_CENTER,
    MAP_MOVE_RELEARNER
  ].reject { |m| m == prev_dest }
end
