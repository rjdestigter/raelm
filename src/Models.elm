module Models exposing (..)

import Raelm.Map.Models exposing (MapModel)

type alias AppModel =
  { mapModel : MapModel
  }

initialModel : AppModel
initialModel =
  { mapModel = Raelm.Map.Models.initialModel
  }
