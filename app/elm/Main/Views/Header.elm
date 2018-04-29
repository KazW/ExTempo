module Main.Views.Header exposing (headerView)

import Main.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


headerText : Model -> String
headerText model =
    if model.action == Talking then
        model.talk.title
    else
        "Plan a Talk"


headerButton : Model -> Html Msg
headerButton model =
    let
        button_text =
            if model.action == Talking then
                "stop talk"
            else
                "start talk"

        button_action =
            if model.action == Talking then
                StopTalking
            else
                StartTalking
    in
        a
            [ href "#"
            , class "waves-effect waves-light btn-large"
            , onClick button_action
            ]
            [ text button_text
            ]


headerView : Model -> Html Msg
headerView model =
    header []
        [ nav
            [ class ""
            , attribute "role" "navigation"
            ]
            (headerNav model)
        ]


headerNav : Model -> List (Html Msg)
headerNav model =
    if model.talk.duration > 0 then
        [ div [ class "nav-wrapper" ]
            [ span
                [ class "brand-logo center"
                ]
                [ text (headerText model)
                ]
            , ul [ class "right" ]
                [ li []
                    [ headerButton model
                    ]
                ]
            ]
        ]
    else
        []
