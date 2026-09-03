import './Inicio.css'

function Inicio({ onCargas }) {
  return (
    <div className="inicio-container">
      <div className="inicio-card">

        <div className="inicio-icon">
          🚛
        </div>

        <h1>Gestión de Cargas</h1>

        <p>
          Sistema de gestión y control de expediciones
        </p>

        <button className="inicio-button" onClick={onCargas}>
          <span>📦</span>
          Cargas
        </button>

      </div>

      <footer>
        Sistema de gestión de cargas
      </footer>
    </div>
  )
}

export default Inicio