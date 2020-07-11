module GameObject exposing (..)
import Animation exposing (Animation, doAnimation, genAnimation, receiveAniMsg)
import BasicFunctions exposing (getValue, posToRealPos, replace)
import Geometry exposing (Geometry, doTranslation, genGeometry, receiveGeoMsg)
import Map exposing (Map)
import Msg exposing (AnimationMsg, GeometryMsg)
import State exposing (AnimationState(..))
type alias GameObject =
    {geometry : Geometry,
     actIndex : Int,
     actions : List Animation,
     state : GameObjectState,
     passedTime : Float,
     length : Float,
     pos :  (Int,Int)

    }

type GameObjectState
    = ObjPlaying
    | ObjStopped

genGameObj : Geometry-> List Animation -> GameObject
genGameObj geo animations =
    GameObject geo 1 animations ObjStopped 0 0 (0,0)

addObjTime : Float -> GameObject -> GameObject
addObjTime elapsed obj =
    let
        t=obj.passedTime + elapsed
    in
        { obj | passedTime = t }

returnObjZero : GameObject -> GameObject
returnObjZero obj =
    let
        (passedTime,state) =
            (0,ObjStopped)
        (vX,vY) = obj.geometry.v
        (x,y) = obj.pos
        x_ =
            if vX > 0 then
                1
            else if vX < 0 then
                -1
            else
                0
        y_ =
            if vY > 0 then
                1
            else if vY < 0 then
                -1
            else
                0
        pos_ = (x+x_,y+y_)
        obj_ = locate pos_ obj
    in
        if obj.passedTime <= obj.length then
            obj
        else
            { obj_ | passedTime = passedTime,state=state }

calLength : GameObject -> GameObject
calLength gameObj =
    let
        ani = case (getValue gameObj.actions gameObj.actIndex) of
            Just a ->
                a
            Nothing ->
                genAnimation [] 0
        l = toFloat (List.length ani.srcLib) * ani.delta
    in
          { gameObj | length = l }

act : AnimationMsg -> Float -> GameObject -> GameObject
act aniMsg elapsed gameObj =
    let
        ani = case (getValue gameObj.actions gameObj.actIndex) of
                Just a ->
                    a
                Nothing ->
                    genAnimation [] 1
        ani_ =
            ani
                |> receiveAniMsg aniMsg
                |> doAnimation elapsed
        actions_ = replace gameObj.actions gameObj.actIndex ani_
        index_ =
            if ani_.state == AniStopped then
                1
            else
                gameObj.actIndex

    in
        { gameObj | actions = actions_,actIndex=index_ }


translate : GeometryMsg -> Float -> GameObject -> GameObject
translate geoMsg elapsed gameObj =
    let
        geo = gameObj.geometry
        geo_ =
            geo
                |> receiveGeoMsg geoMsg
                |> doTranslation elapsed
    in
        { gameObj | geometry = geo_ }


changeNormal : Bool-> List String -> GameObject -> GameObject
changeNormal bool srcLib obj =
    let
        normal = genAnimation srcLib 100000
        actions=replace obj.actions 1 normal
    in
        if bool then
            { obj | actions=actions }
        else
            obj

locate : (Int,Int) -> GameObject -> GameObject
locate (xP,yP) gameObj =
    let
        (x,y) = posToRealPos (xP,yP)
        geo = gameObj.geometry
        geo_ = { geo | x = x, y = y }
    in
    { gameObj | pos=(xP,yP),geometry = geo_ }

checkBarrier : Map -> GameObject -> (Int,Int) -> Bool
checkBarrier map gameObj (vX,vY) =
    let
        (x,y) = gameObj.pos
        (x_,y_) = (x+vX,y+vY)
    in
        List.member (x_,y_) map.barriers
