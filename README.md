SynPDF
======

#### add the implementation of texture brush from a metafile.
###### *short remark:*
* *In my project I have to generate and include into pdf many pictures (from ten to hundreds - depends on customer design) and the pictures have to be very readable and illustrative and of course the smallest as possible. Therefore I use texture brush for drawing them. (f.e. brush n x 1 pixels).The drawing picture is stored as metafile (.wmf), that can be rendered into pdf.*
*But a recognization of texture brush bitmap from metafile is difficult and time/memory consuming because rounding color leads to similiar (but not equal) bitmaps.*
* *Therefore I decided to such step: instead of real texture brush to use dummy brush of 1x1 pixel(to minimalize wmf metafile itself) and add into GDI comments information about bitmap, that will be used as texture brush for filling shapes right in pdf*
* *Pdf has the tools for texture/pattern brush - there are Pattern and XObject/Form*

There are two types of texturebrush information in GDI comment:
1. has to be added into comment before using of render bitmap and contains TextureBMP unique ID and Bitmap data in the form:
```
     pgcTextureBitmap      1byte 
     'SI'                  2bytes
     TextureBMPUniqueID    2bytes
     bitmap data 
```     
2. has to be added into GDI comment before each using of dummy brush(1x1) and contains instruction how to transform texture brush for filling next shape
```
     pgcTextureID         1byte    or pgcPatternID
     'ST'                 2bytes   or 'SP'
     TextureBMPUniqueID   2bytes 
     TilesPerX            2bytes
     TilesPerY            2bytes
     WrapMode             2bytes
     ScaleX               4bytes  (single)
     ScaleY               4bytes  (single)
     Angle                4bytes  (single) - in degrees
```     

there are distinguished two kind of brush pgcTextureID - (defines something like stamp - for accurate filling) and pgcPatternID for standard brush 

in the pdf is possible to handle brush by these way:
1. pgcTextureID into XObject Form
2. pgcPatternID into Pattern (dimensionless)
3. pgcPatternID into Pattern (dimensionless) and on its base register XObject Form (this way is convenient for filling of  rotated shapes


example of pdf:

 **Page Resources**
 ```
 Resources<</Font<<>>
           /XObject<</SynImg0 6 0 R/SynT_0 7 0 R/SynImg2 8 0 R/SynT_2 10 0 R>>
           /Pattern<</SynPat_1 9 0 R>>
           /ProcSet\[/PDF/Text/ImageC\]>>/Contents 5 0 R>>
 ``` 
  **1. pgcTextureID /SynT_0 7 0 R**
  ```
           7 0 obj
           <</Length 479/Type/XObject/Subtype/Form/BBox\[-496 -496 1302 1178\]/Matrix \[1 0 0 1 0 0\]
             /Resources<</Font<<>>/ProcSet\[/PDF/Text/ImageC\]
             /XObject<</SynImg0 6 0 R>>>>/Name/SynT_0>>
           stream
           q
           2.419135 0.000000 0.000000 -2.365376 0.000000 7.096128 cm
           *TilesPerX x TilesPerY times*
           /SynImg0 Do
           ...
           endstream
           endobj
```           
  *where SynImg0 is TextureBitmap registered as PdfImage*
  
  **XObject Image /SynImg0 6 0 obj**
  ```
            6 0 obj
            <</Length 11532/Type/XObject/Subtype/Image/ColorSpace/DeviceRGB/Width 62/Height 62/BitsPerComponent 8
              /Name/SynImg0>>
            stream
            ... Bitmap data
            endstream
            endobj
  ```
  **2.pgcPatternID  /SynPat_1 9 0 R**
  ```
             9 0 obj
             <</Length 131/Type/Pattern/PaintType 1/PatternType 1/TilingType 1
             /XStep 46.715023/YStep 3.397456/BBox\[0.000 0.000 46.715023 3.397456\]
             /Resources<</ProcSet\[/PDF/Text/ImageB\]
             /XObject<</SynImg2 8 0 R>>
             /ColorSpace<</CS1\[/Pattern/DeviceRGB\]>>>>/Name/SynPat_1>>
             stream
             q
             ... Pdf scale Transform cm
             ... Pattern scale +FlipY Transform cm
             /SynImg2 Do
              Q
              endstream
              endobj
```              
  *where SynImg2 is TextureBitmap registered as PdfImage*
  
  **XObject Image /SynImg2 8 0 obj**
  ```
              8 0 obj
              <</Length 375/Type/XObject/Subtype/Image/ColorSpace/DeviceRGB/Width 1/Height 125/BitsPerComponent 8
              /Name/SynImg2>>
  ```
  **3.Texture defined on the base of dimensionless Pattern /SynT_2 10 0 R**
```
              10 0 obj
              <</Length 128/Type/XObject/Subtype/Form
              /BBox\[-49 -49 144 101\]/Matrix \[1 0 0 1 0 0\]
              /Resources<</Font<<>>/ProcSet\[/PDF/Text/ImageC\]
              /Pattern<</SynPat_1 9 0 R>>>>/Name/SynT_2>>
              stream
              q
              ... pdf Scale Transform cm
              /Pattern cs
              /SynPat_1 scn
              0.000000 0.000000 5.992000 5.992000 re
              f
              Q
              endstream
              endobj
  ```
  
  #### **usage defined brushes in content stream**
  **1. pgcTextureID /SynT_0 7 0 R**
  ```
               q
               n
               ...Scale + Translate transform cm
               /SynT_0 Do
               f
               Q
```               
  **2.pgcPatternID  /SynPat_1 9 0 R**               
  ```
               q
               n
               ...transform  cm
               /Pattern cs
               /SynPat_1 scn
               0.000000 0.000000 5.992000 5.992000 re     (or path)
               f
               Q
```               
  **3.Texture defined on the base of dimensionless Pattern /SynT_2 10 0 R**
  ```
               q
               n
               ...Rotation + translate Transform  cm
               /SynT_2 Do
               f
               Q
```


