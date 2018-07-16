import * as React from 'react'
import { renderAsJson, LinkClickHandler } from './render-as-json'

interface Props {
  resource: any
  onLinkClick: LinkClickHandler
}

export class ResourceView extends React.Component<Props> {

  public componentDidMount() {
  }

  public render() {
    const { resource, onLinkClick } = this.props
    return (
      <pre>
        {renderAsJson(resource, onLinkClick)}
      </pre>
    )
  }
}

