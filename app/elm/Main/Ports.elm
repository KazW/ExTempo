port module Main.Ports exposing (..)

--PORTS


port initPort : String -> Cmd msg


port openModal : String -> Cmd msg


port closeModal : String -> Cmd msg


port updateTextFields : String -> Cmd msg
