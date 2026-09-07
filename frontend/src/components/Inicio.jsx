import { useState } from 'react'
import './Inicio.css'

function Inicio({ usuario, onLoginSuccess, onCargas }) {
  const [nombreUsuario, setNombreUsuario] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')

  const handleLogin = async (e) => {
    e.preventDefault()
    setError('')

    try {
      const response = await fetch('http://localhost:8080/api/usuarios/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nombre: nombreUsuario, password: password })
      })

      if (response.ok) {
        const usuarioData = await response.json()
        onLoginSuccess(usuarioData)
      } else {
        setError('Credenciales incorrectas')
      }
    } catch (err) {
      console.error("Error capturado en el frontend:", err)
      setError('Error al conectar con el servidor')
    }
  }

  // Función para cerrar sesión limpiando el estado del usuario
  const handleLogout = () => {
    onLoginSuccess(null)
    setNombreUsuario('')
    setPassword('')
  }

  return (
    <div className="inicio-container">
      <div className="inicio-card">

        <div className="inicio-badge">
          <span>Logística & Expediciones</span>
        </div>

        <div className="inicio-icon">
          🚛
        </div>

        <h1>Gestión de Cargas</h1>

        {!usuario ? (
          <form onSubmit={handleLogin} className="inicio-login-form">
            <p className="inicio-subtitle">
              Ingresa tus credenciales para acceder al sistema
            </p>

            <div className="inicio-input-group">
              <label>Usuario</label>
              <input
                type="text"
                placeholder="Ej: admin"
                value={nombreUsuario}
                onChange={(e) => setNombreUsuario(e.target.value)}
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

            {error && <div className="inicio-error">{error}</div>}

            <button type="submit" className="inicio-button">
              <span>🔑</span> Iniciar Sesión
            </button>
          </form>
        ) : (
          <div className="inicio-usuario-bienvenida">
            <p className="inicio-welcome-text">
              Bienvenido, <strong>{usuario.nombre}</strong> ({usuario.rol})
            </p>
            <p>
              Sistema de gestión y control centralizado de expediciones, palés y pedidos.
            </p>

            <button className="inicio-button" onClick={onCargas}>
              <span>📦</span> Ir a Cargas
            </button>

            {/* Botón de Cerrar Sesión */}
            <button 
              className="inicio-button" 
              onClick={handleLogout} 
              style={{ backgroundColor: '#e74c3c', marginTop: '10px' }}
            >
              <span>🚪</span> Cerrar Sesión
            </button>
          </div>
        )}

      </div>

      <footer className="inicio-footer">
        © {new Date().getFullYear()} Sistema de Gestión de Cargas — Todos los derechos reservados.
      </footer>
    </div>
  )
}

export default Inicio