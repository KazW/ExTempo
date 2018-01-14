module Main.Views.Reviewing exposing (reviewingView)

import Main.Models exposing (..)
import Main.Views.Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


reviewingView : Model -> Html Msg
reviewingView model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "col s4 right-align" ] [ h3 [ class "trimmed" ] [ text "Main Topic:" ] ]
            , div [ class "col s8" ] [ h3 [ class "trimmed" ] [ text model.talk.name ] ]
            ]
        , div [ class "row" ]
            [ div [ class "col s4 right-align" ] [ h3 [ class "trimmed" ] [ text "Duration:" ] ]
            , div [ class "col s8" ] [ h3 [ class "trimmed" ] [ text (secondsToDuration model.talk.duration) ] ]
            ]
        ]
