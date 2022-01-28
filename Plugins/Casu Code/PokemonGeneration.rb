POKEMON_GET_LEVEL = [15, 30, 60, 90]

def pbGenPokeChoice
    stages_cleared = pbGet(48)
    lvl = POKEMON_GET_LEVEL[stages_cleared]
  
    pkmn = pbChooseRandomPokemon(
    whiteList=nil,
    blackList="suggested",
    addList=nil,
    base_only=true,
    choose_gen=[1,2,3,4,5])
    
    pbSet(26, pbGetCorrectEvo(pkmn, lvl))
    
    pkmn = pbChooseRandomPokemon(
    whiteList=nil,
    blackList="suggested",
    addList=nil,
    base_only=true,
    choose_gen=[1,2,3,4,5])
    
    pbSet(27, pbGetCorrectEvo(pkmn, lvl))
    
    pkmn = pbChooseRandomPokemon(
    whiteList=nil,
    blackList="suggested",
    addList=nil,
    base_only=true,
    choose_gen=[1,2,3,4,5])
    
    pbSet(28, pbGetCorrectEvo(pkmn, lvl))
  end

  def pbGetCorrectEvo(pkmn, lvl)
    res = pkmn
    nxt = pkmn
    while nxt
      res = nxt
      nxt = pbGenPkmn(nxt, lvl).check_evolution_on_level_up
    end
    return res
  end

  def pbGenStarterPkmn(type)
    pkmn = pbChooseRandomPokemon(
      whiteList=[:BULBASAUR, :CHARMANDER, :SQUIRTLE, :CHIKORITA, :CYNDAQUIL, :TOTODILE, :TREECKO, :TORCHIC, :MUDKIP, :TURTWIG, :CHIMCHAR, :PIPLUP, :SNIVY, :TEPIG, :OSHAWOTT], 
      blackList="suggested", 
      addList=nil,                          
      base_only=true, 
      choose_gen=[1,2,3,4,5], 
      typeWhitelist=[type]
      )
  end
  
  def pbGiveRandomPoke(saveSlot)
    stages_cleared = pbGet(48)
    lvl = lvl = POKEMON_GET_LEVEL[stages_cleared]
    
    pkmn = pbGenPkmn(pbGet(saveSlot), lvl)
    pbAddPokemon(pkmn)
  end