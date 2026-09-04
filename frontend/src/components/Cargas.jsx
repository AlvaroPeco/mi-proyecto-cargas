import { useEffect, useState } from 'react'
import './Cargas.css'

function Cargas({ onSeleccionarCamion, onVolver }) {
  const [vehiculos, setVehiculos] = useState([])
  const [error, setError] = useState('')

  useEffect(() => {
    fetch('http://localhost:8080/api/vehiculos')
      .then((respuesta) => {
        if (!respuesta.ok) {
          throw new Error('Error al obtener los vehículos')
        }
        return respuesta.json()
      })
      .then((datos) => {
        setVehiculos(datos)
      })
      .catch((error) => {
        console.error(error)
        setError('No se han podido cargar los vehículos')
      })
  }, [])

  return (
    <div className="cargas-container">
      {/* Tarjeta contenedora principal */}
      <div className="cargas-card">
        
        {/* Cabecera con botón volver y título */}
        <div className="cargas-header">
          <button className="volver-button" onClick={onVolver}>
            ← Volver
          </button>
          
          <div className="titulo-cargas">
            <h1>Gestión de Cargas</h1>
            <p>Selecciona el vehículo</p>
          </div>
        </div>

        {error && <p className="error-mensaje">{error}</p>}

        {/* Grilla de vehículos */}
        <div className="camiones-grid">
          {vehiculos.map((vehiculo) => {
            const esFurgoneta = vehiculo.nombre.toLowerCase().includes('furgoneta')

            return (
              <button
                key={vehiculo.idVehiculo}
                className="camion-button"
                onClick={() => onSeleccionarCamion(vehiculo.idVehiculo)}
              >
                <span>{esFurgoneta ? '🚐' : '🚛'}</span>
                <strong>{vehiculo.nombre}</strong>
                <small>{vehiculo.matricula}</small>
              </button>
            )
          })}
        </div>

      </div>
    </div>
  )
}

export default Cargas