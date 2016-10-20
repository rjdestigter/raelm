module Raelm.Base.Views exposing (view)

import Html exposing (Html, div, button, text)
import Html.Attributes exposing (style)

import Raelm.Base.Styles exposing (raelmContainer)
import Raelm.Base.Messages exposing (Events(..))
import Raelm.Base.MouseEvents exposing (onClick)

view : Html Events -> Html Events
view children =
  div [ style raelmContainer
      , onClick
      ]
    [ children ]
