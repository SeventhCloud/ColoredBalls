import Html exposing (program)
import Messages exposing (..)
import Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Subscriptions exposing (..)
import Color exposing (..)
import Collage exposing (..)

init : ( Model, Cmd Msg )
init = ( { 
            fieldInfo = {
                width = 1000,
                height = 600,
                colorSize = 75
            },
            currColor = rgb 255 0 0,
            colorInfos = [  
                { color = rgb 255 0 0, code = 81, position = 0 }, 
                { color = rgb 0 255 0, code = 87, position = 1 },
                { color = rgb 0 0 255, code = 69, position = 2 }
            ],
            spawningColors = [
                rgb 0 0 255,
                rgb 0 85 170,
                rgb 0 170 85,
                rgb 0 255 0,
                rgb 85 85 85,
                rgb 85 170 0,
                rgb 170 85 0,
                rgb 255 0 0,
                rgb 170 0 85,
                rgb 85 0 170
            ],
            colorChooser = [ rgb 255 0 0, rgb 255 0 0, rgb 255 0 0 ],
            balls = [],
            info = "",
            spawnMul = 40,
            lives = [{url = "heart.png", width = 10, height = 10}, {url = "heart.png", width = 10, height = 10}, {url = "heart.png", width = 10, height =10}],
            points = 0,
            mixCode = 82
        }, Cmd.none )

main : Program Never Model Msg
main = program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
    }