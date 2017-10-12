port module Tplink.Tplink exposing (..)

import Html
    exposing
        ( Html
        , ul
        , li
        , h1
        , h4
        , div
        , text
        , span
        , i
        )
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Tplink.Decoder
    exposing
        ( Status
        , decodeStatus
        )
import Json.Decode


port turnOff : String -> Cmd msg


port turnOn : String -> Cmd msg


port receiveInfo : (Json.Decode.Value -> msg) -> Sub msg


tplinkIp : String
tplinkIp =
    "192.168.0.25"


type alias Model =
    { status : Maybe Status
    }


initModel =
    { status = Nothing }


type Msg
    = ReceiveInfo Json.Decode.Value
    | TurnOn
    | TurnOff


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveInfo json ->
            let
                status =
                    json |> Debug.log "[Elm] ReceiveInfo json" |> Json.Decode.decodeValue decodeStatus
            in
                case status of
                    Ok s ->
                        { model | status = Just s } ! [ Cmd.none ]

                    Err reason ->
                        model ! [ Cmd.none ]

        TurnOn ->
            model ! [ turnOn tplinkIp ]

        TurnOff ->
            model ! [ turnOff tplinkIp ]


view : Model -> Html Msg
view model =
    let
        ( status, alias_ ) =
            case model.status of
                Just s ->
                    ( s.relay_state, s.alias_ )

                Nothing ->
                    ( 0, "" )

        ( action, icon ) =
            if status == 1 then
                ( TurnOff, "wb_sunny" )
            else
                ( TurnOn, "lightbulb_outline" )

        colorClass =
            if status == 1 then
                "light-on"
            else
                "light-off"

        liClass =
            "mdl-list__item mdl-list__item--two-line clickable list-item " ++ colorClass
    in
        li [ class liClass, onClick action ]
            [ span [ class "mdl-list__item-primary-content" ]
                [ text alias_
                ]
            , span
                [ class "mdl-list__item-secondary-content"
                ]
                [ span [ class "mdl-list__item-secondary-action" ]
                    [ i [ class "material-icons" ] [ text icon ]
                    ]
                ]
            ]
            |> \x ->
                div []
                    [ h4 [ class "display-3 sub-heading" ]
                        [ text "TP-Link" ]
                    , ul
                        [ class "two mdl-list" ]
                        [ x ]
                    ]


subscriptions : Model -> Sub Msg
subscriptions model =
    receiveInfo ReceiveInfo
