module Main.Views.Editing exposing (editingView)

import Main.Models as Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


modalHeaderText : Model -> String
modalHeaderText model =
    case model.newEntry.entryType of
        TalkType ->
            if model.talk.duration > 0 then
                "Edit Talk"
            else
                "Plan a Talk"

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
                [ div [ class "input-field col s6" ]
                    [ input
                        [ id "title-field"
                        , value model.newEntry.title
                        , type_ "text"
                        , onInput (\data -> UserInput (Title data))
                        ]
                        []
                    , label [ for "title-field" ] [ text "Title" ]
                    ]
                , div [ class "input-field col s6" ]
                    [ input
                        [ id "minutes-field"
                        , value (toString model.newEntry.minutes)
                        , type_ "text"
                        , onInput (\data -> UserInput (Minutes data))
                        ]
                        []
                    , label [ for "title-field" ] [ text "Minutes" ]
                    ]
                , div [ class "input-field col s6" ]
                    [ input
                        [ id "seconds-field"
                        , value (toString model.newEntry.seconds)
                        , type_ "text"
                        , onInput (\data -> UserInput (Seconds data))
                        ]
                        []
                    , label [ for "title-field" ] [ text "Seconds" ]
                    ]
                ]
            ]
        , div [ class "modal-footer" ]
            [ a
                [ class "waves-effect waves-red btn-flat"
                , onClick ClearEntry
                ]
                [ i [ class "material-icons" ]
                    [ text "clear" ]
                ]
            , a
                [ class "waves-effect waves-green btn-flat"
                , onClick ValidateEntry
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
            p [ class "caption", style [ ( "color", "red" ) ] ] [ text error ]
