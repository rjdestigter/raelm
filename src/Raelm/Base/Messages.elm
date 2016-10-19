module Raelm.Base.Messages exposing (..)

import Raelm.Types.Coordinates exposing (X, Y, Z)

type Msg
  = Click (X, Y)
  | Drag (X, Y, X, Y)
  | Scroll Z
