TRAINER_OVERRIDE = [
  {
    tType: :YOUNGSTER, tName: 'Trainer',
    lvl1: 10, lvl2: 12, numPkmn: 2,
    pkmnPool: %i[BIDOOF BUNNELBY EEVEE LILLIPUP AIPOM BUNEARY MEOWTH MINCCINO RATTATA PATRAT CASTFORM JIGGLYPUFF GLAMEOW HOOTHOOT TEDDIURSA ZIGZAGOON WHISMUR DUSKULL RALTS MIMEJR POOCHYENA SOLOSIS SENTRET SKITTY CLEFFA RIOLU TYROGUE]
  },
  {
    tType: :LASS, tName: 'Trainer',
    lvl1: 25, lvl2: 28, numPkmn: 3,
    pkmnPool: %i[GLOOM SEADRA LAMPENT STARAVIA KIRLIA GRAVELER MARSHTOMP LOUDRED POLIWHIRL NUZLEAF TANGELA WARTORTLE COMBUSKEN GOTHORITA BRONZOR KLANG KROKOROK MURKROW BAYLEEF CHARMELEON CROCONAW DEWOTT FLAAFFY GROTLE GROVYLE HERDIER IVYSAUR LAIRON LOMBRE MACHOKE NIDORINO PIDGEOTTO VANILLISH  WHIRLIPEDE]
  },
  {
    tType: :COOLTRAINER_F, tName: 'Trainer',
    lvl1: 53, lvl2: 55, numPkmn: 3,
    pkmnPool: %i[ARCANINE AZUMARILL ABOMASNOW SLOWBRO HITMONTOP STARMIE BRONZONG MACHAMP HONCHKROW GALVANTULA TOGEKISS RHYDON SCRAFTY ROSERADE CHANDELURE AMBIPOM CLAYDOL COFAGRIGUS CROBAT DUSKNOIR MISMAGIUS NIDOKING NIDOQUEEN XATU VENOMOTH AGGRON AMOONGUSS BOUFFALANT CRUSTLE ELECTIVIRE KLINKLANG MANECTRIC LANTURN POLIWRATH QWILFISH WHIMSICOTT]
  },
  {
    tType: :BIKER, tName: 'Trainer',
    lvl1: 80, lvl2: 85, numPkmn: 4,
    pkmnPool: %i[ALAKAZAM CONKELDURR EXCADRILL FERROTHORN GLISCOR GENGAR JELLICENT MAMOSWINE REUNICLUS SCIZOR STARMIE TENTACRUEL HIPPOWDON HAXORUS INFERNAPE LUCARIO METAGROSS ABOMASNOW TOXICROAK GYARADOS DONPHAN VAPOREON CHANDELURE FROSLASS STARAPTOR DARMANITAN EMPOLEON FLYGON RHYPERIOR MIENSHAO MILOTIC SNORLAX WEAVILE]
  },
]

TRAINER_INTRO_TEXT = [
  ['I was given 5$ to stop you.', 'I just caught these. Let\'s see how strong they are.', 'Mom said I have to be home before it gets dark.'],
  ['Stop right there!', 'What\'s the hurry?', 'I can\'t let you through.', 'I will not go easy on you!'],
  ['You look weak. This will be easier than i thought.', 'Last chance to turn around.', 'You don\'t stand a chance!'],
  ['First I will finish your Pokémon, then I will finish you.', 'This will not end pretty.', 'I hope you wrote your testament.', 'Time to smash some Pokémon'],
]

Events.onTrainerPartyLoad += proc { |sender, trainer_list|
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
      newParty.push(Pokemon.new(new_species , lvl))
    end

    trainer.party = newParty
    echoln "Generated trainer party: " + newParty.to_s
  end
}

def pbGenIntroText
  stages_cleared = pbGet(48)
  intro_list = TRAINER_INTRO_TEXT[stages_cleared]
  pbSet(34, intro_list[rand(intro_list.length)])
end
