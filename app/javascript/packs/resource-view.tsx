import * as React from 'react'
import { renderAsJson } from './render-as-json'

interface Props {
  resource: any
}

export class ResourceView extends React.Component<Props> {

  public componentDidMount() {
  }

  public render() {
    const { resource } = this.props
    return (
      <pre>
        {renderAsJson(resource, this.onLinkClick)}
      </pre>
    )
  }

  private onLinkClick = (href: string) => {
    console.log('onLinkClick', href)
  }
}

