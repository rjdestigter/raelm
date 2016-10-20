module Raelm.Map.Views exposing (view)

import Html.App
import Html exposing (Html, span, div, text)
import Html.Attributes exposing (style)

-- Local imports
import Raelm.Map.Messages exposing (MapMessage(..))
import Raelm.Map.Models exposing (MapPositionModel)

import Raelm.Layer.Tile exposing (tileLayer)
import Raelm.Layer.Tile.Types exposing (TileOptionSet(..))
import Raelm.Types.Options exposing (LayerOptions)

layerOptions = LayerOptions Nothing Nothing Nothing Nothing

-- Exports
coords label x y =
  span [ style [ ("padding", "0 15px") ] ]
    [ text label
    , text " ("
    , text (toString x)
    , text ","
    , text (toString y)
    , text ")"
    ]

-- children : MapPositionModel -> Html MouseEventsMsg
children {events} =
  let
    (x, y) = events.click
    (mx, my) = events.move
  in
    div [ style [ ("backgroundColor", "Yellow")
                , ("height", "80%")
                ]
        ]
    [ coords "Click" x y
    , coords "Move" mx my
    , tileLayer (Just "http") (LayerOption layerOptions)
    ]

-- view : (a -> b) -> c -> MapPositionModel -> Html MapMessage
view eventMapper baseView mapPositionModel =
  let
    renderedView =
      baseView (children mapPositionModel)
  in
    Html.App.map eventMapper renderedView
