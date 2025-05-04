
Feature: Administración de usuarios desde el API pública de ReqRes

  Background:
    * url ulrBase
    * def testUser = testData.nuevoUsuario
    * def updateTestUser = testData.actualizarUsuario
    * def userSchema = read('esquemasUsuarios.json')
    * header x-api-key = 'reqres-free-v1'

  @ObtenerUsuarios @Regresion
  Scenario: Obtener lista de usuarios por paginación
    Given path '/users'
    And param page = 1
    When method GET
    Then status 200
    And match response.page == 1
    And match response.per_page == 6
    And match response.total == '#number'
    And match response.total_pages == '#number'
    And match response.data == '#array'
    And match each response.data contains { id: '#number', email: '#regex .+@.+..+' }
    And match response.data[0].id == '#number'
    * print response

  @CrearUsuario @Regresion
  Scenario: Crear un nuevo usuario
    * def nombre = "Agustin Castro"
    * def cargo = "QA Automation"
    Given path '/users'
    And request
    """
    {
      name: "#(nombre)",
      job: "#(cargo)"
    }
    """
    When method POST
    Then status 201
    And match $.name == nombre
    And match $.job == cargo
    And match $.id == '#string'
    And match $.createdAt == '#string'
    * def userId = response.id
    * print 'Se creo el usuario con el id:', userId
    * print response

  @ObtenerUsuarioPorID
  Scenario: Obtiene un usuario por ID
    Given path '/users/2'
    When method GET
    Then status 200
    And match response.data contains { id: 2 }
    And match response.data.first_name == '#string'
    And match response.data.last_name == '#string'
    And match response.data.email == '#regex .+@.+..+'
    And match response.data.avatar == '#string'
    And match response == '#object'
    And match response == userSchema.singleUser
    * print response