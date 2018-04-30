module ExTempo.Views.Speaking exposing (speakingView)

import ExTempo.Models exposing (..)
import ExTempo.Views.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


speakingView : Model -> Html Msg
speakingView model =
    div [ class "center" ] [ text (secondsToTime model.talkTime) ]
