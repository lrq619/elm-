module Msg exposing (..)
import Browser.Dom exposing (Viewport)



type SysMsg
    = Resize Int Int
    | GetViewport Viewport
    | Tick Float
    | MoveLeft
    | MoveRight
    | Noop

type alias GameMsg =
    {
        movMsg : MoveMsg,
        aniMsg : AnimationMsg

    }

type alias MoveMsg =
    {
        scale : Float,
        velocity : Float,
        dir : Float,
        rotSpeed : Float
    }

type alias AnimationMsg =
    {
        index : Int,
        cmd : AniCmd,
        loop : Bool
    }

type AniCmd
    = AniStart
    | AniStop
    | AniNone

genAniMsg : Int -> AniCmd -> Bool -> AnimationMsg
genAniMsg index cmd loop =
     AnimationMsg index cmd loop