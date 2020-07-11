module State exposing (..)
type GameState
    = GameStopped
    | GamePlaying
    | GamePause

type GeometryState
    = GeoStopped
    | GeoPlaying

type AnimationState
    = AniStopped
    | AniPlaying

type SoundState
    = SoundStopped
    | SoundPlaying