module Main.Views.Speaking exposing (speakingView)

import Main.Models exposing (..)
import Main.Views.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


speakingView : Model -> Html Msg
speakingView model =
    div [ class "center" ] [ text (secondsToTime model.talkTime) ]
