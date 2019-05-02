module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser exposing (..)

-- model

type alias Model = 
    { players : List Player
    , name : String
    , playerId : Maybe Int
    , plays : List Play
    }

type alias Player = 
    { id :Int
    , name : String
    , points : Int
    }

type alias Play = 
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }

initModel : Model
initModel =
    { players = []
    , name = ""
    , playerId = Nothing
    , plays = []
    }

-- Update

type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play

type alias RecordWithID a =
    { a | id : Int }

maxId : List (RecordWithID a) -> Int
maxId list =
    list
        |> List.map (.id)
        |> List.maximum
        |> Maybe.withDefault -1
        |> (+) 1

update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            { model | name = name }

        Save ->
            if model.name == "" then
                model
            else    
                { model | players = List.append model.players [ Player (maxId model.players) model.name 0 ], name = ""}

        Cancel ->
            { model | name = "", playerId = Nothing }

        _ ->
            model

-- view

view : Model -> Html Msg
view model =
    div [ class "scoreboard" ] 
        [   h1 [] [ text "Score Keeper" ]
        , playerForm model
        ]

playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ input 
            [ type_ "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value model.name
            ]
            []
        , button [ type_ "submit" ] [ text "Save" ]
        , button [ type_ "button", onClick Cancel ] [ text "Cancel" ]
        , p [] [ text (Debug.toString model ) ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }