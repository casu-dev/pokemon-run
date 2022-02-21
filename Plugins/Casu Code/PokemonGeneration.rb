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
    nxt = Pokemon.new(nxt, lvl).check_evolution_on_level_up
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

def pbRandomPkmnSelection(lv, mega = false, hiddenAbility = true)
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

    $h=rand(4)
    #pbMessage(_INTL($h.to_s))

    if(hiddenAbility && $h==1)
        n = $PokemonStorage.boxes[0].length-1
        $FirstEmptySlotBefore=0

        (0..n).each do |i|
            if ($PokemonStorage.boxes[0][i]==nil)
                $FirstEmptySlotBefore=i
            break
            end
        end
    end

    DiegoWTsStarterSelection.new(pkmn1, pkmn2, pkmn3, lv)

    if(hiddenAbility  && $h==1)
        m=$Trainer.party.length-1

        (0..n).each do |i|
          if ($PokemonStorage.boxes[0][i]==nil)
            if(i>$FirstEmptySlotBefore)
                 $PokemonStorage.boxes[0][i-1].setAbility(2)
            else
                (0..m).each do |j|
                    if($Trainer.party[m-j] != nil)
                        $Trainer.party[m-j].setAbility(2)
                        break
                    end
                end
            end
            break
          end
        end
    end
end

def pbGiveRandomPoke(saveSlot)
  lvl = lvl = POKEMON_GET_LEVEL[pbGetStagesCleared]

  pkmn = Pokemon.new(pbGet(saveSlot), lvl)
  pbAddPokemon(pkmn)
end