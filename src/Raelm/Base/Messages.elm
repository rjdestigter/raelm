module Raelm.Base.Messages exposing (..)

import Raelm.Base.Types exposing (X, Y, Z, Initialize)

type MouseEventMsg
  = MouseClick (X, Y)
  | MouseMove (X, Y)
  | MouseWheel Z
  | MouseDown
  | MouseUp

type TouchEventMsg
  = TouchTap (X, Y)
  | TouchSwipe (X, Y)
  | TouchPinch Z

type EventMsg
  = Click (X, Y)
  | Move (X, Y)
  | Scroll Z
  | Down
  | Up
  | Init Initialize
