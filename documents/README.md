## the changes in SynPDF

1. [handle EMR_SelectClipPath record](#1handle-emr_selectclippath-record)

2. [add decimals accurency into TPdfReal](#2add-decimals-accurency-into-tpdfreal)

3. [adding posibility to draw Texture/Pattern from Metafile](#3adding-posibility-to-draw-texturepattern-from-metafile)

4. [added an option of opacity (both for filling shape and for pattern/textures)](#4added-an-option-of-opacity-both-for-filling-shape-and-for-patterntextures)

5. Fixed EMR_INTERSECTCLIPRECT

6. [adding posibility to draw Pattern directly into TPDFDocument.Canvas](#6-adding-posibility-to-draw-pattern-directly-into-tpdfdocumentcanvas)

#### 1.handle EMR_SelectClipPath record



![before handling EMR_SelectClipPath record](https://user-images.githubusercontent.com/3242659/54346352-30631b80-4645-11e9-9cec-d23592e7d01e.png)
![after handling EMR_SelectClipPath record](https://user-images.githubusercontent.com/3242659/54346967-47563d80-4646-11e9-94a4-370ecef90722.png)



#### 2.add decimals accurency into TPdfReal



#### 3.adding posibility to draw Texture/Pattern from Metafile 
Metafile GDIcomments contains information about texturebrush 

using pattern/texture in pdf is convenient from several reason
* **better quality**
* **less memory(as wmf, so pdf)**
* **less time consumption**

*in the sample the used texture bitmaps have dimensions 62x62, 64x1 and 1x125*


![PdfWithPattern](https://user-images.githubusercontent.com/3242659/54348957-87b7ba80-464a-11e9-84f3-fb704d651b10.png)
![PDFWithoutPattern](https://user-images.githubusercontent.com/3242659/54348959-87b7ba80-464a-11e9-9561-c7711b18a8a6.png)

comparission of pdf with pattern/texture objects and without them
![comparissionUsepattern](https://user-images.githubusercontent.com/3242659/54348958-87b7ba80-464a-11e9-93a0-7860e7f282ed.png)

#### 4.added an option of opacity (both for filling shape and for pattern/textures)
Opacity value can be set  in rendered metafile either as separate GDI comment   
in the form :  
  pgcOpacity(1byte)'SO'(2bytes) opacity value(single=4bytes)  
or   
  as a part of GDI comment for fill by pattern/texture  

opacity value can be used in direct drawing into TPDFCanvas as well  
>doc.canvas.opacity := 0.5;  
>doc.canvas.useOpacity:= true;  
>doc.canvas.rectangle(20,20,500,500);  
>doc.canvas.fill;  

![opacity](https://user-images.githubusercontent.com/3242659/56849597-d2d61600-68f6-11e9-8f11-152b8529aede.png)


#### 6. adding posibility to draw Pattern directly into TPDFDocument.Canvas
![DrawPatternDirectly](https://user-images.githubusercontent.com/3242659/57484818-4fc79f00-72aa-11e9-91e9-87e8d14491ac.png)

example [DrawPatternDirectly.pdf](https://github.com/Eva-F/SynPDF/blob/Eva-F-texture-pattern/documents/DrawPatternDirectly.pdf)
(wrong displayed in Git; You need to link to the raw version. So on the resulting page, context click the Raw button)
