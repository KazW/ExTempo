module Main.Views.Helpers exposing (..)

import Main.Time exposing (..)


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
        minutes =
            secondsToMinutes time

        seconds =
            remainingSeconds time
    in
        (toString minutes) ++ " minutes, " ++ (toString seconds) ++ " seconds"


padTime : String -> String
padTime time =
    String.padLeft 2 '0' time


secondsToTime : Int -> String
secondsToTime time =
    let
        hours =
            secondsToHours time

        minutes =
            remainingMinutes time

        seconds =
            remainingSeconds time
    in
        if hours > 0 then
            padTime (toString hours) ++ ":" ++ padTime (toString minutes) ++ ":" ++ padTime (toString seconds)
        else
            padTime (toString minutes) ++ ":" ++ padTime (toString seconds)
