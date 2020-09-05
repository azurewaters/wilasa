import { Elm } from './Index.elm'
const index = Elm.Index.init({
  node: document.getElementsByTagName('main')[0],
  flags: { height: window.innerHeight, width: window.innerWidth }
})
