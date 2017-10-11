module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Hue.Hue as Hue


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { error : Maybe String
    , hueModel : Hue.Model
    }


initModel : Model
initModel =
    { error = Nothing
    , hueModel = Hue.initModel
    }


init : ( Model, Cmd Msg )
init =
    let
        ( _, hueCmd ) =
            Hue.init
    in
        initModel ! [ Cmd.map HueMsg hueCmd ]


type Msg
    = HueMsg Hue.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HueMsg hueMsg ->
            let
                ( hueModel, hueCmd ) =
                    Hue.update hueMsg model.hueModel
            in
                { model | hueModel = hueModel } ! [ Cmd.map HueMsg hueCmd ]


view : Model -> Html Msg
view model =
    div [ Attr.class "container" ]
        [ Html.map HueMsg (Hue.view model.hueModel)
        ]
