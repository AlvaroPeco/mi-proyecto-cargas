import { useEffect, useState } from 'react'
import './DetallePalet.css'

function DetallePalet({ palet, onVolver }) {

  const [datosPalet, setDatosPalet] = useState(null)
  const [pedidos, setPedidos] = useState([])
  const [cargando, setCargando] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {

    const cargarDatos = async () => {

      try {

        const respuestaPalet = await fetch(
          `http://localhost:8080/api/palets/${palet}`
        )

        if (!respuestaPalet.ok) {
          throw new Error('Error al obtener el palé')
        }

        const datos = await respuestaPalet.json()

        setDatosPalet(datos)

        const respuestaPedidos = await fetch(
          `http://localhost:8080/api/pedidos/palet/${palet}`
        )

        if (!respuestaPedidos.ok) {
          throw new Error('Error al obtener los pedidos')
        }

        const datosPedidos = await respuestaPedidos.json()

        setPedidos(datosPedidos)
        setCargando(false)

      } catch (error) {

        console.error(error)
        setError('No se ha podido cargar la información')
        setCargando(false)

      }
    }

    cargarDatos()

  }, [palet])

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
    <div className="detalle-palet-container">

      {cargando && (
        <div className="mensaje">
          Cargando información...
        </div>
      )}

      {error && (
        <div className="mensaje">
          {error}
        </div>
      )}

      {!cargando && !error && datosPalet && (
        <>

          <div className="detalle-palet-header">

            <h1>📦 Detalle del palé</h1>

            <div className="informacion-palet">

              <div className="dato-palet">
                <span>Código de escaneo</span>
                <strong>
                  {datosPalet.codEscaneo}
                </strong>
              </div>

              <div className="dato-palet">
                <span>Cliente</span>
                <strong>
                  {datosPalet.cliente.nombreEmpresa}
                </strong>
              </div>

              <div className="dato-palet">
                <span>Dirección</span>
                <strong>
                  {datosPalet.direccion.direccion}
                </strong>
              </div>

              <div className="dato-palet">
                <span>Población</span>
                <strong>
                  {datosPalet.direccion.poblacion}
                </strong>
              </div>

              <div className="dato-palet">
                <span>Provincia</span>
                <strong>
                  {datosPalet.direccion.provincia}
                </strong>
              </div>

              <div className="dato-palet">
                <span>Estado</span>
                <strong>
                  <span className={obtenerEstadoPalet(datosPalet.estado)}>
                    {mostrarEstadoPalet(datosPalet.estado)}
                  </span>
                </strong>
              </div>

            </div>

          </div>

          <div className="pedidos-container">

            <h2>📋 Pedidos del palé</h2>

            {pedidos.length === 0 ? (
              <p>Este palé no tiene pedidos.</p>
            ) : (
              <div className="pedidos-tabla-container">

                <table className="pedidos-tabla">

                  <thead>
                    <tr>
                      <th>ID Pedido</th>
                      <th>Artículo</th>
                      <th>Cantidad</th>
                    </tr>
                  </thead>

                  <tbody>

                    {pedidos.map((pedido) => (

                      <tr key={pedido.idPedido}>

                        <td>
                          {pedido.idPedido}
                        </td>

                        <td>
                          {pedido.articulo.nomArticulo}
                        </td>

                        <td>
                          {pedido.cantidad}
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

      <button
        className="volver-button"
        onClick={onVolver}
      >
        ← Volver
      </button>

    </div>
  )
}

export default DetallePalet