module NPC exposing (..)
import Animation exposing (genAnimation)
import BasicFunctions exposing (getValue, unitSize)
import GameObject exposing (GameObject, genGameObj, locate)
import Geometry exposing (genGeometry)
type alias NPC =
    {
        obj : GameObject,
        talk : String
    }

genNPC : List String -> String -> (Int,Int) -> NPC
genNPC imgs talk pos =
    let
        down = case getValue imgs 1 of
            Just i ->
                i
            Nothing ->
                ""
        left = case getValue imgs 2 of
            Just i ->
                i
            Nothing ->
                ""
        right = case getValue imgs 3 of
            Just i ->
                i
            Nothing ->
                ""
        up = case getValue imgs 4 of
            Just i ->
                i
            Nothing ->
                ""
        geo =
            genGeometry 0 0 unitSize unitSize (0,0)
        ani_down =
            genAnimation [down] 1000000
        ani_left =
            genAnimation [left] 1000000
        ani_right =
            genAnimation [right] 1000000
        ani_up =
            genAnimation [up] 1000000
        obj = locate (genGameObj geo [ani_down,ani_left,ani_right,ani_up]) pos
    in
        NPC obj talk

path : String
path = "./static/character/"

elderPath : String
elderPath = "elder/"

genSrcLib : String -> List String
genSrcLib imgSrc =
    [
        path++imgSrc++"1.png",
        path++imgSrc++"2.png",
        path++imgSrc++"3.png",
        path++imgSrc++"4.png"
    ]

npcGroup : List NPC
npcGroup
    =  (genNPC (genSrcLib elderPath) "Hello!" (1,2))
    :: (genNPC (genSrcLib elderPath) "Have a nice day!" (2,4))
    :: (genNPC (genSrcLib elderPath) "Wow!" (7,7))
    ::[]

getObj : NPC -> GameObject
getObj npc =
    npc.obj

getTalk : NPC -> String
getTalk npc =
    npc.talk

checkSame : (Int,Int) -> NPC -> Bool
checkSame pos npc =
    npc.obj.pos == pos


