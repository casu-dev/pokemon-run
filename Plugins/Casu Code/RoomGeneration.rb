MAP_PICK_POKEMON = { id: 88, name: 'Professor Oak', posx: 10, posy: 11, value: 15 }

MAP_MOVE_RELEARNER = { id: 81, name: 'Move Relearner', posx: 5, posy: 10, value: 10 }
MAP_MART = { id: 48, name: 'Poké Mart', posx: 4, posy: 7, value: 5 }
MAP_CENTER = { id: 77, name: 'Poké Center', posx: 7, posy: 8, value: 0 }

MAP_BOSS_LIST = [
  { id: 86, name: '1st Floor Boss', posx: 10, posy: 13, value: 20 }, # 1st floor
  { id: 95, name: '2nd Floor Boss', posx: 10, posy: 13, value: 20 }, # 2nd floor
  { id: 100, name: '3rd Floor Boss', posx: 9, posy: 17, value: 20 }, # 3rd floor
  { id: 106, name: 'Final Boss', posx: 9, posy: 17, value: 20 } # 4th floor
]
MAP_FIGHT_TRAINER_LIST = [
  { id: 84, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25 }, # 1st floor
  { id: 93, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25 }, # 2nd floor
  { id: 101, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25 }, # 3rd floor
  { id: 107, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25 } # 4th floor
]
MAP_FIGHT_ELITE_TRAINER_LIST = [
  { id: 85, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30 }, # 1st floor
  { id: 96, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30 }, # 2nd floor
  { id: 102, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30 }, # 3rd floor
  { id: 108, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30 } # 4th floor
]
MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST = [
  { id: 87, name: 'Fight a Rocket Grump', posx: 10, posy: 11, value: 35 }, # 1st floor
  { id: 94, name: 'Fight a Rocket Grump', posx: 10, posy: 11, value: 35 }, # 2nd floor
  { id: 99, name: 'Fight a Rocket Grump', posx: 10, posy: 11, value: 35 }, # 3rd floor
  { id: 105, name: 'Fight a Rocket Grump', posx: 10, posy: 11, value: 35 } # 4th floor
]

def pbGenDest
  prev1 = pbGet(29)
  prev2 = pbGet(31)

  room = pbGetPossDest(0, prev1)
  pbSet(29, room)
  pbSet(30, room[:name])
  pbSet(35, room[:value])

  room = pbGetPossDest(1, prev2)
  pbSet(31, room)
  pbSet(32, room[:name])
  pbSet(36, room[:value])

  echoln 'Generated destinations: ' + pbGet(30).to_s + ' | ' + pbGet(32).to_s
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

# 	Clears	Option 1	Option 2
#	0	Trainer	X
#	1	Trainer	Move
#	2	Trainer	Center
#	3	Oak	X
#	4	Trainer	Shop
#	5	Trainer	Shop
#	6	Grunt	X
#	7	Trainer	Move geändert  zu ->  Elite Trainer
#	8	Oak	X
#	9	Trainer	Shop
#	10	Trainer	Elite
#	11	Trainer	Center
#	12	Boss	X
def pbGetPossDest(exit_no, _prev_dest)
  stages_cleared = pbGet(48)
  rooms_cleared = pbGet(49)

  # Forced Rooms
  return MAP_BOSS_LIST[stages_cleared] if rooms_cleared >= 11
  return MAP_PICK_POKEMON if [7, 2].include?(rooms_cleared)
  return MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST[stages_cleared] if rooms_cleared == 5

  # Left is fight trainer
  return MAP_FIGHT_TRAINER_LIST[stages_cleared] if exit_no == 0

  # Right Room
  return MAP_MOVE_RELEARNER if rooms_cleared == 0
  return MAP_CENTER if [1, 10].include?(rooms_cleared)
  return MAP_MART if [3, 4, 8].include?(rooms_cleared)
  return MAP_FIGHT_ELITE_TRAINER_LIST[stages_cleared] if [6, 9].include?(rooms_cleared)
end

def pbGetFightTrainerDest
  MAP_FIGHT_TRAINER_LIST[pbGet(48)]
end
