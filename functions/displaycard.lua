PokeDisplayCard = Card:extend()

function PokeDisplayCard:init(args, x, y, w, h)
  if args.existing_key then
    return self:init_from_existing(args.existing_key, args, x, y, w, h)
  end

  w = w or args.w or G.CARD_W
  h = h or args.h or G.CARD_H

  local properties = {
    atlas = args.atlas,
    pos = args.pos,
    soul_pos = args.soul_pos,
    stage = false, -- turns off pokedex view feature
  }

  local fake_center = setmetatable({}, {
    __index = function(_table, key)
      if properties[key] ~= nil then return properties[key] end
      return G.P_CENTERS.j_poke_caterpie[key]
    end
  })

  Card.init(self, x, y, w, h, nil, fake_center)

  self.sticker_run = 'NONE'
end

function PokeDisplayCard:init_from_existing(key, args, x, y, w, h)
  local existing_obj
  local new_args = copy_table(args)
  new_args.existing_key = nil

  if args.set == 'Seal' then
    existing_obj = G.P_SEALS[key]
  elseif args.set == 'Tag' then
    existing_obj = G.P_TAGS[key]
    w = 0.8
    h = 0.8
  elseif args.set == 'Blind' then
    existing_obj = G.P_BLINDS[key]
    w = 1.3
    h = 1.3
  else
    existing_obj = G.P_CENTERS[key]
    if args.set == 'Booster' then
      w = G.CARD_W*1.27
      h = G.CARD_H*1.27
    end
  end

  new_args.atlas = existing_obj.atlas
  new_args.pos = existing_obj.pos
  new_args.soul_pos = existing_obj.soul_pos

  if args.set == 'Booster' or args.set == 'Sticker' then
    new_args.display_text = localize { type = 'name_text', set = 'Other', key = key }
  elseif args.set == 'Seal' then
    new_args.display_text = localize { type = 'name_text', set = 'Other', key = key..'_seal' }
  else
    new_args.display_text = localize { type = 'name_text', set = args.set, key = key }
  end

  if args.set == 'Booster' or args.set == 'Spectral' or key == 'poke_silver' then
    new_args.shader = 'booster'
  end
  if args.set == 'Voucher' then
    new_args.shader = 'voucher'
  end

  self:init(new_args, x, y, w, h)
end

-- Controller support
local is_node_focusable_ref = G.CONTROLLER.is_node_focusable
function G.CONTROLLER:is_node_focusable(node)
  if not self.screen_keyboard and node:is(PokeDisplayCard) then
    return true
  end
  return is_node_focusable_ref(self, node)
end

local game_draw_ref = Game.draw
function Game:draw()
  game_draw_ref(self)
  local target = self.CONTROLLER.focused.target
  if target and target:is(PokeDisplayCard) then
    love.graphics.push()
    target:translate_container()
    target:draw()
    love.graphics.pop()
  end
end
