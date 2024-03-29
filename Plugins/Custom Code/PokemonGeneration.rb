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

def pbLvUpAllPkmn(targetLevel = nil, partyOnly = false)
  targetLevel = POKEMON_FLOOR_START_LEVEL[pbGetStagesCleared] if targetLevel.nil?

  # Level up party
  $Trainer.party.each do |pkmn|
    pbChangeLevel(pkmn, targetLevel, nil) if !pkmn.nil? && (pkmn.level < targetLevel)
  end

  if !partyOnly
      # Level up box
      $PokemonStorage.boxes.each do |box|
        box.each do |pkmn|
          pbChangeLevel(pkmn, targetLevel, nil) if !pkmn.nil? && (pkmn.level < targetLevel)
        end
      end
  end
end

def pbHealBoxes
  $PokemonStorage.boxes.each do |box|
    box.each do |pkmn|
      if !pkmn.nil?
          statusAfter = pbGetStatusAfter(pkmn)
          pkmn.heal
          pkmn.status = statusAfter
      end
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
    return pbGetTierPool(pbGet(62)) if pbGetGameMode == 6
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

def pbRandomPkmnsAsArray(whiteList: nil, blacklist: nil, amount: 3)
    output = []
    result = pbChooseRandomPokemon(whiteList: whiteList, blacklist: blacklist, amount: amount)
    if result.is_a?(Array)
       output = result
    else
       output.push(result)
    end
    return output
end

def pbGenMonoTypeMegaPkmn
    output = []
    basePool = getOakMegas
    typeIds = []
    GameData::Type.each do |t|
        next unless t.id.to_s != "QMARKS"
        typeIds.push(t.id)
    end
    type = pbGet(59)
    type = typeIds.sample if !(typeIds.include? type)
    whiteList = [type]
    megas = []
    basePool.each do |pkmnID|
            pkmn = GameData::Species.try_get(pkmnID)
            megas.push(pkmnID) if (whiteList.include? pkmn.type1) || (whiteList.include? pkmn.type2)
    end
    n = [3, megas.length].min
    (0...n).each do |i|
        output.push(megas[i])
    end
    n = 3-n
    if n>0
        fillupTemp = []
        monoPool = pbgetMonoTypePool(type).dup
        monoPool -= pbGetOwnedPkmn
        monoPool -= megas
        if monoPool.length < n
            myTemp = pbgetMonoTypePool(type).dup
            myTemp -= monoPool
            monoPool += myTemp.sample(n-monoPool.length)
        end

        fillupTemp = monoPool.sample(n)
        fillup = []
        if fillupTemp.is_a?(Array)
           fillup = fillupTemp
        else
           fillup.push(fillupTemp)
        end
        output += fillup
    end
    if pbRollForChance(9)
        megaLegis = %i[MEWTWO LATIAS LATIOS RAYQUAZA DIANCIE]
        typeLegis = []
        megaLegis.each do |pkmnID|
                pkmn = GameData::Species.try_get(pkmnID)
                typeLegis.push(pkmnID) if (whiteList.include? pkmn.type1) || (whiteList.include? pkmn.type2)
        end
        if typeLegis.length > 0
            output[2] = pbChooseRandomPokemon(whiteList: typeLegis, blacklist: pbGetOwnedPkmn, amount: 1)
        else
            possLegis = getOakLegendOrMythic
            legis = []
            possLegis.each do |pkmnID|
                pkmn = GameData::Species.try_get(pkmnID)
                legis.push(pkmnID) if (whiteList.include? pkmn.type1) || (whiteList.include? pkmn.type2)
            end
            output[2] = pbChooseRandomPokemon(whiteList: legis, blacklist: pbGetOwnedPkmn, amount: 1)
        end
    end
    output = output.shuffle
    # do for every pokemon save slot
    [26, 27, 28].each do |i|
        pbSet(i, output.pop)
    end
end

def pbGenMonoTypePokeChoice
    amount = 3
    typeIds = []
    GameData::Type.each do |t|
        next unless t.id.to_s != "QMARKS"
        typeIds.push(t.id)
    end
    type = pbGet(59)
    type = typeIds.sample if !(typeIds.include? type)
    pool = pbgetMonoTypePool(type)
    output = []
    output = pbChooseRandomPokemon(whiteList: pool, blacklist: pbGetOwnedPkmn, amount: amount)
    loopcounter = 0
    while (!diverse_types?(output) && loopcounter <10) do
        output = pbChooseRandomPokemon(whiteList: pool, blacklist: pbGetOwnedPkmn, amount: amount)
        loopcounter += 1
    end
    # Chance tripled, because only 1 slot can be shiny
    if (pbRollForChance(9) && pbGet(48) > 1)
        basePool = getOakLegendOrMythic
        whiteList = [type]
        legis = []
        basePool.each do |pkmnID|
                pkmn = GameData::Species.try_get(pkmnID)
                legis.push(pkmnID) if (whiteList.include? pkmn.type1) || (whiteList.include? pkmn.type2)
        end
        output[2] = pbChooseRandomPokemon(whiteList: legis, blacklist: pbGetOwnedPkmn, amount: 1)
    end
    output = output.shuffle
    # do for every pokemon save slot
    [26, 27, 28].each do |i|
        pbSet(i, output.pop)
    end
end

def pbGenPokeChoice
    amount = 3
    # Chance in % (integer)
    legiChance = 3
    output = []
    amountLegis = 0
    luckyWeakling = pbLW
    # Checks if mode is not "Lucky Weakling" and if the floor is > 2
    if pbGet(48) > 1 && !luckyWeakling && !(pbGetGameMode == 6)
        for i in 1 .. amount do
           amountLegis += 1 if pbRollForChance(legiChance)
        end
    end
    if amountLegis > 0
        legiPkmns = pbRandomPkmnsAsArray(whiteList: getOakLegendOrMythic, blacklist: pbGetOwnedPkmn, amount: amountLegis)
        loopCounter = 0
        while (!diverse_types?(legiPkmns) && loopCounter <10) do
          legiPkmns = pbRandomPkmnsAsArray(whiteList: getOakLegendOrMythic, blacklist: pbGetOwnedPkmn, amount: amountLegis)
          loopCounter += 1
        end
        output = legiPkmns
        amount -= amountLegis
        if amount > 0
            mergedPkmns = legiPkmns.dup
            mergedPkmns += pbRandomPkmnsAsArray(whiteList: pbGetCorrectOakPool, blacklist: pbGetOwnedPkmn, amount: amount)
            loopCounter = 0
            while (!diverse_types?(mergedPkmns) && loopCounter <10) do
                mergedPkmns = legiPkmns.dup
                mergedPkmns += pbRandomPkmnsAsArray(whiteList: pbGetCorrectOakPool, blacklist: pbGetOwnedPkmn, amount: amount)
                loopCounter += 1
            end
            output = mergedPkmns
        end
    else
        output = pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool(luckyWeakling), blacklist: pbGetOwnedPkmn, amount: amount)
        loopCounter = 0
        while (!diverse_types?(output) && loopCounter <10) do
            output = pbChooseRandomPokemon(whiteList: pbGetCorrectOakPool(luckyWeakling), blacklist: pbGetOwnedPkmn, amount: amount)
            loopCounter += 1
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

def pbGetStarters(type)
    return [:BULBASAUR, :CHIKORITA, :TREECKO, :TURTWIG, :SNIVY, :CHESPIN, :ROWLET, :GROOKEY] if type == :GRASS
    return [:CHARMANDER, :CYNDAQUIL, :TORCHIC, :CHIMCHAR, :TEPIG, :FENNEKIN, :LITTEN, :SCORBUNNY] if type == :FIRE
    return [:SQUIRTLE, :TOTODILE, :MUDKIP, :PIPLUP, :OSHAWOTT, :FROAKIE, :POPPLIO, :SOBBLE] if type == :WATER
end

def pbGenStarterPkmn(type)
    index = pbReadFile("f3completedcount.txt").to_i
    maxIndex = pbGetStarters(:GRASS).length-1
    index = maxIndex if index > maxIndex
    pickableGrassStarter = []
    pickableFireStarter = []
    pickableWaterStarter = []
    for i in 0 .. index do
        pickableGrassStarter.push(pbGetStarters(:GRASS)[i])
        pickableFireStarter.push(pbGetStarters(:FIRE)[i])
        pickableWaterStarter.push(pbGetStarters(:WATER)[i])
    end

    return Pokemon.new(pbChooseRandomPokemon(whiteList: pickableGrassStarter), pbGetPkmnTargetLvl) if type == :GRASS
    return Pokemon.new(pbChooseRandomPokemon(whiteList: pickableFireStarter), pbGetPkmnTargetLvl) if type == :FIRE
    return Pokemon.new(pbChooseRandomPokemon(whiteList: pickableWaterStarter), pbGetPkmnTargetLvl) if type == :WATER
end

def pbGenSetTierMegaPkmn
    megaLegis = %i[MEWTWO LATIAS LATIOS RAYQUAZA DIANCIE]
    pool = getOakMegas
    pool += megaLegis
    pool = pool.intersection(pbGetCorrectOakPool)
    echoln pool.to_s
    output = pbChooseRandomPokemon(whiteList: pool, blacklist: pbGetOwnedPkmn, amount: 3)
    loopCounter = 0
    while (!diverse_types?(output) && loopCounter <10) do
        output = pbChooseRandomPokemon(whiteList: pool, blacklist: pbGetOwnedPkmn, amount: 3)
        loopCounter += 1
    end
    output = output.shuffle
    # do for every pokemon save slot
    [26, 27, 28].each do |i|
        pbSet(i, output.pop)
    end
end

def pbGenMegaPkmn
    amount = 3
    # Chance in % (integer)
    legiChance = 3
    output = []
    amountLegis = 0
        for i in 1 .. amount do
           amountLegis += 1 if pbRollForChance(legiChance)
        end
    if amountLegis > 0
        legiPkmns = pbRandomPkmnsAsArray(whiteList: %i[MEWTWO LATIAS LATIOS RAYQUAZA DIANCIE], blacklist: pbGetOwnedPkmn, amount: amountLegis)
        loopCounter = 0
        while (!diverse_types?(legiPkmns) && loopCounter <10) do
          legiPkmns = pbRandomPkmnsAsArray(whiteList: %i[MEWTWO LATIAS LATIOS RAYQUAZA DIANCIE], blacklist: pbGetOwnedPkmn, amount: amountLegis)
          loopCounter += 1
        end
        output = legiPkmns
        amount -= amountLegis
        if amount > 0
            mergedPkmns = legiPkmns.dup
            mergedPkmns += pbRandomPkmnsAsArray(whiteList: getOakMegas, blacklist: pbGetOwnedPkmn, amount: amount)
            loopCounter = 0
            while (!diverse_types?(mergedPkmns) && loopCounter <10) do
                mergedPkmns = legiPkmns.dup
                mergedPkmns += pbRandomPkmnsAsArray(whiteList: getOakMegas, blacklist: pbGetOwnedPkmn, amount: amount)
                loopCounter += 1
            end
            output = mergedPkmns
        end
    else
        output = pbChooseRandomPokemon(whiteList: getOakMegas, blacklist: pbGetOwnedPkmn, amount: amount)
        loopCounter = 0
        while (!diverse_types?(output) && loopCounter <10) do
            output = pbChooseRandomPokemon(whiteList: getOakMegas, blacklist: pbGetOwnedPkmn, amount: amount)
            loopCounter += 1
        end
    end
    output = output.shuffle
    # do for every pokemon save slot
    [26, 27, 28].each do |i|
        pbSet(i, output.pop)
    end
end

def pbPkmnOwned?(pkmn1, pkmn2, pkmn3)
    babySpeciesInput = []
    babySpeciesInput.push(GameData::Species.try_get(pkmn1).get_baby_species)
    babySpeciesInput.push(GameData::Species.try_get(pkmn2).get_baby_species)
    babySpeciesInput.push(GameData::Species.try_get(pkmn3).get_baby_species)
    #remove duplicates
    babySpeciesInput |= []

  # check boxes
  $PokemonStorage.boxes.each do |box|
      box.each do |pkmn|
          if pkmn != nil
              if babySpeciesInput.include? pkmn.species_data.get_baby_species
                return true
              end
          end
      end
  end

  # check party
  $Trainer.party.each do |pkmn|
      if pkmn != nil
          if babySpeciesInput.include? pkmn.species_data.get_baby_species
              return true
          end
      end
  end

  return false
end

def pbOakOfferStarter
    gamemode = pbGetGameMode
    if (gamemode == 5 || gamemode == 6)
       pbRandomPkmnGeneration(false, false)
       pbRandomPkmnSelection
    else
        poke1 = pbGenStarterPkmn(:GRASS)
        poke2 = pbGenStarterPkmn(:FIRE)
        poke3 = pbGenStarterPkmn(:WATER)
        DiegoWTsStarterSelection.new(poke1, poke2, poke3)
    end
end

#Generates the Pokemon (usually used when entering Oaks room)
def pbRandomPkmnGeneration(mega = false, hiddenAbility = true)
  if pbGet(48) == 3 && $game_map.map_id == 88
    return if pbRollHallOfFameChoice
    echoln "hall of fame choice false"
  end
  mega = false if pbLW
  monotype = false
  monotype = true if (pbGetGameMode == 5 && pbGet(59) != 0)

  if pbGetGameMode == 6
    if mega
        pbGenSetTierMegaPkmn
    else
       pbGenPokeChoice
    end
  elsif(monotype)
    if mega
        pbGenMonoTypeMegaPkmn
    else
        pbGenMonoTypePokeChoice
    end
  else
    if mega
        pbGenMegaPkmn
    else
        pbGenPokeChoice
    end
  end

  # Replace species names by real Pokémon
  # First Poke
  pbSet(26, Pokemon.new(pbGet(26), pbGetPkmnTargetLvl))
  # Second Poke
  pbSet(27, Pokemon.new(pbGet(27), pbGetPkmnTargetLvl))
  # Third Poke
  pbSet(28, Pokemon.new(pbGet(28), pbGetPkmnTargetLvl))

  if !mega
    # deactivate asking player for learning move on form change
    pbSet(40, 1)
    # Roll forms
    (26..28).each do |i|
        pk = pbGet(i)
        oldForm = pk.species_data.real_form_name.to_s
        newFormNumber = pbRollForm(pk.species)
        newForm = GameData::Species.get_species_form(pk.species,newFormNumber).real_form_name.to_s
        if oldForm != newForm
            pbGet(i).form = newFormNumber
            pbGet(i).reset_moves
        end
    end
    # activate asking player for learning move on form change
    pbSet(40, 0)
  end
    # 25% chance for hidden ability, if not on starting map
    if($game_map.map_id != 79 && hiddenAbility && rand(4)==1)
        pbGet(26).setAbility(2)
        pbGet(27).setAbility(2)
        pbGet(28).setAbility(2)
    end
end

def pbRandomPkmnSelection(hiddenAbility = true)
  DiegoWTsStarterSelection.new(pbGet(26), pbGet(27), pbGet(28))
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