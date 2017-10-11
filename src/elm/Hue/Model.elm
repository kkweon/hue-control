module Hue.Model exposing (baseAPIUrl, Model)

import Hue.HueDecoder exposing (LightGroup, getGroups)
import Material


bridgeIP : String
bridgeIP =
    "192.168.0.18"


username : String
username =
    "nb323mVsQp5jfuINsu47215PWJ5nkOv-MKJIk1jJ"


type alias Model =
    { lightGroups : List LightGroup
    , errorMessage : Maybe String
    , loading : Bool
    , mdl : Material.Model
    }


baseAPIUrl : String
baseAPIUrl =
    [ bridgeIP, "api", username ]
        |> String.join "/"
        |> \x -> ("http://" ++ x)
