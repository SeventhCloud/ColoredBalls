module Messages exposing (..)

import Mouse
import Keyboard
import Time exposing (..)

type Msg = MouseMsg Mouse.Position | KeyMsg Keyboard.KeyCode | Tick Time | RandNum (Int, (Int, Int))