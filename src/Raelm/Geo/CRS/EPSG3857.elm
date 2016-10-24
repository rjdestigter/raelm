module Raelm.Geo.CRS.EPSG3857 exposing (..)

import Raelm.Types.Coordinates exposing (Point, LngLat, Bounds)
import Raelm.Geo.CRS as CRS
import Raelm.Geo.CRS.Earth as Earth
import Raelm.Geo.Projection.SphericalMercator as SphericalMercator
import Raelm.Geometry.Transformation as Transformation

code = "EPSG:3857"
--
transformationFactor = 0.5
transformationScale = transformationFactor / (pi * (toFloat SphericalMercator.r))

project = SphericalMercator.project
unproject = SphericalMercator.unproject
bounds = SphericalMercator.bounds

distance = Earth.distance
wrapLng = Earth.wrapLng

r = Earth.r

transform = Transformation.transform transformationScale transformationFactor -transformationScale transformationFactor
untransform = Transformation.untransform transformationScale transformationFactor -transformationScale transformationFactor

scale = CRS.scale
zoom = CRS.zoom

latLngToPoint : LngLat -> Int -> LngLat
latLngToPoint = CRS.latLngToPoint project transform

pointToLatLng : Point -> Int -> LngLat
pointToLatLng = CRS.pointToLatLng untransform unproject

getProjectedBounds = CRS.getProjectedBounds bounds transform
