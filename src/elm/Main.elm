module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Hue.Hue as Hue
import Tplink.Tplink as Tplink


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        tplinkSub =
            Tplink.subscriptions model.tplinkModel
    in
        Sub.batch
            [ Sub.map TplinkMsg tplinkSub
            ]


type alias Model =
    { error : Maybe String
    , hueModel : Hue.Model
    , tplinkModel : Tplink.Model
    }


initModel : Model
initModel =
    { error = Nothing
    , hueModel = Hue.initModel
    , tplinkModel = Tplink.initModel
    }


init : ( Model, Cmd Msg )
init =
    let
        ( _, hueCmd ) =
            Hue.init
    in
        initModel ! [ Cmd.batch [ Cmd.map HueMsg hueCmd ] ]


type Msg
    = HueMsg Hue.Msg
    | TplinkMsg Tplink.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HueMsg hueMsg ->
            let
                ( hueModel, hueCmd ) =
                    Hue.update hueMsg model.hueModel
            in
                { model | hueModel = hueModel } ! [ Cmd.map HueMsg hueCmd ]

        TplinkMsg tplinkMsg ->
            let
                ( smallModel, smallCmd ) =
                    Tplink.update tplinkMsg model.tplinkModel
            in
                { model | tplinkModel = smallModel } ! [ Cmd.map TplinkMsg smallCmd ]


view : Model -> Html Msg
view model =
    div [ Attr.class "container" ]
        [ Html.map HueMsg (Hue.view model.hueModel)
        , Html.map TplinkMsg (Tplink.view model.tplinkModel)
        ]
