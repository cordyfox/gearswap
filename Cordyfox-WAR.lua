-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

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
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+- ]          Chain Affinity
--              [ CTRL+= ]          Burst Affinity
--              [ CTRL+[ ]          Efflux
--              [ ALT+[ ]           Diffusion
--              [ ALT+] ]           Unbridled Learning
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--
--  Spells:     [ CTRL+` ]          Blank Gaze
--              [ ALT+Q ]           Nature's Meditation/Fantod
--              [ ALT+W ]           Cocoon/Reactor Cool
--              [ ALT+E ]           Erratic Flutter
--              [ ALT+R ]           Battery Charge/Refresh
--              [ ALT+T ]           Occultation
--              [ ALT+Y ]           Barrier Tusk/Phalanx
--              [ ALT+U ]           Diamondhide/Stoneskin
--              [ ALT+P ]           Mighty Guard/Carcharian Verve
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad4 ]    Requiescat
--              [ CTRL+Numpad5 ]    Expiacion
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


--------------------------------------------------------------------------------------------------------------------
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

    state.Buff['Mighty Strikes'] = buffactive['Mighty Strikes'] or false
    state.Buff['Brazen Rush'] = buffactive['Brazen Rush'] or false

    state.Buff['Berserk'] = buffactive['Berserk'] or false
    state.Buff['Defender'] = buffactive['Defender'] or false

    state.Buff['Warcry'] = buffactive['Warcry'] or false
    state.Buff['Blood Rage'] = buffactive['Blood Rage'] or false

    no_swap_gear = S{
        "Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
        "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"
    }
    
    elemental_ws = S{
        -- Sword
        'Burning Blade',
        'Red Lotus Blade',
        'Shining Blade',
        'Seraph Blade',
        'Sanguine Blade',
        -- Club
        'Shining Strike',
        'Seraph Strike',
        ' sh Nova',
        -- Great Sword
        'Frostbite',
        'Freezebite',
        'Herculean Slash',
        -- Polearm
        'Thunder Thrust',
        'Raiden Thrust',
        -- Staff
        'Rock Crusher',
        'Earth Crusher',
        'Cataclysm',
    }

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    if (player.sub_job == 'DRG') or (player.sub_job == 'WHM') then
        lockstyleset = 5
    elseif player.sub_job == 'SAM' then
        lockstyleset = 6
    elseif (player.sub_job == 'NIN') or (player.sub_job == 'DNC') then
        lockstyleset = 11
    end

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Accuracy', 'MaxAccuracy')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Accuracy')
    state.WeaponskillMode:options('Normal', 'Accuracy')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
    state.IdleMode:options('Normal', 'DT')

    if player.sub_job == 'DRG' then
        state.WeaponSet = M{['description']='Weapon Set','Sword','Club','Polearm','Great Axe'}
    elseif player.sub_job == 'SAM' then
        state.WeaponSet = M{['description']='Weapon Set','GreatAxe','GreatSword','Staff','Sword'}
    elseif (player.sub_job == 'NIN' or 'DNC') then
        state.WeaponSet = M{['description']='Weapon Set','AxeDW','SwordDW','ClubDW','DMG1DW','GreatAxe'}
    end
    
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    -- state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line

    send_command('bind ^` input /ja "Berserk" <me>')
    send_command('bind !` input /ja "Aggressor" <me>')
    send_command('bind @` input /ja "Warcry" <me>')
    --send_command('bind ^\\ gs c cycle treasuremode')
    send_command('bind ^[ gs c toggle WeaponLock')
    send_command('bind @c gs c toggle CP')
    send_command('bind ^[ gs c cycleback WeaponSet')
    send_command('bind ^] gs c cycle WeaponSet')

    send_command('bind numpad+ input /ja "Provoke" <stnpc>')
    send_command('bind numpad0 input /ra <t>')

    if player.sub_job == 'DRG' then
        send_command('bind ^numpad/ input /ja "Jump" <t>')
        send_command('bind ^numpad* input /ja "High Jump" <t>')
        send_command('bind ^numpad- input /ja "Super Jump" <t>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Hasso" <me>')
        send_command('bind ^numpad* input /ja "Meditate" <me>')
        send_command('bind ^numpad- input /ja "Sekkanoki" <me>')
        send_command('bind !numpad/ input /ja "Seigan" <me>')
        send_command('bind !numpad* input /ja "Third Eye" <me>')
    elseif player.sub_job == 'DNC' then
        send_command('bind ^numpad/ input /ja "Haste Samba" <me>')
        send_command('bind ^numpad* input /ja "Reverse Flourish" <me>')
        send_command('bind ^numpad- input /ja "Building Flourish" <me>')
        send_command('bind !numlock input /ja "Contradance" <me>')
        send_command('bind !numpad* input /ja "Quickstep" <t>')
        send_command('bind !numpad/ input /ja "Box Step" <t>')
        send_command('bind !numpad* input /ja "Stutter Step" <t>')
    elseif player.sub_job == 'WHM' then
        send_command('bind ^numpad/ input /ma "Teleport-Holla" <me>')
        send_command('bind ^numpad* input /ma "Teleport-Dem" <me>')
        send_command('bind ^numpad- input /ma "Teleport-Mea" <me>')
        send_command('bind !numpad/ input /ma "Teleport-Yhoat" <me>')
        send_command('bind !numpad* input /ma "Teleport-Altep" <me>')
        send_command('bind !numpad* input /ma "Teleport-Vahzl" <me>')
    end

    -- Weapon Skill keybinds

        -- Ctrl + Numpad
        send_command('bind ^numpad1 input /ws "Upheaval" <t>')
        send_command('bind ^numpad2 input /ws "King\'s Justice" <t>')
        send_command('bind ^numpad3 input /ws "Ukko\'s Fury" <t>')

        send_command('bind ^numpad4 input /ws "Steel Cyclone" <t>')
        send_command('bind ^numpad5 input /ws "Full Break" <t>')
        send_command('bind ^numpad6 input /ws "Armor Break" <t>')

        -- Alt + Numpad
        send_command('bind !numpad1 input /ws "Savage Blade" <t>')
        send_command('bind !numpad2 input /ws "Sanguine Blade" <t>')
        send_command('bind !numpad3 input /ws "Requiescat" <t>')

        send_command('bind !numpad4 input /ws "Judgment" <t>')
        send_command('bind !numpad5 input /ws "Black Halo" <t>')
        send_command('bind !numpad6 input /ws "Flash Nova" <t>')

        send_command('bind !numpad7 input /ws "Decimation" <t>')
        send_command('bind !numpad8 input /ws "Mistral Axe" <t>')
        send_command('bind !numpad9 input /ws "Bora Axe" <t>')

        -- Cleaves
        send_command('bind ^numpad9 input /ws "Fell Cleave" <t>')
        send_command('bind !numpad9 input /ws "Circle Blade" <t>')

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

    -- Unbind top row
    send_command('unbind @t')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind !]')
    send_command('unbind !q')
    send_command('unbind !w')
    send_command('unbind !e')
    send_command('unbind !t')
    send_command('unbind !r')
    send_command('unbind !y')
    send_command('unbind !u')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind @w')
    send_command('unbind @c')
    send_command('unbind @e')
    send_command('unbind @r')

    -- Unbind keypad
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')

    send_command('unbind !numlock')
    send_command('unbind !numpad/')
    send_command('unbind !numpad*')
    send_command('unbind !numpad-')

    send_command('unbind @numlock')
    send_command('unbind @numpad/')
    send_command('unbind @numpad*')
    send_command('unbind @numpad-')

    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad9')

    send_command('unbind !numpad1')
    send_command('unbind !numpad2')
    send_command('unbind !numpad3')
    send_command('unbind !numpad4')
    send_command('unbind !numpad5')
    send_command('unbind !numpad6')
    send_command('unbind !numpad7')
    send_command('unbind !numpad8')
    send_command('unbind !numpad9')

    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad9')
    
    send_command('unbind @numpad1')
    send_command('unbind @numpad2')
    send_command('unbind @numpad3')
    send_command('unbind @numpad4')
    send_command('unbind @numpad5')
    send_command('unbind @numpad6')
    send_command('unbind @numpad7')
    send_command('unbind @numpad8')
    send_command('unbind @numpad9')
    

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

    -- Precast sets to enhance JAs

    sets.precast.JA['Berserk'] = {
        body = "Pumm. Lorica +3",
        feet = "Agoge Calligae +1",
        back = gear.WAR_TP_Cape,
    }

    sets.precast.JA['Warcry'] = {
        head = "Agoge Mask +3",
    }

    -- Enmity set
    sets.Enmity = {
        ammo="Sapience Orb", -- +2
        --head="Rabid Visor", -- 
        body="Emet Harness +1", -- +10
        hands="Pumm. Mufflers +2", -- +10
        legs="Zoar Subligar +1", -- +6
        --feet=""
        neck="Unmoving Collar +1", -- +10
        ear1="Cryptic Earring", -- +4
        ear2="Friomisi Earring", -- +2
        ring1="Provocare Ring", -- +5
        ring2="Begrudging Ring", -- +5
        back="Reiki Cloak", -- +6 
    } -- +56 Enmity

    sets.precast.JA['Provoke'] = sets.Enmity

    sets.precast.FC = {
        ammo = "Sapience Orb", -- 2%
        head = "Sakpata's Helm", -- 8%
        body = "Sacro Breastplate", -- 10%
        hands= "Leyline Gloves", -- 8%
        legs = "Arjuna Breeches", -- 4%
        -- feet="Odyssean Greaves",
        neck = "Baetyl Pendant", -- 4%
        ear1 = "Loquacious Earring", -- 2%
        ear2 = "Enchntr. Earring +1", -- 2%
        ring1= "Prolix Ring", -- 2% 
        ring2= "Naji's Loop", -- 1%
        back = gear.WAR_FC_cape, -- 10%
    } -- 53% 

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo = "Impatiens",
        ring2= "Lebeche Ring",
    })

    -- Pre-shot

    sets.precast.RA = {
        body="Volte Harness",
        hands="Volte Mittens",
    } 

    -- Waltz

    sets.precast.Waltz = {
        head = "",
        body = "", 
        hands= "",
        legs = "Dashing Subligar", --10
        feet = "", 
        neck = "", 
        ear1 = "Handler's Earring +1",
        ear2 = "Enchntr. Earring +1",
        ring1= "Carb. Ring +1",
        ring2= "Metamor. Ring +1",
        back = "",
        waist= "Chaac Belt",
    } -- Waltz Potency/CHR

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.precast.WS = {
        ammo = "Knobkierrie",
        head = "Agoge Mask +3",
		neck = "War. Beads +2",
        body = "Pumm. Lorica +3", 
        hands= "Sakpata's Gauntlets",
        legs = "Sakpata's Cuisses",
		feet = "Sulev. Leggings +2",
		ring1= "Regal Ring",
        ring2= "Beithir Ring",
        ear1 = "Moonshade Earring",
        ear2 = "Thrud Earring",
        waist= "Sailfi Belt +1",
        back = gear.WAR_WSD_Cape,

    }

        sets.precast.WS.Accuracy = set_combine(sets.precast.WS, {

        })

    -- Great Axe Weapon Skills

    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {
        ring2="Niqmaddu Ring",
    })

    sets.precast.WS['Full Break'] = set_combine(sets.precast.WS, {
        ammo = "Pemphredo Tathlum",
        head = "Sakpata's Helm",
        body = "Sakpata's Plate",
        hands= "Sakpata's Gauntlets",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings",
        neck = "Sanctity Necklace",
        ear1 = "Enchntr. Earring +1",
        ring1= "Metamor. Ring +1",
        ring2= {name="Stikini Ring +1", bag="wardrobe4"},
        waist= "Eschan Stone",
    })

    sets.precast.WS['Weapon Break'] = set_combine(sets.precast.WS['Full Break'], {})
    sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS['Full Break'], {})

	-- Sword Weapon Skills

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        waist="Sailfi Belt +1",
    })

        sets.precast.WS['Savage Blade'].Accuracy = set_combine(sets.precast.WS['Savage Blade'], {

        })

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        neck = "Fotia Gorget",
        ring1= "Metamor. Ring +1",
        ring2= "Rufescent Ring",
        waist= "Fotia Belt",
    })

	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
        ammo = "Ghastly Tathlum +1",
		head = "Pixie Hairpin +1",
		neck = "Baetyl Pendant",
        ear1 = "Friomisi Earring",
        ear2 = "Hecate's Earring",
        body = "Sacro Breastplate",
        hands= "Nyame Gauntlets",
		ring1= "Archon Ring",
        ring2= "Metamor. Ring +1",
        back = gear.WAR_WSD_Cape,
        waist= "Eschan Stone",
		legs = "Augury Cuisses +1",
		feet = "Nyame Sollerets",
    })

    -- Club Weapon Skills

    sets.precast.WS['True Strike'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['True Strike'].Accuracy = sets.precast.WS['Savage Blade'].Accuracy
    sets.precast.WS['Judgment'] = sets.precast.WS['True Strike']
    sets.precast.WS['Judgment'].Accuracy = sets.precast.WS['True Strike'].Accuracy

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS['Savage Blade'], {
        ear2 = "Regal Earring",
        waist= "Sailfi Belt +1",
    })

    sets.precast.WS['Black Halo'].Accuracy = set_combine(sets.precast.WS['Black Halo'], {
        ear2 = "Telos Earring",
    })

    sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']

    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {
        ring1 = "Shiva Ring +1",
    })

    -- Axe Weapon Skills

    sets.precast.WS['Decimation'] = set_combine(sets.precast.WS, {
        ammo = "Seeth. Bomblet +1",
        neck = "Fotia Gorget",
        ear1 = "Schere Earring",
        ring2= "Niqmaddu Ring",
        waist= "Fotia Belt",
    })

        sets.precast.WS['Decimation'].Accuracy = set_combine(sets.precast.WS['Savage Blade'], {
            ear1 = "Telos Earring",
            ear2 = "Digni. Earring",
        })

    sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS, {
    
    })

    -- Staff Weapon Skills

    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS['Sanguine Blade'], {

    })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Staunch Tathlum +1", --11
        --body=gear.Taeon_Phalanx_body, --10
        --hands=gear.Taeon_Phalanx_hands, --10
        --legs="Carmine Cuisses +1", --20
        --feet=gear.Taeon_Phalanx_feet, --10
        neck="Loricate Torque +1", --5
        ear1="Halasz Earring", --5
        --ear2="Magnetic Earring", --8
        --ring2="Evanescence Ring", --5
        waist="Rumination Sash", --10
    }

    sets.midcast.RA = {
        head = "Nyame Helm",
        body = "Nyame Mail",
        hands= "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        neck = "Combatant's Torque",
        ear1 = "Enervating Earring",
        ear2 = "Telos Earring",
        ring1= "Cacoethic Ring +1",
        ring2= "Longshot Ring",
        back = "Moondoe Mantle +1",
        waist= "Reiki Yotai",
    }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
    sets.resting = {
        body = "Sacro Breastplate",
        neck = "Bathy Choker +1",
        ring1= "Chirich Ring +1",
		ring2= {name="Stikini Ring +1", bag="wardrobe4"},
    }

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle = {
		ammo = "Staunch Tathlum +1",
		head = "Volte Salade",
		neck = "Bathy Choker +1",
		ear1 = "Odnowa Earring +1",
		ear2 = "Etiolation Earring",
		body = "Sacro Breastplate",
		hands= "Sakpata's Gauntlets",
		ring1= "Shneddick Ring",
		ring2= "Defending Ring",
		back = "Moonlight Cape",
		waist= "Engraved Belt",
		legs = "Volte Brayettes",
		feet = "Sakpata's Leggings",
	}

    sets.idle.DT = set_combine(sets.idle, {

    })

    sets.idle.Town = {		
        ammo = "Knobkierrie",
        head = "Agoge Mask +3",
        neck = "War. Beads +2",
        ear1 = "Odnowa Earring +1",
        ear2 = "Telos Earring",
        body = "Tatena. Harama. +1",
        hands= "Tatena. Gote +1",
        ring1= "Shneddick Ring",
        ring2= "Dim. Ring (Mea)",
        back = "Nexus Cape",
        waist= "Engraved Belt",
        legs = "Tatena. Haidate +1",
        feet = "Tatena. Sune. +1",
    }	

    sets.idle.Weak = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
		neck = "War. Beads +2",
		ear1 = "Schere Earring",
		ear2 = "Telos Earring",
        body = "Sakpata's Plate",
        hands= "Sakpata's Gauntlets",
		ring1= "Petrov Ring",
		ring2= "Niqmaddu Ring",
		back = gear.WAR_TP_Cape,
		waist= "Sailfi Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings",
    }

    sets.engaged.Accuracy = set_combine(sets.engaged, {
        ammo = "Seeth. Bomblet +1",
		ear1 = "Mache Earring +1",
		ear2 = "Telos Earring",
		ring1= "Chirich Ring +1",
		ring2= "Niqmaddu Ring",
		waist= "Kentarch Belt +1",
    })

    sets.engaged.MaxAccuracy = set_combine(sets.engaged.Accuracy, {
        body = "Tatena. Harama. +1",
		hands= "Tatena. Gote +1",
		legs = "Tatena. Haidate +1",
		feet = "Tatena. Sune. +1",
    })

    -- Base Dual-Wield Values:
    -- * DW6: +37%
    -- * DW5: +35%
    -- * DW4: +30%
    -- * DW3: +25% (NIN Subjob)
    -- * DW2: +15% (DNC Subjob)
    -- * DW1: +10%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
    } 

    sets.engaged.DW.Accuracy = set_combine(sets.engaged.DW, {

    })

    sets.engaged.DW.MaxAccuracy = set_combine(sets.engaged.DW.Accuracy, {

    })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {

    }) -- 37%

    sets.engaged.DW.Accuracy.LowHaste = set_combine(sets.engaged.DW.LowHaste, {

    })

    sets.engaged.DW.MaxAccuracy.LowHaste = set_combine(sets.engaged.DW.Accuracy.LowHaste, {

    })


    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {

    }

    sets.engaged.DW.Accuracy.MidHaste = set_combine(sets.engaged.DW.MidHaste, {

    })

    sets.engaged.DW.MaxAccuracy.MidHaste = set_combine(sets.engaged.DW.Accuracy.MidHaste, {

    })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {

    } -- 

    sets.engaged.DW.Accuracy.HighHaste = set_combine(sets.engaged.DW.HighHaste, {

    })

    sets.engaged.DW.MaxAccuracy.HighHaste = set_combine(sets.engaged.DW.Accuracy.HighHaste, {

    })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {

    } -- 

    sets.engaged.DW.Accuracy.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {

    })

    sets.engaged.DW.MaxAccuracy.MaxHaste = set_combine(sets.engaged.DW.Accuracy.MaxHaste, {

    })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        ring2="Defending Ring", --10/10
    }

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

    sets.Kiting = {ring1="Shneddick Ring"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

	sets.buff.Doom = {
        neck="Nicander's Necklace", -- 20%
        ring1={name="Saida Ring", bag="wardrobe3"}, -- 15%
        ring2={name="Saida Ring", bag="wardrobe4"}, -- 15%
        waist="Gishdubar Sash", -- 10%
    } -- 60% Cursna received

    sets.buff.Sleep = {
		neck="Vim Torque +1",
	}

    sets.CP = {
		back="Mecisto. Mantle"
	}

    sets.Reive = {
		neck="Ygnas's Resolve +1"
	}

    sets.TreasureHunter = {legs="Volte Hose", hands="Valorous Mitts", waist="Chaac Belt"}

    sets.Axe = {main="Dolichenus", sub="Blurred Shield +1"}
    sets.AxeDW = {main="Dolichenus", sub="Sangarius +1"}
    sets.Sword = {main="Naegling", sub="Blurred Shield +1"}
    sets.SwordDW = {main="Naegling", sub="Sangarius +1"}
    sets.Club = {main="Loxotic Mace +1", sub="Blurred Shield +1"}
    sets.ClubDW = {main="Loxotic Mace +1", sub="Sangarius +1"}
    sets.H2H = {}
    sets.GreatAxe = {main="Chango", sub="Utu Grip"}
    sets.GreatSword = {main="Montante +1", sub="Utu Grip"}
    sets.Lance = {main="Shining One", sub="Utu Grip"}
    sets.Staff = {main="Xoanon", sub="Utu Grip"}
    sets.Scythe = {main="Tokko Scythe", sub="Utu Grip"}
    sets.Archery = {main="Kustawi +1", sub="Blurred Shield +1", range="Ullr", ammo="Chapuli Arrow"}
    sets.Crossbow = {}
    sets.DMG1 = {main="Firetongue", sub="Sacro Bulwark"}
    sets.DMG1DW = {main="Ceremonial Dagger", sub="Qutrub Knife"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
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
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if elemental_ws:contains(spell.name) then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 1.7 yalms.
            elseif spell.target.distance < (1.7 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Magical' then
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' then
            equip(sets.midcast['Blue Magic'].HealingSelf)
        end
    end

    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Dream Flower" then
            send_command('@timers c "Dream Flower ['..spell.target.name..']" 90 down spells/00098.png')
        elseif spell.english == "Soporific" then
            send_command('@timers c "Sleep ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sheep Song" then
            send_command('@timers c "Sheep Song ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Yawn" then
            send_command('@timers c "Yawn ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Entomb" then
            send_command('@timers c "Entomb ['..spell.target.name..']" 60 down spells/00547.png')
        end
    end
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
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
            send_command('@input /p <me> is Doomed! Cursna, please!')
            disable('neck','ring1','ring2','waist')
        else
            send_command('@input /p No longer Doomed, thanks!')
            enable('neck','ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

	if buff == "charm" then
        if gain then
            send_command('@input /p <me> is Charmed! Sleep me, Break me, or GTFO!')
        else
            send_command('@input /p No longer Charmed! It\'s safe to come out now!')
            handle_equipping_gear(player.status)
        end
    end

    if buff == "sleep" then
        if gain then
            send_command('@input /me doze')
            --send_command('@input /p <me> is Asleep! Zzz...')
            equip(sets.buff.Sleep)
            disable('neck')
        else
            --send_command('@input /p I\'m awake, thanks!')
            enable('neck')
            handle_equipping_gear(player.status)
        end
    end

    if buff == 'Hasso' and not gain then
        add_to_chat(167, 'Hasso just expired!')
        send_command('@input /ja "Hasso" <me>')
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
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)

    check_weaponset()

    return meleeSet
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MaxAccuracy' then
        wsmode = 'Accuracy'
    end

    return wsmode
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    --if state.IdleMode.value == 'Learning' then
    --    equip(sets.Learning)
    --    disable('hands')
    --else
    --    enable('hands')
    --end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
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

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
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
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 27 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
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

function update_active_abilities()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Efflux'] = buffactive['Efflux'] or false
    state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end

-- State buff checks that will equip buff gear and mark the event as handled.
function apply_ability_bonuses(spell, action, spellMap)
    if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        equip(sets.buff['Burst Affinity'])
    end
    if state.Buff.Efflux and spellMap == 'Physical' then
        equip(sets.buff['Efflux'])
    end
    if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then
        equip(sets.buff['Diffusion'])
    end

    if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end
    if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end
    if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end
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

function check_weaponset()
    equip(sets[state.WeaponSet.current])
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
	if player.sub_job == 'DRG' then
		set_macro_page(1, 5)
	elseif player.sub_job == 'SAM' then
		set_macro_page(2, 5)
	elseif player.sub_job == 'NIN' then
		set_macro_page(3, 5)
	elseif player.sub_job == 'DNC' then
		set_macro_page(4, 5)
	else
		set_macro_page(5, 5)
	end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end

-- Ensure items are always in your inventory.
organizer_items = {
    neck = "War. Beads +2",
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
    tomahawks="Thr. Tomahawk",
	shield="Blurred Shield +1",
	sword="Naegling",
    offhand="Sangarius +1",
    lowdmg="Firetongue",
    axe="Dolichenus",
	club="Loxotic Mace +1",
	gaxe="Chango",
	gsword="Montante +1",
    scythe="Tokko Scythe",
	lance="Shining One",
    staff="Xoanon",
    bow="Ullr",
    arrows="Chapuli Arrow",
    quivers="Chapuli Quiver",
	cbow="Exalted C.bow +1",
    -- AF
    artifact_head="",
    artifact_body="Pumm. Lorica +3",
    artifact_hands="",
    artifact_legs="Pumm. Cuisses +2",
    artifact_feet="Pumm. Calligae +2",
    -- Relic
    relic_head="Agoge Mask +3",
    relic_body="Agoge Lorica +1",
    relic_hands="Agoge Mufflers +1",
    relic_legs="Agoge Cuisses +1",
    relic_feet="Agoge Calligae +1",
    -- Empyrean
    empy_head="",
    empy_body="",
    empy_hands="",
    empy_legs="",
    empy_feet="",
}