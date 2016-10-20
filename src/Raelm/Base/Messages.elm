module Raelm.Base.Messages exposing (..)

import Raelm.Base.Types exposing (X, Y, Z)

type MouseEventsMsg
  = Click (X, Y)
  | Drag (X, Y, X, Y)
  | Scroll Z

type TouchEventsMsg
  = Tap (X, Y)
  | Swipe (X, Y, X, Y)
  | Pinch Z
