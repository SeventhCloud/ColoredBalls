module Subscriptions exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Mouse exposing (..)
import Keyboard exposing (..)
import Time exposing (..)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.batch [
    Mouse.moves MouseMsg,
    Keyboard.downs KeyMsg,
    Time.every (Time.millisecond * 30) Tick
    ]