module Map exposing (..)
type alias Map =
    {
        barriers : List (Int,Int)
    }
genMap : Map
genMap =
    Map barriers


barriers : List (Int,Int)
barriers =
    [
    (1,2),(2,4)
    ]

trap_1_location : List (Int,Int)
trap_1_location =
    [
    (2,6),(3,6),(2,7),(3,7)
    ]

