# Sistema de Supresión de Ruido de Red Eléctrica

> Presente su reporte aquí

1.	¿Cuál es la frecuencia de muestreo con que fue tomada la señal?

48 kHz:
```
>> audioinfo('la_muerte_del_angel_power_noise.wav')
ans =

  scalar structure containing the fields:

    Filename = D:\Users\Chris Russell\Dropbox\TEC\Courses\Procesamiento Digital de Señales\Tarea 5\dsp-3-2022-tarea5-crussel-t
ec\la_muerte_del_angel_power_noise.wav
    CompressionMethod =
    NumChannels = 1
    SampleRate = 48000
    TotalSamples = 963584
    Duration = 20.075
    BitsPerSample = 16
    BitRate = -1
    Title =
    Artist =
    Comment =
```

2.	Utilice la DFT para desplegar el contenido espectral de la señal en su totalidad. Asegúrese que el eje x de los gráficos tenga las unidades apropiadas en frecuencia (Hz).

!(figure1.png)

3.	Identifique en el espectro las componentes de frecuencia causadas por la línea de poder de 60Hz, así como sus posibles armónicos. Para ello, realice una ampliación del espectro en la región de interés pero asegúrese que las unidades se mantengan correctas.

!(figure2.png)

La señal muestra corrupción principalmente por los armónicos 1 a 6 del ruido de 60 Hz, y armónicos impares adicionales más allá de eso hasta aproximadamente el armónico 13.

4.	Presente la Transformada Discreta de Fourier de Corto Plazo para 4 ventanas distintas de mucho menor tamaño. Identifique las mismas componentes parasitas en dichos espectros.

!(figure3.png)
!(figure4.png)
!(figure5.png)
!(figure6.png)

5.	Proponga un sistema IIR que suprima las componentes de ruido de 60Hz y sus armónicos. Presente su función de transferencia así como su ecuación de diferencias y su diagrama de polos y ceros.

Para suprimir por completo el componente de 60 Hz, se necesita un cero en el círculo unitario. El uso de un par conjugado permite coeficientes de filtro reales:
!(eq1.png)
Para agudizar la respuesta, se puede poner un par de polos conjugados cerca a los polos pero dentro del círculo unitario para evitar la inestabilidad:
!(eq2.png)
La función de transferencia será:
!(eq3.png)
Dado que f=60Hz y T=1/48000s:
!(eq4.png)
La ecuación en diferencia es:
!(eq5.png)
El número de decimales es importante, ya que la frecuencia de filtrado deseada es muy pequeña en comparación con la frecuencia de muestreo, por lo que es necesaria la precisión.
Generalizando para los primeros N armónicos, la función de transferencia será:
!(eq6.png)
En teoría, los 13 o más armónicos significativos se suprimirían calculando la función de transferencia anterior para N=13 y expandiendo los coeficientes. En la práctica, la estabilidad numérica es difícil de lograr en Octave con una cantidad tan grande de polos y ceros cerca del círculo unitario.
Para mayor estabilidad, se utilizan dos pasos de filtro de 8 polos. En el direccionamiento de los armónicos impares del 1 al 7, y el otro para los armónicos pares del 2 al 8.
Para el filtro impar:
!(eq7.png)
!(figure7.png)
Para el filtro par:
!(eq8.png)
!(figure8.png)

6.	Despliegue su respuesta en frecuencia. Para ello utilice alguna herramienta como freqz. Asegúrese que el eje x tenga unidades de Hz.

!(figure9.png)
!(figure10.png)

7.	Filtre la señal contaminada utilizando alguna herramienta como filter. No implemente el filtrado manualmente mediante la convolución.

!(figure11.png)
!(figure12.png)

8.	Presente conclusiones (cualitativas) sobre el resultado obtenido. Procure compararlo con la señal de referencia. Si el prototipo no fue satisfactorio, presente un análisis donde detalle las posibles causas.

El audio filtrado muestra una clara reducción en el nivel de ruido, con un ligero remanente audible. Esto está respaldado por los gráficos espectrales, en el gráfico semilogarítmico todavía se ven picos leves. Los ceros adicionales para ensanchar las muescas pueden reducir aún más este ruido.
También hay una atenuación significativa en las regiones de frecuencia más baja adyacentes a las frecuencias de muesca. Esto podría compensarse con polos adicionales en estas áreas para mejorar la nitidez de las muescas, o aplicando un filtro de paso bajo para suprimir igualmente las frecuencias altas y luego amplificando todas las frecuencias para compensar.