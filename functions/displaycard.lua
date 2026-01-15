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
