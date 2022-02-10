POKEMON_FLOOR_START_LEVEL = [15, 30, 60, 90]
POKEMON_GET_LEVEL = POKEMON_FLOOR_START_LEVEL # [16, 32, 62, 92]

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

def pbGenPokeChoice
  pkmn = pbChooseRandomPokemon(
    whiteList = nil,
    blackList = 'suggested',
    addList = nil,
    base_only = true,
    choose_gen = [1, 2, 3, 4, 5]
  )

  pbSet(26, pbGetCorrectEvo(pkmn, pbGetPkmnTargetLvl))

  pkmn = pbChooseRandomPokemon(
    whiteList = nil,
    blackList = 'suggested',
    addList = nil,
    base_only = true,
    choose_gen = [1, 2, 3, 4, 5]
  )

  pbSet(27, pbGetCorrectEvo(pkmn, pbGetPkmnTargetLvl))

  pkmn = pbChooseRandomPokemon(
    whiteList = nil,
    blackList = 'suggested',
    addList = nil,
    base_only = true,
    choose_gen = [1, 2, 3, 4, 5]
  )

  pbSet(28, pbGetCorrectEvo(pkmn, pbGetPkmnTargetLvl))
end

def pbGetCorrectEvo(pkmn, lvl)
  res = pkmn
  nxt = pkmn
  while nxt
    res = nxt
    nxt = pbGenPkmn(nxt, lvl).check_evolution_on_level_up
  end
  res
end

def pbGenStarterPkmn(type)
  pkmn = pbChooseRandomPokemon(
    whiteList = %i[BULBASAUR CHARMANDER SQUIRTLE CHIKORITA CYNDAQUIL TOTODILE TREECKO TORCHIC MUDKIP
                   TURTWIG CHIMCHAR PIPLUP SNIVY TEPIG OSHAWOTT],
    blackList = 'suggested',
    addList = nil,
    base_only = true,
    choose_gen = [1, 2, 3, 4, 5],
    typeWhitelist = [type]
  )
end

def pbGenMegaPkmn
pkmn = pbChooseRandomPokemon(
    whiteList = %i[VENUSAUR CHARIZARD BLASTOISE BEEDRILL PIDGEOT ALAKAZAM SLOWBRO GENGAR KANGASKHAN PINSIR GYARADOS AERODACTYL
	 AMPHAROS STEELIX SCIZOR HERACROSS TYRANITAR SCEPTILE BLAZIKEN SWAMPERT GARDEVOIR SABLEYE MAWILE AGGRON MEDICHAM MANECTRIC
	 SHARPEDO CAMERUPT ALTARIA BANETTE ABSOL GLALIE SALAMENCE METAGROSS LOPUNNY GARCHOMP LUCARIO ABOMASNOW GALLADE AUDINO],
    blackList = 'suggested',
    addList = nil,
    base_only = true,
    choose_gen = [1, 2, 3, 4, 5]
)
# pkmn.item=pbGetMegaStones(pkmn)[0].to_s
end

def pbRandomPkmnSelection(lv, mega = false)
    if mega
        pkmn1 = pbGenMegaPkmn
        pkmn2 = pbGenMegaPkmn
        pkmn3 = pbGenMegaPkmn
    else
        pkmn1 = pbGet(26)
        pkmn2 = pbGet(27)
        pkmn3 = pbGet(28)
    end

    while (pkmn1 == pkmn2)
        pkmn2 = pbGenMegaPkmn
    end

    while (pkmn1 == pkmn3 || pkmn2 == pkmn3)
        pkmn3 = pbGenMegaPkmn
    end

    DiegoWTsStarterSelection.new(pkmn1, pkmn2, pkmn3, lv)
end

def pbGiveRandomPoke(saveSlot)
  lvl = lvl = POKEMON_GET_LEVEL[pbGetStagesCleared]

  pkmn = pbGenPkmn(pbGet(saveSlot), lvl)
  pbAddPokemon(pkmn)
end