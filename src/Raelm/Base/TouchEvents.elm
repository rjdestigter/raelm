module Raelm.Base.TouchEvents exposing (..)

-- Elm Imports
import Html.Events exposing (on)

-- Local Imports
import Raelm.Base.Messages exposing (EventMsg(..), TouchEventMsg(..))
import Raelm.Base.Decoders exposing (touchTapDecoder)

-- Dependency Imports
import Raelm.Map.Messages exposing (MapMessage(..))

-- Exports
onTouch =
  on "click" (touchTapDecoder eventMapper)

-- Maps a local event message into a MapMessage
eventMapper : TouchEventMsg -> EventMsg
eventMapper event =
  case event of
    TouchTap (x, y) ->
      Click ( x, y )
    TouchSwipe (x, y) ->
      Move ( x, y )
    TouchPinch z ->
      Scroll z
