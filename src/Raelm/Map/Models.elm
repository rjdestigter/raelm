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
  { centre = (5.052680969238282, 51.93135336754814)
  , zoom = 18
  , events = MapEventsModel (0, 0) (0, 0) False Nothing
  , dom = DomModel False Nothing
  }
