module Msg exposing (..)
import Browser.Dom exposing (Viewport)



type SysMsg
    = Resize Int Int
    | GetViewport Viewport
    | Tick Float
    | MoveLeft Bool
    | MoveRight Bool
    | Noop

type alias GameMsg =
    {
        geoMsg : GeometryMsg,
        aniMsg : AnimationMsg
    }

type alias GeometryMsg =
    {
        scale : Float,
        velocity : (Float,Float),
        rotSpeed : Float
    }

genGeometryMsg : Float -> (Float,Float) -> Float -> GeometryMsg
genGeometryMsg scale velocity rotSpeed =
    GeometryMsg scale velocity rotSpeed

type alias AnimationMsg =
    {
        index : Int,
        cmd : AniCmd,
        loop : Bool
    }

genAnimationMsg : Int -> AniCmd -> Bool -> AnimationMsg
genAnimationMsg index cmd loop =
    AnimationMsg index cmd loop

type AniCmd
    = AniStart
    | AniStop
    | AniNone

genAniMsg : Int -> AniCmd -> Bool -> AnimationMsg
genAniMsg index cmd loop =
     AnimationMsg index cmd loop

type alias SoundMsg =
     {
         index:Int,
         cmd:SoundCmd,
         loop:Bool
     }

type SoundCmd
    = SoundStart
    | SoundStop
    | SoundNone

genSoundMsg: Int -> SoundCmd -> Bool ->SoundMsg
genSoundMsg index cmd loop =
     SoundMsg index cmd loop
