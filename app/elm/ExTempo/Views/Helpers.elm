module ExTempo.Views.Helpers exposing (..)

import ExTempo.Time exposing (..)


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


secondsToDuration : Int -> String
secondsToDuration time =
    let
        ( hours, minutes, seconds ) =
            timeBreakdown time

        times =
            if hours > 0 then
                [ (toString hours)
                , "hours,"
                , (toString minutes)
                , "minutes,"
                , (toString seconds)
                , "seconds"
                ]
            else
                [ (toString minutes)
                , "minutes,"
                , (toString seconds)
                , "seconds"
                ]
    in
        String.join " " times


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
