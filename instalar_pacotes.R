# --- Script de Configuração da Sessão da Oficina ---
#
# OBJETIVO: Este script, quando executado (via 'source'),
# prepara o ambiente de R para o minicurso.
#
# O QUE ELE FAZ:
# 1. Cria uma pasta de biblioteca de pacotes temporária.
# 2. Instala todos os pacotes (.zip) necessários nessa pasta.
# 3. Define essa pasta como o local padrão para carregar pacotes.
#
# -----------------------------------------------------------------

cat("===============================================================\n")
cat("[INFO] Iniciando a configuração do ambiente para a Oficina de R\n")
cat("===============================================================\n\n")


dir_name <- "C:/Temp/pacotes_r/"

cat(paste0("Definir diretório com os arquivos. \n Se estão em: ",dir_name,". DIGITE ENTER ABAIXO\n"))

novo_dir_name <- readline(prompt = "Entre o nome do diretório com os arquivos: ")

if(novo_dir_name != "") dir_name = novo_dir_name

print("\n --  -- \n")
print(dir_name)
print("\n --  -- \n")

dir_name <- "C:\\Users\\marcs\\AppData\\Local\\Temp\\Rtmp4ygY3t\\R_Offline_Download\\"


minha_lib_temporaria <- file.path(tempdir(), "R_000_Minicurso_Biblioteca")
dir.create(minha_lib_temporaria, showWarnings = FALSE, recursive = TRUE)


lista_de_zips <- list.files(dir_name,
                            pattern = "\\.zip$",
                            full.names = TRUE)


if (length(lista_de_zips) == 0) {
  cat(paste0("[FALHA] Nenhum pacote (.zip) encontrado em ",dir_name,"\n"))
  cat("[FALHA] Por favor, verifique o caminho e chame o professor.\n")
  
} else {
  
  cat(paste("[INFO] Instalando pacotes (e dependências) na biblioteca temporária...\n"))
  cat("[INFO] A instalação pode demorar, por favor, não feche o R...\n\n\n")
  
  # install.packages() irá instalar TODOS os zips na ordem correta de dependência.
  install.packages(lista_de_zips,
                   lib = minha_lib_temporaria,
                   repos = NULL,
                   type = "binary",
                   quiet = TRUE)
  
  cat("[INFO] Instalação concluída.\n")
  
  .libPaths(c(minha_lib_temporaria, .libPaths()))

  cat("\n===============================================================\n")
  cat("[SUCESSO] Ambiente configurado!\n")
  cat(paste("[INFO] Os pacotes agora estão instalados em:", minha_lib_temporaria, "\n"))
  cat("===============================================================\n")
}

# Limpar variáveis do ambiente "Global Environment"
rm(list = c("dir_name", "minha_lib_temporaria", "lista_de_zips"))