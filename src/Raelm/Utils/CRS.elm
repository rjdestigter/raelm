module Raelm.Geo.CRS exposing (..)

import Raelm.Types.Coordinates exposing (Point, LngLat, Bounds)
ln2 = 0.6931471805599453

-- Projects geographical coordinates into pixel coordinates for a given zoom.
latLngToPoint : (LngLat -> Point) -> (Point -> Float -> LngLat) -> LngLat -> Int -> LngLat
latLngToPoint projectFn transformFn lnglat zoom =
  let
    projectedPoint : Point
    projectedPoint = projectFn lnglat

    s : Float
    s = scale zoom
  in
    transformFn projectedPoint s

-- The inverse of `latLngToPoint`. Projects pixel coordinates on a given
-- zoom into geographical coordinates.
pointToLatLng : (Point -> Float -> LngLat) -> (Point -> LngLat) -> Point -> Int -> LngLat
pointToLatLng untransformFn unprojectFn point zoom =
  let
    s : Float
    s = scale zoom

    untransformedPoint : LngLat
    untransformedPoint = untransformFn point s
  in
    unprojectFn untransformedPoint

-- Projects geographical coordinates into coordinates in units accepted for
-- this CRS (e.g. meters for EPSG:3857, for passing it to WMS services).
project : (LngLat -> Point) -> LngLat -> Point
project projectFn latlng =
  projectFn latlng

-- Given a projected coordinate returns the corresponding LatLng.
-- The inverse of `project`.
unproject : (Point -> LngLat) -> Point -> LngLat
unproject unprojectFn point =
  unprojectFn point

-- Returns the scale used when transforming projected coordinates into
-- pixel coordinates for a particular zoom. For example, it returns
-- `256 * 2^zoom` for Mercator-based CRS.
scale : Int -> Float
scale zoom =
  256 * (2 ^ (toFloat zoom))

-- Inverse of `scale()`, returns the zoom level corresponding to a scale
-- factor of `scale`.
zoom : Float -> Float
zoom scale =
  (logBase e (scale / 256)) / ln2

-- Returns the projection's bounds scaled and transformed for the provided `zoom`.
-- getProjectedBounds : Bounds -> (Point -> Float -> LngLat) -> Int -> Bounds
getProjectedBounds ((x1, y1), (x2, y2)) transformFn zoom =
  let
    s : Float
    s = scale zoom

    minPoint : Point
    minPoint = (min x1 x2, min y1 y2)

    maxPoint : Point
    maxPoint = (max x1 x2, max y1 y2)

    (a1, a2) = transformFn minPoint s
    (b1, b2) = transformFn maxPoint s
  in
    ((a1, a2), (b1, b2))

-- wrapLatLng latlngFn wrapLng wrapLat wrapNumFn latlng =
--   let
--     lng = if wrapLng === True then wrapNum latlng.lng wrapLng True else latlng.lng
--     lat = if wrapLat === True then wrapNum latlng.lat wrapLat True else latlng.lat
--     alt = latlng.alt
--   in
--     latlngFn lat lng alt
