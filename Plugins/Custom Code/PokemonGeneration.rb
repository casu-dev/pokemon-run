POKEMON_FLOOR_START_LEVEL = [15, 30, 60, 90]
POKEMON_GET_LEVEL = POKEMON_FLOOR_START_LEVEL #[16, 32, 62, 92]

def pbGetStagesCleared
  pbGet(48)
end

def pbGetPkmnTargetLvl
  POKEMON_GET_LEVEL[pbGetStagesCleared]
end

def pbLvUpAllPkmn(targetLevel = nil)
  targetLevel = POKEMON_FLOOR_START_LEVEL[pbGetStagesCleared] if targetLevel.nil?

  # Level up party
  $Trainer.party.each do |pkmn|
    pbChangeLevel(pkmn, targetLevel, nil) if !pkmn.nil? && (pkmn.level < targetLevel)
  end

  # Level up box
  $PokemonStorage.boxes.each do |box|
    box.each do |pkmn|
      pbChangeLevel(pkmn, targetLevel, nil) if !pkmn.nil? && (pkmn.level < targetLevel)
    end
  end
end

def pbHealBoxes
  $PokemonStorage.boxes.each do |box|
    box.each do |pkmn|
      pkmn.heal if !pkmn.nil?
    end
  end
end

def pbGenPokeChoice
  startTime = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  nfe = false
  nfe = true if pbReadFile("gamemode.txt").to_i == 3
  echoln "Generating Poke Choice. With nfe? " + nfe.to_s 
  alreadyOwned = [] #todo
  startGen = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  
  if !nfe
    pkmns = pbChooseRandomPokemon(amount: 3)
    # do for every pokemon save slot
    [26, 27, 28].each do |i|
      pbSet(i, pbGetCorrectEvo(pkmns.pop, pbGetPkmnTargetLvl))   
    end       
  else
    startRoll = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    pkmns = pbChooseRandomPokemon(
      filterFunc: method(:filterPkmnHasEvolution),
      amount: 3
    )
    echoln "Gen Result: " + pkmns.to_s
    echoln "Generating Poke: pbChooseRandomPokemon took (s):" + (Process.clock_gettime(Process::CLOCK_MONOTONIC) - startRoll).to_s
    startRoll = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    [26, 27, 28].each do |i|
      correctEvo = pbGetCorrectEvo(pkmns.pop, pbGetPkmnTargetLvl)
      echoln "Correct_evo " + correctEvo.to_s
      devolvedEvo = pbDevolvePkmn(correctEvo)
      echoln "Saving " + devolvedEvo.to_s
      pbSet(i, devolvedEvo)
    end    
    echoln "Generating Poke: pbGetCorrectEvo + pbDevolvePkmn took (s):" + (Process.clock_gettime(Process::CLOCK_MONOTONIC) - startRoll).to_s
  end

  timeDiff = Process.clock_gettime(Process::CLOCK_MONOTONIC) - startTime
  echoln "Generation took " + timeDiff.to_s + "s"
end

def filterPkmnHasEvolution(species)
  return !GameData::Species.try_get(species).get_evolutions.empty?
end

def pbGetCorrectEvo(pkmn, lvl)
    evos = Pokemon.new(pkmn, lvl).species_data.get_evolutions
    if evos.to_s != '[]'
        if evos[0][1].to_s == "Level" && lvl >= evos[0][2].to_i
            return evos[0][0].to_s
        else
            return pkmn
        end
    else
        return pkmn
    end
end

def pbGenStarterPkmn(type)
  return pbChooseRandomPokemon(whiteList: %i[CHARMANDER CYNDAQUIL TORCHIC CHIMCHAR TEPIG]) if type == :FIRE
  return pbChooseRandomPokemon(whiteList: %i[SQUIRTLE TOTODILE MUDKIP PIPLUP OSHAWOTT]) if type == :WATER
  return pbChooseRandomPokemon(whiteList: %i[BULBASAUR CHIKORITA TREECKO TURTWIG SNIVY]) if type == :GRASS
end

def pbGenMegaPkmn
pkmn = pbChooseRandomPokemon(
    whiteList: %i[VENUSAUR CHARIZARD BLASTOISE BEEDRILL PIDGEOT ALAKAZAM SLOWBRO GENGAR KANGASKHAN PINSIR GYARADOS AERODACTYL
	 AMPHAROS STEELIX SCIZOR HERACROSS TYRANITAR SCEPTILE BLAZIKEN SWAMPERT GARDEVOIR SABLEYE MAWILE AGGRON MEDICHAM MANECTRIC
	 SHARPEDO CAMERUPT ALTARIA BANETTE ABSOL GLALIE SALAMENCE METAGROSS LOPUNNY GARCHOMP LUCARIO ABOMASNOW GALLADE AUDINO]
)
end

def pbPkmnOwned?(pkmn1, pkmn2, pkmn3)
  $PokemonStorage.boxes.each do |box|
      box.each do |pkmn|
          if pkmn != nil
              if pkmn.species_data.get_baby_species.to_s == Pokemon.new(pkmn1, 5).species_data.get_baby_species.to_s || pkmn.species_data.get_baby_species.to_s == Pokemon.new(pkmn2, 5).species_data.get_baby_species.to_s || pkmn.species_data.get_baby_species.to_s == Pokemon.new(pkmn3, 5).species_data.get_baby_species.to_s
                echoln "Pokemon was found in a box"
                return true
              end
          end
      end
  end

  $Trainer.party.each do |pkmn|
      if pkmn != nil
          if pkmn.species_data.get_baby_species.to_s == Pokemon.new(pkmn1, 5).species_data.get_baby_species.to_s || pkmn.species_data.get_baby_species.to_s == Pokemon.new(pkmn2, 5).species_data.get_baby_species.to_s || pkmn.species_data.get_baby_species.to_s == Pokemon.new(pkmn3, 5).species_data.get_baby_species.to_s
              return true
          end
      end
  end

  return false
end

def pbRandomPkmnSelection(lv, mega = false, hiddenAbility = true)
    if mega
        pkmn1 = pbGenMegaPkmn
        pkmn2 = pbGenMegaPkmn
        pkmn3 = pbGenMegaPkmn
    else
        pbGenPokeChoice
        pkmn1 = pbGet(26)
        pkmn2 = pbGet(27)
        pkmn3 = pbGet(28)
    end

    while (pbPkmnOwned?(pkmn1, pkmn2, pkmn3))
      echoln "Pokemons are not unique. Rerolling..."
        if mega
          pkmn1 = pbGenMegaPkmn
          pkmn2 = pbGenMegaPkmn
          pkmn3 = pbGenMegaPkmn
        else
          pbGenPokeChoice
          pkmn1 = pbGet(26)
          pkmn2 = pbGet(27)
          pkmn3 = pbGet(28)
        end
    end

    # 25% chance for hidden ability
    if(hiddenAbility && rand(4)==1)
        DiegoWTsStarterSelection.new(pkmn1, pkmn2, pkmn3, lv, hiddenAbility)
    else
        DiegoWTsStarterSelection.new(pkmn1, pkmn2, pkmn3, lv)
    end
end

def pbGiveRandomPoke(saveSlot)
  lvl = lvl = POKEMON_GET_LEVEL[pbGetStagesCleared]

  pkmn = Pokemon.new(pbGet(saveSlot), lvl)
  pbAddPokemon(pkmn)
end

def pbDevolvePkmn(p)
  s = GameData::Species.try_get(p)
  if s.get_evolutions.empty?
      baby = GameData::Species.try_get(s.get_baby_species)
      if !baby.get_evolutions.empty?
           if filterPkmnHasEvolution(GameData::Species.try_get(baby.get_evolutions[0][0]))
                return baby.get_evolutions[0][0]
           else
                return baby.id
           end
      else
          return nil
      end
  end
  return s.id
end