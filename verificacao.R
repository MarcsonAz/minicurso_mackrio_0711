# --- Script de Teste Completo (Simulação Admin + Aluno) ---

# --- Configuração Inicial: Nossos diretórios de teste ---

# 1. A pasta onde o "Admin" salvará os .zip
#    (Usando tempdir() para ser fácil de limpar depois)
pasta_zips_teste <- file.path(tempdir(), "R_Offline_Download_TESTE")
if (!dir.exists(pasta_zips_teste)) {
  dir.create(pasta_zips_teste)
}

# 2. A pasta onde o "Aluno" instalará os pacotes
minha_lib_teste <- file.path(tempdir(), "R_Minicurso_Biblioteca_TESTE")
if (!dir.exists(minha_lib_teste)) {
  dir.create(minha_lib_teste)
}

cat(paste("[CONFIG] Pasta de Download (Admin):", pasta_zips_teste, "\n"))
cat(paste("[CONFIG] Pasta da Biblioteca (Aluno):", minha_lib_teste, "\n\n"))

# -------------------------------------------------------------------
# --- PARTE A: SIMULAÇÃO DO ADMINISTRADOR (BAIXAR PACOTES) ---
# -------------------------------------------------------------------

cat("--- PARTE A (ADMIN): Baixando pacotes .zip ---\n")

# Para este teste, vamos usar um conjunto menor de pacotes
# para ser mais rápido.
pacotes_chave_teste <- c(
  "dplyr",      # Um pacote popular
  "jsonlite"    # Uma dependência comum e leve
)

# Obter banco de dados de pacotes (binários de Windows)
db_teste <- available.packages(type = "win.binary",
                               repos = "https://cran.rstudio.com/")

# Encontrar dependências
lista_deps_teste <- tools::package_dependencies(pacotes_chave_teste,
                                                db = db_teste,
                                                recursive = TRUE)

pacotes_para_baixar_teste <- unique(c(pacotes_chave_teste, unlist(lista_deps_teste)))

cat(paste("[ADMIN] Total de pacotes a baixar (com dependências):",
          length(pacotes_para_baixar_teste), "\n"))
print(pacotes_para_baixar_teste)

# Baixar os pacotes para a pasta de teste
download.packages(pacotes_para_baixar_teste,
                  destdir = pasta_zips_teste,
                  type = "win.binary")

cat("\n[ADMIN] Download dos arquivos .zip concluído.\n\n")

# -------------------------------------------------------------------
# --- PARTE B: SIMULAÇÃO DO ALUNO (INSTALAR PACOTES) ---
# -------------------------------------------------------------------

cat("--- PARTE B (ALUNO): Instalando pacotes a partir dos .zip ---\n")

# Listar os zips que o "Admin" baixou
lista_de_zips_teste <- list.files(pasta_zips_teste,
                                  pattern = "\\.zip$",
                                  full.names = TRUE)

cat(paste("[ALUNO] Encontrados", length(lista_de_zips_teste), "arquivos .zip para instalar.\n"))

# Instalar os pacotes a partir dos arquivos locais,
# direcionando para a nossa biblioteca temporária
install.packages(lista_de_zips_teste,
                 lib = minha_lib_teste,  # Instala na nossa pasta
                 repos = NULL,           # NÃO usa a internet
                 type = "binary")

cat("\n[ALUNO] Instalação local concluída.\n\n")

# -------------------------------------------------------------------
# --- PARTE C: VERIFICAÇÃO (LISTA DE PACOTES ATIVOS) ---
# -------------------------------------------------------------------

cat("--- PARTE C (VERIFICAÇÃO): Listando pacotes ativos ---\n")

# A "lista de pacotes ativos na sessão" refere-se aos pacotes
# que foram CARREGADOS com a função library().
# A função para ver isso é search()

cat("\n[VERIFICAÇÃO] Pacotes carregados ANTES de ativar o 'dplyr':\n")
print(search())

# Agora, vamos CARREGAR (ativar) o 'dplyr'
# que acabamos de instalar na nossa biblioteca de teste.
cat("\n[VERIFICAÇÃO] Carregando 'dplyr' da biblioteca de teste...\n")
library(dplyr, lib.loc = minha_lib_teste)

cat("\n[VERIFICAÇÃO] Pacotes carregados DEPOIS de ativar o 'dplyr':\n")
print(search())
cat("\n[VERIFICAÇÃO] Você deve ver 'package:dplyr' listado acima.\n")

# BÔNUS: Testar se o pacote realmente funciona
cat("\n[VERIFICAÇÃO] Testando uma função do dplyr:\n")
tryCatch({
  df_teste <- starwars %>% filter(height > 170)
  print(head(df_teste, 3))
  cat("\n[SUCESSO] O pacote 'dplyr' foi instalado e carregado corretamente.\n")
}, error = function(e) {
  cat("[FALHA] Não foi possível usar o pacote 'dplyr'.\n")
})

# Limpeza: desanexar o pacote
detach("package:dplyr", unload = TRUE)
cat("\n[VERIFICAÇÃO] Pacote 'dplyr' desanexado.\n")


# BÔNUS 2: Para ver TODOS os pacotes INSTALADOS na sua
# biblioteca temporária (não apenas os "ativos"):
cat("\n[VERIFICAÇÃO] Lista de TODOS os pacotes INSTALADOS na biblioteca de teste:\n")
pacotes_instalados_teste <- installed.packages(lib.loc = minha_lib_teste)
print(pacotes_instalados_teste[, "Package"]) # Imprime só os nomes

cat("\n--- Teste Completo Concluído ---\n")


installed.packages(lib.loc = minha_lib)


