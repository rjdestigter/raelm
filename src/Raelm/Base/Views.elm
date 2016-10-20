module Raelm.Base.Views exposing (view, mouseView, touchView)

-- Lang imports
import Html exposing (Html, div, button, text)
import Html.Attributes exposing (style)

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

-- Exports
-- view : EventMode -> Html EventMsg -> Html EventMsg
view eventMode children =
  div [ style raelmContainer
      , onClick eventMode
      , onMove
      ]
    [ children ]

mouseView = view Mouse

touchView = view Touch
