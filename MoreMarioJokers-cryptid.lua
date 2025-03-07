
local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
mmj_config = SMODS.current_mod.config
local folder = string.match(mod_path, "[Mm]ods.*")

if mmj_config["Nostalgic_luigi"] == nil then
  mmj_config["Nostalgic_luigi"] = true
end
if mmj_config["More_mario_jokers"] == nil then
  mmj_config["More_mario_jokers"] = true
end


if mmj_config["Nostalgic_luigi"] then
	SMODS.Joker {
		name = "mmj-nluigi",
		key = "nluigi",
		pos = { x = 0, y = 0 },
		soul_pos = { x = 1, y = 0 },
		config = { extra = { x_chips = 2.5 } },
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
else
SMODS.Joker {
		name = "mmj-luigi",
		key = "luigi",
		pos = { x = 0, y = 0 },
		soul_pos = { x = 1, y = 0 },
		config = { extra = { odd_change = 1.5, last_odd_change = 1} },
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.odd_change, center.ability.extra.odd_change_var } }
		end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = false,
		remove_from_deck = function(self, card, from_debuff)
					for k, v in pairs(G.GAME.probabilities) do 
						G.GAME.probabilities[k] = v/card.ability.extra.last_odd_change
					end
					card.ability.extra.last_odd_change = 1
		end,
		update = function(self, card, dt)
			if G.jokers and card.added_to_deck then 
				local change = math.pow(card.ability.extra.odd_change, #G.jokers.cards)
				if change ~= card.ability.extra.last_odd_change then
					for k, v in pairs(G.GAME.probabilities) do 
						v = v/card.ability.extra.last_odd_change
						G.GAME.probabilities[k] = v*change
						if G.GAME.probabilities[k] == math.huge then
						G.GAME.probabilities[k] = 1e300
						end
					end
				card.ability.extra.last_odd_change = change
				end
			end
		end,
		atlas = "marioatlas",
		cry_credits = {
			idea = {
				"Denverplays2"
			},
			art = {
				"Linus Goof Balls"
			},
			code = {
				"SMG9000",
				"WilsontheWolf"
			}
		},
	}
	
end




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
if mmj_config["More_mario_jokers"] or true then 
	SMODS.Joker {
		name = "mmj-Peach",
		key = "peach",
		pos = { x = 0, y = 1 },
		soul_pos = { x = 1, y = 1 },
		config = { extra = {  } },
		loc_vars = function(self, info_queue, center)
			return { vars = { } }
		end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
		calculate = function(self, card, context)
			if context.setting_blind then
				for i = 1, #G.jokers.cards do
					if not Talisman.config_file.disable_anims then
						G.E_MANAGER:add_event(Event({
							func = function()
								card_eval_status_text(G.jokers.cards[i], 'extra', nil, nil, nil, {message = "-5% Blind Size", colour = G.C.DARK_EDITION});
								return true
							end,
						}))
					end
					G.GAME.blind.chips = (to_big(G.GAME.blind.chips) * to_big(0.95))
				end
				return nil, true
			end
		end,
		atlas = "marioatlas",
		cry_credits = {
			idea = {
				"Denverplays2"
			},
			art = {
				"SMG9000"
			},
			code = {
				"SMG9000"
			}
		},
	}
	SMODS.Joker {
		name = "mmj-Daisy",
		key = "daisy",
		pos = { x = 0, y = 3 },
		soul_pos = { x = 1, y = 3 },
		config = { extra = { odds = 5 } },
		loc_vars = function(self, info_queue, center)
			return { vars = {"" .. (G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds} }
		end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
		calculate = function(self, card, context)
			if context.before and not context.individual then 
				for i = 1, #G.jokers.cards do
					if pseudorandom("mmj-Daisy") < G.GAME.probabilities.normal/card.ability.extra.odds then
						G.E_MANAGER:add_event(Event({
							delay = 0.4,
							func = function()
                            local _card = create_card('Consumeables',G.consumeables, nil, nil, nil, nil, nil, 'daisy')
							_card:add_to_deck()
							G.consumeables:emplace(_card)
							card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Here Take This", instant = true})
                        return true end,
						
						}))
						--card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Here Take This" })
					else
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.4,
						func = function() --"borrowed" from Wheel Of Fortune
							attention_text({
								text = localize("k_nope_ex"),
								scale = 1.3,
								hold = 1.4,
								major = G.jokers.cards[i],
								backdrop_colour = G.C.PURPLE,
								align = (
									G.STATE == G.STATES.TAROT_PACK
									or G.STATE == G.STATES.SPECTRAL_PACK
									or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
								)
										and "tm"
									or "cm",
								offset = {
									x = 0,
									y = (
										G.STATE == G.STATES.TAROT_PACK
										or G.STATE == G.STATES.SPECTRAL_PACK
										or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
									)
											and -0.2
										or 0,
								},
								silent = true,
							})
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 0.06 * G.SETTINGS.GAMESPEED,
								blockable = false,
								blocking = false,
								func = function()
									play_sound("tarot2", 0.76, 0.4)
									return true
								end,
							}))
							play_sound("tarot2", 1, 0.4)
							G.jokers.cards[i]:juice_up(0.3, 0.5)
							return true
						end,
					}))
					end
				end
				return nil, true
			end

		end,
		atlas = "marioatlas",
		cry_credits = {
			idea = {
				"Denverplays2"
			},
			art = {
				"SMG9000"
			},
			code = {
				"SMG9000"
			}
		},
	}
	SMODS.Joker {
		name = "mmj-rosalina",
		key = "rosalina",
		pos = { x = 2, y = 3 },
		soul_pos = { x = 3, y = 3 },
		config = { extra = { odds = 8 } },
		loc_vars = function(self, info_queue, center)
		return { vars = { "" .. (G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds } }
		end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
		calculate = function(self, card, context)
			if context.end_of_round and not context.individual and not context.repetition then
				for i = 1, #G.jokers.cards do
				if pseudorandom("rosalina") < G.GAME.probabilities.normal / card.ability.extra.odds then --Code "borrowed" from black hole
					update_hand_text(
						{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
						{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
					)
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.2,
						func = function()
							play_sound("tarot1")
							G.jokers.cards[i]:juice_up(0.8, 0.5)
							G.TAROT_INTERRUPT_PULSE = true
							return true
						end,
					}))
					update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.9,
						func = function()
							play_sound("tarot1")
							G.jokers.cards[i]:juice_up(0.8, 0.5)
							return true
						end,
					}))
					update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.9,
						func = function()
							play_sound("tarot1")
							G.jokers.cards[i]:juice_up(0.8, 0.5)
							G.TAROT_INTERRUPT_PULSE = nil
							return true
						end,
					}))
					update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "+1" })
					delay(1.3)
					for k, v in pairs(G.GAME.hands) do
						level_up_hand(G.jokers.cards[i], k, true, to_big(1))
					end
					update_hand_text(
						{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
						{ mult = 0, chips = 0, handname = "", level = "" }
					)
				else
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.4,
						func = function() --"borrowed" from Wheel Of Fortune
							attention_text({
								text = localize("k_nope_ex"),
								scale = 1.3,
								hold = 1.4,
								major = G.jokers.cards[i],
								backdrop_colour = G.C.SECONDARY_SET.Planet,
								align = (
									G.STATE == G.STATES.TAROT_PACK
									or G.STATE == G.STATES.SPECTRAL_PACK
									or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
								)
										and "tm"
									or "cm",
								offset = {
									x = 0,
									y = (
										G.STATE == G.STATES.TAROT_PACK
										or G.STATE == G.STATES.SPECTRAL_PACK
										or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
									)
											and -0.2
										or 0,
								},
								silent = true,
							})
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 0.06 * G.SETTINGS.GAMESPEED,
								blockable = false,
								blocking = false,
								func = function()
									play_sound("tarot2", 0.76, 0.4)
									return true
								end,
							}))
							play_sound("tarot2", 1, 0.4)
							G.jokers.cards[i]:juice_up(0.3, 0.5)
							return true
						end,
					}))
				end
				end
				return nil, true
			end
		end,
		atlas = "marioatlas",
		cry_credits = {
			idea = {
				"Denverplays2"
			},
			art = {
				"GeorgeTheRat"
			},
			code = {
				"SMG9000"
			}
		},
	}
	SMODS.Joker {
		name = "mmj-KingBoo",
		key = "king_boo",
		pos = { x = 2, y = 4 },
		soul_pos = { x = 3, y = 4	 },
		config = { extra = { odds1 = 10, odds2 = 100,  } },
		loc_vars = function(self, info_queue, center)
			return { vars = {"" .. (G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds1, center.ability.extra.odds2} }
		end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
		calculate = function(self, card, context)
			if context.post_trigger then 
				local _card = context.other_card
				local chance1 
				local chance2 
				local chance3 
				local chance4 
				if pseudorandom("mmj-KingBoo") < G.GAME.probabilities.normal/card.ability.extra.odds1 then
					chance1 = true
				else 
					chance1 = false
					chance3 = true
				end
				if pseudorandom("mmj-KingBoo") < G.GAME.probabilities.normal/card.ability.extra.odds2 then
					chance2 = true
				else 
					chance2 = false
					chance4= true
				end
				if chance1 == true or chance2 == true then
					if chance1 == true then
						G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.75,
						func = function() --"borrowed" from Wheel Of Fortune
							local found_index = 1
							if _card.edition then 	
								for i, v in ipairs(G.P_CENTER_POOLS.Edition) do
									if v.key == _card.edition.key then
										found_index = i
										break
									end
								end
							end
							found_index = found_index + 1
							if found_index > #G.P_CENTER_POOLS.Edition then
								found_index = found_index - #G.P_CENTER_POOLS.Edition
							end
							
							local edition_apply = G.P_CENTER_POOLS.Edition[found_index].key
							_card:set_edition((edition_apply or "e_foil"), true)
							
							return true
						end,
					}))
					card_eval_status_text(_card, 'extra', nil, nil, nil, { message = "Upgrade!"})
					end
					if chance2 == true then
						G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.75,
						func = function()
							_card:set_edition("e_base", true)
							
							return true
						end,
					}))
					card_eval_status_text(_card, 'extra', nil, nil, nil, { message = "Reset:("})			

					end
				elseif chance1 == false and chance2 == false then
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.75,
						func = function() --"borrowed" from Wheel Of Fortune
							attention_text({
								text = localize("k_nope_ex"),
								scale = 1.3,
								hold = 1.4,
								major = _card,
								backdrop_colour = G.C.PURPLE,
								align = (
									G.STATE == G.STATES.TAROT_PACK
									or G.STATE == G.STATES.SPECTRAL_PACK
									or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
								)
										and "tm"
									or "cm",
								offset = {
									x = 0,
									y = (
										G.STATE == G.STATES.TAROT_PACK
										or G.STATE == G.STATES.SPECTRAL_PACK
										or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
									)
											and -0.2
										or 0,
								},
								silent = true,
							})
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 0.06 * G.SETTINGS.GAMESPEED,
								blockable = false,
								blocking = false,
								func = function()
									play_sound("tarot2", 0.76, 0.4)
									return true
								end,
							}))
							play_sound("tarot2", 1, 0.4)
							_card:juice_up(0.3, 0.5)
							return true
						end,
					}))
				end
				return nil, true
			end

		end,
		atlas = "marioatlas",
		cry_credits = {
			idea = {
				"Glitchkat10 (kierkat10)"
			},
			art = {
				"SMG9000"
			},
			code = {
				"SMG9000"
			}
		},
	}
	SMODS.Joker {
		name = "mmj-Lakitu",
		key = "lakitu",
		pos = { x = 4, y = 0 },
		soul_pos = { x = 5, y = 0		 },
		config = { extra = { jkr_slots = 0, extra_slots = 0.05,  } },
		loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.extra_slots, card.ability.extra.jkr_slots, (card.ability.extra.jkr_slots > 1 and "Slots") or "Slot"}}
        end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
		add_to_deck = function(self, card, from_debuff)
            if G.jokers and not from_debuff then
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.jkr_slots
            end
        end,
        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and not from_debuff then
                G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.jkr_slots
            end
        end,
        calculate = function(self, card, context)
            if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
				card.ability.extra.jkr_slots = card.ability.extra.jkr_slots + card.ability.extra.extra_slots * #G.jokers.cards
				G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.extra_slots * #G.jokers.cards
				card_eval_status_text(card, 'extra', nil, nil, nil, {
					message = localize('k_upgrade_ex'),
					colour = G.C.DARK_EDITION,
				})
			end
        end,
		atlas = "marioatlas",
		cry_credits = {
			idea = {
				"Glitchkat10 (kierkat10)"
			},
			art = {
				"candycanearter",
				"Gud username"
			},
			code = {
				"SMG9000"
			}
		},
	}
	SMODS.Joker {
		name = "mmj-Shyguy",
		key = "shyguy",
		pos = { x = 4, y = 1 },
		soul_pos = { x = 5, y = 1	 },
		config = { extra = { xmult_divide = 10,   } },
		loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.xmult_divide}}
        end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.individual then
				if not context.other_card:is_face() then
					context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1
					context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult + (#G.jokers.cards/card.ability.extra.xmult_divide)
					return {
						extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
						colour = G.C.MULT,
						card = context.other_card
					}
				end
			end 
        end,
		atlas = "marioatlas",
		cry_credits = {
			idea = {
				"Glitchkat10 (kierkat10)"
			},
			art = {
				"Lexi"
			},
			code = {
				"SMG9000"
			}
		},
	}
else
end




SMODS.Atlas({
	key = "marioatlas",
	atlas_table = "ASSET_ATLAS",
	path = "marioatlas.png",
	px = 71,
	py = 95
})

SMODS.Atlas({
    key = "marioatlas2",
	atlas_table = "ASSET_ATLAS",
    path = "atlasthree2_1.png",
    px = 51,
    py = 96,
	frames = 1,
})

local moremariojokerTabs = function() return {
	{
		label = "Features",
		chosen = true,
		tab_definition_function = function()
			mmj_nodes = {}
			settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = "Nostalgic Luigi", ref_table = mmj_config, ref_value = "Nostalgic_luigi" })
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = "More Mario Jokers", ref_table = mmj_config, ref_value = "More_mario_jokers" })
			config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { settings } }
			mmj_nodes[#mmj_nodes + 1] = config
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 10,
					align = "cm",
					padding = 0.2,
					colour = G.C.BLACK,
				},
				nodes = mmj_nodes,
			}
		end,
	},
} end
SMODS.current_mod.extra_tabs = moremariojokerTabs
