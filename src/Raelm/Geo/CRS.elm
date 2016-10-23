module Raelm.Geo.CRS exposing (..)

import Raelm.Types.Coordinates exposing (Point, LngLat)
ln2 = 0.6931471805599453

-- Projects geographical coordinates into pixel coordinates for a given zoom.
latLngToPoint projectFn scaleFn transformFn latlng zoom =
  let
    projectedPoint = projectFn latlng
    scale = scaleFn zoom
  in
    transformFn projectedPoint scale

-- The inverse of `latLngToPoint`. Projects pixel coordinates on a given
-- zoom into geographical coordinates.
pointToLatLng scaleFn untransformFn unprojectFn point zoom =
  let
    scale = scaleFn zoom
    untransformedPoint = untransformFn point scale
  in
    unprojectFn untransformedPoint

-- Projects geographical coordinates into coordinates in units accepted for
-- this CRS (e.g. meters for EPSG:3857, for passing it to WMS services).
project projectFn latlng =
  projectFn latlng

-- Given a projected coordinate returns the corresponding LatLng.
-- The inverse of `project`.
unproject unprojectFn point =
  unprojectFn point

-- Returns the scale used when transforming projected coordinates into
-- pixel coordinates for a particular zoom. For example, it returns
-- `256 * 2^zoom` for Mercator-based CRS.
scale zoom =
  256 * (2 ^ zoom)

-- Inverse of `scale()`, returns the zoom level corresponding to a scale
-- factor of `scale`.
zoom scale =
  (logBase e (scale / 256)) / ln2

-- Returns the projection's bounds scaled and transformed for the provided `zoom`.
getProjectedBounds scaleFn transformFn boundsFn bounds zoom =
  let
    scale = scaleFn zoom
    min = transformFn bounds.min scale
    max = transformFn bounds.max scale
  in
    boundsFn min max

-- wrapLatLng latlngFn wrapLng wrapLat wrapNumFn latlng =
--   let
--     lng = if wrapLng === True then wrapNum latlng.lng wrapLng True else latlng.lng
--     lat = if wrapLat === True then wrapNum latlng.lat wrapLat True else latlng.lat
--     alt = latlng.alt
--   in
--     latlngFn lat lng alt
