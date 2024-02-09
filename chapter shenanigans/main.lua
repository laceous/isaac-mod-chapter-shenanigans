local mod = RegisterMod('Chapter Shenanigans', 1)

if REPENTOGON then
  function mod:onRender()
    mod:RemoveCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.onRender)
    mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
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
  
  function mod:setupImGui()
    if not ImGui.ElementExists('shenanigansMenu') then
      ImGui.CreateMenu('shenanigansMenu', '\u{f6d1} Shenanigans')
    end
    ImGui.AddElement('shenanigansMenu', 'shenanigansMenuItemChapters', ImGuiElement.MenuItem, '\u{e0bb} Chapter Shenanigans')
    ImGui.CreateWindow('shenanigansWindowChapters', 'Chapter Shenanigans')
    ImGui.LinkWindowToElement('shenanigansWindowChapters', 'shenanigansMenuItemChapters')
    
    ImGui.AddTabBar('shenanigansWindowChapters', 'shenanigansTabBarChapters')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChapters', 'Chapters')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersModes', 'Modes')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersBosses', 'Bosses')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersEntities', 'Entities')
    ImGui.AddTab('shenanigansTabBarChapters', 'shenanigansTabChaptersRooms', 'Rooms')
    
    local chapters = {
      {
        name = 'Chapter 1',
        options = {
          { name = 'Basement'        , achievement = -1 },
          { name = 'Cellar'          , achievement = Achievement.CELLAR },
          { name = 'Burning Basement', achievement = Achievement.BURNING_BASEMENT },
        }
      },
      {
        name = 'Chapter 1.5',
        options = {
          { name = 'Downpour', achievement = Achievement.SECRET_EXIT, hint = 'A secret exit in boss rooms' },
          { name = 'Dross'   , achievement = Achievement.DROSS },
        }
      },
      {
        name = 'Chapter 2',
        options = {
          { name = 'Caves'        , achievement = -1 },
          { name = 'Catacombs'    , achievement = Achievement.CATACOMBS },
          { name = 'Flooded Caves', achievement = Achievement.FLOODED_CAVES },
        }
      },
      {
        name = 'Chapter 2.5',
        options = {
          { name = 'Mines' , achievement = Achievement.SECRET_EXIT, hint = 'A secret exit in boss rooms' },
          { name = 'Ashpit', achievement = Achievement.ASHPIT },
        }
      },
      {
        name = 'Chapter 3',
        options = {
          { name = 'Depths'     , achievement = -1 },
          { name = 'Necropolis' , achievement = Achievement.NECROPOLIS },
          { name = 'Dank Depths', achievement = Achievement.DANK_DEPTHS },
        }
      },
      {
        name = 'Chapter 3.5',
        options = {
          { name = 'Mausoleum', achievement = Achievement.SECRET_EXIT, hint = 'A secret exit in boss rooms' },
          { name = 'Gehenna'  , achievement = Achievement.GEHENNA },
        }
      },
      {
        name = 'Chapter 4',
        options = {
          { name = 'Womb'        , achievement = Achievement.WOMB },
          { name = 'Utero'       , achievement = Achievement.WOMB },
          { name = 'Scarred Womb', achievement = Achievement.SCARRED_WOMB },
        }
      },
      {
        name = 'Chapter 4.5',
        options = {
          { name = '???'   , achievement = Achievement.BLUE_WOMB, hint = 'Blue Womb' },
          { name = 'Corpse', achievement = Achievement.SECRET_EXIT, hint = 'A secret exit in boss rooms' },
        }
      },
      {
        name = 'Chapter 5',
        options = {
          { name = 'Sheol'    , achievement = Achievement.IT_LIVES, hint = 'It Lives!' },
          { name = 'Cathedral', achievement = Achievement.IT_LIVES, hint = 'It Lives!' },
        }
      },
      {
        name = 'Chapter 6',
        options = {
          { name = 'Dark Room', achievement = Achievement.THE_NEGATIVE, hint = 'The Negative' },
          { name = 'Chest'    , achievement = Achievement.THE_POLAROID, hint = 'The Polaroid' },
        }
      },
      {
        name = 'Endgame',
        options = {
          { name = 'The Void'     , achievement = Achievement.THE_VOID },
          { name = 'Home (Ascent)', achievement = Achievement.A_STRANGE_DOOR, hint = 'A strange door in Depths II' },
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
          { name = 'Famine, War, Pestilence, Death, The Headless Horseman', achievement = Achievement.THE_HARBINGERS },
          { name = 'Conquest'                                             , achievement = Achievement.CONQUEST },
        }
      },
      {
        name = 'Something Wicked This Way Comes',
        options = {
          { name = 'Rag Man, Little Horn, Dangle, Turdlings, The Frail, The Stain, The Forsaken, Brownie', achievement = Achievement.SOMETHING_WICKED     , hint = 'Afterbirth bosses' },
          { name = 'Rag Mega, Big Horn, Sisters Vis, The Matriarch'                                      , achievement = Achievement.SOMETHING_WICKED_PLUS, hint = 'Afterbirth+ bosses' },
        }
      },
      {
        name = 'Chapter 1',
        options = {
          { name = 'Steven', achievement = Achievement.STEVEN },
        }
      },
      {
        name = 'Chapter 2',
        options = {
          { name = 'C.H.A.D.', achievement = Achievement.CHAD },
        }
      },
      {
        name = 'Chapter 3',
        options = {
          { name = 'Gish', achievement = Achievement.GISH },
        }
      },
      {
        name = 'Chapter 4',
        options = {
          { name = 'Triachnid', achievement = Achievement.TRIACHNID },
        }
      },
      {
        name = 'Chapter 6',
        options = {
          { name = 'Mega Satan', achievement = Achievement.ANGELS, hint = 'Angel statues can be bombed' },
        }
      },
      {
        name = 'The Void',
        options = {
          { name = 'Portals', achievement = Achievement.THE_GATE_IS_OPEN },
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
    
    for _, a in ipairs({
                        { tbl = chapters, tab = 'shenanigansTabChapters'        , chkIdPrefix = 'shenanigansChkChapter' },
                        { tbl = modes   , tab = 'shenanigansTabChaptersModes'   , chkIdPrefix = 'shenanigansChkChapterMode' },
                        { tbl = bosses  , tab = 'shenanigansTabChaptersBosses'  , chkIdPrefix = 'shenanigansChkChapterBoss' },
                        { tbl = entities, tab = 'shenanigansTabChaptersEntities', chkIdPrefix = 'shenanigansChkChapterEntity' },
                        { tbl = rooms   , tab = 'shenanigansTabChaptersRooms'   , chkIdPrefix = 'shenanigansChkChapterRoom' },
                      })
    do
      for i, v in ipairs(a.tbl) do
        ImGui.AddElement(a.tab, '', ImGuiElement.SeparatorText, v.name)
        for j, w in ipairs(v.options) do
          local chkId = a.chkIdPrefix .. i .. '-' .. j
          ImGui.AddCheckbox(a.tab, chkId, w.name, nil, false)
          if w.hint then
            ImGui.SetHelpmarker(chkId, w.hint)
          end
          ImGui.AddCallback(chkId, ImGuiCallback.Render, function()
            local gameData = Isaac.GetPersistentGameData()
            local value = true
            if w.achievement > 0 then
              value = gameData:Unlocked(w.achievement)
            end
            ImGui.UpdateData(chkId, ImGuiData.Value, value)
          end)
          ImGui.AddCallback(chkId, ImGuiCallback.Edited, function(b)
            if w.achievement > 0 then
              mod:unlockAchievement(w.achievement, b)
            end
          end)
        end
      end
    end
    
    local cmbMomsHeartId = 'shenanigansCmbChapterMomsHeart'
    ImGui.AddElement('shenanigansTabChaptersBosses', '', ImGuiElement.SeparatorText, 'Mom\'s Heart')
    ImGui.AddCombobox('shenanigansTabChaptersBosses', cmbMomsHeartId, 'Mom\'s Heart Ending', nil, {
      'No Mom Kills',
      'End 1 (Eden)',
      'End 2 (Rubber Cement)',
      'End 3 (Transcendence)',
      'End 4 (Wire Coat Hanger)',
      'End 5 (Everything Is Terrible)',
      'End 6 (Ipecac)',
      'End 7 (Experimental Treatment)',
      'End 8 (A Quarter)',
      'End 9 (Dr. Fetus)',
      'End 10 (???)',
      'End 11 (It Lives!)',
    }, 0, true)
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
      local label = 'Mom Kills: ' .. gameData:GetEventCounter(EventCounter.MOM_KILLS) .. ' (' .. (gameData:Unlocked(Achievement.IT_LIVES) and 'It Lives!' or 'Mom\'s Heart') .. ')'
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
  end
  
  -- launch options allow you to skip the menu
  mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.onRender)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
end