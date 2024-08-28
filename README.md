## RESULTS API

Eres un ingeniero de BUK en una misión. Usando una API de resultados de evaluaciones, tu trabajo es calcular los
resultados finales de la evaluación. Estos se dividen en tres tipos de resultados:

- Resultado general de la evaluación (promedio simple de los resultados por participante)
- Resultado por participante (promedio ponderado de los resultados por tipo de evaluación de cada participante)
- Resultado por tipo de evaluación por participante (promedio simple de los resultados de cada tipo de evaluador por
  participante)


Una evaluación de desempeño en BUK tiene como nota máxima *5*, y se compone de distintos tipos de evaluación:
- Descendente
- Ascendente
- Paralela
- Autoevaluación

Los usuarios de nuestro módulo pueden elegir cuáles tipos usar por evaluación, y el peso que cada tipo de evaluación
tendrá. También pueden elegir cuantos evaluadores por tipo son permitidos. Un ejemplo de configuración podría ser:

- 1 Evaluador descendente máximo, con peso 50%
- 2 evaluadores paralelos máximos, con peso 20%
- 3 evaluadores ascendentes máximos, con peso 20%
- 1 autoevaluación, con peso 10%

Idealmente, todos los evaluadores de todos los tipos contestarían la evaluación. En la práctica, sin embargo, no es así.
Si un participante no tiene evaluaciones contestadas de un tipo de evaluación, el peso de este tipo de evaluación *NO* 
debería afectar los resultados. Pudes pensar esto como que el peso se reparte entre las demás evaluaciones de manera
proporcional (no equitativa). Esto es, el resultado final por participante es un promedio ponderado de los resultados
por tipo de evaluación.

Como ejemplo, usando la configuración de ejemplo, si un participante tuvo los siguienets resultados:

- Descendente: 5
- Ascendente: NULL, NULL
- Paralela: 3, 5, NULL
- Autoevaluación: 5

El resultado final del participante debería ser ((5 * 50) + (4 * 20) + (5 * 10)) / (50 + 20 + 10) = *4*


---

La API a la que tienes acceso te devuelve los resultados por participante, paginados. Es decir, con un cliente
instanciado para cierta DB, las respuestas serían:

```ruby
client = ExternalAPI.new("./data/example.json")
client.fetch(2)
# => {"page":1,"results":[{"id":11,"evaluado_id":2,"result":3,"kind":"ascending"},{"id":12,"evaluado
_id":2,"result":2,"kind":"ascending"},{"id":13,"evaluado_id":2,"result":4,"kind":"descending"},
{"id":14,"evaluado_id":2,"result":2,"kind":"descending"},{"id":15,"evaluado_id":2,"result":1,"k
ind":"descending"},{"id":16,"evaluado_id":2,"result":1,"kind":"parallel"},{"id":17,"evaluado_id
":2,"result":3,"kind":"parallel"},{"id":18,"evaluado_id":2,"result":5,"kind":"parallel"},{"id":
19,"evaluado_id":2,"result":4,"kind":"autoevaluation"}]}
```

Esta API te responde con resultados de la forma:

```ruby
# [{id: <id>, evaluado: <id_evaluado>, result: <result>, kind: <kind>}, {id: <id>, evaluado: <id_evaluado>, result: <result>, kind: <kind>}]
```

Donde:
- id Es el identificador del registro
- evaluado_id es el identificador del participante
- result Es el resultado que un evaluador dió al participante
- kind Es el tipo de evaluador que dió ese resultado

Los tipos de evaluador son

```ruby
%i[descending ascending parallel autoevaluation]
```


Para esta prueba, trabajarás con uan evaluación con la siguiente configuración:
```ruby
  EXAMPLE_WEIGHTS = {
    ascending: 20,
    descending: 50,
    autoevaluation: 10,
    parallel: 20,
  }.freeze
  EXAMPLE_MAX_EVALUATORS = {
    ascending: 2,
    descending: 5,
    parallel: 8,
    autoevaluation: 1,
  }.freeze
```

pero deberías manejar evaluaciones con tamaños y pesos arbitrarios.


### Criterios de aceptación

- Desarrollar un servicio que utilice la API de resultados para generar los resultados de una evaluación
- Proponer una estructura o una interfaz de respuestas, tomando en cuenta que este servicio se puede usar para persistir
  estos resultados en una DB, o para enviarlos a otro servicio como JSON
