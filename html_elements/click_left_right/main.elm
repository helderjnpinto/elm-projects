module Sample exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (..)


type alias Model =
    { text : String
    , sideClicked : SideClicked
    }


type alias PointClicked =
    { pageX : Int
    , pointX : Int
    }


type SideClicked
    = Left
    | Right
    | None


main =
    Html.beginnerProgram
        { model = Model "Hello World!!" None
        , view = view
        , update = update
        }


type Msg
    = Clicked PointClicked


update : Msg -> Model -> Model
update msg model =
    case Debug.log "MSG" msg of
        Clicked point ->
            { model | sideClicked = sideOf point }



view : Model -> Html Msg
view model =
    let
        displayText =
            case model.sideClicked of
                Left ->
                    "Hello Left!"

                Right ->
                    "Hello Right!"

                None ->
                    "Hello World!"
    in
        Html.map Clicked <|
            div [ on "click" decodeClick, class "divSelection"  ] [ text <| toString model ]


decodeClick : Decoder PointClicked
decodeClick =
    Decode.map2 PointClicked
        (Decode.at ["view", "innerWidth"] Decode.int)
        (Decode.at ["pageX"] Decode.int)


sideOf : PointClicked -> SideClicked
sideOf {pageX, pointX} =
    if pointX < pageX // 2 then Left
    else Right
