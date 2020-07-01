module Color exposing (..)

type Color
  = Hex String
  | Rgb Int Int Int

renderColor : Color -> String
renderColor color =
  case color of
    Hex str ->
      str

    Rgb r g b ->
      "rgb(" ++ String.fromInt r ++ "," ++ String.fromInt g ++ "," ++ String.fromInt b ++ ")"