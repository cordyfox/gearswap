-------------------------------------------------------------------------------------------------------------------
-- Modify the sets table.  Any gear sets that are added to the sets table need to
-- be defined within this function, because sets isn't available until after the
-- include is complete.  It is called at the end of basic initialization in Mote-Include.
-------------------------------------------------------------------------------------------------------------------

function define_global_sets()

    -- Augmented Weapons
    gear.Colada_ENH = {name="Colada", augments={'Enh. Mag. eff. dur. +3','MND+3','Mag. Acc.+16','"Mag.Atk.Bns."+2','DMG:+4',}}

    -- Acro

    -- Chironic

    -- Herculean

    gear.Herc_Refresh_head = {name="Herculean Helm", augments={'DEX+8','STR+8','"Refresh"+2',}}

    gear.Herc_WSD_head = {name="Herculean Helm", augments={'Accuracy+23','Pet: DEX+7','Weapon skill damage +6%','Accuracy+16 Attack+16','Mag. Acc.+12 "Mag.Atk.Bns."+12',}}
    gear.Herc_WSD_body = {name="Herculean Vest", augments={'Accuracy+24','Mag. Acc.+25','Weapon skill damage +6%',}}
    gear.Herc_WSD_feet = {name="Herculean Boots", augments={'VIT+6','"Mag.Atk.Bns."+15','Weapon skill damage +8%','Accuracy+7 Attack+7','Mag. Acc.+12 "Mag.Atk.Bns."+12',}}

    gear.Herc_FC_head = {name="Herculean Helm", augments={'Pet: Mag. Acc.+25 Pet: "Mag.Atk.Bns."+25','VIT+7','"Fast Cast"+7',}}
    gear.Herc_FC_feet = {name="Herculean Boots", augments={'Attack+19','"Fast Cast"+6','STR+2','"Mag.Atk.Bns."+6',}}

    gear.Herc_Waltz_hands = {name="Herculean Gloves", augments={'Attack+22','"Waltz" potency +8%','DEX+3',}}
    gear.Herc_Waltz_legs = {name="Herculean Trousers", augments={'"Waltz" potency +10%','VIT+15','Accuracy+1','Attack+10',}}

    gear.Herc_TA_feet = {name="Herculean Boots", augments={'"Triple Atk."+4','DEX+7','Accuracy+4','Attack+7',}}

    -- Merlinic

    -- Taeon

    gear.Taeon_Phalanx_head = {name="Taeon Chapeau", augments={'Enmity-2','Phalanx +3',}}
    gear.Taeon_Phalanx_body = {name="Taeon Tabard", augments={'Mag. Evasion+19','"Fast Cast"+5','Phalanx +3',}}
    gear.Taeon_Phalanx_hands = {name="Taeon Gloves", augments={'"Conserve MP"+5','Phalanx +3',}}
    gear.Taeon_Phalanx_legs = {name="Taeon Tights", augments={'"Conserve MP"+5','Phalanx +3',}}
    gear.Taeon_Phalanx_feet = {name="Taeon Boots", augments={'"Conserve MP"+5','Phalanx +3',}}

    -- Telchine

    gear.Telchine_ENH_head = {name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}}
    gear.Telchine_ENH_body = {name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}}
    gear.Telchine_ENH_hands = {name="Telchine Gloves", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}}
    gear.Telchine_ENH_legs = {name="Telchine Braconi", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}}
    gear.Telchine_ENH_feet = {name="Telchine Pigaches", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}}

    gear.Telchine_Regen_head = {name="Telchine Cap", augments={'Spell interruption rate down -10%','"Regen" potency+3',}}
    gear.Telchine_Regen_body = {name="Telchine Chas.", augments={'Spell interruption rate down -6%','"Regen" potency+3',}}
    gear.Telchine_Regen_hands = {name="Telchine Gloves", augments={'Spell interruption rate down -1%','"Regen" potency+2',}}
    gear.Telchine_Regen_legs = {name="Telchine Braconi", augments={'"Cure" potency +1%','"Regen" potency+3',}}
    gear.Telchine_Regen_feet = {name="Telchine Pigaches", augments={'"Fast Cast"+3','"Regen" potency+2',}}

    -- Valorous

    gear.Valor_TH_Hands = {name="Valorous Mitts", augments={'AGI+15','CHR+4','"Treasure Hunter"+2',}}

    -- JSE Capes

    gear.BLU_TP_Cape = {name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Damage taken-5%',}}
    gear.BLU_WSD_Cape = {name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    gear.BLU_Cure_Cape = {name="Rosmerta's Cape", augments={'MND+20','MND+10','"Cure" potency +10%',}}
    gear.BLU_MAB_Cape = {name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}

    --gear.RDM_DW_Cape = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+5','"Dual Wield"+10','Damage taken-5%',}}
    gear.RDM_TP_Cape = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+5','"Dual Wield"+10','Damage taken-5%',}}
    gear.RDM_INT_Cape = {name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20',}}

    gear.DNC_TP_Cape = {name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Magic dmg. taken-10%',}}
    gear.DNC_STR_Cape = {name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+5','"Dbl.Atk."+10',}}
    gear.DNC_Waltz_Cape = {name="Senuna's Mantle", augments={'CHR+20','CHR+10','"Waltz" potency +10%',}}
    gear.DNC_FC_Cape = {name="Senuna's Mantle", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+10','"Fast Cast"+10',}}

    gear.WAR_FC_cape = {name="Cichol's Mantle", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}
    gear.WAR_TP_Cape = {name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+9','"Dbl.Atk."+10','Mag. Evasion+15',}}
    gear.WAR_WSD_Cape = {name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}

    gear.RUN_Tank_Cape = {name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}}
    gear.RUN_WSD_Cape = {name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}

    gear.COR_WSD_Cape = {name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}}

    gear.THF_TP_Cape = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Crit.hit rate+10','Evasion+15',}}
    gear.THF_WSD_Cape = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}

end

laggy_zones = S{'Al Zahbi', 'Aht Urhgan Whitegate', 'Eastern Adoulin', 'Mhaura', 'Nashmau', 'Selbina', 'Western Adoulin'}

windower.register_event('zone change',
    function()
    -- Caps FPS to 30 via Config addon in certain problem zones
        --[[if laggy_zones:contains(world.zone) then
            send_command('config FrameRateDivisor 2')
        else
            send_command('config FrameRateDivisor 1')
        end]]--

        -- Auto load Omen add-on
        if world.zone == 'Reisenjima Henge' then
            send_command('lua l omen')
        end
    end
)