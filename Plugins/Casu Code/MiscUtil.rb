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



  speech = nil
        commands2 = []
        commands2[cmdBuy = commands2.length]  = _INTL('No')
        commands2[cmdSell = commands2.length] = _INTL('Yes')
        cmd2 = pbMessage(
          speech || _INTL('Are you sure?'),
          commands2
        )
        loop do
          if cmd2 == cmdBuy
            pbBossRewardFloor2
            break
          elsif cmd2 == cmdSell
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
             break
         end
        end
end

def pbMF_Reward_F4
  speech = nil
  commands = []
  commands[cmdBuy = commands.length]  = _INTL('Assault Vest')
  commands[cmdSell = commands.length] = _INTL('Life Orb')
  commands[cmdQuit = commands.length] = _INTL('Focus Sash')
  cmd = pbMessage(
    speech || _INTL('Take one of the Items.'),
    commands
  )

   speech = nil
      commands2 = []
      commands2[cmdBuy = commands2.length]  = _INTL('No')
      commands2[cmdSell = commands2.length] = _INTL('Yes')
      cmd2 = pbMessage(
        speech || _INTL('Are you sure?'),
        commands2
      )
      loop do
        if cmd2 == cmdBuy
          pbMF_Reward_F4
          break
        elsif cmd2 == cmdSell
       loop do
           if cmd == cmdBuy
             pbReceiveItem(:ASSAULTVEST)
             break
           elsif cmd == cmdSell
             pbReceiveItem(:LIFEORB)
             break
           elsif cmd == cmdQuit
             pbReceiveItem(:FOCUSSASH)
             break
           end
         end
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
      next unless box[i]

      next unless pbGetMegaStones(box[i])

      pbGetMegaStones(box[i]).each do |stone|
        stones << _INTL(stone.to_s) unless stones.include? _INTL(stone.to_s)
      end
    end
  end

  n = $Trainer.party.length
  (0..n).each do |i|
    next unless $Trainer.party[n - i]

    next unless pbGetMegaStones($Trainer.party[n - i])

    pbGetMegaStones($Trainer.party[n - i]).each do |stone|
      stones << _INTL(stone.to_s) unless stones.include? _INTL(stone.to_s)
    end
  end

  speech = nil
  cmd = pbMessage(speech || _INTL('Choose a Mega Stone.'), stones)
    commands = []
    commands[cmdBuy = commands.length]  = _INTL('No')
    commands[cmdSell = commands.length] = _INTL('Yes')
    cmd2 = pbMessage(
      speech || _INTL('Are you sure?'),
      commands
    )
    loop do
      if cmd2 == cmdBuy
        pbOfferUsableMegaStones
        break
      elsif cmd2 == cmdSell
     pbReceiveItem(stones[cmd])
        break
      end
    end
end

def pbSetMartPrices
  items_cheap = %w[TM03 TM04 TM05 TM17 TM18 TM25 TM34 TM48 TM65 TR01 TR48]
  items_cheap.each do |i|
    setPrice(i, 500, 0)
  end

  items_normal = %w[TM43 TM92 TR02 TR04 TR05 TR08 TR10 TR11 TR15 TR16 TR22 TR28 TR33 TR39 TR47 TR49 TR62 TR64 TR65 TR70
                    TR74 TR75 TR90 TR92]
  items_normal.each do |i|
    setPrice(i, 1000, 0)
  end

  items_expensive = %w[TM28 TM56 TM63 TM80 TR00 TR18 TR51 TR84]
  items_expensive.each do |i|
    setPrice(i, 1500, 0)
  end

  items_insane = %w[ADAMANTMINT BOLDMINT IMPISHMINT MODESTMINT CALMMINT CAREFULMINT TIMIDMINT JOLLYMINT NAIVEMINT]
  items_insane.each do |i|
    setPrice(i, 2000, 0)
  end
end

def pbGetMegaStones(pkmn)
  res = []
  GameData::Species.each do |data|
    res.push(data.mega_stone) if data.mega_stone && (data.species == pkmn.species)
  end
  res
end

# DO NOT DELETE
def pbForceSave; end

def pbForceSave2
  Game.save
  pbMessage(_INTL('The game was saved.'))
  pbMEPlay('GUI save game')
  pbSEPlay('GUI save choice')
end
