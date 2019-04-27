## the changes in mORMotReport



1. [added Vertical align](#1-added-vertical-align)

2. [added Text styles](#2-added-text-styles)

3. [added Line spacing into header/footer](#3-added-line-spacing-into-headerfooter)

4. [added drawing of RoundRectangle](#4-added-drawing-of-roundrectangle)

5. [enhanced Columns work](#5-enhanced-columns-work)  
*each column / column header can has own text style; it is possible to set word wrap for column header*

6. [render external Metafiles directly into PDF](#6-render-external-metafiles-directly-into-pdf)  
*it is not neccessary to render external metafiles twice - once into GDIPages.canvas and second time into Pdf.canvas*

[Images](#sample-images)
  
    
      
      
### 1. added Vertical align

**TVerticalTextAlign** = (tvaTop,tvaMiddle,tvaBottom,tvaBaseLine);

### 2. added text styles

#### text style contains: 
  -    **Name**           = Font.Name      *(SynUnicode)*
  -    **Size**           = Font.Size      *(integer)*
  -    **Color**          = Font.Color     *(TColor)* 
  -    **FontStyle**      = Font.Style     *(array of FontStyle - f.e. [ord(fsBold), ord(fsUnderline)])*   
  -    **TextAlign**     = TextAlign      *(TTextAlign)*
  -    **VerticalAlign** = VerticalAlign  *(TVerticalAlign)*

#### usage: 

  procedure **AddStyle**(aStyleName: RawUTF8);    
  > *AddStyle('Caption')  - adds the new text style (taking from current font and aligning) under the name 'Caption'* 
 
  function **GetStyleIdx**(aStyleName: RawUTF8): integer;
  >  *GetStyleIdx('Caption')  - returns index of 'Caption' text style*  

  procedure **SetStyle**(aStyleName: RawUTF8);    
  > *SetStyle('Caption')  - sets current font and aligning according stored 'Caption' text style*  

  procedure **SetStyle**(aStyleIdx: integer);    
  > *SetStyle(GetStyleIdx('Caption'))  - sets current font and aligning according stored 'Caption' text style*  
 


### 3. added Line spacing into header/footer
 
#### usage: 
  procedure AddTextToHeader(const s: SynUnicode; **aLineSpacing**:TLineSpacing);
  > *AddTextToHeader('sometext',lsOneAndHalf); - one and half spacing in the header*
  
### 4. added drawing of RoundRectangle

#### usage: 
  procedure **DrawRoundBox(left,top,right,bottom: integer; aRadiusX, aRadiusY:integer; aPenWidth : boolean=true)**;
  > *Pen.Width:=10;*  
  > *DrawRoundBox(15, 15, 100, 50, 5, 5, false);*  
  > *draw a rounded box with 10px pen*
  
  
### 5. enhanced Columns work

usefull for tables, label - value styles or unordered/ordered list  

#### usage: 
  
  
  procedure AddColumnHeaders(const headers: array of SynUnicode;  WithBottomGrayLine: boolean=false; BoldFont: boolean=false;
  RowLineHeight: integer=0; flags: integer=0;**style**: integer = -1);
  
  procedure AddColumn(left, right: integer; align: TColAlign; bold: boolean; **style**:integer=-1);
  
  **tables:**  
  
  > *clearColumns;*  
  > *clearHeaders;*  
  > *WordWrapColsHeader := true;*  
  > *AddColumnHeaders(['ID','Description','Qty','Qty/ Unit','Unit','Price/ Unit','Discount', 'Price'],* 
  >                   *False,  false,  0,  0,  getStyleIdx('MaterialListTableHeader') );*  
  > *for i:= 0 to high(lColHeaders) do AddColumn(lPos[i] + Marg.Left,lPos[i] + Marg.Left + lWidths[i] ,lColAligns[i],false,getStyleIdx('MaterialListTable') );*  
  > *for i:= 0 to high(lData) do DrawTextAcrossCols(lData[i],[]);*  

  **label-value style:**  

  > *clearColumns;*  
  > *clearHeaders;*  
  > *AddColumn(Marg.left + aLabelLeft,Marg.left + aLabelRight,caRight,false, getStyleIdx('Label'));*  
  > *AddColumn(Marg.left + aLabelRight + 5,Marg.left + 190,caLeft,false, getStyleIdx('Value'));*  
  > *DrawTextAcrossCols(['SomeLabel','SomeValue'],[]);*  
  
    
  **unordered list:**  
  
  > *clearColumns;*  
  > *clearHeaders;*  
  > *Font.name := 'Wingdings'; Font.Size:= 9;  AddStyle('Bullets');*  
  > *AddColumn(Marg.left + aBulletLeft,Marg.left + aBulletRight,caRight,false, getStyleIdx('Bullets'));*  
  > *AddColumn(Marg.left + aBulletRight + 5,Marg.left + 190,caLeft,false, getStyleIdx('BulletList'));*  
  > *DrawTextAcrossCols(['m','SomeValue'],[]);*  
  
  

### 6. render external Metafiles directly into PDF   

sample in the RenderExternalMetafile.pas  
the option of drawing image as Portrait or Landscape orientation  


### Sample images

![Styles](https://user-images.githubusercontent.com/3242659/55557113-685ffa80-56e9-11e9-8568-8c077f3494d7.png)  

![tables](https://user-images.githubusercontent.com/3242659/55557111-685ffa80-56e9-11e9-9d86-1b2defa7f696.png)  

![lblValue](https://user-images.githubusercontent.com/3242659/55557116-68f89100-56e9-11e9-933f-0a64db765db3.png)  

![UoList](https://user-images.githubusercontent.com/3242659/56846124-364a4e80-68cb-11e9-9a5a-a7b5ddc1cfc2.png)

![Metafile](https://user-images.githubusercontent.com/3242659/55557114-685ffa80-56e9-11e9-8a8d-aa9a9a1d2eea.png)  


