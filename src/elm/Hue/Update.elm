module Hue.Update exposing (Msg, initModel, init, update, Msg(..))

import Hue.HueDecoder as HueDecoder exposing (LightGroup)
import Json.Decode
import Json.Encode
import Http
import Hue.Model exposing (Model, baseAPIUrl)


initModel : Model
initModel =
    { lightGroups = []
    , errorMessage = Nothing
    , loading = True
    }


init : ( Model, Cmd Msg )
init =
    initModel ! [ Cmd.batch [ getGroups ] ]


type Msg
    = TurnOn LightGroup
    | TurnOff LightGroup
    | UpdateGroup (Result Http.Error Json.Decode.Value)
    | UpdateSwitch (Result Http.Error Json.Decode.Value)
    | Refresh


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TurnOn { id } ->
            model ! [ onSignal id ]

        TurnOff { id } ->
            model ! [ offSignal id ]

        UpdateGroup (Ok message) ->
            let
                possibleGroups =
                    message |> HueDecoder.decodeGroups

                newLightGroups =
                    case possibleGroups of
                        Ok listGroups ->
                            listGroups

                        Err message ->
                            []
            in
                { model
                    | lightGroups = newLightGroups
                    , loading = False
                }
                    ! [ Cmd.none ]

        UpdateGroup (Err reason) ->
            { model | errorMessage = reason |> toString |> Just } ! [ Cmd.none ]

        UpdateSwitch result ->
            case result of
                Ok _ ->
                    model ! [ getGroups ]

                Err message ->
                    { model | errorMessage = Just (toString message) } ! [ getGroups ]

        Refresh ->
            model ! [ getGroups ]


getGroups : Cmd Msg
getGroups =
    let
        request =
            String.join "/" [ baseAPIUrl, "groups" ] |> HueDecoder.getGroups
    in
        Http.send UpdateGroup request


type Switch
    = On
    | Off


offSignal : String -> Cmd Msg
offSignal groupId =
    Http.send UpdateSwitch (sendSignal Off groupId)


onSignal : String -> Cmd Msg
onSignal groupId =
    Http.send UpdateSwitch (sendSignal On groupId)


sendSignal : Switch -> String -> Http.Request Json.Decode.Value
sendSignal switch groupId =
    let
        url =
            [ baseAPIUrl, "groups", groupId, "action" ]
                |> String.join "/"

        signalJson =
            let
                light =
                    case switch of
                        On ->
                            True

                        Off ->
                            False
            in
                Json.Encode.object
                    [ ( "on", Json.Encode.bool light )
                    ]

        put url body =
            Http.request
                { method = "PUT"
                , headers = []
                , url = url
                , body = body
                , expect = Http.expectJson Json.Decode.value
                , timeout = Nothing
                , withCredentials = False
                }
    in
        put url (Http.jsonBody signalJson)
