library(readxl)
library(dplyr)

# Cargar las bases de datos desde Excel
eje <- read_csv("/workdir/tests/data/eje.csv")
con2 <- read_csv("/workdir/tests/data/con2_contratos.csv")


# Seleccionar las columnas necesarias y renombrarlas para facilitar el cruce
eje <- eje %>%
  select(`Centro gestor`, `Posición presupuestaria`, `Modificado`) %>%
  rename(Centro_Gestor = `Centro gestor`,
         Partida = `Posición presupuestaria`,
         Modificado = `Modificado`)

con2 <- con2 %>%
  select(`Unidad Administrativa`, `Partida`, `No. contrato`, `Total ampliación`) %>%
  rename(Centro_Gestor = `Unidad Administrativa`,
         Partida = `Partida`,
         No_Contrato = `No. contrato`,
         Monto = `Total ampliación`)  # Cambio aquí

# Convertir 'Partida' al mismo tipo en ambas bases de datos
con2 <- con2 %>%
  mutate(Partida = as.character(Partida))  # Convertimos a texto para coincidir con 'eje'

eje <- eje %>%
  mutate(Partida = as.character(Partida))  # (Por si no estaba claro)

# Unir las bases de datos usando 'Centro_Gestor' y 'Partida' como claves
df_final <- left_join(con2, eje, by = c("Centro_Gestor", "Partida"))

# Crear la columna de porcentaje pagado (evitando división por 0)
df_final <- df_final %>%
  mutate(Porcentaje_Pagado = ifelse(Monto == 0, NA, (Modificado / Monto) * 100))

# Contar el número de contratos por partida
df_final <- df_final %>%
  group_by(Centro_Gestor, Partida) %>%
  mutate(Numero_Contratos = n()) %>%
  ungroup()

# Mostrar la tabla resultante
print(df_final)


# Mostrar la tabla resultante
print(df_final)

# Instalar y cargar librería para visualizar los datos en una tabla interactiva
install.packages("DT")
library(DT)

# Mostrar la tabla en formato interactivo
datatable(df_final)

