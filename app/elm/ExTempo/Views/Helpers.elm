module ExTempo.Views.Helpers exposing (..)

import ExTempo.Models exposing (..)
import ExTempo.Time exposing (..)
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


stringToInt : String -> Int
stringToInt string =
    case String.toInt string of
        Err _ ->
            0

        Ok int ->
            if int < 0 then
                0
            else
                int


entriesDuration : Array { e | duration : Int } -> Int
entriesDuration entries =
    entries
        |> Array.map (\entry -> entry.duration)
        |> Array.toList
        |> List.sum


secondsToDuration : Int -> String
secondsToDuration time =
    let
        ( hours, minutes, seconds ) =
            timeBreakdown time

        hourString =
            withCount "hour" "hours" hours

        minuteString =
            withCount "minute" "minutes" minutes

        secondString =
            if hours == 0 && minutes == 0 && seconds == 0 then
                "0 seconds"
            else
                withCount "second" "seconds" seconds
    in
        [ hourString, minuteString, secondString ]
            |> List.filter (\time -> time /= "")
            |> String.join ", "


withCount : String -> String -> Int -> String
withCount singular plural count =
    if count == 0 then
        ""
    else
        (toString count)
            ++ " "
            ++ if count == 1 then
                singular
               else
                plural


padTime : String -> String
padTime time =
    time |> String.padLeft 2 '0'


secondsToTime : Int -> String
secondsToTime time =
    let
        ( hours, minutes, seconds ) =
            timeBreakdown time

        times =
            if hours > 0 then
                [ toString hours
                , padTime (toString minutes)
                , padTime (toString seconds)
                ]
            else
                [ toString minutes
                , padTime (toString seconds)
                ]
    in
        times |> String.join ":"


listToTable : List ( String, String ) -> Html Msg
listToTable list =
    table [ class "responsive-table" ] (List.map tupleToRow list)


tupleToRow : ( String, String ) -> Html Msg
tupleToRow ( cell1, cell2 ) =
    tr []
        [ td [ class "right" ] [ text cell1 ]
        , td [] [ text cell2 ]
        ]
