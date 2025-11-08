# --- Script do Administrador para Baixar Pacotes Offline ---
#
# Este script baixa os pacotes-chave E TODAS AS SUAS DEPENDÊNCIAS
# como arquivos binários .zip do Windows.
# -----------------------------------------------------------

cat("--- Iniciando o download dos pacotes e dependências ---\n\n")

# 1. Defina os pacotes-chave para o minicurso.
#    O 'tidyverse' é um meta-pacote que já inclui
#    dplyr, ggplot2, readr, tidyr, etc.
pacotes_base <- c(
  "tidyverse",  # Coletânea principal (dplyr, ggplot2, readr...)
  "rmarkdown",  # Para relatórios (puxa knitr, htmltools...)
  "readxl",     # Para ler arquivos Excel (.xls, .xlsx)
  "jsonlite",   # Para ler dados em formato JSON
  "httr",        # Para comunicação web/APIs
  "litedown",
  "sidrar",
  "readxl",
  "lubridate",
  "stringr",
  "tidyr"
)

# 1. A pasta onde o "Admin" salvará os .zip
#    (Usando tempdir() para ser fácil de limpar depois)
pasta_zips <- file.path(tempdir(), "R_Offline_Download")
if (!dir.exists(pasta_zips)) {
  dir.create(pasta_zips)
}

# 2. A pasta onde o "Aluno" instalará os pacotes
minha_lib <- file.path(tempdir(), "R_Minicurso_Biblioteca")
if (!dir.exists(minha_lib)) {
  dir.create(minha_lib)
}

cat(paste("[INFO] Os arquivos .zip serão baixados para:", pasta_zips, "\n\n"))

# 3. Obter a lista de TODOS os pacotes disponíveis no CRAN
#    (para a versão Windows binária)
db <- available.packages(type = "win.binary",
                         repos = "https://cran.rstudio.com/")

# 4. Encontrar TODAS as dependências (recursivamente)
cat("[INFO] Mapeando todas as dependências (recursive = TRUE)...\n")
lista_deps <- tools::package_dependencies(pacotes_base,
                                          db = db,
                                          recursive = TRUE)

# 5. Criar a lista final de pacotes para baixar
#    (inclui os pacotes base + todas as dependências únicas)
pacotes_para_baixar <- unique(c(pacotes_base, unlist(lista_deps)))

cat(paste("[INFO] Total de pacotes a serem baixados (incluindo dependências):",
          length(pacotes_para_baixar), "\n"))
print(pacotes_para_baixar)
cat("\n")

# 6. Baixar os pacotes
cat("[INFO] Iniciando o download... Isso pode demorar bastante.\n")

download.packages(pacotes_para_baixar,
                  destdir = pasta_zips,
                  type = "win.binary") # Baixa os .zip para Windows

cat("\n--- DOWNLOAD CONCLUÍDO! ---\n\n")
cat("AÇÃO NECESSÁRIA:\n")
cat("1. Vá para a pasta:", pasta_zips, "\n")
cat("2. Copie TODOS os arquivos .zip que foram baixados.\n")
cat("3. Cole-os na pasta de rede do laboratório: C:/Temp/r_packages/\n")
cat("Os alunos agora podem rodar o 'Script Parte 1'.\n")

# --- Fim do script ---