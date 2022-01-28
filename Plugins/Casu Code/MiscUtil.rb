
def pbDeleteFainted
    n = $Trainer.party.length
    for i in (0..n)
      $Trainer.party.delete_at(n-i) if $Trainer.party[n-i] && !$Trainer.party[n-i].able?
    end
  end

# Not used
def pbGiveAllExp(amount = 500)
    lvls = []
  
    $Trainer.party.each_with_index do |pkmn,i| 
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
        print("level up")
        pkmn.calc_stats
    end
end
  