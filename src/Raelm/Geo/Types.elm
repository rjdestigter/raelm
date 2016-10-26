module Raelm.Geo.Types exposing (..)

import Raelm.Types.Coordinates exposing (..)

type alias Project = LngLat -> Point
type alias Unproject = Point -> LngLat
type alias Projection = {
  r : R,
  project : Project,
  unproject : Unproject,
  bounds: Bounds
}

type alias Distance = LngLat -> LngLat -> Float
type alias Transform = Point -> Float -> LngLat
type alias Untransform = Point -> Float -> LngLat

type alias CRS = {
  r : R,
  wrapLng : WrapLng,
  wrapLat : WrapLat,
  projection: Projection,
  distance :  Distance,
  transform : Transform,
  untransform : Untransform,
  scale : (Int -> Float),
  zoom : (Float -> Float),
  latLngToPoint: LngLat -> Int -> LngLat,
  pointToLatLng: Point -> Int -> LngLat,
  getProjectedBounds: Int -> Bounds
}

type alias WrapLng = Maybe (X, X)
type alias WrapLat = Maybe (Y, Y)
type alias R = Int
type alias MaxLatitude = Float
