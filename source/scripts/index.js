// import { Elm } from './Index.elm'
// const index = Elm.Index.init({
//   node: document.getElementsByTagName('main')[0],
//   flags: { height: window.innerHeight, width: window.innerWidth }
// })

import { Elm } from './Slideshow.elm'

const homePhotographsSlideshow = Elm.Slideshow.init({
  node: document.getElementById('homePhotographs'),
  flags: [
    {
      url: '../images/wilasa/home/wilasaHome1.jpg',
      description: 'A well appointed living room'
    },
    {
      url: '../images/wilasa/home/wilasaHome2.jpg',
      description: 'Kitchen with space, light and air'
    },
    {
      url: '../images/wilasa/home/wilasaHome3.jpg',
      description: 'The spacious master bedroom'
    },
    {
      url: '../images/wilasa/home/wilasaHome4.jpg',
      description: 'The ground-floor bedroom with an attached sit-out'
    },
    {
      url: '../images/wilasa/home/wilasaHome5.jpg',
      description: 'A bedroom designed for children'
    },
    {
      url: '../images/wilasa/home/wilasaHome6.jpg',
      description: 'Another interpretation of a bedroom'
    },
    {
      url: '../images/wilasa/home/wilasaHome6.jpg',
      description: 'Rooftop garden in the Sky apartments'
    }
  ]
})

const commonAreaPhotographsSlideshow = Elm.Slideshow.init({
  node: document.getElementById('commonAreaPhotographs'),
  flags: [
    {
      url: '../images/wilasa/commonAreas/wilasaCommonArea1.jpg',
      description: 'A view of the reception area'
    },
    {
      url: '../images/wilasa/commonAreas/wilasaCommonArea2.png',
      description: 'An overview of the heart of Wilasa, showing the amenities'
    },
    {
      url: '../images/wilasa/commonAreas/wilasaCommonArea3.jpg',
      description: "The beautiful pool with the attached children's pool"
    },
    {
      url: '../images/wilasa/commonAreas/wilasaCommonArea4.jpg',
      description: 'The entrance to the club house'
    },
    {
      url: '../images/wilasa/commonAreas/wilasaCommonArea5.jpg',
      description: 'The well-equipped gym'
    }
  ]
})
