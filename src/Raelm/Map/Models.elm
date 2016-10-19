module Raelm.Map.Models exposing (..)

type alias MapPositionModel =
  { centre : (Float, Float)
  , zoom : Int
  }

initialModel : MapPositionModel
initialModel =
  { centre = (0, 0)
  , zoom = 5
  }
