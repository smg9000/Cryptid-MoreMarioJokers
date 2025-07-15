
return {
    descriptions = {
        Joker = {
            j_mmj_beemario = {
                name = "Bee Mario",
                text = {
                    "Retrigger all Jokers",
                    "Once for each bee joker you have",
                    "{C:inactive}(Currently #1# retriggers){}",
                    "{C:inactive}This counts as a Bee Joker"
                },
            },
            j_mmj_beeluigi = {
                name = "Bee Luigi",
                text = {
                    "All Jokers add",
                    "{C:green} X(#1#+(bee count/#2#)) {} to base {C:attention}listed{}",
					"{C:green}probabilities{}",
                    "{C:inactive}(Currently x#3# ){}",
                    "{C:inactive}This counts as a Bee Joker"
                },
            },
            j_mmj_beepeach = {
                name = "Bee Peach",
                text = {
                    "All Jokers reduce the score required of a {C:attention}Blind{} ",
                    "by {C:attention}(#2# * beecount)%{} when entering a {C:attention}Blind{} ",
					"{C:inactive}(multiplicitively){}",
                    "{C:inactive}(Currently #1#% ){}",
                    "{C:inactive}This counts as a Bee Joker"
                },
            },
            j_mmj_beerosalina = {
                name = "Bee Rosalina",
                text = {
                    "All Jokers have a{C:green} #1# in #2#{} chance",
					"to level up all {C:attention}hands (beecount * #3#){} times",
                    " rounded up at end of round",
                    "{C:inactive}(Currently #4# times ){}",
                    "{C:inactive}This counts as a Bee Joker"

                },
            },
			j_mmj_daisy = {
                name = "Daisy",
                text = {
					"{C:attention}Retrigger{} every {C:attention}4{} and {C:attention}3{}",
                    "{C:attention}#1#{} times for every ",
                    "Joker you have",
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
                    "to upgrade Edition",
                    "{C:green} #1# in #3#{} chance to reset to Base",
                    "{C:inactive}(ex: Base -> Foil -> Holographic -> Polychrome etc.){}",
                }
            },
            j_mmj_shyguy = { 
                name = "Shy Guy",
                text = {
                    "Played Numbered Cards permanently gain {X:mult,C:white}X(n*#1#){} Mult, ",
                    "where {C:attention}n{} is equal to the amount of Jokers you own",
                    
                }
            },
            j_mmj_yoshi = {
				name = "Yoshi",
				text = {
					"All Jokers gain",
					"{C:money}$#1#{} of {C:attention}sell value{} when triggered",
				},
			},
            j_mmj_donkeykong = {
                name = "Donkey Kong",
                text = {
                    "All Jokers give",
                    "{C:attention}#1#{} hand size",
                }
            },
            j_mmj_toad = {
                name = "Toad",
                text = {
                    "When entering a {C:attention}Blind Double{} half",
                    "of {C:attention}Mutatable{} Jokers until",
                    "end of round",
                }
            }
        },
        Back = {
            b_mmj_n64deck = {
                name = "N64",
                text = {
                    "Start with a random {C:attention}Mario{} Joker",
                    "at start of run",
                    
                },
            },
        },
        Spectral={
            c_mmj_beemushroom = {
                name = "Bee Mushroom",
                text = {
                    "Gives {C:attention}1{} Selected viable Mario joker the {C:attention}Bee Powerup{}"
                }
            },
        },
        Code={
            c_mmj_miyamoto = {
                name = "Miyamoto",
                text = {
                    "Destroys the selected {C:cry_candy}legendary{} Joker",
                    "and creates a random {C:attention}Mario{} Joker",
                }
            }
        },
        Other = {
            card_extra_xmult = {
                text = {
                    "{X:mult,C:white}x#1#{} extra mult"
                },
            },
        },
        Sleeve = {
            sleeve_mmj_n64sleeve = {
                name = "N64 sleeve",
                text = { "start with a random mario joker and +5 joker slots", 
                },
            },
        },
        Voucher={
            v_mmj_planet_hopp ={
                name="Planet Hopp",
                text={
                    "Allows for {C:attention}Luma{} cards ",
                    "to be found in {C:Planet}Celestial{} Packs",
                },
            },
            v_mmj_planet_bounce={
                name="Planet Bounce",
                text={
                    "When you open a {C:Planet}Celestial{} Pack",
                    "create a random {C:attention}Luma{} card",
                    "{C:inactive}Doesn't need room{}"
                },
            },
        },
        Luma = {
            c_mmj_red_luma = {
                name = 'Red Luma',
                text = {
                    "Multiplies the Mult of", 
                    "all hands by {X:red,C:white}X#1#{}"
                },
            },
            c_mmj_blue_luma = {
                name = 'Blue Luma',
                text = {
                    "Multiplies the Chips of", 
                    "all hands by {X:blue,C:white}X#1#{}"
                },
            },
            c_mmj_apricot_luma = {
                name = 'Apricot Luma',
                text = {
                    "{C:attention}Swaps{} the Chips and Mult of all hands",
                    "then Multiply them by {X:dark_edition,C:white}X#1#{}"
                },
            },


        },
		
    },
    misc = {
        labels = {
            k_mmj_mariojoker = "Super Bro's",
        },
        dictionary = {
            k_mmj_mariojoker = "Mario",
            mmj_daisy_give = "Take This Consumable",
            mmj_config_features = "Features",
            mmj_config_nostalgic_luigi = "Nostalgic Luigi",
            mmj_config_more_mario_jokers = "More Mario Jokers",
            mmj_beepeach = "-#1#% Blind Size",
            mmj_asc_luma = "Ascension Power"
        }
    },
}