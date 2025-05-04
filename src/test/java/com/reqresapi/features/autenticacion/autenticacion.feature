Feature: Authentication operations at ReqRes API

  Background:
    * url ulrBase
    * def registerData = testData.registrarUsuario
    * def loginData = testData.loginUser
    * def invalidUserData = testData.usuarioInvalido
    * def randomEmail = obtenerCorreoRandom()
    * header x-api-key = apiKey

  Scenario: Registra un nuevo usuario
    Given path '/register'
    And request registerData
    When method POST
    Then status 200
    And match response contains { token: '#notnull' }
    And match response.id == '#number'
    * def authToken = response.token
    * print 'Registro exitoso. Token: ', authToken

  Scenario: Intenta registrar un usuario sin contraseña
    Given path '/register'
    And request { email: randomEmail }
    When method POST
    Then status 400
    And match response.error == 'Missing password'

  Scenario: Autenticación exitosa
    Given path '/login'
    And request loginData
    When method POST
    Then status 200
    And match response contains { token: '#notnull' }
    * def authToken = response.token
    * print 'Login exitoso. Token: ', authToken

  Scenario: Autenticación con credenciales invalidas
    Given path '/login'
    And request invalidUserData
    When method POST
    Then status 400
    And match response.error == 'user not found'

  Scenario: Autenticación sin contraseña
    Given path '/login'
    And request { email: randomEmail }
    When method POST
    Then status 400
    And match response.error == 'Missing password'

  Scenario: Respuesta retrasada para el login
    Given path '/login'
    And request loginData
    And param delay = 3
    When method POST
    Then status 200
    And match response contains { token: '#notnull' }