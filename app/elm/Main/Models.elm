module Main.Models exposing (..)

import Time exposing (Time)


initModel : Flags -> Model
initModel flags_ =
    { currentTime = Nothing
    , apiUrl = flags_.apiUrl
    }



--MODELS


type alias Flags =
    { apiUrl : String }


type alias Model =
    { currentTime : Maybe Time
    , apiUrl : String
    }


type Msg
    = NoOp
    | Tick Time
