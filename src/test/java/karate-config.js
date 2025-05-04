function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    ulrBase: 'https://reqres.in/api',
    apiKey: 'reqres-free-v1',
    timeoutMs: 5000
  };
  // Base datos de prueba
  config.testData = {
    nuevoUsuario: {
      name: "Ronald Castro",
      job: "QA Automation"
    },
    actualizarUsuario: {
      name: "Ronald Castro",
      job: "Developer"
    },
    registrarUsuario: {
      email: "eve.holt@reqres.in",
      password: "pistol"
    },
    loginUser: {
      email: "eve.holt@reqres.in",
      password: "pistol"
    },
    usuarioInvalido: {
      email: "romeocastro@yopmail.com",
      password: "04052025"
    }
  };

  // Función helper para generar datos aleatorios (para evitar colisiones en pruebas)
  config.obtenerCorreoRandom = function() {
    var timestamp = new Date().getTime();
    return 'user.' + timestamp + '@reqres.test';
  };

  // Configuración según el ambiente
  if (env == 'dev') {
    // Configuración para ambiente dev
    config.logPrettyRequest = true;
    config.logPrettyResponse = true;
  } else if (env == 'qa') {
    // Configuración para ambiente qa
  }

  return config;
}