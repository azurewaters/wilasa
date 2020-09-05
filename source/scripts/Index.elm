module Index exposing (main)

import Browser
import Browser.Events
import Element exposing (Attribute, Color, Element, Length, alignTop, centerX, centerY, column, el, explain, fill, height, image, layout, maximum, minimum, padding, paddingEach, paddingXY, paragraph, px, rgb255, spaceEvenly, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (bold, center, family, justify, size)
import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder, Value, field, int, map2)


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


type alias BaseSpace =
    Int


type alias BaseFontSize =
    Float


type alias Height =
    Int


type alias Width =
    Int


type alias WindowDimensions =
    { height : Int
    , width : Int
    }


windowDimensionsDecoder : Decoder WindowDimensions
windowDimensionsDecoder =
    Decode.map2 WindowDimensions (field "height" int) (field "width" int)


type alias Model =
    { windowDimensions : WindowDimensions
    , baseSpace : BaseSpace
    , baseFontSize : BaseFontSize
    }


init : Value -> ( Model, Cmd Msg )
init flags =
    let
        windowDimensions =
            case Decode.decodeValue windowDimensionsDecoder flags of
                Ok wD ->
                    wD

                Err _ ->
                    { height = 0, width = 0 }
    in
    ( { windowDimensions = windowDimensions
      , baseSpace = updateBaseSpace windowDimensions.width
      , baseFontSize = updateBaseFontSize windowDimensions.width
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = GotNewWindowDimensions Width Height


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNewWindowDimensions width height ->
            ( { model
                | windowDimensions = { height = height, width = width }
                , baseFontSize = updateBaseFontSize width
                , baseSpace = updateBaseSpace width
              }
            , Cmd.none
            )


updateBaseFontSize : Width -> BaseFontSize
updateBaseFontSize width =
    width
        |> Basics.toFloat
        |> (*) 0.01
        |> (+) 16
        |> min 36


updateBaseSpace : Width -> BaseSpace
updateBaseSpace width =
    width
        |> Basics.toFloat
        |> (*) 0.01
        |> (+) 16
        |> round
        |> min 40



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize GotNewWindowDimensions



-- VIEW


spaces : BaseSpace -> Int -> Int
spaces baseSpace multiple =
    baseSpace * multiple


spacesPx : BaseSpace -> Int -> Length
spacesPx baseSpace =
    spaces baseSpace >> px


scaledFontSize : BaseFontSize -> Int -> Int
scaledFontSize baseFontSize =
    Element.modular baseFontSize 1.25
        >> Basics.round


standardColours : { red : Color, brown : Color, offWhite : Color, lightGrey : Color, darkGrey : Color }
standardColours =
    { red = rgb255 193 36 44
    , brown = rgb255 194 166 117
    , offWhite = rgb255 242 234 223
    , lightGrey = rgb255 180 180 180
    , darkGrey = rgb255 13 13 13
    }


view : Model -> Html Msg
view model =
    layout
        [ Background.color standardColours.darkGrey ]
        (Element.column
            [ width fill ]
            [ header model.baseFontSize model.baseSpace
            , pictureSeparator model.baseSpace "images/elephantFrieze.jpg"
            , column
                [ centerX
                , paddingXY (spaces model.baseSpace 4) (spaces model.baseSpace 4)
                , spacing (spaces model.baseSpace 4)
                , width (fill |> maximum 800)
                ]
                [ overview model.baseFontSize model.baseSpace
                , theWilasaLife model.baseFontSize model.baseSpace
                , otherFeatures model.baseFontSize model.baseSpace
                , amenities model.baseFontSize model.baseSpace
                , pricing model.baseFontSize model.baseSpace
                , visitUs model.baseFontSize model.baseSpace
                ]
            , footer model.baseFontSize model.baseSpace
            ]
        )


header : BaseFontSize -> BaseSpace -> Element Msg
header baseFontSize baseSpace =
    column
        [ Background.color standardColours.red
        , height (fill |> minimum 600)
        , paddingXY 0 (spaces baseSpace 4)
        , spaceEvenly
        , width fill
        ]
        [ Element.image
            [ centerX
            , centerY
            , width (fill |> maximum 320)
            ]
            { src = "images/logoNoBackground.png", description = "Wilasa Logo" }
        , el
            [ alignTop
            , Border.color standardColours.offWhite
            , Border.solid
            , Border.width 1
            , Border.rounded 2
            , centerX
            , paddingXY (spaces baseSpace 1) (spaces baseSpace 1)
            ]
            (Element.link (centerY :: contentAttributes baseFontSize) { url = "tel:08047108861", label = text "CALL US ON 080 4710 8861" })
        ]


pictureSeparator : BaseSpace -> String -> Element Msg
pictureSeparator baseSpace src =
    el
        [ Background.image src
        , Border.solid
        , Border.color standardColours.darkGrey
        , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
        , height (spacesPx baseSpace 6)
        , width fill
        ]
        Element.none


overview : BaseFontSize -> BaseSpace -> Element Msg
overview baseFontSize baseSpace =
    column
        [ spacing (spaces baseSpace 2)
        ]
        [ sectionHeading baseFontSize "Overview"
        , contentParagraph baseFontSize "Wilasa is a serene, low-rise, ready-to-occupy housing complex just off Kanakapura Road, only a few hundred meters from the Konanakunte Signal. Only a hundred and thirty-four spacious apartments occupy the nearly five acre plot. With greenery all around — inside and outside your home — Wilasa gives you room to breathe, and indeed, revel in."
        ]


sectionHeading : BaseFontSize -> String -> Element Msg
sectionHeading baseFontSize title =
    paragraph
        [ Font.color standardColours.brown
        , Font.size (scaledFontSize baseFontSize 4)
        , Font.family
            [ Font.typeface "Source Serif Pro"
            ]
        ]
        [ text title ]


topicParagraph : BaseFontSize -> BaseSpace -> String -> List (Element Msg) -> Element Msg
topicParagraph baseFontSize baseSpace title content =
    column
        [ spacing (spaces baseSpace 2)
        ]
        (sectionHeading baseFontSize title :: content)


contentAttributes : BaseFontSize -> List (Attribute Msg)
contentAttributes baseFontSize =
    [ Font.color standardColours.offWhite
    , Font.size (scaledFontSize baseFontSize 1)
    , Font.family [ Font.typeface "Source Sans Pro" ]
    , spacing (scaledFontSize baseFontSize 1)
    ]


contentParagraph : BaseFontSize -> String -> Element Msg
contentParagraph baseFontSize content =
    paragraph (contentAttributes baseFontSize) [ text content ]


subheading : BaseFontSize -> String -> Element Msg
subheading baseFontSize content =
    el
        [ Font.color standardColours.offWhite
        , Font.size (scaledFontSize baseFontSize 1)
        , Font.family [ Font.typeface "Source Sans Pro" ]
        , Font.bold
        ]
        (text content)


theWilasaLife : BaseFontSize -> BaseSpace -> Element Msg
theWilasaLife baseFontSize baseSpace =
    topicParagraph baseFontSize
        baseSpace
        "The Wilasa Life"
        (List.map (contentParagraph baseFontSize)
            [ "We take pride in the greenery in Wilasa. Every home either has a garden or looks out onto one. The common areas host large swathes of green, landscaped gardens, giving us a sense of living amidst nature"
            , "The houses are between 2,000 and 4,000 sq. ft. in size, with either 3 or 4 bedrooms each. There's room enough in each of them to stretch your legs out, and also work without distractions."
            , "Wilasa has all the amenities that high-rise apartments offer, including a luxurious club-house, a well-equipped gym, a beautiful swimming pool, and 24-hour security and maintenance. However, each block rises only about 50 feet, and affords you almost the same amount of privacy that an individual home can offer. Thus, Wilasa strikes a balance between apartment living and individual-home living."
            ]
        )


otherFeatures : BaseFontSize -> BaseSpace -> Element Msg
otherFeatures baseFontSize baseSpace =
    topicParagraph baseFontSize
        baseSpace
        "Other Features"
        [ paragraph (contentAttributes baseFontSize)
            [ text "Other notable features include:"
            , column
                [ paddingEach { top = baseSpace, right = 0, left = baseSpace, bottom = 0 }
                , spacing (spaces baseSpace 2)
                ]
                (List.map (contentParagraph baseFontSize)
                    [ "• All vehicular traffic in Wilasa is underground, freeing up the area above for walks, play and community."
                    , "• Wilasa is located a 100 metres from the nearest metro station, a couple of hundred metres from a top-notch hospital, a few hundred metres from schools like Kumaran's and a couple of kilometres from Delhi Public School and The Valley School. The upcoming Forum Mall and Mantri Mall are minutes away, as is NICE road."
                    , "• Wilasa is pre-certified as a 'green' building by the Indian Green Building Council. With green building procedures, rainwater harvesting systems, grey-water recycling systems, a solar electricity plant that powers the lights of the entire basement, and adoption of garbage segregation methodologies, Wilasa is a decidedly green project."
                    ]
                )
            ]
        ]


amenities : BaseFontSize -> BaseSpace -> Element Msg
amenities baseFontSize baseSpace =
    topicParagraph baseFontSize
        baseSpace
        "Amenities"
        [ paragraph
            (contentAttributes baseFontSize)
            [ text "Wilasa has all the amenities that can be found in large, high-rise apartment complexes, including:"
            ]
        , column
            [ paddingEach { top = 0, right = 0, left = spaces baseSpace 1, bottom = 0 }
            , spacing (spaces baseSpace 1)
            ]
            (List.map (contentParagraph baseFontSize)
                [ "• Centralised piped cooking gas"
                , "• A luxurious Club House with 1 indoor and 2 outdoor party areas"
                , "• An indoor games area with a pool table and board games"
                , "• A very well-equipped gym"
                , "• A large swimming pool with a children's pool"
                , "• A basketball half-court that doubles as an amphitheatre"
                , "• Community gathering areas"
                , "• Walkways without vehicular traffic"
                , "• Children's play area"
                , "• Outdoor gym area"
                , "• Housekeeping that practices garbage segregation"
                , "• Maintenance staff available 24 hours for urgent repairs"
                , "• A well-designed reception area"
                ]
            )
        ]


pricing : BaseFontSize -> BaseSpace -> Element Msg
pricing baseFontSize baseSpace =
    topicParagraph baseFontSize baseSpace "Pricing" [ contentParagraph baseFontSize "Prices start at ₹ 9,500/sq. ft. Other terms and conditions apply." ]


visitUs : BaseFontSize -> BaseSpace -> Element Msg
visitUs baseFontSize baseSpace =
    topicParagraph baseFontSize
        baseSpace
        "Visit Us"
        [ column
            [ spacing (spaces baseSpace 2) ]
            (List.map (paragraph [])
                [ [ subheading baseFontSize "Address: "
                  , contentParagraph baseFontSize "Wilasa Grand Villaments, 11th Kilometre, Kanakapura Road, Doddakallasandra, Bangalore 560 062"
                  ]
                , [ subheading baseFontSize "Directions: "
                  , Element.newTabLink (contentAttributes baseFontSize) { url = "https://g.page/Wilasa?share", label = text "Open Google Maps in a new tab" }
                  ]
                , [ subheading baseFontSize "Phone number: "
                  , Element.link (contentAttributes baseFontSize) { url = "tel:08047108861", label = text "080 4710 8861" }
                  ]
                , [ subheading baseFontSize "Email: "
                  , Element.link (contentAttributes baseFontSize) { url = "mailto:info@wilasa.in", label = text "info@wilasa.in" }
                  ]
                ]
            )
        ]


footer : BaseFontSize -> BaseSpace -> Element Msg
footer baseFontSize baseSpace =
    column
        ([ Background.color standardColours.red
         , height (spacesPx baseSpace 14)
         , width fill
         ]
            ++ contentAttributes baseFontSize
        )
        (List.map (paragraph [ centerX, centerY, center ])
            [ [ text "© 2020 M/s G R Nataraj HUF. All rights reserved." ]
            , [ text "Terms of use apply." ]
            ]
        )
