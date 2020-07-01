module Animation exposing (..)
import State exposing (AnimationState(..))
import Msg exposing (AnimationMsg,AniCmd(..))
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


receiveAniMsg : Maybe AnimationMsg -> Animation -> Animation
receiveAniMsg msg ani =
    let
        msg_ = case msg of
            Just m ->
                m
            Nothing ->
                AnimationMsg 0 AniNone False
        cmd = msg_.cmd
        state =
            case cmd of
                AniStart ->
                    AniPlaying
                AniStop ->
                    AniStopped
                AniNone ->
                    ani.state

        loop = msg_.loop
    in
        case msg of
            Just m ->
                { ani | state = state, loop = loop }
            Nothing ->
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