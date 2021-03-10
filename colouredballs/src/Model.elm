module Model exposing (..)

import Color exposing (..)
import Collage exposing (..)

type alias Ball = {
    x : Int,
    y : Int,
    r : Int,
    dx : Int,
    dy : Int,
    color : Color
}
type alias Image = { url : String , width : Int , height : Int }

type alias ColorInfo = {
    color : Color,
    code : Int,
    position : Int
}

type alias FieldInfo = {
    width : Int,
    height : Int,
    colorSize : Int
}

type alias ColorChooser = List Color

type alias Model = {
    currColor : Color,
    colorChooser : ColorChooser,
    spawningColors : List Color,
    colorInfos : List ColorInfo,
    fieldInfo : FieldInfo,
    balls : List Ball,
    info : String,
    spawnMul : Int,
    lives : List Image,
    points : Int,
    mixCode : Int

    
}