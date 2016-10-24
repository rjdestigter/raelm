module Raelm.Map.Models exposing (..)

import DOM exposing (Rectangle)

type alias MapEventsModel =
  { click : (Float, Float)
  , move : (Float, Float)
  , down : Bool
  , downPosition : Maybe (Float, Float)
  }

type alias DomModel =
  { initialized : Bool
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
  , zoom = 2
  , events = MapEventsModel (0, 0) (0, 0) False Nothing
  , dom = DomModel False Nothing
  }
