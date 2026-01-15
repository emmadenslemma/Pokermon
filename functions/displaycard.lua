PokeDisplayCard = Card:extend()

function PokeDisplayCard:init(args, x, y, w, h)
  if args.existing_key then
    return self:init_from_existing(args.existing_key, args, x, y, w, h)
  end

  local default_w, default_h = self.get_size(args.set)

  w = w or args.w or default_w
  h = h or args.h or default_h

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

function PokeDisplayCard.get_size(set)
  if set == 'Tag' then
    return 0.8, 0.8
  elseif set == 'Blind' then
    return 1.3, 1.3
  elseif set == 'Booster' then
    return G.CARD_W * 1.27, G.CARD_H * 1.27
  end
  return G.CARD_W, G.CARD_H
end

function PokeDisplayCard:init_from_existing(key, args, x, y, w, h)
  local new_args = copy_table(args)
  new_args.existing_key = nil

  local existing_obj = (args.set == 'Seal' and G.P_SEALS[key])
      or (args.set == 'Tag' and G.P_TAGS[key])
      or (args.set == 'Blind' and G.P_BLINDS[key])
      or G.P_CENTERS[key]

  new_args.atlas = existing_obj.atlas
  new_args.pos = existing_obj.pos
  new_args.soul_pos = existing_obj.soul_pos

  if args.set == 'Booster' or args.set == 'Sticker' then
    new_args.display_text = localize { type = 'name_text', set = 'Other', key = key }
  elseif args.set == 'Seal' then
    new_args.display_text = localize { type = 'name_text', set = 'Other', key = key .. '_seal' }
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
