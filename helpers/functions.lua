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

function datetimeToUnix(datetime_str)
    -- Parsea la cadena para extraer los campos de la fecha y hora
    local day, month, year, hour, min, sec = datetime_str:match("(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)")

    -- Crea una tabla con los campos de la fecha y hora
    local datetime_tbl = {
        day = tonumber(day),
        month = tonumber(month),
        year = tonumber(year),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec)
    }

    -- Convierte la tabla a tiempo Unix
    local unixtime = os.time(datetime_tbl)

    return unixtime
end

function unixToDatetime(unixtime)
    -- Formatea el tiempo Unix como una cadena de fecha y hora
    local datetime_str = os.date("%d/%m/%Y %H:%M:%S", unixtime)

    return datetime_str
end

function guardarVariable(variable, archivo)
    local file = io.open(archivo, "w")  -- abre el archivo en modo de escritura
    if file then
        file:write(tostring(variable))  -- escribe el estado en el archivo
        file:close()  -- cierra el archivo
    else
        print("Error al abrir el archivo " .. archivo)
    end
end

function cargarVariable(archivo)
    local file = io.open(archivo, "r")  -- abre el archivo en modo de lectura
    if file then
        local fecha = file:read("*a")  -- lee todo el archivo
        file:close()  -- cierra el archivo
        return fecha
    else
        print("Error al abrir el archivo " .. archivo)
    end
end