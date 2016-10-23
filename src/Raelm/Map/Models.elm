module Raelm.Map.Models exposing (..)

import DOM exposing (Rectangle)

type alias MapEventsModel =
  { click : (Float, Float)
  , move : (Float, Float)
  }

type alias DomModel =
  { intialized : Bool
  , rect: Maybe Rectangle
  }

type alias MapPositionModel =
  { centre : (Float, Float)
  , zoom : Int
  , events: MapEventsModel
  , dom: DomModel
  }

initialModel : MapPositionModel
initialModel =
  { centre = (0, 0)
  , zoom = 5
  , events = MapEventsModel (0, 0) (0, 0)
  , dom = DomModel False Nothing
  }
