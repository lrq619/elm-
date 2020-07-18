module Main exposing (..)
import Browser.Events exposing (..)
import Html.Events

import Model exposing (..)
import View
import Update
import Browser
import Msg exposing (..)
import Browser.Dom exposing (Viewport,getViewport)
import Task exposing (Task)
import Json.Decode as Decode

{--
Main part of the program
--}
main=
    let
        init ()=
            (Model.genModel,Task.perform GetViewport Browser.Dom.getViewport )
    in
    Browser.element
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = subscriptions
        }
{--
subscriptions, used to deliver message to html.
--}
subscriptions : Model -> Sub SysMsg
subscriptions model =
    Sub.batch
        [
            onAnimationFrameDelta Tick
        , onKeyUp (Decode.map (key False) Html.Events.keyCode)
        , onKeyDown (Decode.map (key True) Html.Events.keyCode)
        , onResize Resize
        ]


key : Bool -> Int -> SysMsg
key on keyCode =
    case keyCode of
        13 ->
            Start on
        27 ->
            Pause on
        65 ->
            MoveLeft on
        87 ->
            MoveUp on
        68 ->
            MoveRight on
        83 ->
            MoveDown on
        75 ->
            Interact on


        _ ->
            Noop

