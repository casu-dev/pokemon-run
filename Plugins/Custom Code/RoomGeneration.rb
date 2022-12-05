# Room definitions
#MAP_CENTER = { id: 77, name: 'Poké Center', posx: 7, posy: 8, value: 0, weight: -1}
MAP_PICK_POKEMON = { id: 88, name: 'Professor Oak', posx: 10, posy: 10, value: 15, weight: -1 }
MAP_CENTER_WITH_OAK = { id: 112, name: 'Poké Center', posx: 7, posy: 8, value: 15, weight: -1 }

MAP_MOVE_RELEARNER = { id: 81, name: 'Move Relearner', posx: 5, posy: 10, value: 10, weight: 10 }
MAP_MART = { id: 48, name: 'Poké Mart', posx: 4, posy: 7, value: 5, weight: 20 }
MAP_BLACK_BELT_BROTHERS = { id: 111, name: 'Earn Held Item', posx: 6, posy: 12, value: 40, weight: 10 }
MAP_EGG_MOVE_RELEARNER = { id: 109, name: 'Buy Egg-Moves', posx: 10, posy: 14, value: 45, weight: 10 }
MAP_GEMS = { id: 113, name: 'Gem Cave', posx: 10, posy: 11, value: 50, weight: 10 }
MAP_BERRYS = { id: 114, name: 'Berry Granny', posx: 9, posy: 10, value: 55, weight: 10 }
MAP_MONEY = { id: 115, name: 'Wishing Well', posx: 10, posy: 11, value: 60, weight: 10 }
MAP_TM_SHOP = { id: 110, name: 'TM Shop', posx: 4, posy: 8, value: 65, weight: 20 }
MAP_STEAL_POKE = { id: 116, name: 'Rocket Hideout', posx: 6, posy: 9, value: 70, weight: 5 }

# Pool used for rolling random event
MAP_EVENT_POOL = [
  MAP_MOVE_RELEARNER,
  MAP_MART,
  MAP_BLACK_BELT_BROTHERS,
  MAP_EGG_MOVE_RELEARNER,
  MAP_GEMS,
  MAP_BERRYS,
  MAP_MONEY,
  MAP_TM_SHOP,
  MAP_STEAL_POKE
]

# Rooms that are different on each floor 
MAP_BOSS_LIST = [
  { id: 86, name: '1st Floor Boss', posx: 10, posy: 14, value: 20, weight: 10 }, # 1st floor
  { id: 95, name: '2nd Floor Boss', posx: 10, posy: 14, value: 20, weight: 10 }, # 2nd floor
  { id: 100, name: '3rd Floor Boss', posx: 9, posy: 17, value: 20, weight: 10 }, # 3rd floor
  { id: 106, name: 'Final Boss', posx: 9, posy: 17, value: 20, weight: 10 } # 4th floor
]
MAP_FIGHT_TRAINER_LIST = [
  { id: 84, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10 }, # 1st floor
  { id: 93, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10 }, # 2nd floor
  { id: 101, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10 }, # 3rd floor
  { id: 107, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10 } # 4th floor
]
MAP_FIGHT_TRAINER_SINGLE_OPTION_LIST = [
  { id: 117, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10 }, # 1st floor
  { id: 118, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10 }, # 2nd floor
  { id: 119, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10 }, # 3rd floor
  { id: 120, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10 } # 4th floor
]
MAP_FIGHT_ELITE_TRAINER_LIST = [
  { id: 85, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30, weight: 10 }, # 1st floor
  { id: 96, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30, weight: 10 }, # 2nd floor
  { id: 102, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30, weight: 10 }, # 3rd floor
  { id: 108, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30, weight: 10 } # 4th floor
]
MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST = [
  { id: 87, name: 'Fight Gary', posx: 10, posy: 11, value: 35, weight: 10 }, # 1st floor
  { id: 94, name: 'Fight Gary', posx: 10, posy: 11, value: 35, weight: 10 }, # 2nd floor
  { id: 99, name: 'Fight Gary', posx: 10, posy: 11, value: 35, weight: 10 }, # 3rd floor
  { id: 105, name: 'Fight Gary', posx: 10, posy: 11, value: 35, weight: 10 } # 4th floor
]

def isEventRoom(room)
  return true if MAP_EVENT_POOL.include? room
  return true if MAP_FIGHT_ELITE_TRAINER_LIST.include? room
  return false
end

def pbGenDest()
  # load last event rooms as blacklist
  avoidRooms = [pbGet(38),  pbGet(39)]

  room1 = pbGetPossDest(0, avoidRooms)
  pbSet(29, room1)
  pbSet(30, room1[:name])
  pbSet(35, room1[:value])

  avoidRooms += [room1]

  room2 = pbGetPossDest(1, avoidRooms)
  pbSet(31, room2)
  pbSet(32, room2[:name])
  pbSet(36, room2[:value])

  # Save generated event rooms so we know what to avoid next time
  if isEventRoom(room1) || isEventRoom(room2)
    echoln "The next rooms are event rooms. Remembering it for next time"
    pbSet(38, pbGet(29)) 
    pbSet(39, pbGet(31))
  end

  echoln 'Generated destinations: ' + pbGet(30).to_s + ' | ' + pbGet(32).to_s 
  echoln "Rooms avoided: " + avoidRooms.to_s
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
def pbGetPossDest(exit_no, avoidRooms)
  stages_cleared = pbGet(48)
  rooms_cleared = pbGet(49)

  nextMap = MAP_FIGHT_TRAINER_LIST[stages_cleared]
  nextMap = MAP_FIGHT_TRAINER_SINGLE_OPTION_LIST[stages_cleared] if rooms_cleared == 10 || rooms_cleared == 7 || rooms_cleared == 4 || rooms_cleared == 1
  nextMap = rollEventRoom(avoidRooms) if rooms_cleared % 2 == 0
  nextMap = MAP_CENTER_WITH_OAK if rooms_cleared == 2
  nextMap = MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST[stages_cleared] if rooms_cleared == 5
  nextMap = MAP_PICK_POKEMON if rooms_cleared == 8
  nextMap = MAP_BOSS_LIST[stages_cleared] if rooms_cleared >= 11
  return nextMap
end

def pbGetFightTrainerDest
  MAP_FIGHT_TRAINER_LIST[pbGet(48)]
end


def rollEventRoom(avoidRooms)
  pool = MAP_EVENT_POOL.dup
  pool += [MAP_FIGHT_ELITE_TRAINER_LIST[pbGet(48)]]
  pool -= avoidRooms
  pool = pool.shuffle

  # alogrithm stolen from internet

  sumWeight = pool.inject(0) { |sum, element| sum + element[:weight]}
  echoln 'Pool max weight: ' + sumWeight.to_s
  targetWeight = rand(1..sumWeight)  

  pool.each do |room|
    return room if targetWeight <= room[:weight]
    targetWeight -= room[:weight]
  end
end

