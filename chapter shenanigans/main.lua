local mod = RegisterMod('Chapter Shenanigans', 1)
local game = Game()

if REPENTOGON then
  function mod:onModsLoaded()
    mod:setupImGui()
  end
  
  function mod:unlockAchievement(achievement, unlock)
    if unlock then
      local gameData = Isaac.GetPersistentGameData()
      gameData:TryUnlock(achievement)
    else
      Isaac.ExecuteCommand('lockachievement ' .. achievement)
    end
  end
  
  function mod:localize(key)
    for _, category in ipairs({ 'Stages', 'Entities', 'Items', 'Players' }) do
      local s = Isaac.GetString(category, key)
      
      if s ~= nil and s ~= 'StringTable::InvalidCategory' and s ~= 'StringTable::InvalidKey' then
        return s
      end
    end
    
    return key
  end
  
  function mod:localizeHelper(str)
    return string.gsub(str, '(#[%w_]+)', function(s)
      return mod:localize(s)
    end)
  end
  
  function mod:padName(name, num)
    local pad
    if Options.Language == 'jp' or Options.Language == 'kr' or Options.Language == 'zh' then
      pad = '\u{3000}' -- ideographic space
      
      local codes = {}
      for _, c in utf8.codes(name) do
        if c == 0x20 then -- space
          table.insert(codes, 0x3000)
        elseif c >= 0x21 and c <= 0x7E then -- ascii chars
          table.insert(codes, c + 0xFEE0) -- full width chars
        else
          table.insert(codes, c)
        end
      end
      name = utf8.char(table.unpack(codes))
    else
      pad = ' ' -- space
    end
    
    local nameLength = utf8.len(name) -- string.len
    if num > nameLength then
      local diff = num - nameLength
      if diff % 2 ~= 0 then
        name = pad .. name -- extra space before name
        diff = diff - 1
      end
      if diff > 0 then
        local halfDiff = diff / 2
        name = string.rep(pad, halfDiff) .. name .. string.rep(pad, halfDiff)
      end
    end
    
    return name
  end
  
  function mod:setupImGuiMenu()
    if not ImGui.ElementExists('shenanigansMenu') then
      ImGui.CreateMenu('shenanigansMenu', '\u{f6d1} Shenanigans')
    end
  end
  
  function mod:setupImGui()
    ImGui.AddElement('shenanigansMenu', 'shenanigansMenuItemChapters', ImGuiElement.MenuItem, '\u{e0bb} Chapter Shenanigans')
    ImGui.CreateWindow('shenanigansWindowChapters', 'Chapter Shenanigans')
    ImGui.LinkWindowToElement('shenanigansWindowChapters', 'shenanigansMenuItemChapters')
    
    ImGui.AddTabBar('shenanigansWindowChapters', 'shenanigansTabBarChapters')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChapters', 'Chapters')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersTwo', 'Chapters 2')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersModes', 'Modes')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersBosses', 'Bosses')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersEntities', 'Entities')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersRooms', 'Rooms')
    
    local chapters = {
      {
        name = 'Chapter 1',
        options = {
          { name = '#BASEMENT_NAME'        , achievement = -1 },
          { name = '#CELLAR_NAME'          , achievement = Achievement.CELLAR },
          { name = '#BURNING_BASEMENT_NAME', achievement = Achievement.BURNING_BASEMENT },
        }
      },
      {
        name = 'Chapter 1.5',
        options = {
          { name = '#DOWNPOUR_NAME', achievement = Achievement.SECRET_EXIT, hint = 'A secret exit in boss rooms' },
          { name = '#DROSS_NAME'   , achievement = Achievement.DROSS },
        }
      },
      {
        name = 'Chapter 2',
        options = {
          { name = '#CAVES_NAME'        , achievement = -1 },
          { name = '#CATACOMBS_NAME'    , achievement = Achievement.CATACOMBS },
          { name = '#FLOODED_CAVES_NAME', achievement = Achievement.FLOODED_CAVES },
        }
      },
      {
        name = 'Chapter 2.5',
        options = {
          { name = '#MINES_NAME' , achievement = Achievement.SECRET_EXIT, hint = 'A secret exit in boss rooms' },
          { name = '#ASHPIT_NAME', achievement = Achievement.ASHPIT },
        }
      },
      {
        name = 'Chapter 3',
        options = {
          { name = '#DEPTHS_NAME'     , achievement = -1 },
          { name = '#NECROPOLIS_NAME' , achievement = Achievement.NECROPOLIS },
          { name = '#DANK_DEPTHS_NAME', achievement = Achievement.DANK_DEPTHS },
        }
      },
      {
        name = 'Chapter 3.5',
        options = {
          { name = '#MAUSOLEUM_NAME', achievement = Achievement.SECRET_EXIT, hint = 'A secret exit in boss rooms' },
          { name = '#GEHENNA_NAME'  , achievement = Achievement.GEHENNA },
        }
      },
      {
        name = 'Chapter 4',
        options = {
          { name = '#WOMB_NAME'        , achievement = Achievement.WOMB },
          { name = '#UTERO_NAME'       , achievement = Achievement.WOMB },
          { name = '#SCARRED_WOMB_NAME', achievement = Achievement.SCARRED_WOMB },
        }
      },
      {
        name = 'Chapter 4.5',
        options = {
          { name = '#BLUE_WOMB_NAME', achievement = Achievement.BLUE_WOMB, hint = 'Blue Womb' },
          { name = '#CORPSE_NAME'   , achievement = Achievement.SECRET_EXIT, hint = 'A secret exit in boss rooms' },
        }
      },
      {
        name = 'Chapter 5',
        options = {
          { name = '#SHEOL_NAME'    , achievement = Achievement.IT_LIVES, hint = '#IT_LIVES' },
          { name = '#CATHEDRAL_NAME', achievement = Achievement.IT_LIVES, hint = '#IT_LIVES' },
        }
      },
      {
        name = 'Chapter 6',
        options = {
          { name = '#DARK_ROOM_NAME', achievement = Achievement.THE_NEGATIVE, hint = '#THE_NEGATIVE_NAME' },
          { name = '#CHEST_NAME'    , achievement = Achievement.THE_POLAROID, hint = '#THE_POLAROID_NAME' },
        }
      },
      {
        name = 'Endgame',
        options = {
          { name = '#THE_VOID_NAME'     , achievement = Achievement.THE_VOID },
          { name = '#HOME_NAME (Ascent)', achievement = Achievement.A_STRANGE_DOOR, hint = 'A strange door in #DEPTHS_NAME II' },
        }
      },
    }
    
    local modes = {
      {
        name = 'Normal Mode',
        options = {
          { name = 'Normal'  , achievement = -1 },
          { name = 'Hard'    , achievement = -1 },
        }
      },
      {
        name = 'Greed Mode',
        options = {
          { name = 'Greed'   , achievement = -1 },
          { name = 'Greedier', achievement = Achievement.GREEDIER },
        }
      },
      {
        name = 'Xtra Modes',
        options = {
          { name = 'RERUN'   , achievement = Achievement.RERUNS },
        }
      },
    }
    
    local bosses = {
      {
        name = 'Everything Is Terrible',
        options = {
          { name = 'Everything Is Terrible!!!'  , achievement = Achievement.EVERYTHING_IS_TERRIBLE  , hint = 'The game just got harder! (More curses, half soul hearts, etc)' },
          { name = 'Everything Is Terrible 2!!!', achievement = Achievement.EVERYTHING_IS_TERRIBLE_2, hint = 'Greed mode just got harder!' },
        }
      },
      {
        name = 'The Harbingers',
        options = {
          { name = '#FAMINE, #WAR, #PESTILENCE, #DEATH, #HEADLESS_HORSEMAN', achievement = Achievement.THE_HARBINGERS },
          { name = '#CONQUEST'                                             , achievement = Achievement.CONQUEST },
        }
      },
      {
        name = 'Something Wicked This Way Comes',
        options = {
          { name = '#RAG_MAN, #LITTLE_HORN, #DANGLE, #TURDLING, #THE_FRAIL, #THE_STAIN, #THE_FORSAKEN, #BROWNIE', achievement = Achievement.SOMETHING_WICKED     , hint = 'Afterbirth bosses' },
          { name = '#RAG_MEGA, #BIG_HORN, #SISTERS_VIS, #THE_MATRIARCH'                                         , achievement = Achievement.SOMETHING_WICKED_PLUS, hint = 'Afterbirth+ bosses' },
        }
      },
      {
        name = 'Chapter 1',
        options = {
          { name = '#STEVEN', achievement = Achievement.STEVEN },
        }
      },
      {
        name = 'Chapter 2',
        options = {
          { name = '#CHAD', achievement = Achievement.CHAD },
        }
      },
      {
        name = 'Chapter 3',
        options = {
          { name = '#GISH', achievement = Achievement.GISH },
        }
      },
      {
        name = 'Chapter 4',
        options = {
          { name = '#TRIACHNID', achievement = Achievement.TRIACHNID },
        }
      },
      {
        name = 'Chapter 6',
        options = {
          { name = '#MEGA_SATAN', achievement = Achievement.ANGELS, hint = 'Angel statues can be bombed' },
        }
      },
      {
        name = '#THE_VOID_NAME',
        options = {
          { name = '#PORTAL', achievement = Achievement.THE_GATE_IS_OPEN },
        }
      },
    }
    
    -- anything non-specific
    -- no active/passive items, no trinkets, no cards/runes
    local entities = {
      {
        name = 'Rocks',
        options = {
          { name = 'Super Special Rock', achievement = Achievement.SUPER_SPECIAL_ROCKS },
          { name = 'Fool\'s Gold'      , achievement = Achievement.FOOLS_GOLD },
        }
      },
      {
        name = 'Chests',
        options = {
          { name = 'Mega Chest'   , achievement = Achievement.MEGA_CHEST },
          { name = 'Wooden Chest' , achievement = Achievement.WOODEN_CHEST },
          { name = 'Haunted Chest', achievement = Achievement.HAUNTED_CHEST },
          { name = 'Black Sack'   , achievement = Achievement.BLACK_SACK },
        }
      },
      {
        name = 'Gold',
        options = {
          { name = 'Golden Heart'  , achievement = Achievement.GOLDEN_HEARTS },
          { name = 'Golden Bomb'   , achievement = Achievement.GOLDEN_BOMBS },
          { name = 'Golden Pill'   , achievement = Achievement.GOLDEN_PILLS },
          { name = 'Golden Penny'  , achievement = Achievement.GOLDEN_PENNIES },
          { name = 'Golden Battery', achievement = Achievement.GOLDEN_BATTERIES },
          { name = 'Golden Trinket', achievement = Achievement.GOLDEN_TRINKETS },
        }
      },
      {
        name = 'Hearts',
        options = {
          { name = 'Scared Heart', achievement = Achievement.SCARED_HEART },
          { name = 'Bone Heart'  , achievement = Achievement.BONE_HEARTS },
          { name = 'Rotten Heart', achievement = Achievement.ROTTEN_HEARTS },
        }
      },
      {
        name = 'Coins',
        options = {
          { name = 'Lucky Penny'  , achievement = Achievement.LUCKY_PENNIES },
          { name = 'Sticky Nickel', achievement = Achievement.STICKY_NICKELS },
        }
      },
      {
        name = 'Keys',
        options = {
          { name = 'Charged Key', achievement = Achievement.CHARGED_KEY },
        }
      },
      {
        name = 'Pills',
        options = {
          { name = 'Horse Pill', achievement = Achievement.HORSE_PILLS },
        }
      },
      {
        name = 'Poop',
        options = {
          { name = 'Charming Poop'   , achievement = Achievement.CHARMING_POOP },
        }
      },
      {
        name = 'Slots',
        options = {
          { name = 'Crane Game'   , achievement = Achievement.CRANE_GAME },
          { name = 'Hell Game'    , achievement = Achievement.HELL_GAME },
          { name = 'Confessional' , achievement = Achievement.CONFESSIONAL },
          { name = 'Rotten Beggar', achievement = Achievement.ROTTEN_BEGGAR },
        }
      },
    }
    
    local rooms = {
      {
        name = 'Planetariums',
        options = {
          { name = 'Enabled', achievement = Achievement.PLANETARIUMS },
        }
      },
    }
    
    for i, v in ipairs({
                        { tbl = chapters, tab = 'shenanigansTabChapters'        , chkIdPrefix = 'shenanigansChkChapter' },
                        { tbl = modes   , tab = 'shenanigansTabChaptersModes'   , chkIdPrefix = 'shenanigansChkChapterMode' },
                        { tbl = bosses  , tab = 'shenanigansTabChaptersBosses'  , chkIdPrefix = 'shenanigansChkChapterBoss' },
                        { tbl = entities, tab = 'shenanigansTabChaptersEntities', chkIdPrefix = 'shenanigansChkChapterEntity' },
                        { tbl = rooms   , tab = 'shenanigansTabChaptersRooms'   , chkIdPrefix = 'shenanigansChkChapterRoom' },
                      })
    do
      for j, w in ipairs(v.tbl) do
        local wName = w.name
        if i == 3 then -- bosses
          wName = mod:localizeHelper(wName)
        end
        ImGui.AddElement(v.tab, '', ImGuiElement.SeparatorText, wName)
        for k, x in ipairs(w.options) do
          local chkId = v.chkIdPrefix .. j .. '-' .. k
          local xName = x.name
          if i == 1 or i == 3 then -- chapters/bosses
            xName = mod:localizeHelper(xName)
          end
          ImGui.AddCheckbox(v.tab, chkId, xName, nil, false)
          if x.hint then
            local xHint = x.hint
            if i == 1 then -- chapters
              xHint = mod:localizeHelper(xHint)
            end
            ImGui.SetHelpmarker(chkId, xHint)
          end
          ImGui.AddCallback(chkId, ImGuiCallback.Render, function()
            local gameData = Isaac.GetPersistentGameData()
            local value = true
            if x.achievement > 0 then
              value = gameData:Unlocked(x.achievement)
            end
            ImGui.UpdateData(chkId, ImGuiData.Value, value)
          end)
          ImGui.AddCallback(chkId, ImGuiCallback.Edited, function(b)
            if x.achievement > 0 then
              mod:unlockAchievement(x.achievement, b)
            end
          end)
        end
      end
    end
    
    local momsHeart = mod:localize('#MOMS_HEART')
    local itLives = mod:localize('#IT_LIVES')
    local cmbMomsHeartId = 'shenanigansCmbChapterMomsHeart'
    local cmbMomsHeartOptions = {
      'No Mom Kills',
      'End 1 (#EDEN_NAME)',
      'End 2 (#RUBBER_CEMENT_NAME)',
      'End 3 (#TRANSCENDENCE_NAME)',
      'End 4 (#WIRE_COAT_HANGER_NAME)',
      'End 5 (Everything Is Terrible)',
      'End 6 (#IPECAC_NAME)',
      'End 7 (#EXPERIMENTAL_TREATMENT_NAME)',
      'End 8 (#A_QUARTER_NAME)',
      'End 9 (#DR_FETUS_NAME)',
      'End 10 (#BLUEBABY_NAME)',
      'End 11 (#IT_LIVES)',
    }
    for i, v in ipairs(cmbMomsHeartOptions) do
      cmbMomsHeartOptions[i] = mod:localizeHelper(v)
    end
    ImGui.AddElement('shenanigansTabChaptersBosses', '', ImGuiElement.SeparatorText, momsHeart)
    ImGui.AddCombobox('shenanigansTabChaptersBosses', cmbMomsHeartId, '', nil, cmbMomsHeartOptions, 0, true)
    ImGui.SetHelpmarker(cmbMomsHeartId, 'This will reset your MOM_KILLS stat and toggle the IT_LIVES achievement. This will auto-increment on your next mom kill.')
    ImGui.AddCallback(cmbMomsHeartId, ImGuiCallback.Render, function()
      local gameData = Isaac.GetPersistentGameData()
      local value
      if gameData:Unlocked(Achievement.IT_LIVES) then
        value = 11
      else
        value = gameData:GetEventCounter(EventCounter.MOM_KILLS)
        if value > 11 then
          value = 11
        end
      end
      ImGui.UpdateData(cmbMomsHeartId, ImGuiData.Value, value)
    end)
    ImGui.AddCallback(cmbMomsHeartId, ImGuiCallback.Edited, function(num)
      local gameData = Isaac.GetPersistentGameData()
      local stat = EventCounter.MOM_KILLS
      gameData:IncreaseEventCounter(stat, num - gameData:GetEventCounter(stat))
      if num < 11 then
        mod:unlockAchievement(Achievement.IT_LIVES, false)
      end
    end)
    local txtMomsHeartId = 'shenanigansTxtChapterMomsHeart'
    ImGui.AddText('shenanigansTabChaptersBosses', 'Mom Kills: 0 (Mom\'s Heart)', false, txtMomsHeartId)
    ImGui.AddCallback(txtMomsHeartId, ImGuiCallback.Render, function()
      local gameData = Isaac.GetPersistentGameData()
      local label = 'Mom Kills: ' .. gameData:GetEventCounter(EventCounter.MOM_KILLS) .. ' (' .. (gameData:Unlocked(Achievement.IT_LIVES) and itLives or momsHeart) .. ')'
      ImGui.UpdateData(txtMomsHeartId, ImGuiData.Label, label)
    end)
    
    for _, v in ipairs({
                        { intDonationId = 'shenanigansIntChapterDonationMachine'     , txtDonationId = 'shenanigansTxtChapterDonationMachine'     , label = 'Donation Machine'      , stat = EventCounter.DONATION_MACHINE_COUNTER },
                        { intDonationId = 'shenanigansIntChapterGreedDonationMachine', txtDonationId = 'shenanigansTxtChapterGreedDonationMachine', label = 'Greed Donation Machine', stat = EventCounter.GREED_DONATION_MACHINE_COUNTER },
                      })
    do
      ImGui.AddInputInteger('shenanigansTabChaptersEntities', v.intDonationId, v.label, nil, 0, 1, 100)
      ImGui.SetHelpmarker(v.intDonationId, 'To trigger achievements, you\'ll need to deposit a coin in the machine in-game.')
      ImGui.AddCallback(v.intDonationId, ImGuiCallback.Render, function()
        local gameData = Isaac.GetPersistentGameData()
        ImGui.UpdateData(v.intDonationId, ImGuiData.Value, gameData:GetEventCounter(v.stat))
      end)
      ImGui.AddCallback(v.intDonationId, ImGuiCallback.Edited, function(num)
        local gameData = Isaac.GetPersistentGameData()
        gameData:IncreaseEventCounter(v.stat, num - gameData:GetEventCounter(v.stat))
      end)
      ImGui.AddText('shenanigansTabChaptersEntities', v.label .. ' (normalized): 0 %% 1000 = 000', false, v.txtDonationId)
      ImGui.AddCallback(v.txtDonationId, ImGuiCallback.Render, function()
        local gameData = Isaac.GetPersistentGameData()
        local statValue = gameData:GetEventCounter(v.stat)
        local label = v.label .. ' (normalized): ' .. statValue .. ' %% 1000 = ' .. string.format('%03d', statValue % 1000)
        ImGui.UpdateData(v.txtDonationId, ImGuiData.Label, label)
      end)
    end
    
    local cmbShopLevelId = 'shenanigansCmbChapterShopLvl'
    ImGui.AddElement('shenanigansTabChaptersRooms', '', ImGuiElement.SeparatorText, 'Shops')
    ImGui.AddCombobox('shenanigansTabChaptersRooms', cmbShopLevelId, 'Shop Level', nil, { 'Level 0', 'Level 1', 'Level 2', 'Level 3', 'Level 4' }, 0, true)
    ImGui.AddCallback(cmbShopLevelId, ImGuiCallback.Render, function()
      local gameData = Isaac.GetPersistentGameData()
      local value = 0
      if gameData:Unlocked(Achievement.STORE_UPGRADE_LV4) then
        value = 4
      elseif gameData:Unlocked(Achievement.STORE_UPGRADE_LV3) then
        value = 3
      elseif gameData:Unlocked(Achievement.STORE_UPGRADE_LV2) then
        value = 2
      elseif gameData:Unlocked(Achievement.STORE_UPGRADE_LV1) then
        value = 1
      end
      ImGui.UpdateData(cmbShopLevelId, ImGuiData.Value, value)
    end)
    ImGui.AddCallback(cmbShopLevelId, ImGuiCallback.Edited, function(num)
      if num == 0 then
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV1, false)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV2, false)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV3, false)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV4, false)
      elseif num == 1 then
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV1, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV2, false)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV3, false)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV4, false)
      elseif num == 2 then
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV1, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV2, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV3, false)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV4, false)
      elseif num == 3 then
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV1, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV2, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV3, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV4, false)
      elseif num == 4 then
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV1, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV2, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV3, true)
        mod:unlockAchievement(Achievement.STORE_UPGRADE_LV4, true)
      end
    end)
    
    local chapters2 = {
      {
        name = 'Chapter 1',
        options = {
          { name = '#BASEMENT_NAME I'         , stage = '1' , greedStage = '1' , sameLine = true },
          { name = '#BASEMENT_NAME II'        , stage = '2' , greedStage = '1' },
          { name = '#CELLAR_NAME I'           , stage = '1a', greedStage = '1a', sameLine = true },
          { name = '#CELLAR_NAME II'          , stage = '2a', greedStage = '1a' },
          { name = '#BURNING_BASEMENT_NAME I' , stage = '1b', greedStage = '1b', sameLine = true },
          { name = '#BURNING_BASEMENT_NAME II', stage = '2b', greedStage = '1b' },
        }
      },
      {
        name = 'Chapter 1.5',
        options = {
          { name = '#DOWNPOUR_NAME I' , stage = '1c', greedStage = '1c', sameLine = true },
          { name = '#DOWNPOUR_NAME II', stage = '2c', greedStage = '1c' },
          { name = '#DROSS_NAME I'    , stage = '1d', greedStage = '1d', sameLine = true },
          { name = '#DROSS_NAME II'   , stage = '2d', greedStage = '1d' },
        }
      },
      {
        name = 'Chapter 2',
        options = {
          { name = '#CAVES_NAME I'         , stage = '3' , greedStage = '2' , sameLine = true },
          { name = '#CAVES_NAME II'        , stage = '4' , greedStage = '2' },
          { name = '#CATACOMBS_NAME I'     , stage = '3a', greedStage = '2a', sameLine = true },
          { name = '#CATACOMBS_NAME II'    , stage = '4a', greedStage = '2a' },
          { name = '#FLOODED_CAVES_NAME I' , stage = '3b', greedStage = '2b', sameLine = true },
          { name = '#FLOODED_CAVES_NAME II', stage = '4b', greedStage = '2b' },
        }
      },
      {
        name = 'Chapter 2.5',
        options = {
          { name = '#MINES_NAME I'  , stage = '3c', greedStage = '2c', sameLine = true },
          { name = '#MINES_NAME II' , stage = '4c', greedStage = '2c' },
          { name = '#ASHPIT_NAME I' , stage = '3d', greedStage = '2d', sameLine = true },
          { name = '#ASHPIT_NAME II', stage = '4d', greedStage = '2d' },
        }
      },
      {
        name = 'Chapter 3',
        options = {
          { name = '#DEPTHS_NAME I'      , stage = '5' , greedStage = '3' , sameLine = true },
          { name = '#DEPTHS_NAME II'     , stage = '6' , greedStage = '3' },
          { name = '#NECROPOLIS_NAME I'  , stage = '5a', greedStage = '3a', sameLine = true },
          { name = '#NECROPOLIS_NAME II' , stage = '6a', greedStage = '3a' },
          { name = '#DANK_DEPTHS_NAME I' , stage = '5b', greedStage = '3b', sameLine = true },
          { name = '#DANK_DEPTHS_NAME II', stage = '6b', greedStage = '3b' },
        }
      },
      {
        name = 'Chapter 3.5',
        options = {
          { name = '#MAUSOLEUM_NAME I' , stage = '5c', greedStage = '3c', sameLine = true },
          { name = '#MAUSOLEUM_NAME II', stage = '6c', greedStage = '3c', sameLine = true },
          { name = '#DADS_NOTE_NAME'   , stage = '6c', greedStage = '3c', preAscent = true },
          { name = '#GEHENNA_NAME I'   , stage = '5d', greedStage = '3d', sameLine = true },
          { name = '#GEHENNA_NAME II'  , stage = '6d', greedStage = '3d', sameLine = true },
          { name = '#DADS_NOTE_NAME'   , stage = '6d', greedStage = '3d', preAscent = true },
        }
      },
      {
        name = 'Chapter 4',
        options = {
          { name = '#WOMB_NAME I'         , stage = '7' , greedStage = '4' , sameLine = true },
          { name = '#WOMB_NAME II'        , stage = '8' , greedStage = '4' },
          { name = '#UTERO_NAME I'        , stage = '7a', greedStage = '4a', sameLine = true },
          { name = '#UTERO_NAME II'       , stage = '8a', greedStage = '4a' },
          { name = '#SCARRED_WOMB_NAME I' , stage = '7b', greedStage = '4b', sameLine = true },
          { name = '#SCARRED_WOMB_NAME II', stage = '8b', greedStage = '4b' },
        }
      },
      {
        name = 'Chapter 4.5',
        options = {
          { name = '#BLUE_WOMB_NAME', stage = '9' },
          { name = '#CORPSE_NAME I' , stage = '7c', greedStage = '4c', sameLine = true },
          { name = '#CORPSE_NAME II', stage = '8c', greedStage = '4c' },
        }
      },
      {
        name = 'Chapter 5',
        options = {
          { name = '#SHEOL_NAME'    , stage = '10' , greedStage = '5' },
          { name = '#CATHEDRAL_NAME', stage = '10a', greedStage = '5a' },
        }
      },
      {
        name = 'Chapter 6',
        options = {
          { name = '#DARK_ROOM_NAME', stage = '11' },
          { name = '#CHEST_NAME'    , stage = '11a' },
        }
      },
      {
        name = 'Endgame',
        options = {
          { name = '#THE_VOID_NAME'    , stage = '12' },
          { name = '#HOME_NAME (day)'  , stage = '13', sameLine = true },
          { name = '#HOME_NAME (night)', stage = '13a' },
        }
      },
      {
        name = 'Endgame (Greed)',
        options = {
          { name = '#THE_SHOP_NAME'   , greedStage = '6' },
          { name = '#ULTRA_GREED_NAME', greedStage = '7' },
        }
      },
    }
    
    local longestName = 0
    for _, v in ipairs(chapters2) do
      for _, w in ipairs(v.options) do
        local nameLength = utf8.len(mod:localizeHelper(w.name)) -- string.len
        if nameLength > longestName then
          longestName = nameLength
        end
      end
    end
    
    local autoReseed = false
    local doAscent = false
    ImGui.AddCheckbox('shenanigansTabChaptersTwo', 'shenanigansChkChapterAutoReseed', 'Auto-reseed?', function(b)
      autoReseed = b
    end, autoReseed)
    ImGui.AddCheckbox('shenanigansTabChaptersTwo', 'shenanigansChkChapterDoAscent', 'Ascent?', function(b)
      doAscent = b
    end, doAscent)
    ImGui.SetHelpmarker('shenanigansChkChapterDoAscent', mod:localizeHelper('Backwards path: #BASEMENT_NAME - #MAUSOLEUM_NAME'))
    for i, v in ipairs(chapters2) do
      ImGui.AddElement('shenanigansTabChaptersTwo', '', ImGuiElement.SeparatorText, v.name)
      for j, w in ipairs(v.options) do
        local btnId = 'shenanigansBtnChapterTwo' .. i .. '-' .. j
        ImGui.AddButton('shenanigansTabChaptersTwo', btnId, mod:padName(mod:localizeHelper(w.name), longestName), function()
          if Isaac.IsInGame() then
            if game:IsGreedMode() then
              if w.greedStage then
                Isaac.ExecuteCommand('stage ' .. w.greedStage)
                if autoReseed then
                  Isaac.ExecuteCommand('reseed')
                end
              end
            else
              if w.stage then
                local tempStage = tonumber(string.match(w.stage, '^(%d+)'))
                game:SetStateFlag(GameStateFlag.STATE_MAUSOLEUM_HEART_KILLED, false)
                game:SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, false)
                if w.preAscent then
                  game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT, true)
                  game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH, false)
                elseif doAscent and tempStage >= 1 and tempStage <= 6 then
                  game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT, false) -- true
                  game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH, true)
                else
                  game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT, false)
                  game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH, false)
                end
                Isaac.ExecuteCommand('stage ' .. w.stage)
                if autoReseed then
                  Isaac.ExecuteCommand('reseed')
                end
              end
            end
          end
        end, false)
        if w.sameLine then
          ImGui.AddElement('shenanigansTabChaptersTwo', '', ImGuiElement.SameLine, '')
        elseif w.stage and w.greedStage then
          ImGui.SetHelpmarker(btnId, 'Normal+Greed')
        end
      end
    end
  end
  
  mod:setupImGuiMenu()
  mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.onModsLoaded)
end