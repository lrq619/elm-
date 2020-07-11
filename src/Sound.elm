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

receiveSoundMsg: SoundMsg -> Sound -> Sound
receiveSoundMsg msg sound =
    let

        cmd = msg.cmd
        loop_=msg.loop
        state =
            case cmd of
                SoundStart ->
                    SoundPlaying
                SoundStop->
                    SoundStopped
                SoundNone ->
                    sound.state
    in
        if msg.cmd == SoundNone then
            sound
        else
            { sound | state = state, loop = loop_ }


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