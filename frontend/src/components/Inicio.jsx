import './Inicio.css'

function Inicio({ onCargas }) {
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

        <p>
          Sistema de gestión y control centralizado de expediciones, palés y pedidos.
        </p>

        <button className="inicio-button" onClick={onCargas}>
          <span>📦</span> Ir a Cargas
        </button>

      </div>

      <footer className="inicio-footer">
        © {new Date().getFullYear()} Sistema de Gestión de Cargas — Todos los derechos reservados.
      </footer>
    </div>
  )
}

export default Inicio