module Raelm.Geo.CRS.EPSG3857 exposing (..)

import Raelm.Types.Coordinates exposing (Point, LngLat, Bounds)
import Raelm.Geo.CRS as CRS
import Raelm.Geo.CRS.Earth as Earth
import Raelm.Geo.Projection.SphericalMercator as SphericalMercator
import Raelm.Geo.Types exposing (..)
import Raelm.Geometry.Transformation as Transformation

code : String
code = "EPSG:3857"

transformationFactor : Float
transformationFactor = 0.5

transformationScale : Float
transformationScale = transformationFactor / (pi * (toFloat SphericalMercator.r))

project: Project
project = SphericalMercator.project

unproject : Unproject
unproject = SphericalMercator.unproject

bounds: Bounds
bounds = SphericalMercator.bounds

distance = Earth.distance
wrapLng = Earth.wrapLng
wrapLat = Earth.wrapLat

r: R
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

projection = SphericalMercator.exports

crs = CRS r wrapLng Nothing projection distance transform untransform scale zoom latLngToPoint pointToLatLng getProjectedBounds
