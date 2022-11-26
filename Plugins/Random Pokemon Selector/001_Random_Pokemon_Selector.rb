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

# Unused utility method that gets all Pokemon with BST between bstMin and bstMax (boundries included)
def pbGetGen8PkmnByBST(bstMin, bstMax)
    output =[]
    getGen8Pkmn.each do |pkmn|
        output.push(pkmn) if bstMin <= getBaseStatTotal(GameData::Species.try_get(pkmn)) && getBaseStatTotal(GameData::Species.try_get(pkmn)) <= bstMax
    end
    pbMessage(bstMin.to_s + "to " + bstMax.to_s)
    pbMessage(getGen8Pkmn.length.to_s)
    pbWriteIntoFile(bstMin.to_s+" to "+bstMax.to_s+".txt", "%i"+output.to_s.gsub(/[:\,]/, ''))
end

#Count:803
def getGen8Pkmn
%i[BULBASAUR IVYSAUR VENUSAUR CHARMANDER CHARMELEON CHARIZARD SQUIRTLE WARTORTLE BLASTOISE CATERPIE METAPOD BUTTERFREE WEEDLE KAKUNA BEEDRILL PIDGEY PIDGEOTTO PIDGEOT RATTATA RATICATE SPEAROW FEAROW EKANS ARBOK PIKACHU RAICHU SANDSHREW SANDSLASH NIDORANfE NIDORINA NIDOQUEEN NIDORANmA NIDORINO NIDOKING CLEFAIRY CLEFABLE VULPIX NINETALES JIGGLYPUFF WIGGLYTUFF ZUBAT GOLBAT ODDISH GLOOM VILEPLUME PARAS PARASECT VENONAT VENOMOTH DIGLETT DUGTRIO MEOWTH PERSIAN PSYDUCK GOLDUCK MANKEY PRIMEAPE GROWLITHE ARCANINE POLIWAG POLIWHIRL POLIWRATH ABRA KADABRA ALAKAZAM MACHOP MACHOKE MACHAMP BELLSPROUT WEEPINBELL VICTREEBEL TENTACOOL TENTACRUEL GEODUDE GRAVELER GOLEM PONYTA RAPIDASH SLOWPOKE SLOWBRO MAGNEMITE MAGNETON FARFETCHD DODUO DODRIO SEEL DEWGONG GRIMER MUK SHELLDER CLOYSTER GASTLY HAUNTER GENGAR ONIX DROWZEE HYPNO KRABBY KINGLER VOLTORB ELECTRODE EXEGGCUTE EXEGGUTOR CUBONE MAROWAK HITMONLEE HITMONCHAN LICKITUNG KOFFING WEEZING RHYHORN RHYDON CHANSEY TANGELA KANGASKHAN HORSEA SEADRA GOLDEEN SEAKING STARYU STARMIE MRMIME SCYTHER JYNX ELECTABUZZ MAGMAR PINSIR TAUROS MAGIKARP GYARADOS LAPRAS DITTO EEVEE VAPOREON JOLTEON FLAREON PORYGON OMANYTE OMASTAR KABUTO KABUTOPS AERODACTYL SNORLAX DRATINI DRAGONAIR DRAGONITE CHIKORITA BAYLEEF MEGANIUM CYNDAQUIL QUILAVA TYPHLOSION TOTODILE CROCONAW FERALIGATR HOOTHOOT NOCTOWL SENTRET FURRET PICHU LEDYBA LEDIAN SPINARAK ARIADOS CROBAT CLEFFA IGGLYBUFF TOGEPI TOGETIC DUNSPARCE MAREEP FLAAFFY AMPHAROS WOOPER QUAGSIRE UNOWN STEELIX HOPPIP SKIPLOOM JUMPLUFF POLITOED SLOWKING BELLOSSOM PINECO FORRETRESS YANMA YANMEGA SUNKERN SUNFLORA SUDOWOODO WOBBUFFET SCIZOR HERACROSS AIPOM AMBIPOM SNUBBULL GRANBULL STANTLER MARILL AZUMARILL TYROGUE HITMONTOP GIRAFARIG MILTANK MAGBY SMOOCHUM ELEKID SMEARGLE NATU XATU QWILFISH SHUCKLE CORSOLA REMORAID OCTILLERY CHINCHOU LANTURN LICKILICKY TANGROWTH ESPEON UMBREON KINGDRA GLIGAR DELIBIRD SWINUB PILOSWINE MAMOSWINE TEDDIURSA URSARING PHANPY DONPHAN MANTINE SKARMORY MURKROW HOUNDOUR HOUNDOOM SLUGMA MAGCARGO SNEASEL MISDREAVUS PORYGON2 BLISSEY LARVITAR PUPITAR TYRANITAR TREECKO GROVYLE SCEPTILE TORCHIC COMBUSKEN BLAZIKEN MUDKIP MARSHTOMP SWAMPERT POOCHYENA MIGHTYENA ZIGZAGOON LINOONE WURMPLE SILCOON BEAUTIFLY CASCOON DUSTOX LOTAD LOMBRE LUDICOLO SEEDOT NUZLEAF SHIFTRY TAILLOW SWELLOW WINGULL PELIPPER RALTS KIRLIA GARDEVOIR SURSKIT MASQUERAIN SHROOMISH BRELOOM SLAKOTH VIGOROTH SLAKING NINCADA NINJASK SHEDINJA WHISMUR LOUDRED EXPLOUD MAKUHITA HARIYAMA AZURILL NOSEPASS SKITTY DELCATTY SABLEYE MAWILE ARON LAIRON AGGRON MEDITITE MEDICHAM ELECTRIKE MANECTRIC PLUSLE MINUN ROSELIA GULPIN SWALOT CARVANHA SHARPEDO WAILMER WAILORD NUMEL CAMERUPT TORKOAL SPOINK GRUMPIG SPINDA TRAPINCH VIBRAVA FLYGON CACNEA CACTURNE SWABLU ALTARIA ZANGOOSE SEVIPER LUNATONE SOLROCK BARBOACH WHISCASH CORPHISH CRAWDAUNT BALTOY CLAYDOL LILEEP CRADILY ANORITH ARMALDO FEEBAS MILOTIC CASTFORM KECLEON SHUPPET BANETTE DUSKULL DUSCLOPS TROPIUS CHIMECHO ABSOL WYNAUT SNORUNT GLALIE SPHEAL SEALEO CLAMPERL HUNTAIL GOREBYSS RELICANTH LUVDISC BAGON SHELGON SALAMENCE BELDUM METANG METAGROSS TURTWIG GROTLE TORTERRA CHIMCHAR MONFERNO INFERNAPE PIPLUP PRINPLUP EMPOLEON STARLY STARAVIA STARAPTOR BIDOOF BIBAREL KRICKETOT KRICKETUNE SHINX LUXIO LUXRAY BUDEW ROSERADE CRANIDOS RAMPARDOS SHIELDON BASTIODON BURMY WORMADAM MOTHIM COMBEE VESPIQUEN PACHIRISU BUIZEL FLOATZEL CHERUBI CHERRIM SHELLOS GASTRODON DRIFLOON DRIFBLIM BUNEARY LOPUNNY MISMAGIUS HONCHKROW GLAMEOW PURUGLY CHINGLING STUNKY SKUNTANK BRONZOR BRONZONG BONSLY MIMEJR HAPPINY CHATOT SPIRITOMB GIBLE GABITE GARCHOMP MUNCHLAX RIOLU LUCARIO HIPPOPOTAS HIPPOWDON SKORUPI DRAPION CROAGUNK TOXICROAK CARNIVINE FINNEON LUMINEON MANTYKE SNOVER ABOMASNOW WEAVILE MAGNEZONE RHYPERIOR ELECTIVIRE MAGMORTAR TOGEKISS LEAFEON GLACEON GLISCOR PORYGONZ GALLADE PROBOPASS DUSKNOIR FROSLASS ROTOM SNIVY SERVINE SERPERIOR TEPIG PIGNITE EMBOAR OSHAWOTT DEWOTT SAMUROTT PATRAT WATCHOG LILLIPUP HERDIER STOUTLAND PURRLOIN LIEPARD PANSAGE SIMISAGE PANSEAR SIMISEAR PANPOUR SIMIPOUR MUNNA MUSHARNA PIDOVE TRANQUILL UNFEZANT BLITZLE ZEBSTRIKA ROGGENROLA BOLDORE GIGALITH WOOBAT SWOOBAT DRILBUR EXCADRILL AUDINO TIMBURR GURDURR CONKELDURR TYMPOLE PALPITOAD SEISMITOAD THROH SAWK SEWADDLE SWADLOON LEAVANNY VENIPEDE WHIRLIPEDE SCOLIPEDE COTTONEE WHIMSICOTT PETILIL LILLIGANT BASCULIN SANDILE KROKOROK KROOKODILE DARUMAKA DARMANITAN MARACTUS DWEBBLE CRUSTLE SCRAGGY SCRAFTY SIGILYPH YAMASK COFAGRIGUS TIRTOUGA CARRACOSTA ARCHEN ARCHEOPS TRUBBISH GARBODOR ZORUA ZOROARK MINCCINO CINCCINO GOTHITA GOTHORITA GOTHITELLE SOLOSIS DUOSION REUNICLUS DUCKLETT SWANNA VANILLITE VANILLISH VANILLUXE DEERLING SAWSBUCK EMOLGA KARRABLAST ESCAVALIER FOONGUS AMOONGUSS FRILLISH JELLICENT ALOMOMOLA JOLTIK GALVANTULA FERROSEED FERROTHORN KLINK KLANG KLINKLANG TYNAMO EELEKTRIK EELEKTROSS ELGYEM BEHEEYEM LITWICK LAMPENT CHANDELURE AXEW FRAXURE HAXORUS CUBCHOO BEARTIC CRYOGONAL SHELMET ACCELGOR STUNFISK MIENFOO MIENSHAO DRUDDIGON GOLETT GOLURK PAWNIARD BISHARP BOUFFALANT RUFFLET BRAVIARY VULLABY MANDIBUZZ HEATMOR DURANT DEINO ZWEILOUS HYDREIGON LARVESTA VOLCARONA CHESPIN QUILLADIN CHESNAUGHT FENNEKIN BRAIXEN DELPHOX FROAKIE FROGADIER GRENINJA BUNNELBY DIGGERSBY FLETCHLING FLETCHINDER TALONFLAME SCATTERBUG SPEWPA VIVILLON LITLEO PYROAR FLABEBE FLOETTE FLORGES SKIDDO GOGOAT PANCHAM PANGORO FURFROU ESPURR MEOWSTIC HONEDGE DOUBLADE AEGISLASH SPRITZEE AROMATISSE SWIRLIX SLURPUFF INKAY MALAMAR BINACLE BARBARACLE SKRELP DRAGALGE CLAUNCHER CLAWITZER HELIOPTILE HELIOLISK TYRUNT TYRANTRUM AMAURA AURORUS SYLVEON HAWLUCHA DEDENNE CARBINK GOOMY SLIGGOO GOODRA KLEFKI PHANTUMP TREVENANT PUMPKABOO GOURGEIST BERGMITE AVALUGG NOIBAT NOIVERN ROWLET DARTRIX DECIDUEYE LITTEN TORRACAT INCINEROAR POPPLIO BRIONNE PRIMARINA PIKIPEK TRUMBEAK TOUCANNON YUNGOOS GUMSHOOS GRUBBIN CHARJABUG VIKAVOLT CRABRAWLER CRABOMINABLE ORICORIO CUTIEFLY RIBOMBEE ROCKRUFF LYCANROC WISHIWASHI MAREANIE TOXAPEX MUDBRAY MUDSDALE DEWPIDER ARAQUANID FOMANTIS LURANTIS MORELULL SHIINOTIC SALANDIT SALAZZLE STUFFUL BEWEAR BOUNSWEET STEENEE TSAREENA COMFEY ORANGURU PASSIMIAN WIMPOD GOLISOPOD SANDYGAST PALOSSAND PYUKUMUKU MINIOR KOMALA TURTONATOR TOGEDEMARU MIMIKYU BRUXISH DRAMPA DHELMISE JANGMOO HAKAMOO KOMMOO GROOKEY THWACKEY RILLABOOM SCORBUNNY RABOOT CINDERACE SOBBLE DRIZZILE INTELEON SKWOVET GREEDENT ROOKIDEE CORVISQUIRE CORVIKNIGHT BLIPBUG DOTTLER ORBEETLE NICKIT THIEVUL GOSSIFLEUR ELDEGOSS WOOLOO DUBWOOL CHEWTLE DREDNAW YAMPER BOLTUND ROLYCOLY CARKOL COALOSSAL APPLIN FLAPPLE APPLETUN SILICOBRA SANDACONDA CRAMORANT ARROKUDA BARRASKEWDA TOXEL TOXTRICITY SIZZLIPEDE CENTISKORCH CLOBBOPUS GRAPPLOCT SINISTEA POLTEAGEIST HATENNA HATTREM HATTERENE IMPIDIMP MORGREM GRIMMSNARL OBSTAGOON PERRSERKER CURSOLA SIRFETCHD MRRIME RUNERIGUS MILCERY ALCREMIE FALINKS PINCURCHIN SNOM FROSMOTH STONJOURNER EISCUE INDEEDEE MORPEKO CUFANT COPPERAJAH DRACOZOLT ARCTOZOLT DRACOVISH ARCTOVISH DURALUDON DREEPY DRAKLOAK DRAGAPULT]
end

#Count:402
def getGen8NFE
%i[BULBASAUR IVYSAUR CHARMANDER CHARMELEON SQUIRTLE WARTORTLE CATERPIE METAPOD WEEDLE KAKUNA PIDGEY PIDGEOTTO RATTATA SPEAROW EKANS PIKACHU SANDSHREW NIDORANfE NIDORINA NIDORANmA NIDORINO CLEFAIRY VULPIX JIGGLYPUFF ZUBAT GOLBAT ODDISH GLOOM PARAS VENONAT DIGLETT MEOWTH PSYDUCK MANKEY GROWLITHE POLIWAG POLIWHIRL ABRA KADABRA MACHOP MACHOKE BELLSPROUT WEEPINBELL TENTACOOL GEODUDE GRAVELER PONYTA SLOWPOKE MAGNEMITE MAGNETON FARFETCHD DODUO SEEL GRIMER SHELLDER GASTLY HAUNTER ONIX DROWZEE KRABBY VOLTORB EXEGGCUTE CUBONE LICKITUNG KOFFING RHYHORN RHYDON CHANSEY TANGELA HORSEA SEADRA GOLDEEN STARYU MRMIME SCYTHER ELECTABUZZ MAGMAR MAGIKARP EEVEE PORYGON OMANYTE KABUTO DRATINI DRAGONAIR CHIKORITA BAYLEEF CYNDAQUIL QUILAVA TOTODILE CROCONAW HOOTHOOT SENTRET PICHU LEDYBA SPINARAK CLEFFA IGGLYBUFF TOGEPI TOGETIC MAREEP FLAAFFY WOOPER HOPPIP SKIPLOOM PINECO YANMA SUNKERN AIPOM SNUBBULL MARILL TYROGUE MAGBY SMOOCHUM ELEKID NATU CORSOLA REMORAID CHINCHOU GLIGAR SWINUB PILOSWINE TEDDIURSA PHANPY MURKROW HOUNDOUR SLUGMA SNEASEL MISDREAVUS PORYGON2 LARVITAR PUPITAR TREECKO GROVYLE TORCHIC COMBUSKEN MUDKIP MARSHTOMP POOCHYENA ZIGZAGOON LINOONE WURMPLE SILCOON CASCOON LOTAD LOMBRE SEEDOT NUZLEAF TAILLOW WINGULL RALTS KIRLIA SURSKIT SHROOMISH SLAKOTH VIGOROTH NINCADA WHISMUR LOUDRED MAKUHITA AZURILL NOSEPASS SKITTY ARON LAIRON MEDITITE ELECTRIKE ROSELIA GULPIN CARVANHA WAILMER NUMEL SPOINK TRAPINCH VIBRAVA CACNEA SWABLU BARBOACH CORPHISH BALTOY LILEEP ANORITH FEEBAS SHUPPET DUSKULL DUSCLOPS WYNAUT SNORUNT SPHEAL SEALEO CLAMPERL BAGON SHELGON BELDUM METANG TURTWIG GROTLE CHIMCHAR MONFERNO PIPLUP PRINPLUP STARLY STARAVIA BIDOOF KRICKETOT SHINX LUXIO BUDEW CRANIDOS SHIELDON BURMY COMBEE BUIZEL CHERUBI SHELLOS DRIFLOON BUNEARY GLAMEOW CHINGLING STUNKY BRONZOR BONSLY MIMEJR HAPPINY GIBLE GABITE MUNCHLAX RIOLU HIPPOPOTAS SKORUPI CROAGUNK FINNEON MANTYKE SNOVER SNIVY SERVINE TEPIG PIGNITE OSHAWOTT DEWOTT PATRAT LILLIPUP HERDIER PURRLOIN PANSAGE PANSEAR PANPOUR MUNNA PIDOVE TRANQUILL BLITZLE ROGGENROLA BOLDORE WOOBAT DRILBUR TIMBURR GURDURR TYMPOLE PALPITOAD SEWADDLE SWADLOON VENIPEDE WHIRLIPEDE COTTONEE PETILIL SANDILE KROKOROK DARUMAKA DWEBBLE SCRAGGY YAMASK TIRTOUGA ARCHEN TRUBBISH ZORUA MINCCINO GOTHITA GOTHORITA SOLOSIS DUOSION DUCKLETT VANILLITE VANILLISH DEERLING KARRABLAST FOONGUS FRILLISH JOLTIK FERROSEED KLINK KLANG TYNAMO EELEKTRIK ELGYEM LITWICK LAMPENT AXEW FRAXURE CUBCHOO SHELMET MIENFOO GOLETT PAWNIARD RUFFLET VULLABY DEINO ZWEILOUS LARVESTA CHESPIN QUILLADIN FENNEKIN BRAIXEN FROAKIE FROGADIER BUNNELBY FLETCHLING FLETCHINDER SCATTERBUG SPEWPA LITLEO FLABEBE FLOETTE SKIDDO PANCHAM ESPURR HONEDGE DOUBLADE SPRITZEE SWIRLIX INKAY BINACLE SKRELP CLAUNCHER HELIOPTILE TYRUNT AMAURA GOOMY SLIGGOO PHANTUMP PUMPKABOO BERGMITE NOIBAT ROWLET DARTRIX LITTEN TORRACAT POPPLIO BRIONNE PIKIPEK TRUMBEAK YUNGOOS GRUBBIN CHARJABUG CRABRAWLER CUTIEFLY ROCKRUFF MAREANIE MUDBRAY DEWPIDER FOMANTIS MORELULL SALANDIT STUFFUL BOUNSWEET STEENEE WIMPOD SANDYGAST JANGMOO HAKAMOO GROOKEY THWACKEY SCORBUNNY RABOOT SOBBLE DRIZZILE SKWOVET ROOKIDEE CORVISQUIRE BLIPBUG DOTTLER NICKIT GOSSIFLEUR WOOLOO CHEWTLE YAMPER ROLYCOLY CARKOL APPLIN SILICOBRA ARROKUDA TOXEL SIZZLIPEDE CLOBBOPUS SINISTEA HATENNA HATTREM IMPIDIMP MORGREM MILCERY SNOM CUFANT DREEPY DRAKLOAK]
end

######################################### Pokémon Pools for Oak #########################################
##### Legi #####
#Count:85
def getOakLegendOrMythic
  %i[ARTICUNO ZAPDOS MOLTRES
     RAIKOU ENTEI SUICUNE
     REGIROCK REGICE REGISTEEL
     LATIAS LATIOS
     UXIE MESPRIT AZELF
     HEATRAN REGIGIGAS CRESSELIA
     COBALION TERRAKION VIRIZION
     TORNADUS THUNDURUS LANDORUS
     SILVALLY
     TAPUKOKO TAPULELE TAPUBULU TAPUFINI
     NIHILEGO BUZZWOLE PHEROMOSA XURKITREE
     CELESTEELA KARTANA GUZZLORD
     NAGANADEL STAKATAKA BLACEPHALON
     URSHIFU
     REGIELEKI REGIDRAGO
     GLASTRIER SPECTRIER
     MEWTWO LUGIA HOOH
     KYOGRE GROUDON RAYQUAZA
     DIALGA PALKIA GIRATINA
     RESHIRAM ZEKROM KYUREM
     XERNEAS YVELTAL ZYGARDE
     SOLGALEO LUNALA NECROZMA
     ZACIAN ZAMAZENTA
     ETERNATUS CALYREX
     MEW CELEBI JIRACHI
     DEOXYS MANAPHY
     DARKRAI SHAYMIN ARCEUS
     VICTINI KELDEO MELOETTA GENESECT
     DIANCIE HOOPA VOLCANION
     MAGEARNA MARSHADOW ZERAORA
     MELMETAL ZARUDE]
end

##### F1 #####
# 0 <= BST <= 241, Odds: Ultra rare
def getOakPool1
# Count: 37
%i[CATERPIE METAPOD WEEDLE KAKUNA MAGIKARP SENTRET PICHU CLEFFA IGGLYBUFF WOOPER SUNKERN TYROGUE POOCHYENA ZIGZAGOON WURMPLE SILCOON CASCOON LOTAD SEEDOT RALTS SHEDINJA WHISMUR MAKUHITA AZURILL FEEBAS KRICKETOT BURMY HAPPINY BUNNELBY SCATTERBUG SPEWPA WISHIWASHI BOUNSWEET WIMPOD BLIPBUG ROLYCOLY SNOM]
end

# 242 <= BST <= 277, Odds: Rare
def getOakPool2
# Count: 51
%i[PIDGEY RATTATA SPEAROW NIDORANfE NIDORANmA JIGGLYPUFF ZUBAT DIGLETT HOOTHOOT LEDYBA SPINARAK TOGEPI HOPPIP MARILL SMEARGLE SWINUB SLUGMA TAILLOW WINGULL SURSKIT NINCADA SKITTY WYNAUT STARLY BIDOOF SHINX COMBEE CHERUBI PATRAT LILLIPUP PIDOVE VENIPEDE TYNAMO LITWICK NOIBAT PIKIPEK YUNGOOS DEWPIDER FOMANTIS SKWOVET ROOKIDEE NICKIT GOSSIFLEUR WOOLOO YAMPER APPLIN TOXEL HATENNA IMPIDIMP MILCERY DREEPY]
end

# 278 <= BST <= 299, Odds: Often
def getOakPool3
# Count: 41
%i[EKANS VULPIX PARAS MEOWTH HORSEA DITTO MAREEP PINECO KIRLIA SHROOMISH SLAKOTH MEDITITE ELECTRIKE TRAPINCH BARBOACH SHUPPET DUSKULL SPHEAL BUDEW CHINGLING BONSLY RIOLU PURRLOIN MUNNA BLITZLE ROGGENROLA TYMPOLE COTTONEE PETILIL SANDILE GOTHITA SOLOSIS FOONGUS FLETCHLING INKAY HELIOPTILE ROCKRUFF MORELULL STEENEE CHEWTLE ARROKUDA]
end

# 300 <= BST <= 376, Odds: Rare
def getOakPool4
# Count: 194
%i[BULBASAUR CHARMANDER SQUIRTLE PIDGEOTTO PIKACHU SANDSHREW NIDORINA NIDORINO CLEFAIRY ODDISH VENONAT PSYDUCK MANKEY GROWLITHE POLIWAG ABRA MACHOP BELLSPROUT TENTACOOL GEODUDE SLOWPOKE MAGNEMITE DODUO SEEL GRIMER SHELLDER GASTLY DROWZEE KRABBY VOLTORB EXEGGCUTE CUBONE KOFFING RHYHORN GOLDEEN STARYU EEVEE OMANYTE KABUTO DRATINI CHIKORITA CYNDAQUIL TOTODILE FLAAFFY UNOWN SKIPLOOM AIPOM SNUBBULL MAGBY SMOOCHUM ELEKID NATU REMORAID CHINCHOU DELIBIRD TEDDIURSA PHANPY HOUNDOUR LARVITAR TREECKO TORCHIC MUDKIP LOMBRE NUZLEAF LOUDRED NOSEPASS ARON GULPIN CARVANHA NUMEL SPOINK SPINDA VIBRAVA CACNEA SWABLU CORPHISH BALTOY LILEEP ANORITH SNORUNT CLAMPERL LUVDISC BAGON BELDUM TURTWIG CHIMCHAR PIPLUP STARAVIA LUXIO CRANIDOS SHIELDON BUIZEL SHELLOS DRIFLOON BUNEARY GLAMEOW STUNKY BRONZOR MIMEJR GIBLE HIPPOPOTAS SKORUPI CROAGUNK FINNEON MANTYKE SNOVER SNIVY TEPIG OSHAWOTT HERDIER PANSAGE PANSEAR PANPOUR TRANQUILL WOOBAT DRILBUR TIMBURR SEWADDLE WHIRLIPEDE KROKOROK DARUMAKA DWEBBLE SCRAGGY YAMASK TIRTOUGA TRUBBISH ZORUA MINCCINO DUOSION DUCKLETT VANILLITE DEERLING KARRABLAST FRILLISH JOLTIK FERROSEED KLINK ELGYEM LAMPENT AXEW CUBCHOO SHELMET MIENFOO GOLETT PAWNIARD RUFFLET VULLABY DEINO LARVESTA CHESPIN FENNEKIN FROAKIE LITLEO FLABEBE FLOETTE SKIDDO PANCHAM ESPURR HONEDGE SPRITZEE SWIRLIX BINACLE SKRELP CLAUNCHER TYRUNT AMAURA GOOMY PHANTUMP PUMPKABOO BERGMITE ROWLET LITTEN POPPLIO TRUMBEAK GRUBBIN CRABRAWLER CUTIEFLY MAREANIE SALANDIT STUFFUL SANDYGAST JANGMOO GROOKEY SCORBUNNY SOBBLE CORVISQUIRE DOTTLER SILICOBRA SIZZLIPEDE CLOBBOPUS SINISTEA HATTREM MORGREM CUFANT]
end

##### F2 #####
# 377 <= BST <= 399, Odds: Rare
def getOakPool5
# Count: 25
%i[BUTTERFREE BEEDRILL GLOOM POLIWHIRL WEEPINBELL GRAVELER FARFETCHD ONIX LICKITUNG PORYGON LEDIAN YANMA BEAUTIFLY DUSTOX SABLEYE MAWILE KRICKETUNE MUNCHLAX BOLDORE PALPITOAD SWADLOON GOTHORITA VANILLISH FLETCHINDER MUDBRAY]
end

# 400 <= BST <= 419, Odds: Often
def getOakPool6
# Count: 55
%i[IVYSAUR CHARMELEON WARTORTLE RATICATE PARASECT KADABRA MACHOKE PONYTA HAUNTER BAYLEEF QUILAVA CROCONAW FURRET ARIADOS TOGETIC DUNSPARCE SUDOWOODO WOBBUFFET CORSOLA MURKROW PUPITAR GROVYLE COMBUSKEN MARSHTOMP DELCATTY MEDICHAM PLUSLE MINUN ROSELIA WAILMER SEALEO GROTLE MONFERNO PRINPLUP BIBAREL PACHIRISU CHATOT GABITE SERVINE PIGNITE DEWOTT GURDURR ARCHEN EELEKTRIK FRAXURE QUILLADIN BRAIXEN FROGADIER VIVILLON GUMSHOOS CHARJABUG SHIINOTIC PYUKUMUKU CARKOL DRAKLOAK]
end

# 420 <= BST <= 463, Odds: Rare
def getOakPool7
# Count: 94
%i[FEAROW ARBOK SANDSLASH WIGGLYTUFF GOLBAT VENOMOTH DUGTRIO PERSIAN PRIMEAPE MAROWAK HITMONLEE HITMONCHAN CHANSEY TANGELA SEADRA SEAKING MRMIME JYNX DRAGONAIR NOCTOWL QUAGSIRE JUMPLUFF SUNFLORA GRANBULL AZUMARILL HITMONTOP GIRAFARIG QWILFISH LANTURN GLIGAR PILOSWINE MAGCARGO SNEASEL MISDREAVUS MIGHTYENA LINOONE SWELLOW PELIPPER MASQUERAIN BRELOOM VIGOROTH NINJASK LAIRON SHARPEDO CAMERUPT ZANGOOSE SEVIPER LUNATONE SOLROCK CASTFORM KECLEON BANETTE DUSCLOPS TROPIUS CHIMECHO SHELGON METANG WORMADAM MOTHIM CHERRIM PURUGLY CARNIVINE LUMINEON ROTOM WATCHOG LIEPARD SWOOBAT AUDINO BASCULIN MARACTUS EMOLGA KLANG ZWEILOUS DIGGERSBY DOUBLADE AROMATISSE DEDENNE SLIGGOO DARTRIX TORRACAT BRIONNE ARAQUANID MINIOR TOGEDEMARU HAKAMOO THWACKEY RABOOT DRIZZILE GREEDENT THIEVUL ELDEGOSS PERRSERKER PINCURCHIN MORPEKO]
end

##### F3+F4 #####
# 464 <= BST <= 488, Odds F3: Rare
def getOakPool8
# Count: 95
%i[RAICHU CLEFABLE HYPNO RHYDON AMBIPOM OCTILLERY MANTINE LUDICOLO SHIFTRY GLALIE HUNTAIL GOREBYSS RELICANTH STARAPTOR LOPUNNY SPIRITOMB FROSLASS MUSHARNA UNFEZANT SCOLIPEDE WHIMSICOTT LILLIGANT DARMANITAN CRUSTLE SCRAFTY COFAGRIGUS JELLICENT BEHEEYEM DRUDDIGON GOLURK HEATMOR DURANT SLURPUFF MALAMAR HELIOLISK TOUCANNON LYCANROC LURANTIS SALAZZLE COMFEY PALOSSAND KOMALA TURTONATOR DRAMPA DREDNAW FLAPPLE APPLETUN GRAPPLOCT RUNERIGUS PIDGEOT MAGNETON DODRIO DEWGONG KINGLER FORRETRESS STANTLER XATU SKARMORY HARIYAMA MANECTRIC SWALOT TORKOAL GRUMPIG CACTURNE WHISCASH CRAWDAUNT ABSOL VESPIQUEN GASTRODON SKUNTANK THROH SAWK GARBODOR CINCCINO SWANNA SAWSBUCK AMOONGUSS ALOMOMOLA GALVANTULA STUNFISK FURFROU MEOWSTIC KLEFKI TREVENANT CRABOMINABLE ORICORIO RIBOMBEE MIMIKYU BRUXISH CRAMORANT FALINKS FROSMOTH STONJOURNER EISCUE INDEEDEE]
end

# 489 <= BST <= 499, Odds F3: Often, Odds F4: Rare
def getOakPool9
# Count: 51
%i[VILEPLUME VICTREEBEL GOLEM SLOWBRO ELECTRODE WEEZING KANGASKHAN ELECTABUZZ MAGMAR TAUROS OMASTAR KABUTOPS SLOWKING BELLOSSOM MILTANK EXPLOUD ALTARIA CRADILY ARMALDO RAMPARDOS BASTIODON FLOATZEL DRIFBLIM MISMAGIUS TOXICROAK ABOMASNOW SIMISAGE SIMISEAR SIMIPOUR ZEBSTRIKA SIGILYPH CARRACOSTA GOTHITELLE REUNICLUS ESCAVALIER FERROTHORN ACCELGOR BISHARP BOUFFALANT TALONFLAME PANGORO DRAGALGE GOURGEIST TOXAPEX ORANGURU PASSIMIAN CORVIKNIGHT DUBWOOL BOLTUND BARRASKEWDA ALCREMIE]
end

# 500 <= BST <= 534, Odds F3: Rare, Odds F4: Often
def getOakPool10
# Count: 127
%i[VENUSAUR CHARIZARD BLASTOISE NIDOQUEEN NIDOKING NINETALES GOLDUCK POLIWRATH ALAKAZAM MACHAMP TENTACRUEL RAPIDASH MUK CLOYSTER GENGAR EXEGGUTOR STARMIE SCYTHER PINSIR VAPOREON JOLTEON FLAREON AERODACTYL MEGANIUM TYPHLOSION FERALIGATR AMPHAROS STEELIX POLITOED YANMEGA SCIZOR HERACROSS SHUCKLE LICKILICKY ESPEON UMBREON MAMOSWINE URSARING DONPHAN HOUNDOOM PORYGON2 SCEPTILE BLAZIKEN GARDEVOIR AGGRON WAILORD FLYGON CLAYDOL TORTERRA INFERNAPE EMPOLEON LUXRAY ROSERADE HONCHKROW BRONZONG LUCARIO HIPPOWDON DRAPION WEAVILE LEAFEON GLACEON GLISCOR GALLADE PROBOPASS DUSKNOIR SERPERIOR EMBOAR SAMUROTT STOUTLAND GIGALITH EXCADRILL CONKELDURR SEISMITOAD LEAVANNY KROOKODILE ZOROARK KLINKLANG EELEKTROSS CHANDELURE BEARTIC CRYOGONAL MIENSHAO BRAVIARY MANDIBUZZ CHESNAUGHT DELPHOX GRENINJA PYROAR GOGOAT AEGISLASH BARBARACLE CLAWITZER TYRANTRUM AURORUS SYLVEON HAWLUCHA CARBINK AVALUGG DECIDUEYE INCINEROAR PRIMARINA VIKAVOLT MUDSDALE BEWEAR TSAREENA GOLISOPOD DHELMISE RILLABOOM CINDERACE INTELEON ORBEETLE COALOSSAL SANDACONDA TOXTRICITY CENTISKORCH POLTEAGEIST HATTERENE GRIMMSNARL OBSTAGOON CURSOLA SIRFETCHD MRRIME COPPERAJAH DRACOZOLT ARCTOZOLT DRACOVISH ARCTOVISH]
end

# 535 <= BST <= 670, Odds F3: Ultra Rare, Odds F4: Rare
def getOakPool11
# Count: 33
%i[GYARADOS LAPRAS SNORLAX CROBAT TANGROWTH KINGDRA BLISSEY SWAMPERT MILOTIC MAGNEZONE RHYPERIOR ELECTIVIRE MAGMORTAR TOGEKISS PORYGONZ VANILLUXE HAXORUS NOIVERN DURALUDON ARCANINE DRAGONITE TYRANITAR SLAKING SALAMENCE METAGROSS GARCHOMP ARCHEOPS HYDREIGON VOLCARONA FLORGES GOODRA KOMMOO DRAGAPULT]
end

##### Lucky Weakling mode #####

##### F1, F2, F3, F4
# 0 <= BST <= 241, Odds F1: Ultra Rare
def getOakPoolLW1
# Count: 35
%i[CATERPIE METAPOD WEEDLE KAKUNA MAGIKARP SENTRET PICHU CLEFFA IGGLYBUFF WOOPER SUNKERN TYROGUE POOCHYENA ZIGZAGOON WURMPLE SILCOON CASCOON LOTAD SEEDOT RALTS WHISMUR MAKUHITA AZURILL FEEBAS KRICKETOT BURMY HAPPINY BUNNELBY SCATTERBUG SPEWPA BOUNSWEET WIMPOD BLIPBUG ROLYCOLY SNOM]
end

# 242 <= BST <= 277, Odds F1: Rare
def getOakPoolLW2
# Count: 50
%i[PIDGEY RATTATA SPEAROW NIDORANfE NIDORANmA JIGGLYPUFF ZUBAT DIGLETT HOOTHOOT LEDYBA SPINARAK TOGEPI HOPPIP MARILL SWINUB SLUGMA TAILLOW WINGULL SURSKIT NINCADA SKITTY WYNAUT STARLY BIDOOF SHINX COMBEE CHERUBI PATRAT LILLIPUP PIDOVE VENIPEDE TYNAMO LITWICK NOIBAT PIKIPEK YUNGOOS DEWPIDER FOMANTIS SKWOVET ROOKIDEE NICKIT GOSSIFLEUR WOOLOO YAMPER APPLIN TOXEL HATENNA IMPIDIMP MILCERY DREEPY]
end

# 278 <= BST <= 299, Odds F1: Often
def getOakPoolLW3
# Count: 40
%i[EKANS VULPIX PARAS MEOWTH HORSEA MAREEP PINECO KIRLIA SHROOMISH SLAKOTH MEDITITE ELECTRIKE TRAPINCH BARBOACH SHUPPET DUSKULL SPHEAL BUDEW CHINGLING BONSLY RIOLU PURRLOIN MUNNA BLITZLE ROGGENROLA TYMPOLE COTTONEE PETILIL SANDILE GOTHITA SOLOSIS FOONGUS FLETCHLING INKAY HELIOPTILE ROCKRUFF MORELULL STEENEE CHEWTLE ARROKUDA]
end

# 300 <= BST <= 376, Odds F1: Rare, Odds F2: Rare
def getOakPoolLW4
# Count: 190
%i[BULBASAUR CHARMANDER SQUIRTLE PIDGEOTTO PIKACHU SANDSHREW NIDORINA NIDORINO CLEFAIRY ODDISH VENONAT PSYDUCK MANKEY GROWLITHE POLIWAG ABRA MACHOP BELLSPROUT TENTACOOL GEODUDE SLOWPOKE MAGNEMITE DODUO SEEL GRIMER SHELLDER GASTLY DROWZEE KRABBY VOLTORB EXEGGCUTE CUBONE KOFFING RHYHORN GOLDEEN STARYU EEVEE OMANYTE KABUTO DRATINI CHIKORITA CYNDAQUIL TOTODILE FLAAFFY SKIPLOOM AIPOM SNUBBULL MAGBY SMOOCHUM ELEKID NATU REMORAID CHINCHOU TEDDIURSA PHANPY HOUNDOUR LARVITAR TREECKO TORCHIC MUDKIP LOMBRE NUZLEAF LOUDRED NOSEPASS ARON GULPIN CARVANHA NUMEL SPOINK VIBRAVA CACNEA SWABLU CORPHISH BALTOY LILEEP ANORITH SNORUNT CLAMPERL BAGON BELDUM TURTWIG CHIMCHAR PIPLUP STARAVIA LUXIO CRANIDOS SHIELDON BUIZEL SHELLOS DRIFLOON BUNEARY GLAMEOW STUNKY BRONZOR MIMEJR GIBLE HIPPOPOTAS SKORUPI CROAGUNK FINNEON MANTYKE SNOVER SNIVY TEPIG OSHAWOTT HERDIER PANSAGE PANSEAR PANPOUR TRANQUILL WOOBAT DRILBUR TIMBURR SEWADDLE WHIRLIPEDE KROKOROK DARUMAKA DWEBBLE SCRAGGY YAMASK TIRTOUGA TRUBBISH ZORUA MINCCINO DUOSION DUCKLETT VANILLITE DEERLING KARRABLAST FRILLISH JOLTIK FERROSEED KLINK ELGYEM LAMPENT AXEW CUBCHOO SHELMET MIENFOO GOLETT PAWNIARD RUFFLET VULLABY DEINO LARVESTA CHESPIN FENNEKIN FROAKIE LITLEO FLABEBE FLOETTE SKIDDO PANCHAM ESPURR HONEDGE SPRITZEE SWIRLIX BINACLE SKRELP CLAUNCHER TYRUNT AMAURA GOOMY PHANTUMP PUMPKABOO BERGMITE ROWLET LITTEN POPPLIO TRUMBEAK GRUBBIN CRABRAWLER CUTIEFLY MAREANIE SALANDIT STUFFUL SANDYGAST JANGMOO GROOKEY SCORBUNNY SOBBLE CORVISQUIRE DOTTLER SILICOBRA SIZZLIPEDE CLOBBOPUS SINISTEA HATTREM MORGREM CUFANT]
end

# 377 <= BST <= 399, Odds F2: Often, Odds F3: Rare
def getOakPoolLW5
# Count: 17
%i[GLOOM POLIWHIRL WEEPINBELL GRAVELER FARFETCHD ONIX LICKITUNG PORYGON YANMA MUNCHLAX BOLDORE PALPITOAD SWADLOON GOTHORITA VANILLISH FLETCHINDER MUDBRAY]
end

# 400 <= BST <= 409, Odds F2: Rare, Odds F3: Often, Odds F4: Rare
def getOakPoolLW6
# Count: 26
%i[IVYSAUR CHARMELEON WARTORTLE KADABRA MACHOKE HAUNTER BAYLEEF QUILAVA CROCONAW TOGETIC MURKROW GROVYLE COMBUSKEN MARSHTOMP ROSELIA WAILMER GROTLE MONFERNO PRINPLUP GURDURR ARCHEN EELEKTRIK QUILLADIN BRAIXEN FROGADIER CHARJABUG]
end

# 410 <= BST <= 424, Odds F3: Rare, Odds F4: Often
def getOakPoolLW7
# Count: 23
%i[PONYTA DRAGONAIR CORSOLA PUPITAR LINOONE SEALEO SHELGON METANG GABITE SERVINE PIGNITE DEWOTT FRAXURE ZWEILOUS DARTRIX TORRACAT BRIONNE HAKAMOO THWACKEY RABOOT DRIZZILE CARKOL DRAKLOAK]
end

# 425 <= BST <= 515, Odds F3: Ultra Rare, Odds F4: Rare
def getOakPoolLW8
# Count: 21
%i[GOLBAT MAGNETON RHYDON CHANSEY TANGELA SEADRA MRMIME SCYTHER ELECTABUZZ MAGMAR GLIGAR PILOSWINE SNEASEL MISDREAVUS PORYGON2 VIGOROTH LAIRON DUSCLOPS KLANG DOUBLADE SLIGGOO]
end