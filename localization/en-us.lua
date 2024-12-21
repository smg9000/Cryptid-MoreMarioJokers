--I couldn't get Meme Packs to work without crashing
--yes somehow that was harder than RNJoker
return {
    descriptions = {
        Joker = {
			j_mmj_daisy = {
                name = "Daisy",
                text = {
					"When joker is triggerd",
                    "{C:green} #1# in #2#{} chance to gain a random",
                    "{C:attention}Consumable {}",
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
        },
		misc = {
			dictionary = {
				mmj_daisy_give = "Take This Consumable",
				mmj_config_features = "Features",
				mmj_config_nostolgic_luigi = "Nostolgic Luigi",
				mmj_config_more_mario_jokers = "More Mario Jokers",
			}
		},
    }
}
