## Funktion 1) Prüft ob die Variable ein Factor oder Character ist

kategoriale_variablen <- function(data, var) {
  ##Überprüfen, ob die Variable ein Factor oder Character ist
  if (!is.factor(data[[var]]) && !is.character(data[[var]])) {
    stop("Die Variable muss ein Factor oder Character sein.")
  }


## Funktion 2) Prüft ob Variablen existieren

bivariate_kategorial <- function(data, var1, var2) {
  # Überprüfen, ob Variablen existieren
  if (!(var1 %in% names(data)) || !(var2 %in% names(data))) {
    stop("Eine oder beide Variablen sind nicht im Datensatz vorhanden.")
  }
