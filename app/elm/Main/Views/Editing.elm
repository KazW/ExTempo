module Main.Views.Editing exposing (editingView)

import Main.Models as Models exposing (Model, Msg)
import Html exposing (..)
import Html.Attributes exposing (..)


editingView : Model -> Html Msg
editingView model =
    div [ class "center" ] [ text "Editing Modal" ]
