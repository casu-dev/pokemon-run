TRAINER_OVERRIDE = [
  # ====== TRAINER =========
  {
    # Trainer F1
    tType: :YOUNGSTER, tName: 'Trainer',
    lvl1: 10, lvl2: 12, numPkmn: 2,
    pkmnPool: getF1StdTrainerPool
  },
  {
    # Trainer F2
    tType: :LASS, tName: 'Trainer',
    lvl1: 25, lvl2: 28, numPkmn: 3,
    pkmnPool: getOak5Merged6
  },
  {
    # Trainer F3
    tType: :COOLTRAINER_F, tName: 'Trainer',
    lvl1: 53, lvl2: 55, numPkmn: 3,
    pkmnPool: getOak8Merged9
  },
  {
    # Trainer F4
    tType: :BIKER, tName: 'Trainer',
    lvl1: 80, lvl2: 85, numPkmn: 4,
    pkmnPool: getOakPool10
  },
  # ====== Elite =========
  {
    # Elite F1
    tType: :GENTLEMAN, tName: 'Elite Trainer',
    lvl1: 13, lvl2: 14, numPkmn: 2,
    pkmnPool: getF1EliteTrainerPool
  },
  {
    # Elite F2
    tType: :LADY, tName: 'Elite Trainer',
    lvl1: 28, lvl2: 29, numPkmn: 3,
    pkmnPool: getOakPool7
  },
  {
    # Elite F3
    tType: :BEAUTY, tName: 'Elite Trainer',
    lvl1: 57, lvl2: 58, numPkmn: 3,
    pkmnPool: getOakPool10
  },
  {
    # Elite F4
    tType: :GAMBLER, tName: 'Elite Trainer',
    lvl1: 89, lvl2: 90, numPkmn: 4,
    pkmnPool: getOakPool11
  },
  # ====== Middle Boss =========
  {
    # Middle Boss F1
    tType: :RIVAL1, tName: 'Gary1',
    lvl1: 12, lvl2: 12, numPkmn: 2,
    pkmnPool: getF1EliteTrainerPool
  },
  {
    # Middle Boss F2
    tType: :RIVAL1, tName: 'Gary2',
    lvl1: 28, lvl2: 28, numPkmn: 3,
    pkmnPool: getOakPool7
  },
  {
    # Middle Boss F3
    tType: :ROCKETBOSS, tName: 'Gary3',
    lvl1: 57, lvl2: 57, numPkmn: 4,
    pkmnPool: getOakPool10
  },
  {
    # Middle Boss F4
    tType: :LEADER_Giovanni, tName: 'Gary4',
    lvl1: 88, lvl2: 88, numPkmn: 4,
    pkmnPool: getOakPool11
  },
  # ====== Rocket Grunt =========
    {
      # Rocket Grunt F1
      tType: :TEAMROCKET_M, tName: 'Rocket Grunt1',
      lvl1: 11, lvl2: 13, numPkmn: 3,
      pkmnPool: getF1StdTrainerPool
    },
    {
      # Rocket Grunt F2
      tType: :TEAMROCKET_M, tName: 'Rocket Grunt2',
      lvl1: 28, lvl2: 30, numPkmn: 3,
      pkmnPool: getOakPool6
    },
    {
      # Rocket Grunt F3
      tType: :TEAMROCKET_M, tName: 'Rocket Grunt3',
      lvl1: 55, lvl2: 57, numPkmn: 3,
      pkmnPool: getOakPool8
    },
    {
      # Rocket Grunt F4
      tType: :TEAMROCKET_M, tName: 'Rocket Grunt4',
      lvl1: 85, lvl2: 87, numPkmn: 3,
      pkmnPool: getOakPool10
    },
]

TRAINER_INTRO_TEXT = [
  ['I was given 5$ to stop you.', 'I just caught these. Let\'s see how strong they are.',
   'Mom said I have to be home before it gets dark.'],
  ['Stop right there!', 'What\'s the hurry?', 'I can\'t let you through.', 'I will not go easy on you!'],
  ['You look weak. This will be easier than i thought.', 'Last chance to turn around.', 'You don\'t stand a chance!'],
  ['First I will finish your Pokémon, then I will finish you.', 'This will not end pretty.',
   'I hope you wrote your testament.', 'Time to smash some Pokémon']
]

Events.onTrainerPartyLoad += proc { |_sender, trainer_list|
  return unless trainer_list

  trainer_list.each do |trainer|
    template = TRAINER_OVERRIDE.find { |i| i[:tType] == trainer.trainer_type and i[:tName] == trainer.name }
    next unless template # Do nothing if no override was found

    # Determin lvl
    lvl = template[:lvl1]
    lvl = template[:lvl2] if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1

    # Generate Party
    newParty = []
    alreadyPicked = []
    while newParty.length < template[:numPkmn]
      pkmnPool = template[:pkmnPool].reject { |p| alreadyPicked.include? p }
      new_species = pkmnPool[rand(pkmnPool.length)]

      alreadyPicked.push(new_species)
      newParty.push(Pokemon.new(new_species, lvl))
    end
    trainer.party = newParty
    echoln 'Generated trainer party: ' + newParty.to_s
  end
}

def pbGenIntroText
  stages_cleared = pbGet(48)
  intro_list = TRAINER_INTRO_TEXT[stages_cleared]
  pbSet(34, intro_list[rand(intro_list.length)])
end

def pbDisplayBossTeam(template, trainerID, trainerName)
  trainer =pbLoadTrainer(trainerID, trainerName, pbGet(37))
  pkmnList = ''
  party = trainer.party.each do |pkmn|
    spec = GameData::Species.try_get(pkmn.species)
    pkmnList += spec.real_name.to_s + ' '
  end  

  msg = ""
  # F1 Boss
  if pkmnList.include? "Mienfoo"
     msg += "Fighting"
  elsif pkmnList.include? "Axew"
        msg += "Dragon"
  elsif pkmnList.include? "Pansear"
          msg += "Fire-Water-Grass"

  # F2 Boss
  elsif pkmnList.include? "Mismagius"
          msg += "Ghost"
  elsif pkmnList.include? "Gardevoir"
          msg += "Fairy"
  elsif pkmnList.include? "Simisear"
          msg += "Fire-Water-Grass"

  # F3 Boss
  elsif pkmnList.include? "Pelipper"
          msg += "Rain"
  elsif pkmnList.include? "Ninetales"
          msg += "Sun"
  elsif pkmnList.include? "Abomasnow"
          msg += "Hail"

  # F4 Boss
  elsif pkmnList.include? "Rayquaza"
          msg += "Mega-Rayquaza"
  elsif pkmnList.include? "Groudon"
          msg += "Primal-Groudon"
  elsif pkmnList.include? "Kyogre"
          msg += "Primal-Kyogre"
  end

  msg = template.gsub("\n", "").gsub("$team", "\\c[10]" + msg + template[0..1])

  pbMessage(msg)
end
