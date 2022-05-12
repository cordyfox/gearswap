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
--              [ ALT+Q ]            Nature's Meditation/Fantod
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
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false

    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    blue_magic_maps = {}

    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.

    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{'Bilgestorm'}

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{'Heavy Strike'}

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Saurian Slide','Sinker Drill','Spinal Cleave','Sweeping Gouge',
        'Uppercut','Vertical Cleave'}

    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone',
        'Disseverment','Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault','Vanity Dive'}

    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'}

    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'}

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{'Mandibular Bite','Queasyshroom'}

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{'Ram Charge','Screwdriver','Tourbillion'}

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{'Bludgeon'}

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{'Final Sting'}

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{'Anvil Lightning','Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere',
        'Droning Whirlwind','Embalming Earth','Entomb','Firespit','Foul Waters','Ice Break','Leafstorm',
        'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
        'Silent Storm','Spectral Floe','Subduction','Tem. Upheaval','Water Bomb','Searing Tempest'}

    blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
        'Tenebral Crush'}

    blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
        'Retinal Glare'}

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{'Acrid Stream','Magic Hammer','Mind Blast'}

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{'Mysterious Light'}

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{'Thermal Pulse'}

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{'Charged Whisker','Gates of Hades'}

    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{'1000 Needles','Absolute Terror','Actinic Burst','Atra. Libations',
        'Auroral Drape','Awful Eye', 'Blank Gaze','Blistering Roar','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest','Dream Flower',
        'Enervation','Feather Tickle','Filamented Hold','Frightful Roar','Geist Wall','Hecatomb Wave',
        'Infrasonics','Jettatura','Light of Penance','Lowing','Mind Blast','Mortal Ray','MP Drainkiss',
        'Osmosis','Reaving Wind','Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast',
        'Stinking Gas','Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'}

    -- Breath-based spells
    blue_magic_maps.Breath = S{'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath','Hecatomb Wave',
        'Magnetite Cloud','Poison Breath','Self-Destruct','Thunder Breath','Vapor Spray','Wind Breath'}

    -- Stun spells
    blue_magic_maps.StunPhysical = S{'Frypan','Head Butt','Sudden Lunge','Tail slap','Whirl of Rage'}
    blue_magic_maps.StunMagical = S{'Blitzstrahl','Temporal Shift','Thunderbolt'}

    -- Healing spells
    blue_magic_maps.Healing = S{'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
        'Wild Carrot'}

    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body',
        'Plasma Charge','Pyric Bulwark','Reactor Cool','Occultation'}

    -- Other general buffs
    blue_magic_maps.Buff = S{'Amplification','Animating Wail','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell','Memento Mori',
        'Nat. Meditation','Orcish Counterstance','Refueling','Regeneration','Saline Coat','Triumphant Roar',
        'Warm-Up','Winds of Promyvion','Zephyr Mantle'}

    blue_magic_maps.Refresh = S{'Battery Charge'}

    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool',
        'Crashing Thunder','Cruel Joke','Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard',
        'Polar Roar','Pyric Bulwark','Tearing Gust','Thunderbolt','Tourbillion','Uproot'}

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}
    elemental_ws = S{'Flash Nova', 'Sanguine Blade'}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 1
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Accuracy', 'MaxAccuracy', 'STP')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
    state.IdleMode:options('Normal', 'DT')--, 'Learning')

    state.WeaponSet = M{['description']='Weapon Set', 'Tizona','Naegling','Sakpata','Maxentius','Casting'}
    state.Rune = M{['description']='Rune', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    -- state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line

    send_command('lua l azureSets')

    send_command('bind @t gs c cycle treasuremode')
    send_command('bind !] gs c toggle WeaponLock')
    -- send_command('bind @c gs c toggle CP')
    send_command('bind ^[ gs c cycleback WeaponSet')
    send_command('bind ^] gs c cycle WeaponSet')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind ^- input /ja "Chain Affinity" <me>')
    --send_command('bind ^[ input /ja "Efflux" <me>')
    send_command('bind ^= input /ja "Burst Affinity" <me>')
    --send_command('bind ![ input /ja "Diffusion" <me>')
    --send_command('bind !] input /ja "Unbridled Learning" <me>')
    send_command('bind !e input /ma "Erratic Flutter" <me>')
    send_command('bind !t input /ma "Occultation" <me>')

    if player.sub_job == "RDM" then
        send_command('bind !q input /ma "Fantod" <me>')
        send_command('bind !w input /ma "Reactor Cool" <me>')
        send_command('bind !r input /ma "Refresh" <stpc>')
        send_command('bind !y input /ma "Phalanx" <me>')
        send_command('bind !u input /ma "Stoneskin" <me>')
        send_command('bind !p input /ma "Carcharian Verve" <me>')
    else
        send_command('bind !q input /ma "Nat. Meditation" <me>')
        send_command('bind !w input /ma "Cocoon" <me>')
        send_command('bind !r input /ma "Battery Charge" <me>')
        send_command('bind !y input /ma "Barrier Tusk" <me>')
        send_command('bind !u input /ma "Diamondhide" <me>')
        send_command('bind !p input /ma "Mighty Guard" <me>')
    end

    -- send_command('bind @c gs c toggle CP')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'RUN' then
        send_command('bind ^insert gs c cycleback Rune')
        send_command('bind ^delete gs c cycle Rune')
        send_command('bind ^numpad/ input /ja "Swordplay" <me>')
        send_command('bind ^numpad* input /ja "Pflug" <me>')
        send_command('bind ^numpad- input /ja "Vallation" <me>')
        send_command('bind !numpad* input /ja "Lunge" <me>')
        send_command('bind !numpad- input /ja "Swipe" <me>')
    end

    send_command('bind ^numpad1 input /ws "Expiacion" <t>')
    send_command('bind ^numpad2 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad3 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad4 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad5 input /ws "Requiescat" <t>')

    send_command('bind !numpad1 input /ws "Black Halo" <t>')
    send_command('bind !numpad2 input /ws "Flash Nova" <t>')
    send_command('bind !numpad3 input /ws "Black Halo" <t>')

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
    send_command('unbind @t')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind !]')
    send_command('unbind !q')
    send_command('unbind !w')
    send_command('bind !e input /ma Haste <stpc>')
    send_command('bind !t input /ma Blink <me>')
    send_command('bind !r input /ma Refresh <stpc>')
    send_command('bind !y input /ma Phalanx <me>')
    send_command('bind !u input /ma Stoneskin <me>')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind @w')
    -- send_command('unbind @c')
    send_command('unbind @e')
    send_command('unbind @r')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')

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

    send_command('lua u azureSets')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs

    -- Enmity set
    sets.Enmity = {
        ammo = "Sapience Orb", --2
        head = "Halitus Helm", --8
        body = "Emet Harness +1", --10
        hands= "Kurys Gloves", --9
        feet = "Ahosi Leggings", --7
        neck = "Unmoving Collar +1", --10
        ear1 = "Cryptic Earring", --4
        ear2 = "Trux Earring", --5
        ring1= "Pernicious Ring", --5
        ring2= "Eihwaz Ring", --5
        waist= "Kasiri Belt", --3
    }

    sets.precast.JA['Provoke'] = sets.Enmity

    sets.buff['Burst Affinity'] = {legs="Assim. Shalwar +3", feet="Hashi. Basmak +1"}
    sets.buff['Diffusion'] = {feet="Luhlaza Charuqs +3"}
    sets.buff['Efflux'] = {legs="Hashishin Tayt +1"}

    sets.precast.JA['Azure Lore'] = {hands="Luh. Bazubands +3"}
    sets.precast.JA['Chain Affinity'] = {feet="Assim. Charuqs"}
    sets.precast.JA['Convergence'] = {head="Luh. Keffiyeh +3"}
    sets.precast.JA['Enchainment'] = {body="Luhlaza Jubbah +3"}

    sets.precast.FC = {
        ammo = "Sapience Orb", --2
        head = "Carmine Mask +1", --14
        body = "Luhlaza Jubbah +3", --9
        hands= "Leyline Gloves", --8
        legs = "Aya. Cosciales +2", --6
        feet = "Carmine Greaves +1", --8
        neck = "Baetyl Pendant", --5
        ear1 = "Loquacious Earring", --2
        ear2 = "Enchntr. Earring +1", --2
        ring1= "Kishar Ring", --4
        ring2= "Prolix Ring", --6(4)
        back = "Fi Follet Cape +1", --4
    }

    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear1="Mendi. Earring"})

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        ring1="Lebeche Ring",
        waist="Rumination Sash",
    })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo = "Aurgelmir Orb",
        head = gear.Herc_WSD_head,
        body = "Assim. Jubbah +3",
        hands= "Jhakri Cuffs +2",
        legs = "Luhlaza Shalwar +3",
        feet = gear.Herc_WSD_feet,
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Ishvara Earring",
        ring1= "Beithir Ring",
        ring2= "Ilabrat Ring",
        back = gear.BLU_WSD_Cape,
        waist= "Fotia Belt",
    }

        sets.precast.WS.Acc = set_combine(sets.precast.WS, {
            ammo = "Falcon Eye",
            head = "Dampening Tam",
            hands= gear.Herc_WS_hands,
            ear2 = "Telos Earring",
        })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        head = "Adhemar Bonnet +1",
        body = "Gleti's Cuirass",
        hands= "Adhemar Wrist. +1",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots",
        neck = "Mirage Stole +2",
        ear1 = "Odr Earring",
        ear2 = "Mache Earring +1",
        ring1= "Begrudging Ring",
        ring2= "Epona's Ring",
        back = gear.BLU_TP_Cape,
    })

        sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
            ammo = "Falcon Eye",
            head = "Dampening Tam",
            body = "Adhemar Jacket +1",
            hands= "Adhemar Wrist. +1",
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        body = "Assim. Jubbah +3",
        neck = "Mirage Stole +2",
        ring2= "Rufescent Ring",
        waist= "Sailfi Belt +1",
    })

        sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
            ammo = "Falcon Eye",
            ear2 = "Telos Earring",
            waist= "Grunfeld Rope",
        })

    sets.precast.WS['Requiescat'] = {
        head = "Luh. Keffiyeh +3",
        body = "Luhlaza Jubbah +3",
        hands= "Jhakri Cuffs +2",
        legs = "Luhlaza Shalwar +3",
        feet = "Luhlaza Charuqs +3",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Brutal Earring",
        ring1= "Rufescent Ring",
        ring2= "Epona's Ring",
        back = gear.BLU_WS1_Cape,
        waist= "Fotia Belt",
    }

        sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
            ammo = "Falcon Eye",
            head = "Dampening Tam",
            ear1 = "Mache Earring +1",
            ear2 = "Telos Earring",
        })

    sets.precast.WS['Expiacion'] = sets.precast.WS['Savage Blade']

        sets.precast.WS['Expiacion'].Acc = set_combine(sets.precast.WS['Expiacion'], {
            body="Adhemar Jacket +1",
            ear2="Telos Earring",
        })

    sets.precast.WS['Sanguine Blade'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Pixie Hairpin +1",
        body = "Amalric Doublet +1",
        hands= "Amalric Gages +1",
        legs = "Luhlaza Shalwar +3",
        feet = "Amalric Nails +1",
        neck = "Baetyl Pendant",
        ear1 = "Moonshade Earring",
        ear2 = "Regal Earring",
        ring1= "Metamor. Ring +1",
        ring2= "Archon Ring",
        back = gear.BLU_MAB_Cape,
        waist= "Sacro Cord",
    }

    sets.precast.WS['True Strike'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['True Strike'].Acc = sets.precast.WS['Savage Blade'].Acc
    sets.precast.WS['Judgment'] = sets.precast.WS['True Strike']
    sets.precast.WS['Judgment'].Acc = sets.precast.WS['True Strike'].Acc

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS['Savage Blade'], {
        ear2="Regal Earring",
        waist="Sailfi Belt +1",
    })

    sets.precast.WS['Black Halo'].Acc = set_combine(sets.precast.WS['Black Halo'], {
        ear2="Telos Earring",
    })

    sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']
    sets.precast.WS['Realmrazer'].Acc = sets.precast.WS['Requiescat'].Acc

    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {
        head=gear.Herc_MAB_head,
        --ring2="Weather. Ring +1",
    })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC
    sets.midcast['Divine Magic'] = set_combine(sets.TreasureHunter, {})

    sets.midcast.SpellInterrupt = {
        ammo = "Staunch Tathlum +1", --11
        body = gear.Taeon_Phalanx_body, --10
        hands= gear.Taeon_Phalanx_hands, --10
        legs = "Carmine Cuisses +1", --20
        feet = gear.Taeon_Phalanx_feet, --10
        neck = "Loricate Torque +1", --5
        ear1 = "Halasz Earring", --5
        --ear2="Magnetic Earring", --8
        ring2= "Evanescence Ring", --5
        waist= "Rumination Sash", --10
    }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast['Blue Magic'] = {
        ammo = "Mavi Tathlum",
        head = "Luh. Keffiyeh +3",
        body = "Assim. Jubbah +3",
        hands= "Rawhide Gloves",
        legs = "Hashishin Tayt +1",
        feet = "Luhlaza Charuqs +3",
        neck = "Mirage Stole +2",
        --ear1 = "Njordr Earring",
        ring1= {name="Stikini Ring +1", bag="wardrobe3"},
        ring2= {name="Stikini Ring +1", bag="wardrobe4"},
        back = "Cornflower Cape",
    }

    sets.midcast['Blue Magic'].Physical = {
        ammo = "Aurgelmir Orb",
        head = "Luh. Keffiyeh +3",
        body = "Luhlaza Jubbah +3",
        hands= "Luh. Bazubands +3",
        legs = "Jhakri Slops +2",
        feet = "Luhlaza Charuqs +3",
        neck = "Mirage Stole +2",
        ear1 = "Odr Earring",
        ear2 = "Telos Earring",
        ring1= "Shukuyu Ring",
        ring2= "Ilabrat Ring",
        back = gear.BLU_WSD_Cape,
        waist= "Prosilio Belt +1",
    }

        sets.midcast['Blue Magic'].PhysicalAcc = set_combine(sets.midcast['Blue Magic'].Physical, {
            ammo = "Falcon Eye",
            head = "Carmine Mask +1",
            --hands = "Gazu Bracelet +1",
            legs = "Carmine Cuisses +1",
            ear2 = "Telos Earring",
            back = "Cornflower Cape",
            waist= "Grunfeld Rope",
        })

        sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical

        sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {
            ear2="Mache Earring +1",
            ring2="Ilabrat Ring",
            back=gear.BLU_WS1_Cape,
            waist="Grunfeld Rope",
            })

        sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical

        sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {
            hands= "Adhemar Wrist. +1",
            ring2= "Ilabrat Ring",
        })

        sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {
            ammo = "Ghastly Tathlum +1",
            ear2 = "Regal Earring",
            ring1= "Metamor. Ring +1",
            ring2= "Shiva Ring +1",
            back = "Aurist's Cape +1",
            waist= "Acuity Belt +1",
        })

        sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {
            ear2 = "Regal Earring",
            ring1= {name="Stikini Ring +1", bag="wardrobe3"},
            ring2= {name="Stikini Ring +1", bag="wardrobe4"},
            back = "Aurist's Cape +1",
        })

        sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {
            ear1 = "Regal Earring",
            ear2 = "Enchntr. Earring +1"
        })

    sets.midcast['Blue Magic'].Magical = {
        ammo = "Ghastly Tathlum +1",
        head = empty,
        body = "Cohort Cloak +1",
        hands= "Amalric Gages +1",
        legs = "Amalric Slops +1",
        feet = "Amalric Nails +1",
        neck = "Baetyl Pendant",
        ear1 = "Friomisi Earring",
        ear2 = "Regal Earring",
        ring1= "Metamor. Ring +1",
        ring2= "Shiva Ring +1",
        back = gear.BLU_MAB_Cape,
        waist= "Sacro Cord",
    }

        sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical, {
            ammo = "Pemphredo Tathlum",
            head="Assim. Keffiyeh +3",
            hands="Jhakri Cuffs +2",
            legs="Luhlaza Shalwar +3",
            neck="Mirage Stole +2",
            ear1="Digni. Earring",
            ring1={name="Stikini Ring +1", bag="wardrobe3"},
            ring2={name="Stikini Ring +1", bag="wardrobe4"},
            waist="Acuity Belt +1",
        })

    sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Pixie Hairpin +1",
        ring2="Archon Ring",
    })

    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {
        ring2="Weather. Ring +1"
    })

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Aurist's Cape +1",
        })

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        ammo="Aurgelmir Orb",
        ear2="Mache Earring +1",
        ring2="Ilabrat Ring",
        })

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {
        ammo="Aurgelmir Orb",
        })

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {
        ammo="Falcon Eye",
        ear1="Regal Earring",
        ear2="Enchntr. Earring +1"
        })

    sets.midcast['Blue Magic'].MagicAccuracy = {
        ammo="Pemphredo Tathlum",
        head="Assim. Keffiyeh +3",
        body="Amalric Doublet +1",
        hands="Nyame Gauntlets",
        legs="Assim. Shalwar +3",
        feet="Nyame Sollerets",
        neck="Mirage Stole +2",
        ear1="Digni. Earring",
        ear2="Regal Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Aurist's Cape +1",
        waist="Acuity Belt +1",
        head="Volte Cap", hands=gear.Herc_TH_hands, feet="Volte Boots" -- TH Tag
        }

    sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, {head="Luh. Keffiyeh +3"})

    sets.midcast['Blue Magic'].StunPhysical = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        ammo = "Falcon Eye",
        head = "Malignance Chapeau",
        body = "Nyame Mail",
        hands= "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        neck = "Mirage Stole +2",
        ear2 = "Mache Earring +1",
        back = "Aurist's Cape +1",
        waist= "Eschan Stone",
    })

    sets.midcast['Blue Magic'].StunMagical = sets.midcast['Blue Magic'].MagicAccuracy

    sets.midcast['Blue Magic'].Healing = {
        ammo = "Quartz Tathlum +1",
        head = "Pinga Crown", -- 8%
        body = "Pinga Tunic", -- 13%
        hands= "Pinga Mittens", -- 5%
        legs = "Pinga Pants", -- 11%
        feet = "Pinga Pumps", -- 3%
        neck = "Aife's Medal",
        waist= "Luminary Sash",
        ear1 = "Regal Earring",
        ear2 = "Lifestorm Earring",
        ring1= "Metamor. Ring +1",
        ring2= {name="Stikini Ring +1", bag="wardrobe4"},
        back = gear.BLU_Cure_Cape, -- 10%
    } -- 50/50 Cure Potency I

    sets.midcast['Blue Magic'].HealingSelf = set_combine(sets.midcast['Blue Magic'].Healing, {
        --legs="Gyve Trousers", -- 10
        --neck="Phalaina Locket", -- 4(4)
        ring2="Asklepian Ring", -- (3)
        waist="Gishdubar Sash", -- (10)
    })

    sets.midcast['Blue Magic']['White Wind'] = set_combine(sets.midcast['Blue Magic'].Healing, {
        head=gear.Adhemar_D_head,
        neck="Sanctity Necklace",
        ear2="Etiolation Earring",
        ring2="Eihwaz Ring",
        back="Moonlight Cape",
        waist="Kasiri Belt",
    })

    sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {head="Amalric Coif +1", waist="Gishdubar Sash", back="Grapevine Cape"})
    sets.midcast['Blue Magic'].SkillBasedBuff = sets.midcast['Blue Magic']

    sets.midcast['Blue Magic']['Occultation'] = set_combine(sets.midcast['Blue Magic'], {
        hands="Hashi. Bazu. +1",
        --ear1="Njordr Earring",
        ear2="Enchntr. Earring +1",
        ring1 = {name="Stikini Ring +1", bag="wardrobe3"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe4"},
    }) -- 1 shadow per 50 skill

    sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {
        head="Amalric Coif +1",
        waist="Emphatikos Rope",
    })

    sets.midcast['Elemental Magic'] = {
        ammo = "Ghastly Tathlum +1",
        head = empty,
        body = "Cohort Cloak +1",
        hands= "Amalric Gages +1",
        legs = "Amalric Slops +1",
        feet = "Amalric Nails +1",
        neck = "Baetyl Pendant",
        ear1 = "Friomisi Earring",
        ear2 = "Regal Earring",
        ring1= "Metamor. Ring +1",
        ring2= "Shiva Ring +1",
        back = gear.BLU_MAB_Cape,
        waist= "Sacro Cord",
    }

    sets.midcast['Enhancing Magic'] = {
        --ammo="Pemphredo Tathlum",
        head = "Carmine Mask +1",
        body = gear.Telchine_ENH_body,
        hands= gear.Telchine_ENH_hands,
        legs = "Carmine Cuisses +1",
        feet = gear.Telchine_ENH_feet,
        neck = "Incanter's Torque",
        --ear1="Mimir Earring",
        ear2 = "Andoaa Earring",
        ring1= {name="Stikini Ring +1", bag="wardrobe3"},
        ring2= {name="Stikini Ring +1", bag="wardrobe4"},
        back = "Fi Follet Cape +1",
        waist= "Olympus Sash",
    }

    sets.midcast.EnhancingDuration = {
        head = gear.Telchine_ENH_head,
        body = gear.Telchine_ENH_body,
        hands= gear.Telchine_ENH_hands,
        legs = gear.Telchine_ENH_legs,
        feet = gear.Telchine_ENH_feet,
    }

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {head="Amalric Coif +1", waist="Gishdubar Sash", back="Grapevine Cape"})
    
    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        --hands = "Stone Mufflers",
        legs = "Shedir Seraweels",
        neck = "Stone Gorget",
        waist= "Siegel Sash",
    })

    sets.midcast.Phalanx = set_combine(sets.midcast.EnhancingDuration, {
        head = gear.Taeon_Phalanx_head, --3(10)
        body = gear.Taeon_Phalanx_body, --3(10)
        hands= gear.Taeon_Phalanx_hands, --3(10)
        legs = gear.Taeon_Phalanx_legs, --3(10)
        feet = gear.Taeon_Phalanx_feet, --3(10)
    })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        head = "Amalric Coif +1",
        --hands = "Regal Cuffs",
        waist = "Emphatikos Rope",
    })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        head=empty;
        body="Cohort Cloak +1",
        ear2="Vor Earring",
    })

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- k Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
    sets.resting = {}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = gear.Herc_Refresh_head,
        body = "Luhlaza Jubbah +3",
        hands= "Gleti's Gauntlets",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots",
        neck = "Bathy Choker +1",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        ring1= "Shneddick Ring",
        ring2= {name="Stikini Ring +1", bag="wardrobe4"},
        back = "Moonlight Cape",
        waist= "Carrier's Sash",
    }

    sets.idle.DT = set_combine(sets.idle, {
        ammo = "Staunch Tathlum +1", --3/3
        head = "Malignance Chapeau", --6/6
        body = "Nyame Mail", --9/9
        hands= "Nyame Gauntlets", --5/5
        legs = "Nyame Flanchard", --7/7
        feet = "Nyame Sollerets", --4/4
        neck = "Warder's Charm +1",
        ring1= "Epona's Ring", --0/4
        ring2= "Defending Ring", --10/10
        back = "Moonlight Cape", --6/6
    })

    sets.idle.Town = set_combine(sets.idle, {
        ammo = "Coiste Bodhar",
        head = "Luh. Keffiyeh +3",
        body = "Luhlaza Jubbah +3",
        hands= "Luh. Bazubands +3",
        legs = "Luhlaza Shalwar +3",
        feet = "Luhlaza Charuqs +3",
        neck = "Mirage Stole +2",
        ear1 = "Eabani Earring",
        ear2 = "Telos Earring",
        back = "Nexus Cape",
        ring1= "Shneddick Ring",
        ring2= "Warp Ring",
        waist= "Sailfi Belt +1",
    })

    sets.idle.Refresh = set_combine(sets.idle, {
        head = gear.Herc_Refresh_head,
        body = "Jhakri Robe +2",
        legs = "Rawhide Trousers",
        ring1= {name="Stikini Ring +1", bag="wardrobe3"},
        ring2= {name="Stikini Ring +1", bag="wardrobe4"},
    })

    sets.idle.Weak = sets.idle.DT

    --sets.idle.Learning = set_combine(sets.idle, sets.Learning)

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
        head = "Adhemar Bonnet +1",
        body = "Adhemar Jacket +1",
        hands= "Adhemar Wrist. +1",
        legs = "Samnuha Tights",
        feet = gear.Herc_TA_feet,
        neck = "Mirage Stole +2",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        ring1= "Ilabrat Ring",
        ring2= "Epona's Ring",
        back = gear.BLU_TP_Cape,
        waist= "Sailfi Belt +1",
    }

    sets.engaged.Accuracy = set_combine(sets.engaged, {
        head="Dampening Tam",
        hands="Adhemar Wrist. +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
    })

    sets.engaged.MaxAccuracy = set_combine(sets.engaged.Accuracy, {
        ammo="Falcon Eye",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
    })

    sets.engaged.STP = set_combine(sets.engaged, {
        head=gear.Herc_STP_head,
        feet="Carmine Greaves +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
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
        ammo="Aurgelmir Orb",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", --6
        hands="Adhemar Wrist. +1",
        legs="Carmine Cuisses +1", --6
        feet=gear.Taeon_DW_feet, --9
        neck="Mirage Stole +2",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Ilabrat Ring",
        ring2="Epona's Ring",
        back=gear.BLU_TP_Cape,
        waist="Reiki Yotai", --7
    } -- 37%

    sets.engaged.DW.Accuracy = set_combine(sets.engaged.DW, {
        head="Dampening Tam",
        hands="Adhemar Wrist. +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
    })

    sets.engaged.DW.MaxAccuracy = set_combine(sets.engaged.DW.Accuracy, {
        ammo="Falcon Eye",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
    })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
        head=gear.Herc_STP_head,
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
    })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
        ammo="Aurgelmir Orb",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", --6
        hands="Adhemar Wrist. +1",
        legs="Carmine Cuisses +1", --6
        feet=gear.Taeon_DW_feet, --9
        neck="Mirage Stole +2",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Ilabrat Ring",
        ring2="Epona's Ring",
        back=gear.BLU_TP_Cape,
        waist="Reiki Yotai", --7
    }) -- 37%

    sets.engaged.DW.Accuracy.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        head="Dampening Tam",
        hands="Adhemar Wrist. +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
    })

    sets.engaged.DW.MaxAccuracy.LowHaste = set_combine(sets.engaged.DW.Accuracy.LowHaste, {
        ammo="Falcon Eye",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
    })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        head=gear.Herc_STP_head,
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
    })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
        ammo="Aurgelmir Orb",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", --6
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet=gear.Taeon_DW_feet, --9
        neck="Mirage Stole +2",
        ear1="Telos Earring",
        ear2="Suppanomimi", --5
        ring1="Ilabrat Ring",
        ring2="Epona's Ring",
        back=gear.BLU_TP_Cape,
        waist="Reiki Yotai", --7
    } -- 27%

    sets.engaged.DW.Accuracy.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head="Dampening Tam",
        hands="Adhemar Wrist. +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
    })

    sets.engaged.DW.MaxAccuracy.MidHaste = set_combine(sets.engaged.DW.Accuracy.MidHaste, {
        ammo="Falcon Eye",
        feet=gear.Herc_TA_feet,
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
    })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head=gear.Herc_STP_head,
        ear1="Dedition Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
        ammo="Aurgelmir Orb",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", --6
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Mirage Stole +2",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Ilabrat Ring",
        ring2="Epona's Ring",
        back=gear.BLU_TP_Cape,
        waist="Reiki Yotai", --7
        } -- 22%

    sets.engaged.DW.Accuracy.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head="Dampening Tam",
        hands="Adhemar Wrist. +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.MaxAccuracy.HighHaste = set_combine(sets.engaged.DW.Accuracy.HighHaste, {
        ammo="Falcon Eye",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head=gear.Herc_STP_head,
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
        ammo="Aurgelmir Orb",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", --6
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Mirage Stole +2",
        ear1="Telos Earring",
        ear2="Telos Earring",
        ring1="Ilabrat Ring",
        ring2="Epona's Ring",
        back=gear.BLU_TP_Cape,
        waist="Sailfi Belt +1",
        } -- 6%

    sets.engaged.DW.Accuracy.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head="Dampening Tam",
        hands="Adhemar Wrist. +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MaxAccuracy.MaxHaste = set_combine(sets.engaged.DW.Accuracy.MaxHaste, {
        ammo="Falcon Eye",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head=gear.Herc_STP_head,
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        waist="Kentarch Belt +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Malignance Chapeau", --6/6
        body="Nyame Mail", --9/9
        hands="Nyame Gauntlets", --5/5
        legs="Nyame Flanchard", --7/7
        feet="Nyame Sollerets", --4/4
        ring2="Defending Ring", --10/10
    }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Accuracy.DT = set_combine(sets.engaged.Accuracy, sets.engaged.Hybrid)
    sets.engaged.MaxAccuracy.DT = set_combine(sets.engaged.MaxAccuracy, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT = set_combine(sets.engaged.DW.Accuracy, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT = set_combine(sets.engaged.DW.MaxAccuracy, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT.LowHaste = set_combine(sets.engaged.DW.Accuracy.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT.LowHaste = set_combine(sets.engaged.DW.MaxAccuracy.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT.MidHaste = set_combine(sets.engaged.DW.Accuracy.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT.MidHaste = set_combine(sets.engaged.DW.MaxAccuracy.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT.HighHaste = set_combine(sets.engaged.DW.Accuracy.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT.HighHaste = set_combine(sets.engaged.DW.MaxAccuracy.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Accuracy.DT.MaxHaste = set_combine(sets.engaged.DW.Accuracy.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MaxAccuracy.DT.MaxHaste = set_combine(sets.engaged.DW.MaxAccuracy.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {
        body="Samnuha Coat", --(8)
        hands="Amalric Gages +1", --(6)
        legs="Assim. Shalwar +3", --10
        feet="Jhakri Pigaches +2", --7
        neck="Warder's Charm +1", --10
        --ear1="Static Earring",--5
        ring1="Mujin Band", --(5)
        --ring2="Locus Ring", --5
        back="Seshaw Cape", --5
        })

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.Learning = {hands="Assim. Bazu. +2"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Saida Ring", bag="wardrobe3"}, --20
        ring2={name="Saida Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
    }

    sets.TreasureHunter = {
        ammo = "Per. Lucky Egg", --1
        legs = "Volte Hose", --1
        feet = "Volte Boots", --1
        waist= "Chaac Belt", --1
    }

    sets.CP = {back="Mecisto. Mantle"}
    sets.midcast.Dia = sets.TreasureHunter
    sets.midcast.Diaga = sets.TreasureHunter
    sets.midcast.Bio = sets.TreasureHunter
    sets.Reive = {neck="Ygnas's Resolve +1"}

    sets.Tizona = {main="Tizona", sub="Thibron"}
    sets.Naegling = {main="Naegling", sub="Thibron"}
    sets.Sakpata = {main="Tizona", sub="Sakpata's Sword"}
    sets.Maxentius = {main="Maxentius", sub="Thibron"}
    sets.Casting = {main="Maxentius", sub="Bunzi's Rod"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
    end
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

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
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
        wsmode = 'Acc'
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
    if player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC' then
       equip(sets.DefaultShield)
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
    if player.sub_job == 'WAR' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'RUN' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'RDM' then
        set_macro_page(3, 1)
    elseif player.sub_job == 'SCH' then
        set_macro_page(4, 1)
    else
        set_macro_page(1, 1)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
