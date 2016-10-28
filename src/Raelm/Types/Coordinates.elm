module Raelm.Types.Coordinates exposing (..)

type alias X = Float
type alias Y = Float
type alias Z = Int
type alias Zoom = Z
type alias XY = (X, Y)

type alias Lat = Float
type alias Lng = Float
type alias Point = (X, Y)
type alias LngLat = (Lng, Lat)
type alias Bounds = (Point, Point)
type alias LngLatBounds = (LngLat, LngLat)
type alias Coord = (X, Y, Z)
type alias Coords = List Coord

type PanePos = PanePos Point

type PointTuple a b = PointTuple a | LngLatTuple b

type alias BoundsMinMax = {
  minX : Point,
  minY : Point,
  maxX: Point,
  maxY: Point
}
