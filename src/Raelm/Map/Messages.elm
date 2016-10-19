module Raelm.Map.Messages exposing (..)

import Raelm.Types.Coordinates exposing (X, Y, Z)

type MapMessage
  = Centre (X, Y)
  | Pan (X, Y, X, Y)
  | Zoom Z
