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

def pbLvUpAllPkmn(targetLevel)
    # Level up party
    $Trainer.party.each do |pkmn|
         if pkmn != nil
             if pkmn.level < targetLevel
                     pbChangeLevel(pkmn, targetLevel, nil)
             end
         end
    end

    # Level up box
    $PokemonStorage.boxes.each do |box|
    box.each do |pkmn|
        if pkmn != nil
              if pkmn.level < targetLevel
                       pbChangeLevel(pkmn, targetLevel, nil)
              end
           end
        end
    end
end
