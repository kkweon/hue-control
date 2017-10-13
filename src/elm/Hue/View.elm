module Hue.View exposing (view)

import Hue.Model exposing (Model)
import Html
    exposing
        ( text
        , button
        , p
        , div
        , h2
        , h4
        , input
        , ul
        , li
        , span
        , i
        , Html
        )
import Html.Attributes
    exposing
        ( class
        , value
        , type_
        )
import Html.Events exposing (onClick)
import Hue.Update exposing (Msg(..))
import Hue.HueDecoder exposing (LightGroup)


view : Model -> Html.Html Msg
view model =
    let
        loadingView =
            if model.loading then
                div [ class "mdl-spinner mdl-js-spinner is-active" ] []
            else
                text ""

        title =
            h2 [ class "display-3" ] [ text "Elise's Home Control" ]

        refreshButton =
            button
                [ class "mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect refresh-btn"
                , onClick Refresh
                ]
                [ text "refresh", i [ class "material-icons" ] [ text "refresh" ] ]
    in
        div []
            [ title
            , refreshButton
            , loadingView
            , h4 [ class "display-3 sub-heading" ] [ text "Hue" ]
            , viewLightGroups model
            ]


viewLightGroups : Model -> Html.Html Msg
viewLightGroups model =
    model.lightGroups
        |> List.map viewSingleLightGroup
        |> ul [ class "two mdl-list" ]


viewSingleLightGroup : LightGroup -> Html Msg
viewSingleLightGroup lightgroup =
    let
        allLightOn =
            lightgroup.state.all_on

        anyLightOn =
            lightgroup.state.any_on

        ( action, icon ) =
            if anyLightOn then
                ( TurnOff, "wb_sunny" )
            else
                ( TurnOn, "lightbulb_outline" )

        liClass =
            "mdl-list__item mdl-list__item--two-line clickable list-item "
                ++ (if anyLightOn then
                        "light-on"
                    else
                        "light-off"
                   )
    in
        li [ class liClass, onClick (action lightgroup) ]
            [ span [ class "mdl-list__item-primary-content" ]
                [ text lightgroup.name
                ]
            , span
                [ class "mdl-list__item-secondary-content"
                ]
                [ span [ class "mdl-list__item-secondary-action" ]
                    [ i [ class "material-icons" ] [ text icon ]
                    ]
                ]
            ]
