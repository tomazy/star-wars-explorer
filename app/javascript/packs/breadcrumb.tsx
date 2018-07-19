import * as React from 'react'
import './breadcrumb.css'

interface Props {
  path: string
  className?: string
  linkFactory: (href: string, text: string) => JSX.Element
}

export class Breadcrumb extends React.Component<Props> {
  public render() {
    const { className, path, linkFactory } = this.props;
    const parts = path.split('/').filter(Boolean)

    function makeHref(idx) {
      return `/${parts.slice(0, idx + 1).join('/')}`
    }

    return (
      <ul className={`Breadcrumb code list ma0 pa0 light-silver ${className || ''}`}>
        {parts.map((part, idx) => (
          <li className='dib' key={idx}>
            {
              (idx === parts.length - 1)
                ? <span className="near-black">{part}</span>
                : linkFactory(makeHref(idx), part)
            }
          </li>
        ))}
      </ul>
    )
  }
}
