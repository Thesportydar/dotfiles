# ~/.bash_profile
# Se ejecuta UNA VEZ al iniciar sesión.
# Prevenir doble carga de configuraciones.
if [[ -n "$BASH_PROFILE_ALREADY_RUN" ]]; then
    return
fi
export BASH_PROFILE_ALREADY_RUN=1

# --- CONFIGURACIÓN DE ENTORNO Y PATH ---

# Homebrew
# Configura las variables de entorno para Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Pyenv (Python Version Manager)
# Define la raíz de pyenv y lo inicializa.
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Certificados SSL para Python
# Asegura que Python y las librerías como 'requests' usen los certificados correctos.
export SSL_CERT_FILE="$(/usr/bin/python3 -m certifi)"
export REQUESTS_CA_BUNDLE="$(/usr/bin/python3 -m certifi)"

# Añadir otras rutas al PATH
# Agrupamos todas las modificaciones del PATH para mayor claridad.
export PATH="$PATH:/opt/homebrew/opt/openjdk@21/bin"
export PATH="$PATH:/opt/homebrew/opt/libpq/bin"
export PATH="$HOME/.local/bin:$PATH"

# Variables de entorno adicionales
export TERM="xterm-256color"  # Tipo de terminal para compatibilidad de colores.
export BW_USER='ipaladinobravo@gmail.com' # Usuario de Bitwarden.
export BASH_SILENCE_DEPRECATION_WARNING=1 # Silencia el aviso de obsolescencia de Bash en macOS.


# --- COMANDOS DE INICIO DE SESIÓN ---

# Muestra información del sistema al abrir una nueva terminal.
neofetch


# --- CARGAR CONFIGURACIÓN INTERACTIVA ---

# Al final, carga la configuración para shells interactivos desde .bashrc
# Esto asegura que tus alias y funciones estén disponibles.
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
