def pbGetTRAINER_OVERRIDE
 return [
  # ====== TRAINER =========
  {
    # Trainer F1
    tType: :YOUNGSTER, tName: 'Trainer',
    lvl1: pbGetLvTrainer, lvl2: pbGetLvTrainer, numPkmn: 2,
    pkmnPool: getF1StdTrainerPool,
    LoseText: "..."
  },
  {
    # Trainer F2
    tType: :LASS, tName: 'Trainer',
    lvl1: pbGetLvTrainer, lvl2: pbGetLvTrainer, numPkmn: 3,
    pkmnPool: getOak5Merged6,
    LoseText: "..."
  },
  {
    # Trainer F3
    tType: :COOLTRAINER_F, tName: 'Trainer',
    lvl1: pbGetLvTrainer, lvl2: pbGetLvTrainer, numPkmn: 3,
    pkmnPool: getOak8Merged9,
    LoseText: "..."
  },
  {
    # Trainer F4
    tType: :BIKER, tName: 'Trainer',
    lvl1: pbGetLvTrainer, lvl2: pbGetLvTrainer, numPkmn: 4,
    pkmnPool: getOakPool10,
    LoseText: "..."
  },
  # ====== Elite =========
  {
    # Elite F1
    tType: :GENTLEMAN, tName: 'Elite Trainer',
    lvl1: pbGetLvElite, lvl2: pbGetLvElite, numPkmn: 2,
    pkmnPool: getF1EliteTrainerPool,
    LoseText: "..."
  },
  {
    # Elite F2
    tType: :LADY, tName: 'Elite Trainer',
    lvl1: pbGetLvElite, lvl2: pbGetLvElite, numPkmn: 3,
    pkmnPool: getOakPool7,
    LoseText: "..."
  },
  {
    # Elite F3
    tType: :BEAUTY, tName: 'Elite Trainer',
    lvl1: pbGetLvElite, lvl2: pbGetLvElite, numPkmn: 3,
    pkmnPool: getOakPool10,
    LoseText: "..."
  },
  {
    # Elite F4
    tType: :GAMBLER, tName: 'Elite Trainer',
    lvl1: pbGetLvElite, lvl2: pbGetLvElite, numPkmn: 4,
    pkmnPool: getOakPool11,
    LoseText: "..."
  },
  # ====== Middle Boss =========
  {
    # Middle Boss F1
    tType: :RIVAL1, tName: 'Gary',
    lvl1: pbGetLvMiddle, lvl2: pbGetLvMiddle, numPkmn: 2,
    pkmnPool: getF1EliteTrainerPool,
    LoseText: "I will get you next time!"
  },
  {
    # Middle Boss F2
    tType: :RIVAL1, tName: 'Gary',
    lvl1: pbGetLvMiddle, lvl2: pbGetLvMiddle, numPkmn: 3,
    pkmnPool: getOakPool7,
    LoseText: "You didn't have to win so convincingly!"
  },
  {
    # Middle Boss F3
    tType: :RIVAL1, tName: 'Gary',
    lvl1: pbGetLvMiddle, lvl2: pbGetLvMiddle, numPkmn: 4,
    pkmnPool: getOakPool10,
    LoseText: "Aw man..."
  },
  {
    # Middle Boss F4
    tType: :RIVAL1, tName: 'Gary',
    lvl1: pbGetLvMiddle, lvl2: pbGetLvMiddle, numPkmn: 4,
    pkmnPool: getOakPool11,
    LoseText: "I'm never lucky..."
  },
  # ====== Rocket Grunt (Steal Trainer) =========
    {
      # Rocket Grunt F1
      tType: :TEAMROCKET_M, tName: 'Grunt',
      lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
      pkmnPool: getF1StdTrainerPool,
      LoseText: "gruntF1"
    },
    {
      # Rocket Grunt F2
      tType: :TEAMROCKET_M, tName: 'Grunt',
      lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
      pkmnPool: getOakPool6,
      LoseText: "gruntF2"
    },
    {
      # Rocket Grunt F3
      tType: :TEAMROCKET_M, tName: 'Grunt',
      lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
      pkmnPool: getOakPool8,
      LoseText: "gruntF3"
    },
    {
      # Rocket Grunt F4
      tType: :TEAMROCKET_M, tName: 'Grunt',
      lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
      pkmnPool: getOakPool10,
      LoseText: "gruntF4"
    },
  # ====== Rocket Grunt (Steal Trainer) Lucky Weakling mode =========
      {
        # Rocket Grunt F1
        tType: :TEAMROCKET_M, tName: 'Grunt',
        lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
        pkmnPool: getF1StdTrainerPool,
        LoseText: "gruntF1LW"
      },
      {
        # Rocket Grunt F2
        tType: :TEAMROCKET_M, tName: 'Grunt',
        lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
        pkmnPool: getOakPoolLW5,
        LoseText: "gruntF2LW"
      },
      {
        # Rocket Grunt F3
        tType: :TEAMROCKET_M, tName: 'Grunt',
        lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
        pkmnPool: getOakPoolLW6,
        LoseText: "gruntF3LW"
      },
      {
        # Rocket Grunt F4
        tType: :TEAMROCKET_M, tName: 'Grunt',
        lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
        pkmnPool: getOakPoolLW7,
        LoseText: "gruntF4LW"
      },
  # ====== Rocket Grunt (Steal Trainer) Monotype mode =========
      {
        # Rocket Grunt F1
        tType: :TEAMROCKET_M, tName: 'Grunt',
        lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
        pkmnPool: pbgetMonoTypePool(pbGetMonoType),
        LoseText: "gruntF1MT"
      },
      {
        # Rocket Grunt F2
        tType: :TEAMROCKET_M, tName: 'Grunt',
        lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
        pkmnPool: pbgetMonoTypePool(pbGetMonoType),
        LoseText: "gruntF2MT"
      },
      {
        # Rocket Grunt F3
        tType: :TEAMROCKET_M, tName: 'Grunt',
        lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
        pkmnPool: pbgetMonoTypePool(pbGetMonoType),
        LoseText: "gruntF3MT"
      },
      {
        # Rocket Grunt F4
        tType: :TEAMROCKET_M, tName: 'Grunt',
        lvl1: pbGetLvGrunt, lvl2: pbGetLvGrunt, numPkmn: 3,
        pkmnPool: pbgetMonoTypePool(pbGetMonoType),
        LoseText: "gruntF4MT"
      },
  # ====== Floor Bosses =========
      {
        # Boss F1
        tType: :ELITEFOUR_Bruno, tName: 'Bruno',
        lvl1: pbGetBossLv, lvl2: pbGetBossLv, numPkmn: 3,
        pkmnPool: getF1StdTrainerPool,
        LoseText: "GG WP"
      },
      {
        # Boss F2
        tType: :ELITEFOUR_Agatha, tName: 'Agatha',
        lvl1: pbGetBossLv, lvl2: pbGetBossLv, numPkmn: 4,
        pkmnPool: getOakPoolLW5,
        LoseText: "GG WP"
      },
      {
        # Boss F3
        tType: :LEADER_Misty, tName: 'Misty',
        lvl1: pbGetBossLv, lvl2: pbGetBossLv, numPkmn: 5,
        pkmnPool: getOakPoolLW6,
        LoseText: "GG WP"
      },
      {
        # Boss F4
        tType: :ELITEFOUR_Lance, tName: 'Lance',
        lvl1: pbGetBossLv, lvl2: pbGetBossLv, numPkmn: 6,
        pkmnPool: getOakPoolLW7,
        LoseText: "GG WP"
      },
]
end

TRAINER_INTRO_TEXT = [
  ['I was given 5$ to stop you.', 'I just caught these. Let\'s see how strong they are.',
   'Mom said I have to be home before it gets dark.'],
  ['Stop right there!', 'What\'s the hurry?', 'I can\'t let you through.', 'I will not go easy on you!'],
  ['You look weak. This will be easier than i thought.', 'Last chance to turn around.', 'You don\'t stand a chance!'],
  ['First I will finish your Pokémon, then I will finish you.', 'This will not end pretty.',
   'I hope you wrote your testament.', 'Time to smash some Pokémon']
]

TRAINER_LOOSE_TEXT = ["I'm never lucky...", "Well played!", "Damn, you are strong.", "Aw man...", "I will get you next time!", "How was I supposed to win?"]


Events.onTrainerPartyLoad += proc { |_sender, trainer_list|
  return unless trainer_list

  trainer_list.each do |trainer|
    template = pbGetTRAINER_OVERRIDE.find { |i| i[:tType] == trainer.trainer_type and i[:tName] == trainer.name and trainer.lose_text == i[:LoseText]}
    next unless template # Do nothing if no override was found
    start = Time.now
    # Determin lvl
    lvl = template[:lvl1]
    lvl = template[:lvl2] if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
    blacklist = %i[ELITEFOUR_Bruno ELITEFOUR_Agatha LEADER_Misty ELITEFOUR_Lance]
    boss = blacklist.include?(template[:tType])
    if boss
        trainer.party.each do |pkmn|
            pkmn.level = lvl
        end
    end
    if (!boss || pbGetGameMode == 6)
        newParty = []
        if (pbGet(63) == false)
            # Generate Party
            alreadyPicked = []
            improvedTrainers = [:TEAMROCKET_M, :RIVAL1, :BEAUTY, :GAMBLER, :ELITEFOUR_Bruno, :ELITEFOUR_Agatha, :LEADER_Misty, :ELITEFOUR_Lance]
            # Eliminates evasion moves from moveset, because they are buggy used by an NPC
            pbSet(58,1)
            # make it so the Pokémon get better movesets
            pbSet(58,2) if improvedTrainers.include? template[:tType]
            pbSet(58,3) if boss
            while newParty.length < template[:numPkmn]
              pkmnPool = []
              if pbGetGameMode == 6
                pkmnPool = pbGetTierPool(pbGet(62))
              else
                pkmnPool = template[:pkmnPool].reject { |p| alreadyPicked.include? p }
              end
              new_species = pkmnPool[rand(pkmnPool.length)]

              alreadyPicked.push(new_species)
              # disable form moves to trigger until form is changed
              pbSet(40, 1)
              pk = Pokemon.new(new_species, lvl)
              oldForm = GameData::Species.get_species_form(pk.species,pk.form).real_form_name.to_s
              newFormNumber = pbRollForm(pk.species)
              newForm = GameData::Species.get_species_form(pk.species,newFormNumber).real_form_name.to_s
              if oldForm != newForm
                pk.form = newFormNumber
                pk.reset_moves
                echoln "other form applied"
              end
              newParty.push(pk)
              pbSet(40, 0)
            end

            # Replace first Pokemon with a Mega Pokemon if on F4 Middle Floor Trainer or Elite Trainer map or Final boss in "Set Tier" gamemode
            if (($game_map.map_id == 108) || ($game_map.map_id == 105) || (($game_map.map_id == 106) && pbGetGameMode == 6))
                newPartyIDs = []
                newParty.each do |pkmn|
                    newPartyIDs.push(pkmn.species) if pkmn.species
                end
                pool = getOakMegas.dup
                pool += %i[MEWTWO LATIAS LATIOS RAYQUAZA DIANCIE]
                if pbGetGameMode == 6
                    pool = pool.intersection(pbGetTierPool(pbGet(62)))
                    tempPool = pool.dup
                    pool -= newPartyIDs
                    pool = tempPool if pool.length < 2
                else
                    pool -= newPartyIDs
                end
                megaPkmnID = pbChooseRandomPokemon(whiteList: pool)
                megaPkmn = Pokemon.new(megaPkmnID, lvl)
                megaStones = pbGetMegaStones(megaPkmn)
                megaPkmn.item = megaStones[rand(megaStones.length)]
                newParty[0] = megaPkmn if newParty[0]
            end

            # Set 58 back to default
            pbSet(58,0)
        else
            newParty = pbGet(44)
        end
        trainer.party = newParty
        trainer.lose_text = TRAINER_LOOSE_TEXT.sample if trainer.lose_text == "..."
        trainer.lose_text = "..." if trainer.trainer_type.to_s == "TEAMROCKET_M"

        # Preperation steal Pokémon
        pbSet(44, trainer.party.dup)
        pbSet(63, true)
        echoln (Time.now-start).to_s + 's Generated trainer party: ' + newParty.to_s
    end
  end
}

# Gets called by the Grunt
def pbGetGruntID
 id =  pbGet(48)
 id += 4 if pbLW
 # Monotype
 id += 8 if pbGetGameMode == 5
 return id
end

def pbGenIntroText
  stages_cleared = pbGet(48)
  intro_list = TRAINER_INTRO_TEXT[stages_cleared]
  pbSet(34, intro_list[rand(intro_list.length)])
end

def pbGetBossHint(template, trainerID, trainerName)
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

     return msg
end

def pbDisplayBossTeam(template, trainerID, trainerName)
  msg = pbGetBossHint(template, trainerID, trainerName)
  msg = template.gsub("\n", "").gsub("$team", "\\c[10]" + msg + template[0..1])
  pbMessage(msg)
end