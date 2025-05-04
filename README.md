# Desafio técnico API

## Decripción y contexto
 
---  
Automatización de pruebas a nivel de API con [Karate DSL](https://www.karatelabs.io/), java, escenarios con Gherkin, 
integración del reporte de Cucumber y con el API pública brindada por el sitio [REQRES](https://reqres.in/)

### Librerías

---
Requisitos para ejecutar **[JDK 21.0.3](https://www.oracle.com/co/java/technologies/downloads/#java21)** y **[gradle 8.7](https://gradle.org/install/)** o superior

Versiones de las bibliotecas con las que la automatización es estable:

+ JUnit 1.4.1

+ CucumberReporting 5.8.4

+ LogBack 1.5.18

#### Ejemplo de comando de ejecución:

Para ejecutar por un tag específico:

```./gradlew test -Dkarate.options="--tags @CrearUsuario".```

Para ejecutar todas las pruebas:

```./gradlew test```

Para ejecutar un feature:

```./gradlew test -Dkarate.options="classpath:com/reqresapi/features/autenticacion/autenticacion.feature```

Para ejecutar en un entorno específico:

```./gradlew test -Dkarate.env=qa```


---  

## Reportes

+ Ante una ejecución los archivos que generan el reporte de Cucumber se crean en la 
carpeta /target, se genera un paquete cucumber-html-reports y desde allí se puede acceder a 
varios .html para visualizar los resultados


+ En la carpeta build se agregan como tal los reportes generados desde el 
framework Karate DSL como tal.


