# --- Seção Adicional: Solução Alternativa (Diretórios Temporários) ---
#
# Objetivo: Instalar e carregar pacotes quando há erro de permissão de
#           escrita na biblioteca padrão do R.
# --------------------------------------------------------------------

cat("--- Teste de Solução Alternativa: Diretório Temporário ---\n\n")
cat("[INFO] Este teste verifica se é possível instalar pacotes em um diretório temporário.\n")
cat("[INFO] Esta é uma solução alternativa comum se a instalação normal falhar por 'permissão negada'.\n\n")

# 1. Obter o caminho para um diretório temporário
#    A função tempdir() retorna um local onde o usuário ATUAL tem permissão de escrita.
diretorio_temporario <- tempdir()
cat(paste("[INFO] O diretório temporário para esta sessão é:", diretorio_temporario, "\n\n"))

# 2. Definir um pacote de exemplo (pequeno e rápido de instalar)
pacote_exemplo <- "crayon"

# 3. Tentar INSTALAR o pacote no diretório temporário
cat(paste("[INFO] Tentando instalar '", pacote_exemplo, "' em:\n", diretorio_temporario, "\n"))

install_temp_success <- tryCatch({
  # A mágica está no argumento 'lib = ...'
  install.packages(pacote_exemplo,
                   lib = diretorio_temporario,
                   repos = "https://cran.rstudio.com/")
  TRUE
}, error = function(e) {
  cat(paste("[ERRO DE INSTALAÇÃO TEMPORÁRIA] Mensagem:", e$message, "\n"))
  return(FALSE)
})

if (!install_temp_success) {
  cat("[FALHA] A instalação no diretório temporário também falhou. Isso é incomum.\n\n")
} else {
  cat("[SUCESSO] Pacote 'crayon' instalado no diretório temporário.\n\n")
  
  # 4. Tentar CARREGAR o pacote do diretório temporário
  cat(paste("[INFO] Tentando carregar '", pacote_exemplo, "' do diretório temporário...\n"))
  
  load_temp_success <- tryCatch({
    # A mágica está no argumento 'lib.loc = ...'
    library(pacote_exemplo,
            lib.loc = diretorio_temporario,
            character.only = TRUE)
    TRUE
  }, error = function(e) {
    cat(paste("[ERRO DE CARREGAMENTO TEMPORÁRIO] Mensagem:", e$message, "\n"))
    return(FALSE)
  })
  
  if (load_temp_success) {
    cat("[SUCESSO] Pacote carregado com sucesso do diretório temporário.\n")
    
    # Teste de funcionalidade
    cat("[INFO] Testando funcionalidade do pacote (texto colorido):\n")
    try(print(crayon::bold$blue("Se este texto estiver azul e em negrito, funcionou!")))
    
    # 5. Limpeza (desanexar o pacote)
    # É uma boa prática desanexar após o teste
    detach_name <- paste0("package:", pacote_exemplo)
    detach(detach_name, unload = TRUE, character.only = TRUE)
    cat(paste("\n[INFO] Pacote '", pacote_exemplo, "' desanexado.\n"))
    
  } else {
    cat(paste("[FALHA] Não foi possível carregar o pacote '", pacote_exemplo, "' do diretório temporário.\n\n"))
  }
}

cat("--- Fim do Teste de Solução Alternativa ---\n\n")
cat("[RESUMO] Se esta seção teve [SUCESSO], instrua os alunos a usar:\n")
cat("1. meu_dir <- tempdir()\n")
cat("2. install.packages('nome_do_pacote', lib = meu_dir)\n")
cat("3. library('nome_do_pacote', lib.loc = meu_dir)\n")
cat("...no início de cada aula para os pacotes necessários.\n")