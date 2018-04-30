module Main.Views.Landing exposing (landingView)

import Main.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


landingView : Model -> Html Msg
landingView model =
    div [ class "row" ] []
