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
  commands2[cmdBuy = commands2.length]  = _INTL('No')
  commands2[cmdSell = commands2.length] = _INTL('Yes')
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
      evo.pbStartScreen(pkmn, evo_info[cmd][0])
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
    if stones != []
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
end

def pbSetMartPrices
  items_cheap = %w[TM03 TM04 TM05 TM10 TM17 TM18 TM25 TM34 TM48 TM65 TR01 TR48]
  items_cheap.each do |i|
    setPrice(i, 500, 0)
  end

  items_normal = %w[TM39 TM43 TM92 TR02 TR04 TR05 TR08 TR10 TR11 TR15 TR16 TR22 TR28 TR32 TR33 TR39 TR47 TR49 TR58 TR62 TR64 TR65 TR70
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
      $Lv = pbGetPkmnTargetLvl
      $TargetEv = 0
      $TargetEv = 46 if $Lv == 30
      $TargetEv = 69 if $Lv == 60
      $TargetEv = 84 if $Lv == 90

      pkmn.ev[:HP] = $TargetEv
      pkmn.ev[:ATTACK] = $TargetEv
      pkmn.ev[:DEFENSE] = $TargetEv
      pkmn.ev[:SPECIAL_ATTACK] = $TargetEv
      pkmn.ev[:SPECIAL_DEFENSE] = $TargetEv
      pkmn.ev[:SPEED] = $TargetEv
end

def pbChangeAllPkmnEv
  $Lv = pbGetPkmnTargetLvl
  $TargetEv = 0
  $TargetEv = 46 if $Lv == 30
  $TargetEv = 69 if $Lv == 60
  $TargetEv = 84 if $Lv == 90

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
    end
  end

  # EV up boxx
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
      end
    end
  end
end

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
    old = (old + 1).to_s
    pbWriteIntoFile("runcompletedcount.txt", text = old)
    pbMessage(_INTL("You unlocked a new game mode.")) if (old.to_i+1) <= pbGetGameModes.length()
    pbMessage(_INTL("You unlocked all game modes.")) if (old.to_i+1) == pbGetGameModes.length()
end

def pbChoseMode
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
            speech || _INTL('Which game mode do you want to play?'), shownmodes)

            loop do
                if cmd2 == 0
                    pbWriteIntoFile("gamemode.txt", 0)
                    pbWriteIntoFile("battlerinfo.txt", 0)
                    pbPlaySaveSound
                    pbMessage(_INTL("Game mode set to "+ pbGetGameModes[cmd2] +"."))
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
                     pbMessage(_INTL("Game mode set to "+ pbGetGameModes[cmd2] +". The " + info + " stat of YOUR Pokémon will be swapped in battle."))
                     break
                elsif cmd2 == 2
                     pbWriteIntoFile("gamemode.txt", 2)
                     pbWriteIntoFile("battlerinfo.txt", 11)
                     pbPlaySaveSound
                     pbMessage(_INTL("Game mode set to "+ pbGetGameModes[cmd2] +". The first Pokémon in your party will have the ability of the last one in battle."))
                     break
                elsif cmd2 == 3
                                     pbWriteIntoFile("gamemode.txt", 3)
                                     pbWriteIntoFile("battlerinfo.txt", 0)
                                     pbPlaySaveSound
                                     pbMessage(_INTL("Game mode set to "+ pbGetGameModes[cmd2] +". All your Pokémon will not be fully evolved, but their moves have their secondary effect chance tripled."))
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
    return ["Standard", "Stat-Swap", "Copy-Ability", "Lucky weakling"]
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

def pbResetAssistant
size = $Trainer.party.length()
    if size == 0
        speech = nil
        yn = ["Yes", "No"]
        cmd2 = pbMessage(speech || _INTL('You want to start the new run without one of your old Pokémon?'), yn)
            loop do
                if cmd2 == 0
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
                cmd2 = pbMessage(speech || _INTL("You want to start the new run with " + $Trainer.party[0].name + "?"), yn)
                    loop do
                        if cmd2 == 0
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

def pbkAddPokemon(pkmn, level = 1, see_form = true, hiddenAbility = false)
    if hiddenAbility
          return false if !pkmn
          if pbBoxesFull?
            pbMessage(_INTL("There's no more room for Pokémon!\1"))
            pbMessage(_INTL("The Pokémon Boxes are full and can't accept any more!"))
            return false
          end
          pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
          species_name = pkmn.speciesName
          # Set hidden ability
          pkmn.setAbility(2)
          pbSetPkmnEv(pkmn)
          pbMessage(_INTL("{1} obtained {2}!\\me[Pkmn get]\\wtnp[80]\1", $Trainer.name, species_name))
          pbNicknameAndStore(pkmn)
          $Trainer.pokedex.register(pkmn) if see_form
          return true
    else
          return false if !pkmn
          if pbBoxesFull?
            pbMessage(_INTL("There's no more room for Pokémon!\1"))
            pbMessage(_INTL("The Pokémon Boxes are full and can't accept any more!"))
            return false
          end
          pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
          species_name = pkmn.speciesName
          pbSetPkmnEv(pkmn)
          pbMessage(_INTL("{1} obtained {2}!\\me[Pkmn get]\\wtnp[80]\1", $Trainer.name, species_name))
          pbNicknameAndStore(pkmn)
          $Trainer.pokedex.register(pkmn) if see_form
          return true
    end
end

def pbOakSpawn4
    if  pbReadFile("gamemode.txt").to_i != 3
        pbMessage(_INTL("Gratulations to your victory! This is the last Floor. It's gonna be tough. I think you're ready for Mega-Evolutions. Take one of these Pokémon."))
        pbRandomPkmnSelection(pbGetPkmnTargetLvl, true)
        pbReceiveItem(:MEGARING)
        pbMessage(_INTL("Okay, now take one of my Mega-Stones."))
        pbOfferUsableMegaStones
        pbMessage(_INTL("Excellent choice! Equip the Mega-Stone and press Y in Battle to mega evolve. I'm continuing my research now, have a good one!"))
    else
        pbMessage(_INTL("Gratulations to your victory! This is the last Floor. It's gonna be tough. Take one of these Pokémon."))
        pbRandomPkmnSelection(pbGetPkmnTargetLvl)
        pbMessage(_INTL("Excellent choice! I'm continuing my research now, have a good one!"))
    end
end

def pbCanEvoInCurrentMode(pkmn)
    if pbReadFile("gamemode.txt").to_i != 3
        return can_evolve?(pkmn)
    else
        if can_evolve?(pkmn)
            return false if GameData::Species.try_get(GameData::Species.try_get(pkmn.species).get_evolutions[0][0]).get_evolutions.empty? #Returns false, if evolution cant evolve.
            return true
        end
    end
end

def pbScout
pbMessage(_INTL("Room scripts actice"))
end