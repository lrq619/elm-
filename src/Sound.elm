module Sound exposing (..)

import State exposing (SoundState(..))
import Msg exposing (SoundCmd(..),SoundMsg,genSoundMsg)


type alias Sound =
    {
        state:SoundState,
        srcLib :String,
        length:Float,
        loop : Bool,
        passedTime:Float
    }

genSound: String -> Float -> Sound
genSound  srcLib length=
    Sound SoundStopped srcLib length False 0

receiveSoundMsg: Maybe SoundMsg -> Sound -> Sound
receiveSoundMsg msg sound =
    let
        msg_ = case msg of
            Just m ->
                m
            Nothing ->
                genSoundMsg 0 SoundNone False
        cmd = msg_.cmd
        loop_=msg_.loop
        state =
            case cmd of
                SoundStart ->
                    SoundPlaying
                SoundStop->
                    SoundStopped
                SoundNone ->
                    sound.state
    in
        case msg of
            Just m ->
                { sound | state = state, loop = loop_ }
            Nothing ->
                sound

doSound: Float -> Sound -> Sound
doSound elapsed sound =
    case sound.state of
        SoundStopped ->
            sound
        SoundPlaying ->
            sound
                |> addTime elapsed
                |> returnZero

addTime : Float -> Sound -> Sound
addTime elapsed sound =
    let
        t=sound.passedTime + elapsed
    in
        { sound | passedTime = t }

returnZero :Sound -> Sound
returnZero sound =
    let
        (passedTime_,state) =
                if sound.passedTime <= sound.length then
                    (sound.passedTime,sound.state)
                else
                    (0,SoundStopped)
    in
        {sound | passedTime = passedTime_,state=state }