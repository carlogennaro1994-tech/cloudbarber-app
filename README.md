# CloudBarber

CloudBarber è una applicazione Flutter per la gestione di prenotazioni e servizi di un barber shop, costruita con Riverpod, GoRouter e un'architettura a feature modulari.

## Stato del progetto

- **UI base pronta**: schermate di login/registrazione, lista prenotazioni, dettaglio prenotazione, creazione nuova prenotazione, catalogo servizi e profilo sono prototipi funzionanti con mock data.
- **Architettura modulare**: cartelle `features/*` organizzate per dominio (auth, booking, profile) con layer `data`, `domain` e `presentation` già predisposti.
- **Dipendenze e DI**: Riverpod per lo stato, GoRouter per la navigazione, GetIt per l'iniezione (vedi `lib/core/injection_container.dart`).
- **Localizzazione**: inglese e italiano pronti tramite `flutter gen-l10n` con file `.arb` in `lib/l10n/`.
- **API client**: interfacce Retrofit/Dio predisposte per l'integrazione con backend ma ancora senza endpoint reali o gestione token.

## Come eseguire

1. Installa le dipendenze:
   ```bash
   flutter pub get
   ```
2. Genera il codice (se usi freezed/json_serializable):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. Genera le traduzioni:
   ```bash
   flutter gen-l10n
   ```
4. Avvia l'app:
   ```bash
   flutter run
   ```

## Prossimi passi raccomandati

- **Autenticazione reale**: collegare le schermate di login/registrazione ai repository/auth API e gestire persistenza/refresh del token.
- **Gestione dati booking**: sostituire i mock con chiamate reali per servizi, slot e prenotazioni; aggiungere stato di caricamento/errore nelle pagine di lista e dettaglio.
- **Validazioni e UX**: introdurre validazioni lato dominio per prenotazioni (orari futuri, conflitti, durate) e messaggi di errore tradotti.
- **Notifiche**: integrare notifiche push/email per conferme, cancellazioni e promemoria.
- **Testing**: aggiungere unit/widget test per use case e UI principali; configurare pipeline CI per analisi statiche e test.
- **Temi e accessibilità**: rifinire i temi chiaro/scuro, contrasto e supporto screen reader.

## Struttura principale

- `lib/app/`: router e temi globali.
- `lib/core/`: configurazione DI e componenti condivisi.
- `lib/features/`: moduli funzionali organizzati per dominio.
- `assets/`, `ios/`, `android/`, `web/`: risorse e target di piattaforma Flutter standard.

