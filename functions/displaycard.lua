PokeDisplayCard = Card:extend()

function PokeDisplayCard:init(args, x, y, w, h)
  local properties = {
    atlas = args.atlas,
    pos = args.pos,
    soul_pos = args.soul_pos,
  }

  local fake_center = setmetatable({}, {__index = function(_table, key)
    return properties[key] or G.P_CENTERS.j_joker[key]
  end})

  Card.init(self, x, y, w, h, nil, fake_center)
end
