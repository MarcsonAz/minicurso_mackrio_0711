### Código R de Teste de Configuração do Laboratório
  
# --- Script de Teste de Configuração do Laboratório R ---
#
# Instruções:
# 1. Copie e cole TODO este código no Console do RStudio ou em um script.
# 2. Execute o código.
# 3. Analise as mensagens [INFO], [SUCESSO] e [FALHA] no Console.
# ---------------------------------------------------------

cat("--- INICIANDO TESTE DE DIAGNÓSTICO DO AMBIENTE R ---\n\n")

# --- Seção 1: Informações do Sistema e Permissões ---
cat("--- Seção 1: Informações do Sistema e Permissões ---\n")

# Teste 1.1: Versão do R e SO
cat("[INFO] Versão do R:\n")
print(R.version.string)
cat("\n[INFO] Informações da Sessão (Sistema Operacional):\n")
print(sessionInfo())
cat("\n")

# Teste 1.2: Permissão de Escrita no Diretório Atual
cat("[INFO] Testando permissão de escrita no diretório atual:", getwd(), "\n")
test_file <- "teste_de_escrita_temp.txt"
write_permission <- tryCatch({
  file.create(test_file)
  if (file.exists(test_file)) {
    file.remove(test_file)
    TRUE
  } else {
    FALSE
  }
}, error = function(e) {
  cat("[ERRO AO ESCREVER] Mensagem:", e$message, "\n")
  return(FALSE)
})

if (write_permission) {
  cat("[SUCESSO] Permissão de escrita no diretório atual OK.\n\n")
} else {
  cat("[FALHA] Não foi possível escrever arquivos no diretório atual. Isso pode impedir salvar scripts ou baixar dados.\n\n")
}

# --- Seção 2: Conectividade com Repositórios (CRAN) ---
cat("--- Seção 2: Conectividade com Repositórios (CRAN) ---\n")

# Teste 2.1: Verificar repositório
cat("[INFO] Repositório CRAN configurado:", getOption("repos")["CRAN"], "\n")

# Teste 2.2: Tentar listar pacotes do CRAN
cat("[INFO] Tentando conectar ao CRAN para listar pacotes (pode demorar um pouco)...\n")
cran_access <- tryCatch({
  # available.packages() baixa um índice grande, é um ótimo teste de rede.
  # Usamos 'suppressWarnings' para ocultar mensagens comuns de "repositório temporariamente indisponível"
  # que podem não ser erros fatais.
  suppressWarnings(db <- available.packages(repos = "https://cran.rstudio.com/"))
  # Verificamos se recebemos dados
  if (is.matrix(db) && nrow(db) > 1000) { # Um CRAN saudável tem milhares de pacotes
    TRUE
  } else {
    FALSE
  }
}, error = function(e) {
  cat("[ERRO DE CONEXÃO CRAN] Mensagem:", e$message, "\n")
  return(FALSE)
})

if (cran_access) {
  cat("[SUCESSO] Conexão com o repositório CRAN (https://cran.rstudio.com/) bem-sucedida.\n\n")
} else {
  cat("[FALHA] Não foi possível conectar ou obter a lista de pacotes do CRAN. A instalação de pacotes provavelmente falhará.\n")
  cat("[INFO] Causa comum: Firewall da instituição, ausência de configuração de Proxy ou rede offline.\n\n")
}

# --- Seção 3 e 4: Instalação e Carregamento de Pacotes ---
cat("--- Seção 3 e 4: Instalação e Carregamento de Pacotes ---\n")
cat("[INFO] Tentando instalar e carregar pacotes essenciais.\n")
cat("[INFO] Isso pode falhar por bloqueio de rede ou falta de permissão de escrita na biblioteca.\n\n")

# Lista de pacotes populares para teste
pacotes_para_testar <- c(
  "jsonlite",    
  "dplyr",       
  "ggplot2",     
  "readr",       
  "data.table",  
  "rmarkdown",   
  "httr",
  "janitor",
  "tidyr"
)

# Limpar nomes de pacotes que já podem estar instalados para forçar o teste
# Nota: Em um ambiente de laboratório, pode ser melhor não reinstalar se já existir.
# Vamos verificar primeiro e só instalar se não existir.

for (pacote in pacotes_para_testar) {
  cat(paste0("--- Testando Pacote: ", pacote, " ---\n"))
  
  # --- Teste de Instalação (Seção 3) ---
  if (!requireNamespace(pacote, quietly = TRUE)) {
    cat(paste0("[INFO] '", pacote, "' não encontrado. Tentando instalar...\n"))
    
    install_success <- tryCatch({
      # 'dependencies=TRUE' é importante para simular o uso real
      install.packages(pacote, dependencies = TRUE, repos = "https://cran.rstudio.com/")
      TRUE
    }, error = function(e) {
      cat(paste0("[ERRO DE INSTALAÇÃO '", pacote, "'] Mensagem: ", e$message, "\n"))
      return(FALSE)
    })
    
    if (install_success) {
      cat(paste0("[SUCESSO] Instalação de '", pacote, "' concluída.\n"))
    } else {
      cat(paste0("[FALHA] Instalação de '", pacote, "' falhou.\n\n"))
      next # Pula para o próximo pacote se a instalação falhar
    }
    
  } else {
    cat(paste0("[INFO] '", pacote, "' já está instalado.\n"))
  }
  
  # --- Teste de Carregamento (Seção 4) ---
  cat(paste0("[INFO] Tentando carregar '", pacote, "'...\n"))
  
  load_success <- tryCatch({
    # Usamos 'require' pois ele retorna FALSE em falha, ao invés de parar o script
    # 'character.only = TRUE' é necessário para usar a variável 'pacote'
    if (require(pacote, character.only = TRUE)) {
      # Se carregou, vamos desanexar para manter o ambiente limpo
      detach(paste0("package:", pacote), unload = TRUE, character.only = TRUE)
      TRUE
    } else {
      FALSE
    }
  }, warning = function(w) {
    # Às vezes, um aviso pode indicar um problema (ex: pacote compilado para outra versão)
    cat(paste0("[AVISO AO CARREGAR '", pacote, "'] Mensagem: ", w$message, "\n"))
    # Mesmo com aviso, pode ter carregado
    return(require(pacote, character.only = TRUE, quietly = TRUE))
  }, error = function(e) {
    cat(paste0("[ERRO AO CARREGAR '", pacote, "'] Mensagem: ", e$message, "\n"))
    return(FALSE)
  })
  
  if (load_success) {
    cat(paste0("[SUCESSO] Carregamento de '", pacote, "' bem-sucedido.\n\n"))
  } else {
    cat(paste0("[FALHA] Carregamento de '", pacote, "' falhou. O pacote pode estar quebrado ou ter dependências ausentes.\n\n"))
  }
}

# --- Seção 5: Acesso à Internet (Links Externos) ---
cat("--- Seção 5: Acesso à Internet (Links Externos) ---\n")
cat("[INFO] Testando download de arquivo CSV de um link externo (GitHub).\n")

url_teste <- "https://raw.githubusercontent.com/tidyverse/readr/main/inst/extdata/mtcars.csv"
download_success <- tryCatch({
  # Usamos 'read.csv' diretamente pois 'download.file' pode exigir config de 'method' (curl, wininet)
  # 'read.csv' tentará usar o método padrão do R
  dados_teste <- read.csv(url_teste)
  # Se baixou e tem o número correto de colunas (11), consideramos sucesso
  if (is.data.frame(dados_teste) && ncol(dados_teste) == 11) {
    TRUE
  } else {
    FALSE
  }
}, error = function(e) {
  cat("[ERRO DE DOWNLOAD] Mensagem:", e$message, "\n")
  return(FALSE)
})

if (download_success) {
  cat("[SUCESSO] Download de arquivo de dados (CSV) de link externo (GitHub) funcionou.\n\n")
} else {
  cat("[FALHA] Não foi possível baixar dados de links externos. A instituição pode estar bloqueando o GitHub ou outros domínios.\n\n")
}

# --- Seção 6: Teste de Funcionalidade (Tidyverse) ---
cat("--- Seção 6: Teste de Funcionalidade (Tidyverse) ---\n")
cat("[INFO] Tentando executar um pipeline simples com dplyr (se instalado).\n")

if (requireNamespace("dplyr", quietly = TRUE)) {
  dplyr_test <- tryCatch({
    # Carrega silenciosamente
    suppressPackageStartupMessages(library(dplyr))
    
    # Executa teste
    resultado <- mtcars %>%
      group_by(cyl) %>%
      summarise(mpg_media = mean(mpg), .groups = 'drop')
    
    # Desanexa
    detach("package:dplyr", unload = TRUE)
    
    # Verifica
    if (is.data.frame(resultado) && nrow(resultado) == 3 && ncol(resultado) == 2) {
      TRUE
    } else {
      FALSE
    }
  }, error = function(e) {
    cat("[ERRO NO PIPELINE DPLYR] Mensagem:", e$message, "\n")
    return(FALSE)
  })
  
  if (dplyr_test) {
    cat("[SUCESSO] Pipeline básico do dplyr executado corretamente.\n\n")
  } else {
    cat("[FALHA] Pipeline básico do dplyr falhou, mesmo com o pacote parecendo estar instalado.\n\n")
  }
  
} else {
  cat("[INFO] Pacote 'dplyr' não foi instalado, pulando teste de pipeline.\n\n")
}


cat("--- DIAGNÓSTICO CONCLUÍDO ---\n")
cat("Revise as mensagens [FALHA] acima para identificar possíveis problemas no ambiente.\n")
```