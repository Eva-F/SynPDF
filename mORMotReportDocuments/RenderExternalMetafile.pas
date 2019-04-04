const PDFdpi = 72;

procedure TForm1.CreateStyle(aGDIPages : TGDIPages);
var lDarkBlue,lLightBlue : TColor;
begin
  lDarkBlue := $591E0F;
  lLightBlue :=$DE9C01;
  with lGDIPages do
  begin
    Font.Name := 'Arial';
    Font.Size := 24;
    textAlign := taCenter;
    FontColor := lDarkBlue;
    Font.Style := [fsBold];
    addStyle('Caption');
    Font.Name := 'Arial';
    Font.Size := 10;
    textAlign := taRight;
    VerticalTextAlign := tvaBaseLine; 
    FontColor := clBlack;
    Font.Style := [];
    addStyle('Label');
    //...
    Font.Name := 'WingDings';
    Font.Size := 10;
    textAlign := taCenter;
    VerticalTextAlign := tvaMiddle;
    FontColor := lDarkBlue;
    Font.Style := [];
    addStyle('Bullet');
  end;  
end;

procedure  TForm1.AddMetafile(lGDIPages: TGDIPages; aMetafile: SynUnicode);
var n,t,l,b,r : integer;
    lMetafileExternal : TMetaFileExternal;
begin
  with lGDIPages do
  begin
    if (aMetafile <> '')  and FileExists(aMetafile) then
    begin
      // put image on current page
      n :=high(pages);
      setLength(pages[n].metafiles,Length(pages[n].metafiles)+1);
      lMetafileExternal.MetafileName := aMetafile;
      t := MmToPrinterPxY(CurrentYPos);
      b := fPhysicalSizePx.y - fPageMarginsPx.bottom - fFooterHeight;
      l := fPageMarginsPx.left;
      rx :=  fPhysicalSizePx.X - fPageMarginsPx.right;
      lMetafileExternal.Bound := Rect(l,t,r,b);
      pages[n].metafiles[high(pages[n].metafiles)] := lMetafileExternal;
    end;
  end;
end;

procedure TForm1.RenderMetafileEvt(Sender:TObject;aMetaFileExt: TMetaFileExternal; aCanvas: TPdfCanvas );
var lS:TFileStream;
    lMetaFile:TMetaFile;
    lPdfSize : TPoint;
    lRotate : boolean;
    lscPx,lScale,lx,ly : single;
    lR :TRect;

function getBoundRect(pM:HENHMETAFILE ):TRect;
var buf: TEnhMetaHeader;
begin
    GetEnhMetaFileHeader(pM, sizeof(TEnhMetaHeader), @buf);
    Result := buf.rclBounds;
end;

begin
  if not FileExists(aMetaFileExt.MetafileName ) then
    exit;
  try
    with  TMyGDIPages(Sender) do
    begin
      lS := TFileStream.Create(aMetaFileExt.MetafileName, fmOpenRead or fmShareDenyNone);
      lMetaFile := TMetaFile.create;
      if lMetafile.CanLoadFromStream(lS) then
      begin
        lMetafile.LoadFromStream(lS);
        lR := getBoundRect( lMetafile.handle);
        lScPx := screen.pixelsperinch  / (fPrinterPxPerInch.x) ;
        // my Flag for rotate image        
        lRotate :=  StartsText('90_',aMetaFileExt.MetafileName);
        // or f.e.  
        // lRotate :=  ((lR.Bottom-lR.Top) > (lR.Right-lR.Left)) and
        //             ((aMetaFileExt.Bound.Bottom-aMetaFileExt.Bound.Top) < (aMetaFileExt.Bound.Right-aMetaFileExt.Bound.Left)) ;
        
        if lRotate then
           lScale := Math.min( (aMetaFileExt.Bound.Right- aMetaFileExt.Bound.Left)  / (lR.Bottom-lR.Top),
                               (aMetaFileExt.Bound.Bottom- aMetaFileExt.Bound.Top)   /(lR.Right-lR.Left) )*lscPx        
        else
          lScale := Math.min( (aMetaFileExt.Bound.Right- aMetaFileExt.Bound.Left)  / (lR.Right-lR.Left),
                              (aMetaFileExt.Bound.Bottom- aMetaFileExt.Bound.Top)   / (lR.Bottom-lR.Top))*lscPx;
        lX :=PDFdpi * (aMetaFileExt.Bound.Left) / fPrinterPxPerInch.x;
        lY :=PDFdpi * (aMetaFileExt.Bound.Top) / fPrinterPxPerInch.y ;
        if lRotate then  (landscape - about -90 deg)
        begin
          aCanvas.GSave;
          aCanvas.ConcatToCTM(cos(-PI/2),sin(-PI/2),-sin(-PI/2),cos(-PI/2), 
                              lx - (PDFdpi*TMyGDIPages(Sender).fPhysicalSizePx.y/TMyGDIPages(Sender).fPrinterPxPerInch.x - PDFdpi/screen.pixelsperinch*lScale*(lR.Bottom-lR.Top)),
                              PDFdpi*(TMyGDIPages(Sender).fPhysicalSizePx.y )/TMyGDIPages(Sender).fPrinterPxPerInch.x - lY, 6);                            
          aCanvas.RenderMetaFile(lMetaFile,lScale,lScale);
          aCanvas.GRestore;
        end
        else
          aCanvas.RenderMetaFile(lMetaFile,lScale,lScale,lx,ly);
     end;
  end;
  finally
    lMetaFile.free;
    lS.free;
  end;
end;


procedure  TForm1.generatePDF(aPdfName:RawUTF8);
var  lGDIPages : TGDIPages;
begin
  lGDIPages := TGDIPages.create(Self) 
  with lGDIPages do
  begin
     CreateStyle(lGDIPages);
     BeginDoc;
     OnRenderMetafile:=RenderMetafileEvt;
     //...put some texts 
     AddMetafile(lGDIPages,'someMetafile.wmf');
     //...put some next texts 
     AddMetafile(lGDIPages,'90_someMetafile.wmf');
     ExportPDF(aPdfName,true,false); 
  end;
