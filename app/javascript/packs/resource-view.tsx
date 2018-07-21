import * as React from 'react'
import { highlightJson, Syntax, LinkFactory } from './highlight-json'

interface Props {
  resource: any
  linkFactory: LinkFactory
}

export class ResourceView extends React.Component<Props> {
  public render() {
    const { resource, linkFactory } = this.props

    const hlPairs = highlightJson(resource, linkFactory)

    const spans = hlPairs.map(([syntax, element], idx) => (
      <span key={idx} className={syntaxToClassName(syntax)}>{element}</span>
    ))

    return (
      <pre className='pre code overflow-auto overflow-visible-ns ma0'>
        {spans}
      </pre>
    )
  }
}

function syntaxToClassName(syntax: Syntax): string {
	switch (syntax) {
    case Syntax.keyword:
      return 'dark-blue'
    case Syntax.propertyName:
      return 'dark-green'
    case Syntax.string:
      return 'orange'
    case Syntax.number:
      return 'purple'
    case Syntax.punctuation:
      return 'silver'
    default: return undefined
	}
}
