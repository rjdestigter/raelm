module Raelm.Map.Views exposing (view)

import Html.App
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Raelm.Base.Views exposing (..)
-- import Raelm.Base.Styles exposing (raelmContainer)
import Raelm.Map.Messages exposing (MapMessage(..))
import Raelm.Base.Messages exposing (Events(..))

import Raelm.Map.Models exposing (MapPositionModel)

mapper : Events -> MapMessage
mapper event =
  case event of
    Click (x, y) ->
      Centre ( toFloat x, toFloat y)
    Drag (x, y, k, l) ->
      Pan ( toFloat x, toFloat y, 0, 0)
    Scroll z ->
      Zoom z

children : MapPositionModel -> Html Events
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

view : MapPositionModel -> Html MapMessage
view mapPositionModel =
  let
    render =
      Raelm.Base.Views.view (children mapPositionModel)
  in
    Html.App.map mapper render
