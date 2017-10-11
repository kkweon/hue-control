module Hue.HueDecoder exposing (..)

import Json.Encode
import Json.Decode
import Http
import Html
import Json.Decode.Pipeline


type alias LightGroupState =
    { all_on : Bool
    , any_on : Bool
    }


type alias LightGroupAction =
    { on : Bool
    , bri : Int
    , hue : Int
    , sat : Int
    , effect_ : String
    , xy : List Float
    , ct : Int
    , alert : String
    , colormode : String
    }


type alias LightGroup =
    { id : String
    , name : String
    , lights : List String
    , type_ : String
    , state : LightGroupState
    , recycle : Bool
    , class_ : String
    , action : LightGroupAction
    }


decodeLightGroupState : Json.Decode.Decoder LightGroupState
decodeLightGroupState =
    Json.Decode.Pipeline.decode LightGroupState
        |> Json.Decode.Pipeline.required "all_on" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "any_on" (Json.Decode.bool)


decodeLightGroupAction : Json.Decode.Decoder LightGroupAction
decodeLightGroupAction =
    Json.Decode.Pipeline.decode LightGroupAction
        |> Json.Decode.Pipeline.required "on" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "bri" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "hue" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "sat" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "effect" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "xy" (Json.Decode.list Json.Decode.float)
        |> Json.Decode.Pipeline.required "ct" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "alert" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "colormode" (Json.Decode.string)


decodeLightGroup : Json.Decode.Decoder LightGroup
decodeLightGroup =
    Json.Decode.Pipeline.decode LightGroup
        |> Json.Decode.Pipeline.hardcoded "0"
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "lights" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "state" (decodeLightGroupState)
        |> Json.Decode.Pipeline.required "recycle" (Json.Decode.bool)
        |> Json.Decode.Pipeline.optional "class" (Json.Decode.string) "null"
        |> Json.Decode.Pipeline.required "action" (decodeLightGroupAction)


temp : String
temp =
    "{\"1\": {\"name\": \"Living room\", \"lights\": [\"2\", \"3\", \"1\"], \"type\": \"Room\", \"state\": {\"all_on\": false, \"any_on\": false}, \"recycle\": false, \"class\": \"Living room\", \"action\": {\"on\": false, \"bri\": 254, \"hue\": 39392, \"sat\": 13, \"effect\": \"none\", \"xy\": [0.3691, 0.3719], \"ct\": 230, \"alert\": \"none\", \"colormode\": \"xy\"}}, \"2\": {\"name\": \"Afred Hue Group\", \"lights\": [\"1\", \"2\", \"3\"], \"type\": \"LightGroup\", \"state\": {\"all_on\": false, \"any_on\": false}, \"recycle\": false, \"action\": {\"on\": false, \"bri\": 254, \"hue\": 39392, \"sat\": 13, \"effect\": \"none\", \"xy\": [0.3691, 0.3719], \"ct\": 230, \"alert\": \"none\", \"colormode\": \"xy\"}}, \"3\": {\"name\": \"Bedroom\", \"lights\": [\"4\"], \"type\": \"Room\", \"state\": {\"all_on\": false, \"any_on\": false}, \"recycle\": false, \"class\": \"Bedroom\", \"action\": {\"on\": false, \"bri\": 25, \"hue\": 47104, \"sat\": 254, \"effect\": \"none\", \"xy\": [0.1532, 0.0475], \"ct\": 153, \"alert\": \"none\", \"colormode\": \"xy\"}}}"


decodeGroups : Json.Decode.Value -> Result String (List LightGroup)
decodeGroups message =
    let
        tupleToLightGroup =
            \( a, b ) -> retrieveId a b
    in
        message
            |> Json.Decode.decodeValue (Json.Decode.keyValuePairs decodeLightGroup)
            |> Result.andThen (\list -> Ok (List.map tupleToLightGroup list))


retrieveId : String -> LightGroup -> LightGroup
retrieveId id lightgroup =
    { lightgroup | id = id }


getGroups : String -> Http.Request Json.Decode.Value
getGroups groupUrl =
    Http.get groupUrl Json.Decode.value



-- [
-- 	{
-- 		"error": {
-- 			"type": 7,
-- 			"address": "/groups/1/action/on",
-- 			"description": "invalid value, 222 } , for parameter, on"
-- 		}
-- 	}
-- ]
-- [
-- 	{
-- 		"success": {
-- 			"/groups/1/action/on": false
-- 		}
-- 	}
-- ]


type alias SignalMessage =
    { result : String
    , address : String
    , description : String
    }
