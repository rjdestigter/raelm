module Raelm.Base.Views exposing (view)

import Html exposing (Html, div, button, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

import Raelm.Base.Styles exposing (raelmContainer)
import Raelm.Base.Messages exposing (Msg(..))

-- view : Html Msg
view children =
  div [ style raelmContainer
      -- , onClick (Click (10, 87))
      ]
    [ children ]
