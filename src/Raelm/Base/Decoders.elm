module Raelm.Base.Decoders exposing (..)

import Json.Decode as Json exposing ((:=))

import Raelm.Base.Messages exposing (MouseEventMsg(MouseClick))
import Raelm.Base.Messages exposing (TouchEventMsg(TouchTap))

offsetDecoder : Json.Decoder (Int, Int)
offsetDecoder =
  Json.object2 (,)
    ("offsetX" := Json.int)
    ("offsetY" := Json.int)

clickDecoder t = Json.map t offsetDecoder

mouseClickDecoder eventMapper =
  Json.map eventMapper (clickDecoder MouseClick)

touchTapDecoder eventMapper =
  Json.map eventMapper (clickDecoder TouchTap)
