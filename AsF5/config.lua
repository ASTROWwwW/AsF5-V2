Config = {}
if Config == nil then
    Config = {}
end
-- Clef pour ouvrir le menu
Config.MenuKey = 166 -- F5

-- Délai anti-spam en millisecondes
Config.SpamDelay = 0

-- Bannière des menus
Config.MenuBannerColor = {r = 148, g = 0, b = 211, a = 255} -- Violet

Config.Menus = {
    MainMenu = {title = "ASTRXWRLD", subtitle = "Interactions"},
    Portefeuille = {title = "Portefeuille", subtitle = "Votre argent"},
    GestionEntreprise = {title = "Gestion Entreprise", subtitle = "Gérez votre entreprise"},
    GestionOrganisation = {title = "Gestion Organisation", subtitle = "Gérez votre organisation"},
    GestionVehicule = {title = "Gestion Véhicule", subtitle = "Gérez votre véhicule"},
    ListeEmployes = {title = "Liste des employés", subtitle = "Gérer les employés"},
    ListeMembres = {title = "Liste des membres", subtitle = "Gérer les membres"},
    Divers = {title = "Divers", subtitle = "Options diverses"},
    Touches = {title = "Touches", subtitle = "Liste des touches"},
    Commandes = {title = "Commandes", subtitle = "Liste des commandes disponibles"},
    Vision = {title = "Vision", subtitle = "Types de vision"},
    Inventaire = {title = "Inventaire", subtitle = "Voir votre inventaire"},
    Actions = {title = "Actions", subtitle = "Lâcher ou donner des objets"},
    Vetements = {title = "Vêtements", subtitle = "Changer de vêtements"},
    Animations = {title = "Animations", subtitle = "Choisissez une animation"},
    Festives = {title = "Festives", subtitle = "Animations festives"},
    Salutations = {title = "Salutations", subtitle = "Animations de salutations"},
    Travail = {title = "Travail", subtitle = "Animations de travail"},
    Humeurs = {title = "Humeurs", subtitle = "Animations d'humeurs"},
    Sports = {title = "Sports", subtitle = "Animations sportives"},
    DiversAnimations = {title = "Divers", subtitle = "Animations diverses"},
    Attitudes = {title = "Attitudes", subtitle = "Animations d'attitudes"},
    Adulte = {title = "Adulte +18", subtitle = "Animations pour adultes"},
    Administration = {title = "Administration", subtitle = "Options administratives"}
}
Config.Buttons = {
    Inventory = true,
    Portefeuille = true,
    Vetements = true,
    Animations = true,
    GestionEntreprise = true,
    GestionOrganisation = true,
    GestionVehicule = true,
    Divers = true,
    
}
Config.ControlsList = {
    {label = "Interagir", control = "~INPUT_CONTEXT~"},
    {label = "Sauter", control = "~INPUT_JUMP~"},
    {label = "Sprint", control = "~INPUT_SPRINT~"},
    -- Ajoutez d'autres contrôles ici
}
Config.CommandsList = {
    {label = "/help", description = "Afficher l'aide"},
    {label = "/me", description = "Action personnelle"},
    -- Ajoutez d'autres commandes ici
}


Config.BlackScreenOnTP = {
    Enable = true, -- Activer ou désactiver l'écran noir lors du tp a un joueur
    Time = 1000 -- Temps de l'écran noir en millisecondes
}

-- Table des objets utilisables
Config.UsableItems = {
    bread = true,
    water = true
    -- Ajoutez d'autres objets utilisables ici
}



Config.Animations = {
    Festives = {
        {label = "Disco Queen", animDict = "anim@amb@nightclub@dancers@solomun_entourage@", animName = "mi_dance_facedj_17_v1_female^1", AnimationOptions = {EmoteLoop = true}},
        {label = "Salsa Groove", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", animName = "high_center", AnimationOptions = {EmoteLoop = true}},
        {label = "Hip Hop Vibe", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", animName = "high_center_up", AnimationOptions = {EmoteLoop = true}},
        {label = "Funky Moves", animDict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", animName = "hi_dance_facedj_09_v2_female^1", AnimationOptions = {EmoteLoop = true}},
        {label = "Electric Slide", animDict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", animName = "hi_dance_facedj_09_v2_female^3", AnimationOptions = {EmoteLoop = true}},
        {label = "Twist and Turn", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", animName = "high_center_up", AnimationOptions = {EmoteLoop = true}},
        {label = "Latin Heat", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", animName = "low_center", AnimationOptions = {EmoteLoop = true}},
        {label = "Slow Salsa", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", animName = "low_center_down", AnimationOptions = {EmoteLoop = true}},
        {label = "Chill Vibes", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", animName = "low_center", AnimationOptions = {EmoteLoop = true}},
        {label = "DJ Groove", animDict = "anim@amb@nightclub@dancers@podium_dancers@", animName = "hi_dance_facedj_17_v2_male^5", AnimationOptions = {EmoteLoop = true}},
        {label = "Funk Out", animDict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", animName = "high_center_down", AnimationOptions = {EmoteLoop = true}},
        {label = "Breakdance Burst", animDict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", animName = "high_center", AnimationOptions = {EmoteLoop = true}},
        {label = "Groove Machine", animDict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", animName = "high_center_up", AnimationOptions = {EmoteLoop = true}},
        {label = "Swing and Sway", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", animName = "high_center", AnimationOptions = {EmoteLoop = true, EmoteMoving = true}},
        {label = "Rhythmic Flow", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", animName = "high_center_up", AnimationOptions = {EmoteLoop = true, EmoteMoving = true}},
        {label = "Shy Shuffle", animDict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", animName = "low_center", AnimationOptions = {EmoteLoop = true}},
        {label = "Calm Sway", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", animName = "low_center_down", AnimationOptions = {EmoteLoop = true}},
        {label = "Slow Jam", animDict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", animName = "low_center", AnimationOptions = {EmoteLoop = true}},
        {label = "Silly Shuffle", animDict = "rcmnigel1bnmt_1b", animName = "dance_loop_tyler", AnimationOptions = {EmoteLoop = true}},
        {label = "Tao Dance", animDict = "misschinese2_crystalmazemcs1_cs", animName = "dance_loop_tao", AnimationOptions = {EmoteLoop = true}},
        {label = "IG Dance", animDict = "misschinese2_crystalmazemcs1_ig", animName = "dance_loop_tao", AnimationOptions = {EmoteLoop = true}},
        {label = "FBI Shuffle", animDict = "missfbi3_sniping", animName = "dance_m_default", AnimationOptions = {EmoteLoop = true}},
        {label = "Mountain Twist", animDict = "special_ped@mountain_dancer@monologue_3@monologue_3a", animName = "mnt_dnc_buttwag", AnimationOptions = {EmoteLoop = true}},
        {label = "Clown Fidget", animDict = "move_clown@p_m_zero_idles@", animName = "fidget_short_dance", AnimationOptions = {EmoteLoop = true}},
        {label = "Double Clown", animDict = "move_clown@p_m_two_idles@", animName = "fidget_short_dance", AnimationOptions = {EmoteLoop = true}},
        {label = "Butt Wiggle", animDict = "anim@amb@nightclub@lazlow@hi_podium@", animName = "danceidle_hi_11_buttwiggle_b_laz", AnimationOptions = {EmoteLoop = true}},
        {label = "Tracy Shuffle", animDict = "timetable@tracy@ig_5@idle_a", animName = "idle_a", AnimationOptions = {EmoteLoop = true}},
        {label = "Idle Grooves", animDict = "timetable@tracy@ig_8@idle_b", animName = "idle_d", AnimationOptions = {EmoteLoop = true}},
        {label = "Club Vibe", animDict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", animName = "med_center_up", AnimationOptions = {EmoteLoop = true}},
        {label = "Woogie Dance", animDict = "anim@mp_player_intcelebrationfemale@the_woogie", animName = "the_woogie", AnimationOptions = {EmoteLoop = true}},
        {label = "Casino Groove", animDict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@", animName = "high_center", AnimationOptions = {EmoteLoop = true}},
        {label = "Glowing Lights", animDict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@", animName = "med_center", AnimationOptions = {EmoteLoop = true}},
        {label = "Glowstick Party", animDict = "anim@amb@nightclub@lazlow@hi_railing@", animName = "ambclub_13_mi_hi_sexualgriding_laz", AnimationOptions = {Prop = 'ba_prop_battle_glowstick_01', PropBone = 28422, PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0}, SecondProp = 'ba_prop_battle_glowstick_01', SecondPropBone = 60309, SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0}, EmoteLoop = true, EmoteMoving = true}},
        {label = "Booty Shake", animDict = "anim@amb@nightclub@lazlow@hi_railing@", animName = "ambclub_12_mi_hi_bootyshake_laz", AnimationOptions = {Prop = 'ba_prop_battle_glowstick_01', PropBone = 28422, PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0}, SecondProp = 'ba_prop_battle_glowstick_01', SecondPropBone = 60309, SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0}, EmoteLoop = true}},
        {label = "Belly Dancer", animDict = "anim@amb@nightclub@lazlow@hi_railing@", animName = "ambclub_09_mi_hi_bellydancer_laz", AnimationOptions = {Prop = 'ba_prop_battle_glowstick_01', PropBone = 28422, PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0}, SecondProp = 'ba_prop_battle_glowstick_01', SecondPropBone = 60309, SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0}, EmoteLoop = true}},
    },
    Salutations = {
        {label = "Relaxé", animDict = "anim@heists@heist_corona@team_idles@male_a", animName = "idle"},
        {label = "Détendu 8", animDict = "amb@world_human_hang_out_street@male_b@idle_a", animName = "idle_b"},
        {label = "Décontracté", animDict = "friends@fra@ig_1", animName = "base_idle"},
        {label = "Se tenir tranquille", animDict = "mp_move@prostitute@m@french", animName = "idle"},
        {label = "Reposant", animDict = "random@countrysiderobbery", animName = "idle_a"},
        {label = "Calme", animDict = "anim@heists@heist_corona@team_idles@female_a", animName = "idle"},
        {label = "Célébration tranquille", animDict = "anim@heists@humane_labs@finale@strip_club", animName = "ped_b_celebrate_loop"},
        {label = "Fête tranquille", animDict = "anim@mp_celebration@idles@female", animName = "celebration_idle_f_a"},
        {label = "Attente 5", animDict = "anim@mp_corona_idles@female_b@idle_a", animName = "idle_a"},
        {label = "Attente 6", animDict = "anim@mp_corona_idles@male_c@idle_a", animName = "idle_a"},
        {label = "Attente 7", animDict = "anim@mp_corona_idles@male_d@idle_a", animName = "idle_a"},
        {label = "En attendant", animDict = "amb@world_human_hang_out_street@female_hold_arm@idle_a", animName = "idle_a"},
        {label = "Ivresse légère", animDict = "random@drunk_driver_1", animName = "drunk_driver_stand_loop_dd1"},
        {label = "Ivresse légère 2", animDict = "random@drunk_driver_1", animName = "drunk_driver_stand_loop_dd2"},
        {label = "Ivresse totale", animDict = "missarmenian2", animName = "standing_idle_loop_drunk"},
        {label = "Guitare aérienne", animDict = "anim@mp_player_intcelebrationfemale@air_guitar", animName = "air_guitar"},
        {label = "Synthétiseur aérien", animDict = "anim@mp_player_intcelebrationfemale@air_synth", animName = "air_synth"},
        {label = "Dispute", animDict = "misscarsteal4@actor", animName = "actor_berating_loop"},
        {label = "Dispute 2", animDict = "oddjobs@assassinate@vice@hooker", animName = "argue_a"},
        {label = "Barman", animDict = "anim@amb@clubhouse@bar@drink@idle_a", animName = "idle_a_bartender"},
        {label = "Baiser", animDict = "anim@mp_player_intcelebrationfemale@blow_kiss", animName = "blow_kiss"},
        {label = "Baiser 2", animDict = "anim@mp_player_intselfieblow_kiss", animName = "exit"},
        {label = "Révérence", animDict = "anim@mp_player_intcelebrationpaired@f_f_sarcastic", animName = "sarcastic_left"},
        {label = "Défi", animDict = "misscommon@response", animName = "bring_it_on"},
        {label = "Viens te battre", animDict = "mini@triathlon", animName = "want_some_of_this"},
        {label = "Policier 2", animDict = "anim@amb@nightclub@peds@", animName = "rcmme_amanda1_stand_loop_cop"},
        {label = "Policier 3", animDict = "amb@code_human_police_investigate@idle_a", animName = "idle_b"},
        {label = "Bras croisés", animDict = "amb@world_human_hang_out_street@female_arms_crossed@idle_a", animName = "idle_a"},
        {label = "Bras croisés 2", animDict = "amb@world_human_hang_out_street@male_c@idle_a", animName = "idle_b"},
        {label = "Bras croisés 3", animDict = "anim@heists@heist_corona@single_team", animName = "single_team_loop_boss"},
        {label = "Bras croisés 4", animDict = "random@street_race", animName = "_car_b_lookout"},
        {label = "Bras croisés 5", animDict = "anim@amb@nightclub@peds@", animName = "rcmme_amanda1_stand_loop_cop"},
        {label = "Bras croisés 6", animDict = "random@shop_gunstore", animName = "_idle"},
        {label = "Bras croisés (Affaires)", animDict = "anim@amb@business@bgen@bgen_no_work@", animName = "stand_phone_phoneputdown_idle_nowork"},
        {label = "Bras croisés sur le côté", animDict = "rcmnigel1a_band_groupies", animName = "base_m2"},
        {label = "Attente 4", animDict = "amb@world_human_hang_out_street@Female_arm_side@idle_a", animName = "idle_a"},
        {label = "Attente 5", animDict = "missclothing", animName = "idle_storeclerk"},
        {label = "Attente 6", animDict = "timetable@amanda@ig_2", animName = "ig_2_base_amanda"},
        {label = "Attente 7", animDict = "rcmnigel1cnmt_1c", animName = "base"},
        {label = "Attente 8", animDict = "rcmjosh1", animName = "idle"},
        {label = "Attente 9", animDict = "rcmjosh2", animName = "josh_2_intp1_base"},
        {label = "Attente 10", animDict = "timetable@amanda@ig_3", animName = "ig_3_base_tracy"},
        {label = "Attente 11", animDict = "misshair_shop@hair_dressers", animName = "keeper_base"},
        {label = "Reposant 2", animDict = "amb@world_human_leaning@female@wall@back@hand_up@idle_a", animName = "idle_a"},
        {label = "Reposant 3", animDict = "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", animName = "idle_a"},
        {label = "Reposant 4", animDict = "amb@world_human_leaning@male@wall@back@foot_up@idle_a", animName = "idle_a"},
        {label = "Reposant 5", animDict = "amb@world_human_leaning@male@wall@back@hands_together@idle_b", animName = "idle_b"},
        {label = "Flirt en Lean", animDict = "random@street_race", animName = "_car_a_flirt_girl"},
        {label = "Lean Bar 2", animDict = "amb@prop_human_bum_shopping_cart@male@idle_a", animName = "idle_c"},
        {label = "Lean Bar 3", animDict = "anim@amb@nightclub@lazlow@ig1_vip@", animName = "clubvip_base_laz"},
        {label = "Lean Bar 4", animDict = "anim@heists@prison_heist", animName = "ped_b_loop_a"},
        {label = "Lean Haut", animDict = "anim@mp_ferris_wheel", animName = "idle_a_player_one"},
        {label = "Lean Haut 2", animDict = "anim@mp_ferris_wheel", animName = "idle_a_player_two"},
        {label = "Lean sur le côté", animDict = "timetable@mime@01_gc", animName = "idle_a"},
        {label = "Lean sur le côté 2", animDict = "misscarstealfinale", animName = "packer_idle_1_trevor"},
        {label = "Lean sur le côté 3", animDict = "misscarstealfinalecar_5_ig_1", animName = "waitloop_lamar"},
        {label = "Lean sur le côté 4", animDict = "misscarstealfinalecar_5_ig_1", animName = "waitloop_lamar"},
        {label = "Lean sur le côté 5", animDict = "rcmjosh2", animName = "josh_2_intp1_base"},
        {label = "Moi", animDict = "gestures@f@standing@casual", animName = "gesture_me_hard"},
    }
    
    ,
    Travail = {
        {label = "Travailler sur un ordinateur", animDict = "anim@amb@office@boss@male@", animName = "computer_working_idle_b"},
        {label = "Marteler", animDict = "amb@world_human_hammering@male@base", animName = "base"},
        {label = "Réparer un véhicule", animDict = "amb@world_human_welding@male@base", animName = "base"},
        {label = "Écrire sur un clavier", animDict = "anim@amb@office@computer@male@", animName = "typing_idle"},
        {label = "Prendre des appels", animDict = "anim@amb@office@phone@male@", animName = "phone_idle"},
    },
    Humeurs = {
        {label = "Fâché", animDict = "Expression", animName = "mood_angry_1"},
        {label = "Ivre", animDict = "Expression", animName = "mood_drunk_1"},
        {label = "Stupide", animDict = "Expression", animName = "pose_injured_1"},
        {label = "Électrocuté", animDict = "Expression", animName = "electrocuted_1"},
        {label = "Grincheux", animDict = "Expression", animName = "effort_1"},
        {label = "Grincheux 2", animDict = "Expression", animName = "mood_drivefast_1"},
        {label = "Grincheux 3", animDict = "Expression", animName = "pose_angry_1"},
        {label = "Heureux", animDict = "Expression", animName = "mood_happy_1"},
        {label = "Blessé", animDict = "Expression", animName = "mood_injured_1"},
        {label = "Joyeux", animDict = "Expression", animName = "mood_dancing_low_1"},
        {label = "Respirer par la Bouche", animDict = "Expression", animName = "smoking_hold_1"},
        {label = "Ne Cligner Jamais des Yeux", animDict = "Expression", animName = "pose_normal_1"},
        {label = "Un Œil", animDict = "Expression", animName = "pose_aiming_1"},
        {label = "Choqué", animDict = "Expression", animName = "shocked_1"},
        {label = "Choqué 2", animDict = "Expression", animName = "shocked_2"},
        {label = "Dormir", animDict = "Expression", animName = "mood_sleeping_1"},
        {label = "Dormir 2", animDict = "Expression", animName = "dead_1"},
        {label = "Dormir 3", animDict = "Expression", animName = "dead_2"},
        {label = "Sournois", animDict = "Expression", animName = "mood_smug_1"},
        {label = "Spéculatif", animDict = "Expression", animName = "mood_aiming_1"},
        {label = "Stressé", animDict = "Expression", animName = "mood_stressed_1"},
        {label = "Mauvaise Humeur", animDict = "Expression", animName = "mood_sulk_1"},
        {label = "Étrange", animDict = "Expression", animName = "effort_2"},
        {label = "Étrange 2", animDict = "Expression", animName = "effort_3"},
    },
    Sports = {
        {label = "Faire des Pompes", animDict = "amb@world_human_push_ups@male@base", animName = "base"},
        {label = "Faire des Abdos", animDict = "amb@world_human_sit_ups@male@base", animName = "base"},
        {label = "Courir", animDict = "move_m@hn@jog@", animName = "jog"},
        {label = "Faire du Yoga", animDict = "amb@world_human_yoga@female@base", animName = "base"},
        {label = "S'étirer", animDict = "amb@world_human_stretch@male@base", animName = "base"},
    },
    Divers = {
        {label = "S'asseoir", animDict = "anim@heists@heist_safehouse_intro@phone_couch@", animName = "phone_couch_sit_idle"},
        {label = "Dormir", animDict = "timetable@tracy@sleep@", animName = "idle_c"},
        {label = "Manger un sandwich", animDict = "mp_player_inteat@burger", animName = "idle_a"},
        {label = "Boire de l'eau", animDict = "amb@world_human_drinking@male@idle_a", animName = "idle_a"},
        {label = "Lire un journal", animDict = "amb@world_human_standing_mobile@male@idle_a", animName = "idle_a"},
    },
    Attitudes = {
        {label = "Poser les mains sur les hanches", animDict = "anim@mp_player_intcelebrationmale@hands_on_hips", animName = "hands_on_hips"},
        {label = "S'appuyer contre un mur", animDict = "amb@world_human_leaning@male@wall@back@foot_up@idle_a", animName = "idle_a"},
    },
    Adulte = {
        {label = "Fumer une cigarette", animDict = "amb@world_human_smoking@male@male_a@base", animName = "base"},
        {label = "Boire une bière", animDict = "amb@world_human_drinking@beer@male@base", animName = "base"},
    }
}
