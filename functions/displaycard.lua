PokeDisplayCard = Card:extend()

function PokeDisplayCard:init(args, x, y, w, h)
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
