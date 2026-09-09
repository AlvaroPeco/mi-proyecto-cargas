import { useEffect, useState } from 'react'
import API_BASE_URL from '../api'
import './PanelLogs.css'

function PanelLogs({ onVolver }) {
  const [logs, setLogs] = useState([])
  const [cargando, setCargando] = useState(true)
  const [error, setError] = useState('')

  const usuarioSesion = JSON.parse(localStorage.getItem('usuario') || '{}')
  const idUsuario = usuarioSesion?.idUsuario || usuarioSesion?.id || 1

  useEffect(() => {
    const cargarLogs = async () => {
      setCargando(true)
      try {
        const respuesta = await fetch(`${API_BASE_URL}/api/logs?idUsuario=${idUsuario}`)
        if (!respuesta.ok) throw new Error('Error al cargar auditoría')
        const datos = await respuesta.json()
        setLogs(datos)
      } catch (err) {
        console.error(err)
        setError('No se pudo obtener el historial.')
      } finally {
        setCargando(false)
      }
    }

    cargarLogs()
  }, [idUsuario])

  const handleLimpiarLogs = async () => {
    if (!window.confirm('¿Estás seguro de que deseas vaciar todos los registros de logs? Esta acción no se puede deshacer.')) {
      return
    }

    try {
      const respuesta = await fetch(`${API_BASE_URL}/api/logs/limpiar?idUsuario=${idUsuario}`, {
        method: 'DELETE'
      })

      if (respuesta.ok) {
        setLogs([])
      } else {
        alert('No tienes permisos para realizar esta acción.')
      }
    } catch (err) {
      console.error(err)
      alert('Error al intentar vaciar los logs.')
    }
  }

  return (
    <div className="panel-logs-container">
      <div className="panel-logs-header">
        <button className="btn-volver-logs" onClick={onVolver}>
          ← Volver
        </button>

        <h1>📋 Historial de Auditoría</h1>

        {logs.length > 0 && (
          <button className="btn-limpiar-logs" onClick={handleLimpiarLogs}>
            🗑️ Limpiar Logs
          </button>
        )}
      </div>

      {cargando && <div className="mensaje">Cargando registros...</div>}
      {error && <div className="mensaje mensaje-error">{error}</div>}

      {!cargando && !error && (
        <div className="tabla-logs-wrapper">
          {logs.length === 0 ? (
            <div className="logs-vacio">No hay registros registrados en el sistema.</div>
          ) : (
            <table className="tabla-logs">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Acción</th>
                  <th>Código Palé</th>
                  <th>Usuario</th>
                  <th>Fecha y Hora</th>
                </tr>
              </thead>
              <tbody>
                {logs.map((log) => {
                  const accion = log.accion || ''
                  let claseBadge = 'badge-accion'
                  if (accion.includes('EXITOSO')) claseBadge += ' badge-exito'
                  else if (accion.includes('FALLIDO')) claseBadge += ' badge-fallido'
                  else if (accion.includes('CREAR')) claseBadge += ' badge-crear'

                  return (
                    <tr key={log.id}>
                      <td>{log.id}</td>
                      <td><span className={claseBadge}>{accion}</span></td>
                      <td>{log.palet?.codEscaneo || '-'}</td>
                      <td>{log.usuario?.nombre || log.usuario?.username || 'Desconocido'}</td>
                      <td>{new Date(log.fechaHora).toLocaleString()}</td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          )}
        </div>
      )}
    </div>
  )
}

export default PanelLogs