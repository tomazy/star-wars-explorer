/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import * as React from 'react'
import * as ReactDOM from 'react-dom'

import { ResourceView } from './resource-view'

const sample = {
  name: "Luke Skywalker",
  age: 12,
  dupa: null,
  films: [
    "/film/1",
    "/film/2",
    { _href: '/film/1', _text: '/film/1' },
    "/film/3",
    "/film/4",
  ],
  vehicles: []
}

const App = () =>
  <React.Fragment>
    <ResourceView resource={sample}/>
  </React.Fragment>

ReactDOM.render(<App />, document.getElementById('app'))
