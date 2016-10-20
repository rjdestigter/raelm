module Raelm.Map.Views exposing (view)

import Html.App
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Raelm.Base.Views exposing (..)
-- import Raelm.Base.Styles exposing (raelmContainer)
import Raelm.Map.Messages exposing (MapMessage(..))
-- import Raelm.Base.Messages exposing (MouseEventsMsg(..))

import Raelm.Map.Models exposing (MapPositionModel)
-- import Raelm.Base.MouseEvents exposing(eventMapper)

-- children : MapPositionModel -> Html MouseEventsMsg
children {centre} =
  let
    (x, y) = centre
  in
    div [ style [ ("backgroundColor", "Yellow")
                , ("height", "80%")
                ]
        ]
    [ text (toString x)
    , text ","
    , text (toString y)
    ]

-- view : (a -> b) -> c -> MapPositionModel -> Html MapMessage
view eventMapper baseView mapPositionModel =
  let
    renderedView =
      baseView (children mapPositionModel)
  in
    Html.App.map eventMapper renderedView
