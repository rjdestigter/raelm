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

import Raelm.Geo.CRS.EPSG3857 exposing (latLngToPoint, pointToLatLng)

import Raelm.Utils.Coordinates exposing (unscaleBy, ceilPoint, floorPoint)

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

hun n = toFloat ( round ( n ) )
children {centre, zoom, dom, events} =
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
          (0, 0, 0, 0)
        Just {top, left, width, height} ->
          (top, left, width, height)

    (halfWidth, halfHeight) = (width / 2, height / 2)
    (centreX, centreY) = latLngToPoint centre zoom
    (originX, originY) = (centreX - halfWidth, centreY - halfHeight)
    (projectedX, projectedY) = (mx - left + originX, my - top + originY)
    (lng, lat) = pointToLatLng (projectedX, projectedY) zoom
  in
    div [ style [ ("backgroundColor", "Yellow")
                , ("position", "fixed")
                , ("width", "100vw")
                , ("height", "50px")
                ]
        ]
    [ coords "LngLat" (hun lng) (hun lat)
    , coords "origin" originX originY
    , coords "Move" mx my
    , coords "Down position" downX downY
    , text (concat ["(", (join "," (List.map toString [top, left, width, height])), ")"])
    , text (if events.down then " isDown " else " isUp ")
    , tileLayer (Just "http") (LayerOption layerOptions) { centre = centre
                                                          , zoom = zoom
                                                          , size = (width, height)
                                                          , origin = (originX, originY)
                                                          }
    ]

-- view : (a -> b) -> c -> MapPositionModel -> Html MapMessage
view eventMapper baseView raelmModel =
  let
    renderedView =
      baseView raelmModel.dom.initialized (mapPane raelmModel.dom.rect (children raelmModel))
  in
    Html.App.map eventMapper renderedView
