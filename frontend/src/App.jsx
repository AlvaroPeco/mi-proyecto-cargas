import { useState } from 'react'
import Inicio from './components/Inicio'
import Cargas from './components/Cargas'
import Camion from './components/Camion'
import DetalleCarga from './components/DetalleCarga'
import DetallePalet from './components/DetallePalet'

function App() {

  const [pantalla, setPantalla] = useState('inicio')
  const [camionSeleccionado, setCamionSeleccionado] = useState(null)
  const [cargaSeleccionada, setCargaSeleccionada] = useState(null)
  const [paletSeleccionado, setPaletSeleccionado] = useState(null)

  const mostrarCargas = () => {
    setPantalla('cargas')
  }

  const seleccionarCamion = (camion) => {
    setCamionSeleccionado(camion)
    setPantalla('camion')
  }

  const seleccionarCarga = (carga) => {
    setCargaSeleccionada(carga)
    setPantalla('detalleCarga')
  }

  const seleccionarPalet = (palet) => {
    setPaletSeleccionado(palet)
    setPantalla('detallePalet')
  }

  const volverInicio = () => {
    setPantalla('inicio')
  }

  const volverCargas = () => {
    setPantalla('cargas')
  }

  const volverCamion = () => {
    setPantalla('camion')
  }

  const volverDetalleCarga = () => {
    setPantalla('detalleCarga')
  }

  if (pantalla === 'inicio') {
    return <Inicio onCargas={mostrarCargas} />
  }

  if (pantalla === 'cargas') {
    return (
      <Cargas
        onSeleccionarCamion={seleccionarCamion}
        onVolver={volverInicio}
      />
    )
  }

  if (pantalla === 'camion') {
    return (
      <Camion
        camion={camionSeleccionado}
        onSeleccionarCarga={seleccionarCarga}
        onVolver={volverCargas}
      />
    )
  }

  if (pantalla === 'detalleCarga') {
    return (
      <DetalleCarga
        carga={cargaSeleccionada}
        onSeleccionarPalet={seleccionarPalet}
        onVolver={volverCamion}
      />
    )
  }

  if (pantalla === 'detallePalet') {
    return (
      <DetallePalet
        palet={paletSeleccionado}
        onVolver={volverDetalleCarga}
      />
    )
  }
}

export default App