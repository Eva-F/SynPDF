## the changes in SynPDF

#### handle EMR_SelectClipPath record

![before handling EMR_SelectClipPath record](https://user-images.githubusercontent.com/3242659/54346352-30631b80-4645-11e9-9cec-d23592e7d01e.png)
![after handling EMR_SelectClipPath record](https://user-images.githubusercontent.com/3242659/54346967-47563d80-4646-11e9-94a4-370ecef90722.png)

#### add decimals accurency into TPdfReal

#### adding posibility to draw Texture/Pattern from Metafile 
in GDI comments are sending information about texturebrush 

using pattern/texture in pdf is convenient from several reason
* better quality
* less memory(as wmf, so pdf)
* less time consumption
![PdfWithPattern](https://user-images.githubusercontent.com/3242659/54348957-87b7ba80-464a-11e9-84f3-fb704d651b10.png)
![PDFWithoutPattern](https://user-images.githubusercontent.com/3242659/54348959-87b7ba80-464a-11e9-9561-c7711b18a8a6.png)

comparission of pdf with pattern/texture objects and without them
![comparissionUsepattern](https://user-images.githubusercontent.com/3242659/54348958-87b7ba80-464a-11e9-93a0-7860e7f282ed.png)
