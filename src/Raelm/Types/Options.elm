module Raelm.Types.Options exposing (..)

type alias Zoom = Maybe Int
type alias MinZoom = Zoom
type alias MaxZoom = Zoom
type alias Opacity = Maybe Float

type alias Options =
  { zoom : Zoom
  , minZoom : MinZoom
  , maxZoom : MaxZoom
  }

type alias LayerOptions =
  { zoom : Zoom
  , minZoom : MinZoom
  , maxZoom : MaxZoom
  , opacity : Opacity
  }
