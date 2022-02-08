TRAINER_OVERRIDE = [
  {
    tType: :YOUNGSTER, tName: 'Trainer',
    lvl1: 10, lvl2: 12, numPkmn: 2,
    pkmnPool: %i[BIDOOF BUNNELBY EEVEE LILLIPUP AIPOM BUNEARY MEOWTH MINCCINO RATTATA PATRAT]
  },
  {
    tType: :LASS, tName: 'Trainer',
    lvl1: 25, lvl2: 28, numPkmn: 3,
    pkmnPool: %i[GLOOM SEADRA LAMPENT STARAVIA KIRLIA GRAVELER MARSHTOMP LOUDRED POLIWHIRL NUZLEAF]
  },
  {
    tType: :COOLTRAINER_F, tName: 'Trainer',
    lvl1: 55, lvl2: 57, numPkmn: 3,
    pkmnPool: %i[ARCANINE AZUMARILL ABOMASNOW SLOWBRO HITMONTOP STARMIE BRONZONG MACHAMP HONCHKROW GALVANTULA TOGEKISS RHYDON SCRAFTY ROSERADE AZUMARILL ]
  },
  {
    tType: :BIKER, tName: 'Trainer',
    lvl1: 80, lvl2: 85, numPkmn: 4,
    pkmnPool: %i[ALAKAZAM CONKELDURR EXCADRILL FERROTHORN GLISCOR GENGAR JELLICENT MAMOSWINE REUNICLUS SCIZOR STARMIE TENTACRUEL HIPPOWDON HAXORUS INFERNAPE LUCARIO METAGROSS ABOMASNOW]
  },
]

Events.onTrainerPartyLoad += proc { |_sender, trainer_list|
  return unless trainer_list

  trainer_list.each do |trainer|
    template = TRAINER_OVERRIDE.find { |i| i[:tType] == trainer.trainer_type and i[:tName] == trainer.name }
    next unless template # Do nothing if no override was found

    # Determin lvl
    lvl = template[:lvl1]
    lvl = template[:lvl2] if pbGet(49) +2 > Settings::ROOMS_PER_STAGE / 2

    # Generate Party
    newParty = []
    while newParty.length < template[:numPkmn]
      pkmnPool = template[:pkmnPool].reject { |p| newParty.include? p }
      newParty.push(Pokemon.new(pkmnPool[rand(pkmnPool.length)], lvl))
    end

    trainer.party = newParty
  end
}