module Raelm.Base.Views exposing (view, mouseView, touchView)

-- Lang imports
import Html exposing (Html, div, button, text)
import Html.Attributes exposing (style)

-- Local imports
import Raelm.Base.Types exposing (EventMode(..))
import Raelm.Base.Messages exposing (MouseEventsMsg(..))
import Raelm.Base.MouseEvents exposing (onClick)
import Raelm.Base.TouchEvents exposing (onTouch)
import Raelm.Base.Styles exposing (raelmContainer)

onEvent eventMode =
  case eventMode of
    Mouse ->
      onClick
    Touch ->
      onTouch

-- Exports
view : EventMode -> Html MouseEventsMsg -> Html MouseEventsMsg
view eventMode children =
  div [ style raelmContainer
      , onEvent eventMode
      ]
    [ children ]

mouseView = view Mouse

touchView = view Touch
