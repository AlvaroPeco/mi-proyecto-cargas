import { useEffect, useState } from 'react'
import './DetalleCarga.css'

function DetalleCarga({ carga, onSeleccionarPalet, onVolver }) {
  const [datosCarga, setDatosCarga] = useState(null)
  const [palets, setPalets] = useState([])
  const [cargando, setCargando] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    const cargarDatos = async () => {
      try {
        const respuestaCarga = await fetch(
          `http://localhost:8080/api/cargas/${carga}`
        )

        if (!respuestaCarga.ok) {
          throw new Error('Error al obtener la carga')
        }

        const datos = await respuestaCarga.json()
        setDatosCarga(datos)

        const respuestaPalets = await fetch(
          `http://localhost:8080/api/palets/carga/${carga}`
        )

        if (!respuestaPalets.ok) {
          throw new Error('Error al obtener los palés')
        }

        const datosPalets = await respuestaPalets.json()

        setPalets(datosPalets)
        setCargando(false)
      } catch (error) {
        console.error(error)
        setError('No se ha podido cargar la información')
        setCargando(false)
      }
    }

    cargarDatos()
  }, [carga])

  const obtenerEstadoPalet = (estado) => {
    if (estado === 'cargado') {
      return 'estado-palet palet-cargado'
    }
    return 'estado-palet palet-pendiente'
  }

  const mostrarEstadoPalet = (estado) => {
    if (estado === 'cargado') {
      return 'Cargado'
    }
    return 'Pendiente'
  }

  return (
    <div className="detalle-container">
      {cargando && (
        <div className="mensaje">
          Cargando información...
        </div>
      )}

      {error && (
        <div className="mensaje mensaje-error">
          {error}
        </div>
      )}

      {!cargando && !error && datosCarga && (
        <>
          {/* Cabecera con el botón Volver dentro del bloque */}
          <div className="detalle-header">
            <button className="volver-button" onClick={onVolver}>
              ← Volver
            </button>

            <h1>Detalle de la carga</h1>

            <div className="informacion-carga">
              <div className="dato-carga">
                <span>Vehículo</span>
                <strong>{datosCarga.vehiculo.nombre}</strong>
              </div>

              <div className="dato-carga">
                <span>Matrícula</span>
                <strong>{datosCarga.vehiculo.matricula}</strong>
              </div>

              <div className="dato-carga">
                <span>Fecha</span>
                <strong>{datosCarga.fecha}</strong>
              </div>

              <div className="dato-carga">
                <span>Ruta</span>
                <strong>{datosCarga.ruta.nombre}</strong>
              </div>

              <div className="dato-carga">
                <span>Hora de salida</span>
                <strong>{datosCarga.horaSalida || '-'}</strong>
              </div>

              <div className="dato-carga">
                <span>Estado</span>
                <strong>{datosCarga.estado}</strong>
              </div>
            </div>
          </div>

          {/* Sección de palés */}
          <div className="palets-container">
            <h2>📦 Palés de la carga</h2>

            {palets.length === 0 ? (
              <p className="mensaje-vacio">No hay palés asociados a esta carga.</p>
            ) : (
              <div className="palets-tabla-container">
                <table className="palets-tabla">
                  <thead>
                    <tr>
                      <th>Código</th>
                      <th>Cliente</th>
                      <th>Dirección</th>
                      <th>Provincia</th>
                      <th>Estado</th>
                    </tr>
                  </thead>
                  <tbody>
                    {palets.map((palet) => (
                      <tr
                        key={palet.idPalet}
                        className="palet-fila"
                        onClick={() => onSeleccionarPalet(palet.idPalet)}
                      >
                        <td className="codigo-palet">{palet.codEscaneo}</td>
                        <td>{palet.cliente.nombreEmpresa}</td>
                        <td>{palet.direccion.direccion}</td>
                        <td>{palet.direccion.provincia}</td>
                        <td>
                          <span className={obtenerEstadoPalet(palet.estado)}>
                            {mostrarEstadoPalet(palet.estado)}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </>
      )}
    </div>
  )
}

export default DetalleCarga