import { useState } from 'react'
import { useNuiEvent } from '../hooks/useNuiEvent'
import serverLogo from '../assets/images/logo.png'
import "./App.css";

const ServerLogo = () => {
  const [logo, setLogo] = useState<boolean>(false)

  useNuiEvent('setLogo', () => setLogo(true))

  return <>{ logo && <div id="Logo"><img src={serverLogo} /></div> }</>
}

export default ServerLogo