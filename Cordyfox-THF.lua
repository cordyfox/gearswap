--    ___                       _____               _        __          
--   / _ \                     /  __ \             | |      / _|         
--  / /_\ \___ _   _ _ __ __ _ | /  \/ ___  _ __ __| |_   _| |_ _____  __
--  |  _  / __| | | | '__/ _` || |    / _ \| '__/ _` | | | |  _/ _ \ \/ /
--  | | | \__ \ |_| | | | (_| || \__/\ (_) | | | (_| | |_| | || (_) >  < 
--  \_| |_/___/\__,_|_|  \__,_(_)____/\___/|_|  \__,_|\__, |_| \___/_/\_\
--                                                    __/ |             
--                                                   |___/             
--  THF Gearswap .lua
--    Original: Motenten / Modified: Shiva.Arislan and Asura.Cordyfox
--    NOTE: Haste/DW Detection Requires Gearinfo Addon
--

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ CTRL+` ]          Cycle Treasure Hunter Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ ALT+` ]           Flee
--              [ Numpad+ ] <st>    Provoke / Poisonga / Animated Flourish 
--              [ CTRL+Numpad/ ]    Berserk / Last Resort / Haste Samba
--              [ CTRL+Numpad* ]    Warcry / Arcane Circle
--              [ CTRL+Numpad- ]    Aggressor / Bio II
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad1 ]    Rudra's Storm
--              [ CTRL+Numpad2 ]    Evisceration
--              [ CTRL+Numpad3 ]    Mandalic Stab
--              [ CTRL+Numpad4 ]    Exenterator
--              [ CTRL+Numpad5 ]    Dancing Edge
--              [ CTRL+Numpad6 ]    Shark Bite
--              [ CTRL+Numpad7 ]    Shadowstitch
--              [ CTRL+Numpad8 ]    Energy Drain
--              [ CTRL+Numpad9 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)

-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob (either melee,
--
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    state.Ambush = M(false, 'Ambush')
    -- state.CP = M(false, "Capacity Points Mode")

    lockstyleset = 13
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal','Accuracy','MaxAccuracy')
    state.HybridMode:options('Normal','DT')
    state.RangedMode:options('Normal','Accuracy')
    state.WeaponskillMode:options('Normal', 'Accuracy', 'LowBuff')
    state.IdleMode:options('Normal', 'DT', 'Refresh')

    state.WeaponSet = M{['description']='Weapon Set', 'Damage','Tank','Cleave','Treasure','SixStep'}
    state.WeaponLock = M(false, 'Weapon Lock')

    -- Rune state for when /RUN
    state.Rune = M{['description']='Rune', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line

    send_command('bind ^` gs c cycle treasuremode')
    send_command('bind ^[ gs c cycleback WeaponSet')
    send_command('bind ^] gs c cycle WeaponSet')
    send_command('bind !` input /ja "Flee" <me>')
    send_command('bind %numpad0 gs c toggle Ambush')

    -- send_command('bind @c gs c toggle CP')

    send_command('bind ^numlock input /ja "Assassin\'s Charge" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
        send_command('bind numpad+ input /ja "Provoke" <stnpc>')
    elseif player.sub_job == 'DNC' then
        send_command('bind ^numpad/ input /ja "Haste Samba" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
        send_command('bind !numlock input /ja "Box Step" <t>')
        send_command('bind !numpad/ input /ja "Quick Step" <t>')
        send_command('bind numpad+ input /ja "Animated Flourish" <stnpc>')
    elseif player.sub_job == 'DRK' then
        send_command('bind ^numpad/ input /ja "Last Resort" <me>')
        send_command('bind ^numpad* input /ja "Arcane Circle" <me>')
        send_command('bind ^numpad- input /ma "Bio II" <t>')
        send_command('bind numpad+ input /ma "Poisonga" <stnpc>')
    elseif player.sub_job == 'RUN' then
        send_command('bind !insert gs c cycleback Rune')
        send_command('bind !delete gs c cycle Rune')
        send_command('bind ^numpad/ input /ja "Swordplay" <me>')
        send_command('bind ^numpad* input /ja "Pflug" <me>')
        send_command('bind ^numpad- input /ja "Vallation" <me>')
        send_command('bind !numpad* input /ja "Lunge" <me>')
        send_command('bind !numpad- input /ja "Swipe" <me>')
    end

    send_command('bind ^numpad1 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad2 input /ws "Evisceration" <t>')
    send_command('bind ^numpad3 input /ws "Mandalic Stab" <t>')
    send_command('bind ^numpad4 input /ws "Exenterator" <t>')
    send_command('bind ^numpad5 input /ws "Dancing Edge" <t>')
    send_command('bind ^numpad6 input /ws "Shark Bite" <t>')
    send_command('bind ^numpad7 input /ws "Shadowstitch" <t>')
    send_command('bind ^numpad8 input /ws "Energy Drain" <t>')
    send_command('bind ^numpad9 input /ws "Aeolian Edge" <t>')

    send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
    send_command('bind ^numpad. input /ja "Trick Attack" <me>')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind numpad0')
    -- send_command('unbind @c')
    send_command('unbind @r')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {
        ammo = "Per. Lucky Egg", --1
        hands= "Plun. Armlets +3", --4
        legs = "Volte Hose", --1
        feet = "Skulk. Poulaines +1", --3
        waist= "Chaac Belt", --1
    } -- TH: 3 + 10 = 13

    sets.buff['Sneak Attack'] = {}
    sets.buff['Trick Attack'] = {}

    -- Actions we want to use to tag TH.
    --sets.precast.Poisonga = sets.TreasureHunter
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
        --sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +1"}
        --sets.precast.JA['Aura Steal'] = {head="Plun. Bonnet +3"}
        --sets.precast.JA['Collaborator'] = set_combine(sets.TreasureHunter, {head="Skulker's Bonnet +1"})
        --sets.precast.JA['Flee'] = {feet="Pill. Poulaines +3"}
        --ets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
        --sets.precast.JA['Conspirator'] = set_combine(sets.TreasureHunter, {body="Skulker's Vest +1"})

        sets.precast.JA['Steal'] = {
            --ammo="Barathrum",
            --head="Plun. Bonnet +3",
            --hands="Pillager's Armlets +1",
            --feet="Pill. Poulaines +3",
            neck = "Pentalagus Charm",
        }

    --sets.precast.JA['Despoil'] = {ammo="Barathrum", legs="Skulk. Culottes +1", feet="Skulk. Poulaines +1"}
        sets.precast.JA['Perfect Dodge'] = {hands="Plun. Armlets +3"}
    --sets.precast.JA['Feint'] = {legs="Plun. Culottes +3"}
    --sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    --sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

        sets.precast.Waltz = {
            ammo = "Yamarang",
            body = "Gleti's Cuirass",
            hands= gear.Herc_Waltz_hands,
            legs = "Dashing Subligar",
            feet = gear.Herc_Waltz_legs,
            ear1 = "Enchntr. Earring +1",
            ear2 = "Handler's Earring +1",
            ring1= "Asklepian Ring",
            ring2= "Metamor. Ring +1",
            waist= "Gishdubar Sash",
        }

        sets.precast.Waltz['Healing Waltz'] = {}

        sets.precast.FC = {
            ammo = "Sapience Orb", -- 2%
            head = gear.Herc_FC_head, -- 7%
            body = gear.Taeon_Phalanx_body, -- 9%
            hands= "Leyline Gloves", -- 8%
            legs = "Rawhide Trousers", -- 5%
            feet = gear.Herc_FC_feet, -- 6%
            neck = "Baetyl Pendant", -- 4%
            ear1 = "Loquacious Earring", -- 2%
            ear2 = "Enchntr. Earring +1", -- 2%
            ring1= "Prolix Ring", -- 2%
            ring2= "Naji's Loop", -- 1%
        } -- 48%

            sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
                ammo = "Impatiens",
                body = "Passion Jacket",
                ring2= "Lebeche Ring",
            })

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo = "Aurgelmir Orb",
        head = gear.Herc_WSD_head,
        body = gear.Herc_WSD_body,
        hands= "Meg. Gloves +2",
        legs = "Nyame Flanchard",
        feet = gear.Herc_WSD_feet,
        neck = "Fotia Gorget",
        ear1 = "Ishvara Earring",
        ear2 = "Moonshade Earring",
        ring1= "Regal Ring",
        ring2= "Beithir Ring",
        back = gear.THF_WSD_Cape,
        waist= "Fotia Belt",
    } -- default set

        sets.precast.WS.Accuracy = set_combine(sets.precast.WS, {
            ammo = "Falcon Eye",
            ear2 = "Telos Earring",
        })

        sets.precast.WS.Critical = {
            ammo = "Yetshila +1",
          --head = "Pill. Bonnet +3",
            body = "Meg. Cuirie +2",
        }

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
        head = "Adhemar Bonnet +1",
        body = "Adhemar Jacket +1",
        legs = "Meg. Chausses +2",
        feet = "Meg. Jam. +2",
        ear1 = "Sherida Earring",
        ear2 = "Telos Earring",
        ring2= "Ilabrat Ring",
    })

        sets.precast.WS['Exenterator'].Accuracy = set_combine(sets.precast.WS['Exenterator'], {
            head = "Malignance Chapeau",
        })

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        ammo = "Yetshila +1",
        head = "Adhemar Bonnet +1",
        body = "Pillager's Vest +3",
        hands= "Mummu Wrists +2",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots",
        ear1 = "Sherida Earring",
        ear2 = "Mache Earring +1",
        ring1= "Begrudging Ring",
        ring2= "Mummu Ring",
        back = gear.THF_TP_Cape,
    })

        sets.precast.WS['Evisceration'].Accuracy = set_combine(sets.precast.WS['Evisceration'], {
            ammo = "Falcon Eye",
            legs = "Nyame Mail",
            ring1= "Regal Ring",
        })

    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        ammo = "Aurgelmir Orb",
        ear1 = "Sherida Earring",
        waist= "Kentarch Belt +1",
    })

        sets.precast.WS['Rudra\'s Storm'].Accuracy = set_combine(sets.precast.WS['Rudra\'s Storm'], {
            ammo = "Falcon Eye",
            ear2 = "Telos Earring",
            waist= "Grunfeld Rope",
        })

    sets.precast.WS['Mandalic Stab'] = sets.precast.WS["Rudra's Storm"]
        sets.precast.WS['Mandalic Stab'].Accuracy = sets.precast.WS["Rudra's Storm"].Accuracy

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        ammo = "Ghastly Tathlum +1",
        head = gear.Herc_WSD_head,
        body = "Nyame Mail",
        hands= "Leyline Gloves",
        legs = gear.Herc_WSD_legs,
        feet = gear.Herc_WSD_feet,
        neck = "Baetyl Pendant",
        ear1 = "Hecate's Earring",
        ear2 = "Friomisi Earring",
        ring1= "Metamor. Ring +1",
        ring2= "Beithir Ring",
        back = "Sacro Mantle",
        waist= "Eschan Stone",
    })

    sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS['Exenterator'], {
        hands= "Adhemar Wrist. +1",
        feet = "Nyame Sollerets",
        ring2= "Gere Ring"
    })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo = "Staunch Tathlum +1", --11
        body = gear.Taeon_Phalanx_body, --10
        hands= "Rawhide Gloves", --15
        legs = gear.Taeon_Phalanx_legs, --10
        feet = gear.Taeon_Phalanx_feet, --10
        neck = "Loricate Torque +1", --5
        ear1 = "Halasz Earring", --5
      --ear2 = "Magnetic Earring", --8
        ring2= "Evanescence Ring", --5
    }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast['Enfeebling Magic'] = set_combine(sets.TreasureHunter, {})


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo = "Staunch Tathlum +1",
        --head = "Turms Cap +1",
            head = "Gleti's Mask",
        body = "Gleti's Cuirass",
        hands= "Gleti's Gauntlets",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots",
        neck = "Bathy Choker +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Eabani Earring",
        ring1= "Shneddick Ring",
        ring2= "Chirich Ring +1",
        back = "Moonlight Cape",
        waist= "Engraved Belt",
    }

    sets.idle.DT = set_combine(sets.idle, {
        ammo = "Staunch Tathlum +1", --3/3
        head = "Malignance Chapeau", --6/6
        body = "Nyame Mail", --9/9
        hands= "Nyame Gauntlets", --5/5
        legs = "Nyame Flanchard", --7/7
        feet = "Nyame Sollerets", --4/4
        neck = "Warder's Charm +1",
        ear2 = "Odnowa Earring +1",
        ring1= "Shneddick Ring", --0/4
        ring2= "Moonlight Ring", --10/10
        back = "Moonlight Cape", --6/6
        waist= "Engraved Belt",
    })


   sets.idle.Refresh = set_combine(sets.idle, {
        feet  = "Jute Boots +1",
        ring1 = {name="Stikini Ring +1", bag="wardrobe3"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe4"},
    })


    sets.idle.Town = set_combine(sets.idle, {
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        body = "Adhemar Jacket +1",
        hands= "Adhemar Wrist. +1",
        legs = "Adhemar Kecks +1",
        feet = "Jute Boots +1",
        neck = "Asn. Gorget +2",
        ear1 = "Sherida Earring",
        ear2 = "Telos Earring",
        ring1= "Warp Ring",
        ring2= "Dim. Ring (Mea)",
        back = "Nexus Cape",
        waist= "Engraved Belt",
    })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Jute Boots +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Adhemar Bonnet +1",
        body = "Adhemar Jacket +1",
        hands= "Adhemar Wrist. +1",
        legs = "Samnuha Tights",
        feet = gear.Herc_TA_feet,
        neck = "Asn. Gorget +2",
        ear1 = "Sherida Earring",
        ear2 = "Brutal Earring",
        ring1= "Gere Ring",
        ring2= "Epona's Ring",
        back = gear.THF_TP_Cape,
        waist= "Sailfi Belt +1",
    }

    sets.engaged.Accuracy = set_combine(sets.engaged, {
        ring1= "Chirich Ring +1",
        ear2 = "Telos Earring",
        ring2= "Ilabrat Ring",
    })

    sets.engaged.MaxAccuracy = set_combine(sets.engaged.Accuracy, {
        ammo = "Yamarang",
        head = "Malignance Chapeau",
        body = "Gleti's Cuirass",
        hands= "Gleti's Gauntlets",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots",
        ring1= "Cacoethic Ring +1",
        ear1 = "Odr Earring",
        waist= "Kentarch Belt +1",
    })

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (74% DW to cap)

    sets.engaged.DW = {
        ammo="Aurgelmir Orb",
        ammo="Yamarang",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", -- 6
        hands=gear.Adhemar_A_hands,
        legs="Samnuha Tights",
        feet=gear.Taeon_DW_feet, --9
        neck="Anu Torque",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Gere Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
    } -- 41%

        sets.engaged.DW.Accuracy = set_combine(sets.engaged.DW, {
            ring1 = {name="Chirich Ring +1", bag="wardrobe3"},
        })

        sets.engaged.DW.MaxAccuracy = set_combine(sets.engaged.DW.Accuracy, {
            ammo = "Yamarang",
            head = "Malignance Chapeau",
          --body = "Pillager's Vest +3",
            ring2= "Ilabrat Ring",
            waist= "Kentarch Belt +1",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
        ammo = "Aurgelmir Orb",
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        body = "Adhemar Jacket +1", -- 6
        hands= gear.Adhemar_A_hands,
        legs = "Samnuha Tights",
        feet = gear.Taeon_DW_feet, --9
        neck = "Anu Torque",
        ear1 = "Cessance Earring",
        ear2 = "Suppanomimi", --5
        ring1= "Gere Ring",
        ring2= "Epona's Ring",
        back = gear.THF_DW_Cape, --10
        waist= "Reiki Yotai", --7
    } -- 37%

        sets.engaged.DW.Accuracy.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
            ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

        sets.engaged.DW.MaxAccuracy.LowHaste = set_combine(sets.engaged.DW.Accuracy.LowHaste, {
            ammo="Yamarang",
            head="Malignance Chapeau",
            body="Pillager's Vest +3",
            ring2="Ilabrat Ring",
            waist="Kentarch Belt +1",
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
        ammo = "Aurgelmir Orb",
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        body = "Pillager's Vest +3",
        hands= gear.Adhemar_A_hands,
        legs = "Samnuha Tights",
        feet = "Nyame Sollerets",
        neck = "Anu Torque",
        ear1 = "Eabani Earring", --4
        ear2 = "Suppanomimi", --5
        ring1= "Gere Ring",
        ring2= "Epona's Ring",
        back = gear.THF_DW_Cape, --10
        waist= "Reiki Yotai", --7
    } -- 26%

        sets.engaged.DW.Accuracy.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
            ring1 = {name="Chirich Ring +1", bag="wardrobe3"},
        })

        sets.engaged.DW.MaxAccuracy.MidHaste = set_combine(sets.engaged.DW.Accuracy.MidHaste, {
            ammo = "Yamarang",
            head = "Malignance Chapeau",
            ear1 = "Cessance Earring",
            ring2= "Ilabrat Ring",
            waist= "Kentarch Belt +1",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
        ammo = "Aurgelmir Orb",
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        body = "Pillager's Vest +3",
        hands= gear.Adhemar_A_hands,
        legs = "Samnuha Tights",
        feet = "Nyame Sollerets",
        neck = "Anu Torque",
        ear1 = "Sherida Earring",
        ear2 = "Suppanomimi", --5
        ring1= "Gere Ring",
        ring2= "Epona's Ring",
        back = gear.THF_DW_Cape, --10
        waist= "Reiki Yotai", --7
    } -- 22%

        sets.engaged.DW.Accuracy.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
            neck = "Combatant's Torque",
            ring1= {name="Chirich Ring +1", bag="wardrobe3"},
        })

        sets.engaged.DW.MaxAccuracy.HighHaste = set_combine(sets.engaged.DW.Accuracy.HighHaste, {
            ammo = "Yamarang",
            head = "Malignance Chapeau",
            ear1 = "Cessance Earring",
            ring2= "Ilabrat Ring",
            waist= "Kentarch Belt +1",
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
        ammo = "Aurgelmir Orb",
        head = "Adhemar Bonnet +1",
        body = "Pillager's Vest +3",
        hands= gear.Adhemar_A_hands,
        legs = "Samnuha Tights",
        feet = "Nyame Sollerets",
        neck = "Anu Torque",
        ear1 = "Sherida Earring",
        ear2 = "Suppanomimi", --5
        ring1= "Gere Ring",
        ring2= "Epona's Ring",
        back = gear.THF_TP_Cape,
        waist= "Sailfi Belt +1",
    } -- 5%

        sets.engaged.DW.Accuracy.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
            ring1 = {name="Chirich Ring +1", bag="wardrobe3"},
            waist = "Kentarch Belt +1",
        })

        sets.engaged.DW.MaxAccuracy.MaxHaste = set_combine(sets.engaged.DW.Accuracy.MaxHaste, {
            ammo = "Yamarang",
            head = "Malignance Chapeau",
            ear1 = "Cessance Earring",
            ring2= "Ilabrat Ring",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head = "Malignance Chapeau", --6/6
        body = "Nyame Mail", --9/9
        hands= "Nyame Gauntlets", --5/5
        legs = "Nyame Flanchard", --7/7
        feet = "Nyame Sollerets", --4/4
        ring1= {name="Moonlight Ring", bag="wardrobe1"}, -- 5/5
        ring2= {name="Moonlight Ring", bag="wardrobe2"}, -- 5/5
    } -- 41% PDT / 41% MDT

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Accuracy.DT = set_combine(sets.engaged.Accuracy, sets.engaged.Hybrid)
    sets.engaged.MaxAccuracy.DT = set_combine(sets.engaged.MaxAccuracy, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT = set_combine(sets.engaged.DW.Accuracy, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT = set_combine(sets.engaged.DW.MaxAccuracy, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT.LowHaste = set_combine(sets.engaged.DW.Accuracy.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT.LowHaste = set_combine(sets.engaged.DW.MaxAccuracy.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT.MidHaste = set_combine(sets.engaged.DW.Accuracy.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT.MidHaste = set_combine(sets.engaged.DW.MaxAccuracy.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT.HighHaste = set_combine(sets.engaged.DW.Accuracy.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT.HighHaste = set_combine(sets.engaged.DW.MaxAccuracy.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT.MaxHaste = set_combine(sets.engaged.DW.Accuracy.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT.MaxHaste = set_combine(sets.engaged.DW.MaxAccuracy.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

  --sets.buff['Ambush'] = {body="Plunderer's Vest +3"}

    sets.Damage = {main="Tauret", sub="Gleti's Knife"}
    sets.Tank = {main="Tauret", sub="Acrontica"}
    sets.Cleave = {main="Tauret", sub="Malevolence"}
    sets.Treasure = {main="Tauret", sub="Gleti's Knife"}
    sets.SixStep = {main="Ceremonial Dagger", sub="Qutrub Knife"}

    sets.buff.Doom = {
        neck = "Nicander's Necklace", -- 20%
        ring1= {name="Saida Ring", bag="wardrobe3"}, -- 15
        ring2= {name="Saida Ring", bag="wardrobe4"}, -- 15%
        waist= "Gishdubar Sash", --10%
    }
    
    sets.Reive = {neck="Ygnas's Resolve +1"}
    sets.CP = {back="Mecisto. Mantle"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
    if spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
    end
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Aeolian Edge' then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end

    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)

    if buffactive['Reive Mark'] then
        if gain then
            equip(sets.Reive)
            disable('neck')
        else
            enable('neck')
            handle_equipping_gear(player.status)
        end
    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p <me> is Doomed! Cursna, please! <call21>')
            disable('neck','ring1','ring2','waist')
        else
            send_command('@input /p No longer Doomed, thanks!')
            enable('neck','ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

	if buff == "charm" then
        if gain then
            send_command('@input /p <me> is Charmed! Stay on your toes! <call21>')
        else
            send_command('@input /p No longer Charmed! <note>')
            handle_equipping_gear(player.status)
        end
    end

    if buff == "sleep" then
        if gain then
            send_command('@input /me doze')
            send_command('@input /p <me> is Asleep! Zzz...')
        else
            send_command('@input /p I\'m awake, thanks!')
            handle_equipping_gear(player.status)
        end
    end

    if not midaction() then
        handle_equipping_gear(player.status)
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub','ammo','range')
    else
        enable('main','sub','ammo','range')
    end

    check_weaponset()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)

    check_weaponset()

    return meleeSet
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MaxAccuracy' then
        wsmode = 'Accuracy'
    end

    --if state.Buff['Sneak Attack'] then
    --    wsmode = 'SA'
    --end
    --if state.Buff['Trick Attack'] then
    --    wsmode = (wsmode or '') .. 'TA'
    --end

    return wsmode
end

--[[ function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end ]]

function customize_melee_set(meleeSet)
    if state.Ambush.value == true then
        meleeSet = set_combine(meleeSet, sets.buff['Ambush'])
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 6 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 6 and DW_needed <= 22 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 22 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 26 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'rune' then
        send_command('@input /ja '..state.Rune.value..' <me>')
    end

    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

function check_weaponset()
    equip(sets[state.WeaponSet.current])
end

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'WAR' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 1)
    else
        set_macro_page(1, 1)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end

-- Ensure items are always in your inventory.

organizer_items = {
	-- food
	sushi="Sublime Sushi +1",
	curry="Red Curry Bun",
	grapes="Grape Daifuku",
    carbonara="Carbonara",
    miso="Miso Ramen",
	-- consumables
	remedies="Remedy",
	shihei="Shihei",
	toolbags="Toolbag (Shihe)",
	-- weapons
    tauret="Tauret",
    acrontica="Acrontica",
    gleti="Gleti's Knife",
    multi="Renegade",
	h2h="Kaja Knuckles",
	chakram="Albin Bane",
    -- warps
    warp="Warp Ring",
    dim="Dim. Ring (Mea)",
    mask="Cumulus Masque +1",
    -- EXP
    specs="Magian Specs.",
    trizek="Trizek Ring",
    echad="Echad Ring",
}