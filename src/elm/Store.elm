module Store exposing (..)

import Asset exposing (Assets)


type alias Data =
    { assets : Assets
    }


type alias App =
    { flags :
        { booted : Bool
        , uniqueId : Int
        }
    }


type alias Auth =
    { token : String
    , username : String
    }


type alias Store =
    { data : Data
    , modules :
        { app : App
        , auth : Auth
        }
    }
