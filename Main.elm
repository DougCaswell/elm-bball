import Html exposing (..)

add a b =
    a + b

result =
    add 1 2 |> \a -> modBy 2 a == 0

main = 
    Html.text result