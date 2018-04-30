module ExTempo.Time exposing (..)


secondsInMinute : Int
secondsInMinute =
    60


secondsInHour : Int
secondsInHour =
    3600


timeBreakdown : Int -> ( Int, Int, Int )
timeBreakdown time =
    ( secondsToHours time
    , remainingMinutes time
    , remainingSeconds time
    )


remainingSeconds : Int -> Int
remainingSeconds time =
    time % secondsInMinute


remainingMinutes : Int -> Int
remainingMinutes time =
    (time % secondsInHour) // secondsInMinute


secondsToMinutes : Int -> Int
secondsToMinutes time =
    time // secondsInMinute


secondsToHours : Int -> Int
secondsToHours time =
    time // secondsInHour


minutesToSeconds : Int -> Int
minutesToSeconds minutes =
    minutes * secondsInMinute
