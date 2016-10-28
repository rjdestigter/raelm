module Raelm.Base.Views exposing (view, mouseView, touchView)

-- Lang imports
import Html exposing (Html, div, button, text)
import Html.Attributes exposing (id, style)

-- Local imports
import Raelm.Base.Types exposing (EventMode(..))
import Raelm.Base.Messages exposing (EventMsg, MouseEventMsg(..), TouchEventMsg(..))
import Raelm.Base.MouseEvents exposing (..)
import Raelm.Base.TouchEvents exposing (..)
import Raelm.Base.Styles exposing (raelmContainer)

-- onEvent : EventMode -> EventMsg
onClick eventMode =
  case eventMode of
    Mouse ->
      Raelm.Base.MouseEvents.onClick
    Touch ->
      Raelm.Base.TouchEvents.onTouch

onMove = Raelm.Base.MouseEvents.onMove
onMouseDown = Raelm.Base.MouseEvents.onMouseDown
onMouseUp = Raelm.Base.MouseEvents.onMouseUp
onInitialize = Raelm.Base.MouseEvents.onInitialize


-- Exports
-- view : EventMode -> Html EventMsg -> Html EventMsg
view mapId eventMode initialized children =
  div [ style raelmContainer
      , id mapId
      -- , onClick eventMode
      , onMouseDown
      , onMouseUp
      , if initialized then onMove else onInitialize mapId
      ]
    -- [ if initialized then children else (text "")
    (if initialized then [children] else [])

mouseView mapId = view mapId Mouse

touchView mapId = view mapId Touch
