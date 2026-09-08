import { useEffect, useState } from 'react'
import API_BASE_URL from '../api' // Importamos la base centralizada
import './DetalleCarga.css'

function DetalleCarga({ carga, onSeleccionarPalet, onVolver }) {
  const [datosCarga, setDatosCarga] = useState(null)
  const [palets, setPalets] = useState([])
  const [cargando, setCargando] = useState(true)
  const [error, setError] = useState('')
  const [recargar, setRecargar] = useState(0)

  useEffect(() => {
    let ignorar = false

    const cargarDatos = async () => {
      setCargando(true)
      try {
        const respuestaCarga = await fetch(
          `${API_BASE_URL}/api/cargas/${carga}`
        )

        if (!respuestaCarga.ok) {
          throw new Error('Error al obtener la carga')
        }

        const datos = await respuestaCarga.json()

        const respuestaPalets = await fetch(
          `${API_BASE_URL}/api/palets/carga/${carga}`
        )

        if (!respuestaPalets.ok) {
          throw new Error('Error al obtener los palés')
        }

        const datosPalets = await respuestaPalets.json()

        if (!ignorar) {
          setDatosCarga(datos)
          setPalets(datosPalets)
          setCargando(false)
        }
      } catch (error) {
        if (!ignorar) {
          console.error(error)
          setError('No se ha podido cargar la información')
          setCargando(false)
        }
      }
    }

    cargarDatos()

    return () => {
      ignorar = true
    }
  }, [carga, recargar])

  // Función para marcar el palé como cargado
  const marcarPaletComoCargado = async (e, idPalet) => {
    e.stopPropagation()

    try {
      const respuesta = await fetch(
        `${API_BASE_URL}/api/palets/${idPalet}/marcar-cargado`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          }
        }
      )

      if (respuesta.ok) {
        setRecargar((prev) => prev + 1)
      } else {
        alert('No se pudo marcar el palé como cargado')
      }
    } catch (err) {
      console.error('Error al actualizar el estado del palé:', err)
    }
  }

  // NUEVA FUNCIÓN: Desmarcar el palé como cargado
  const desmarcarPaletComoCargado = async (e, idPalet) => {
    e.stopPropagation()

    try {
      const respuesta = await fetch(
        `${API_BASE_URL}/api/palets/${idPalet}/desmarcar-cargado`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          }
        }
      )

      if (respuesta.ok) {
        setRecargar((prev) => prev + 1)
      } else {
        alert('No se pudo desmarcar el palé')
      }
    } catch (err) {
      console.error('Error al desmarcar el palé:', err)
    }
  }

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
          <div className="detalle-header">
            <button className="volver-button" onClick={onVolver}>
              ← Volver
            </button>

            <h1>Detalle de la carga</h1>

            <div className="informacion-carga">
              <div className="dato-carga">
                <span>Vehículo</span>
                <strong>{datosCarga.vehiculo?.nombre}</strong>
              </div>

              <div className="dato-carga">
                <span>Matrícula</span>
                <strong>{datosCarga.vehiculo?.matricula}</strong>
              </div>

              <div className="dato-carga">
                <span>Fecha</span>
                <strong>{datosCarga.fecha}</strong>
              </div>

              <div className="dato-carga">
                <span>Ruta</span>
                <strong>{datosCarga.ruta?.nombre}</strong>
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
                      <th>Acciones</th>
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
                        <td>{palet.cliente?.nombreEmpresa}</td>
                        <td>{palet.direccion?.direccion}</td>
                        <td>{palet.direccion?.provincia}</td>
                        <td>
                          <span className={obtenerEstadoPalet(palet.estado)}>
                            {mostrarEstadoPalet(palet.estado)}
                          </span>
                        </td>
                        <td>
                          {palet.estado !== 'cargado' ? (
                            <button
                              onClick={(e) => marcarPaletComoCargado(e, palet.idPalet)}
                              className="btn-marcar-cargado"
                            >
                              Marcar Cargado
                            </button>
                          ) : (
                            <div className="acciones-cargado">
                              <span className="texto-cargado">✓ Cargado</span>
                              <button
                                onClick={(e) => desmarcarPaletComoCargado(e, palet.idPalet)}
                                className="btn-desmarcar-cargado"
                                title="Desmarcar si hubo un error"
                              >
                                Desmarcar
                              </button>
                            </div>
                          )}
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