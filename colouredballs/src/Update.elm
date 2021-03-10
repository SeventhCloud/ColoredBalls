module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Color exposing (..)
import Random exposing (..)
import List.Extra exposing (..)
import Collage exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    MouseMsg position -> ( updateOnMouseMove model position.x position.y, Cmd.none )
    KeyMsg code -> ( updateOnKeyPress model code, Cmd.none )

    Tick time -> ( 
        { model | 
            balls = updateBalls (removeOutsideBalls model.balls model.fieldInfo.width model.fieldInfo.height), 
            lives = if checkIfBallsOutside model.balls model.fieldInfo.width model.fieldInfo.height then removeHeart model.lives else model.lives 
        }, Random.generate RandNum (Random.pair (Random.int 0 (getUpperRand model)) (Random.pair (Random.int -5 5) (Random.int -5 5))) 
    )

    RandNum (num, (dx, dy)) -> ( 
        { model | 
            balls = if num < List.length model.spawningColors then appendBall model.balls model.fieldInfo model.spawningColors num dx dy else model.balls 
        }, Cmd.none 
    )

{-remove Heart-}
removeHeart : List Form -> List Form
removeHeart lst = case lst of
 x::xs -> xs
 _ -> []

{- When the mouse moves the following model properties have to be updated:
1. List of balls present on the field
2. Points collected -}
updateOnMouseMove : Model -> Int -> Int -> Model
updateOnMouseMove model mouseX mouseY = 
    { model | 
        balls = updateBallsOnMouseMove model.balls mouseX (model.fieldInfo.height - mouseY) model.currColor,
        points = updatePointsOnMouseMove model.points model.balls mouseX (model.fieldInfo.height - mouseY) model.currColor }

{- Update the list of balls present on the field on mouse move:
If the mouse hovers over a ball and the current color is the same as the color of the ball the ball is removed. -}
updateBallsOnMouseMove : List Ball -> Int -> Int -> Color -> List Ball
updateBallsOnMouseMove balls mouseX mouseY currColor = 
    List.Extra.filterNot 
        (\ball -> (mouseX - ball.x) ^ 2 + (mouseY - ball.y) ^ 2 <= ball.r ^ 2 && ball.color == currColor) 
        balls

{- Update points collected on mouse move:
If the mouse hovers over a ball and the current color is the same as the color of the ball a point is added. -}
updatePointsOnMouseMove : Int -> List Ball -> Int -> Int -> Color -> Int
updatePointsOnMouseMove points balls mouseX mouseY currColor =  
    points + 
        List.length
            (List.filter (\ball -> (mouseX - ball.x) ^ 2 + (mouseY - ball.y) ^ 2 <= ball.r ^ 2 && ball.color == currColor) balls)

{- When a key is pressed the following model properties have to be updated:
1. The current color selection (if a color selection button is pressed)
2. The current color (if the mix button is pressed) -}
updateOnKeyPress : Model -> Int -> Model 
updateOnKeyPress model code =
    if code == model.mixCode 
        then { model | currColor = getMixedColor model.colorChooser }
        else { model | colorChooser = updateColorChooser model.colorChooser model.colorInfos code }

{-Update color chooser upon key press.-}
updateColorChooser : ColorChooser -> List ColorInfo -> Int -> ColorChooser
updateColorChooser colorChooser colorInfo code =
    List.drop 1 colorChooser ++ [ getColorFromKeyCode colorInfo code ]

{-Get the color that is mixed upon invoking the color chooser.-}
getMixedColor : ColorChooser -> Color
getMixedColor colorChooser = 
    let 
        len = List.length colorChooser 
    in rgb 
        ((List.sum (List.map getRed colorChooser)) // len)
        ((List.sum (List.map getGreen colorChooser)) // len)
        ((List.sum (List.map getBlue colorChooser)) // len)

getRed : Color -> Int
getRed color = (toRgb color).red

getBlue : Color -> Int
getBlue color = (toRgb color).blue

getGreen : Color -> Int
getGreen color = (toRgb color).green

{- Maybe useful Later on 

checkIfBallKilled : List Ball -> Int -> Int -> Color -> Bool
checkIfBallKilled balls posX posY currColor = 
    List.any (\ball -> (posX - ball.x) ^ 2 + (posY - ball.y) ^ 2 < ball.r^2 && ball.color == currColor) balls
-}

{-Update the list of balls present on the field after a mouse click.-}
updateBallsAfterClick : List Ball -> Int -> Int -> Color -> List Ball
updateBallsAfterClick balls mouseX mouseY currColor = 
    List.filter 
        (\ball -> (mouseX - ball.x) ^ 2 + (mouseY - ball.y) ^ 2 >= ball.r^2 || ball.color /= currColor) 
        balls

{-Get the color of a color info list by key code. Returns white if the key code does not exist.-}
getColorFromKeyCode : List ColorInfo -> Int -> Color
getColorFromKeyCode colorInfos code = 
   case List.Extra.find (\colorInfo -> colorInfo.code == code) colorInfos of
       Just colorInfo -> colorInfo.color
       Nothing -> white

{-Update balls present on the field for the next frame.-}
updateBalls : List Ball -> List Ball
updateBalls list = List.map updateBall list

updateBall : Ball -> Ball
updateBall ball = { ball | x = ball.x + ball.dx, y = ball.y + ball.dy }

{-Remove all balls that have left the field.-}
removeOutsideBalls : List Ball -> Int -> Int -> List Ball
removeOutsideBalls balls w h = 
    List.filter 
        (ballIsInside w h)
        balls

{-Check whether any balls have left the field.-}
checkIfBallsOutside : List Ball -> Int -> Int -> Bool
checkIfBallsOutside balls w h = 
    List.any 
        (ballIsInside w h >> not)
        balls

{-Get the color of a color info list by index. Returns white if the index does not exist.-}
getColorFromIndex : List Color -> Int -> Color
getColorFromIndex list i = case List.Extra.getAt i list of 
    Just color -> color
    Nothing -> white

{-Checks if a ball is inside the field.-}
ballIsInside : Int -> Int -> Ball -> Bool
ballIsInside w h ball = 
    ball.x >= 0 && ball.x < w && ball.y >= 0 && ball.y < h

getUpperRand : Model -> Int
getUpperRand model = 
    List.length model.spawningColors * model.spawnMul

appendBall : List Ball -> FieldInfo -> List Color -> Int -> Int -> Int -> List Ball
appendBall list fieldInfo colors num dx dy = 
    list ++ [{ x = fieldInfo.width // 2, y = fieldInfo.height // 2, r = 30, color = getColorFromIndex colors num, dx = dx, dy = if dx == 0 && dy == 0 then 1 else dy }]