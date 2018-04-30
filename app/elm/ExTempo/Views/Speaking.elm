module ExTempo.Views.Speaking exposing (speakingView)

import ExTempo.Models exposing (..)
import ExTempo.Views.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


speakingView : Model -> Html Msg
speakingView model =
    div []
        [ ul [ class "sidenav sidenav-fixed" ]
            [ li [ class "bold active" ]
                [ div [] [ text "Hello" ]
                ]
            ]
        , div [ class "center" ] [ text (secondsToTime model.talkTime) ]
        ]
