# Countries App - iOS
Aplicación iOS con consumo de información a través de archivos JSON

## Descripción
Aplicación iOS desarrollada con Swift que implementa navegación mediante `Tab Bar Controller` con dos secciones principales: <em>Countries</em> y <em>Currency</em>.

En la sección <em>Countries</em>, se muestra una lista de países utilizando una `UICollectionView`, donde se presentan el nombre y la bandera de cada uno. Al seleccionar un país, se navega a una pantalla de detalle que muestra información relevante como:

- Nombre del país

- Bandera

- Capital

- Idioma

- Moneda

- Estados

Los estados se presentan en una `UITableView`, permitiendo navegar hacia una vista adicional donde se muestran lugares de interés correspondientes a cada estado.

En la sección <em>Currency</em>, el usuario puede seleccionar dos monedas mediante `UIPickerView` y convertir un monto ingresado en un `UITextField`.

## Tecnologías Utilizadas

- Swift

- UIKit

- UICollectionView

- UITableView

- UIPickerView

- UINavigationController

- TabBarController

## Funcionalidades
- Navegación jerárquica entre múltiples pantallas

- Uso de Collection View y Table View

- Manejo de Picker View

- Conversión básica de monedas

- Organización estructurada de vistas
