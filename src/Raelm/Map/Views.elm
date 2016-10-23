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
import String exposing (concat, join)

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
children {dom, events} =
  let
    (x, y) = events.click
    (mx, my) = events.move
    (top, left, width, height) =
      case dom.rect of
        Nothing ->
          ("0", "0", "0", "0")
        Just {top, left, width, height} ->
          (toString top, toString left, toString width, toString height)
  in
    div [ style [ ("backgroundColor", "Yellow")
                , ("height", "80%")
                ]
        ]
    [ coords "Click" x y
    , coords "Move" mx my
    , text (concat ["(", (join "," [top, left, width, height]), ")"])
    , tileLayer (Just "http") (LayerOption layerOptions)
    ]

-- view : (a -> b) -> c -> MapPositionModel -> Html MapMessage
view eventMapper baseView raelmModel =
  let
    renderedView =
      baseView raelmModel.dom.intialized (children raelmModel)
  in
    Html.App.map eventMapper renderedView
