# returns a random pokemon when amount = 1 or returns a list of distinct random pokemons of size amount
def pbChooseRandomPokemon(
  whiteList: nil,
  blacklist: nil,
  filterFunc: method(:noFilter),
  amount: 1,
  addToPool: nil
)
  pool = getGen5Babies
  pool = whiteList if whiteList
  pool -= blacklist if blacklist
  pool += addToPool if addToPool

  pool = pool.select do |p|
    filterFunc.call(p)
  end

  if amount <= 1
    pool.delete_at(rand(pool.length))
  else
    result = []
    (0...amount).each do |_i|
      result.push(pool.delete_at(rand(pool.length)))
    end
    result
  end
end

# returns a list of random pokemon
def pbGetRandomPokemonPool(whiteList = nil, blackList = nil, addList = nil,
                           base_only = true, choose_gen = nil, typeWhitelist = nil,
                           filterFunc = method(:noFilter))

  # If blackList is set to "suggested", then set to mythical and legendary Pokémon
  blackList = getLegendOrMythic if blackList == 'suggested'

  # Option for a second black list, useful if suggested black list is requested and the user wants to add into that array rather than rewrite it
  # addList is ignored if blackList is not specified
  blackList.concat(addList) if addList && blackList

  # Set blackList to empty array if it doesn't exist by this point
  blackList ||= []

  unless typeWhitelist
    typeWhitelist = []
    GameData::Type.each do |t|
      typeWhitelist.push(t.id)
    end
  end

  # Set choose_gen to array of values from 1 to 8 if it doesn't exist
  choose_gen ||= (1..8).to_a

  # Blank array to be filled
  arr = []

  # If whiteList is given, push into above blank array
  # If base_only is true, then only pick species from whiteList if they are the base form
  # Exclude any species on the black list
  # If whiteList is not defined, then start from all species
  # Restrict to species from generations specified in choose_gen array
  # Repeated from above wrt black list and base forms
  if whiteList
    whiteList.each_with_index do |s, i|
      whiteList[i] = GameData::Species.try_get(s)
    end
    if base_only
      whiteList.each do |s|
        if !blackList.include?(s.id) && s.id == s.get_baby_species && (typeWhitelist.include?(s.type1) || typeWhitelist.include?(s.type2)) && filterFunc.call(s)
          arr.push(s.id)
        end
      end
    else
      whiteList.each do |s|
        if !blackList.include?(s.id) && (typeWhitelist.include?(s.type1) || typeWhitelist.include?(s.type2)) && filterFunc.call(s)
          arr.push(s.id)
        end
      end
    end
  elsif base_only
    GameData::Species.each do |s|
      if choose_gen.include?(s.generation) && !blackList.include?(s.id) && s.id == s.get_baby_species && s.form == 0 && (typeWhitelist.include?(s.type1) || typeWhitelist.include?(s.type2)) && filterFunc.call(s)
        arr.push(s.id)
      end
    end
  else
    GameData::Species.each do |s|
      if choose_gen.include?(s.generation) && !blackList.include?(s.id) && s.form == 0 && (typeWhitelist.include?(s.type1) || typeWhitelist.include?(s.type2)) && filterFunc.call(s)
        arr.push(s.id)
      end
    end
  end
  arr
end

def noFilter(_p)
  true
end

def getGen5Babies
  %i[BULBASAUR CHARMANDER SQUIRTLE CATERPIE WEEDLE PIDGEY RATTATA SPEAROW EKANS SANDSHREW
     NIDORANfE NIDORANmA VULPIX ZUBAT ODDISH PARAS VENONAT DIGLETT MEOWTH PSYDUCK MANKEY
     GROWLITHE POLIWAG ABRA MACHOP BELLSPROUT TENTACOOL GEODUDE PONYTA SLOWPOKE MAGNEMITE
     FARFETCHD DODUO SEEL GRIMER SHELLDER GASTLY ONIX DROWZEE KRABBY VOLTORB EXEGGCUTE CUBONE
     LICKITUNG KOFFING RHYHORN TANGELA KANGASKHAN HORSEA GOLDEEN STARYU SCYTHER PINSIR TAUROS
     MAGIKARP LAPRAS DITTO EEVEE PORYGON OMANYTE KABUTO AERODACTYL DRATINI CHIKORITA CYNDAQUIL
     TOTODILE SENTRET HOOTHOOT LEDYBA SPINARAK CHINCHOU PICHU CLEFFA IGGLYBUFF TOGEPI NATU MAREEP
     HOPPIP AIPOM SUNKERN YANMA WOOPER MURKROW MISDREAVUS UNOWN GIRAFARIG PINECO DUNSPARCE GLIGAR
     SNUBBULL QWILFISH SHUCKLE HERACROSS SNEASEL TEDDIURSA SLUGMA SWINUB CORSOLA REMORAID DELIBIRD
     SKARMORY HOUNDOUR PHANPY STANTLER SMEARGLE TYROGUE SMOOCHUM ELEKID MAGBY MILTANK LARVITAR TREECKO
     TORCHIC MUDKIP POOCHYENA ZIGZAGOON WURMPLE LOTAD SEEDOT TAILLOW WINGULL RALTS SURSKIT SHROOMISH
     SLAKOTH NINCADA WHISMUR MAKUHITA AZURILL NOSEPASS SKITTY SABLEYE MAWILE ARON MEDITITE ELECTRIKE
     PLUSLE MINUN VOLBEAT ILLUMISE GULPIN CARVANHA WAILMER NUMEL TORKOAL SPOINK SPINDA TRAPINCH CACNEA
     SWABLU ZANGOOSE SEVIPER LUNATONE SOLROCK BARBOACH CORPHISH BALTOY LILEEP ANORITH FEEBAS CASTFORM
     KECLEON SHUPPET DUSKULL TROPIUS ABSOL WYNAUT SNORUNT SPHEAL CLAMPERL RELICANTH LUVDISC BAGON BELDUM
     TURTWIG CHIMCHAR PIPLUP STARLY BIDOOF KRICKETOT SHINX BUDEW CRANIDOS SHIELDON BURMY COMBEE PACHIRISU
     BUIZEL CHERUBI SHELLOS DRIFLOON BUNEARY GLAMEOW CHINGLING STUNKY BRONZOR BONSLY MIMEJR HAPPINY
     CHATOT SPIRITOMB GIBLE MUNCHLAX RIOLU HIPPOPOTAS SKORUPI CROAGUNK CARNIVINE FINNEON MANTYKE SNOVER
     ROTOM SNIVY TEPIG OSHAWOTT PATRAT LILLIPUP PURRLOIN PANSAGE PANSEAR PANPOUR MUNNA PIDOVE BLITZLE
     ROGGENROLA WOOBAT DRILBUR AUDINO TIMBURR TYMPOLE THROH SAWK SEWADDLE VENIPEDE COTTONEE PETILIL
     BASCULIN SANDILE DARUMAKA MARACTUS DWEBBLE SCRAGGY SIGILYPH YAMASK TIRTOUGA ARCHEN TRUBBISH ZORUA
     MINCCINO GOTHITA SOLOSIS DUCKLETT VANILLITE DEERLING EMOLGA KARRABLAST FOONGUS FRILLISH ALOMOMOLA
     JOLTIK FERROSEED KLINK TYNAMO ELGYEM LITWICK AXEW CUBCHOO CRYOGONAL SHELMET STUNFISK MIENFOO
     DRUDDIGON GOLETT PAWNIARD BOUFFALANT RUFFLET VULLABY HEATMOR DURANT DEINO LARVESTA]
end

# Returns array of mythical and legendary Pokémon
def getLegendOrMythic
  %i[ARTICUNO ZAPDOS MOLTRES
     RAIKOU ENTEI SUICUNE
     REGIROCK REGICE REGISTEEL
     LATIAS LATIOS
     UXIE MESPRIT AZELF
     HEATRAN REGIGIGAS CRESSELIA
     COBALION TERRAKION VIRIZION
     TORNADUS THUNDURUS LANDORUS
     TYPENULL SILVALLY
     TAPUKOKO TAPULELE TAPUBULU TAPUFINI
     NIHILEGO BUZZWOLE PHEROMOSA XURKITREE
     CELESTEELA KARTANA GUZZLORD POIPOLE
     NAGANADEL STAKATAKA BLACEPHALON
     KUBFU URSHIFU
     REGIELEKI REGIDRAGO
     GLASTRIER SPECTRIER
     MEWTWO LUGIA HOOH
     KYOGRE GROUDON RAYQUAZA
     DIALGA PALKIA GIRATINA
     RESHIRAM ZEKROM KYUREM
     XERNEAS YVELTAL ZYGARDE
     COSMOG COSMOEM
     SOLGALEO LUNALA NECROZMA
     ZACIAN ZAMAZENTA
     ETERNATUS CALYREX
     MEW CELEBI JIRACHI
     DEOXYS PHIONE MANAPHY
     DARKRAI SHAYMIN ARCEUS
     VICTINI KELDEO MELOETTA GENESECT
     DIANCIE HOOPA VOLCANION
     MAGEARNA MARSHADOW ZERAORA
     MELTAN MELMETAL ZARUDE]
end

# Unused utility method that returns the base stat total (BST) for given Pokémon
def getBaseStatTotal(pokemon)
  baseTotal = 0
  GameData::Stat.each_main do |s|
    baseTotal += pokemon.base_stats[s.id]
  end
  baseTotal
end
