module Raelm.Base.TouchEvents exposing (..)

-- Elm Imports
import Html.Events exposing (on)

-- Local Imports
import Raelm.Base.Messages exposing (TouchEventsMsg(..))
import Raelm.Base.Decoders exposing (clickDecoder)

-- Dependency Imports
import Raelm.Map.Messages exposing (MapMessage(..))

-- Exports
onTouch =
  on "click" clickDecoder

-- Maps a local event message into a MapMessage
eventMapper : TouchEventsMsg -> MapMessage
eventMapper event =
  case event of
    Tap (x, y) ->
      Centre ( toFloat x, toFloat y)
    Swipe (x, y, k, l) ->
      Pan ( toFloat x, toFloat y, 0, 0)
    Pinch z ->
      Zoom z
