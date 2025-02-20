## R code für die Erste Aufgabe* 
##Lese datensatz ein 

install.packages("stringr")
install.packages("readxl")
library(stringr)
library(readxl) 

# Excel-Datei einlesen 
titanic <- read.csv("https://raw.githubusercontent.com/SomeGuy-J/AufgabeWisArb/refs/heads/main/titanic.csv")

##erstelle neue variable mit Anrede
# Extrahiere das Wort nach dem Komma für alle 1000+ Einträge

Anrede <- sub("^.*?,\\s(\\w+).*", "\\1", titanic$Name)


## Kodiere Variablen Survived, Sex, Embarked als Faktor um

titanic$Survived <- as.factor(titanic$Survived)
titanic$Sex <- as.factor(titanic$Sex)
titanic$Embarked <- as.factor(titanic$Embarked)

# Umwandlung der Variable 'Pclass' in einen geordneten Faktor
titanic$Pclass <- factor(titanic$Pclass, levels = c(1, 2, 3), ordered = TRUE)

# Ersetze NA's aus Alter mit Mittelwert
titanic$Age[is.na(titanic$Age)] <- mean(titanic$Age, na.rm = T)

# Erstellung neuer Variablen für Backbord/ Steuerbord, Deck und NA
cabin <- gsub("[A-Z]", "", titanic$Cabin) # Entferne Buchstaben aus der Spalte Cabin

cabin1 <- strsplit(cabin[cabin != ""], " ") # Lasse die leeren Zeilen zur Seite und splitte die Zeilen mit mehreren Einträgen auf

cabin1 <- lapply(cabin1, as.numeric) # In numeric umwandeln

cabin1 <- lapply(cabin1, function(x) ifelse(x %% 2 == 1, "Steuerbord", "Backbord")) # Ungeraden Zahlen <- "Steuerbord", sonst <- "Bacbord"

cabin2 <- sapply(cabin1, paste, collapse = " ") # Liste zu Vektor

cabin[cabin != ""] <- cabin2 # Ersetze betroffenen Zeilen

cabin[cabin == ""] <- NA # Ersetze leere Zeilen durch NA

titanic$Kabinentyp <- cabin # Setze im Datensatz ein

titanic$Deck <- gsub("[0-9]", "", titanic$Cabin) # Entferne die Zahlen aus $Cabin

titanic$Deck[titanic$Deck == ""] <- NA # Leere Zeilen zu NA

# Entfernung unnötiger Variablen
titanic <- titanic[, !names(titanic) %in% c("PassengerId", "Name", "Ticket", "Cabin")]
