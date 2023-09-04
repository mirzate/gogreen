# gogreen

## Seeded users data (username/pass) for testing>

admin / test    (pripada super-admin roli)
desktop / test  (type: uposlenik opstine)

sarajevo / test
tuzla / test
mostar / test

### RUN APP

KEYS !!!

Kreirati: api_keys.properties file na root-u projekta i u njega unjeti values za google maps: 

GOOGLE_MAPS_API_KEY=XXX

# Desktop App - in case that is backend local
flutter run -d windows --dart-define=baseURL=https://localhost:7125/api/

# Desktop App - in case that is backend on Docker
flutter run -d windows --dart-define=baseURL=http://localhost:8080/api/

## Mob App
flutter run --dart-define=baseURL=http://10.0.2.2:8080/api/


### Maintenance APP

flutter clean

flutter pub run build_runner build --delete-conflicting-outputs

flutter pub run build_runner watch --delete-conflicting-outputs


