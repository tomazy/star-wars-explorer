import * as React from 'react'

export type LinkClickHandler = (href: string) => void;

interface Props {
  onClick: LinkClickHandler
  href: string
}

export const ApiLink = ({ href, onClick, ...rest }: Props) => {
  return (
    <a className='link blue hover-pink' {...rest} href={href} onClick={e => {
      e.preventDefault()
      onClick(href)
    }} />
  )
}
