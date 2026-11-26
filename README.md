# exchange_app — Ejercicio 3.3 (Dio + Riverpod)

```bash
flutter create .   # solo si faltan android/ios
flutter pub get
flutter run
```
Android: asegúrate de tener el permiso INTERNET en `android/app/src/main/AndroidManifest.xml`
(`<uses-permission android:name="android.permission.INTERNET"/>`; flutter create ya lo incluye en debug/profile).

## Prueba de errores
| Escenario | Cómo simularlo | Excepción |
|---|---|---|
| Timeout | Red muy lenta / bajar `connectTimeout` a 1 ms | NetworkException |
| Sin conexión | Modo avión | NetworkException |
| 404 | `getLatest(base: 'XYZ')` | NotFoundException |
| 500 | baseUrl a un endpoint roto | ServerException |
