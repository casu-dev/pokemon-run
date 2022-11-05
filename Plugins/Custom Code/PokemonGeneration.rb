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

def getGen5BreedBabies
  %i[PICHU CLEFFA IGGLYBUFF TOGEPI TYROGUE SMOOCHUM ELEKID MAGBY AZURILL WYNAUT BUDEW CHINGLING BONSLY HAPPINY MUNCHLAX RIOLU MANTYKE MIMEJR]
end

def getGen5BreedBabyEvos
  %i[PIKACHU CLEFAIRY JIGGLYPUFF TOGETIC HITMONLEE HITMONCHAN HITMONTOP JYNX ELECTABUZZ MAGMAR MARILL WOBBUFFET ROSELIA CHIMECHO SUDOWOODO CHANSEY SNORLAX LUCARIO MANTINE MRMIME]
end

# For Lucky Weakling mode
def pbModifyBreedBabyList
    oldBabyList = getGen5BreedBabies
    newBabyList = []
    oldBabyList.each do |baby|
        evo_info = GameData::Species.try_get(baby).get_evolutions
        newBabyList << baby if filterPkmnHasEvolution(evo_info[0][0])
    end
    return newBabyList
end

def pbEvolveBaby(pkmn)
  evo_info = pkmn.species_data.get_evolutions
  if pbCanEvoInCurrentMode(pkmn)
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, evo_info[0][0])
      evo.pbEvolution
      evo.pbEndScreen
  end
end

def pbEvolveBabiesInParty
    $Trainer.party.each do |pkmn|
        pbEvolveBaby(pkmn) if !pkmn.nil? && (getGen5BreedBabies.include? pkmn.species)
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
    pkmns = nil
    if pbGetStagesCleared != 1
        pkmns = pbChooseRandomPokemon(amount: 3)
    else
        pkmns = pbChooseRandomPokemon(
              blacklist: getGen5BreedBabies,
              amount: 3,
              addToPool: getGen5BreedBabyEvos
            )
    end
    # do for every pokemon save slot
    [26, 27, 28].each do |i|
      pbSet(i, pbGetCorrectEvo(pkmns.pop, pbGetPkmnTargetLvl))   
    end       
  else
    startRoll = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    pkmns = nil
        if pbGetStagesCleared != 1
            pkmns = pbChooseRandomPokemon(
                  filterFunc: method(:filterPkmnHasEvolution),
                  amount: 3
                )
        else
            pkmns = pbChooseRandomPokemon(
                  blacklist: pbModifyBreedBabyList,
                  filterFunc: method(:filterPkmnHasEvolution),
                  amount: 3,
                  addToPool: getGen5BreedBabyEvos
                )
        end
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

def pbGetCorrectLvlEvo(pkmn, lvl)
    evos = GameData::Species.try_get(pkmn).get_evolutions
    if evos.length() == 1
        if evos[0][1].to_s == "Level" && lvl >= evos[0][2].to_i
            return pbGetCorrectLvlEvo(evos[0][0], lvl)
        else
            return pkmn
        end
    else
        return pkmn
    end
end

def pbGetCorrectEvo(pkmn, lvl)
  p = GameData::Species.try_get(pbGetCorrectLvlEvo(pkmn, lvl))
  $Lv = pbGetPkmnTargetLvl
  evos = p.get_evolutions

  if evos.length() == 1 && $Lv >= 60
        # p2 is the evolution of p
        p2 = GameData::Species.try_get(evos[0][0])
        if !filterPkmnHasEvolution(p2)
           return p2.id #i.e Sneasel -> Weavile
        else
           evos2 = p2.get_evolutions
           if evos2.length() > 1
                return p2.id # no i.e
           else
                return evos2[0][0] #i.e Cleffa -> Clefable
           end
        end
  else
        return p.id
  end
end

def pbGenStarterPkmn(type)
  return pbChooseRandomPokemon(whiteList: %i[CHARMANDER CYNDAQUIL TORCHIC CHIMCHAR TEPIG]) if type == :FIRE
  return pbChooseRandomPokemon(whiteList: %i[SQUIRTLE TOTODILE MUDKIP PIPLUP OSHAWOTT]) if type == :WATER
  return pbChooseRandomPokemon(whiteList: %i[BULBASAUR CHIKORITA TREECKO TURTWIG SNIVY]) if type == :GRASS
end

def pbGenMegaPkmn
  pkmns = pbChooseRandomPokemon(
      whiteList: %i[VENUSAUR CHARIZARD BLASTOISE BEEDRILL PIDGEOT ALAKAZAM SLOWBRO GENGAR KANGASKHAN PINSIR GYARADOS AERODACTYL
    AMPHAROS STEELIX SCIZOR HERACROSS TYRANITAR SCEPTILE BLAZIKEN SWAMPERT GARDEVOIR SABLEYE MAWILE AGGRON MEDICHAM MANECTRIC
    SHARPEDO CAMERUPT ALTARIA BANETTE ABSOL GLALIE SALAMENCE METAGROSS LOPUNNY GARCHOMP LUCARIO ABOMASNOW GALLADE AUDINO], amount:3
  )
  pbSet(26, pkmns[0])
  pbSet(27, pkmns[1])
  pbSet(28, pkmns[2])
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

def pbRandomPkmnGeneration(mega = false)
  if mega
    pbGenMegaPkmn()
  else
    pbGenPokeChoice()
  end

  while (pbPkmnOwned?(pbGet(26), pbGet(27), pbGet(28)))
    echoln "Pokemons are not unique. Rerolling..."
      if mega
        pbGenMegaPkmn()
      else
        pbGenPokeChoice()
      end
  end
end

def pbRandomPkmnSelection(lv, hiddenAbility = true)
  pkmn1 = pbGet(26)
  pkmn2 = pbGet(27)
  pkmn3 = pbGet(28)
  # 25% chance for hidden ability
  if(hiddenAbility && rand(4)==1)
      DiegoWTsStarterSelection.new(pkmn1, pkmn2, pkmn3, lv, hiddenAbility)
  else
      DiegoWTsStarterSelection.new(pkmn1, pkmn2, pkmn3, lv)
  end
end

def pbGiveRandomPoke(saveSlot)
  lvl = POKEMON_GET_LEVEL[pbGetStagesCleared]
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