Feature: Complete user lifecycle integration flows

  Background:
    * url ulrBase
    * def usuario = { name: 'Ronald Castro', job: 'QA Automation Senior' }
    * def actualizaUsuario = { name: 'Katherine Bedoya', job: 'QA Automation Engineer' }
    * def registrarDatos = testData.registrarUsuario

@IntegracionUsuarios
  Scenario: Flujo completo de toda la gestión de usuarios
  * configure headers = { x-api-key: 'reqres-free-v1' }
    # Paso 1: Obtiene la lista inicial de usuarios para verificar el estado actual
    Given path '/users'
    And param page = 1
    When method GET
    Then status 200
    And match $.page == 1
    * def initialTotalUsers = $.total
    * print 'Initial total users:', initialTotalUsers

    # Step 2: Crea el nuevo usuario
    Given path '/users'
    And request usuario
    When method POST
    Then status 201
    And match $.name == usuario.name
    And match $.job == usuario.job
    * def userId = $.id
    * print 'El usuario fue creado con el ID ', userId

    # Step 3: Simulo consultar el usuario anteriormente creado
    Given path '/users/2'
    When method GET
    Then status 200
    And match $.data.id == 2
    * print response

    # Step 4: Actualiza el usuario
    Given path '/users/' + userId
    And request actualizaUsuario
    When method PATCH
    Then status 200
    And match $.name == actualizaUsuario.name
    And match $.job == actualizaUsuario.job
    And match $.updatedAt == '#string'
    * print 'Usuario actualizado:', response

    # Step 5: Borra el usuario
    Given path '/users/' + userId
    When method DELETE
    Then status 204

    # Paso 6: Verifica que el usuario no exista con un id inexistente
    Given path '/users/21'
    When method GET
    Then status 404

  @IntegracionRecursosAutenticacion
  Scenario: Flujo de autenticación y acceso a recursos
    * configure headers = { x-api-key: 'reqres-free-v1' }
    # Step 1: Registra un nuevo usuario y obtiene el token
    Given path '/register'
    * print registrarDatos
    And request registrarDatos
    When method POST
    Then status 200
    And match response contains { token: '#notnull' }
    * def authToken = $.token
    * print 'Token de registro: ', authToken
    * def email = registrarDatos.email
    * def password = registrarDatos.password

    # Step 2: Autenticación
    Given path '/login'
    And request
    """
      {
        email: "#(email)",
        password: "#(password)"
      }
    """
    When method POST
    Then status 200
    And match response contains { token: '#notnull' }
    * def loginToken = $.token
    * print 'Token de autenticación ', loginToken

    # Step 3: Accede a los recursos con autenticación
    Given path '/unknown'
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    And match $.data == '#array'
    And match $.data[*].id contains '#number'
    * def resourceId = $.data[0].id
    * print response

    # Step 4: Accede a un recurso especifico
    Given path '/unknown/' + resourceId
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    And match $.data.id == resourceId
    And match $.data.name == '#string'
    And match $.data.year == '#number'
    And match $.data.color == '#string'
    And match $.data.pantone_value == '#string'
    * print response

  @IntegracionUsuariosyPaginacion
  Scenario: Crea múltiples usuarios y verifica la paginación
    * configure headers = { x-api-key: 'reqres-free-v1' }
    # Step 1: Crea un primer usuario
    Given path '/users'
    And request { name: 'Diana Maria', job: 'QA 1' }
    When method POST
    Then status 201
    * def userId1 = $.id

    # Step 2: Crea un segundo usuario
    Given path '/users'
    And request { name: 'Maria Isabel', job: 'QA 2' }
    When method POST
    Then status 201
    * def userId2 = $.id

    # Step 3: Crea un tercer usuario
    Given path '/users'
    And request { name: 'Angela', job: 'PM' }
    When method POST
    Then status 201
    * def userId3 = $.id

    # Step 4: Obtiene los usuarios por paginación en este caso la página 1
    Given path '/users'
    And param page = 1
    When method GET
    Then status 200
    And match $.page == 1
    And match $.per_page == 6
    And match $.data == '#[response.per_page]'
    * print 'Users on page 1:', response.data.length
    * print response

    # Step 5: Obtiene los usuarios por paginación en este caso la página 2
    Given path '/users'
    And param page = 2
    When method GET
    Then status 200
    And match $.page == 2
    And match $.data == '#array'
    * print 'Users on page 2:', response.data.length
    * print response