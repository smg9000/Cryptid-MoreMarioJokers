
return {
    descriptions = {
        Joker = {
			j_mmj_daisy = {
                name = "Daisy",
                text = {
					"When hand is played",
                    "{C:green} #1# in #2#{} chance for every Joker ",
                    "to create a random {C:attention}Consumable{}",
					"{C:inactive}Doesn't need room{}",
                },
            },
			j_mmj_luigi = {
                name = "Luigi",
                text = {
                    "All Jokers add",
                    "{C:green} X#1# {} to base {C:attention}listed{}",
					"{C:green}probabilities{}",
                },
            },
            j_mmj_nluigi = {
                name = "Luigi",
                text = {
                    "All Jokers give",
                    "{X:chips,C:white} X#1# {} Chips",
					"{C:inactive}getting a refactor!!{} ",
                },
            },
			j_mmj_mario = {
                name = "Mario",
                text = {
                    "Retrigger all Jokers",
                    "{C:attention}#1#{} additional time(s)",
                },
            },
			j_mmj_peach = {
                name = "Peach",
                text = {
                    "All Jokers reduce the score required of a {C:attention}Blind{} ",
                    "by {C:attention}5%{} when entering a {C:attention}Blind{} ",
					"{C:inactive}(multiplicitively){}",
                },
            },
			j_mmj_rosalina = {
                name = "Rosalina",
                text = {
                    "All Jokers have a{C:green} #1# in #2#{} chance",
					"to level up all {C:attention}hands{} at end of round",
                },
            },
            j_mmj_lakitu = {
                name = "Lakitu",
                text = {
                    "This Joker gains {C:dark_edition}+#1#{} Joker",
                    "Slots per Joker at end of round",
                    "{C:inactive}(Currently {C:dark_edition}+#2# {C:inactive}Joker #3#)"
                }
            },
            j_mmj_king_boo = { 
                name = "King Boo",
                text = {
                    "When Jokers are triggered{C:green} #1# in #2# {}chance",
                    "to upgrade {C:attention}Edition{}",
                    "{C:green} #1# in #3#{} chance to reset to {C:attention}Base{}",
                    "{C:inactive}(ex: Base -> Foil -> Holographic -> Polychrome etc.){}",
                }
            },
            j_mmj_shyguy = { 
                name = "Shy Guy",
                text = {
                    "{C:attention}Numbered Cards{} permanently gain {X:mult,C:white}X(n/#1#){} Mult when scored,",
                    "where {C:attention}n{} is equal to the amount of Jokers you own",
                    
                }
            },
        },
        Other = {
            card_extra_xmult = {
                text = {
                    "{X:mult,C:white}x#1#{} extra mult"
                }
            },
        },
		misc = {
			dictionary = {
				mmj_daisy_give = "Take This Consumable",
				mmj_config_features = "Features",
				mmj_config_nostalgic_luigi = "Nostalgic Luigi",
				mmj_config_more_mario_jokers = "More Mario Jokers",
			}
		},
    }
}
