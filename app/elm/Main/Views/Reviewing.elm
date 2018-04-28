module Main.Views.Reviewing exposing (reviewingView)

import Main.Models exposing (..)
import Main.Views.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


reviewingView : Model -> Html Msg
reviewingView model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ h4 [ class "header" ]
                [ text "Talk Options    "
                , a
                    [ class "btn-floating btn-med waves-effect waves-light"
                    , onClick (EditEntry TalkType)
                    ]
                    [ i [ class "medium material-icons" ] [ text "edit" ] ]
                ]
            , p [ class "caption" ] [ text "Set the main topic and total duration, both are required." ]
            ]
        , div [ class "row" ]
            [ div [ class "row" ]
                [ div [ class "col s12 m4 right-align" ] [ h5 [ class "trimmed" ] [ text "Main Topic:" ] ]
                , div [ class "col s12 m8" ] [ p [] [ text model.talk.title ] ]
                ]
            , div [ class "row" ]
                [ div [ class "col s12 m4 right-align" ] [ h5 [ class "trimmed" ] [ text "Duration:" ] ]
                , div [ class "col s12 m8" ] [ p [] [ text (secondsToDuration model.talk.duration) ] ]
                ]
            ]
        , div [ class "row" ]
            [ h4 [ class "header" ]
                [ text "Sections    "
                , a
                    [ class "btn-floating btn-med waves-effect waves-light"
                    , onClick (EditEntry (SectionType Nothing))
                    ]
                    [ i [ class "medium material-icons" ] [ text "add" ] ]
                ]
            , p [ class "caption" ] [ text "Set the section topic and duration, both are required." ]
            ]
        ]
