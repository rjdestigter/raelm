module Raelm.Map.Views exposing (view)

import Html.App
import Html exposing (Html, span, div, text)
import Html.Attributes exposing (style)

import String exposing (concat, join)

-- Local imports
import Raelm.Types.Options exposing (LayerOptions)
import Raelm.Map.Messages exposing (MapMessage(..))
import Raelm.Map.Models exposing (MapPositionModel)

import Raelm.Map.Panes.Map exposing (mapPane)
import Raelm.Layer.Tile exposing (tileLayer)
import Raelm.Layer.Tile.Types exposing (TileOptionSet(..))

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
    (downX, downY) =
      case events.downPosition of
        Just dp -> dp
        Nothing -> (-1, -1)
    (top, left, width, height) =
      case dom.rect of
        Nothing ->
          ("0", "0", "0", "0")
        Just {top, left, width, height} ->
          (toString top, toString left, toString width, toString height)
  in
    div [ style [ ("backgroundColor", "Yellow")
                , ("position", "absolute")
                , ("top", "0px")
                , ("left", "0px")
                ]
        ]
    [ coords "Click" x y
    , coords "Move" mx my
    , coords "Down position" downX downY
    , text (concat ["(", (join "," [top, left, width, height]), ")"])
    , text (if events.down then " isDown " else " isUp ")
    , tileLayer (Just "http") (LayerOption layerOptions)
    ]

-- view : (a -> b) -> c -> MapPositionModel -> Html MapMessage
view eventMapper baseView raelmModel =
  let
    renderedView =
      baseView raelmModel.dom.initialized (mapPane raelmModel.dom.rect (children raelmModel))
  in
    Html.App.map eventMapper renderedView
