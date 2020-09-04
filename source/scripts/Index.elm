module Index exposing (main)

import Browser
import Browser.Dom as Dom exposing (setViewport)
import Element exposing (Attribute, Color, Element, Length, alignTop, centerX, centerY, column, el, explain, fill, height, image, layout, maximum, minimum, padding, paddingEach, paddingXY, paragraph, px, rgb255, spaceEvenly, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (bold, family, size)
import Html exposing (Html)
import Task


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    Bool


init : flags -> ( Model, Cmd Msg )
init _ =
    ( True, Cmd.none )



-- UPDATE


type Msg
    = HomeClicked
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HomeClicked ->
            ( model, Task.perform (\_ -> NoOp) (Dom.setViewport 0 0) )

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


baseSpace : Int
baseSpace =
    20


spaces : Int -> Int
spaces multiple =
    baseSpace * multiple


spacesPx : Int -> Length
spacesPx =
    spaces >> px


baseFontSize : Float
baseFontSize =
    16


scaledFontSize : Int -> Int
scaledFontSize =
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
view _ =
    layout
        [ Background.color standardColours.darkGrey ]
        (Element.column
            [ width fill ]
            [ header
            , pictureSeparator "../images/elephantFrieze.jpg"
            , column
                [ centerX
                , width (fill |> maximum 600)
                ]
                [ overview
                , theWilasaLife
                , otherFeatures
                , amenities
                , pricing
                , visitUs
                ]
            , footer
            ]
        )


header : Element Msg
header =
    column
        [ Background.color standardColours.red
        , height (fill |> minimum 600)
        , paddingXY 0 (spaces 4)
        , spaceEvenly
        , width fill
        ]
        [ Element.image
            [ centerX
            , centerY
            , width (fill |> maximum 320)
            ]
            { src = "../images/logoNoBackground.png", description = "Wilasa Logo" }
        , el
            [ alignTop
            , Border.color standardColours.offWhite
            , Border.solid
            , Border.width 1
            , Border.rounded 2
            , centerX
            , paddingXY (spaces 1) (spaces 1)
            ]
            (Element.link (centerY :: contentAttributes) { url = "tel:08047108861", label = text "CALL US ON 080 4710 8861" })
        ]


pictureSeparator : String -> Element Msg
pictureSeparator src =
    el
        [ Background.image src
        , Border.solid
        , Border.color standardColours.darkGrey
        , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
        , height (spacesPx 10)
        , width fill
        ]
        Element.none


overview : Element Msg
overview =
    column
        [ paddingXY (spaces 4) (spaces 4)
        , spacing (spaces 2)
        ]
        [ sectionHeading "Overview"
        , contentParagraph "Wilasa is a serene, low-rise, ready-to-occupy housing complex just off Kanakapura Road, only a few hundred meters from the Konanakunte Signal. Only a hundred and thirty-four spacious apartments occupy the nearly five acre plot. With greenery all around — inside and outside your home — Wilasa gives you room to breathe, and indeed, revel in."
        ]


sectionHeading : String -> Element Msg
sectionHeading title =
    el
        [ Font.color standardColours.brown
        , Font.size (scaledFontSize 4)
        , Font.family
            [ Font.typeface "Source Serif Pro"
            ]
        ]
        (text title)


topicParagraph : String -> List (Element Msg) -> Element Msg
topicParagraph title content =
    column
        [ paddingEach
            { top = 0
            , right = spaces 4
            , bottom = spaces 4
            , left = spaces 4
            }
        , spacing (spaces 2)
        ]
        (sectionHeading title :: content)


contentAttributes : List (Attribute Msg)
contentAttributes =
    [ Font.color standardColours.offWhite
    , Font.size (scaledFontSize 1)
    , Font.family [ Font.typeface "Source Sans Pro" ]
    , spacing (scaledFontSize 1)
    ]


contentParagraph : String -> Element Msg
contentParagraph content =
    paragraph contentAttributes [ text content ]


subheading : String -> Element Msg
subheading content =
    el
        [ Font.color standardColours.offWhite
        , Font.size (scaledFontSize 1)
        , Font.family [ Font.typeface "Source Sans Pro" ]
        , Font.bold
        ]
        (text content)


theWilasaLife : Element Msg
theWilasaLife =
    topicParagraph "The Wilasa Life"
        (List.map contentParagraph
            [ "We take pride in the greenery in Wilasa. Every home either has a garden or looks out onto one. The common areas host large swathes of green, landscaped gardens, giving us a sense of living amidst nature"
            , "The houses are between 2,000 and 4,000 sq. ft. in size, with either 3 or 4 bedrooms each. There's room enough in each of them to stretch your legs out, and also work without distractions."
            , "Wilasa has all the amenities that high-rise apartments offer, including a luxurious club-house, a well-equipped gym, a beautiful swimming pool, and 24-hour security and maintenance. However, each block rises only about 50 feet, and affords you almost the same amount of privacy that an individual home can offer. Thus, Wilasa strikes a balance between apartment living and individual-home living."
            ]
        )


otherFeatures : Element Msg
otherFeatures =
    topicParagraph "Other Features"
        [ paragraph contentAttributes
            [ text "Other notable features include:"
            , column
                [ paddingEach { top = baseSpace, right = 0, left = baseSpace, bottom = 0 }
                , spacing (spaces 2)
                ]
                (List.map contentParagraph
                    [ "• All vehicular traffic in Wilasa is underground, freeing up the area above for walks, play and community."
                    , "• Wilasa is located a 100 metres from the nearest metro station, a couple of hundred metres from a top-notch hospital, a few hundred metres from schools like Kumaran's and a couple of kilometres from Delhi Public School and The Valley School. The upcoming Forum Mall and Mantri Mall are minutes away, as is NICE road."
                    , "• Wilasa is pre-certified as a 'green' building by the Indian Green Building Council. With green building procedures, rainwater harvesting systems, grey-water recycling systems, a solar electricity plant that powers the lights of the entire basement, and adoption of garbage segregation methodologies, Wilasa is a decidedly green project."
                    ]
                )
            ]
        ]


amenities : Element Msg
amenities =
    topicParagraph "Amenities"
        [ paragraph
            contentAttributes
            [ text "Wilasa has all the amenities that can be found in large, high-rise apartment complexes, including:"
            ]
        , column
            [ paddingEach { top = 0, right = 0, left = spaces 1, bottom = 0 }
            , spacing (spaces 1)
            ]
            (List.map contentParagraph
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


pricing : Element Msg
pricing =
    topicParagraph "Pricing" [ contentParagraph "Prices start at ₹ 9,500/sq. ft. Other terms and conditions apply." ]


visitUs : Element Msg
visitUs =
    topicParagraph "Visit Us"
        [ column
            [ spacing (spaces 2) ]
            [ paragraph []
                [ subheading "Address: "
                , contentParagraph "Wilasa Grand Villaments, 11th Kilometre, Kanakapura Road, Doddakallasandra, Bangalore 560 062"
                ]
            , paragraph []
                [ subheading "Directions: "
                , Element.newTabLink contentAttributes { url = "https://g.page/Wilasa?share", label = text "Open Google Maps in a new tab" }
                ]
            , paragraph []
                [ subheading "Phone number: "
                , Element.link contentAttributes { url = "tel:08047108861", label = text "080 4710 8861" }
                ]
            , paragraph []
                [ subheading "Email: "
                , Element.link contentAttributes { url = "mailto:info@wilasa.in", label = text "info@wilasa.in" }
                ]
            ]
        ]


footer : Element Msg
footer =
    column
        ([ Background.color standardColours.red
         , height (spacesPx 14)
         , width fill
         ]
            ++ contentAttributes
        )
        [ el [ centerX, centerY ] (text "© 2020 M/s G R Nataraj HUF. All rights reserved.")
        , el [ centerX, centerY ] (text "Terms of use apply.")
        ]
