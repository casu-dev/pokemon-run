def pbDeleteFainted
  n = $Trainer.party.length
  (0..n).each do |i|
    $Trainer.party.delete_at(n - i) if $Trainer.party[n - i] && !$Trainer.party[n - i].able?
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
  speech=nil
  commands = []
  commands[cmdBuy = commands.length]  = _INTL("Choice Scarf")
  commands[cmdSell = commands.length] = _INTL("Choice Specs")
  commands[cmdQuit = commands.length] = _INTL("Choice Band")
  cmd = pbMessage(
     speech ? speech : _INTL("Take one of the Items."),
     commands)
  loop do
    if cmd==cmdBuy
      pbReceiveItem(:CHOICESCARF)
    break
    elsif cmd==cmdSell
      pbReceiveItem(:CHOICESPECS)
    break
    elsif cmd==cmdQuit
      pbReceiveItem(:CHOICEBAND)
    break
    end
  end
end

def pbGiveMoney(amount)
  $Trainer.money += amount
  pbMessage(_INTL("You got ${1} for winning!", amount.to_s_formatted))  
end
