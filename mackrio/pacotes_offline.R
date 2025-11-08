# --- Script de Instalação Offline para Alunos ---
#
# Este script instala pacotes a partir de uma pasta local,
# pois o laboratório não tem acesso à internet (CRAN).
#
# Ele também instala em uma pasta temporária, pois não
# temos permissão para instalar na pasta principal do R.
# ----------------------------------------------------

cat("--- Iniciando a instalação de pacotes locais ---\n\n")

# 1. Definir a pasta onde o ADM salvou os pacotes .zip
pasta_pacotes_zip <- pasta_zips
pasta_pacotes_zip <- "C:\\Users\\marcs\\AppData\\Local\\Temp\\Rtmp8scTVo/R_Offline_Download"

# 2. Criar uma biblioteca (pasta) temporária SÓ PARA ESTA SESSÃO
#    para onde os pacotes serão de fato instalados.
#    Nós TEMOS permissão para escrever aqui.
minha_lib <- file.path(tempdir(), "R_Oficina_Biblioteca")
if (!dir.exists(minha_lib)) {
  dir.create(minha_lib)
}

cat(paste("[INFO] A biblioteca temporária foi criada em:", minha_lib, "\n"))
cat("[INFO] Os pacotes serão instalados lá.\n\n")

# 3. Listar TODOS os arquivos .zip na pasta de pacotes
cat(paste("[INFO] Lendo pacotes da pasta:", pasta_pacotes_zip, "\n"))
lista_de_zips <- list.files(pasta_pacotes_zip,
                            pattern = "\\.zip$",
                            full.names = TRUE)

if (length(lista_de_zips) == 0) {
  cat("[FALHA] Nenhum arquivo .zip encontrado em C:/Temp/r_packages/\n")
  cat("[FALHA] Por favor, chame o professor. O administrador precisa colocar os arquivos na pasta.\n")
} else {
  cat(paste("[INFO] Encontrados", length(lista_de_zips), "pacotes .zip para instalar.\n"))
  cat("[INFO] Iniciando instalação... Isso pode demorar alguns minutos.\n\n")
  
  install.packages(lista_de_zips,
                   lib = minha_lib,     
                   repos = NULL,        
                   type = "binary")     
  
  cat("\n--- INSTALAÇÃO CONCLUÍDA! ---\n\n")
  cat("Para carregar um pacote, use o comando:\n")
  cat("library(NOME_DO_PACOTE, lib.loc = minha_lib)\n\n")
  cat("Por exemplo, para carregar o dplyr:\n")
  cat("library(dplyr, lib.loc = minha_lib)\n")
}

# --- Fim do script ---



