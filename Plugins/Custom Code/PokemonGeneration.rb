POKEMON_FLOOR_START_LEVEL = [15, 30, 60, 90]
POKEMON_GET_LEVEL = POKEMON_FLOOR_START_LEVEL #[16, 32, 62, 92]

def pbGetStagesCleared
  pbGet(48)
end

def pbGetRoomsCleared
    pbGet(49)
  end

def pbGetPkmnTargetLvl
  return POKEMON_GET_LEVEL[pbGetStagesCleared] + 2 if pbGetRoomsCleared > 5 && pbGetStagesCleared > 3
  return POKEMON_GET_LEVEL[pbGetStagesCleared] + 1 if pbGetRoomsCleared > 5
  return POKEMON_GET_LEVEL[pbGetStagesCleared]
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

def pbGetCorrectOakPool(luckyWeakling = false)
    floor = pbGet(48) + 1
    diceRoll = rand(1..100)
    if luckyWeakling
        if floor == 1
            # 50% chance
            if 1 <= diceRoll && diceRoll <= 50
                return getOakPoolLW3
            # 20% chance
            elsif 51 <= diceRoll && diceRoll <= 70
                return getOakPoolLW2
            # 20% chance
            elsif 71 <= diceRoll && diceRoll <= 90
                return getOakPoolLW4
            # 10% chance
            elsif 91 <= diceRoll && diceRoll <= 100
                return getOakPoolLW1
            end
        elsif floor == 2
            # 50% chance
            if 1 <= diceRoll && diceRoll <= 50
                return getOakPoolLW5
            # 25% chance
            elsif 51 <= diceRoll && diceRoll <= 75
                return getOakPoolLW4
            # 25% chance
            elsif 76 <= diceRoll && diceRoll <= 100
                return getOakPoolLW6
            end
        elsif floor == 3
            # 50% chance
            if 1 <= diceRoll && diceRoll <= 50
                return getOakPoolLW6
            # 20% chance
            elsif 51 <= diceRoll && diceRoll <= 70
               return getOakPoolLW5
            # 20% chance
            elsif 71 <= diceRoll && diceRoll <= 90
                return getOakPoolLW7
            # 10% chance
            elsif 91 <= diceRoll && diceRoll <= 100
                return getOakPoolLW8
            end
        elsif floor == 4
            # 50% chance
            if 1 <= diceRoll && diceRoll <= 50
                return getOakPoolLW7
            # 25% chance
            elsif 51 <= diceRoll && diceRoll <= 75
                return getOakPoolLW6
            # 25% chance
            elsif 76 <= diceRoll && diceRoll <= 100
                return getOakPoolLW8
            end
        end
    else
        if floor == 1
            # 50% chance
            if 1 <= diceRoll && diceRoll <= 50
                return getOakPool3
            # 20% chance
            elsif 51 <= diceRoll && diceRoll <= 70
                return getOakPool2
            # 20% chance
            elsif 71 <= diceRoll && diceRoll <= 90
                return getOakPool4
            # 10% chance
            elsif 91 <= diceRoll && diceRoll <= 100
                return getOakPool1
            end
        elsif floor == 2
            # 50% chance
            if 1 <= diceRoll && diceRoll <= 50
                return getOakPool6
            # 25% chance
            elsif 51 <= diceRoll && diceRoll <= 75
                return getOakPool5
            # 25% chance
            elsif 76 <= diceRoll && diceRoll <= 100
                return getOakPool7
            end
        elsif floor == 3
            # 50% chance
            if 1 <= diceRoll && diceRoll <= 50
                return getOakPool9
            # 20% chance
            elsif 51 <= diceRoll && diceRoll <= 70
                return getOakPool8
            # 20% chance
            elsif 71 <= diceRoll && diceRoll <= 90
                return getOakPool10
            # 10% chance
            elsif 91 <= diceRoll && diceRoll <= 100
                return getOakPool11
            end
        elsif floor == 4
            # 50% chance
            if 1 <= diceRoll && diceRoll <= 50
                return getOakPool10
            # 25% chance
            elsif 51 <= diceRoll && diceRoll <= 75
                return getOakPool9
            # 25% chance
            elsif 76 <= diceRoll && diceRoll <= 100
                return getOakPool11
            end
        end
    end
end

def diverse_types?(pkmnIDs)
    types = []
    pkmnIDs.each do |pkmnid|
        pkmn = GameData::Species.try_get(pkmnid)
        typing = []
        typing.push(pkmn.type1)
        typing.push(pkmn.type2) if pkmn.type1.to_s != pkmn.type2.to_s
        types.push(typing)
    end
    # types could now look like this: [[WATER,GROUND],[DRAGON],[ICE,WATER]]

    for i1 in 0 .. (types.length-1) do
        for i2 in (i1+1) .. (types.length-1) do
            # returns false, if typing is identic
            return false if types[i1][0] == types[i2][0] && types[i1][1] == types[i2][1]
            # returns false if typing is just flipped (for example [WATER,GROUND] compared with [GROUND,WATER])
            return false if types[i1][0] == types[i2][1] && types[i1][1] == types[i2][0]
        end
    end
    return true
end

def pbRollForChance(chance)
    diceRoll = rand(1..100)
    return true if diceRoll <= chance
    return false
end

def pbGenPokeChoice
    amount = 3
    # Integer in %
    legiChance = 3
    output = []
    legiPkmns = []
    amountLegis = 0
    luckyWeakling = pbLW
    # Checks if mode is not "Lucky Weakling" and if the floor is > 2
    if pbGet(48) > 1 && !luckyWeakling
        for i in 1 .. amount do
           amountLegis += 1 if pbRollForChance(legiChance)
        end
    end
    if amountLegis > 0
        if pbChooseRandomPokemon(whiteList: getOakLegendOrMythic, amount: amountLegis).is_a?(Array)
            legiPkmns = pbChooseRandomPokemon(whiteList: getOakLegendOrMythic, amount: amountLegis)
        else
            legiPkmns.push(pbChooseRandomPokemon(whiteList: getOakLegendOrMythic, amount: amountLegis))
        end
        while !diverse_types?(legiPkmns) do
            # Same if-else block as above
            if pbChooseRandomPokemon(whiteList: getOakLegendOrMythic, amount: amountLegis).is_a?(Array)
                legiPkmns = pbChooseRandomPokemon(whiteList: getOakLegendOrMythic, amount: amountLegis)
            else
                legiPkmns.push(pbChooseRandomPokemon(whiteList: getOakLegendOrMythic, amount: amountLegis))
            end
        end
        output = legiPkmns
        amount -= amountLegis
        if amount > 0
           normalPkmns = []
           if pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool, amount: amount).is_a?(Array)
               normalPkmns = pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool, amount: amount)
           else
               normalPkmns.push(pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool, amount: amount))
           end
            mergedPkmns = legiPkmns.dup
            normalPkmns.each do |pkmn|
                mergedPkmns.push(pkmn)
            end
            while !diverse_types?(mergedPkmns) do
                # Same if-else block as above
                normalPkmns = []
                if pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool, amount: amount).is_a?(Array)
                   normalPkmns = pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool, amount: amount)
                else
                   normalPkmns.push(pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool, amount: amount))
                end
                mergedPkmns = legiPkmns.dup
                normalPkmns.each do |pkmn|
                    mergedPkmns.push(pkmn)
                end
            end
            output = mergedPkmns
        end
    else
        output = pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool(luckyWeakling), amount: amount)
        while !diverse_types?(output) do
            output = pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool(luckyWeakling), amount: amount)
        end
    end
    output = output.shuffle
    # do for every pokemon save slot
    [26, 27, 28].each do |i|
        pbSet(i, output.pop)
    end
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

#Reworked
def pbGetCorrectEvo(pkmn)
  p = GameData::Species.try_get(pbGetCorrectLvlEvo(pkmn, 70))
  evos = p.get_evolutions

  if evos.length() >= 1
        # p2 is the evolution of p
        p2 = GameData::Species.try_get(evos[0][0])
        if !filterPkmnHasEvolution(p2)
           return p2.id #i.e Sneasel -> Weavile
        else
           evos2 = p2.get_evolutions
           return evos2[0][0] #i.e Cleffa -> Clefable
        end
  else
        return p.id
  end
end

def pbGenStarterPkmn(type)
  return pbChooseRandomPokemon(whiteList: %i[CHARMANDER CYNDAQUIL TORCHIC CHIMCHAR TEPIG FENNEKIN LITTEN SCORBUNNY]) if type == :FIRE
  return pbChooseRandomPokemon(whiteList: %i[SQUIRTLE TOTODILE MUDKIP PIPLUP OSHAWOTT FROAKIE POPPLIO SOBBLE]) if type == :WATER
  return pbChooseRandomPokemon(whiteList: %i[BULBASAUR CHIKORITA TREECKO TURTWIG SNIVY CHESPIN ROWLET GROOKEY]) if type == :GRASS
end

def pbGenMegaPkmn
  pkmns = pbChooseRandomPokemon(whiteList: getOakMegas, amount:3)
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

#Generates the Pokemon (usually used when entering Oaks room)
def pbRandomPkmnGeneration(mega = false)
  mega = false if pbLW
  if mega
    pbGenMegaPkmn()
  else
    pbGenPokeChoice()
  end
  while (pbPkmnOwned?(pbGet(26), pbGet(27), pbGet(28)))
    echoln "Pokemon owned. Rerolling..."
      if mega
        pbGenMegaPkmn()
      else
        pbGenPokeChoice()
      end
  end

  # Roll Pokémon forms like Galar or Alolan form
  # First Poke
  pbSet(41, pbRollForm(pbGet(26)))
  # Second Poke
  pbSet(42, pbRollForm(pbGet(27)))
  # Third Poke
  pbSet(43, pbRollForm(pbGet(28)))
end

def pbRandomPkmnSelection(lv, hiddenAbility = true)
  pkmn1 = pbGet(26)
  formPkmn1 = pbGet(41)
  pkmn2 = pbGet(27)
  formPkmn2 = pbGet(42)
  pkmn3 = pbGet(28)
  formPkmn3 = pbGet(43)
  # 25% chance for hidden ability
  if(hiddenAbility && rand(4)==1)
      DiegoWTsStarterSelection.new(pkmn1, pkmn2, pkmn3, lv, hiddenAbility, formPkmn1, formPkmn2, formPkmn3)
  else
      DiegoWTsStarterSelection.new(pkmn1, pkmn2, pkmn3, lv, false, formPkmn1, formPkmn2, formPkmn3)
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