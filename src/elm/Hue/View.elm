module Hue.View exposing (view)

import Material
import Material.Card as Card
import Material.Color as Color
import Material.Grid exposing (grid, cell, size, Device(..))
import Material.Button as Button
import Material.Spinner as Loading
import Material.Scheme
import Material.Options as Options exposing (css)
import Material.Typography as Typo
import Hue.Model exposing (Model)
import Html exposing (text, p, div)
import Hue.Update exposing (Msg(..))
import Hue.HueDecoder exposing (LightGroup)



view : Model -> Html.Html Msg
view model =
    let
        loadingView =
            if model.loading then
                [ Loading.spinner [ Loading.active model.loading ] ]
                    |> cell [ size All 12 ]
            else
                cell [ size All 12 ]
                    [ text ""
                    ]

        title =
            cell [ size All 12 ]
                [ Options.styled p
                    [ Typo.display2 ]
                    [ text "Light Groups" ]
                ]

        refreshButton =
            cell [ size All 12 ]
                [ Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.raised
                    , Button.colored
                    , Button.ripple
                    , Options.onClick Refresh
                    ]
                    [ text "Refresh" ]
                ]
    in
        [ title
        , refreshButton
        , loadingView
        , cell [ size All 12 ] [ viewLightGroups model ]
        ]
            |> grid []
            |> Material.Scheme.top


viewLightGroups : Model -> Html.Html Msg
viewLightGroups model =
    model.lightGroups
        |> List.map viewSingleLightGroup
        |> div []


white : Options.Property c m
white =
    Color.text Color.white


viewSingleLightGroup : LightGroup -> Html.Html Msg
viewSingleLightGroup lightgroup =
    let
        allLightOn =
            lightgroup.state.all_on

        anyLightOn =
            lightgroup.state.any_on

        color =
            if allLightOn then
                Color.color Color.Blue Color.S600
            else
                (if anyLightOn then
                    Color.color Color.BlueGrey Color.S600
                 else
                    Color.color Color.Grey Color.S600
                )

        action =
            if anyLightOn then
                TurnOff
            else
                TurnOn
    in
        Card.view
            [ css "width" "100%"
            , Color.background (color)
            , css "margin-bottom" "2%"
            , Options.onClick <| action lightgroup
            ]
            [ Card.title
                [ css "align-content" "flex-start"
                , css "flex-direction" "row"
                , css "align-items" "flex-start"
                , css "justify-content" "space-between"
                ]
                [ Options.div
                    []
                    [ Card.head [ white ] [ text lightgroup.name ]
                    , Card.subhead [ white ] [ text <| toString anyLightOn ]
                    ]
                ]
            ]
