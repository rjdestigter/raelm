module Raelm.Base.Types exposing (..)

import DOM exposing (Rectangle)

type alias X = Int
type alias Y = Int
type alias Z = Int
type alias XY = (X, Y)

type EventMode =
  Mouse
  | Touch

type alias Initialize =
  { boundingClientRect : Maybe Rectangle
  }
