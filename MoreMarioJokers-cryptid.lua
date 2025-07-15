
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

local gradient = SMODS.Gradient{
		key = "mariogradient",
		colours = {
			HEX('E52521'),
			HEX('43B047'),
			HEX('049CD8'),
			HEX('FBD000')
		}

	}

SMODS.Rarity{
	key = "mariojoker",

	badge_colour = gradient,
}

function mult_dollars(multiplier, instant)
    local function _mod2(multiplier)
        local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
        multiplier = to_big(multiplier) or to_big(0)
        local text = 'x'..localize('$')
        local col = G.C.MONEY
        if to_big(multiplier) < to_big(0) then
            text = 'x-'..localize('$')
            col = G.C.RED              
        else
          inc_career_stat('c_dollars_earned', multiplier)
        end
        --Ease from current chips to the new number of chips
        G.GAME.dollars = to_big(G.GAME.dollars) * to_big(multiplier)
        check_and_set_high_score('most_money', G.GAME.dollars)
        check_for_unlock({type = 'money'})
        dollar_UI.config.object:update()
        G.HUD:recalculate()
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
          text = text..tostring(math.abs(to_big(multiplier))),
          scale = 0.8, 
          hold = 0.7,
          cover = dollar_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        --Play a chip sound
        play_sound('coin1')
    end
    if instant then
        _mod2(multiplier)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod2(multiplier)
            return true
        end
        }))
    end
end

if not IncantationAddons then
	IncantationAddons = {
		Stacking = {},
		Dividing = {},
		BulkUse = {},
		StackingIndividual = {},
		DividingIndividual = {},
		BulkUseIndividual = {},
		MassUse = {},
		MassUseIndividual = {}
	}
end






if mmj_config["Nostalgic_luigi"] then
	SMODS.Joker {
		name = "mmj-nluigi",
		key = "nluigi",
		pos = { x = 0, y = 0 },
		soul_pos = { x = 1, y = 0 }	,
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
				"Auto Watto",
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
						if G.GAME.probabilities[k] == 0 then
							G.GAME.probabilities[k] = 1
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
				"Auto Watto",
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
	name = "mmj-Mario",
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
			"Linus Goof Balls",
			"MarioFan597"
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
				"SMG9000",
				"MarioFan597"
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
		config = {
			extra = { retriggers = 2 },
			immutable = { max_retriggers = 25 },
		},
		loc_vars = function(self, info_queue, center)
			return { vars = { math.min(center.ability.immutable.max_retriggers, center.ability.extra.retriggers) } }
		end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
		calculate = function(self, card, context)
			if context.repetition then
				if context.cardarea == G.play then
					if context.other_card:get_id() == 4 or context.other_card:get_id() == 3 then
						return {
							message = localize("k_again_ex"),
							repetitions = to_number(
								math.min(card.ability.immutable.max_retriggers * #G.jokers.cards, card.ability.extra.retriggers * #G.jokers.cards)
							),
							card = card,
						}
					end
				end
			end
		end,
		atlas = "marioatlas",
		cry_credits = {
			idea = {
				"MarioFan597"
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
		name = "mmj-Rosalina",
		key = "rosalina",
		pos = { x = 2, y = 3 },
		soul_pos = { x = 3, y = 3 },
		config = { extra = { odds = 5 } },
		loc_vars = function(self, info_queue, center)
		return { vars = { "" .. (G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds } }
		end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
		calculate = function(self, card, context)
			if context.end_of_round and not context.individual and not context.repetition then
				for _, _card in ipairs(G.jokers.cards) do
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
								_card:juice_up(0.8, 0.5)
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
								_card:juice_up(0.8, 0.5)
								return true
							end,
						}))
						update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.9,
							func = function()
								play_sound("tarot1")
								_card:juice_up(0.8, 0.5)
								G.TAROT_INTERRUPT_PULSE = nil
								return true
							end,
						}))
						update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "+1" })
						delay(1.3)
						for k, v in pairs(G.GAME.hands) do
							level_up_hand(_card, k, true, to_big(1))
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
									major = card,
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
								_card:juice_up(0.3, 0.5)
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
				"GeorgeTheRat",
				"MarioFan597"
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
		config = { extra = { xmult_mult = 0.1,   } },
		loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.xmult_mult}}
        end,
		rarity = 4,
		cost = 20,
		order = 86,
		blueprint_compat = true,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.individual then
				if not context.other_card:is_face() then
					context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1
					context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult + (#G.jokers.cards*card.ability.extra.xmult_mult)
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
				"Lexi",
				"candycanearter"
			},
			code = {
				"SMG9000"
			}
		},
	}
	SMODS.Joker {
		name = "mmj-Yoshi",
		key = "yoshi",
		pos = { x = 4, y = 2 },
		soul_pos = { x = 5, y = 2 },
		config = { extra = { money = 3 } },
		loc_vars = function(self, info_queue, center)
			return { vars = {center.ability.extra.money}}
		end,
		rarity = 4,
		cost = 20,
		order = 87,
		blueprint_compat = true,
		calculate = function(self, card, context)
			if context.post_trigger then
				for k, v in ipairs(G.jokers.cards) do
				if v.set_cost then 
					v.ability.extra_value = (v.ability.extra_value or 0) + card.ability.extra.money
					v:set_cost()
				end
			end
			return {
				message = localize('k_val_up'),
                colour = G.C.MONEY,
				card = context.other_context.blueprint_card or context.other_card,
			}
		end
	end,
	atlas = "marioatlas",
	cry_credits = {
		idea = {
			"SMG9000",
		},
		art = {
			"Auto Watto",
		},
		code = {
			"Auto Watto",
			"SDM_0",
		},
	},
}

	SMODS.Joker {
		name = "mmj-DonkeyKong",
		key = "donkeykong",
		pos = { x = 2, y = 1 },
		soul_pos = { x = 3, y = 1 },
		config = { extra = { handsize = 0, h_mod = 1 } },
		rarity = 4,
		cost = 20,
		order = 87,
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.h_mod, center.ability.extra.handsize } }
		end,
		remove_from_deck = function(self, card, from_debuff)
			G.hand:change_size(-(card.ability.extra.handsize * card.ability.extra.h_mod))
		end,
		update = function(self, card, dt)
			if (card.area == G.jokers) and G.hand and (G.jokers and G.jokers.cards) then
				if #G.jokers.cards ~= card.ability.extra.handsize and #G.jokers.cards <= 1000 then
					G.hand:change_size(math.floor(math.min(1000, (#G.jokers.cards - card.ability.extra.handsize) * card.ability.extra.h_mod)))
					card.ability.extra.handsize = #G.jokers.cards
				end
			end
		end,
		atlas = "marioatlas",
		cry_credits = {
			idea = { "Denverplays2" },
			art = { "Gud username" },
			code = { "Auto Watto", "SDM_0" },
		},
	}
	SMODS.Joker {
		name = "mmj-Toad",
		key = "toad",
		pos = { x = 0, y = 4 },
		soul_pos = { x = 1, y = 4 },
		config = { extra = { handsize = 0, h_mod = 1 } },
		rarity = 4,
		cost = 20,
		order = 87,
		immutable = true,
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.h_mod, center.ability.extra.handsize } }
		end,
		calculate = function(self, card, context)
			if context.end_of_round and not context.individual and not context.repetition then
				local viable_cards = {}
				for i = 1, #G.jokers.cards do
					if not Card.no(G.jokers.cards[i], "immutable", true) then
						table.insert(viable_cards, i)
					end
				end
				local modified_cards = {}
				for i = 1, math.ceil(#viable_cards/2) do
					local chosen_card, pwcwin = pseudorandom_element(viable_cards, pseudoseed("Toad"))
					table.insert(modified_cards, chosen_card )
					table.remove(viable_cards, pwcwin)
				end
				table.sort(modified_cards)
				for i = 1, #modified_cards do
					local _card = modified_cards[i]
					if not G.jokers.cards[_card].config.cry_multiply then
						G.jokers.cards[_card].config.cry_multiply = 1
					end

					G.jokers.cards[_card].config.cry_multiply = G.jokers.cards[_card].config.cry_multiply * 2
					Cryptid.with_deck_effects(G.jokers.cards[_card], function(card)
					Cryptid.misprintize(card, { min = 2, max = 2 }, nil, true)
					end)
					G.E_MANAGER:add_event(Event({
							func = function()
								G.jokers.cards[_card]:juice_up(0.8, 0.5)
								card_eval_status_text(G.jokers.cards[_card], 'extra', nil, nil, nil, {message = "Increased", colour = G.C.DARK_EDITION});
								return true
							end,
						}))
				end
				
				
			end
		end,
		atlas = "marioatlas",
		cry_credits = {
			idea = { "MarioFan597" },
			art = { "Yamper" },
			code = { "SMG9000" },
		},
	}

	local lumaType = SMODS.ConsumableType {
		key = "Luma",
		primary_colour = HEX("6A5700"),
		secondary_colour = HEX("02BF0E"),
		collection_rows = {4,4}, 
		loc_txt = {
			collection = "Luma Cards",
			name = "Luma",
			label = "Luma",
			undiscovered = {
				name = 'Undiscovered Luma',
				text = { 'Find this Luma in a run to discover it' },
			},
		},
		shop_rate = 0,
		default = 'c_mmj_yellow_luma',
		can_stack = true,
		can_divide = true,
	}
	
	SMODS.MMJ_Lumas = SMODS.Consumable:extend {
		set = "Luma",
		can_use = function(self, card) 
			return true
		end,
	}
	
	SMODS.UndiscoveredSprite {
		key = 'Luma',
		atlas = 'luma',
		pos = {x = 0, y = 2},
	}
		
	SMODS.MMJ_Lumas({
		key = "mmj_yellow_luma",
		pos = {x=0,y=0},
		loc_txt = {
			name = 'Yellow Luma',
			text = {
				"#1#"
			},
		},
		cost = 4,
		atlas = "luma",
		config = {extra = {amount = 1 }},
		loc_vars = function(self, info_queue, center)
			local leastplayed = "High Card"
			local timesplayed = 1e100
			for _, v in ipairs(G.handlist) do
				if ((G.GAME.hands[v].visible == true) and (G.GAME.hands[v].played > 0)) and ( G.GAME.hands[v].played <= timesplayed) then --(Talisman and to_big(lowest_level) or lowest_level) then
					leastplayed = v
					timesplayed = G.GAME.hands[v].played
				end
			end
			if timesplayed == 1e100 then
				timesplayed = 0
			end
			return { vars = { leastplayed, } }
		end,
		use = function(self, card, area, copier)
			local leastplayed = "High Card"
			local timesplayed = 1e100
			for _, v in ipairs(G.handlist) do
				if ((G.GAME.hands[v].visible == true) and (G.GAME.hands[v].played > 0)) and ( G.GAME.hands[v].played <= timesplayed) then --(Talisman and to_big(lowest_level) or lowest_level) then
					leastplayed = v
					timesplayed = G.GAME.hands[v].played
				end
			end
			if timesplayed == 1e100 then
				timesplayed = 0
			end
			mult_dollars(math.max(timesplayed, 1))

		end,
		bulk_use = function(self, card, area, copier, number)
			local leastplayed = "High Card"
			local timesplayed = 1e100
			for _, v in ipairs(G.handlist) do
				if ((G.GAME.hands[v].visible == true) and (G.GAME.hands[v].played >= 1)) and ( G.GAME.hands[v].played <= timesplayed) then --(Talisman and to_big(lowest_level) or lowest_level) then
					leastplayed = v
					timesplayed = G.GAME.hands[v].played
				end
			end
			if timesplayed == 1e100 then
				timesplayed = 0
			end
			mult_dollars(math.max(to_big(timesplayed)^to_big(number)	, 1))
		end,
	})

	SMODS.MMJ_Lumas({
		key = "mmj_red_luma",
		pos = {x=1,y=0},
		
		cost = 4,
		atlas = "luma",
		config = {extra = {xmult = 5 }},
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.xmult, } }
		end,
		use = function(self, card, area, copier)
			for _, v in ipairs(G.handlist) do
				G.GAME.hands[v].mult = G.GAME.hands[v].mult * card.ability.extra.xmult
			end

			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
			)
			update_hand_text({sound = "tarot1", volume = 0.7, pitch = 1, delay = 1 }, {mult = "x" .. number_format(card.ability.extra.xmult), StatusText = true})
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
				{ mult = 0, chips = 0, handname = "", level = "" }
			)
		end,
		bulk_use = function(self, card, area, copier, number)
			for _, v in ipairs(G.handlist) do
				G.GAME.hands[v].mult = G.GAME.hands[v].mult * (to_big(card.ability.extra.xmult)^number)
			end

			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
			)
			update_hand_text({delay = 0}, {mult = "x" .. tostring(to_big(card.ability.extra.xmult)^number), StatusText = true})
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
				{ mult = 0, chips = 0, handname = "", level = "" }
			)
		end,
	})

	SMODS.MMJ_Lumas({
		key = "mmj_blue_luma",
		pos = {x=2,y=0},
		cost = 4,
		atlas = "luma",
		config = {extra = {xchips = 5 }},
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.xchips, } }
		end,
		use = function(self, card, area, copier)
			for _, v in ipairs(G.handlist) do
				G.GAME.hands[v].chips = G.GAME.hands[v].chips * card.ability.extra.xchips
			end

			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
			)
			update_hand_text({sound = "tarot1", volume = 0.7, pitch = 1, delay = 1 }, {chips = "x" .. number_format(card.ability.extra.xchips), StatusText = true})
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
				{ mult = 0, chips = 0, handname = "", level = "" }
			)
		end,
		bulk_use = function(self, card, area, copier, number)
			for _, v in ipairs(G.handlist) do
				G.GAME.hands[v].chips = G.GAME.hands[v].chips * (to_big(card.ability.extra.xchips)^number)
			end

			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
			)
			update_hand_text({delay = 0}, {chips = "x" .. tostring(to_big(card.ability.extra.xchips)^number), StatusText = true})
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
				{ mult = 0, chips = 0, handname = "", level = "" }
			)
		end,
	})

	SMODS.MMJ_Lumas({
		key = "mmj_apricot_luma",
		pos = {x=1,y=0},
		cost = 4,
		atlas = "luma",
		config = {extra = {xmult_and_chips = 1.5 }},
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.xmult_and_chips, } }
		end,
		use = function(self, card, area, copier)
			local oldhandchips
			local oldhandmult
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
			)
			update_hand_text({sound = "tarot1", volume = 0.7, pitch = 1, delay = 1}, {mult = "Swap", chips = "Swap", StatusText = true})
			for _, v in ipairs(G.handlist) do
				oldhandchips = G.GAME.hands[v].chips
				oldhandmult = G.GAME.hands[v].mult
				G.GAME.hands[v].chips = oldhandmult
				G.GAME.hands[v].mult = oldhandchips
			end
			for _, v in ipairs(G.handlist) do
				G.GAME.hands[v].chips = G.GAME.hands[v].chips * card.ability.extra.xmult_and_chips
				G.GAME.hands[v].mult = G.GAME.hands[v].mult * card.ability.extra.xmult_and_chips
			end

			
			update_hand_text({sound = "tarot1", volume = 0.7, pitch = 1, delay = 1 }, {mult = "x" .. number_format(card.ability.extra.xmult_and_chips), StatusText = true})
			update_hand_text({sound = "tarot1", volume = 0.7, pitch = 1, delay = 1 }, {chips = "x" .. number_format(card.ability.extra.xmult_and_chips), StatusText = true})
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
				{ mult = 0, chips = 0, handname = "", level = "" }
			)
		end,
		bulk_use = function(self, card, area, copier, number)
			for _, v in ipairs(G.handlist) do
				G.GAME.hands[v].chips = G.GAME.hands[v].chips * (to_big(card.ability.extra.xmult_and_chips)^number)
				G.GAME.hands[v].mult = G.GAME.hands[v].mult * (to_big(card.ability.extra.xmult_and_chips)^number)
			end

			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
			)
			update_hand_text({sound = "tarot1", volume = 0.7, pitch = 1, delay = 1 }, {mult = "x" .. tostring(to_big(card.ability.extra.xmult_and_chips)^number), StatusText = true})
			update_hand_text({sound = "tarot1", volume = 0.7, pitch = 1, delay = 1 }, {chips = "x" .. tostring(to_big(card.ability.extra.xmult_and_chips)	^number), StatusText = true})
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
				{ mult = 0, chips = 0, handname = "", level = "" }
			)
		end,
	})

	SMODS.MMJ_Lumas({
		key = "mmj_black_luma",
		pos = {x=4,y=0},
		loc_txt = {
			name = 'Black Luma',
			text = {
				"#1#",
				"#2#",
				"#3#"
			},
		},
		cost = 4,
		atlas = "luma",
		config = {extra = {level_up = 1, times_level_up_per = 1, times_total = 1 }},
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.level_up, center.ability.extra.times_level_up_per, center.ability.extra.times_total, } }
		end,
		update = function(self, card, dt)
			if G.GAME and G.GAME.consumeable_usage_total then 
				card.ability.extra.times_total = card.ability.extra.level_up + (card.ability.extra.times_level_up_per * G.GAME.consumeable_usage_total.all)
			end
		end,
		use = function(self, card, area, copier)
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
			)
			update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
			update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
			update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "+"..tostring(to_big(card.ability.extra.times_total)) })
			delay(1.3)
			for k, v in pairs(G.GAME.hands) do
				level_up_hand(card, k, true, to_big(card.ability.extra.times_total))
			end
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
				{ mult = 0, chips = 0, handname = "", level = "" }
			)
		end,
		bulk_use = function(self, card, area, copier, number)
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
			)
			update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
			update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
			update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "+"..tostring(to_big(card.ability.extra.times_total)*number) })
			delay(1.3)
			for k, v in pairs(G.GAME.hands) do
				level_up_hand(card, k, true, to_big(card.ability.extra.times_total)*number)
			end
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
				{ mult = 0, chips = 0, handname = "", level = "" }
			)
		end,
	})


	SMODS.MMJ_Lumas({
		key = "mmj_pink_luma",
		pos = {x=5,y=0},
		loc_txt = {
			name = 'Pink Luma',
			text = {
			},
		},
		cost = 4,
		atlas = "luma",
		config = {extra = {condition = false, divide = 2, pow = 2}},
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.divide, center.ability.extra.pow, } }
		end,
		use = function(self, card, area, copier)
			if card.ability.extra.condition == false then
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
					{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
				)
				update_hand_text({ delay = 0 }, { mult = "-", StatusText = true })
				update_hand_text({ delay = 0 }, { chips = "-", StatusText = true })
				update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "/"..tostring(to_big(card.ability.extra.divide)) })
				delay(1.3)
				for k, v in pairs(G.GAME.hands) do
					local divide = -(to_big(G.GAME.hands[k].level) / 2)
					level_up_hand(card, k, true, to_big(divide))
				end
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
					{ mult = 0, chips = 0, handname = "", level = "" }
				)
				card.ability.extra.condition = true
			elseif card.ability.extra.condition == true then
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
					{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
				)
				update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
				update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
				update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "^"..tostring(to_big(card.ability.extra.pow)) })
				delay(1.3)
				for k, v in pairs(G.GAME.hands) do
					local power = (to_big(G.GAME.hands[k].level) ^ 2) - G.GAME.hands[k].level	
					level_up_hand(card, k, true, to_big(power))
				end
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
					{ mult = 0, chips = 0, handname = "", level = "" }
				)
				card.ability.extra.condition = false
			end
		end,
		bulk_use = function(self, card, area, copier, number)
			for i=1, number do
				if card.ability.extra.condition == false then
					update_hand_text(
						{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
						{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
					)
					update_hand_text({ delay = 0 }, { mult = "-", StatusText = true })
					update_hand_text({ delay = 0 }, { chips = "-", StatusText = true })
					update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "/"..tostring(to_big(card.ability.extra.divide)) })
					delay(1.3)
					for k, v in pairs(G.GAME.hands) do
						local divide = -(to_big(G.GAME.hands[k].level) / 2)
						level_up_hand(card, k, true, to_big(divide))
					end
					update_hand_text(
						{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
						{ mult = 0, chips = 0, handname = "", level = "" }
					)
					card.ability.extra.condition = true
				elseif card.ability.extra.condition == true then
					update_hand_text(
						{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
						{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
					)
					update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
					update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
					update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "^"..tostring(to_big(card.ability.extra.pow)) })
					delay(1.3)
					for k, v in pairs(G.GAME.hands) do
						local power = (to_big(G.GAME.hands[k].level) ^ 2) - G.GAME.hands[k].level
						level_up_hand(card, k, true, to_big(power))
					end
					update_hand_text(
						{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
						{ mult = 0, chips = 0, handname = "", level = "" }
					)
					card.ability.extra.condition = false
				end
			end
		end,
	})

	SMODS.MMJ_Lumas({
		key = "mmj_orange_luma",
		pos = {x=0,y=0},
		loc_txt = {
			name = 'Orange Luma',
			text = {
			},
		},
		cost = 4,
		atlas = "luma",
		config = {extra = 5},
		loc_vars = function(self, info_queue, center)
			return { vars = { } }
		end,
		use = function(self, card, area, copier)
			local used_consumable = copier or card
			delay(0.4)	
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("mmj_asc_luma"), chips = "...", mult = "...", level = "" }
			)
			delay(1.0)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					play_sound("tarot1")
					ease_colour(G.C.UI_CHIPS, copy_table(G.C.GOLD), 0.1)
					ease_colour(G.C.UI_MULT, copy_table(G.C.GOLD), 0.1)
					Cryptid.pulse_flame(0.01, G.GAME.sunnumber/5 or 1)
					used_consumable:juice_up(0.8, 0.5)
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						blockable = false,
						blocking = false,
						delay = 1.2,
						func = function()
							ease_colour(G.C.UI_CHIPS, G.C.BLUE, 1)
							ease_colour(G.C.UI_MULT, G.C.RED, 1)
							return true
						end,
					}))
					return true
				end,
			}))
		update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { mult = "X"..tostring(to_big(card.ability.extra)),  chips = "X"..tostring(to_big(card.ability.extra)) })
		delay(2.6)
		G.GAME.sunnumber = G.GAME.sunnumber ~= nil and G.GAME.sunnumber * card.ability.extra or card.ability.extra
		update_hand_text(
			{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
			{ mult = 0, chips = 0, handname = "", level = "" }
		)
		end,
		bulk_use = function(self, card, area, copier, number)
		local used_consumable = copier or card
			delay(0.4)	
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize("mmj_asc_luma"), chips = "...", mult = "...", level = "" }
			)
			delay(1.0)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					play_sound("tarot1")
					ease_colour(G.C.UI_CHIPS, copy_table(G.C.GOLD), 0.1)
					ease_colour(G.C.UI_MULT, copy_table(G.C.GOLD), 0.1)
					Cryptid.pulse_flame(0.01, G.GAME.sunnumber/5 or 1)
					used_consumable:juice_up(0.8, 0.5)
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						blockable = false,
						blocking = false,
						delay = 1.2,
						func = function()
							ease_colour(G.C.UI_CHIPS, G.C.BLUE, 1)
							ease_colour(G.C.UI_MULT, G.C.RED, 1)
							return true
						end,
					}))
					return true
				end,
			}))
		update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { mult = "X"..tostring(to_big(card.ability.extra)^ number),  chips = "X"..tostring(to_big(card.ability.extra)^ number) })
		delay(2.6)
		G.GAME.sunnumber = G.GAME.sunnumber ~= nil and G.GAME.sunnumber * (card.ability.extra ^ number) or card.ability.extra ^ number
		update_hand_text(
			{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
			{ mult = 0, chips = 0, handname = "", level = "" }
		)
		end,
	})

	

	SMODS.Voucher({
		key = "planet_hopp",
		atlas = "luma",
		pos = {x = 0, y = 0},
		cost = 10,
		unlocked = true,
		discovered = false,
		available = true,
		config = {extra = {booster_gain = 1}},
		redeem = function(self)
		end,
		loc_vars = function(self, info_queue, card)
			--if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
			return {vars = {	}}
		end,
	})
	SMODS.Voucher({
		key = "planet_bounce",
		atlas = "luma",
		pos = {x = 0, y = 0},
		cost = 10,
		unlocked = true,
		discovered = false,
		available = true,
		requires = {"v_mmj_planet_hopp"},
		config = {extra = {booster_gain = 1}},
		redeem = function(self)
		end,
		loc_vars = function(self, info_queue, card)
			--if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
			return {vars = {	}}
		end,
	})

	if next(SMODS.find_mod('Beelatro')) then
		SMODS.Joker {
			name = "mmj-beemario",
			key = "beemario",
			config = { extra = { retriggers = 0, bee = true } },
			pos = { x = 0, y = 2 },
			soul_pos = { x = 1, y = 2 },
			rarity = "mmj_mariojoker",
			order = 85,
			cost = 50,
			blueprint_compat = true,
			immutable = true,
			loc_vars = function(self, info_queue, center)
				return { vars = { center.ability.extra.retriggers } }
			end,
			atlas = "beemarioatlas",
			calculate = function(self, card, context)
				if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self and card.ability.extra.retriggers > 0 then
					return {
						message = localize("k_again_ex"),
						repetitions = card.ability.extra.retriggers,
						card = card,
					}
				end
			end,
			update = function(self, card, dt)
				if G and G.jokers and G.jokers.cards then
					local beeCount = GetBees()
					card.ability.extra.retriggers = beeCount
				end
			end,
			cry_credits = {
				idea = {
					"MarioFan597"
				},
				art = {
					"Linus Goof Balls",
					"MarioFan597",
				},
				code = {
					"SMG9000"
				}
			},
		}
		if mmj_config["Nostalgic_luigi"] then
			SMODS.Joker {
				name = "mmj-beenluigi",
				key = "beenluigi",
				pos = { x = 0, y = 0 },
				soul_pos = { x = 1, y = 0 }	,
				config = { extra = { x_chips = 1, bee = true } },
				loc_vars = function(self, info_queue, center)
					return { vars = { center.ability.extra.x_chips } }
				end,
				rarity = "mmj_mariojoker",
				cost = 50,
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
				update = function(self, card, dt)
					if G and G.jokers and G.jokers.cards then
						local beeCount = GetBees()
						card.ability.extra.x_chips = beeCount
					end
				end,
				atlas = "beemarioatlas",
				cry_credits = {
					idea = {
						"Auto Watto"
					},
					art = {
						"Auto Watto",
						"Linus Goof Balls"
					},
					code = {
						"Auto Watto"
					}
				},
			}
		else
			SMODS.Joker {
				name = "mmj-beeluigi",
				key = "beeluigi",
				config = { extra = { odd_change = 0, last_odd_change = 1, bee = true, start_odd = 1, odd_divide = 5, total_amount = 1 } },
				pos = { x = 0, y = 0 },
				soul_pos = { x = 1, y = 0 },
				rarity = "mmj_mariojoker",
				order = 85,
				cost = 50,
				blueprint_compat = true,
				immutable = true,
				loc_vars = function(self, info_queue, center)
					return { vars = { center.ability.extra.start_odd, center.ability.extra.odd_divide, center.ability.extra.total_amount  } }
				end,
				atlas = "beemarioatlas",
				remove_from_deck = function(self, card, from_debuff)
					for k, v in pairs(G.GAME.probabilities) do 
						G.GAME.probabilities[k] = v/card.ability.extra.last_odd_change
					end
					card.ability.extra.last_odd_change = 1
				end,
				update = function(self, card, dt)
					if G.jokers and card.added_to_deck  then
						local beeCount = GetBees()
						card.ability.extra.total_amount = card.ability.extra.start_odd +(beeCount / card.ability.extra.odd_divide)
						local change = math.pow((card.ability.extra.start_odd + (beeCount/card.ability.extra.odd_divide)), #G.jokers.cards)
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
				cry_credits = {
					idea = {
						"MarioFan597"
					},
					art = {
						"Linus Goof Balls",
						"MarioFan597",
					},
					code = {
						"SMG9000"
					}
				},
			}
		end
		SMODS.Joker {
		name = "mmj-beePeach",
		key = "beepeach",
		pos = { x = 0, y = 1 },
		soul_pos = { x = 1, y = 1 },
		config = { extra = { blind_reduce = 0, base_blind_reduce = 2, bee = true} },
		loc_vars = function(self, info_queue, center)
			return { vars = { center.ability.extra.blind_reduce, center.ability.extra.base_blind_reduce } }
		end,
		rarity = "mmj_mariojoker",
		cost = 50,
		order = 86,
		blueprint_compat = true,
		calculate = function(self, card, context)
			if context.setting_blind then
				for i = 1, #G.jokers.cards do
					if not Talisman.config_file.disable_anims then
						G.E_MANAGER:add_event(Event({
							func = function()
								card_eval_status_text(G.jokers.cards[i], 'extra', nil, nil, nil, {message = localize("mmj_beepeach"), colour = G.C.DARK_EDITION});
								return true
							end,
						}))
					end
					G.GAME.blind.chips = to_big(G.GAME.blind.chips) * to_big( 1 - (card.ability.extra.blind_reduce / 100))
				end	
				return nil, true
			end
		end,
		update = function(self, card, dt)
			if G and G.jokers and G.jokers.cards  then
				local beeCount = GetBees()
				card.ability.extra.blind_reduce = math.min(card.ability.extra.base_blind_reduce * beeCount, 99.9)
			end
		end,
		atlas = "beemarioatlas",		
		cry_credits = {
			idea = {
				"MarioFan597"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"SMG9000"
			}
		},
		}
		SMODS.Joker {
			name = "mmj-beeRosalina",
			key = "beerosalina",
			pos = { x = 2, y = 3 },
			soul_pos = { x = 3, y = 3 },
			config = { extra = { odds = 5, bee = true, multiplier = 0.5, amount = 0 } },
			loc_vars = function(self, info_queue, center)
			return { vars = { "" .. (G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds, center.ability.extra.multiplier, center.ability.extra.amount } }
			end,
			rarity = "mmj_mariojoker",
			cost = 50,
			order = 86,
			blueprint_compat = true,
			calculate = function(self, card, context)
				if context.end_of_round and not context.individual and not context.repetition then
					for _, _card in ipairs(G.jokers.cards) do
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
									_card:juice_up(0.8, 0.5)
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
									_card:juice_up(0.8, 0.5)
									return true
								end,
							}))
							update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 0.9,
								func = function()
									play_sound("tarot1")
									_card:juice_up(0.8, 0.5)
									G.TAROT_INTERRUPT_PULSE = nil
									return true
								end,
							}))
							update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "+"..tostring(card.ability.extra.amount) })
							delay(1.3)
							for k, v in pairs(G.GAME.hands) do
								level_up_hand(_card, k, true, to_big(card.ability.extra.amount))
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
										major = card,
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
									_card:juice_up(0.3, 0.5)
									return true
								end,
							}))
						end
					end	
					return nil, true
				end
			end,
			update = function(self, card, dt)
				if G and G.jokers and G.jokers.cards  then
					local beeCount = GetBees()
					card.ability.extra.amount = math.ceil(card.ability.extra.multiplier * beeCount)
				end
			end,
			atlas = "beemarioatlas",
			cry_credits = {
				idea = {
					"Denverplays2"
				},
				art = {
					"MarioFan597"
				},
				code = {
					"SMG9000"
				}
			},
		}

		local powerupable = {
			j_mmj_mario = "j_mmj_beemario",
			j_mmj_nluigi = "j_mmj_beenluigi",
			j_mmj_luigi = "j_mmj_beeluigi",
			j_mmj_peach = "j_mmj_beepeach",
			j_mmj_rosalina = "j_mmj_beerosalina",	
		}

		SMODS.Consumable {
			key = 'beemushroom',
			cry_credits = {
				art = { "MarioFan597" },
				code = { "SMG9000" }
			},
			set = 'Spectral',
			pos = { x = 0, y = 0 },
			cost = 4,
			unlocked = true,
			discovered = true,
			hidden = true,
			soul_rate = 0.006,
			atlas = 'powerups',
			soul_pos = { x = 1, y = 0 },
			soul_set = "Spectral",
			can_use = function(self, card)
				if #G.jokers.highlighted == 1
				and powerupable[G.jokers.highlighted[1].config.center.key]then
					return true
				end
			end,
			use = function(self, card, area, copier)
				SMODS.add_card({key = powerupable[G.jokers.highlighted[1].config.center.key]})
				G.jokers.highlighted[1]:remove()
			end,
			in_pool = function()
				if G and G.jokers and G.jokers.cards then
					for k, v in ipairs(G.jokers.cards) do
						if powerupable[v.config.center.key] then
							return true 
						end
					end
				end
				return false
			end,
		}

	end

	local n64deckjokers = {
		"j_cry_wario",
		"j_cry_waluigi",	
		"j_mmj_mario",
		"j_mmj_peach",
		"j_mmj_rosalina",
		"j_mmj_daisy",
		"j_mmj_king_boo",
		"j_mmj_shyguy",
		"j_mmj_lakitu",
		"j_mmj_yoshi",
		"j_mmj_donkeykong"
	}	
	if mmj_config["Nostalgic_luigi"] then
		table.insert( n64deckjokers, "j_mmj_nluigi")
	else
		table.insert( n64deckjokers, "j_mmj_luigi")
	end

SMODS.Consumable {
    key = "miyamoto",
    cry_credits = {
        idea = {"Auto Watto"},
        art = {"unexian"},
        code = {"Auto Watto", "SDM_0"},
    },
    set = "Code",
    pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 }	,
    cost = 4,
    unlocked = true,
    discovered = true,
    object_type = "Consumable",
    atlas = "mariocodecards",
	can_use = function(self, card)
        return #G.jokers.highlighted == 1
            and not G.jokers.highlighted[1].ability.eternal
            and G.jokers.highlighted[1].config.center.rarity == 4
    end,
	use = function(self, card, area, copier)
		
        local selected_joker = G.jokers.highlighted[1]
        local deleted_joker_key = selected_joker.config.center.key
        n64deckjokers[deleted_joker_key] = nil

        local _first_dissolve = nil
        G.E_MANAGER:add_event(Event({
            trigger = "before",
            delay = 0.75,
            func = function()
                selected_joker:start_dissolve(nil, _first_dissolve)
                _first_dissolve = true
                return true
            end,
        }))

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                play_sound("timpani")

                local selected_joker_key = pseudorandom_element(n64deckjokers, pseudoseed('miyamoto'))

                local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, selected_joker_key)

                new_card:add_to_deck()
                G.jokers:emplace(new_card)
                new_card:juice_up(0.3, 0.5)

                if new_card.config.center.key == deleted_joker_key then
                    check_for_unlock({ type = "pr_unlock" })
                end
                return true
            end,
        }))
    end,
}

	SMODS.Back{
		key = "n64deck",
		atlas = 'mariodecks', 
		pos = { x = 0, y = 0 },
		config = {joker_slot = 5},
		apply = function(self)
			G.E_MANAGER:add_event(Event({
				func = function()
					if G.jokers then
						local jokerkey = math.min( (math.floor(pseudorandom("n64deck", 1, #n64deckjokers + 1))), #n64deckjokers)
						SMODS.add_card({key = n64deckjokers[jokerkey]})
						return true
					end
				end,
			}))
		end,
	}
	if next(SMODS.find_mod("CardSleeves")) then
		CardSleeves.Sleeve {
			key = "n64sleeve",
			name = "n64 Sleeve",
			atlas = "mariosleeves",
			pos = { x = 0, y = 0 },
			config = { joker_slot = 5 },
			unlocked = true,
			apply = function(self, sleeve)
				CardSleeves.Sleeve.apply(self)
				G.E_MANAGER:add_event(Event({
					func = function()
						if G.jokers then
							local jokerkey = math.min( (math.floor(pseudorandom("n64sleeve", 1, #n64deckjokers + 1))), #n64deckjokers)
							SMODS.add_card({key = n64deckjokers[jokerkey]})
							return true
						end
					end,
				}))
			end,
		}
	end


	
	table.insert(IncantationAddons.Stacking, "Luma")
	table.insert(IncantationAddons.Dividing, "Luma")
	table.insert(IncantationAddons.BulkUse, "Luma")
	table.insert(IncantationAddons.StackingIndividual, "Luma")
	table.insert(IncantationAddons.DividingIndividual, "Luma")
	table.insert(IncantationAddons.BulkUseIndividual, "Luma")
	table.insert(IncantationAddons.MassUse, "Luma")
	table.insert(IncantationAddons.MassUseIndividual, "Luma")
	







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
	key = "luma",
	atlas_table = "ASSET_ATLAS",
	path = "luma.png",
	px = 71,
	py = 95
})
SMODS.Atlas({
	key = "mariosleeves",
	atlas_table = "ASSET_ATLAS",
	path = "mariosleeves.png",
	px = 71,
	py = 95
})
SMODS.Atlas({
	key = "mariodecks",
	atlas_table = "ASSET_ATLAS",
	path = "mariodecks.png",
	px = 71,
	py = 95
})
SMODS.Atlas({
	key = "powerups",
	atlas_table = "ASSET_ATLAS",
	path = "powerups.png",
	px = 71,
	py = 95
})
SMODS.Atlas({
	key = "mariocodecards",
	atlas_table = "ASSET_ATLAS",
	path = "mariocodecards.png",
	px = 71,
	py = 95
})

SMODS.Atlas({
    key = "beemarioatlas",
	atlas_table = "ASSET_ATLAS",
    path = "beemarioatlas.png",
    px = 71,
    py = 95,
})

local moremariojokerTabs = function() return {
	{
		label = localize("mmj_config_features"),
		chosen = true,
		tab_definition_function = function()
			mmj_nodes = {}
			settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mmj_config_nostalgic_luigi"), ref_table = mmj_config, ref_value = "Nostalgic_luigi" })
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mmj_config_more_mario_jokers"), ref_table = mmj_config, ref_value = "More_mario_jokers" })
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
