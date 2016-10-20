module Raelm.Base.MouseEvents exposing (onClick)

import Html.Events exposing (on)

import Raelm.Base.Messages exposing (Events(Click))
import Raelm.Base.Decoders exposing (clickDecoder)

onClick =
  on "click" clickDecoder
