module Tplink.Decoder exposing (decodeStatus, Status)

import Json.Decode
import Json.Decode.Pipeline


type alias Status =
    { err_code : Int
    , sw_ver : String
    , hw_ver : String
    , type_ : String
    , model : String
    , mac : String
    , deviceId : String
    , hwId : String
    , fwId : String
    , oemId : String
    , alias_ : String
    , dev_name : String
    , icon_hash : String
    , relay_state : Int
    , on_time : Int
    , active_mode : String
    , feature : String
    , updating : Int
    , rssi : Int
    , led_off : Int
    , latitude : Float
    , longitude : Float
    }


decodeStatus : Json.Decode.Decoder Status
decodeStatus =
    Json.Decode.Pipeline.decode Status
        |> Json.Decode.Pipeline.required "err_code" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "sw_ver" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "hw_ver" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "model" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "mac" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "deviceId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "hwId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "fwId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "oemId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "alias" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "dev_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "icon_hash" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "relay_state" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "on_time" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "active_mode" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "feature" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "updating" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "rssi" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "led_off" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "latitude" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "longitude" (Json.Decode.float)
