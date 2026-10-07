# Mi propuesta de videojuego

Eres un taquero mexicano clandestino que anda prófugo haciendo un tour mundial. En cada país vendes tacos con la fauna local (literal, cazas animales de la zona mientras atiendes el puesto). Entre pedir la orden, cazar el ingrediente, cocinar, cobrar y defenderte de los problemas locales (rateros en México, sismos en Japón, balaceras en EE. UU., etc.), tienes que juntar dinero. Cuando juntas suficiente satisfacción de los clientes y dinero, la policía te corre del país por cazar sin licencia y brincas al que sigue. ¿El final? Juntas tanto dinero que te compras una nave espacial y te vas a venderle tacos a los marcianos.

**Mecánica principal:** Preparación y Caza Concurrente. El jugador atiende la cocina del puesto (picar, cocinar y ensamblar tacos) mientras utiliza herramientas para cazar animales en tiempo real dentro del mismo escenario.

**Objetivo del jugador:** Alcanzar un nivel de satisfacción del país actual antes de que expire el tiempo o antes de quedarnos sin carne.

**Reglas básicas:**

**Inventario Cero:** Sin carne recolectada no se pueden preparar tacos; la carne cruda se agota y requiere caza continua.

**Control de Pérdidas:** Cocinar carne en exceso la quema; dejar ir clientes con paciencia en 0 % reduce la satisfacción global.

**Amenazas Directas:** Si no se resuelve la contingencia local (ej. golpear al ladrón o esquivar el sismo), se pierde carne del stock, dinero de la caja, satisfacción global o herramientas de caza.

Se espera o se busca que el jugador sienta una mezcla entre desafío y descubrimiento, y esto lo logramos con la mecánica principal, que es la preparación y la caza concurrente. El usuario debe simultáneamente centrarse en 2 cosas: preparar tacos rápidamente para ganar dinero y satisfacción de los clientes, y cazar animales para conseguir carne para los tacos. Todo esto en un periodo de tiempo o mientras tenga suministros. Esto hace que el jugador sienta cierta tensión, y el descubrimiento se da por el hecho de que los animales encontrados al cazar van a variar dependiendo del país en el que nos encontremos.

Ahora, considerando el diagrama de MDA visto en clase, y con algo de ayuda de ChatGPT para identificar algunos elementos, la relación entre ellos sería la siguiente:

1. Las Reglas, el Espacio de Juego y los Bits/Tokens forman las Mecánicas: Las reglas (satisfacción objetivo, límite de tiempo o stock) establecen cómo interactúan los bits/tokens (carne, puesto, animales) dentro del espacio de juego (pantalla con 2 escenarios, el de venta y el de caza).
2. El Jugador ejecuta las Mecánicas a través de la Interfaz: Cuando el jugador realiza acciones (como cazar o cocinar), las mecánicas modifican el Estado del juego en tiempo real (aumento o disminución de carnes en stock, más dinero, menos carne, más o menos satisfacción global).
3. El Estado se muestra mediante la Visión/Interfaz: La pantalla devuelve feedback inmediato al jugador sobre el nuevo estado del sistema con sus indicadores.
4. Las Mecánicas generan las Dinámicas: El cambio constante de estados fuerza al jugador a adoptar un comportamiento o dinámica (la multitarea extrema y la gestión bajo presión).
5. Las Dinámicas producen la Experiencia de Juego (Estética): La interacción entre la dinámica que vive el jugador y la visión en pantalla genera la emoción (ese desafío y descubrimiento que busco).
