# FRONTEND PROYECTO UCAB AIR
Esta implementación proporciona una página de inicio de sesión y una aplicación con un menú que muestra elementos según los roles y privilegios de la persona que inicia sesión. El tema de la aplicación es una fábrica de aviones con opciones de compra, venta y fabricación. El menú funciona con href para abrir una nueva página de la carpeta "páginas" cada vez que se elige una opción del menú.

To use this application desde la consola:
1. npm i
2. npm run dev
3. Ingresar a: http://192.168.0.103:8080 o  http://127.0.0.1:8080

Usuarios:
1. Username: admin, Password: admin123
2. Username: manager, Password: manager123
3. Username: worker, Password: worker123

El menú mostrará diferentes opciones según el rol del usuario:

- Administrador: Compras, Ventas, Fabricación
- Gerente: Compras, Ventas
- Trabajador: Fabricación

Cada elemento del menú se vinculará a su página respectiva en la carpeta "páginas".

Recuerde que esta es una implementación solo del lado del cliente con fines de demostración. En un escenario del mundo real, necesitaría implementar la autenticación y autorización adecuadas del lado del servidor para garantizar la seguridad.