module Models exposing (..)

import Raelm.Map.Models exposing (MapPositionModel)

type alias AppModel =
  { mapModel : MapPositionModel
  }

initialModel : AppModel
initialModel =
  { mapModel = Raelm.Map.Models.initialModel
  }
