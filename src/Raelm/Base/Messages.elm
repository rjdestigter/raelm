module Raelm.Base.Messages exposing (..)

import Raelm.Base.Types exposing (X, Y, Z)

type Events
  = Click (X, Y)
  | Drag (X, Y, X, Y)
  | Scroll Z
