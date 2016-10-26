module Raelm.Base.Styles exposing (..)

import Style exposing (..)

raelmContainer : List Style
raelmContainer =
  [ position "absolute"
  , width (pc 100)
  , height (pc 100)
  , backgroundColor "Cyan"
  , overflow "hidden"
  ]
