module Raelm.Base.MouseEvents exposing (..)

-- Elm Imports
import Html.Events exposing (on)

-- Local Imports
import Raelm.Base.Messages exposing (EventMsg(..), MouseEventMsg(..))
import Raelm.Base.Decoders exposing (initializeDecoder, mouseClickDecoder, mouseMoveDecoder)

-- Dependency Imports
import Raelm.Map.Messages exposing (MapMessage(..))

-- Exports
onInitialize mapId =
  on "mousemove" (initializeDecoder mapId)

onClick =
  on "click" (mouseClickDecoder eventMapper)

onMove =
  on "mousemove" (mouseMoveDecoder eventMapper)

onMouseDown = Html.Events.onMouseDown Down
onMouseUp = Html.Events.onMouseUp Up

-- Maps a local event message into a MapMessage
eventMapper : MouseEventMsg -> EventMsg
eventMapper event =
  case event of
    MouseClick (x, y) ->
      Click ( x, y )
    MouseMove (x, y) ->
      Move ( x, y )
    MouseWheel z ->
      Scroll z
    MouseDown ->
      Down
    MouseUp ->
      Up
