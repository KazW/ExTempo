module Main.Views exposing (view)

import Main.Models as Models exposing (..)
import Main.Views.Header exposing (headerView)
import Main.Views.Editing exposing (editingView)
import Main.Views.Reviewing exposing (reviewingView)
import Main.Views.Speaking exposing (speakingView)
import Html exposing (..)
import Html.Attributes exposing (..)


view : Model -> Html Msg
view model =
    div [ id "wrapper" ]
        [ headerView model
        , editingView model
        , content model
        ]


content : Model -> Html Msg
content model =
    if model.action == Speaking then
        speakingView model
    else
        reviewingView model
