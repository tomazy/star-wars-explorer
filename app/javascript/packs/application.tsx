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
import { DelayedLoading } from './delayed-loading'
import { ApiLink } from './api-link'
import { Breadcrumb } from './breadcrumb'

const ROOT_API = '/api'

interface State {
  loading: boolean
  href: string
  resource?: Object
}

const Loading = () =>
  <DelayedLoading>
    <div className='mv4 silver f6'>
      please wait...
    </div>
  </DelayedLoading>

class App extends React.Component<{}, State> {

  public state = {
    loading: false,
    href: '',
    resource: null,
  }

  public componentWillMount() {
    this.loadResource(ROOT_API)
  }

  public render() {
    const { resource, href, loading } = this.state
    return (
      <React.Fragment>
        <div className='f3 bb b--light-gray pv3'>
          <Breadcrumb className='dib' path={href} linkFactory={this.renderApiLink} />
        </div>
        {
          loading
            ? <Loading />
            : resource && <ResourceView resource={resource} linkFactory={this.renderApiLink} />
        }
      </React.Fragment>
    );
  }

  private async loadResource(href) {
    this.setState({ href, loading: true, resource: null })

    const res = await fetch(href)
    const resource = await res.json()

    this.setState({ resource, loading: false })
  }

  private renderApiLink = (href: string, text: string) => {
    return (
      <ApiLink href={href} onClick={this.handleLinkClick}>{text}</ApiLink>
    )
  }

  private handleLinkClick = href => {
    this.loadResource(href)
  }
}

ReactDOM.render(<App />, document.getElementById('app'))
