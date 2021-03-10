module View exposing (..)

import Html exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Color exposing (..)
import Text exposing (..)

view : Model -> Html Msg
view model = div [ ] [ 
    --(fromString model.info) |> leftAligned|> toHtml,
    collage model.fieldInfo.width model.fieldInfo.height (getFieldFormList model) |> toHtml, 
    collage model.fieldInfo.width (model.fieldInfo.colorSize * 2) (getDisplayFormList model) |> toHtml,
    --collage model.fieldInfo.width 100 (getLivesFormList model) |> toHtml,
    collage model.fieldInfo.width 100 model.lives |> toHtml,
    collage 50 50 (getScoreForm model) |> toHtml]

{-getLivesFormList : Model -> List Form
getLivesFormList model = List.map (getLiveForm 50 model.fieldInfo) (List.range 0 (model.lives - 1))
-}
{-getLiveForm : Int -> FieldInfo -> Int -> Form
getLiveForm r fieldInfo i =  circle (toFloat r) |> filled red |> moveX (getFormX fieldInfo (i * 2 * r + r))
-}

getFieldFormList : Model -> List Form
getFieldFormList model = [
    rect (toFloat model.fieldInfo.width) (toFloat model.fieldInfo.height) |> 
    filled black ] ++ List.map (getBallForm model.fieldInfo) model.balls

getScoreForm : Model -> List Form
getScoreForm model = [move (0,0) <| Collage.text (Text.height 50 (fromString (toString model.points) |> Text.color green))]

getDisplayFormList : Model -> List Form
getDisplayFormList model = 
    [ rect (toFloat model.fieldInfo.width) (model.fieldInfo.colorSize * 2 |> toFloat) |> filled gray ] ++
    List.indexedMap (getDisplayForm model.fieldInfo) model.colorChooser ++
    [ circle (toFloat model.fieldInfo.colorSize) |> filled model.currColor |> moveX (getFormX model.fieldInfo (model.fieldInfo.width - model.fieldInfo.colorSize)) ]

getBallForm : FieldInfo -> Ball -> Form
getBallForm fieldInfo ball  = 
    circle ( toFloat ball.r ) |>
    filled ball.color |>
    move (getFormX fieldInfo ball.x, getFormY fieldInfo ball.y)

getDisplayForm : FieldInfo -> Int -> Color -> Form
getDisplayForm fieldInfo pos color = 
    circle (toFloat fieldInfo.colorSize) |> 
    filled color |> 
    moveX (getFormX fieldInfo (pos * fieldInfo.colorSize * 2 + fieldInfo.colorSize))

getFormX : FieldInfo -> Int -> Float
getFormX fieldInfo x = -fieldInfo.width // 2 + x |> toFloat

getFormY : FieldInfo -> Int -> Float
getFormY fieldInfo y = -fieldInfo.height // 2 + y |> toFloat

getTotalHeight : Model -> Int
getTotalHeight model = model.fieldInfo.height + model.fieldInfo.colorSize