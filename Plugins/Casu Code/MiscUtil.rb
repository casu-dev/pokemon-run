# User.methods - Object.methods

def pbDeleteFainted
  n = $Trainer.party.length
  (0..n).each do |i|
    if $Trainer.party[n - i] && !$Trainer.party[n - i].able?
      pbReceiveItem($Trainer.party[n - i].item.id) if $Trainer.party[n - i].item
      $Trainer.party.delete_at(n - i)
    end
  end
end

# Not used
def pbGiveAllExp(amount = 500)
  lvls = []

  $Trainer.party.each_with_index do |pkmn, i|
    lvls[i] = pkmn.level
    pbGiveOneExp(pkmn, amount)
  end

  pbEvolutionCheck(lvls)
end

# Not used
def pbGiveOneExp(pkmn, amount)
  level_bevor = pkmn.level
  pkmn.exp += amount
  if pkmn.level > level_bevor
    print('level up')
    pkmn.calc_stats
  end
end

def pbDeleteAllPkmn
  n = $Trainer.party.length
  (0..n).each do |i|
    $Trainer.party.delete_at(n - i) if $Trainer.party[n - i]
  end
end

def pbClearAllBoxes
  $PokemonStorage.boxes.each do |box|
    (0...box.length).each do |i|
      box[i] = nil
    end
  end
end

def pbBossRewardFloor2
  speech = nil
  commands = []
  commands[cmdBuy = commands.length]  = _INTL('Choice Scarf')
  commands[cmdSell = commands.length] = _INTL('Choice Specs')
  commands[cmdQuit = commands.length] = _INTL('Choice Band')
  cmd = pbMessage(
    speech || _INTL('Take one of the Items.'),
    commands
  )
  loop do
    if cmd == cmdBuy
      pbReceiveItem(:CHOICESCARF)
      break
    elsif cmd == cmdSell
      pbReceiveItem(:CHOICESPECS)
      break
    elsif cmd == cmdQuit
      pbReceiveItem(:CHOICEBAND)
      break
    end
  end
end

def pbMF_Reward_F4
  speech = nil
  commands = []
  commands[cmdBuy = commands.length]  = _INTL('Assault Vest')
  commands[cmdSell = commands.length] = _INTL('Expert Belt')
  commands[cmdQuit = commands.length] = _INTL('Focus Sash')
  cmd = pbMessage(
    speech || _INTL('Take one of the Items.'),
    commands
  )
  loop do
    if cmd == cmdBuy
      pbReceiveItem(:ASSAULTVEST)
      break
    elsif cmd == cmdSell
      pbReceiveItem(:EXPERTBELT)
      break
    elsif cmd == cmdQuit
      pbReceiveItem(:FOCUSSASH)
      break
    end
  end
end

def pbGiveMoney(amount)
  $Trainer.money += amount
  pbMessage(_INTL('You got ${1} for winning!', amount.to_s_formatted))
end

def can_evolve?(pkmn)
  # To-do?: Exclude Eggs
  if pkmn.species_data.get_evolutions[0]
    true
  else
    false
  end
end

def pbForceEvo?(pkmn)
  # To-do?: Exclude Eggs
  evo_info = pkmn.species_data.get_evolutions
  if pkmn.species_data.get_evolutions[0]
    speech = nil
    evos = []

    evo_info.each do |i|
      evos << _INTL(i[0].to_s)
    end
    evos << _INTL('Go back')

    cmd = pbMessage(speech || _INTL('Choose an Evolution.'), evos)
    # pbMessage(cmd.to_s)

    if cmd != evos.length - 1
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, evo_info[cmd][0])
      # evo.pbStartScreen(pkmn,pkmn.species_data.get_evolutions[0][0])
      evo.pbEvolution
      evo.pbEndScreen
      true
    else
      false
    end
  else
    pbMessage("This Pokémon can't evolve anymore.")
    false
  end
end

def pbOfferUsableMegaStones
    stones = []

    $PokemonStorage.boxes.each do |box|
        (0...box.length).each do |i|
              if box[i]
                  if pbGetMegaStones(box[i])
                     pbGetMegaStones(box[i]).each do |stone|
                        if !(stones.include? _INTL(stone.to_s))
                            stones << _INTL(stone.to_s)
                        end
                     end
                  end
              end
        end
    end

   n = $Trainer.party.length
  (0..n).each do |i|
    if $Trainer.party[n - i]
        if pbGetMegaStones($Trainer.party[n - i])
             pbGetMegaStones($Trainer.party[n - i]).each do |stone|
                if !(stones.include? _INTL(stone.to_s))
                    stones << _INTL(stone.to_s)
                end
             end
        end
    end
  end

  speech = nil
  cmd = pbMessage(speech || _INTL('Choose a Mega Stone.'), stones)
  pbReceiveItem(stones[cmd])

end

def pbSetMartPrices
  items = %w[TM10 TM28 TM11 TM30 TM17 TM32 TM18 TM33 TM21 TM34 TM25 TM35 TM39
             TM43 TM46 TM48 TM56 TM63 TM64 TM65 TM75 TM77 TM79 TM80 TM81 TM87 TM86
             TM92 TM03 TM04 TM05]
  items.each do |i|
    setPrice(i, 1500, 1400)
  end
end

def pbGetMegaStones(pkmn)
  res = []
  GameData::Species.each do |data|    
    if data.mega_stone      
      res.push(data.mega_stone) if data.species == pkmn.species
    end
  end
  return res
end