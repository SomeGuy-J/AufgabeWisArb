##i) Eine Funktion, die verschiedene geeignete deskriptive Statistiken für metrische Variablen berechnet und ausgibt:

deskriptive_statistik_metrischer_variabeln <- function(titanic) {
  ## Fehlende Werte entfernen:
  titanic_clean <- titanic[!is.na(x)]
  ## Bestimmung der Anzahl der Beobachtungen:
  n <- length(titanic_clean)
  ## Berechnung des arithmetischen Mittels:
  aritmetisches_mittel <- sum(titanic_clean) / n
  ## Berechnung des Medians:
  ## Sortierung der Daten + Bestimmung des Mittelwertes der mittleren Werte (bei gerader Anzahl) oder des mittleren Wertes (bei ungerader Anzahl):
  titanic_sortiert <- sort(titanic_clean)
  if(n %% 2 == 1) { 
    median <- titanic_sortiert[(n + 1) / 2]
  } else {
    median <- (titanic_sortiert[n/2] + titanic_sortiert[n/2 + 1]) / 2
  }
  ## Bestimmen von Minimum und Maximum:
  min <- titanic_sortiert[1]
  max <- titanic_sortiert[n]
  ## Berechnung der Stichprobenvarianz: 
  varianz <- sum((titanic_clean - arithmetisches_mittel)^2) / (n - 1)
  ## Standardabweichung:
  standartabweichung <- sqrt(varianz)
  ## Berechnung der Quantile (25%, 50%, 75%):
  q1 <- quantile(titanic_clean, probs = 0.25, names = FALSE)
  q2 <- quantile(titanic_clean, probs = 0.50, names = FALSE)  
  q3 <- quantile(titanic_clean, probs = 0.75, names = FALSE)
  # q2 entspricht auch dem Median
  ## Berechnung des Interquartilsabstands (IQR):
  IQR <- q3 - q1
  ## Zusammenstellung der Ergebnisse in Form einer Liste:
  result <- list(
    N = n, Arithmetisches_Mittel = aritmetisches_mittel, Median = median, Minimum = min, Maximum = max, Varianz = varianz, Standardabweichung = standartabweichung, Q1 = q1, Q2 = q2, Q3 = q3, IQR = IQR)
  return(result)
}
## Es folgt eine Darstellung aller zu vor genannten Berechnungen.

##ii) Eine Funktion, die verschiedene geignete deskriptive Stastiken für kategoriale Variablen berechnet und ausgibt.
##Funktion zur Berechnung deskriptiver Statistiken für kategoriale Variablen

kategoriale_variablen <- function(data, var) {
  ##Überprüfen, ob die Variable ein Factor oder Character ist
  if (!is.factor(data[[var]]) && !is.character(data[[var]])) {
    stop("Die Variable muss ein Factor oder Character sein.")
  }
  
  ##Häufigkeiten der Kategorien berechnen
  freq_table <- table(data[[var]])
  
  ##Modus berechnen
  mode <- names(freq_table)[which.max(freq_table)]
  
  ##Relative Häufigkeiten berechnen
  prop_table <- round(prop.table(freq_table)*100,3)
  
  ##Ergebnisse in einer Liste zusammenfassen
  results <- list(
    Frequency = freq_table,
    Mode = mode,
    Proportion = prop_table
  )
  
  return(results)
}
## iii)Eine Funktion, die geeignete deskriptive bivariate Statistiken für den Zusammenhang zwischen zwei kategorialen Variablen berechnet ausgibt 


bivariate_kategorial <- function(data, var1, var2) {
  # Überprüfen, ob Variablen existieren
  if (!(var1 %in% names(data)) || !(var2 %in% names(data))) {
    stop("Eine oder beide Variablen sind nicht im Datensatz vorhanden.")
  }
  
  # Sicherstellen, dass beide Variablen als Faktoren behandelt werden
  data[[var1]] <- as.factor(data[[var1]])
  data[[var2]] <- as.factor(data[[var2]])
  
  # Erstellen der Kontingenztabelle (absolute Häufigkeiten)
  kontingenztabelle <- table(data[[var1]], data[[var2]])
  
  # Relative Häufigkeiten berechnen
  row_perc <- prop.table(kontingenztabelle, margin = 1) * 100  # Zeilen-Prozente
  col_perc <- prop.table(kontingenztabelle, margin = 2) * 100  # Spalten-Prozente
  
  # Chi-Quadrat-Test (für Unabhängigkeit der Variablen)
  chi_test <- chisq.test(kontingenztabelle)
  
  # Berechnung von Cramérs V (nur wenn Test gültig ist)
  cramers_v <- sqrt(chi_test$statistic / (sum(kontingenztabelle) * (min(dim(kontingenztabelle)) - 1)))
  
  # Ergebnisse in einer Liste zusammenfassen
  results <- list(
    "Kontingenztabelle" = kontingenztabelle,
    "Zeilenprozentsätze (%)" = row_perc,
    "Spaltenprozentsätze (%)" = col_perc,
    "Chi-Quadrat-Test" = chi_test,
    "Cramérs V" = cramers_v
  )
  
  return(results)
}






## iv) Eine Funktion zur Analyse des Zusammenhangs bzw. der Korrelation zwischen einer metrischen und einer dichotomen Variablen
analyze_metric_dichotomous <- function(data, metric_var, dichotomous_var) {
  ## Überprüfung der Variablen, falls nicht vorhanden Fehlerausgabe, sonst Funktion anwenden
  
  if (!(metric_var %in% names(data)) | !(dichotomous_var %in% names(data))) {
    stop("Eine oder beide Variablen sind nicht im Datensatz vorhanden.")
  }
  
  ## Überprüfung der dichotomen Variable (ob sie nur 2 Merkmalsausprägungen hat)
  unique_vals <- unique(data[[dichotomous_var]])
  if (length(unique_vals) != 2) {
    stop("Die dichotome Variable muss genau zwei Kategorien haben.")
  }
  
  ## NA-Werten löschen
  data_clean <- na.omit(data[, c(metric_var, dichotomous_var)])
  
  ## Mittelwert und Standardabweichung
  summary_stats <- aggregate(
    data_clean[[metric_var]],
    by = list(Group = data_clean[[dichotomous_var]]),
    FUN = function(x) c(Mean = mean(x), SD = sd(x))
  )
  
  ## Lesbarkeit verbessern
  summary_stats <- do.call(data.frame, summary_stats)
  
  ## Spaltennamen hinzufügen
  colnames(summary_stats) <- c(dichotomous_var, "Mean", "SD")
  
  ## Ausgabe der deskriptiven Statistiken
  cat("Deskriptive Statistiken:\n")
  print(summary_stats)
  
  ## T-Test zum Vergleich der Mittelwerte der Gruppen
  t_test_result <- t.test(
    data_clean[[metric_var]] ~ data_clean[[dichotomous_var]]
  )
  
  ## Ausgabe der Ergebnisse des t-Tests
  cat("\nErgebnisse des t-Tests:\n")
  print(t_test_result)
}

## v) Eine Funktion, die eine geeignete Visualisierung von drei oder vier kategorialen Variablen erstellt

# Hinweis: es wird das Paket "vcd" benötigt
kategoriell <- function(x, y, z, v = NULL, main = "Mosaikaplot", col = c("lightblue", "lightgreen", "salmon", "lightpink")){
  
  # Extrahiere die Variablennamen
  name_x <- as.character(substitute(x))[length(as.character(substitute(x)))]
  name_y <- as.character(substitute(y))[length(as.character(substitute(y)))]
  name_z <- as.character(substitute(z))[length(as.character(substitute(z)))]
  name_v <- as.character(substitute(v))[length(as.character(substitute(v)))]
  
  # Extrahiere die levels der 3. und 4. Kategorie
  levels2 <- unique(z)
  levels1 <- if (!is.null(v)) unique(v) else unique(z)
  
  # Verlängere ggf. die Farbpalette
  if(length(col) < length(levels1)){
    col <- brewer.pal((length(levels1)), "Pastel1")
  }
  
  # Definiere den Layout so, damit man unten eine schöne, lesbare Legende für die letzte
  # Kategorie einfügen kann
  layout(matrix(c(1, 2), nrow = 2), heights = c(5, 1))
  
  # Anpassung vom Fit, damit alle Beschriftungen passen
  if(is.null(v)) {
    par(mar = c(5, 5, 4, 2))
  } else {
    par(mar = c(6, 6, 4, 2))
  }
  
  if(is.null(v)){
    mosaicplot(table(x, y, z), main = main, color = col[1:length(levels2)], 
               xlab = name_x, ylab = name_y)
  }
  else{
    mosaicplot(table(x, y, z, v), main = main, color = col[1:length(levels1)], 
               xlab = name_z, ylab = name_y)
    # Beschrifte die erste Unterteilung oben und die Dritte (im Falle von 4) unten
    mtext(name_x, side = 3, line = 0.1, cex = 1.2, font = 1)
  }
  
  par(mar = c(0, 0, 0, 0))
  plot.new()
  legend("center", legend = levels1, 
         fill = col[1:length(levels1)],
         title = ifelse(is.null(v), name_z, name_v), horiz = T)
}
