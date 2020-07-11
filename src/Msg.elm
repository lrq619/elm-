module Msg exposing (..)
import Browser.Dom exposing (Viewport)



type SysMsg
    = Resize Int Int
    | GetViewport Viewport
    | Tick Float
    | MoveLeft Bool
    | MoveRight Bool
    | Noop

type alias GameObjMsg =
    {
        geoMsg : GeometryMsg,
        aniMsg : AnimationMsg,
        cmd : ObjCmd
    }
type ObjCmd
    = ObjStart
    | ObjStop
    | ObjNone

genGameObjMsg : GeometryMsg -> AnimationMsg -> ObjCmd -> GameObjMsg
genGameObjMsg geoMsg aniMsg cmd=
    GameObjMsg geoMsg aniMsg cmd


type alias GeometryMsg =
    {
        velocity : (Float,Float),
        length : Float,
        cmd : GeoCmd
    }

genGeometryMsg : (Float,Float) -> Float  ->GeoCmd -> GeometryMsg
genGeometryMsg  velocity  length cmd =
    GeometryMsg velocity  length cmd


type GeoCmd
    = GeoStart
    | GeoStop
    | GeoNone

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
         index : Int,
         cmd : SoundCmd,
         loop : Bool
     }

type SoundCmd
    = SoundStart
    | SoundStop
    | SoundNone

genSoundMsg: Int -> SoundCmd -> Bool ->SoundMsg
genSoundMsg index cmd loop =
     SoundMsg index cmd loop
