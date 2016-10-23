module Raelm.Map.Messages exposing (..)

import Raelm.Types.Coordinates exposing (X, Y, Z)
import Raelm.Base.Types exposing (Initialize)

type MapEvent
  = Click (X, Y)
  | Move (X, Y)
  | Init Initialize

type MapMessage
  = Centre (X, Y)
  | Pan (X, Y, X, Y)
  | Zoom Z
  | Event MapEvent
