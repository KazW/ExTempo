module ExTempo.Views exposing (view)

import ExTempo.Models as Models exposing (..)
import ExTempo.Views.Header exposing (headerView)
import ExTempo.Views.Editing exposing (editingView)
import ExTempo.Views.Reviewing exposing (reviewingView)
import ExTempo.Views.Speaking exposing (speakingView)
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
    if model.action == Talking then
        speakingView model
    else
        reviewingView model
