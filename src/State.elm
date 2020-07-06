module State exposing (..)
type GameState
    = GameStopped
    | GamePlaying
    | GamePause

type AnimationState
    = AniStopped
    | AniPlaying

type SoundState
    =SoundStopped
    | SoundPlaying