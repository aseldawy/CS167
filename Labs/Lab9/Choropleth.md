# Choropleth Maps
This page explains how to generate a choropleth map using QGIS.

## Prerequisites
 - Download [QGIS](https://qgis.org/en/site/) for free.
 - Download the [countries dataset](https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip). No need to decompress the file.

## Steps
1. Open QGIS and drag-and-drop the downloaded file on it. Choose the `.shp` file from the list of files.

![Choose the .shp file](images/QGIS-choose-layer.png)

![QGIS visualized countries](images/QGIS-countries.png)

2. Double-click on the layer name in the Layers list. From the "Properties" dialog, choose the "Symbology" tab on the left.

![QGIS Layer Properties](images/QGIS-Layer-properties.png)

3. From the drop-down menu at the top, choose "Graduated".

![QGIS Graduated](images/QGIS-Graduated.png)

4. Choose the attribute you want to color by. In this example, choose `POP_EST` which indicates the estimated population.

![QGIS POP EST](images/QGIS-POP_EST.png)

5. Click the `Classify` button to create the classes.

![img.png](images/QGIS-Classify.png)

6. Click `OK` to close the window and apply the changes.

![QGIS Countries Choropleth](images/QGIS-Countries-choropleth.png)

7. To explore a different way of creating classes, go back to the `Layer Properties` dialog and change the mode to `Natural Breaks (Jenks)` and increase the number of classes to 7.

![Change mode to natural breaks (Jenks)](images/QGIS-Mode-Natural-Breaks.png)

![Increase number of classes to 7](images/QGIS-Number-of-classes.png)

8. The output will now look as follows. Notice the different ranges on the left.
![QGIS choropleth of countries with natural breaks](images/QGIS-Countries-Natural-Breaks.png)