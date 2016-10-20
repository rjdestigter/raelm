module Raelm.Map.Messages exposing (..)

import Raelm.Types.Coordinates exposing (X, Y, Z)

type MapEvent
  = Click (X, Y)
  | Move (X, Y)

type MapMessage
  = Centre (X, Y)
  | Pan (X, Y, X, Y)
  | Zoom Z
  | Event MapEvent
