module Raelm.Geo.CRS.EPSG3857 exposing (..)

import Raelm.Geo.CRS as CRS
import Raelm.Geo.CRS.Earth as Earth
import Raelm.Geo.Projection.SphericalMercator as SphericalMercator
import Raelm.Geometry.Transformation as Transformation

code = "EPSG:3857"
--
-- transformationFactor = 0.5
-- transformationScale = transformationFactor / pi * SphericalMercator.r
--
-- project = SphericalMercator.project
-- unproject = SphericalMercator.unproject
-- bounds = SphericalMercator.bounds
--
-- distance = Earth.distance
-- wrapLng = Earth.wrapLng
--
-- r = Earth.r
--
-- transform = Transformation.transform transformationScale transformationFactor -transformationScale transformationFactor
-- untransform = Transformation.untransform transformationScale transformationFactor -transformationScale transformationFactor
--
-- latLngToPoint = CRS.latLngToPoint project scale transform
-- pointToLatLng = CRS.pointToLatLng scale untransform unproject
-- scale = CRS.scale
-- zoom = CRS.zoom
-- getProjectedBounds = scale transform bounds
