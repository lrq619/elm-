module Animation exposing (..)
import BasicFunctions exposing (replace)
import State exposing (AnimationState(..))
import Msg exposing (AniCmd(..), AnimationMsg, genAnimationMsg)
type alias Animation =
    {
        state : AnimationState,
        stage : Int,
        srcLib : List String,
        passedTime : Float,
        delta : Float,
        loop : Bool
    }
genAnimation : List String -> Float -> Animation
genAnimation srcLib delta =
    Animation AniStopped 1 srcLib 0 delta True


receiveAniMsg : AnimationMsg -> Animation -> Animation
receiveAniMsg msg ani =
    let
        cmd = msg.cmd

        state =
            case cmd of
                AniStart ->
                    AniPlaying
                AniStop ->
                    AniStopped
                AniNone ->
                    ani.state

        loop = msg.loop
    in
    if ani.state == AniStopped then
        if msg.cmd == AniNone then
            ani
        else
           { ani | state = state, loop = loop }
    else
        ani

doAnimation : Float -> Animation -> Animation
doAnimation elapsed ani =
    case ani.state of
        AniStopped ->
            ani
        AniPlaying ->
            ani
                |> addTime elapsed
                |> changeStage
                |> returnZero




addTime : Float -> Animation -> Animation
addTime elapsed ani =
    let

        t=ani.passedTime + elapsed
    in
        { ani | passedTime = t }

changeStage : Animation -> Animation
changeStage ani =
    let
        stage =
             floor (ani.passedTime / ani.delta) + 1

    in
        { ani | stage = stage }

returnZero : Animation -> Animation
returnZero ani =
    let
        stage = ani.stage

        (passedtime_,state) =
            if ani.loop then
                if stage <= List.length ani.srcLib  then
                    (ani.passedTime,ani.state)
                else
                    (0,ani.state)
            else
                if stage <= List.length ani.srcLib then
                    (ani.passedTime,ani.state)
                else
                    (0,AniStopped)
    in
        {ani | passedTime = passedtime_,state=state }



