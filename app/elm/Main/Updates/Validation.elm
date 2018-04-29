module Main.Updates.Validation exposing (isValidEntry, addErrors)

import Main.Models exposing (..)


isValidEntry : Model -> Bool
isValidEntry model =
    True


addErrors : Model -> Model
addErrors model =
    model
