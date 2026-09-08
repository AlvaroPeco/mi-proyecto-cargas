import { useEffect, useState } from 'react'
import API_BASE_URL from '../api' // Importamos la variable centralizada
import './Camion.css'

function Camion({ camion, onSeleccionarCarga, onVolver }) {
  const [cargas, setCargas] = useState([])
  const [cargando, setCargando] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    const cargarCargasYPalets = async () => {
      try {
        // Sustituimos http://localhost:8080 por API_BASE_URL
        const respuesta = await fetch(`${API_BASE_URL}/api/cargas/vehiculo/${camion}`)
        if (!respuesta.ok) {
          throw new Error('Error al obtener las cargas')
        }
        const datosCargas = await respuesta.json()

        // Para cada carga, consultamos sus palés apuntando a API_BASE_URL
        const cargasConPalets = await Promise.all(
          datosCargas.map(async (carga) => {
            try {
              const resPalets = await fetch(`${API_BASE_URL}/api/palets/carga/${carga.idCarga}`)
              if (resPalets.ok) {
                const palets = await resPalets.json()
                return { ...carga, numPalets: palets.length }
              }
            } catch (e) {
              console.error('Error al obtener palés de la carga', carga.idCarga, e)
            }
            return { ...carga, numPalets: 0 }
          })
        )

        setCargas(cargasConPalets)
        setCargando(false)
      } catch (err) {
        console.error(err)
        setError('No se han podido cargar las cargas')
        setCargando(false)
      }
    }

    cargarCargasYPalets()
  }, [camion])

  const obtenerClaseEstado = (estado) => {
    switch (estado) {
      case 'pendiente':
        return 'estado estado-pendiente'
      case 'en_preparacion':
        return 'estado estado-en-preparacion'
      case 'cargada':
        return 'estado estado-cargada'
      case 'finalizada':
        return 'estado estado-finalizada'
      default:
        return 'estado'
    }
  }

  const mostrarEstado = (estado) => {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente'
      case 'en_preparacion':
        return 'En preparación'
      case 'cargada':
        return 'Cargada'
      case 'finalizada':
        return 'Finalizada'
      default:
        return estado
    }
  }

  return (
    <div className="camion-container">
      <div className="camion-header">
        <button className="volver-button" onClick={onVolver}>
          ← Volver
        </button>

        <div className="camion-header-texto">
          <h1>Cargas del vehículo</h1>
          <p>Selecciona una carga para consultar sus detalles</p>
        </div>
      </div>

      {cargando && <div className="mensaje">Cargando cargas...</div>}

      {error && <div className="mensaje">{error}</div>}

      {!cargando && !error && cargas.length === 0 && (
        <div className="mensaje">Este vehículo no tiene cargas.</div>
      )}

      {!cargando && !error && cargas.length > 0 && (
        <div className="cargas-tabla-container">
          <table className="cargas-tabla">
            <thead>
              <tr>
                <th>ID Carga</th>
                <th>Fecha</th>
                <th>Camión</th>
                <th>Ruta</th>
                <th>Hora de salida</th>
                <th>Nº Palets</th>
                <th>Estado</th>
              </tr>
            </thead>
            <tbody>
              {cargas.map((carga) => (
                <tr
                  key={carga.idCarga}
                  className="carga-fila"
                  onClick={() => onSeleccionarCarga(carga.idCarga)}
                >
                  <td>{carga.idCarga}</td>
                  <td>{carga.fecha}</td>
                  <td>
                    {carga.vehiculo
                      ? `${carga.vehiculo.matricula} - ${carga.vehiculo.nombre}`
                      : '-'}
                  </td>
                  <td>{carga.ruta?.nombre || '-'}</td>
                  <td>{carga.horaSalida || '-'}</td>
                  <td>{carga.numPalets}</td>
                  <td>
                    <span className={obtenerClaseEstado(carga.estado)}>
                      {mostrarEstado(carga.estado)}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}

export default Camion