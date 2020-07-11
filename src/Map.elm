module Map exposing (..)
type alias Map =
    {
        barriers : List (Int,Int)
    }
genMap : Map
genMap =
    setBarrier barriers

setBarrier : List (Int,Int) -> Map
setBarrier lst =
    Map lst

barriers : List (Int,Int)
barriers =
    [

    ]

