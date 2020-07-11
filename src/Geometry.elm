module Geometry exposing (..)
import Msg exposing (GeoCmd(..), GeometryMsg, genGeometryMsg)
import State exposing (GeometryState(..))
type alias Geometry =
    {x : Float,
     y : Float,
     w : Float,
     h : Float,

     v : (Float,Float),

     passedTime : Float,
     state : GeometryState,
     length : Float
    }

genGeometry : Float  -> Float -> Float -> Float-> (Float,Float)-> Geometry
genGeometry x y w h v  =
    Geometry x y w h v  0 GeoStopped 800

receiveGeoMsg : GeometryMsg -> Geometry -> Geometry
receiveGeoMsg msg geo =
    let

        v = msg.velocity
        l = msg.length

        state=
            case msg.cmd of
                GeoStart ->
                    GeoPlaying
                GeoStop ->
                    GeoStopped
                GeoNone ->
                    geo.state
    in
        if msg.cmd == GeoNone then
            geo
        else
            { geo | v=v,length = l,state=state }



doTranslation : Float -> Geometry -> Geometry
doTranslation elapsed geo =
    case geo.state of
        GeoStopped ->
            geo
        GeoPlaying ->
            geo
                |> addTime elapsed
                |> move elapsed
                |> returnZero

addTime : Float -> Geometry -> Geometry
addTime elapsed geo =
    let
        t=geo.passedTime + elapsed
    in
        { geo | passedTime = t }


move : Float -> Geometry -> Geometry
move elapsed geo =
    let
        (vx,vy)=geo.v
        (x_,y_)=(geo.x+vx*elapsed,geo.y+vy*elapsed)

    in
        { geo | x=x_,y=y_ }

returnZero :Geometry -> Geometry
returnZero geo =
    let
        (passedTime,state) =
                if geo.passedTime <= geo.length then
                    (geo.passedTime,geo.state)
                else
                    (0,GeoStopped)
    in
        { geo | passedTime = passedTime,state=state }



