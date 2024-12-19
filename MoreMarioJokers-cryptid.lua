--- STEAMODDED HEADER
--- MOD_NAME: Cry-MoreMarioJokers
--- MOD_ID: CryptidMoreMarioJokers
--- PREFIX: mmj
--- MOD_AUTHOR: [SMG9000, Denverplays2 ]
--- MOD_DESCRIPTION: a mod that adds more Mario jokers to cryptid
--- BADGE_COLOUR: 708b91
--- DEPENDENCIES: [Talisman, Cryptid]
--- VERSION: 0.0.0

----------------------------------------------
------------MOD CODE -------------------------







SMODS.Joker {
	name = "mmj-nluigi",
	key = "nluigi",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	config = { extra = { x_chips = 3 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.x_chips } }
	end,
	rarity = 4,
	cost = 20,
	order = 86,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.other_joker and context.other_joker.ability.set == "Joker" then
			if not Talisman.config_file.disable_anims then
				G.E_MANAGER:add_event(Event({
					func = function()
						context.other_joker:juice_up(0.5, 0.5)
						return true
					end,
				}))
			end
			return {
				message = localize({ type = "variable", key = "a_xchips", vars = { card.ability.extra.x_chips } }),
				colour = G.C.CHIPS,
				Xchip_mod = card.ability.extra.x_chips,
			}
		end
	end,
	atlas = "marioatlas",
	cry_credits = {
		idea = {
			"Auto Watto"
		},
		art = {
			"Linus Goof Balls"
		},
		code = {
			"Auto Watto"
		}
	},
}
SMODS.Joker {
	name = "mmj-mario",
	key = "mario",
	config = { extra = { retriggers = 2 } },
	pos = { x = 0, y = 2 },
	soul_pos = { x = 1, y = 2 },
	rarity = 4,
	order = 85,
	cost = 20,
	blueprint_compat = true,
	immutable = true,
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.retriggers } }
	end,
	atlas = "marioatlas",
	calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
			return {
				message = localize("k_again_ex"),
				repetitions = card.ability.extra.retriggers,
				card = card,
			}
		end
	end,
	cry_credits = {
		idea = {
			"Auto Watto"
		},
		art = {
			"Linus Goof Balls"
		},
		code = {
			"Auto Watto"
		}
	},
}
SMODS.Atlas({
	key = "marioatlas",
	atlas_table = "ASSET_ATLAS",
	path = "marioatlas.png",
	px = 71,
	py = 95
})
