module ExTempo.Views.Helpers exposing (..)

import ExTempo.Time exposing (..)
import Array exposing (..)


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
            if hours > 0 then
                (toString hours) ++ " hours"
            else
                ""

        minuteString =
            if minutes > 0 then
                (toString minutes) ++ " minutes"
            else
                ""

        secondString =
            if seconds > 0 then
                (toString seconds) ++ " seconds"
            else if hours == 0 && minutes == 0 then
                "0 seconds"
            else
                ""
    in
        [ hourString, minuteString, secondString ]
            |> List.filter (\time -> time /= "")
            |> String.join ", "


padTime : String -> String
padTime time =
    String.padLeft 2 '0' time


secondsToTime : Int -> String
secondsToTime time =
    let
        ( hours, minutes, seconds ) =
            timeBreakdown time

        times =
            if hours > 0 then
                [ padTime (toString hours)
                , padTime (toString minutes)
                , padTime (toString seconds)
                ]
            else
                [ padTime (toString minutes)
                , padTime (toString seconds)
                ]
    in
        String.join ":" times
