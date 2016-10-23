module Raelm.Types.Coordinates exposing (..)

type alias X = Float
type alias Y = Float
type alias Z = Int
type alias XY = (X, Y)

type alias Lat = Float
type alias Lng = Float
type alias Point = (Int, Int)
type alias LngLat = (Lng, Lat)
type alias LatLng = (Lat, Lng)
type alias Bounds = (LngLat, LngLat)
