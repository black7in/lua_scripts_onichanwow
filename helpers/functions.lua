function obtenerNuevaCoordenada(x, y, z, orientacion, distancia, direccion)
    -- Variables para las orientaciones dependiendo de la dirección
    local angulo = 0

    -- Determinar el ángulo según la dirección:
    if direccion == "adelante" then
        angulo = orientacion -- Adelante es la dirección de la orientación actual
    elseif direccion == "atras" then
        angulo = orientacion + math.pi -- Atrás es la orientación + 180 grados (pi radianes)
    elseif direccion == "izquierda" then
        angulo = orientacion + (math.pi / 2) -- Izquierda es la orientación + 90 grados (pi/2 radianes)
    elseif direccion == "derecha" then
        angulo = orientacion - (math.pi / 2) -- Derecha es la orientación - 90 grados (pi/2 radianes)
    else
        print(
            "Dirección no válida. Usa: 'adelante', 'atras', 'izquierda' o 'derecha'.")
        return x, y, z
    end

    -- Calcular las nuevas coordenadas x e y
    local nuevo_x = x + distancia * math.cos(angulo)
    local nuevo_y = y + distancia * math.sin(angulo)

    -- La coordenada z no cambia
    local nuevo_z = z

    -- Retornar las nuevas coordenadas
    return nuevo_x, nuevo_y, nuevo_z
end