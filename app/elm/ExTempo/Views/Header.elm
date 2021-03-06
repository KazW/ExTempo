module ExTempo.Views.Header exposing (headerView)

import ExTempo.Models exposing (..)
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
            else if model.talk.duration == 0 then
                "set main topic"
            else
                "start talk"

        button_action =
            if model.action == Talking then
                StopTalking
            else if model.talk.duration == 0 then
                EditEntry TalkType
            else
                StartTalking
    in
        a
            [ href "#"
            , class "waves-effect btn-large"
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
