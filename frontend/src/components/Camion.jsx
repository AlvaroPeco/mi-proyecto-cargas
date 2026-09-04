import { useEffect, useState } from 'react'
import './Camion.css'

function Camion({ camion, onSeleccionarCarga, onVolver }) {
  const [cargas, setCargas] = useState([])
  const [cargando, setCargando] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    fetch(`http://localhost:8080/api/cargas/vehiculo/${camion}`)
      .then((respuesta) => {
        if (!respuesta.ok) {
          throw new Error('Error al obtener las cargas')
        }
        return respuesta.json()
      })
      .then((datos) => {
        setCargas(datos)
        setCargando(false)
      })
      .catch((error) => {
        console.error(error)
        setError('No se han podido cargar las cargas')
        setCargando(false)
      })
  }, [camion])

  const obtenerClaseEstado = (estado) => {
    switch (estado) {
      case 'pendiente':
        return 'estado estado-pendiente'
      case 'en preparacion':
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
      case 'en preparacion':
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

      {/* Cabecera que incluye el botón volver arriba a la izquierda */}
      <div className="camion-header">
        <button className="volver-button" onClick={onVolver}>
          ← Volver
        </button>

        <div className="camion-header-texto">
          <h1>Cargas del vehículo</h1>
          <p>Selecciona una carga para consultar sus detalles</p>
        </div>
      </div>

      {cargando && (
        <div className="mensaje">
          Cargando cargas...
        </div>
      )}

      {error && (
        <div className="mensaje">
          {error}
        </div>
      )}

      {!cargando && !error && cargas.length === 0 && (
        <div className="mensaje">
          Este vehículo no tiene cargas.
        </div>
      )}

      {!cargando && !error && cargas.length > 0 && (
        <div className="cargas-tabla-container">
          <table className="cargas-tabla">
            <thead>
              <tr>
                <th>Fecha</th>
                <th>Ruta</th>
                <th>Hora de salida</th>
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
                  <td>{carga.fecha}</td>
                  <td>{carga.ruta.nombre}</td>
                  <td>{carga.horaSalida || '-'}</td>
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