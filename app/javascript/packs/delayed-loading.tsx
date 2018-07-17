import * as React from 'react'

//
// Sometimes components load really quickly (<200ms) and the loading screen only quickly
// flashes on the screen.
//
// A number of user studies have proven that this causes users to perceive things taking
// longer than they really have. If you don't show anything, users perceive it as being faster.
//
// --
// https://github.com/jamiebuilds/react-loadable
//

interface Props {
  children: JSX.Element
}

interface State {
  displayChildren: boolean
}

export class DelayedLoading extends React.Component<Props, State> {
  private timer;

  public state = {
    displayChildren: false,
  }

  public componentWillMount() {
    this.setState({ displayChildren: false })
  }

  public componentDidMount() {
    this.killTimer()
    this.timer = setTimeout(() => {
      this.setState({ displayChildren: true })
      this.killTimer()
    }, 200)
  }

  public componentWillUnmount() {
    this.killTimer()
  }

  public render() {
    const { displayChildren } = this.state;
    if (!displayChildren) return null;

    const { children } = this.props;
    return children;
  }

  private killTimer() {
    if (this.timer) {
      clearTimeout(this.timer)
      delete this.timer
    }
  }
}
