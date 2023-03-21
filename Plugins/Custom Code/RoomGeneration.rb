# Room definitions
#MAP_CENTER = { id: 77, name: 'Poké Center', posx: 7, posy: 8, value: 0, weight: -1}
MAP_PICK_POKEMON = { id: 88, name: 'Professor Oak', posx: 10, posy: 10, value: 15, weight: -1, sprite: "phone001"}
MAP_CENTER_WITH_OAK = { id: 112, name: 'Poké Center', posx: 7, posy: 8, value: 15, weight: -1, sprite: "phone001" }

MAP_MOVE_RELEARNER = { id: 81, name: 'Move Relearner', posx: 5, posy: 10, value: 10, weight: 10, sprite: "NPC 06" }
MAP_MART = { id: 48, name: 'Poké Mart', posx: 4, posy: 7, value: 5, weight: 20, sprite: "NPC 19" }
MAP_BLACK_BELT_BROTHERS = { id: 111, name: 'Earn Held Item', posx: 6, posy: 12, value: 40, weight: 10, sprite: "trainer_BLACKBELT" }
MAP_EGG_MOVE_RELEARNER = { id: 109, name: 'Buy Egg-Moves', posx: 10, posy: 14, value: 45, weight: 10, sprite: "trainer_RUINMANIAC" }
MAP_GEMS = { id: 113, name: 'Gem Cave', posx: 10, posy: 11, value: 50, weight: 10, sprite: "skull_2:1" }
MAP_BERRYS = { id: 114, name: 'Berry Granny', posx: 9, posy: 10, value: 55, weight: 10, sprite: "NPC 11" }
MAP_MONEY = { id: 115, name: 'Wishing Well', posx: 10, posy: 11, value: 60, weight: 10, sprite: "skull_2:2" }
MAP_TM_SHOP = { id: 110, name: 'TM Shop', posx: 4, posy: 8, value: 65, weight: 20, sprite: "trainer_SAILOR" }
MAP_STEAL_POKE = { id: 116, name: 'Rocket Hideout', posx: 6, posy: 9, value: 70, weight: 5, sprite: "trainer_TEAMROCKET_M" }
MAP_TRADE_POKE = { id: 121, name: 'Trade Pokémon', posx: 3, posy: 8, value: 75, weight: 10, sprite: "trainer_POKEMONRANGER_F" }
MAP_DAY_CARE = { id: 122, name: 'Day Care', posx: 4, posy: 7, value: 80, weight: 5, sprite: "NPC 10" }
MAP_HIDDEN_TRAIL = { id: 123, name: 'Maximize IVs', posx: 16, posy: 6, value: 85, weight: 5, sprite: "Pokemon 10" }

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
  MAP_STEAL_POKE,
  MAP_TRADE_POKE,
  MAP_DAY_CARE,
  MAP_HIDDEN_TRAIL
]

# Rooms that are different on each floor 
MAP_BOSS_LIST = [
  { id: 86, name: '1st Floor Boss', posx: 10, posy: 14, value: 20, weight: 10, sprite: "trainer_ELITEFOUR_Bruno" }, # 1st floor
  { id: 95, name: '2nd Floor Boss', posx: 10, posy: 14, value: 20, weight: 10, sprite: "trainer_ELITEFOUR_Agatha" }, # 2nd floor
  { id: 100, name: '3rd Floor Boss', posx: 9, posy: 17, value: 20, weight: 10, sprite: "trainer_LEADER_Misty" }, # 3rd floor
  { id: 106, name: 'Final Boss', posx: 9, posy: 17, value: 20, weight: 10, sprite: "trainer_ELITEFOUR_Lance" } # 4th floor
]
MAP_FIGHT_TRAINER_LIST = [
  { id: 84, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10, sprite: "trainer_YOUNGSTER" }, # 1st floor
  { id: 93, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10, sprite: "trainer_LASS" }, # 2nd floor
  { id: 101, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10, sprite: "trainer_COOLTRAINER_F" }, # 3rd floor
  { id: 107, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10, sprite: "trainer_CUEBALL" } # 4th floor
]
MAP_FIGHT_TRAINER_SINGLE_OPTION_LIST = [
  { id: 117, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10, sprite: "trainer_YOUNGSTER" }, # 1st floor
  { id: 118, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10, sprite: "trainer_LASS" }, # 2nd floor
  { id: 119, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10, sprite: "trainer_COOLTRAINER_F" }, # 3rd floor
  { id: 120, name: 'Fight a Trainer', posx: 10, posy: 11, value: 25, weight: 10, sprite: "trainer_CUEBALL" } # 4th floor
]
MAP_FIGHT_ELITE_TRAINER_LIST = [
  { id: 85, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30, weight: 10, sprite: "trainer_GENTLEMAN" }, # 1st floor
  { id: 96, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30, weight: 10, sprite: "trainer_GENTLEMAN" }, # 2nd floor
  { id: 102, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30, weight: 10, sprite: "trainer_GENTLEMAN" }, # 3rd floor
  { id: 108, name: 'Fight an Elite Trainer', posx: 10, posy: 11, value: 30, weight: 10, sprite: "trainer_GENTLEMAN" } # 4th floor
]
MAP_FIGHT_MIDDLE_STAGE_TRAINER_LIST = [
  { id: 87, name: 'Fight Gary', posx: 10, posy: 11, value: 35, weight: 10, sprite: "trainer_RIVAL1" }, # 1st floor
  { id: 94, name: 'Fight Gary', posx: 10, posy: 11, value: 35, weight: 10, sprite: "trainer_RIVAL1" }, # 2nd floor
  { id: 99, name: 'Fight Gary', posx: 10, posy: 11, value: 35, weight: 10, sprite: "trainer_RIVAL1" }, # 3rd floor
  { id: 105, name: 'Fight Gary', posx: 10, posy: 11, value: 35, weight: 10, sprite: "trainer_RIVAL1" } # 4th floor
]

#  First and last event shouldn't be "useless" events. This means the first event of f1 mustn't be Egg-move Tutor or Tm shop (maybe also ban the mart?). And the last event on F4 mustn't be the wishing well event.
MAP_EVENT_AVOID_FIRST = [
  MAP_EGG_MOVE_RELEARNER,
  MAP_TM_SHOP,
  MAP_MART,
  MAP_FIGHT_ELITE_TRAINER_LIST[0]
]

MAP_EVENT_AVOID_LAST = [
  MAP_MONEY
]

MAP_EVENT_AVOID_F1_FIRST_TWO_AND_F4 = [
  MAP_DAY_CARE
]

def isEventRoom(room)
  return true if MAP_EVENT_POOL.include? room
  return true if MAP_FIGHT_ELITE_TRAINER_LIST.include? room
  return false
end

def pbGenDest()
  stages_cleared = pbGet(48)
  rooms_cleared = pbGet(49)

  # load last event rooms as blacklist
  avoidRooms = [pbGet(38),  pbGet(39)]

  # special handling for first and last room and Day Care
  avoidRooms += MAP_EVENT_AVOID_FIRST if rooms_cleared == 0 and stages_cleared == 0
  avoidRooms += MAP_EVENT_AVOID_LAST if rooms_cleared == 10 and stages_cleared == 3
  avoidRooms += MAP_EVENT_AVOID_F1_FIRST_TWO_AND_F4 if ((pbGet(48) == 0 && rooms_cleared < 3) || pbGet(48) == 3)

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
  
  pbSetRoomSprites()
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

def pbSetRoomSprites()
  roomLSprite = pbGet(29)[:sprite]
  roomLIndex = 0
  roomRSprite = pbGet(31)[:sprite]
  roomRIndex = 0

  if(i = roomLSprite.index(':'))
    roomLIndex = roomLSprite[i + 1...i+2].to_i
    roomLSprite = roomLSprite[0...i]
  end

  if(i = roomRSprite.index(':'))
    roomRIndex = roomRSprite[i + 1...i+2].to_i
    roomRSprite = roomRSprite[0...i]
  end

  for event in $game_map.events.values
    if event.name[/ExitLeft/i]
      event.character_name = roomLSprite
      event.pattern = roomLIndex
    end
    if event.name[/ExitRight/i]
      event.character_name = roomRSprite
      event.pattern = roomRIndex
    end
  end
end

#   0   Empty
#	1	Event
#	2	Trainer
#	3	Event
#	4	Trainer
#	5	Oak Center
#	6	Gary
#	7	Event
#	8	Trainer
#	9	Oak
#	10	Trainer
#	11	Event
#	12	Boss
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

