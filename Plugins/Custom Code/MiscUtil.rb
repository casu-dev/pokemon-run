# User.methods - Object.methods
#pbMessage(GameData::Species.get_species_form(pkmn.species,0).egg_moves.to_s)

def pbDeleteFainted
  n = $Trainer.party.length
  (0..n).each do |i|
    if $Trainer.party[n - i] && !$Trainer.party[n - i].able?
      pbReceiveItem($Trainer.party[n - i].item.id) if $Trainer.party[n - i].item
      $Trainer.party[n - i].heal
      $Trainer.mystery_gifts.push($Trainer.party[n - i]) #Collecting fainted Pokemon for offering later if player blacksout
      $Trainer.party.delete_at(n - i)
    end
  end
  n = 6 - $Trainer.party.length
  if (n > 0)
      $PokemonStorage.boxes.each do |box|
        (0...box.length).each do |i|
            if box[i]
                 pkmn = box[i].clone
                 $Trainer.party.push(pkmn)
                 box[i] = nil
                 n -= 1
                 return if n <= 0
            end
        end
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

def pbConfirmChoice
speech = nil
  commands2 = []
  commands2[cmdSell = commands2.length] = _INTL('Yes')
  commands2[cmdBuy = commands2.length]  = _INTL('No')
  cmd2 = pbMessage(
    speech || _INTL('Are you sure?'),
    commands2
  )
  loop do
    if cmd2 == cmdBuy
      return true
    else
      return false
    end
  end
end

def pbBossRewardFloor2Obsulete
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

def pbGiveMoney(amount)
  $Trainer.money += amount
  pbMessage(_INTL('You got ${1} for winning!', amount.to_s_formatted))
end

def pbLootWell
floor = pbGet(48)
amount = 1200 + rand(100) if floor == 0
amount = 2000 + rand(200) if floor == 1
amount = 2800 + rand(300) if floor == 2
amount = 3600 + rand(500) if floor == 3
  $Trainer.money += amount
  pbMessage("You looted the well.")
  pbMEPlay("Item get")
  pbMessage(_INTL('You found \\b${1}\\c[0]!', amount.to_s_formatted))
end

def can_evolve?(pkmn)
  if pkmn.species_data.get_evolutions[0]
    true
  else
    false
  end
end

def pbForceEvo?(pkmn)
  # To-do?: Exclude Eggs
  evo_info = pkmn.species_data.get_evolutions
  if pkmn.species_data.get_evolutions[0] && pbCanEvoInCurrentMode(pkmn)
    speech = nil
    evos = []

    evo_info.each do |i|
      evos << _INTL(i[0].to_s) unless evos.include? i[0].to_s
    end
    evos << _INTL('Go back')

    cmd = pbMessage(speech || _INTL('Choose an Evolution.'), evos)
    # pbMessage(cmd.to_s)
    if cmd != evos.length - 1
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, evos[cmd])
      # evo.pbStartScreen(pkmn,pkmn.species_data.get_evolutions[0][0])
      evo.pbEvolution
      evo.pbEndScreen
      true
    else
      false
    end
  else
    pbMessage("This Pokémon can't evolve.")
    false
  end
end

def pbOfferUsableMegaStones
  stones = []
  $PokemonStorage.boxes.each do |box|
    (0...box.length).each do |i|
      next unless box[i]
      newStones = pbGetMegaStones(box[i])
      next unless newStones

      newStones.each do |stone|
        stones << _INTL(stone.to_s) unless stones.include? _INTL(stone.to_s)
      end
    end
  end

  n = $Trainer.party.length
  (0..n).each do |i|
    next unless $Trainer.party[n - i]
    newStones = pbGetMegaStones($Trainer.party[n - i])
    next unless newStones

    newStones.each do |stone|
      stones << _INTL(stone.to_s) unless stones.include? _INTL(stone.to_s)
    end
  end
    if stones != []
          speech = nil
          cmd = pbMessage(speech || _INTL('\\bChoose a Mega Stone.'), stones)
          commands = []
          commands[cmdSell = commands.length] = _INTL('Yes')
          commands[cmdBuy = commands.length]  = _INTL('No')
          cmd2 = pbMessage(
            speech || _INTL('\\bAre you sure?'),
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
end

def pbGetMegaStones(pkmn)
  res = []
  if !((pkmn.species.to_s == "SLOWBRO") && (pkmn.form == 1))
      GameData::Species.each do |data|
          if data.mega_stone && (data.species == pkmn.species)
              res.push(data.mega_stone)
              break if (res.length >= 2)
          end
      end
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

def pbResetMessage
  speech = nil
  commands = []
  commands[cmdBuy = commands.length] = _INTL('=)')
  cmd = pbMessage(
    speech || _INTL('Please press F12 to go back to Titlescreen.'),
    commands
  )
  loop do
    pbResetMessage if cmd == cmdBuy
  end
end

# Used when Oak gives 1 Pokemon, so that not all Pokemon's EVs will be checked
def pbSetPkmnEv(pkmn)
      floor = pbGet(48) + 1
      $TargetEv = 0
      $TargetEv = 46 if floor == 2
      $TargetEv = 69 if floor == 3
      $TargetEv = 84 if floor == 4

      pkmn.ev[:HP] = $TargetEv
      pkmn.ev[:ATTACK] = $TargetEv
      pkmn.ev[:DEFENSE] = $TargetEv
      pkmn.ev[:SPECIAL_ATTACK] = $TargetEv
      pkmn.ev[:SPECIAL_DEFENSE] = $TargetEv
      pkmn.ev[:SPEED] = $TargetEv
      pkmn.calc_stats
end

def pbChangeAllPkmnEv
  floor = pbGet(48) + 1
  $TargetEv = 0
  $TargetEv = 46 if floor == 2
  $TargetEv = 69 if floor == 3
  $TargetEv = 84 if floor == 4

  # EV up party
  $Trainer.party.each do |pkmn|
    if !pkmn.nil?
        # If every stat is < $TargetEv, set all stats = $TargetEv. Otherwise increase each stat by 1 until done, to avoid sum getting > 510, which creates a bug.
        if (pkmn.ev[:HP] < $TargetEv && pkmn.ev[:ATTACK] < $TargetEv && pkmn.ev[:DEFENSE] < $TargetEv && pkmn.ev[:SPECIAL_ATTACK] < $TargetEv && pkmn.ev[:SPECIAL_DEFENSE] < $TargetEv && pkmn.ev[:SPEED] < $TargetEv)
            pkmn.ev[:HP] = $TargetEv
            pkmn.ev[:ATTACK] = $TargetEv
            pkmn.ev[:DEFENSE] = $TargetEv
            pkmn.ev[:SPECIAL_ATTACK] = $TargetEv
            pkmn.ev[:SPECIAL_DEFENSE] = $TargetEv
            pkmn.ev[:SPEED] = $TargetEv
        else
            sum = (pkmn.ev[:HP] + pkmn.ev[:ATTACK] + pkmn.ev[:DEFENSE] + pkmn.ev[:SPECIAL_ATTACK] + pkmn.ev[:SPECIAL_DEFENSE] + pkmn.ev[:SPEED])
            while (sum < 6 * $TargetEv)
                pkmn.ev[:HP] += 1 if (pkmn.ev[:HP] < $TargetEv)
                pkmn.ev[:ATTACK] += 1 if (pkmn.ev[:ATTACK] < $TargetEv)
                pkmn.ev[:DEFENSE] += 1 if (pkmn.ev[:DEFENSE] < $TargetEv)
                pkmn.ev[:SPECIAL_ATTACK] += 1 if (pkmn.ev[:SPECIAL_ATTACK] < $TargetEv)
                pkmn.ev[:SPECIAL_DEFENSE] += 1 if (pkmn.ev[:SPECIAL_DEFENSE] < $TargetEv)
                pkmn.ev[:SPEED] += 1 if (pkmn.ev[:SPEED] < $TargetEv)
                sum = (pkmn.ev[:HP] + pkmn.ev[:ATTACK] + pkmn.ev[:DEFENSE] + pkmn.ev[:SPECIAL_ATTACK] + pkmn.ev[:SPECIAL_DEFENSE] + pkmn.ev[:SPEED])
            end
        end
        pkmn.calc_stats
    end
  end

  # EV up box
  $PokemonStorage.boxes.each do |box|
    box.each do |pkmn|
      if !pkmn.nil?
         # If every stat is < $TargetEv, set all stats = $TargetEv. Otherwise increase each stat by 1 until done, to avoid sum getting > 510, which creates a bug.
         if (pkmn.ev[:HP] < $TargetEv && pkmn.ev[:ATTACK] < $TargetEv && pkmn.ev[:DEFENSE] < $TargetEv && pkmn.ev[:SPECIAL_ATTACK] < $TargetEv && pkmn.ev[:SPECIAL_DEFENSE] < $TargetEv && pkmn.ev[:SPEED] < $TargetEv)
             pkmn.ev[:HP] = $TargetEv
             pkmn.ev[:ATTACK] = $TargetEv
             pkmn.ev[:DEFENSE] = $TargetEv
             pkmn.ev[:SPECIAL_ATTACK] = $TargetEv
             pkmn.ev[:SPECIAL_DEFENSE] = $TargetEv
             pkmn.ev[:SPEED] = $TargetEv
         else
              sum = (pkmn.ev[:HP] + pkmn.ev[:ATTACK] + pkmn.ev[:DEFENSE] + pkmn.ev[:SPECIAL_ATTACK] + pkmn.ev[:SPECIAL_DEFENSE] + pkmn.ev[:SPEED])
              while (sum < 6 * $TargetEv)
                  pkmn.ev[:HP] += 1 if (pkmn.ev[:HP] < $TargetEv)
                  pkmn.ev[:ATTACK] += 1 if (pkmn.ev[:ATTACK] < $TargetEv)
                  pkmn.ev[:DEFENSE] += 1 if (pkmn.ev[:DEFENSE] < $TargetEv)
                  pkmn.ev[:SPECIAL_ATTACK] += 1 if (pkmn.ev[:SPECIAL_ATTACK] < $TargetEv)
                  pkmn.ev[:SPECIAL_DEFENSE] += 1 if (pkmn.ev[:SPECIAL_DEFENSE] < $TargetEv)
                  pkmn.ev[:SPEED] += 1 if (pkmn.ev[:SPEED] < $TargetEv)
                  sum = (pkmn.ev[:HP] + pkmn.ev[:ATTACK] + pkmn.ev[:DEFENSE] + pkmn.ev[:SPECIAL_ATTACK] + pkmn.ev[:SPECIAL_DEFENSE] + pkmn.ev[:SPEED])
              end
         end
         pkmn.calc_stats
      end
    end
  end
end

#unused?
def pbFighterBattleDialog
  stages_cleared = pbGet(48)
  speech = nil
  commands = []
  commands[cmdBuy = commands.length]  = _INTL('Air Balloon')
  commands[cmdSell = commands.length] = _INTL('Flame Orb')
  # commands[cmdQuit = commands.length] = _INTL('Rocky Helmet')
  commands[cmdBuy2 = commands.length]  = _INTL('Toxic Orb')
  commands[cmdSell2 = commands.length] = _INTL('Weakness Policy')
  commands[cmdQuit2 = commands.length] = _INTL('White Herb')
  commands[cmdEnd = commands.length] = _INTL('Quit')
  cmd = pbMessage(
    speech || _INTL('You want one of these Items?'),
    commands
  )

  return false if cmd == cmdEnd

  speech = nil
  commands2 = []
  commands2[cmdBuy = commands2.length]  = _INTL('No')
  commands2[cmdSell = commands2.length] = _INTL('Yes')
  cmd2 = pbMessage(
    speech || _INTL('Are you sure, you have to fight for it?'),
    commands2
  )

  loop do
    if cmd2 == cmdBuy
      return pbFighterBattleDialog
    elsif cmd2 == cmdSell
      pbMessage(_INTL('Lets go!'))
      if cmd == cmdBuy
        pbReceiveItem(:AIRBALLOON) if pbTrainerBattle(:BLACKBELT, 'Bruce', endSpeech=nil, doubleBattle=false, trainerPartyID=stages_cleared * 6 + 0)
      elsif cmd == cmdSell
        pbReceiveItem(:FLAMEORB) if pbTrainerBattle(:BLACKBELT, 'Bruce', endSpeech=nil, doubleBattle=false, trainerPartyID=stages_cleared * 6 + 1)
       # elsif cmd == cmdQuit
       # pbReceiveItem(:ROCKYHELMET) if pbTrainerBattle(:BLACKBELT, 'Bruce', endSpeech=nil, doubleBattle=false, trainerPartyID=stages_cleared * 6 + 2)
      elsif cmd == cmdBuy2
        pbReceiveItem(:TOXICORB) if pbTrainerBattle(:BLACKBELT, 'Bruce', endSpeech=nil, doubleBattle=false, trainerPartyID=stages_cleared * 6 + 3)
      elsif cmd == cmdSell2
        pbReceiveItem(:WEAKNESSPOLICY) if pbTrainerBattle(:BLACKBELT, 'Bruce', endSpeech=nil, doubleBattle=false, trainerPartyID=stages_cleared * 6 + 4)
      elsif cmd == cmdQuit2
        pbReceiveItem(:WHITEHERB) if pbTrainerBattle(:BLACKBELT, 'Bruce', endSpeech=nil, doubleBattle=false, trainerPartyID=stages_cleared * 6 + 5)
      end
      pbDeleteFainted
      return true
    end
  end
end

def pbFighterShop(stock, speech = nil, _cantsell = false)
  (0...stock.length).each do |i|
    stock[i] = GameData::Item.get(stock[i]).id
    stock[i] = nil if GameData::Item.get(stock[i]).is_important? && $PokemonBag.pbHasItem?(stock[i])
      # pbMessage(_INTL(GameData::Item.get(stock[i]).move.to_s))
  end
  stock.compact!
  commands = []
  cmdBuy  = -1
  cmdSell = -1
  cmdQuit = -1
  commands[cmdBuy = commands.length]  = _INTL('Buy')
  # commands[cmdSell = commands.length] = _INTL("Sell") if !cantsell
  commands[cmdQuit = commands.length] = _INTL('Quit')
  cmd = pbMessage(
    speech || _INTL('Using TMs let my Pokémon hit harder. Do you want some?'),
    commands, cmdQuit + 1
  )
  loop do
    if cmdBuy >= 0 && cmd == cmdBuy
      scene = PokemonMart_Scene.new
      screen = PokemonMartScreen.new(scene, stock)
      screen.pbBuyScreenTm
    elsif cmdSell >= 0 && cmd == cmdSell
      scene = PokemonMart_Scene.new
      screen = PokemonMartScreen.new(scene, stock)
      screen.pbSellScreen
    else
      pbMessage(_INTL('See you!'))
      break
    end
    cmd = pbMessage(_INTL('Is there anything else you want?'),
                    commands, cmdQuit + 1)
  end
  $game_temp.clear_mart_prices
end

def pbPlainStatsPkmn(pkmn)
ret = {}
ret[:ATTACK]          = pkmn.attack
ret[:DEFENSE]         = pkmn.defense
ret[:SPECIAL_ATTACK]  = pkmn.spatk
ret[:SPECIAL_DEFENSE] = pkmn.spdef
ret[:SPEED]           = pkmn.speed
return ret
end

def pbGetMoveset(pkmn)
return nil if !pkmn
moveset = "[ "
    i = 0
    pkmn.moves.each do |m|
        if m
            if i == 2
            moveset += ",<br>" + m.name
            elsif i == 0
            moveset += m.name
            else
            moveset += ", " + m.name
            end
            i+=1
        end
    end
    moveset += " ]"
    return moveset
end

def pbShowLvUpMoves(pkmnid)
    if $Trainer.party[pkmnid].species_data.moves.to_s != '[]'
              moveInfo = $Trainer.party[pkmnid].species_data.moves
              infoString = ""
              moveInfo.each do |m|
                  if m[0] != 0
                    infoString += GameData::Move.get(m[1]).name
                    infoString += " "
                    infoString += m[0].to_s
                    infoString += ", "
                  end
              end
              infoString += "."
              infoString =  infoString.gsub(", .", ".")
              pbMessage(infoString)
    else
     pbMessage(_INTL("This Pokémon can't learn any move by lv-up."))
    end
end

def pbShowEggMoves(pkmnid)
    if GameData::Species.get_species_form($Trainer.party[pkmnid].species_data.get_baby_species,0).egg_moves.to_s != '[]'
              moveInfo = GameData::Species.get_species_form($Trainer.party[pkmnid].species_data.get_baby_species,0).egg_moves
              infoString = ""
              moveInfo.each do |m|
                infoString += GameData::Move.get(m).name
                infoString += ", "
              end
              infoString += "."
              infoString =  infoString.gsub(", .", ".")
              pbMessage(infoString)
    else
     pbMessage(_INTL("This Pokémon has no egg moves."))
    end
end

def pbPrepline(line)
           line.sub!(/\s*\#.*$/,"")
           line.sub!(/^\s+/,"")
           line.sub!(/\s+$/,"")
           return line
end

def pbFileExists?(filename)
    path = if File.directory?(System.data_directory)
                System.data_directory + '/' + filename
              else
                './' + filename
              end
    return false if !File.exists?(path)
    return true
end

def pbReadFile(filename)
    path = if File.directory?(System.data_directory)
                System.data_directory + '/' + filename
              else
                './' + filename
              end
    pbWriteIntoFile(filename, 0) if !File.exists?(path)
    output=""
    File.open(path,"rb") { |f|
          FileLineData.file = path
                lineno = 1
                f.each_line { |line|
                  if lineno==1 && line[0].ord==0xEF && line[1].ord==0xBB && line[2].ord==0xBF
                    line = line[3,line.length-3]
                  end
                  # line.force_encoding(Encoding::UTF_8)
                  # line = pbPrepline(line)
                  output = line.to_s
                  #if !line[/^\#/] && !line[/^\s*$/]
                  #  FileLineData.setLine(line,lineno)
                  #end
                  lineno += 1
                }
              }
    return output
end

def pbWriteIntoFile(filename, text = "")
    path = if File.directory?(System.data_directory)
                System.data_directory + '/' + filename
              else
                './' + filename
              end
    File.open(path, "w") { |f| f.write text }
end

def pbIncreaseCompletionCount
    old = pbReadFile("runcompletedcount.txt").to_i
    nnew = (old + 1).to_s
    pbWriteIntoFile("runcompletedcount.txt", nnew)
    pbMessage(_INTL("You unlocked the \\c[10]" + pbGetGameModes[nnew.to_i] + " game mode\\c[0].")) if (old+2) <= pbGetGameModes.length
    pbMessage(_INTL("You unlocked \\c[10]all game modes\\c[0].")) if (old+2) == pbGetGameModes.length
end

def pbIncreaseF3CompletionCount
    old = pbReadFile("f3completedcount.txt").to_i
    nnew = (old + 1).to_s
    pbWriteIntoFile("f3completedcount.txt", nnew)
    pbMessage(_INTL("You unlocked the \\c[10]Gen " + (old+2).to_s + " Starter Pokémon\\c[0].")) if (old+2) <= pbGetStarters(:GRASS).length
    pbMessage(_INTL("You unlocked \\c[10]all Starter Pokémon\\c[0].")) if (old+2) == pbGetStarters(:GRASS).length
end

def pbGetDifficulties
    return %w[Easy Normal Hard]
end

def pbChooseDifficulty
    difficulties = pbGetDifficulties
    normalIndex = 0
    (0...difficulties.length).each do |i|
        normalIndex = i if (difficulties[i] == "Normal")
    end
    speech = nil
    cmd2 = pbMessage(speech || _INTL('\rChoose the games difficulty.'), difficulties)

    loop do
        if cmd2 == 0
            pbWriteIntoFile("difficulty.txt", cmd2-normalIndex)
            pbPlaySaveSound
            pbMessage(_INTL("Difficulty set to \\c[10]"+ difficulties[cmd2] +"\\c[0]."))
            break
        elsif cmd2 == 1
             pbWriteIntoFile("difficulty.txt", cmd2-normalIndex)
             pbPlaySaveSound
             pbMessage(_INTL("Difficulty set to \\c[10]"+ difficulties[cmd2] +"\\c[0]."))
             break
        elsif cmd2 == 2
            pbWriteIntoFile("difficulty.txt", cmd2-normalIndex)
            pbPlaySaveSound
            pbMessage(_INTL("Difficulty set to \\c[10]"+ difficulties[cmd2] +"\\c[0]."))
            break
        end
    end
end

def pbChooseMode
    completionCounter = pbReadFile("runcompletedcount.txt").to_i
    if (completionCounter > 0)
        modes = pbGetGameModes
        modeCounter = completionCounter
        modeCounter = modes.length()-1 if completionCounter >= modes.length()
        modeCounter = modeCounter.to_i
        shownmodes = []

        (0...modeCounter+1).each do |i|
            shownmodes.push(modes[i])
        end

          speech = nil
          cmd2 = pbMessage(
            speech || _INTL('\rWhich game mode do you want to play?'), shownmodes)

            loop do
                if cmd2 == 0
                    pbWriteIntoFile("gamemode.txt", 0)
                    pbWriteIntoFile("battlerinfo.txt", 0)
                    pbPlaySaveSound
                    pbMessage(_INTL("Game mode set to \\c[10]"+ pbGetGameModes[cmd2] +"\\c[0]."))
                    break
                elsif cmd2 == 1
                     pbWriteIntoFile("gamemode.txt", 1)
                     index = rand(1..10)
                     info = "Error"
                     info = "Atk and Def" if index == 1
                     info = "Atk and Sp. Atk" if index == 2
                     info = "Atk and Sp. Def" if index == 3
                     info = "Atk and Speed" if index == 4
                     info = "Def and Sp. Atk" if index == 5
                     info = "Def and Sp. Def" if index == 6
                     info = "Def and Speed" if index == 7
                     info = "Sp. Atk and Sp. Def" if index == 8
                     info = "Sp. Atk and Speed" if index == 9
                     info = "Sp. Def and Speed" if index == 10

                     pbWriteIntoFile("battlerinfo.txt", index)
                     pbPlaySaveSound
                     pbMessage(_INTL("Game mode set to \\c[10]"+ pbGetGameModes[cmd2] +"\\c[0]. The " + info + " stat of YOUR Pokémon will be swapped in battle."))
                     break
                elsif cmd2 == 2
                     pbWriteIntoFile("gamemode.txt", 2)
                     pbWriteIntoFile("battlerinfo.txt", 11)
                     pbPlaySaveSound
                     pbMessage(_INTL("Game mode set to \\c[10]"+ pbGetGameModes[cmd2] +"\\c[0]. The first Pokémon in your party will have the ability of the last one in battle."))
                     break
                elsif cmd2 == 3
                    hasFullyEvolved = false
                    $Trainer.party.each do |pkmn|
                       if !pkmn.nil?
                           if !can_evolve?(pkmn)
                            hasFullyEvolved = true
                           end
                       end
                   end

                   $PokemonStorage.boxes.each do |box|
                     box.each do |pkmn|
                       if !pkmn.nil?
                          if !can_evolve?(pkmn)
                           hasFullyEvolved = true
                          end
                       end
                     end
                   end
                   if (!hasFullyEvolved)
                     pbWriteIntoFile("gamemode.txt", 3)
                     pbWriteIntoFile("battlerinfo.txt", 0)
                     pbPlaySaveSound
                     pbMessage(_INTL("Game mode set to \\c[10]"+ pbGetGameModes[cmd2] +"\\c[0]. All your Pokémon will not be fully evolved, but their moves have their secondary effect chance tripled."))
                     break
                   else
                        pbMessage("You \\c[10]can't switch\\c[0] to this mode, while owning a fully evolved Pokémon.")
                        break
                   end
                elsif cmd2 == 4
                     pbWriteIntoFile("gamemode.txt", 4)
                     pbWriteIntoFile("battlerinfo.txt", 0)
                     pbPlaySaveSound
                     pbMessage(_INTL("Game mode set to \\c[10]"+ pbGetGameModes[cmd2] +"\\c[0]. Every moves damage gets boosted by 10% for each Pokémon in your party, that has the same type. Party Pokémon not having this type will reduce the damage by 10%."))
                     break
                end
            end
    else
        pbMessage(_INTL("To play another game mode talk to me. You can unlock game modes by completing runs."))
    end
end

def pbPlaySaveSound
 if FileTest.audio_exist?("Audio/ME/GUI save game")
                    pbMEPlay("GUI save game",80)
 end
end

def pbGetGameModes
    return ["Standard", "Stat-Swap", "Copy-Ability", "Lucky weakling", "Type Boost"]
end

def pbResetRoom
    n = $Trainer.party.length
      (0..n).each do |i|
          if $Trainer.party[n - i]
            $Trainer.mystery_gifts.push($Trainer.party[n - i])
            $Trainer.party.delete_at(n - i)
          end
      end

      $PokemonStorage.boxes.each do |box|
        box.each do |pkmn|
            $Trainer.mystery_gifts.push(pkmn)  if !pkmn.nil?
        end
      end

    pbClearAllBoxes

    for i in 0...$PokemonStorage.maxBoxes
       for j in 0...$Trainer.mystery_gifts.length()
         $Trainer.mystery_gifts[j].item=nil
         $PokemonStorage[i, j] = $Trainer.mystery_gifts[j]
       end
    end

    $Trainer.money = 0
    $PokemonBag.clear
    $Trainer.mystery_gifts = []
   #pbMessage(_INTL($Trainer.mystery_gifts.to_s))
end

def pbHallOfFameEnd
   #$game_temp.to_title = true
   pbClearAllBoxes
   pbFadeOutIn do
       $game_temp.player_new_map_id = 79
       $scene.transfer_player
       $game_map.autoplay
       $game_map.refresh
       $game_temp.player_new_map_id = 79
       $game_temp.player_new_x         = 9
       $game_temp.player_new_y         = 4
       $game_temp.player_new_direction = 0
       $scene.transfer_player
       $game_map.autoplay
       $game_map.refresh
   end
end

def pbResetAssistant
size = $Trainer.party.length()
    if size == 0
        speech = nil
        yn = ["Yes", "No"]
        cmd2 = pbMessage(speech || _INTL('You want to start the new run \\c[10]without\\c[0] one of your old Pokémon?'), yn)
            loop do
                if cmd2 == 0
                   pbClearAllBoxes
                   pbFadeOutIn do
                       $game_temp.player_new_map_id = 79
                       $scene.transfer_player
                       $game_map.autoplay
                       $game_map.refresh
                       $game_temp.player_new_map_id = 79
                       $game_temp.player_new_x         = 9
                       $game_temp.player_new_y         = 4
                       $game_temp.player_new_direction = 0
                       $scene.transfer_player
                       $game_map.autoplay
                       $game_map.refresh
                     end
                    break
                elsif cmd2 == 1
                     break
                end
            end
    elsif size == 1
        speech = nil
                yn = ["Yes", "No"]
                cmd2 = pbMessage(speech || _INTL("You want to start the new run with \\c[10]" + $Trainer.party[0].name + "\\c[0]?"), yn)
                    loop do
                        if cmd2 == 0
                           pbReceiveItem(:POTION)
                           pbClearAllBoxes
                           $Trainer.party.each do |pkmn|
                               if !pkmn.nil?
                                   pbChangeLevel(pkmn, 15, nil)
                                   pkmn.ev[:HP] = 0
                                   pkmn.ev[:ATTACK] = 0
                                   pkmn.ev[:DEFENSE] = 0
                                   pkmn.ev[:SPECIAL_ATTACK] = 0
                                   pkmn.ev[:SPECIAL_DEFENSE] = 0
                                   pkmn.ev[:SPEED] = 0
                                   pkmn.reset_moves
                               end
                           end
                           pbFadeOutIn do
                               $game_temp.player_new_map_id = 79
                               $scene.transfer_player
                               $game_map.autoplay
                               $game_map.refresh
                               $game_temp.player_new_map_id = 79
                               $game_temp.player_new_x         = 9
                               $game_temp.player_new_y         = 6
                               $game_temp.player_new_direction = 0
                               $scene.transfer_player
                               $game_map.autoplay
                               $game_map.refresh
                             end
                            break
                        elsif cmd2 == 1
                             break
                        end
                    end
    else
        pbMessage(_INTL("You can't take more than one Pokémon with you."))
    end
end

def pbPartyCountNotZero?
    return false if $Trainer.party.length() == 0
    return true
end

def pbBattlerIsPkmn?(bttlr, pkmn)
    return false if !(bttlr.name.to_s == pkmn.name.to_s)
    return false if !(bttlr.nature.name.to_s == pkmn.nature.name.to_s)
    return true
end

def pbRollForm(pkmnID)
     # (relevant) Pokémon with more than 2 forms %i[NECROZMA CALYREX DEOXYS ROTOM MEOWTH KYUREM ORICORIO GOURGEIST PUMPKABOO LYCANROC]
     # Form count                                %i[   3        3        4      6     3     3       4         4         4        3]
     if pkmnID == :NECROZMA || pkmnID == :CALYREX || pkmnID == :MEOWTH || pkmnID == :KYUREM || pkmnID == :LYCANROC
        return rand(3)
     elsif pkmnID == :DEOXYS || pkmnID == :ORICORIO || pkmnID == :GOURGEIST || pkmnID == :PUMPKABOO
        return rand(4)
     elsif pkmnID == :ROTOM
        return rand(6)
     elsif pbKeepBaseForm(pkmnID)
        return 0
     else
        return rand(2)
     end
end

def pbkAddPokemon(pkmn, level = 1, see_form = true)
      return false if !pkmn
      pbSet(40, 1)
      pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
      pkmn.heal
      form = pkmn.form
      pkmn.form = 0
      if pbBoxesFull?
        pbMessage(_INTL("There's no more room for Pokémon!\1"))
        pbMessage(_INTL("The Pokémon Boxes are full and can't accept any more!"))
        return false
      end
      species_name = pkmn.speciesName
      # Enable form moves to learn them
      pbSet(40, 0)
      pbMessage(_INTL("{1} obtained {2}!\\me[Pkmn get]\\wtnp[80]\1", $Trainer.name, species_name))
      pkmn.form = form
      pbSetPkmnEv(pkmn)
      pbNicknameAndStore(pkmn)
      $Trainer.pokedex.register(pkmn) if see_form
      return true
end

def pbOakSpawn4
    if  !pbLW
        pbMessage(_INTL("\\bGratulations to your victory! This is the last Floor. It's gonna be tough. I think you're ready for Mega-Evolutions. Take one of these Pokémon."))
        pbRandomPkmnSelection
        pbReceiveItem(:MEGARING)
        pbMessage(_INTL("\\bOkay, now take one of my Mega-Stones."))
        pbOfferUsableMegaStones
        pbMessage(_INTL("\\bExcellent choice! Equip the Mega-Stone and press \\c[10]Y\\b in Battle to mega evolve. I'm continuing my research now, have a good one!"))
    else
        pbMessage(_INTL("\\bGratulations to your victory! This is the last Floor. It's gonna be tough. Take one of these Pokémon."))
        pbRandomPkmnSelection
        pbMessage(_INTL("\\bExcellent choice! I'm continuing my research now, have a good one!"))
    end
end

def pbCanEvoInCurrentMode(pkmn)
    if !pbLW
        return can_evolve?(pkmn)
    else
        if can_evolve?(pkmn)
            return false if GameData::Species.try_get(GameData::Species.try_get(pkmn.species).get_evolutions[0][0]).get_evolutions.empty? #Returns false, if evolution cant evolve.
            return true
        end
    end
end

def pbOfferTypeBoostItems
    pbPokemonMartEarn([
    :BLACKBELT,
    :BLACKGLASSES,
    :CHARCOAL,
    :DRAGONFANG,
    :HARDSTONE,
    :MAGNET,
    :METALCOAT,
    :MIRACLESEED,
    :MYSTICWATER,
    :NEVERMELTICE,
    :PIXIEPLATE,
    :POISONBARB,
    :SHARPBEAK,
    :SILKSCARF,
    :SILVERPOWDER,
    :SOFTSAND,
    :SPELLTAG,
    :TWISTEDSPOON
    ],nil,false,2)
end

def pbOfferHealBerries
   return pbPokemonMartEarn([
    :LUMBERRY,
    :CUSTAPBERRY,
    :SITRUSBERRY,
    :FIGYBERRY,
    :WIKIBERRY,
    :MAGOBERRY,
    :AGUAVBERRY,
    :IAPAPABERRY
    ],nil,false,1)
end

def pbOfferStatBerries
   return pbPokemonMartEarn([
    :LIECHIBERRY,
    :GANLONBERRY,
    :SALACBERRY,
    :PETAYABERRY,
    :APICOTBERRY,
    :STARFBERRY
    ],nil,false,1)
end

def pbOfferWeakenBerries
   return pbPokemonMartEarn([
    :OCCABERRY,
    :PASSHOBERRY,
    :WACANBERRY,
    :RINDOBERRY,
    :YACHEBERRY,
    :CHOPLEBERRY,
    :KEBIABERRY,
    :SHUCABERRY,
    :COBABERRY,
    :PAYAPABERRY,
    :TANGABERRY,
    :CHARTIBERRY,
    :KASIBBERRY,
    :HABANBERRY,
    :COLBURBERRY,
    :BABIRIBERRY,
    :CHILANBERRY,
    :ROSELIBERRY
    ],nil,false,1)
end

def pbReceiveGems(amount)
    gems = %i[FIREGEM WATERGEM ELECTRICGEM GRASSGEM ICEGEM FIGHTINGGEM POISONGEM GROUNDGEM FLYINGGEM PSYCHICGEM BUGGEM ROCKGEM GHOSTGEM DRAGONGEM DARKGEM STEELGEM NORMALGEM FAIRYGEM]
    if amount >= 1
        result = []
        (0...amount).each do |_i|
          result.push(gems.delete_at(rand(gems.length)))
          pbStoreItem(result[_i])
        end
    end
    pbMEPlay("Item get")
    pbMessage("You found \\c[1]" + amount.to_s + " gems\\c[0].")
end

def pbGetEvoInfo(pkmnid)
    evoData = $Trainer.party[pkmnid].species_data.get_evolutions
    if evoData.to_s != '[]'
        evosArray = []
        evoNames = []
        evoData.each do |evo|
            if !(evoNames.include? evo[0].to_s)
                evoNames << evo[0].to_s
                if evo[1].to_s == 'Level'
                    evosArray.push(evo)
                else
                    evosArray.push([evo[0], 'Oaks assistant'])
                end
            end
        end
      evoInfo = evosArray.to_s.gsub(/[:\"]/, '')
      evoInfo[0] = ''
      evoInfo[evoInfo.length-1]= ''
      pbMessage(evoInfo)
    else
             pbMessage(_INTL("This Pokémon can't evolve."))
    end
end

def pbKeepBaseForm(pkmnID)
    pkmnFullyEvolvedID = pbGetCorrectEvo(pkmnID)
    megaPool = getOakMegas.dup
    megaPool += %i[MEWTWO LATIAS LATIOS RAYQUAZA DIANCIE AEGISLASH CASTFORM]
    megaPool -= %i[SLOWBRO]
    return true if megaPool.include? pkmnFullyEvolvedID
    return false
end

def pbGiveSignatureItem(pkmnID)
    if pkmnID == :GENESECT
        itemPool = %i[BURNDRIVE CHILLDRIVE DOUSEDRIVE SHOCKDRIVE]
        return itemPool[rand(4)]
    elsif pkmnID == :ARCEUS
        itemPool = %i[FLAMEPLATE SPLASHPLATE ZAPPLATE MEADOWPLATE ICICLEPLATE FISTPLATE TOXICPLATE EARTHPLATE SKYPLATE MINDPLATE INSECTPLATE STONEPLATE SPOOKYPLATE DRACOPLATE DREADPLATE IRONPLATE PIXIEPLATE]
        return itemPool[rand(17)]
    elsif pkmnID == :ZACIAN
        return "RUSTEDSWORD"
    elsif pkmnID == :ZAMAZENTA
        return "RUSTEDSHIELD"
    elsif pkmnID == :GROUDON
        return "REDORB"
    elsif pkmnID == :KYOGRE
        return "BLUEORB"
    elsif pkmnID == :SILVALLY
        itemPool = %i[FIREMEMORY WATERMEMORY ELECTRICMEMORY GRASSMEMORY ICEMEMORY FIGHTINGMEMORY POISONMEMORY GROUNDMEMORY FLYINGMEMORY PSYCHICMEMORY BUGMEMORY ROCKMEMORY GHOSTMEMORY DRAGONMEMORY DARKMEMORY STEELMEMORY FAIRYMEMORY]
        return itemPool[rand(17)]
    end
    # Other Pokémon shouldn't hold an item
    return nil
end

def pbStealPkmn
    if pbGet(44) != 0
        DiegoWTsStarterSelection.new(pbGet(44)[0], pbGet(44)[1], pbGet(44)[2], true) if pbGet(44)[0].level
    end
end

def pbLW
    return true if (pbReadFile("gamemode.txt").to_i == 3)
    return false
end

def pbGetStatusAfter(pkmn)
    statusAfter = "NONE"
    ability =  pkmn.ability.name.to_s
    if pkmn.status.to_s == "POISON"
      if ((["Poison Heal", "Guts", "Toxic Boost", "Marvel Scale", "Quick Feet"].include?(ability)) || (pkmn.hasMove?(:FACADE)))
        statusAfter = "POISON"
      end
    elsif pkmn.status.to_s == "BURN"
      if ((["Flare Boost", "Guts", "Marvel Scale", "Quick Feet"].include?(ability)) || (pkmn.hasMove?(:FACADE)))
        statusAfter = "BURN"
      end
    end
    return statusAfter
end

def pbTypeBoost(moveType)
    typeCount = 0
    $Trainer.party.each do |pkmn|
        typing = []
        typing.push(pkmn.type1)
        typing.push(pkmn.type2)
        if typing.include?(moveType)
            typeCount += 1
        else
            typeCount -= 1
        end
    end
    factor = 1.0 + (typeCount/10.0)
    return factor
end

def pbGetDifficulty
    return pbReadFile("difficulty.txt").to_i if pbReadFile("difficulty.txt")
end

def pbSetDifficulty(difficultyIndex)
    pbWriteIntoFile("difficulty.txt", difficultyIndex)
end

def pbGetGameMode
    return pbReadFile("gamemode.txt").to_i if pbReadFile("gamemode.txt")
end

def pbAddToTrainerPartyAverageLv(lvl)
    floor = pbGet(48) + 1
    return POKEMON_FLOOR_START_LEVEL[floor-1]+lvl if !$Trainer
    return POKEMON_FLOOR_START_LEVEL[floor-1]+lvl if !$Trainer.party
    lv = 0
    counter = 0
    $Trainer.party.each do |pkmn|
        lv += pkmn.level
        counter += 1
    end
    counter = 6 - counter
    while (counter > 0) do
        lv += POKEMON_FLOOR_START_LEVEL[floor-1]
        counter -= 1
    end

    lv = ((lv.to_f/6).round(half: :up)+lvl).to_i
    lv = 100 if lv > 100
    return lv
end

def pbGetLvTrainer
    difficulty = pbGetDifficulty
    floor = pbGet(48) + 1
    #hard
    if difficulty == 1
        if floor == 1
            return pbAddToTrainerPartyAverageLv(-3)
        elsif floor == 2
            return pbAddToTrainerPartyAverageLv(0)
        elsif floor == 3
            return pbAddToTrainerPartyAverageLv(0)
        else
            return pbAddToTrainerPartyAverageLv(0)
        end
    #normal
    elsif difficulty == 0
        if floor == 1
                return 12 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 10
            elsif floor == 2
                return 28 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 25
            elsif floor == 3
                return 55 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 53
            else
                return 85 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 80
            end
    #easy
    elsif difficulty == -1
        if floor == 1
                return 10
            elsif floor == 2
                return 25
            elsif floor == 3
                return 53
            else
                return 80
            end
    end
end

def pbGetLvElite
    difficulty = pbGetDifficulty
    floor = pbGet(48) + 1
    #hard
    if difficulty == 1
        if floor == 1
            return pbAddToTrainerPartyAverageLv(0)
        elsif floor == 2
            return pbAddToTrainerPartyAverageLv(0)
        elsif floor == 3
            return pbAddToTrainerPartyAverageLv(0)
        else
            return pbAddToTrainerPartyAverageLv(0)
        end
    #normal
    elsif difficulty == 0
        if floor == 1
                return 14 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 13
            elsif floor == 2
                return 29 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 28
            elsif floor == 3
                return 58 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 57
            else
                return 90 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 89
            end
    #easy
    elsif difficulty == -1
        if floor == 1
                return 12
            elsif floor == 2
                return 28
            elsif floor == 3
                return 55
            else
                return 85
            end
    end
end

def pbGetLvMiddle
    difficulty = pbGetDifficulty
    floor = pbGet(48) + 1
    #hard
    if difficulty == 1
        if floor == 1
            return pbAddToTrainerPartyAverageLv(1)
        elsif floor == 2
            return pbAddToTrainerPartyAverageLv(2)
        elsif floor == 3
            return pbAddToTrainerPartyAverageLv(2)
        else
            return pbAddToTrainerPartyAverageLv(2)
        end
    #normal
    elsif difficulty == 0
        if floor == 1
                return 12
            elsif floor == 2
                return 30
            elsif floor == 3
                return 60
            else
                return 88
            end
    #easy
    elsif difficulty == -1
        if floor == 1
                return 11
            elsif floor == 2
                return 28
            elsif floor == 3
                return 55
            else
                return 83
            end
    end
end

def pbGetLvGrunt
    difficulty = pbGetDifficulty
    floor = pbGet(48) + 1
    #hard
    if difficulty == 1
        if floor == 1
            return pbAddToTrainerPartyAverageLv(-2)
        elsif floor == 2
            return pbAddToTrainerPartyAverageLv(1)
        elsif floor == 3
            return pbAddToTrainerPartyAverageLv(1)
        else
            return pbAddToTrainerPartyAverageLv(1)
        end
    #normal
    elsif difficulty == 0
        if floor == 1
                return 13 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 11
            elsif floor == 2
                return 30 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 28
            elsif floor == 3
                return 57 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 55
            else
                return 87 if pbGet(49) * 2 > Settings::ROOMS_PER_STAGE + 1
                return 85
            end
    #easy
    elsif difficulty == -1
        if floor == 1
                return 10
            elsif floor == 2
                return 25
            elsif floor == 3
                return 53
            else
                return 80
            end
    end
end

def pbGetBossLv
    difficulty = pbGetDifficulty
    floor = pbGet(48) + 1
    #hard
    if difficulty == 1
        return pbAddToTrainerPartyAverageLv(5)
    #normal
    elsif difficulty == 0
        if floor == 1
                return 16
            elsif floor == 2
                return 32
            elsif floor == 3
                return 60
            else
                return 92
            end
    #easy
    elsif difficulty == -1
        if floor == 1
                return 14
            elsif floor == 2
                return 29
            elsif floor == 3
                return 56
            else
                return 85
            end
    end

end

def pbRollMintSale
    mints = %i[ADAMANTMINT BOLDMINT IMPISHMINT MODESTMINT CALMMINT CAREFULMINT TIMIDMINT JOLLYMINT NAIVEMINT]
    return mints[rand(mints.length)]
end

def pbGetMints(saleMint)
    mints = %i[ADAMANTMINT BOLDMINT IMPISHMINT MODESTMINT CALMMINT CAREFULMINT TIMIDMINT JOLLYMINT NAIVEMINT]
    mints.each do |i|
        setPrice(i, 1500, 0)
    end

    oldPrice = $game_temp.mart_prices[saleMint][0]
    newPrice = ((oldPrice * 0.5).ceil).to_i
    setPrice(saleMint, newPrice, 0)
    reorderedMints = [saleMint]
    reorderedMints = reorderedMints.clone
    mints -= reorderedMints
    reorderedMints += mints
    return reorderedMints
end

def pbGetAllTms
    return %i[TM03 TM04 TM05 TM10 TM17 TM18 TM25 TM48 TM65 TM70 TR01 TR37 TR38 TR48 TM06 TM22 TM39 TM43 TM92 TM95 TR02
              TR04 TR05 TR08 TR10 TR11 TR15 TR16 TR19 TR22 TR28 TR32 TR33 TR39 TR47 TR49 TR53 TR57 TR58 TR59 TR60 TR61
              TR62 TR63 TR64 TR65 TR66 TR67 TR70 TR73 TR74 TR75 TR81 TR86 TR89 TR90 TR92 TR97 TR98 TR99 TM28 TM56 TM63
              TM80 TR00 TR18 TR51 TR68 TR84]
end

def pbRollTmSale(tms = pbGetAllTms.clone, saleItemCount = 5)
    #tms = pbGetAllTms.clone
    # Generate index array of tms
    itemSlots = []
    (0...tms.length).each do |i|
        itemSlots.push(i)
    end

    # Shuffle and take the first 5 indexes, then sort them
    itemSlots = itemSlots.shuffle
    #saleItemCount = 5
    saleSlots = []
    (0...saleItemCount).each do |i|
        saleSlots.push(itemSlots[i])
    end
    saleSlots = saleSlots.sort

    # Return the corresponding TMs to the saleSlots array
    saleTms = []
    saleSlots.each do |slot|
        saleTms.push(tms[slot])
    end
    return [tms, saleTms]
end

  def pbsetPrice(item, buy_price = -1, sell_price = -1)
    item = GameData::Item.get(item).id
    $game_temp.mart_prices[item] = [-1, -1] if !$game_temp.mart_prices[item]
    $game_temp.mart_prices[item][0] = buy_price if buy_price > 0
    if sell_price >= 0   # 0=can't sell
      $game_temp.mart_prices[item][1] = sell_price * 2
    else
      $game_temp.mart_prices[item][1] = buy_price if buy_price > 0
    end
  end

def pbGetTms(tms = pbGetAllTms.clone, saleTms)
    items_cheap = %i[TM03 TM04 TM05 TM10 TM17 TM18 TM25 TM48 TM65 TM70 TR01 TR37 TR38 TR48]
    items_cheap.each do |i|
       pbsetPrice(i, 500, 0)
    end

    items_normal = %i[TM06 TM22 TM39 TM43 TM92 TM95 TR02 TR04 TR05 TR08 TR10 TR11 TR15 TR16 TR19 TR22 TR28 TR32 TR33 TR39 TR47 TR49 TR53 TR57
     TR58 TR59 TR60 TR61 TR62 TR63 TR64 TR65 TR66 TR67 TR70 TR73 TR74 TR75 TR81 TR86 TR89 TR90 TR92 TR97 TR98 TR99]
    items_normal.each do |i|
        pbsetPrice(i, 1000, 0)
    end

    items_expensive = %i[TM28 TM56 TM63 TM80 TR00 TR18 TR51 TR68 TR84]
    items_expensive.each do |i|
        pbsetPrice(i, 1500, 0)
    end

    reorderedTms = []

    saleTms.each do |myItem|
        oldPrice = $game_temp.mart_prices[myItem][0]
        newPrice = ((oldPrice * 0.7).ceil).to_i
        pbsetPrice(myItem, newPrice, 0)
        reorderedTms.push(myItem)
    end

    reorderedTms = reorderedTms.clone
    tms -= reorderedTms
    reorderedTms += tms
    return reorderedTms
end

def pbRollTms
    items_cheap = %i[TM03 TM04 TM05 TM10 TM17 TM18 TM25 TM48 TM65 TM70 TR01 TR37 TR38 TR48]
    items_normal = %i[TM06 TM22 TM39 TM43 TM92 TM95 TR02 TR04 TR05 TR08 TR10 TR11 TR15 TR16 TR19 TR22 TR28 TR32 TR33 TR39 TR47 TR49 TR53 TR57
         TR58 TR59 TR60 TR61 TR62 TR63 TR64 TR65 TR66 TR67 TR70 TR73 TR74 TR75 TR81 TR86 TR89 TR90 TR92 TR97 TR98 TR99]
    items_expensive = %i[TM28 TM56 TM63 TM80 TR00 TR18 TR51 TR68 TR84]

    items_cheap = pbRollTmSale(items_cheap.clone, saleItemCount = 5)[1]
    items_normal = pbRollTmSale(items_normal.clone, saleItemCount = 15)[1]
    items_expensive = pbRollTmSale(items_expensive.clone, items_expensive = 3)[1]

    output = items_cheap
    output += items_normal
    output += items_expensive

    return output
end

def pbSetAchvDone(index)
    if (index >= 0 && index <=8)
        filename = "achievements.txt"
        achvsStatus = pbReadFile(filename)
        count = pbGetAchvs.length
        if achvsStatus.length != count
            status = ""
            (0...count).each do |i|
                status +="0"
            end
            pbWriteIntoFile(filename, status)
            achvsStatus = pbReadFile(filename)
        end
        achvsStatus[index] = "1"
        pbWriteIntoFile(filename, achvsStatus)
    end
end

def pbGetAchvs
    return %i[JUSTANORMALGUY0 EXPERT0 FIRSTTRY0 MULTITALENT0 DISCSAREOUTDATED0 NORISKNOFUN0 REJECTED0 TOPTHREE0 PERFECTRUN0]
end

def pbGetAchvsCompleted
    return %i[JUSTANORMALGUY1 EXPERT1 FIRSTTRY1 MULTITALENT1 DISCSAREOUTDATED1 NORISKNOFUN1 REJECTED1 TOPTHREE1 PERFECTRUN1]
end

def pbShowAchvs
    count = pbGetAchvs.length
    filename = "achievements.txt"
    achvsStatus = pbReadFile(filename)
    achvs = pbGetAchvs.clone
    if achvsStatus.length == count
        completed = pbGetAchvsCompleted.clone
        (0...achvsStatus.length).each do |i|
           achvs[i] = completed[i] if achvsStatus[i] == '1'
        end
        pbPokemonMartEarn(achvs, nil, false, 5)
    else
        pbPokemonMartEarn(achvs, nil, false, 5)
    end
end

def pbCheckAchvsAfterRun
    if !pbAllAchvs?
        pbSetAchvDone(0) if pbGetDifficulty == 0
        pbSetAchvDone(1) if pbGetDifficulty == 1
        pbSetAchvDone(2) if pbGet(51) == true # reset on restart
        pbSetAchvDone(3) if pbCheckMultiTalent(pbGetGameMode)
        pbSetAchvDone(4) if pbGet(52) == true # reset on restart
        pbSetAchvDone(5) if pbGet(53) == true # reset on restart
        pbSetAchvDone(6) if pbGet(54) == true # reset on restart
        pbSetAchvDone(7) if pbGet(55) == true # reset on restart
        pbSetAchvDone(8) if ($Trainer.mystery_gifts.length == 0) && (pbGet(56) == true)
        if pbAllAchvs?
            pbMessage("\\c[10]All achievements unlocked\\c[0].")
            pbReceiveItem(:PREMIUMSOAP)
        end
    end
end

def pbUpdateTop3
  pbSet(55, false) if $Trainer.party.length > 3
end

def pbUpdateRejected
    pbSet(54, false) if pbGet(47) == false
    pbSet(47, false)
end

def pbCheckMultiTalent(gamemode)
    filename = "gamemodesbeaten.txt"
    data = pbReadFile(filename)
    if data.length <= pbGetGameModes.length
        data = data.chars
        gamemode = [gamemode.to_s]
        data -= gamemode
        data += gamemode
        allModes = ["0","1","2","3","4"]
        allModes -= data

        newData = ""
        data.each do |i|
            newData += i
        end
        pbWriteIntoFile(filename, newData)

        return true if allModes.length == 0
    end
    return false
end

def pbAllAchvs?
    count = pbGetAchvs.length
    filename = "achievements.txt"
    achvsStatus = pbReadFile(filename)
    allAchvs = ""
    (1..count).each do |i|
        allAchvs += "1"
    end

    return true if achvsStatus == allAchvs
    return false
end

def pbUpdatePerfectRun
    pbSet(56, false) if pbSomeFainted?
end

def pbSomeFainted?
    n = $Trainer.party.length
    (0..n).each do |i|
        if $Trainer.party[n - i] && !$Trainer.party[n - i].able?
            return true
        end
    end
    return false
end

def pbGetRemainingTMs
   pbSet(45, pbRollTmSale(pbRollTms,3)) if !(pbGet(45)[1].kind_of?(Array))
   pbSet(45, pbRollTmSale(pbRollTms,3)) if !(pbGet(45)[0].kind_of?(Array))
   allTMs = pbGetTms(pbGet(45)[0], pbGet(45)[1]).clone
   ownedTMs = []
   # Slot 4 is the TM slot in the bag
   $PokemonBag.pockets[4].each do |item|
    ownedTMs.push(item[0])
   end
   allTMs -= ownedTMs
   return allTMs
end

def pbRerollMoney?
    price = 500
    return true if $Trainer.money >= price
    return false
end

def pbScout
pbMessage(pbRollTms.length.to_s)
pbMessage(pbRollTms.to_s)
end