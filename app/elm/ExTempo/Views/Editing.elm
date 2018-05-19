module ExTempo.Views.Editing exposing (editingView)

import ExTempo.Models as Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Events.Extra exposing (..)


modalHeaderText : Model -> String
modalHeaderText model =
    case model.newEntry.entryType of
        TalkType ->
            "Main Topic"

        SectionType index ->
            case index of
                Nothing ->
                    "Add Section"

                Just _ ->
                    "Edit Section"

        PointType _ index ->
            case index of
                Nothing ->
                    "Add Point"

                Just _ ->
                    "Edit Point"


editingView : Model -> Html Msg
editingView model =
    div [ id "editing-modal", class "modal" ]
        [ div [ class "modal-content" ]
            [ h4 [] [ text (modalHeaderText model) ]
            , errorMessage model
            , div [ class "row" ]
                [ div [ class "input-field col s12" ]
                    [ input
                        [ id "title-field"
                        , tabindex 1
                        , value model.newEntry.title
                        , type_ "text"
                        , onInput (\data -> UserInput (Title data))
                        , onEnter ValidateEntry
                        ]
                        []
                    , label [ for "title-field" ] [ text "Title" ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "input-field col s6" ]
                    [ input
                        [ id "minutes-field"
                        , tabindex 2
                        , value (toString model.newEntry.minutes)
                        , type_ "text"
                        , onInput (\data -> UserInput (Minutes data))
                        , onEnter ValidateEntry
                        ]
                        []
                    , label [ for "title-field" ] [ text "Minutes" ]
                    ]
                , div [ class "input-field col s6" ]
                    [ input
                        [ id "seconds-field"
                        , tabindex 3
                        , value (toString model.newEntry.seconds)
                        , type_ "text"
                        , onInput (\data -> UserInput (Seconds data))
                        , onEnter ValidateEntry
                        ]
                        []
                    , label [ for "title-field" ] [ text "Seconds" ]
                    ]
                ]
            ]
        , div [ class "modal-footer" ]
            [ a
                [ class "waves-effect waves-red btn-flat dark-red"
                , tabindex 5
                , onClick ClearEntry
                , onEnter ClearEntry
                ]
                [ i [ class "material-icons" ]
                    [ text "clear" ]
                ]
            , text " "
            , a
                [ class "waves-effect waves-green btn-flat dark-green"
                , tabindex 4
                , onClick ValidateEntry
                , onEnter ValidateEntry
                ]
                [ i [ class "material-icons" ]
                    [ text "check" ]
                ]
            ]
        ]


errorMessage : Model -> Html Msg
errorMessage model =
    case model.errorMessage of
        Nothing ->
            p [] [ text "Set the title (at least 1 character) and duration (at least 1 second)." ]

        Just error ->
            p [ class "caption red-text" ] [ text error ]
