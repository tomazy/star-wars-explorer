import * as React from 'react'
import { renderAsJson, LinkFactory } from './render-as-json'

interface Props {
  resource: any
  linkFactory: LinkFactory
}

export class ResourceView extends React.Component<Props> {

  public render() {
    const { resource, linkFactory } = this.props
    return (
      <pre>
        {renderAsJson(resource, linkFactory)}
      </pre>
    )
  }
}

