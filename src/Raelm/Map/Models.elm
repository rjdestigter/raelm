module Raelm.Map.Models exposing (..)

type alias MapEventsModel =
  { click : (Float, Float)
  , move : (Float, Float)
}

type alias MapPositionModel =
  { centre : (Float, Float)
  , zoom : Int
  , events: MapEventsModel
  }

initialModel : MapPositionModel
initialModel =
  { centre = (0, 0)
  , zoom = 5
  , events = MapEventsModel (0, 0) (0, 0)
  }
