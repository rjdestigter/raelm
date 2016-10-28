module Raelm.Map.Views exposing (..)

import Html.App
import Html exposing (Html, span, div, text)
import Html.Attributes exposing (style)

import String exposing (concat, join)

-- Local imports
import Raelm.Types.Options exposing (LayerOptions)
import Raelm.Map.Messages exposing (MapMessage(..))
import Raelm.Map.Models exposing (MapModel)

import Raelm.Map.Panes.Map exposing (mapPane)
import Raelm.Layer.Tile exposing (tileLayer)
import Raelm.Layer.Tile.Types exposing (TileOptionSet(..))

import Raelm.Types.Coordinates exposing (..)
import Raelm.Utils.Coordinates exposing (..)
import Raelm.Utils.Style exposing (toPixel)

import Raelm.Map exposing (defaultRaelm)

import Raelm.Controls.ZoomControl as ZoomControl exposing (..)
import Raelm.Base.Messages exposing (EventMsg(..))

layerOptions = LayerOptions Nothing Nothing Nothing Nothing

-- Exports
coords label (x, y) =
  span [ style [ ("padding", "0 15px") ] ]
    [ text label
    , text " ("
    , text (toString x)
    , text ","
    , text (toString y)
    , text ")"
    ]

t : Point -> List (String, String) -> List (String, String)
t (x, y) s =
  List.concat [s, [ ("position", "absolute")
  , ("transform", "translateX(" ++ (toPixel x) ++ ") translateY(" ++ (toPixel y) ++ ")")
  -- , ("top", "0px")
  -- , ("left", "0px")
  ]]

openStreetMap = tileLayer (Just "http") (LayerOption layerOptions)

children : MapModel -> Html EventMsg
children raelmModel =
  let
    map = defaultRaelm raelmModel
    post = t (subtractPoint (0, 0) map.getMapPanePos)
  in
    div [ style [ ("position", "absolute")
                , ("top", "0px")
                , ("left", "0px")
                ]
        ]
        [
          div [ style (post [ ("backgroundColor", "Yellow")
                      , ("position", "absolute")
                      , ("width", "100vw")
                      , ("height", "50px")
                      , ("zIndex", "10")
                      , ("display", "flex")
                      , ("justify-content", "space-around")
                      ])
              ]
              [ coords "Centre (lng,lat)" (toFixed 5 map.getCentre)
              , coords "Mouse (lng, lat)" (map.mouseLngLat)
              , coords "Mouse (x, y)" (toFixed 2 map.mousePoint)
              , coords "Pane (x, y)" (toFixed 2 map.getMapPanePos)
              ]
          , openStreetMap map
          , ZoomControl.view post map.getZoom
        ]

-- view : (a -> b) -> c -> MapModel -> Html MapMessage
view eventMapper baseView raelmModel =
  let
    renderedView =
      baseView raelmModel.dom.initialized (mapPane raelmModel.dom.rect (children raelmModel))
  in
    Html.App.map eventMapper renderedView
