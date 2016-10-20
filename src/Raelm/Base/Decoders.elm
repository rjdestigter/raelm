module Raelm.Base.Decoders exposing (..)

import Json.Decode as Json exposing ((:=))

import Raelm.Base.Messages exposing (MouseEventMsg(MouseClick, MouseMove))
import Raelm.Base.Messages exposing (TouchEventMsg(TouchTap))

offsetDecoder : Json.Decoder (Int, Int)
offsetDecoder =
  Json.object2 (,)
    ("offsetX" := Json.int)
    ("offsetY" := Json.int)

clickDecoder t = Json.map t offsetDecoder

mouseClickDecoder eventMapper =
  Json.map eventMapper (clickDecoder MouseClick)

mouseMoveDecoder eventMapper =
  Json.map eventMapper (clickDecoder MouseMove)

touchTapDecoder eventMapper =
  Json.map eventMapper (clickDecoder TouchTap)
