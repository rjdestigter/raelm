module Category exposing (..)


type Category
    = Region
    | Hub
    | Territory
    | Representative
    | Grower
    | SalesOffice
    | Farm
    | Field
    | Subfield
    | Harvest
    | Applied
    | Profit
    | Prediction
    | CropHealth
    | Unknown String


region : String
region =
    "Region"


hub : String
hub =
    "Hub"


territory : String
territory =
    "Territory"


representative : String
representative =
    "Representative"


grower : String
grower =
    "Grower"


salesOffice : String
salesOffice =
    "Sales Office"


farm : String
farm =
    "Farm"


field : String
field =
    "Field"


subfield : String
subfield =
    "Management Zones"


harvest : String
harvest =
    "Harvest"


applied : String
applied =
    "Applied"


profit : String
profit =
    "Profit"


prediction : String
prediction =
    "Prediction"


cropHealth : String
cropHealth =
    "Crop Health"


toString : Category -> String
toString category =
    case category of
        Region ->
            region

        Hub ->
            hub

        Territory ->
            territory

        Representative ->
            representative

        Grower ->
            grower

        SalesOffice ->
            salesOffice

        Farm ->
            farm

        Field ->
            field

        Subfield ->
            subfield

        Harvest ->
            harvest

        Applied ->
            applied

        Profit ->
            profit

        Prediction ->
            prediction

        CropHealth ->
            cropHealth

        Unknown c ->
            c


fromString : String -> Category
fromString category =
    if (category == region) then
        Region
    else if (category == hub) then
        Hub
    else if (category == territory) then
        Territory
    else if (category == representative) then
        Representative
    else if (category == grower) then
        Grower
    else if (category == salesOffice) then
        SalesOffice
    else if (category == farm) then
        Farm
    else if (category == field) then
        Field
    else if (category == subfield) then
        Subfield
    else if (category == harvest) then
        Harvest
    else if (category == applied) then
        Applied
    else if (category == profit) then
        Profit
    else if (category == prediction) then
        Prediction
    else if (category == cropHealth) then
        CropHealth
    else
        Unknown category
