import { useState } from 'react'
import API_BASE_URL from '../api' // Importamos la URL centralizada
import './Inicio.css'

function RegistroUsuario({ onVolver }) {
  const [nombre, setNombre] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [rol, setRol] = useState('OPERARIO')
  const [mensaje, setMensaje] = useState('')
  const [error, setError] = useState('')

  const handleRegistro = async (e) => {
    e.preventDefault()
    setMensaje('')
    setError('')

    try {
      // Sustituimos http://localhost:8080 por API_BASE_URL
      const response = await fetch(`${API_BASE_URL}/api/usuarios/registro`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nombre, email, password, rol })
      })

      if (response.ok) {
        setMensaje('¡Usuario registrado con éxito!')
        setNombre('')
        setEmail('')
        setPassword('')
      } else {
        setError('No se pudo registrar el usuario.')
      }
    } catch (err) {
      console.error(err)
      setError('Error al conectar con el servidor')
    }
  }

  return (
    <div className="inicio-container">
      <div className="inicio-card">
        
        <div className="inicio-badge">
          <span>Panel de Administración</span>
        </div>

        <div className="inicio-icon">
          ➕
        </div>

        <h1>Alta de Usuario</h1>

        <form onSubmit={handleRegistro} className="inicio-login-form">
          <div className="inicio-input-group">
            <label>Nombre de Usuario</label>
            <input
              type="text"
              placeholder="Ej: operario2"
              value={nombre}
              onChange={(e) => setNombre(e.target.value)}
              required
            />
          </div>

          <div className="inicio-input-group">
            <label>Correo Electrónico</label>
            <input
              type="email"
              placeholder="correo@empresa.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          <div className="inicio-input-group">
            <label>Contraseña</label>
            <input
              type="password"
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          <div className="inicio-input-group">
            <label>Rol</label>
            <select 
              value={rol} 
              onChange={(e) => setRol(e.target.value)}
              style={{ width: '100%', padding: '10px', borderRadius: '8px', border: '1px solid #ddd', fontSize: '14px' }}
            >
              <option value="OPERARIO">OPERARIO</option>
              <option value="ADMIN">ADMIN</option>
            </select>
          </div>

          {mensaje && <div style={{ color: '#27ae60', textAlign: 'center', fontWeight: '500' }}>{mensaje}</div>}
          {error && <div className="inicio-error">{error}</div>}

          <button type="submit" className="inicio-button" style={{ backgroundColor: '#27ae60' }}>
            <span>💾</span> Guardar Usuario
          </button>

          <button type="button" className="inicio-button" onClick={onVolver} style={{ backgroundColor: '#7f8c8d', marginTop: '10px' }}>
            <span>⬅️</span> Volver
          </button>
        </form>

      </div>
    </div>
  )
}

export default RegistroUsuario