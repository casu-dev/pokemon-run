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

def pbLvUpAllPkmn(targetLevel)
$k=0
while $k < 6  do
pbChangeLevel($Trainer.party[$k],targetLevel,nil) if $Trainer.party[$k] !=nil
$k +=1
end
$i=0
$j=0
$CountBoxes=30
$CountPkmnEachBox=30
while $i < $CountBoxes  do
	while $j < $CountPkmnEachBox  do			
		# $PokemonStorage[$i][$j].level= targetLevel if $PokemonStorage[$i][$j]!=nil
		pbChangeLevel($PokemonStorage[$i][$j],targetLevel,nil) if $PokemonStorage[$i][$j]!=nil	
		$j+=1
	end
$j = 0
$i +=1
end
end


