module Slideshow exposing (..)

import Browser
import Dict exposing (update)
import Html exposing (Html, div, section, text)
import Html.Attributes exposing (class, classList, style)
import Json.Decode as Decode exposing (Decoder, Value, field, string)
import Time


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


type alias Image =
    { url : String
    , description : String
    }


type alias Model =
    { images : List Image
    , currentImageIndex : Int
    }


initialModel : Model
initialModel =
    { images = [], currentImageIndex = 0 }


init : Value -> ( Model, Cmd Msg )
init flags =
    let
        images =
            case Decode.decodeValue imagesDecoder flags of
                Ok is ->
                    is

                Err _ ->
                    []
    in
    ( { initialModel | images = images }, Cmd.none )



-- UPDATE


type Msg
    = ChangeImage Time.Posix
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeImage _ ->
            let
                newImageIndex =
                    if model.currentImageIndex + 1 == List.length model.images then
                        0

                    else
                        model.currentImageIndex + 1
            in
            ( { model | currentImageIndex = newImageIndex }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


imagesDecoder : Decoder (List Image)
imagesDecoder =
    Decode.list imageDecoder


imageDecoder : Decoder Image
imageDecoder =
    Decode.map2 Image (field "url" string) (field "description" string)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 4000 ChangeImage



-- VIEW


view : Model -> Html Msg
view model =
    let
        currentImage =
            model.images
                |> List.drop model.currentImageIndex
                |> List.head
                |> (\maybeImage ->
                        case maybeImage of
                            Just image ->
                                image

                            Nothing ->
                                Image "" ""
                   )
    in
    section
        [ class "slidesContainer" ]
        (List.map (viewImage currentImage) model.images)


viewImage : Image -> Image -> Html Msg
viewImage currentImage image =
    div
        [ classList
            [ ( "slide", True )
            , ( "displayed", currentImage == image )
            ]
        ]
        [ div [ class "image", style "background-image" ("url('" ++ image.url ++ "')") ] []
        , div [ class "description" ] [ text image.description ]
        ]
