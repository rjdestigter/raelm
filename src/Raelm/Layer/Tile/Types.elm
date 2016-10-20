module Raelm.Layer.Tile.Types exposing (..)

import Raelm.Types.Options exposing (..)

type alias TileSize = Maybe Int
type alias TileUrl = Maybe String

type alias TileOptions =
  { zoom : Zoom
  , minZoom  : MinZoom
  , maxZoom  : MaxZoom
  , opacity  : Opacity
  , tileSize : TileSize
  , url      : TileUrl
  }

type TileOptionSet
  = LayerOption LayerOptions
  | TileOption TileOptions

or : Maybe a -> Maybe a -> Maybe a
or a b = if not (a == Nothing) then a else b

getTileOptions : TileUrl -> TileOptionSet -> TileOptions
getTileOptions url options =
  case options of
    LayerOption layerOptions ->
      { zoom = or layerOptions.zoom (Just 4)
      , minZoom = or layerOptions.minZoom (Just 1)
      , maxZoom = or layerOptions.maxZoom (Just 18)
      , opacity = or layerOptions.opacity (Just 1)
      , tileSize = Just 256
      , url = url
      }
    TileOption tileOptions ->
      { zoom = or tileOptions.zoom (Just 4)
      , minZoom = or tileOptions.minZoom (Just 1)
      , maxZoom = or tileOptions.maxZoom (Just 18)
      , opacity = or tileOptions.opacity (Just 0.5)
      , tileSize = or tileOptions.tileSize (Just 256)
      , url = or tileOptions.url url
      }
