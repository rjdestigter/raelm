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

type alias MapModel =
  { centre : (Float, Float)
  , zoom : Int
  , events: MapEventsModel
  , dom: DomModel
  }

initialModel : MapModel
initialModel =
  { centre = (0, 0)
  , zoom = 4
  , events = MapEventsModel (0, 0) (0, 0) False Nothing
  , dom = DomModel False Nothing
  }
