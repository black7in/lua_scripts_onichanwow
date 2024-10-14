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
        if fecha == "" then  -- si el archivo está vacío
            return nil
        else
            return fecha
        end
    else
        print("Error al abrir el archivo " .. archivo)
    end
end

function cargarVariablesEnv(archivo)
    local file = io.open(archivo, "r")  -- abre el archivo en modo de lectura
    if file then
        local variables = {}
        for line in file:lines() do  -- lee el archivo línea por línea
            local key, value = line:match("(%w+)=(.*)")  -- parsea la clave y el valor de cada línea
            if key and (value == nil or value == "") then
                variables[key] = nil
            elseif key and value then
                variables[key] = value
            end
        end
        file:close()  -- cierra el archivo
        return variables
    else
        print("Error al abrir el archivo " .. archivo)
    end
end

function cambiarVariableEnv(archivo, clave, nuevoValor)
    print("Cambiando variable " .. clave .. " a " .. nuevoValor)
    local file = io.open(archivo, "r")  -- abre el archivo en modo de lectura
    if file then
        local lines = {}
        for line in file:lines() do  -- lee el archivo línea por línea
            print("Leyendo línea: " .. line)  -- imprime la línea que se está leyendo
            local key = line:match("(%w+)=.*") or line:match("(%w+)=")  -- obtiene la clave de la línea
            if key == clave then
                table.insert(lines, clave .. "=" .. nuevoValor)  -- si la clave coincide, cambia el valor
            else
                table.insert(lines, line)  -- si no, mantiene la línea original
            end
        end
        file:close()  -- cierra el archivo

        -- Ahora, escribe de nuevo el archivo con las líneas modificadas
        file = io.open(archivo, "w")  -- abre el archivo en modo de escritura
        for _, line in ipairs(lines) do
            print("Escribiendo línea: " .. line)  -- imprime la línea que se está escribiendo
            file:write(line .. "\n")  -- escribe cada línea en el archivo
        end
        file:close()  -- cierra el archivo
    else
        print("Error al abrir el archivo " .. archivo)
    end
end