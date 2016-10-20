module Raelm.Base.Decoders exposing (..)

import Json.Decode as Json exposing ((:=))

import Raelm.Base.Messages exposing (MouseEventsMsg(Click))

offsetDecoder : Json.Decoder (Int, Int)
offsetDecoder =
  Json.object2 (,)
    ("offsetX" := Json.int)
    ("offsetY" := Json.int)

clickDecoder =
  Json.map Click offsetDecoder
